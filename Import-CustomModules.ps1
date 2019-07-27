# ==============================================================================
# Updated:      2018-11-01
# Created by:   Justin Johns
# Filename:     Import-CustomModules.ps1
# Version:      1.02
# ==============================================================================

<# =============================================================================
.SYNOPSIS
    Install modules
.DESCRIPTION
    This script will create a profile if not already available, add the module
    directory to the profile, then download custom modules.
.EXAMPLE
    PS C:\> Import-CustomModules.ps1
    Explanation of what the example does
.OUTPUTS
    Profile will be created for $PROFILE.CurrentUserAllHosts
    Module path will be added to new profile
    Modules will be added to profile path
============================================================================= #>

if ( -not (Test-Path $PROFILE.CurrentUserAllHosts) ) {

    $Date = (Get-Date).ToString("yyyy-MM-dd")

    # CREATE PROFILE
    New-Item -ItemType File -Path $PROFILE.CurrentUserAllHosts -Force

    # GET MODULE PATH
    $ModuleHome = Get-ChildItem $PROFILE.CurrentUserAllHosts | Select-Object -exp Directory

    # ADD MODULE PATH TO NEW PROFILE
    Set-Content -Path $PROFILE.CurrentUserAllHosts -Value '# =============================================================================='
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value "            Version: 1.00                             Updated: $Date"
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '# =============================================================================='
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value ''
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '# ADD MODULES TO PROFILE'
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$env:PSModulePath += '
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value """;$ModuleHome"" "
}


# CREATE WEBCLIENT AND URL LIST
$WC = New-Object System.Net.WebClient
$FileList = @(
    'https://github.com/johnsarie27/AWSReporting/AWSReporting.psd1'
    'https://github.com/johnsarie27/AWSReporting/AWSReporting.psm1'
    'https://github.com/johnsarie27/UtilityFunctions/UtilityFunctions.psd1'
    'https://github.com/johnsarie27/UtilityFunctions/UtilityFunctions.psm1'
    'https://github.com/johnsarie27/UtilityFunctions/EventTable.json'
    'https://github.com/johnsarie27/SecurityTools/SecurityTools.psd1'
    'https://github.com/johnsarie27/SecurityTools/SecurityTools.psm1'
)

# DOWNLOAD EACH FILE TO THE CORRESPONDING FOLDER
foreach ( $file in $FileList ) {

    $FileName = $file -split '/' | Select-Object -Last 1

    ## if ( $file -match '\.psd1' ) { $Folder = $FileName.TrimEnd(".psd1") }
    $Folder = $FileName.Substring(0, $file.LastIndexOf('.'))

    New-Item -ItemType Directory -Path (Join-Path -Path $ModuleHome.FullName -ChildPath $Folder) -Force

    $Output = Join-Path -Path $ModuleHome.FullName -ChildPath (Join-Path -Path $Folder -ChildPath $FileName)

    $WC.DownloadFile($file,$Output)
}
