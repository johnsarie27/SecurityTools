function Confirm-CMDrive {
    <# =========================================================================
    .SYNOPSIS
        Validate PSDrive
    .DESCRIPTION
        Validate PSDrive
    .PARAMETER PSDrive
        PSDrive object for Configuration Manager
    .INPUTS
        None
    .OUTPUTS
        System.Boolean
    .EXAMPLE
        PS C:\> Confirm-CMDrive -PSDrive 764
        Returns true if PSDrive 764 exists and is of type CMSite. Returns false
        otherwise
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]

    Param(
        [Parameter(Mandatory, HelpMessage = 'PS Drive name')]
        [string] $PSDrive
    )
    # IMPORT SCCM MODULE
    Import-Module (Join-Path -Path (Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

    # VALIDATE PSDRIVE
    if ( (Get-PSDrive -PSProvider CMSite).Name -contains $PSDrive ) { $Result = $true }
    else { $Result = $false }

    # RETURN
    return $Result
}

function Confirm-CMResource {
    <# =========================================================================
    .SYNOPSIS
        Validate existence of specified CM resource
    .DESCRIPTION
        Validate CM resource by checking for its existence in the given CM Site.
    .PARAMETER PSDrive
        CMSite to validate
    .PARAMETER DeviceName
        Name of device to validate
    .PARAMETER CollectionName
        Name of collection to validate
    .PARAMETER UpdateGroupName
        Name of UpdateGroup to validate
    .INPUTS
        None
    .OUTPUTS
        System.ValueType.Boolean
    .EXAMPLE
        PS C:\> Confirm-CMResource -DevinceName MyServer
        Validate that device "MyServer" exists within SCCM
    .NOTES
        1.
    ========================================================================= #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]

    Param(
        [Parameter(HelpMessage = 'PS Drive name')]
        [ValidateScript({ Confirm-CMDrive -PSDrive $_ })]
        [string] $PSDrive,

        [Parameter(Mandatory, ParameterSetName = 'device', HelpMessage = 'Device name')]
        [string] $DeviceName,

        [Parameter(Mandatory, ParameterSetName = 'collection', HelpMessage = 'Collection name')]
        [string] $CollectionName,

        [Parameter(Mandatory, ParameterSetName = 'update', HelpMessage = 'Update group name')]
        [string] $UpdateGroupName
    )

    # INITIALIZE RETURN VALUE
    $Return = $false

    # IMPORT SCCM MODULE
    Import-Module (Join-Path -Path (Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

    # CHANGE LOCATION TO CMSITE
    if ( !$PSBoundParameters.ContainsKey('PSDrive') ) {
        $Site = (Get-PSDrive -PSProvider CMSite).Name
        if ( !$Site ) { Write-Error "No drives from PSProvider CMSite available."; Break }
        elseif ( $Site.Count -gt 1 ) { Write-Error "Please specify CMSite."; Break }
        else { $PSDrive = $Site }
    }
    Push-Location -Path ('{0}:' -f $PSDrive)

    # VALIDATE OTHER RESOURCES
    $Param = $PSBoundParameters.Keys | Where-Object { $_ -ne 'PSDrive' }
    if ( !$Param ) { $Return; Pop-Location; Break }
    else { $Arg = $PSBoundParameters.$Param }
    Write-Verbose $Param

    $Return = switch ( $Param ) { # CHANGED FROM $PSBoundParameters.Keys TO $Param
        DeviceName {
            if ( (Get-CMDevice).Name -contains $Arg ) { $true } # CHANGED FROM $PSBoundParameters.Values TO $Arg
        }
        CollectionName {
            if ( (Get-CMCollection).Name -contains $Arg ) { $true }
        }
        UpdateGroupName {
            if ( (Get-CMSoftwareUpdateGroup).LocalizedDisplayName -contains $Arg ) { $true }
        }
        Default { $false }
    }

    # RETURN
    Pop-Location
    $Return
}