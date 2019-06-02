function Get-ActiveSmartCardCert {
    <# =========================================================================
    .SYNOPSIS
        Get all active smart card certificates
    .DESCRIPTION
        Get all active smart card certificates based on template in provided configuration file
    .PARAMETER ConfigPath
        Path to file containing configuration data
    .PARAMETER Expired
        Return expired certificates
    .INPUTS
        None.
    .OUTPUTS
        System.Object[].
    .EXAMPLE
        PS C:\> Get-ActiveSmartCardCert -CP C:\config.json
        Get all active smart card certificates from CA and template in config.json
    .NOTES
        General notes
        # GET CONFIG DATA
        $Config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
        $CA = $Config.Domain.CA.Subordinate
        $CT = ($Config.Domain.CA.Templates | Where-Object Name -EQ 'SmartCard').Value
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Ceritificate Authority server')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Quiet -Count 1 })]
        [Alias('CA', 'Authority')]
        [string] $CertificateAuthority,

        [Parameter(Mandatory, HelpMessage = 'Ceritificate template')]
        [ValidatePattern('')]
        [Alias('CT', 'Template')]
        [string] $CertificateTemplate,

        [Parameter(HelpMessage = 'Return expired certificates')]
        [switch] $Expired
    )

    Begin {
        # IMPORT REQUIRED MODULE
        Import-Module -Name PSPKI

        # SET WHERE CLAUSES
        if ( $PSBoundParameters.ContainsKey('Expired') ) {
            # WHERE EXPIRATION IS PRIOR TO TODAY
            $Where = { $_.CertificateTemplate -EQ $CertificateTemplate -and $_.NotAfter -lt (Get-Date) }
        }
        else {
            # WHERE EXPIRATION IS AFTER TODAY
            $Where = { $_.CertificateTemplate -EQ $CertificateTemplate -and $_.NotAfter -gt (Get-Date) }
        }
    }

    Process {
        # GET DATA
        $Results = Get-CA -Name $CertificateAuthority | Get-IssuedRequest | Where-Object $Where

        # OUTPUT DATA
        $Results
    }
}
