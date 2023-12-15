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
        Name:     Get-EPSS
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-12-15
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline, HelpMessage = 'CVE ID')]
        [ValidatePattern('CVE-\d{4}\-\d+')]
        [System.String[]] $CVE
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

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
