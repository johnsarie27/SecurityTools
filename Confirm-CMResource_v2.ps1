<# =============================================================================
.NOTES
    This concept of having an individual function to validate each data type
    doesn't quite work unless you pass the PSDrive for the CMSite to each
    function. This is less efficient and more time consuming to code for and
    validate. Therefore, I am not currently using this file in the module.
============================================================================= #>

function Confirm-CMDevice {
    <# =========================================================================
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
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
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Device name')]
        [string] $DeviceName
    )

    # IMPORT SCCM MODULE
    Import-Module (Join-Path -Path (Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

    # VALIDATE
    if ( (Get-CMDevice).Name -contains $DeviceName ) { $Result = $true }
    else { $Result = $false }

    # RETURN
    return $Result
}

function Confirm-CMCollection {
    <# =========================================================================
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
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
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Device name')]
        [string] $CollectionName
    )

    # IMPORT SCCM MODULE
    Import-Module (Join-Path -Path (Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

    #
    if ( (Get-CMCollection).Name -contains $Arg ) { $Result = $true }
    else { $Result = $true }

    # RETURN
    return $Result
}

function Confirm-CMSoftwareUpdateGroup {
    <# =========================================================================
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
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
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Device name')]
        [string] $UpdateGroupName
    )

    # IMPORT SCCM MODULE
    Import-Module (Join-Path -Path (Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

    #
    if ( (Get-CMSoftwareUpdateGroup).LocalizedDisplayName -contains $UpdateGroupName ) { $Result = $true }
    else { $Result = $true }

    # RETURN
    return $Result
}
