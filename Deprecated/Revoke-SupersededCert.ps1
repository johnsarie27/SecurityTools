function Revoke-SupersededCert {
    <# =========================================================================
    .SYNOPSIS
        Revoke smart card certificates that have been superseded
    .DESCRIPTION
        Revoke smart card certificates where a newer certificate of the same template
        exists for the same user.
    .PARAMETER Certificate
        Certificate object
    .PARAMETER ReportOnly
        Switch parameter to report expiration status of certificates
    .INPUTS
        None.
    .OUTPUTS
        System.String[].
    .EXAMPLE
        PS C:\> .\Revoke-SupersededCerts.ps1 -CP C:\config.json
        Revoke all card certificates where a duplicate with a later expiration exists.
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Certificate objects')]
        [ValidateNotNullOrEmpty()]
        [SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbRow[]] $Certificate,

        [Parameter(HelpMessage = 'Confirm revocation')]
        [switch] $ReportOnly
    )

    Begin {
        # REQUIRES MODULE PSPKI
        if ( -not (Get-Module -ListAvailable -Name 'PSPKI') ) {
            Throw 'This function requires module PSPKI'
        }
        else {
            Import-Module -Name 'PSPKI'
        }

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
        foreach ( $cert in $Certificate ) {

            # GET ALL CERTS FOR USER
            $UserCerts = $Certificate | Where-Object 'Request.RequesterName' -EQ $cert.'Request.RequesterName'

            # LOOP THROUGH ALL CERTS FOR USER
            $UserCerts | ForEach-Object -Process {

                # COMPARE EXPIRATION DATE
                if ( $_.NotAfter -gt $cert.NotAfter ) {

                    # CHECK FOR REPORT ONLY
                    if ( $ReportOnly ) {
                        # OUTPUT REPORT MESSAGE
                        Write-Output ($ReportMsg -f $cert.'Request.RequesterName', $cert.NotAfter, $cert.SerialNumber)
                    }
                    else {
                        # ADD SHOULD PROCESS
                        if ($PSCmdlet.ShouldProcess($RevokeMsg -f $cert.'Request.RequesterName', $cert.NotAfter, $cert.SerialNumber)) {

                            # ADD TRY/CATCH
                            try {
                                # REVOKE CERT
                                $cert | Revoke-Certificate -Reason 'Superseded'

                                # RETURN RESULT MESSAGE
                                Write-Output 'Certificate revoked.'
                            }
                            catch {
                                # RETURN RESULT MESSAGE
                                Write-Output 'Failed to revoke certificate. Error: {0}' -f $_.Exception.Message
                            }
                        }
                    }
                }
            }
        }
    }
}