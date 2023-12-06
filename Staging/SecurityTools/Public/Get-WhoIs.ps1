function Get-WhoIs {
    <# =========================================================================
    .SYNOPSIS
        Get WhoIs information
    .DESCRIPTION
        Get WhoIs information
    .PARAMETER IPAddress
        Target IP address
    .INPUTS
        System.String[].
    .OUTPUTS
        System.Object[].
    .EXAMPLE
        PS C:\> Get-WhoIs -IPAddress '8.8.8.8'
        Get's WhoIs info for the ip 8.8.8.8
    .NOTES
        General notes
        I took this from the link below. I've made some minor modifications.
        https://www.powershellgallery.com/packages/PSScriptTools/2.9.0/Content/functions%5CGet-WhoIs.ps1
    ========================================================================= #>
    [cmdletbinding()]
    [OutputType("WhoIsResult")]
    Param (
        [parameter(Position = 0,
            Mandatory,
            HelpMessage = "Enter an IPV4 address to lookup with WhoIs",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$")]
        [ValidateScript( {
                #verify each octet is valid to simplify the regex
                $test = ($_.split(".")).where( { [int]$_ -gt 254 })
                if ($test) {
                    Throw "$_ does not appear to be a valid IPv4 address"
                    $false
                }
                else {
                    $true
                }
            })]
        [System.String[]] $IPAddress
    )
    Begin {
        Write-Verbose "Starting $($MyInvocation.Mycommand)"
        $baseURL = 'http://whois.arin.net/rest'
        #default is XML anyway
        $header = @{ "Accept" = "application/xml" }

    } #begin
    Process {
        foreach ( $ip in $IPAddress ) {
            Write-Verbose -Message "Getting WhoIs information for $ip"
            $url = '{0}/ip/{1}' -f $baseURL, $ip
            try {
                $r = Invoke-Restmethod -Uri $url -Headers $header -ErrorAction Stop
                Write-verbose ($r.net | Out-String)
            }
            catch {
                $errMsg = 'Failed to retrieve WhoIs information for [{0}] with error: {1}' -f $ip, $_.Exception.Message
                Write-Error -Message $errMsg
            }

            if ($r.net) {
                Write-Verbose "Creating result"
                [pscustomobject] @{
                    PSTypeName             = "WhoIsResult"
                    IP                     = $ip
                    Name                   = $r.net.name
                    RegisteredOrganization = $r.net.orgRef.name
                    City                   = (Invoke-RestMethod $r.net.orgRef.'#text').org.city
                    StartAddress           = $r.net.startAddress
                    EndAddress             = $r.net.endAddress
                    NetBlocks              = $r.net.netBlocks.netBlock | foreach-object { "$($_.startaddress)/$($_.cidrLength)" }
                    Updated                = $r.net.updateDate -as [datetime]
                }
            } #If $r.net
        }
    } #Process
    End {
        Write-Verbose "Ending $($MyInvocation.Mycommand)"
    } #end
}