function Revoke-SupersededCardCert {
    <# =========================================================================
    .SYNOPSIS
        Revoke smart card certificates that have been superseded
    .DESCRIPTION
        Revoke smart card certificates where a newer certificate of the same template
        exists for the same user.
    .PARAMETER ConfigPath
        Path to file containing configuration data
    .PARAMETER Confirm
        Switch parameter to confirm revocation of certificates
    .INPUTS
        None.
    .OUTPUTS
        System.String[].
    .EXAMPLE
        PS C:\> .\Revoke-SupersededCardCerts.ps1 -CP C:\config.json
        Revoke all card certificates where a duplicate with a later expiration exists.
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Path to configuration data file')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.json" })]
        [Alias('ConfigFile', 'DataFile', 'CP', 'File')]
        [string] $ConfigPath,

        [Parameter(HelpMessage = 'Confirm revocation')]
        [switch] $Confirm
    )

    # IMPORT REQUIRED MODULES
    Import-Module -Name PSPKI

    # GET ALL ACTIVE CERTIFICATES
    $ActiveCerts = Get-ActiveSmartCardCert -ConfigPath $ConfigPath

    # LOOP THROUGH ALL ACTIVE CERTS
    foreach ( $cert in $ActiveCerts ) {
    
        # GET ALL CERTS FOR USER
        $UserCerts = $ActiveCerts | Where-Object 'Request.RequesterName' -EQ $cert.'Request.RequesterName'

        # LOOP THROUGH ALL CERTS FOR USER
        $UserCerts | ForEach-Object -Process {
        
            # COMPARE EXPIRATION DATE
            if ( $_.NotAfter -gt $cert.NotAfter ) {
            
                # CHECK FOR CONFIRMATION
                if ( $Confirm ) {
                    # REVOKE CERT
                    $cert | Revoke-Certificate -Reason 'Superseded'

                    # SET MESSAGE
                    $Message = 'Revoked certificate for [{0}] expired [{1}] with serial no. [{2}]'
                }
                else {
                    # SET MESSAGE
                    $Message = 'Certificate for [{0}] expired [{1}] with serial no. [{2}]'
                }

                # WRITE OUTPUT
                Write-Output ($Message -f $cert.'Request.RequesterName', $cert.NotAfter, $cert.SerialNumber)
            }
        }
    }
}