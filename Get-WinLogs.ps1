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
        System.String.
        System.Int.
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
        [ValidateScript( { $EventTable.Id -contains $_ })]
        [Alias('Event', 'EventId', 'EventTableId')]
        [string] $Id,

        [Parameter(ValueFromPipeline, HelpMessage = 'Hostname of target computer', ParameterSetName = 'events')]
        [ValidateScript( { Test-NetConnection -ComputerName $_ })]
        [Alias('Name', 'Computer', 'CN')]
        [string] $ComputerName,

        [Parameter(HelpMessage = 'Number of results to return', ParameterSetName = 'events')]
        [ValidateRange(1, 5000)]
        [int] $Results = 10
    )

    # IMPORT EVENTS AND CREATE LOG LIST
    $EventTable = Get-Content -Raw -Path $PSScriptRoot\EventTable.json | ConvertFrom-Json
    $EventLogList = @('Application', 'Security', 'Setup', 'System')

    if ( $PSBoundParameters.ContainsKey('List') ) { $EventTable | Select-Object -Property Id, Name }
    else {
        $E = $EventTable | Where-Object Id -EQ $Id
        if ( $E.Log -in $EventLogList ) {
            if ( $PSBoundParameters.ContainsKey('ComputerName') ) {
                Get-EventLog -LogName $E.Log -ComputerName $ComputerName |
                    Where-Object EventID -EQ $E.EventId | Select-Object -First $Results
            }
            else {
                Get-EventLog -LogName $E.Log | Where-Object EventID -EQ $E.EventId |
                    Select-Object -First $Results
            }
        }
        elseif ( $E.Log -notin $EventLogList ) {
            if ( $PSBoundParameters.ContainsKey('ComputerName') ) {
                Get-WinEvent -ProviderName $E.Log -ComputerName $ComputerName |
                    Where-Object Id -EQ $E.EventId |
                    Select-Object -First $Results -Property TimeCreated, Message
            }
            else {
                Get-WinEvent -ProviderName $E.Log | Where-Object Id -EQ $E.EventId |
                    Select-Object -First $Results -Property TimeCreated, Message
            }
        }
    }
}
