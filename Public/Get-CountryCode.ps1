function Get-CountryCode {
    <#
    .SYNOPSIS
        Get Country Code
    .DESCRIPTION
        Get country from 2- or 3-letter country code
    .PARAMETER Code
        Country code (2- or 3-letter)
    .PARAMETER Country
        Country name
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-CountryCode AS
        Returns the country data for "American Somoa"
    .NOTES
        Name:     Get-CountryCode
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2022-08-23
        - 0.1.0 - Initial version
        - 0.1.1 - Added global variable to prevent repeated web requests
        Comments: <Comment(s)>
        General notes
        https://www.iso.org/obp/ui/#search
        https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
        https://datahub.io/core/country-list
    #>
    [CmdletBinding(DefaultParameterSetName = '__cde')]
    Param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = '__cde', HelpMessage = 'Country code (2- or 3-letter)')]
        [ValidatePattern('^[A-Z]{2,3}$')]
        [System.String] $Code,

        [Parameter(Mandatory, Position = 0, ParameterSetName = '__cty', HelpMessage = 'Country name')]
        [ValidatePattern('^[\w\s-]+$')]
        [System.String] $Country
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # CHECK FOR FILE SIGNATURE VARIABLE
        if (-Not (Get-Variable -Name 'CountryCodes' -ErrorAction Ignore)) {

            Write-Verbose -Message 'Setting "CountryCodes" variable'

            # SET URI
            $uri = 'https://gist.githubusercontent.com/johnsarie27/1ab851a8c0e06687ae1a49acf3498f82/raw/4bda0600fc609c0df774d20a9e5623a22394215d/ISO-3166.csv'

            # CREATE VARIABLE AS GLOBAL
            New-Variable -Name 'CountryCodes' -Scope Global -Value (Invoke-RestMethod -Uri $uri | ConvertFrom-Csv)
        }
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            '__cde' {
                # CHECK CODE LENGTH
                if ($Code.Length -EQ 2) { $CountryCodes.Where({ $_.'Alpha-2 code' -EQ $Code }) }
                else { $CountryCodes.Where({ $_.'Alpha-3 code' -EQ $Code }) }
            }
            '__cty' {
                # MATCH COUNTRY
                $CountryCodes.Where({ $_.'English short name' -Like "*$Country*" })
            }
        }
    }
}
