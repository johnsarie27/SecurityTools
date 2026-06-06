function Get-WhoIs {
    <#
    .SYNOPSIS
        Get WhoIs information
    .DESCRIPTION
        Get WhoIs information
    .PARAMETER IPAddress
        Target IP address
    .INPUTS
        System.Net.IPAddress[].
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .EXAMPLE
        PS C:\> Get-WhoIs -IPAddress '8.8.8.8'
        Get's WhoIs info for the ip 8.8.8.8
    .NOTES
        Status: Stable
        https://www.powershellgallery.com/packages/PSScriptTools/2.9.0/Content/functions%5CGet-WhoIs.ps1
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param (
        [Parameter(Position = 0,
            Mandatory,
            HelpMessage = "Enter an IPV4 address to lookup with WhoIs",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [System.Net.IPAddress[]] $IPAddress
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
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
