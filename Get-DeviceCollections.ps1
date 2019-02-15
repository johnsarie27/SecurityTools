function Get-DeviceCollections {
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
        System.String. Get-DeviceCollections accepts a string value for the
        DeviceName parameter
    .OUTPUTS
        System.PSObject. Get-DeviceCollections returns an array of CMCollection
        objects.
    .EXAMPLE
        Get-DeviceCollections -DeviceName Server01
        Returns a list of CM Collection objects to which Server01 is a member.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = 'Device name')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Quiet -Count 1 })]
        [Alias('Name', 'ComputerName')]
        [string] $DeviceName,

        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'PSDriver for Configuration Manager')]
        [ValidateScript({ (Get-PSDrive -PSProvider CMSite).Name -contains $_ })]
        [Alias('Drive', 'DriveName', 'CMDrive')]
        [string] $PSDrive
    )

    Import-Module (Join-Path -Path $(Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

    # VALIDATE $PSDrive IS PROPERLY FORMATTED
    if ( $PSDrive -match '[a-z0-9]+:' ) { Push-Location $PSDrive } else { Push-Location ($PSDrive + ':') }

    # FIND ALL COLLECTIONS WHERE GIVEN DEVICE IS A MEMBER
    $CollectionList = @()
    foreach ( $collection in ( Get-CMCollection ) ) {
        $DeviceList = @( Get-CMCollectionMember -CollectionName $collection.Name | Select-Object -EXP Name )
        if ( $DeviceList -contains $DeviceName ) { $CollectionList += $collection }
    }

    $CollectionList | Select-Object CollectionID, Name, LastMemberChangeTime, MemberCount

    Pop-Location
}
