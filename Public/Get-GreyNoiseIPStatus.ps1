function Get-GreyNoiseIPStatus {
    <#
    .SYNOPSIS
        Checks the compromise/threat status of one or more IP addresses using the GreyNoise API.
    .DESCRIPTION
        Uses the GreyNoise Community API to retrieve threat intelligence for one or more IP
        addresses, including classification, noise status, and RIOT data.
    .PARAMETER IPAddress
        One or more IP addresses to check.
    .PARAMETER ApiKey
        Your GreyNoise API key. If not provided, attempts to use the
        GREYNOISE_API_KEY environment variable.
    .EXAMPLE
        Get-GreyNoiseIPStatus -IPAddress "8.8.8.8" -ApiKey "your_api_key_here"
    .EXAMPLE
        "1.2.3.4", "5.6.7.8" | Get-GreyNoiseIPStatus
    .NOTES
        Requires a GreyNoise API key. Free community keys available at https://greynoise.io
        Prompts/requests for AI to create function: 5
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Net.IPAddress[]] $IPAddress,

        [Parameter(Mandatory = $false)]
        <# [ValidateScript({
                if ($_.Length -lt 20) {
                    throw "ApiKey appears to be invalid (too short)."
                }
                $true
            })] #>
        [ValidateLength(20, 100)]
        [string] $ApiKey
    )
    Begin {
        # SET UP API REQUEST HEADERS AND BASE URL
        $headers = @{
            'Accept'       = 'application/json'
            'Content-Type' = 'application/json'
        }

        # ADD API KEY TO HEADERS IF PROVIDED
        if ($ApiKey) { $headers['key'] = $ApiKey }

        # BASE URL FOR GREYNOISE COMMUNITY API
        $baseUrl = 'https://api.greynoise.io/v3/community'

        # Lookup table keyed on "classification|noise|riot"
        $statusTable = @{
            'riot'              = 'Benign - Known Internet Infrastructure'
            'malicious|noise'   = 'MALICIOUS - Known Threat Actor (Actively Scanning)'
            'malicious|nonoise' = 'MALICIOUS - Known Threat Actor'
            'benign|noise'      = 'Benign - Known Safe Scanner'
            'benign|nonoise'    = 'Benign - Known Safe'
            'unknown|noise'     = 'Suspicious - Unknown Internet Scanner'
            'unknown|nonoise'   = 'Unknown - No Data'
            'default|noise'     = 'Suspicious - Observed Scanning Activity'
            'default|nonoise'   = 'Unknown - Not Observed'
        }
    }
    Process {
        # LOOP THROUGH EACH IP ADDRESS AND QUERY GREYNOISE
        foreach ($ip in $IPAddress) {
            Write-Verbose "Querying GreyNoise for IP: $ip"

            try {
                # MAKE THE API REQUEST
                $response = Invoke-RestMethod -Uri "$baseUrl/$ip" -Headers $headers -Method Get -ErrorAction Stop

                # DETERMINE STATUS BASED ON RESPONSE FIELDS
                $noiseKey = if ($response.noise) { 'noise' } else { 'nonoise' }
                $classKey = if ($response.classification) { $response.classification } else { 'default' }
                $statusKey = if ($response.riot) { 'riot' } else { "$classKey|$noiseKey" }
                $status = $statusTable[$statusKey] ?? $statusTable["default|$noiseKey"]

                # RETURN A CUSTOM OBJECT WITH THE RELEVANT DATA
                [PSCustomObject] @{
                    IPAddress      = $ip
                    Noise          = $response.noise
                    RIOT           = $response.riot
                    Classification = $response.classification
                    Name           = $response.name
                    Link           = $response.link
                    LastSeen       = $response.last_seen
                    Message        = $response.message
                    Status         = $status
                }
            }
            catch {
                # Handle errors gracefully, returning a consistent object with error status
                [PSCustomObject] @{
                    IPAddress      = $ip
                    Noise          = $null
                    RIOT           = $null
                    Classification = $null
                    Name           = $null
                    Link           = $null
                    LastSeen       = $null
                    Message        = $null
                    Status         = switch ($_.Exception.Response.StatusCode.value__) {
                        400 { 'Invalid IP address' }
                        401 { 'Unauthorized - check API key' }
                        404 { 'Not Found - IP not in GreyNoise dataset' }
                        429 { 'Rate limit exceeded' }
                        default { 'Error: {0}' -f $_.Exception.Message }
                    }
                }
            }
        }
    }
}
