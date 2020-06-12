# ==============================================================================
# Updated:      2019-03-13
# Created by:   Justin Johns
# Filename:     Install-ModuleFromPackage.ps1
# Version:      0.0.2
# ==============================================================================

function Install-ModuleFromPackage {
    <# =========================================================================
    .SYNOPSIS
        Install module from GitHub download
    .DESCRIPTION
        Install module from GitHub download
    .PARAMETER Path
        Path to zip file
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Install-ModuleFromPackage -Path .\SecurityTools.zip
        Extracts contents of zip and copies to Windows module directory then removes zip.
    .NOTES
        General notes
    ========================================================================= #>
    Param(
        [Parameter(Mandatory, HelpMessage = 'Path to module archive file')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.zip" })]
        [Alias('DataFile', 'File')]
        [string] $Path
    )

    # SET VARS
    $ZipName = (Split-Path -Path $Path -Leaf).TrimEnd('.zip')
    $ModuleName = $ZipName.Substring(0, $ZipName.IndexOf('-'))
    $TempPath = Join-Path -Path "C:\ExtractTemp" -ChildPath (New-Guid).Guid
    $ModulePath = Join-Path -Path "C:\Program Files\WindowsPowerShell\Modules" -ChildPath $ModuleName

    # UNZIP MODULE
    Expand-Archive -Path $Path -DestinationPath $TempPath

    # IF NOT EXISTS CREATE NEW MODULE FOLDER
    if ( !(Test-Path -Path $ModuleName) ) { New-Item -Path $ModulePath -ItemType Directory -Force }

    # COPY FILES TO MODULE FOLDER WITH OVERWRITE
    Copy-Item -Path (Join-Path -Path $TempPath -ChildPath ('{0}\*' -f $ZipName)) -Destination $ModulePath -Recurse -Force

    # DELETE TEMP FILES
    Remove-Item -Path (Split-Path -Path $TempPath -Parent) -Recurse -Force

    # DELETE OLD MODULE ZIP AND COPY IN NEW
    Remove-Item -Path ('{0}\*' -f $ModulePath) -Include "*.zip" -EA SilentlyContinue
    Move-Item -Path $Path -Destination $ModulePath

    # GET SCRIPT FILES
    $Scripts = Get-ChildItem -Path $ModulePath -Include @("*.ps1*", "*.psm1") -Recurse

    # SIGN SCRIPT FILES
    Set-AuthenticodeSignature -FilePath $Scripts.FullName -Certificate $MyCert
}
