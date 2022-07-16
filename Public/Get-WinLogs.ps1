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
    .PARAMETER StartTime
        Start time for event serach
    .PARAMETER EndTime
        End time for event serach
    .PARAMETER Data
        String to search for in event data
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-WinLogs.ps1 -Id 8 -ComputerName $Server -Results 10
        Display last 10 RDP Sessions
    .NOTES
        Name:     Get-WinLogs
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-07-16
        - 0.1.0 - Initial version
        - 0.1.1 - Added StartTime, EndTime, and Data parameters
        Comments: <Comment(s)>
        General notes
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-winevent
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = '__lst')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'List available events', ParameterSetName = '__lst')]
        [switch] $List,

        [Parameter(Mandatory, HelpMessage = 'Event Table Id', ParameterSetName = '__evt')]
        [ValidateScript({ $EventTable.Id -contains $_ })]
        [int] $Id,

        [Parameter(ValueFromPipeline, HelpMessage = 'Hostname of target computer', ParameterSetName = '__evt')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Count 1 -Quiet })]
        [Alias('CN')]
        [string] $ComputerName,

        [Parameter(HelpMessage = 'Number of results to return', ParameterSetName = '__evt')]
        [ValidateNotNullOrEmpty()]
        [int] $Results = 10,

        [Parameter(HelpMessage = 'Start time for event serach', ParameterSetName = '__evt')]
        [ValidateNotNullOrEmpty()]
        [System.DateTime] $StartTime,

        [Parameter(HelpMessage = 'End time for event search', ParameterSetName = '__evt')]
        [ValidateNotNullOrEmpty()]
        [System.DateTime] $EndTime,

        [Parameter(HelpMessage = 'String to search for in event data', ParameterSetName = '__evt')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $Data
    )

    Process {
        $eventTable = Get-Content -Raw -Path $PSScriptRoot\EventTable.json | ConvertFrom-Json

        switch ($PSCmdlet.ParameterSetName) {
            '__lst' {
                $eventTable | Select-Object -Property Id, Name, EventId, Log
            }
            '__evt' {
                # SET EVENT PARAMETERS HASHTABLE
                $eventParams = @{ }

                # CHECK FOR PARAMETERS AND ADD AS APPROPRIATE
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
                    #<named-data> = <String[]>
                } #>

                # ADD EVENT ID
                $e = $eventTable.Where({ $_.Id -eq $Id }) #| Where-Object Id -EQ $Id
                $filterHash = @{ ID = $e.EventId }

                # ADD LOG NAME OR PROVIDER
                $logNames = @('Application', 'Security', 'Setup', 'System')
                if ( $e.Log -in $logNames ) { $filterHash['LogName'] = $e.Log }
                else { $filterHash['ProviderName'] = $e.Log }

                # ADD START AND END TIMES
                if ($PSBoundParameters.ContainsKey('StartTime')) { $filterHash['StartTime'] = $StartTime }
                if ($PSBoundParameters.ContainsKey('EndTime')) { $filterHash['EndTime'] = $EndTime }

                # ADD SEARCH STRING FOR EVENT DATA SEARCH
                if ($PSBoundParameters.ContainsKey('Data')) { $filterHash['Data'] = $Data }

                # GET EVENTS
                Get-WinEvent @eventParams -FilterHashtable $filterHash
            }
        }
    }
}