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
    [CmdletBinding(DefaultParameterSetName = 'list')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'List available events', ParameterSetName = 'list')]
        [switch] $List,

        [Parameter(Mandatory, HelpMessage = 'Event Table Id', ParameterSetName = 'events')]
        [ValidateScript({ $EventTable.Id -contains $_ })]
        [Alias('Event', 'EventId', 'EventTableId')]
        [int] $Id,

        [Parameter(ValueFromPipeline, HelpMessage = 'Hostname of target computer', ParameterSetName = 'events')]
        [ValidateScript({ Test-NetConnection -ComputerName $_ })]
        [Alias('Name', 'Computer', 'CN')]
        [string] $ComputerName,

        [Parameter(HelpMessage = 'Number of results to return', ParameterSetName = 'events')]
        [int] $Results = 10
    )

    Begin {
        # IMPORT EVENTS AND CREATE LOG LIST
        $EventTable = Get-Content -Raw -Path $PSScriptRoot\EventTable.json | ConvertFrom-Json
        $EventLogList = @('Application', 'Security', 'Setup', 'System')

        # SET INITIAL SPLATTER TABLE
        if ( $PSBoundParameters.ContainsKey('ComputerName') ) {
            $Params = @{ ComputerName = $ComputerName }
        } else {
            $Params = @{}
        }

        # GET EVENT ID
        if ( $PSBoundParameters.ContainsKey('Id') ) { $E = $EventTable | Where-Object Id -EQ $Id }
    }

    Process {
        # CHECK FOR LIST PARAM
        if ( $PSBoundParameters.ContainsKey('List') ) { $EventTable | Select-Object -Property Id, Name }
        else {
            # CHECK FOR EVENT LOG TYPE
            if ( $E.Log -in $EventLogList ) {
                # ADD PARAMS
                $Params += @{ LogName = $E.Log ; InstanceId = $E.EventId }

                # GET EVENT LOGS
                Get-EventLog @Params | Select-Object -First $Results
            }
            else {
                # CREATE AND ADD FILTER
                $Params.FilterHash = @{ ProviderName = $E.Log }

                <# $FilterHashtable = @{
                    ProviderName = $E.Log
                    ID           = $E.EventId
                    LogName      = <String[]>
                    #Path         = <String[]>
                    #Keywords     = <Long[]>
                    #Level        = <Int32[]>
                    #StartTime    = <DateTime>
                    #EndTime      = <DataTime>
                    #UserID       = <SID>
                    #Data         = <String[]>
                } #>

                # GET WINDOWS EVENT
                Get-WinEvent @Params | Where-Object Id -EQ $E.EventId |
                    Select-Object -First $Results -Property TimeCreated, Message
            }
        }
    }
}
