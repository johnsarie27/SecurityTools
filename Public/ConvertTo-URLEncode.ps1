function ConvertTo-URLEncode {
    <# =========================================================================
    .SYNOPSIS
        Convert URL encoded string to plain text
    .PARAMETER String
        URL encoded string
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> ConvertTo-URLEncode -String 'https://www.google.com/'
        URL encode 'https://www.google.com/'
    .NOTES
        Name: ConvertTo-URLEncode
        Author: Justin Johns
        Version: 0.1.0 | Last Edit: 2022-01-11 [0.1.0]
        - <VersionNotes> (or remove this line if no version notes)
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'String to URL encode')]
        [ValidateNotNullOrEmpty()]
        [string] $String
    )
    Process {
        [System.Web.HttpUtility]::UrlEncode($String)
    }
}