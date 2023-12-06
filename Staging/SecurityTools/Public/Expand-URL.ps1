function Expand-URL {
    <# =========================================================================
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER abc
        Parameter description (if any)
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .NOTES
        Name: Expand-URL
        Author: Justin Johns
        Version: 0.1.0 | Last Edit: 2022-01-10 [0.1.0]
        - <VersionNotes> (or remove this line if no version notes)
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
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

        $baseUrl = 'https://onesimpleapi.com/api/unshorten?token={0}&url={1}'
    }
    Process {
        $fullUri = $baseUrl -f $ApiKey, $URL

        Invoke-RestMethod -Uri $fullUri
    }
}