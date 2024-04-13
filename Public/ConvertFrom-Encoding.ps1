function ConvertFrom-Encoding {
    <#
    .SYNOPSIS
        Decode string from Base64 or URL encoding
    .DESCRIPTION
        Decode string from Base64 or URL encoding
    .PARAMETER String
        Encoded string
    .PARAMETER Encoding
        Encoding type (Base64 or URL)
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> ConvertFrom-Encoding -String $encodedString
        Decode $encodedString from Base64
    .NOTES
        Name: ConvertFrom-Encoding
        Author: Justin Johns
        Version: 0.1.1 | Last Edit: 2022-01-11 [0.1.1]
        - Changed class used to perform URL decoding
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    [OutputType('System.String')]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Base64 encoded string')]
        [ValidateNotNullOrEmpty()]
        [System.String] $String,

        [Parameter(Position = 1, HelpMessage = 'Encoding')]
        [ValidateSet('Base64', 'URL')]
        [System.String] $Encoding = 'Base64'
    )
    Process {
        switch ($Encoding) {
            'Base64' {
                $bytes = [System.Convert]::FromBase64String($String)
                [System.Text.Encoding]::UTF8.GetString($bytes)
            }
            'URL' {
                #[System.Web.HttpUtility]::UrlDecode($String)
                [System.Uri]::UnescapeDataString($String)
            }
        }
    }
}
