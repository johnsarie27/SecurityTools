function Find-SavedCommand {
    <# =========================================================================
    .SYNOPSIS
        Find command matching search term(s)
    .DESCRIPTION
        Search for commands in the stored session history for PowerShell that
        match the provided keyword(s). If no keywards are provided all unique
        commands will be returned.
    .PARAMETER Search
        Search term or phrase (best results with a contiguous phrase)
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object[].
    .EXAMPLE
        PS C:\> Find-SavedCommand -Search "ELBLoadBalancer -Name"
    .NOTES
        See article: https://serverfault.com/questions/891265/how-to-search-powershell-command-history-from-previous-sessions
    ========================================================================= #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]

    Param(
        [Parameter(Mandatory, HelpMessage = 'Search phrase')]
        [ValidateNotNullOrEmpty()]
        [string] $Search
    )

    Begin {
        $history = Get-Content (Get-PSReadLineOption).HistorySavePath |
            Where-Object { $_ -like "*$Search*" } | Select-Object -Unique
    }

    Process {
        $i = 1
        foreach ( $line in $history ) {
            if ( $line -notmatch 'HistorySavePath' -and $line -notmatch 'SavedHistory' ) {
                [PSCustomObject] @{
                    Id          = $i
                    CommandLine = $line
                }
                $i++
            }
        }
    }
}
