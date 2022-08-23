function Get-DomainRegistration {
    <# =========================================================================
    .SYNOPSIS
        Get domain registration info
    .DESCRIPTION
        Get domain registration info
    .PARAMETER ApiKey
        API Key
    .PARAMETER Domain
        Target Domain
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-DomainRegistration -Domain google.com
        Get domain registration info for google.com
    .NOTES
        General notes
        https://whois.whoisxmlapi.com/documentation/making-requests
        API token required
        https://rdap.verisign.com/com/v1/domain/<DOMAIN>
        https://domainsrdap.googleapis.com/v1/domain/<DOMAIN>
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Target Domain')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Domain,

        [Parameter(Mandatory, HelpMessage = 'API Key')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ApiKey
    )
    Begin {
        Write-Verbose "Starting $($MyInvocation.Mycommand)"

        $baseUrl = 'https://www.whoisxmlapi.com/whoisserver/WhoisService?apiKey={0}&domainName={1}'
        $headers = @{ accept = "application/json" }
    }
    Process {
        $url = $baseUrl -f $ApiKey, $Domain

        Write-Verbose -Message ('Getting WhoIs info for [{0}]' -f $ip)

        try {
            Invoke-RestMethod -Uri $url -Headers $headers -Method 'GET'
        }
        catch {
            Write-Error -Message ('Error retrieving IP info for IP: {0}' -f $ip)
        }
    }
}
