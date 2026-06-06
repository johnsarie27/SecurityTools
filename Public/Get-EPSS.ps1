function Get-EPSS {
    <#
    .SYNOPSIS
        Get EPSS information
    .DESCRIPTION
        Get EPSS information or score for specific CVE
    .PARAMETER CVE
        Common Vulnerability Enumeration (CVE) ID
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-EPSS -CVE 'CVE-2022-27225'
        Get the EPSS score for CVE 'CVE-2022-27225'
    .NOTES
        Status: Stable
        https://www.first.org/epss
        https://www.first.org/epss/api
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline, HelpMessage = 'CVE ID')]
        [ValidatePattern('CVE-\d{4}\-\d+')]
        [System.String[]] $CVE
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        # SET BASE URI
        $baseUri = 'https://api.first.org/data/v1/epss'
    }
    Process {
        # VALIDATE CVE PARAMETER
        if ($PSBoundParameters.ContainsKey('CVE')) {
            # CHECK FOR MULTIPLE VALUES
            if ($CVE.Count -GT 1) { $qArgs = $CVE -join ',' }
            else { $qArgs = $CVE[0] }

            # SET URI
            $uri = '{0}?cve={1}' -f $baseUri, $qArgs
        }
        else {
            # SET REQUEST URI
            $uri = $baseUri
        }

        # REQUEST EPSS
        Write-Verbose -Message ('Request uri: {0}' -f $uri)
        Invoke-RestMethod -Uri $uri
    }
}
