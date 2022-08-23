function Get-Ipinfo {
    <# =========================================================================
    .SYNOPSIS
        Get IP address info
    .DESCRIPTION
        Get IP address info
    .PARAMETER abc
        Target IP address
    .INPUTS
        System.String[].
    .OUTPUTS
        System.Object[].
    .EXAMPLE
        PS C:\> Get-Ipinfo -IPAddress '1.1.1.1'
        Get IP address info for IP '1.1.1.1'
    .NOTES
        General notes
        https://ipinfo.io/
        To get more data (e.g., ASN or Company info) a token must be used
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, HelpMessage = 'Enter an IPV4 address')]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^(\d{1,3}\.){3}\d{1,3}$')]
        [System.String[]] $IPAddress
    )
    Begin {
        Write-Verbose "Starting $($MyInvocation.Mycommand)"

        $baseUrl = "https://ipinfo.io/"
        $headers = @{ accept = "application/json" }
    }
    Process {
        foreach ( $ip in $IPAddress ) {
            $url = '{0}{1}' -f $baseUrl, $ip

            Write-Verbose -Message ('Getting Ipinfo for [{0}]' -f $ip)

            try {
                Invoke-RestMethod -Uri $url -Headers $headers -Method "GET"
            }
            catch {
                Write-Error -Message ('Error retrieving IP info for IP: {0}' -f $ip)
            }
        }
    }
}
