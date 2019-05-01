function Get-DeviceCollection {
    <# =========================================================================
    .SYNOPSIS
        Get all Collections for which a Device is a member
    .DESCRIPTION
        This function accepts a device name and outputs all collections that
        contain the provided device.
    .PARAMETER DeviceName
        Name of device.
    .PARAMETER PSDrive
        PowerShell Drive designated for CM Site
    .INPUTS
        System.String. Get-DeviceCollection accepts a string value for the
        DeviceName parameter
    .OUTPUTS
        System.PSObject. Get-DeviceCollection returns an array of CMCollection
        objects.
    .EXAMPLE
        Get-DeviceCollection -DeviceName Server01
        Returns a list of CM Collection objects to which Server01 is a member.
    ========================================================================= #>
    [CmdletBinding()]
    [Alias('Get-DeviceCollections')]

    Param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = 'Device name')]
        [ValidateScript({ Confirm-CMResource -DeviceName $_ })]
        [Alias('Name', 'ComputerName')]
        [string] $DeviceName,

        [Parameter(HelpMessage = 'PSDrive for Configuration Manager')]
        [ValidateScript({ Confirm-CMResource -PSDrive $_ })]
        [Alias('Drive', 'DriveName', 'CMDrive')]
        [string] $PSDrive
    )

    # IMPORT SCCM MODULE AND CD TO SITE
    Import-Module (Join-Path -Path $(Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

    if ( !$PSBoundParameters.ContainsKey('PSDrive') ) {
        $Site = (Get-PSDrive -PSProvider CMSite).Name
        if ( !$Site ) { Write-Error "No drives from PSProvider CMSite available."; Pop-Location; Break }
        elseif ( $Site.Count -gt 1 ) { Write-Error "Please specify CMSite."; Pop-Location; Break }
        else { Push-Location -Path ('{0}:' -f $Site) }
    } else { Push-Location -Path ('{0}:' -f $PSDrive) }

    # FIND ALL COLLECTIONS WHERE GIVEN DEVICE IS A MEMBER
    $CollectionList = @()
    foreach ( $collection in ( Get-CMCollection ) ) {
        $DeviceList = @( Get-CMCollectionMember -CollectionName $collection.Name | Select-Object -EXP Name )
        if ( $DeviceList -contains $DeviceName ) { $CollectionList += $collection }
    }

    $CollectionList | Select-Object CollectionID, Name, LastMemberChangeTime, MemberCount

    Pop-Location
}
