function Compress-URL {
    <#
    .SYNOPSIS
        Compress URL
    .DESCRIPTION
        Get shortened URL
    .PARAMETER URL
        URL to compress
    .PARAMETER ApiKey
        API Key
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Compress-URL -URL 'https://www.google.com'
        Get a shortened URL for 'https://www.google.com'
    .NOTES
        Name: Compress-URL
        Author: Justin Johns
        Version: 0.1.0 | Last Edit: 2024-01-28
        - 0.1.0 - (2024-01-28) Initial version
        General notes
        https://onesimpleapi.com/docs/url-shortener
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
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = 'https://onesimpleapi.com/api/shortener/new'
            Method = 'POST'
            Body   = @{
                token  = $ApiKey
                output = 'json'
                url    = $URL
            }
        }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
