function Get-PortalToken {
    <# =========================================================================
    .SYNOPSIS
        Generate token
    .DESCRIPTION
        Generate token for ArcGIS Portal
    .PARAMETER URL
        Target ArcGIS Portal URL
    .PARAMETER Credential
        PowerShell credential object containing username and password
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-PortalToken -Domain mydomain.com -Credential $creds
        Generate token for mydomain.com
    .NOTES
        This works just fine inside the boundary but doesn't work outside.
        Need to review WAF deny logs to determine why.

        -- SERVER ENDPONITS --
        https://myDomain.com/arcgis/admin/login
        https://myDomain.com/arcgis/admin/generateToken
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal URL')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $_.AbsoluteUri -match 'https://[\w\/\.-]+rest\/generateToken' })]
        [System.Uri] $URL,

        [Parameter(Mandatory, HelpMessage = 'PS Credential object containing un and pw')]
        [ValidateNotNullOrEmpty()]
        [pscredential] $Credential
    )

    Process {
        $restParams = @{
            Uri    = $URL.AbsoluteUri
            #Uri    = 'https://myDomain.com/arcgis/sharing/rest/generateToken'
            Method = "POST"
            Body   = @{
                username   = $Credential.UserName
                password   = $Credential.GetNetworkCredential().password
                referer    = '{0}://{1}' -f $URL.Scheme, $URL.Authority
                client     = 'referer'
                expiration = 60 #minutes
                f          = 'pjson'
            }
            #UserAgent      = "Mozilla/5.0 (Windows NT 10.0; …) Gecko/20100101 Firefox/67.0"
        }

        # GENERATE TOKEN
        $response = Invoke-RestMethod @restParams
        #$response = Invoke-WebRequest @restParams -UseBasicParsing

        # CHECK FOR ERRORS AND RETURN
        if ( -not $response.token ) {
            # CHECK FOR VALID JSON WITH ERROR DETAILS
            if ( $response.error ) {
                if ( $response.error.details.GetType().FullName -eq 'System.Object[]' ) { $details = $response.error.details -join "; " }
                else { $details = $response.error.details }

                $tokens = @($response.error.code, $response.error.message, $details)
                $msg = "Request failed with response:`n`tcode: {0}`n`tmessage: {1}`n`tdetails: {2}" -f $tokens
            }
            else {
                $msg = "Request failed with unknown error"
            }
            # WRITE OUT ERROR
            Write-Error -Message $msg
        }
        else {
            $response
        }

        #$expiration = (Get-Date -Date "1/1/1970").AddSeconds($Response.expires).ToLocalTime()
    }
}
