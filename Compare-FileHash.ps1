function Compare-FileHash {
    <# =========================================================================
    .SYNOPSIS
        Compare file hashes
    .DESCRIPTION
        Compare the hash value of two different files
    .PARAMETER FirstFile
        Path to first file
    .PARAMETER SecondFile
        Path to Second file
    .INPUTS
        None
    .OUTPUTS
        System.String
    .EXAMPLE
        PS C:\> Compare-FileHash -Path1 C:\file.txt -Path2 C:\Temp\file.txt
        Compare the hash value of both files and provide output based on whether
        the hash values match
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Path to first file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [Alias('File1', 'Path1')]
        [string] $FirstFile,

        [Parameter(Mandatory, HelpMessage = 'Path to second file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [Alias('File2', 'Path2')]
        [string] $SecondFile
    )

    # GET HASH VALUES
    $File1Hash = Get-FileHash -Path $FirstFile
    $File2Hash = Get-FileHash -Path $SecondFile

    # COMPARE HASH VALUES
    if ( $File1Hash -eq $File2Hash ) { Write-Output 'Files are the same' }
    else { Write-Warning 'Files do not match' }

}