function Get-FileHeader {
    <#
    .SYNOPSIS
        Get file header
    .DESCRIPTION
        Get the desired number of bytes (starting from the beginning) of a file
        (a.k.a., magic numbers)
    .PARAMETER Path
        File path
    .PARAMETER Bytes
        Number of bytes
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-FileHeader -Path "C:\myFile.xlsx"
        Returns the first 4 bytes as hex
    .NOTES
        Name:     Get-FileHeader
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2022-08-23
        - 0.1.0 - Initial version
        - 0.1.1 - Added parameter for number of bytes to return
        Comments: <Comment(s)>
        General notes
        https://stackoverflow.com/questions/26194071/recognize-file-types-in-powershell
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'File path')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [System.String] $Path,

        [Parameter(Mandatory = $false, Position = 1, HelpMessage = 'Number of bytes')]
        [ValidateRange(2, 100)]
        [System.Int16] $Bytes = 4
    )
    Process {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # GET BYTES OF FILE
        $fileBytes = [System.IO.File]::ReadAllBytes($Path)

        # CONVERT FIRST 4 BYTES TO HEX
        $header = 0..($Bytes-1) | ForEach-Object -Process { '{0:X2}' -f $fileBytes[$_] }

        # RETURN HEADER AS STRING
        $header -join ' '
    }
}
