function Get-HAGroup {
    <# =========================================================================
    .SYNOPSIS
        Get all nodes in a given CM Collection or Collections
    .DESCRIPTION
        This function will return all systems in the specified CM Collection(s)
        that match the station and server type provided.
    .PARAMETER PSDrive
        PowerShell Drive designated for CM Site
    .PARAMETER CollectionName
        CM Collection Name(s) to filter for group servers.
    .PARAMETER Station
        Primary or secondary HA server(s)
    .PARAMETER ServerType
        Primary function of server (app or data)
    .INPUTS
        System.String. Get-HAGroup accepts string values for all parameters
    .OUTPUTS
        System.String. Get-HAGroup returns an array of strings for servers that
        match the arguments provided.
    .EXAMPLE
        PS C:\> Get-HAGroup -PSDrive MySite -CollectionName $Col -Station primary
        Returns all "primary" servers in collection $Col from MySite
    .NOTES
        Need the ability to select data or app
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'PSDriver for Configuration Manager')]
        [ValidateScript( { (Get-PSDrive -PSProvider CMSite).Name -contains $_ })]
        [Alias('Drive', 'DriveName', 'CMDrive')]
        [string] $PSDrive,

        [Parameter(Mandatory, HelpMessage = 'Array of CM Collection Names')]
        [ValidateScript( { $_ -in (Get-CMCollection).Name })]
        [Alias('Collections', 'GroupNames')]
        [string[]] $CollectionNames,

        [Parameter(HelpMessage = 'Primary or secondary HA group')]
        [ValidateSet('primary', 'secondary')]
        [Alias('HAGroup', 'Group')]
        [string] $Station,

        [Parameter(HelpMessage = 'Server type')]
        [ValidateSet('apps', 'data')]
        [Alias('Type', 'Purpose', 'Designation')]
        [string] $ServerType
    )

    Import-Module (Join-Path -Path $(Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

    # VALIDATE $PSDrive IS PROPERLY FORMATTED
    if ( $PSDrive -match '[a-z0-9]+:' ) { Push-Location $PSDrive } else { Push-Location ($PSDrive + ':') }

    $CollectionNames = $CollectionNames | Where-Object { $_ -match "$ServerType" -and $_ -match "$Station" }

    $Results = @()
    $CollectionNames | ForEach-Object -Process { $Results += Get-CMCollectionMember -CollectionName $_ }

    $Results | Select-Object -ExpandProperty Name
    Pop-Location
}
