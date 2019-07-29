# ==============================================================================
# Updated:      2019-07-28
# Created by:   Justin Johns
# Filename:     Invoke-DiskCleanup.ps1
# Version:      0.0.1
# ==============================================================================

<#
.NOTES
    http://www.theservergeeks.com/how-todisk-cleanup-using-powershell/
    https://stackoverflow.com/questions/28852786/automate-process-of-disk-cleanup-cleanmgr-exe-without-user-intervention

#>

#$HKLM = [UInt32] "0x80000002"
$keyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches'

$subKeys = Get-ChildItem -Path $keyPath

$regParams = @{
    Name         = 'StateFlags' #"StateFlags0065" #"StateFlags0001"
    PropertyType = 'DWORD'
    Value        = 2
    ErrorAction  = 'SilentlyContinue'
}

# SET VALUES FOR AUTOMATICALLY RUNNING CLEANUP MANAGER
foreach ($sk in $subKeys) {
    $regParams['Path'] = Join-Path -Path $keyPath -ChildPath $sk.PSChildName
    New-ItemProperty @regParams #| Out-Null
}

# RUN CLEANUP MANAGER
$cleanParams = @{
    FilePath      = "cleanmgr.exe"
    ArgumentList  = "/sagerun:65"
    Wait          = $true
    NoNewWindow   = $true
    #ErrorAction   = SilentlyContinue
    #WarningAction = SilentlyContinue
}
Start-Process @cleanParams

# REMOVE PROPERTY FOR AUTOMATICALLY RUNNING CLEANUP MANAGER
foreach ($sk in $subKeys) {
    Remove-ItemProperty -Path $keyPath\$sk -Name $regParams.Name #| Out-Null
}