function Get-FileHeader {
    <# =========================================================================
    .SYNOPSIS
        Get file header
    .DESCRIPTION
        Get the first 4 bytes of a file (a.k.a., magic numbers)
    .PARAMETER Path
        File path
    .INPUTS
        System.String
    .OUTPUTS
        System.String
    .EXAMPLE
        PS C:\> Get-FileHeader -Path "C:\myFile.xlsx"
        Returns the first 4 bytes as hex
    .NOTES
        Name:     Get-FileHeader
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-08-23
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://stackoverflow.com/questions/26194071/recognize-file-types-in-powershell
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'File Path')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [System.String] $Path
    )
    Process {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # GET BYTES OF FILE
        $bytes = [System.IO.File]::ReadAllBytes($Path)

        # CONVERT FIRST 4 BYTES TO HEX
        0..3 | ForEach-Object -Process { '{0:X2}' -f $bytes[$_] }
    }
}