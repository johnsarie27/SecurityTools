function Revoke-SupersededCardCert {
    <# =========================================================================
    .SYNOPSIS
        Revoke smart card certificates that have been superseded
    .DESCRIPTION
        Revoke smart card certificates where a newer certificate of the same template
        exists for the same user.
    .PARAMETER ConfigPath
        Path to file containing configuration data
    .PARAMETER ReportOnly
        Switch parameter to report expiration status of certificates
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
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Path to configuration data file')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.json" })]
        [Alias('ConfigFile', 'DataFile', 'CP', 'File')]
        [string] $ConfigPath,

        [Parameter(HelpMessage = 'Confirm revocation')]
        [switch] $ReportOnly
    )

    Begin {
        # IMPORT REQUIRED MODULES
        Import-Module -Name PSPKI

        # GET ALL ACTIVE CERTIFICATES
        $ActiveCerts = Get-ActiveSmartCardCert -ConfigPath $ConfigPath

        # SET MESSAGES
        $RevokeMsg = 'Revoke certificate for [{0}] expired [{1}] with serial no. [{2}]?'
        $ReportMsg = 'Report: Certificate for [{0}] expired [{1}] with serial no. [{2}]'

        # CHECK FOR CONFIRM AND WHATIF
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }

    Process {
        # LOOP THROUGH ALL ACTIVE CERTS
        foreach ( $cert in $ActiveCerts ) {

            # GET ALL CERTS FOR USER
            $UserCerts = $ActiveCerts | Where-Object 'Request.RequesterName' -EQ $cert.'Request.RequesterName'

            # LOOP THROUGH ALL CERTS FOR USER
            $UserCerts | ForEach-Object -Process {

                # COMPARE EXPIRATION DATE
                if ( $_.NotAfter -gt $cert.NotAfter ) {

                    # ADD SHOULD PROCESS
                    if ( $ReportOnly ) {
                        # SET MESSAGE
                        Write-Output ($ReportMsg -f $cert.'Request.RequesterName', $cert.NotAfter, $cert.SerialNumber)
                    }
                    else {
                        # ADD SHOULD PROCESS
                        if ($PSCmdlet.ShouldProcess($RevokeMsg -f $cert.'Request.RequesterName', $cert.NotAfter, $cert.SerialNumber)) {

                            # REVOKE CERT
                            $cert | Revoke-Certificate -Reason 'Superseded'

                            # RETURN RESULT
                            Write-Output 'Certificate revoked.'
                        }
                    }
                }
            }
        }
    }
}