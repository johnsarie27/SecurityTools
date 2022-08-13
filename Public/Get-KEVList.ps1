function Get-KEVList {
    <# =========================================================================
    .SYNOPSIS
        Get Known Exploited Vulnerability list
    .DESCRIPTION
        Get Known Exploited Vulnerability list
    .PARAMETER OutputDirectory
        Output Directory
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Get-KEVList
        Returns an object containing known exploited vulnerability catalog
    .NOTES
        Name:     Get-KEVList
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-08-13
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Output directory')]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [System.String] $OutputDirectory
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
        # $schema = 'https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities_schema.json'
    }
    Process {
        if ($PSBoundParameters.ContainsKey('OutputDirectory')) {
            # SET URI
            $uri = 'https://www.cisa.gov/sites/default/files/csv/known_exploited_vulnerabilities.csv'

            # DOWNLOAD CSV FILE
            Invoke-WebRequest -Uri $uri -OutFile (Join-Path -Path $OutputDirectory -ChildPath (Split-Path -Path $uri -Leaf))
        }
        else {
            # SET URI
            $uri = 'https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json'

            # GET KNOWN EXPLOITED VULNERABILITIES
            Invoke-RestMethod -Uri $uri
        }
    }
}