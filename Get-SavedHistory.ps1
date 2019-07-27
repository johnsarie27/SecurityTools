function Get-SavedHistory {
    <# =========================================================================
    .SYNOPSIS
        Get command history matching word or phrase
    .DESCRIPTION
        This function will return results of commands run and stored in the
        HistorySavePath property of Get-PSReadLineOption Cmdlet. This typically
        traverses sessions and windows other than that currently running.
    .PARAMETER Phrase
        Search term or phrase (best results with a contiguous phrase)
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-SavedHistory -Phrase "ELBLoadBalancer -Name" -Results 100
    .NOTES
        See article: https://serverfault.com/questions/891265/how-to-search-powershell-command-history-from-previous-sessions
    ========================================================================= #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]

    Param(
        [Parameter(Mandatory, HelpMessage = 'Search phrase' )]
        [ValidateNotNullOrEmpty()]
        [Alias('Search', 'Terms')]
        [string] $Phrase
    )

    $Return = Get-Content (Get-PSReadLineOption).HistorySavePath |
        Where-Object { $_ -like "*$Phrase*" }

    $i = 1 ; $List = @()
    $Where = { $_ -NotMatch 'HistorySavePath' -and $_ -NotMatch 'SavedHistory' }
    $Return | Where-Object $Where | Select-Object -Unique |
        ForEach-Object {
        $new = @{ 'Id' = $i } ; $new.CommandLine = $_
        $List += [PSCustomObject] $new ; $i++
    }
    $List
}
