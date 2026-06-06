function Get-QRCode {
    <#
    .SYNOPSIS
        Generate QR code
    .DESCRIPTION
        Generate QR code from URI
    .PARAMETER URL
        URL to generate QR code
    .PARAMETER ApiKey
        API Key
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-QRCode -URL 'https://www.google.com'
        Generate QR code for 'https://www.google.com'
    .NOTES
        Status: Stable
        https://onesimpleapi.com/docs/qr-code
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline, HelpMessage = 'URL to generate QR code')]
        [ValidateNotNullOrEmpty()]
        [System.Uri] $URL,

        [Parameter(Mandatory = $true, HelpMessage = 'API Key')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ApiKey
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = 'https://onesimpleapi.com/api/qr_code'
            Method = 'POST'
            Body   = @{
                token   = $ApiKey
                output  = 'json'
                message = $URL
            }
        }

        # LOG URI
        Write-Verbose -Message ('Uri: "{0}"' -f $restParams['Uri'])

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
