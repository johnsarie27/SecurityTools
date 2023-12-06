function Expand-URL {
    <#
    .SYNOPSIS
        Expand URL
    .DESCRIPTION
        Expand shortened URL
    .PARAMETER URL
        URL to expand
    .PARAMETER ApiKey
        API Key
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Expand-URL -URL http://bitly.com/somethinghere
        Show destination URL target for bitly shortened or redirected URL
    .NOTES
        Name: Expand-URL
        Author: Justin Johns
        Version: 0.1.0 | Last Edit: 2022-01-10 [0.1.0]
        - <VersionNotes> (or remove this line if no version notes)
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'URL to expand')]
        [ValidateNotNullOrEmpty()]
        [System.Uri] $URL,

        [Parameter(Mandatory, HelpMessage = 'API Key')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ApiKey
    )
    Begin {
        Write-Verbose "Starting $($MyInvocation.Mycommand)"

        $baseUrl = 'https://onesimpleapi.com/api/unshorten?token={0}&url={1}'
    }
    Process {
        $fullUri = $baseUrl -f $ApiKey, $URL

        Invoke-RestMethod -Uri $fullUri
    }
}
