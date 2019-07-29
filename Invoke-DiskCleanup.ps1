# ==============================================================================
# Updated:      2019-07-28
# Created by:   Justin Johns
# Filename:     Invoke-DiskCleanup.ps1
# Version:      0.0.1
# ==============================================================================

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
    http://www.theservergeeks.com/how-todisk-cleanup-using-powershell/
    https://stackoverflow.com/questions/28852786/automate-process-of-disk-cleanup-cleanmgr-exe-without-user-intervention
    https://github.com/adbertram/Random-PowerShell-Work/blob/master/File-Folder%20Management/Invoke-WindowsDiskCleanup.ps1
========================================================================= #>

$keyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches'

$subKeys = Get-ChildItem -Path $keyPath

# "StateFlags0001" AND "StateFlags0065" DON'T APPEAR TO BE USED IN WINDOWS 10
# I'M GUESSING THEY WERE FROM PERVIOUS VERSIONS OF WINDOWS?
$regParams = @{
    Name         = 'StateFlags'
    PropertyType = 'DWord'
    Value        = 2 # THIS MAY NEED TO BE A VALUE OF 1
    ErrorAction  = 'SilentlyContinue'
}

# SET VALUES FOR AUTOMATICALLY RUNNING CLEANUP MANAGER
foreach ($sk in $subKeys) {
    $regParams['Path'] = Join-Path -Path $keyPath -ChildPath $sk.PSChildName
    New-ItemProperty @regParams #| Out-Null
}

# RUN CLEANUP MANAGER
$diskCleanup = @{
    FilePath      = "cleanmgr.exe"
    ArgumentList  = "/sagerun:65" # BERTRAM IS USING "/sagerun:1" SO I'LL NEED TO LOOKUP THE VALUE DEFINITIONS
    Wait          = $true
    NoNewWindow   = $true
    #ErrorAction   = SilentlyContinue
    #WarningAction = SilentlyContinue
}
Start-Process @diskCleanup

# REMOVE PROPERTY FOR AUTOMATICALLY RUNNING CLEANUP MANAGER
foreach ($sk in $subKeys) {
    Remove-ItemProperty -Path $keyPath\$sk -Name $regParams.Name #| Out-Null
}

# Get-Process -Name cleanmgr, dismhost -ErrorAction SilentlyContinue | Wait-Process
