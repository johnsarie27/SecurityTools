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
        Name: Get-QRCode
        Author: Justin Johns
        Version: 0.1.0 | Last Edit: 2024-01-28 [0.1.0]
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
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
        Write-Verbose "Starting $($MyInvocation.Mycommand)"

        # SET BASE URI
        $baseUrl = 'https://onesimpleapi.com/api/qr_code?token={0}&output=json&message={1}'
    }
    Process {
        # ADD PARAMETERS TO BASE URI
        $fullUri = $baseUrl -f $ApiKey, $URL

        # LOG URI
        Write-Verbose -Message ('Uri: "{0}"' -f $fullUri)

        # SEND REQUEST
        Invoke-RestMethod -Uri $fullUri
    }
}
