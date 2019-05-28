function Get-ActiveSmartCardCert {
    <# =========================================================================
    .SYNOPSIS
        Get all active smart card certificates
    .DESCRIPTION
        Get all active smart card certificates based on template in provided configuration file
    .PARAMETER ConfigPath
        Path to file containing configuration data
    .PARAMETER Inactive
        Return inactive certificates
    .INPUTS
        None.
    .OUTPUTS
        System.Object[].
    .EXAMPLE
        PS C:\> Get-ActiveSmartCardCert -CP C:\config.json
        Get all active smart card certificates from CA and template in config.json
    .NOTES
        General notes
    ========================================================================= #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Path to configuration data file')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.json" })]
        [Alias('ConfigFile', 'DataFile', 'CP', 'File')]
        [string] $ConfigPath,

        [Parameter(HelpMessage = 'Return inactive certificates')]
        [switch] $Inactive
    )

    Begin {
        # IMPORT REQUIRED MODULE
        Import-Module -Name PSPKI

        # GET CONFIG DATA
        $Config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

        # GET CA
        $CA = $Config.Domain.CA.Subordinate

        # GET TEMPLATE
        $Template = ($Config.Domain.CA.Templates | Where-Object Name -EQ 'SmartCard').Value

        # SET WHERE CLAUSES
        if ( $PSBoundParameters.ContainsKey('Inactive') ) {
            # WHERE EXPIRATION IS PRIOR TO TODAY
            $Where = { $_.CertificateTemplate -EQ $Template -and $_.NotAfter -lt (Get-Date) }
        }
        else {
            # WHERE EXPIRATION IS AFTER TODAY
            $Where = { $_.CertificateTemplate -EQ $Template -and $_.NotAfter -gt (Get-Date) }
        }
    }

    Process {
        # GET DATA
        $Results = Get-CA -Name $CA | Get-IssuedRequest | Where-Object $Where

        # OUTPUT DATA
        $Results
    }
}
