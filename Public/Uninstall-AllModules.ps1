function Uninstall-AllModules {
    <#
    .SYNOPSIS
        Uninstall all dependent modules
    .DESCRIPTION
        Uninstall a module and all dependent modules
    .PARAMETER TargetModule
        TargetModule
    .PARAMETER Version
        Version
    .PARAMETER Force
        Force
    .PARAMETER WhatIf
        WhatIf
    .EXAMPLE
        PS C:\> Uninstall-AllModules -TargetModule AzureRM -Version 4.4.1 -Force
        Remove an older version of Azure PowerShell.
    .INPUTS
        System.String.
    .OUTPUTS
        None.
    .NOTES
        This function was written by Microsoft. See link above for details.
        https://docs.microsoft.com/en-us/powershell/azure/uninstall-azurerm-ps?view=azurermps-6.13.0
    #>
    Param(
        [Parameter(Mandatory)]
        [System.String] $TargetModule,

        [Parameter(Mandatory)]
        [System.String] $Version,

        [System.String] $Force,

        [System.String] $WhatIf
    )

    $AllModules = @()

    'Creating list of dependencies...'
    $target = Find-Module $TargetModule -RequiredVersion $version
    $target.Dependencies | ForEach-Object {
        if ($_.requiredVersion) {
            $AllModules += New-Object -TypeName psobject -Property @{name = $_.name; version = $_.requiredVersion }
        }
        else {
            # Assume minimum version
            # Minimum version actually reports the installed dependency
            # which is used, not the actual "minimum dependency." Check to
            # see if the requested version was installed as a dependency earlier.
            $candidate = Get-InstalledModule $_.name -RequiredVersion $version
            if ($candidate) {
                $AllModules += New-Object -TypeName psobject -Property @{name = $_.name; version = $version }
            }
            else {
                Write-Warning ("Could not find uninstall candidate for {0}:{1} - module may require manual uninstall" -f $_.name, $version)
            }
        }
    }
    $AllModules += New-Object -TypeName psobject -Property @{name = $TargetModule; version = $Version }

    foreach ($module in $AllModules) {
        Write-Output ('Uninstalling {0} version {1}...' -f $module.name, $module.version)
        try {
            Uninstall-Module -Name $module.name -RequiredVersion $module.version -Force:$Force -ErrorAction Stop -WhatIf:$WhatIf
        }
        catch {
            Write-Output ("`t" + $_.Exception.Message)
        }
    }
}
