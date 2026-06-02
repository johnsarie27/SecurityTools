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
        Status: Stable
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
