function ConvertFrom-Base64 {
    <# =========================================================================
    .SYNOPSIS
        Convert string from base64 to plain text
    .PARAMETER String
        Base64 encoded string
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> ConvertFrom-Base64 -String $encodedString
        Convert $encodedString to plain text
    .NOTES
        Name: ConvertFrom-Base64
        Author: Justin Johns
        Version: 0.1.0 | Last Edit: 2022-01-11 [0.1.0]
        - <VersionNotes> (or remove this line if no version notes)
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Base64 encoded string')]
        [ValidateNotNullOrEmpty()]
        [string] $String
    )
    Process {
        $bytes = [System.Convert]::FromBase64String($String)
        [System.Text.Encoding]::UTF8.GetString($bytes)
    }
}