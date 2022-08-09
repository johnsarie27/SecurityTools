function Get-CountryCode {
    <# =========================================================================
    .SYNOPSIS
        Get Country Code
    .DESCRIPTION
        Get country from 2- or 3-letter country code
    .PARAMETER Code
        Country code (2- or 3-letter)
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .NOTES
        Name:     Get-CountryCode
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-08-08
        - <VersionNotes> (or remove this line if no version notes)
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Country code (2- or 3-letter)')]
        [ValidatePattern('^[A-Z]{2,3}$')]
        [System.String] $Code
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET URI
        $uri = 'https://gist.githubusercontent.com/johnsarie27/1ab851a8c0e06687ae1a49acf3498f82/raw/4bda0600fc609c0df774d20a9e5623a22394215d/ISO-3166.csv'

        # GET COUNTRY CODE DATA
        $data = Invoke-RestMethod -Uri $uri | ConvertFrom-Csv
    }
    Process {
        # CHECK CODE LENGTH
        if ($Code.Length -EQ 2) { $data.Where({ $_.'Alpha-2 code' -EQ $Code }) }
        else { $data.Where({ $_.'Alpha-3 code' -EQ $Code }) }
    }
}