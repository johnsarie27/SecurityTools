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
        [ValidatePattern('^[\w]+$')]
        [string] $CertificateAuthority,

        [Parameter(Mandatory, HelpMessage = 'Ceritificate template')]
        [ValidatePattern('^[\d\.]+$')]
        [string] $CertificateTemplate,

        [Parameter(HelpMessage = 'Return expired certificates')]
        [switch] $Expired
    )

    Begin {
        # REQUIRES MODULE PSPKI
        if ( -not (Get-Module -ListAvailable -Name 'PSPKI') ) {
            Throw 'This function requires module PSPKI'
        }
        else {
            Import-Module -Name 'PSPKI'
        }

        # SET FILTER
        $Filter = @("CertificateTemplate -EQ $CertificateTemplate")

        # SET FILTERS
        if ( $PSBoundParameters.ContainsKey('Expired') ) { $Filter += "NotAfter -lt $(Get-Date)" }
        else { $Filter += "NotAfter -gt $(Get-Date)" }
    }

    Process {
        # GET DATA
        $Results = Get-CA -Name $CertificateAuthority | Get-IssuedRequest -Filter $Filter

        # OUTPUT DATA
        $Results
    }
}
