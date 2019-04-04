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
        System.String[].
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-HAGroup -PSDrive MySite -CollectionName $Col -Station primary
        Returns all "primary" servers in collection $Col from MySite
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'PSDrive for Configuration Manager')]
        [ValidateScript({ Confirm-CMDrive -PSDrive $_ })]
        [Alias('Drive', 'DriveName', 'CMDrive')]
        [string] $PSDrive,

        [Parameter(Mandatory, HelpMessage = 'CM Collection Name')]
        [ValidateScript({ Confirm-CMResource -CollectionName $_ })]
        [Alias('Collection', 'DeviceCollection')]
        [string[]] $CollectionName,

        [Parameter(HelpMessage = 'Primary or secondary HA group')]
        [ValidateSet('primary', 'secondary')]
        [Alias('HAGroup', 'Group')]
        [string] $Station,

        [Parameter(HelpMessage = 'Server type')]
        [ValidateSet('apps', 'data')]
        [Alias('Type', 'Purpose', 'Designation')]
        [string] $ServerType
    )

    Begin {
        # IMPORT REQUIRED MODULES
        Import-Module (Join-Path -Path $(Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

        # CHANGE DIRECTORY TO CMSITE PSDRIVE
        if ( !$PSBoundParameters.ContainsKey('PSDrive') ) {
            $Site = (Get-PSDrive -PSProvider CMSite).Name
            if ( !$Site ) { Write-Error "No drives from PSProvider CMSite available."; Pop-Location; Break }
            elseif ( $Site.Count -gt 1 ) { Write-Error "Please specify CMSite."; Pop-Location; Break }
            else { Push-Location -Path ('{0}:' -f $Site) }
        } else { Push-Location -Path ('{0}:' -f $PSDrive) }

        # SET RESULTS VAR
        $Results = @()
    }

    Process {
        # LOOP ALL COLLECTIONNAMES
        foreach ( $Name in $CollectionName ) {

            # GET COLLECTIONS THAT MATCH THE GIVEN STATION AND SERVER TYPE
            if ( $Name -match $ServerType -AND $Name -match $Station ) {

                # ADD DEVICES TO RESULTS
                $Results += Get-CMCollectionMember -CollectionName $Name
            }
        }
    }

    End {
        # RETURN RESULTS
        $Results | Select-Object -ExpandProperty Name

        # RESET LOCATION
        Pop-Location
    }
}
