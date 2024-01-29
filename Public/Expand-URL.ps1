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
        PS C:\> Expand-URL -URL 'https://tinyurl.com/RedlandsStake' # https://t.co/Q0uEt49I5D
        Show destination URL target for bitly shortened or redirected URL
    .NOTES
        Name: Expand-URL
        Author: Justin Johns
        Version: 0.1.0 | Last Edit: 2024-01-28 [0.1.1]
        - 0.1.1 - (2024-01-28) Moved query arguments to the request body
        - 0.1.0 - (2022-01-10) Initial version
        General notes
        https://onesimpleapi.com/docs/url-unshorten
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
            Uri    = 'https://onesimpleapi.com/api/unshorten'
            Method = 'POST'
            Body   = @{
                token = $ApiKey
                url   = $URL
            }
        }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
