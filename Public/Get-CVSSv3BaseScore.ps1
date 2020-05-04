function Get-CVSSv3BaseScore {
    <# =========================================================================
    .SYNOPSIS
        Get CVSS v3 score for the given CVE ID
    .DESCRIPTION
        Get the first occurrence of 'CVSS 3.0 Base Score [X]' from the NVD site
        page for the given CVE ID
    .PARAMETER CVE
        CVE ID
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-CVSSv3BaseScore -CVE "CVE-2020-2659"
        Scrapes the NVD NIST page and returns CVSS v3 score for CVE "CVE-2020-2659"
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline, Mandatory, HelpMessage = 'CVE ID')]
        [ValidatePattern('CVE-\d{4}\-\d+')]
        #[ValidateScript({ $_ -match 'CVE-\d{4}\-\d+' })]
        [string] $CVE
    )

    Begin {
        $uri = "https://nvd.nist.gov/vuln/detail/{0}" -f $CVE
        $pattern = '"vuln-cvss3-panel-score"\>(\d+\.\d+)\s(\w+)'
    }

    Process {
        $response = Invoke-WebRequest -Uri $uri

        $results = $response.Content | Select-String -Pattern $pattern # -AllMatches

        [PSCustomObject] @{
            Score = $results.Matches.Groups[1].Value
            Severity = $results.Matches.Groups[2].Value
        }
    }
}
