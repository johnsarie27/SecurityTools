function ConvertTo-Base64 {
    <# =========================================================================
    .SYNOPSIS
        Convert string from plain text to base64
    .PARAMETER String
        String (plain text)
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> ConvertTo-Base64 -String $string
        Convert $string to base64
    .NOTES
        Name: ConvertTo-Base64
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
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($String)
        [System.Convert]::ToBase64String($bytes)
    }
}