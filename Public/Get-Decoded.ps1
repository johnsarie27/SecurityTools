function Get-Decoded {
    <# =========================================================================
    .SYNOPSIS
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
        PS C:\> Get-Decoded -String $encodedString
        Decode $encodedString from Base64
    .NOTES
        Name: Get-Decoded
        Author: Justin Johns
        Version: 0.1.0 | Last Edit: 2022-01-11 [0.1.0]
        - <VersionNotes> (or remove this line if no version notes)
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Base64 encoded string')]
        [ValidateNotNullOrEmpty()]
        [string] $String,

        [Parameter(Position = 1, HelpMessage = 'Encoding')]
        [ValidateSet('Base64', 'URL')]
        [string] $Encoding = 'Base64'
    )
    Process {
        if ($Encoding -EQ 'Base64') {
            $bytes = [System.Convert]::FromBase64String($String)
            [System.Text.Encoding]::UTF8.GetString($bytes)
        }
        if ($Encoding -EQ 'URL') {
            [System.Web.HttpUtility]::UrlDecode($String)
        }
    }
}