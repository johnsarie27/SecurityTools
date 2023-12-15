function Get-WindowsEventCatalog {
    <#
    .SYNOPSIS
        Get catalog of Windows Events
    .DESCRIPTION
        Get catalog of Windows Events
    .PARAMETER UseRemoteData
        Get data from remote source
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
        Version:  0.1.1 | Last Edit: 2023-12-15
        - 0.1.1 - Updates for data location options
        - 0.1.0 - (2022-11-16) Initial version
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Get data from remote source')]
        [System.Management.Automation.SwitchParameter] $UseRemoteData
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET REMOTE PATH
        $uri = 'https://gist.githubusercontent.com/johnsarie27/5519dd08bae06b8b6271ac168e28e06a/raw/321c3a46756beb021012df4f2e26cccbd7fe6417/windows_signatures_850.csv'

        # SET LOCAL PATH
        $path = "$PSScriptRoot\..\Private\windows_signatures_850.csv"
    }
    Process {
        # GET DATA
        if ($PSBoundParameters.ContainsKey('UseRemoteData')) {
            Write-Verbose -Message ('Retrieving data from: {0}' -f $uri)
            Invoke-RestMethod -Uri $uri | ConvertFrom-Csv
        }
        else {
            Write-Verbose -Message 'Retrieving data from local source'
            Import-Csv -Path $path
        }
    }
}
