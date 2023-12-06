function Get-FileInfo {
    <#
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
        Version:  0.1.2 | Last Edit: 2022-08-23
        - 0.1.0 - Initial version
        - 0.1.1 - Replaced file with web lookup for file signatures
        - 0.1.2 - Added global variable to prevent repeated web requests
        Comments: <Comment(s)>
        General notes
        https://en.wikipedia.org/wiki/List_of_file_signatures
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'File signature')]
        [ValidatePattern('^[A-Za-z0-9\s]+$')]
        [System.String] $Signature
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # CHECK FOR FILE SIGNATURE VARIABLE
        if (-Not (Get-Variable -Name 'FileSignatures' -ErrorAction Ignore)) {

            Write-Verbose -Message 'Setting "FileSignatures" variable'

            # SET URI
            $uri = 'https://gist.githubusercontent.com/johnsarie27/819dec131420d02a9404a0479759eb59/raw/2796f5d3e58a272b876285a1eea08614114e9f1f/FileSignatures.json'

            # CREATE VARIABLE AS GLOBAL
            New-Variable -Name 'FileSignatures' -Scope Global -Value (Invoke-RestMethod -Uri $uri)
        }
    }
    Process {
        # LOOKUP VALUE
        $FileSignatures | Where-Object Hex_signature -Match $Signature
    }
}
