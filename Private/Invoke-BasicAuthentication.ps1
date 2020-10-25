#Requires -Version 5.1

function Invoke-BasicAuthentication {
    <# =========================================================================
    .SYNOPSIS
        Invoke web request with basic web authentication
    .DESCRIPTION
        Invoke web request with basic web authentication
    .PARAMETER Uri
        Target URI
    .PARAMETER Credential
        PS Credential Object
    .INPUTS
        None.
    .OUTPUTS
        Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject.
    .EXAMPLE
        PS C:\> Invoke-BasicAuthentication -Credential $creds -Uri https://myCoolWebsite/content/
        Explanation of what the example does
    .NOTES
        General notes
        https://www.reddit.com/r/PowerShell/comments/3z4wt8/basic_web_authentication/
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target URI')]
        [System.Uri] $Uri,

        [Parameter(Mandatory, HelpMessage = 'Credential object')]
        [pscredential] $Credential
    )

    Process {
        $bytes = [System.Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Credential.UserName, $Credential.GetNetworkCredential().Password))

        $params = @{
            Uri     = $Uri.AbsoluteUri
            Method  = 'GET'
            Headers = @{
                Authorization = "Basic {0}" -f ([System.Convert]::ToBase64String($bytes))
            }
        }

        Invoke-WebRequest @params
        #Invoke-RestMethod @params
    }
}
