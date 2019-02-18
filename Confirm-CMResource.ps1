function Confirm-CMResource {
    <# =========================================================================
    .SYNOPSIS
        Validate existence of specified CM resource
    .DESCRIPTION
        Validate CM resource by checking for its existence in the given CM Site.
    .PARAMETER abc
        Parameter description (if any)
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .NOTES
        1. Decide on $Collection or $CollectionName
        2. 
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'drive', HelpMessage = 'PS Drive name')]
        [Parameter(ParameterSetName = 'device',     HelpMessage = 'PS Drive name')]
        [Parameter(ParameterSetName = 'collection', HelpMessage = 'PS Drive name')]
        [Parameter(ParameterSetName = 'update',     HelpMessage = 'PS Drive name')]
        #[ValidateScript( { $_ -NotMatch ':' })]
        [string] $PSDrive,
    
        [Parameter(Mandatory, ParameterSetName = 'device', HelpMessage = 'Device name')]
        [string] $Device, # DeviceName

        [Parameter(Mandatory, ParameterSetName = 'collection', HelpMessage = 'Collection name')]
        [string] $Collection, # CollectionName

        [Parameter(Mandatory, ParameterSetName = 'update', HelpMessage = 'Update group name')]
        [string] $UpdateGroupName
    )

    # INITIALIZE RETURN VALUE
    $Return = $false # $PSBoundParameters.PSDrive

    # IMPORT SCCM MODULE
    Import-Module (Join-Path -Path (Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

    # VALIDATE AND CHANGE PSDRIVE TO SCCM SITE
    $Site = (Get-PSDrive -PSProvider CMSite).Name

    if ( $PSBoundParameters.ContainsKey('PSDrive') ) {
        if ( $Site -contains $PSDrive ) { Push-Location -Path ('{0}:' -f $PSDrive); $Return = $true }
        else { Write-Verbose ('Unable to validate drive "{0}"' -f $PSDrive); $Return ; Break }
    } else {
        if ( !$Site ) { Write-Error "No drives from PSProvider CMSite available."; Break }
        elseif ( $Site.Count -gt 1 ) { Write-Error "Please specify CMSite."; Break }
        else { Push-Location -Path ('{0}:' -f $Site) }
    }
    
    # VALIDATE OTHER RESOURCES
    $Param = $PSBoundParameters.Keys | Where-Object { $_ -ne 'PSDrive' }
    $Arg = $PSBoundParameters.$Param
    Write-Verbose $Param
    
    $Return = switch ( $Param ) { # CHANGED FROM $PSBoundParameters.Keys TO $Param
        Device {
            if ( (Get-CMDevice).Name -contains $Arg ) { $true } # CHANGED FROM $PSBoundParameters.Values TO $Arg
        }
        Collection {
            if ( (Get-CMCollection).Name -contains $Arg ) { $true }
        }
        UpdateGroupName {
            if ( (Get-CMSoftwareUpdateGroup).LocalizedDisplayName -contains $Arg ) { $true }
        }
        #Default {}
    }

    # RETURN
    Pop-Location
    $Return
}
