function ConvertFrom-URLEncode {
    <# =========================================================================
    .SYNOPSIS
        Convert string from URL encoded to plain text
    .PARAMETER String
        URL encoded string
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> ConvertFrom-URLEncode -String $url
        Decode $url to plain text
    .NOTES
        Name: ConvertFrom-URLEncode
        Author: Justin Johns
        Version: 0.1.0 | Last Edit: 2022-01-11 [0.1.0]
        - <VersionNotes> (or remove this line if no version notes)
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'URL encoded string')]
        [ValidateNotNullOrEmpty()]
        [string] $String
    )
    Process {
        [System.Web.HttpUtility]::UrlDecode($String)
    }
}