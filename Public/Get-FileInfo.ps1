function Get-FileInfo {
    <# =========================================================================
    .SYNOPSIS
        Get file information
    .DESCRIPTION
        Get file information based on file header bytes from Wikipedia
    .PARAMETER Signature
        File signature
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-FileInfo -Signature '50 4B 03 04'
        Get information on a file with signature '50 4B 03 04'
    .NOTES
        Name:     Get-FileInfo
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-08-23
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://en.wikipedia.org/wiki/List_of_file_signatures
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'File signature')]
        [ValidatePattern('^[A-Za-z0-9\s]+$')]
        [System.String] $Signature
    )
    Process {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # LOOKUP VALUE
        $FileSignatures | Where-Object Hex_signature -Match $Signature
    }
}