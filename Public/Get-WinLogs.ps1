function Get-WinLogs {
    <# =========================================================================
    .SYNOPSIS
        Get Windows Event Viewer logs
    .DESCRIPTION
        This script will query the Windows Event Viewer and provide log details
        based on the criteria provided.
    .PARAMETER List
        List available events
    .PARAMETER Id
        Id of event in EventTable
    .PARAMETER ComputerName
        Hostname of remote system from which to pull logs.
    .PARAMETER Results
        Number of results to return.
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-WinLogs.ps1 -Id 8 -ComputerName $Server -Results 10
        Display last 10 RDP Sessions
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = '__list')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'List available events', ParameterSetName = '__list')]
        [switch] $List,

        [Parameter(Mandatory, HelpMessage = 'Event Table Id', ParameterSetName = '__events')]
        [ValidateScript({ $EventTable.Id -contains $_ })]
        [int] $Id,

        [Parameter(ValueFromPipeline, HelpMessage = 'Hostname of target computer', ParameterSetName = '__events')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Count 1 -Quiet })]
        [Alias('CN')]
        [string] $ComputerName,

        [Parameter(HelpMessage = 'Number of results to return', ParameterSetName = '__events')]
        [ValidateNotNullOrEmpty()]
        [int] $Results = 10
    )

    Process {
        $eventTable = Get-Content -Raw -Path $PSScriptRoot\EventTable.json | ConvertFrom-Json

        switch ($PSCmdlet.ParameterSetName) {
            '__list' {
                $eventTable | Select-Object -Property Id, Name, EventId, Log
            }
            '__events' {
                $eventParams = @{ }

                if ( $PSBoundParameters.ContainsKey('Results') ) { $eventParams['MaxEvents'] = $Results }
                if ( $PSBoundParameters.ContainsKey('ComputerName') ) { $eventParams['ComputerName'] = $ComputerName }

                <# $filterHash = @{
                    ProviderName = $e.Log
                    ID           = $e.EventId
                    LogName      = <String[]>
                    #Path         = <String[]>
                    #Keywords     = <Long[]>
                    #Level        = <Int32[]>
                    #StartTime    = <DateTime>
                    #EndTime      = <DataTime>
                    #UserID       = <SID>
                    #Data         = <String[]>
                } #>

                $e = $eventTable.Where({ $_.Id -eq $Id }) #| Where-Object Id -EQ $Id
                $filterHash = @{ ID = $e.EventId }

                $logNames = @('Application', 'Security', 'Setup', 'System')
                if ( $e.Log -in $logNames ) { $filterHash['LogName'] = $e.Log }
                else { $filterHash['ProviderName'] = $e.Log }

                Get-WinEvent @eventParams -FilterHashtable $filterHash
            }
        }
    }
}