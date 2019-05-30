function New-SoftwarePatchGroup {
    <# =========================================================================
    .SYNOPSIS
        Create a new Software Update Group for monthly patches
    .DESCRIPTION
        Create a new Software Update Group for monthly patches using the same
        saved search and logic as the SCCM GUI
    .PARAMETER PSDrive
        Site of SCCM installation
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> New-SoftwarePatchGroup -PSDrive abc
        Create a new patch group in site abc
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'PSDrive for Configuration Manager')]
        [ValidateScript({ Confirm-CMDrive -PSDrive $_ })]
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

    # CREATE LIST OF UPDATES FOR NEW UPDATE GROUP
    $Pattern = '(Critical\sUpdates|Feature\sPacks|Security\sUpdates|Service\sPacks|Tools|Update\sRollups|Updates|Upgrades)'
    $NewUpdates = @()
    foreach ( $SU in Get-CMSoftwareUpdate -Fast ) {
        if (
            $SU.IsSuperseded -EQ $false -and $SU.IsExpired -eq $false -and`
            $SU.LocalizedDisplayName -notmatch 'preview' -and`
            $SU.LocalizedCategoryInstanceNames -match $Pattern
        )
        { $NewUpdates += $SU }
    }

    Try {
        # CREATE NEW UPDATE GROUP
        $Splat = @{
            Name             = '{0} Update Rollup' -f (Get-Date -Format "yyyy-MM")
            Description      = '{0} {1} Updates' -f (Get-Date -UFormat %B), (Get-Date -Format "yyyy")
            SoftwareUpdateId = $NewUpdates.CI_ID
            #UpdateId    = $NewUpdates.CI_ID # UPDATEID IS BEING DEPRECATED.
            ErrorAction      = 'Stop'
        }
        $NewUpdateGroup = New-CMSoftwareUpdateGroup @Splat

        # DOWNLOAD UPDATES FOR GROUP
        $Splat = @{
            SoftwareUpdateGroupId  = $NewUpdateGroup.CI_ID
            #SoftwareUpdateGroupName = $NewUpdateGroup.LocalizedDisplayName
            #SoftwareUpdateGroup = Get-SoftwareUpdateGroup -Id $NewUpdateGroup.CI_ID
            SoftwareUpdateLanguage = 'English'
            DeploymentPackageName  = 'Monthly Updates'
            ErrorAction            = 'Stop'
        }
        Save-CMSoftwareUpdate @Splat -WarningAction SilentlyContinue
    }
    Catch {
        $Msg = $_.Exception.Message
    }
    Finally {
        if ( $Msg ) { Write-Error $Msg }
        else {
            $NewUpdateGroup
            #Write-Ouput ('Update group [{0}] created successfully and patches downloaded' -f $NewUpdateGroup.LocalizedDisplayName)
        }
        Pop-Location
    }
}
