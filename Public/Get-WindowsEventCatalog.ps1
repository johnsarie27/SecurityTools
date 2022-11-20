function Get-WindowsEventCatalog {
    <# =========================================================================
    .SYNOPSIS
        Get catalog of Windows Events
    .DESCRIPTION
        Get catalog of Windows Events
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Get-WindowsEventCatalog
        Returns catalog of Windows Events
    .NOTES
        Name:     Get-WindowsEventCatalog
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-11-16
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param()
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET URI
        $uri = 'https://gist.githubusercontent.com/johnsarie27/5519dd08bae06b8b6271ac168e28e06a/raw/321c3a46756beb021012df4f2e26cccbd7fe6417/windows_signatures_850.csv'
    }
    Process {
        Invoke-RestMethod -Uri $uri | ConvertFrom-Csv
    }
}