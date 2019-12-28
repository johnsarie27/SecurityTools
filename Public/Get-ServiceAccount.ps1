function Get-ServiceAccount {
    <# =========================================================================
    .SYNOPSIS
    .DESCRIPTION
        This function will retrieve the services and identities of all services
        running as a domain account.
    .PARAMETER Environment
        User environment
    .PARAMETER Agency
        Agency or customer name
    .PARAMETER Domain
        Domain name
    .PARAMETER ConfigurationData
        Path to configuration data file
    .INPUTS
        System.String. Get-ServiceAccount accepts string values for all parameters
    .OUTPUTS
        System.Object.CimInstance. Get-ServiceAccount returns a list of CimInstance
        Service objects.
    .EXAMPLE
        PS C:\> Get-ServiceAccount -Environment STG -Agency $Ag -DomainName $DN -ConfigFile $ConfigFile
        This returns all services and identities of those services for all
        systems in the staging environment for a give customer
    .NOTES
        Remove comments to utilize Configuration Manager to retrieve servers
        in SCCM Collections.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Environment')]
        [ValidateSet('PRD', 'STG')]
        [Alias('Env', 'System')]
        [string] $Environment,

        [Parameter(Mandatory, HelpMessage = 'Agency')]
        [ValidateScript( { (Get-ADOrganizationalUnit -Filter * -SearchScope Subtree).Name -contains $_ })]
        [Alias('Customer')]
        [string] $Agency,

        [Parameter(Mandatory, HelpMessage = 'Domain short name')]
        [Alias('Domain')]
        [string] $DomainName,

        [Parameter(Mandatory, HelpMessage = 'Configuration data file')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.json" })]
        [Alias('ConfigFile', 'DataFile', 'CofnigData', 'File', 'Path')]
        [string] $ConfigurationData
    )

    $Config = Get-Content -Raw -Path $ConfigurationData | ConvertFrom-Json

    if ( $Environment -eq 'PRD' ) { $Env = $Config.Domain.PRD } else { $Env = $Config.Domain.STG }

    if ( $PSBoundParameters.ContainsKey('Agency') ) {
        $SearchBase = $Env + ',OU=' + $Agency + ',' + $Config.Domain.CustomerBase
    }
    else { $SearchBase = $Config.Domain.CustomerBase }

    $ComputerList = Get-ADComputer -Filter * -SearchBase $SearchBase | Select-Object -EXP Name
    # $ComputerList = Get-HAGroup -ConfigurationData $ConfigurationData -Environment STG

    $ServiceList = @()

    foreach ( $server in $ComputerList ) {
        $ServiceList += Get-CimInstance win32_service -ComputerName $server |
            Where-Object StartName -like $DomainName* |
            Select-Object -Property State, Name, SystemName, StartName # PSComputerName
    }

    $ServiceList
}
