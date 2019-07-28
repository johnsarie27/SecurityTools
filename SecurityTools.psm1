# ==============================================================================
# Updated:      2019-07-28
# Created by:   Justin Johns
# Filename:     SecurityTools.psm1
# Link:         https://github.com/johnsarie27/SecurityTools
# ==============================================================================

# IMPORT SCANNING AND REPORTING FUNCTIONS
. $PSScriptRoot\Export-ScanReportAggregate.ps1
. $PSScriptRoot\Export-ScanReportSummary.ps1
. $PSScriptRoot\Get-ADUserReport.ps1
. $PSScriptRoot\Export-SQLVAReport.ps1
. $PSScriptRoot\Export-SQLVAReportAggregate.ps1

# PERFORMANCE FUNCTIONS
. $PSScriptRoot\Out-MeasureResult.ps1
. $PSScriptRoot\Test-Performance.ps1

# IMPORT FUNCTIONS
. $PSScriptRoot\Compare-FileHash.ps1
. $PSScriptRoot\Compare-Lists.ps1
. $PSScriptRoot\Convert-SecureKey.ps1
. $PSScriptRoot\Convert-TimeZone.ps1
. $PSScriptRoot\Deploy-Script.ps1
. $PSScriptRoot\Format-Disk.ps1
. $PSScriptRoot\Get-DirItemAges.ps1
. $PSScriptRoot\Get-DirStats.ps1
. $PSScriptRoot\Get-SavedHistory.ps1
. $PSScriptRoot\Get-ServiceAccount.ps1
. $PSScriptRoot\Get-TalkingApps.ps1
. $PSScriptRoot\Get-UncPath.ps1
. $PSScriptRoot\Install-ModuleFromPackage.ps1
. $PSScriptRoot\Remove-Files.ps1
. $PSScriptRoot\Uninstall-AllModules.ps1
. $PSScriptRoot\Write-Log.ps1

# IMPORT WINDOWS FUNCTIONS
. $PSScriptRoot\Export-ExcelBook.ps1
. $PSScriptRoot\Find-ServerPendingReboot.ps1
. $PSScriptRoot\Get-ActiveGWUser.ps1
. $PSScriptRoot\Get-ActiveSmartCardCert.ps1
. $PSScriptRoot\Get-ADUserStatus.ps1
. $PSScriptRoot\Get-LoggedOnUser.ps1
. $PSScriptRoot\Get-RemoteBitLocker.ps1
. $PSScriptRoot\Get-Software.ps1
. $PSScriptRoot\Get-WinLogs.ps1
. $PSScriptRoot\Invoke-SDelete.ps1
. $PSScriptRoot\Revoke-SupersededCert.ps1
. $PSScriptRoot\Save-KBFile.ps1
. $PSScriptRoot\Update-LocalUserPassword.ps1

# INTERNAL FUNCTIONS
. $PSScriptRoot\Get-File.ps1
. $PSScriptRoot\Get-Folder.ps1
. $PSScriptRoot\Get-Object.ps1
. $PSScriptRoot\Test-DestinationPath.ps1

# DEPRECATE
. $PSScriptRoot\ConvertTo-DbScanReport.ps1

# VARIABLES
$EventTable = Get-Content -Raw -Path $PSScriptRoot\EventTable.json | ConvertFrom-Json

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
