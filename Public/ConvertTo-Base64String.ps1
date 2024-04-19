function ConvertTo-Base64String {
    <#
    .SYNOPSIS
        Convert a byte array to a base64 encoded string
    .DESCRIPTION
        Convert a byte array to a base64 encoded string
    .PARAMETER ByteArray
        Byte array
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> $cert = Get-RemoteSSLCertificate -ComputerName 'example.com'
        PS C:\> ConvertTo-Base64String -ByteArray $cert.RawData
        Convert the remote SSL certificate byte array to a base64 encoded string
    .EXAMPLE
        PS C:\> $b64s = ConvertTo-Base64String -ByteArray (Get-RemoteSSLCertificate -ComputerName 'example.com').RawData
        PS C:\> $pubCert = @('-----BEGIN CERTIFICATE-----')
        PS C:\> $pubCert += for ($i = 0; $i -LT $b64s.Length; $i += 64) { $b64s.Substring($i, 64) }
        PS C:\> $pubCert += '-----END CERTIFICATE-----'
        Gets the SSL certificate from example.com and converts the raw data to the proper Base64 encoded certificate format
    .NOTES
        Name:     ConvertTo-Base64String
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-04-19
        - Version history is captured in repository commit history
        Comments: <Comment(s)>
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Byte array')]
        [ValidateNotNullOrEmpty()]
        [System.Byte[]] $ByteArray
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # CONVERT BYTE ARRAY TO BASE64 ENCODED STRING
        return [System.Convert]::ToBase64String($ByteArray)
    }
}
