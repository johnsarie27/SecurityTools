# ==============================================================================
# Updated:      2019-06-09
# Created by:   Justin Johns
# Filename:     SecurityTools.psm1
# Link:         https://github.com/johnsarie27/SecurityTools
# ==============================================================================

# IMPORT SYSTEM CENTER FUNCTIONS
. $PSScriptRoot\New-CollectionPatchTime.ps1
. $PSScriptRoot\New-PatchDeployment.ps1
. $PSScriptRoot\New-SoftwarePatchGroup.ps1
. $PSScriptRoot\Get-DeviceCollection.ps1
. $PSScriptRoot\Confirm-CMResource.ps1

# IMPORT SCANNING AND REPORTING FUNCTIONS
. $PSScriptRoot\Export-ScanReportAggregate.ps1
. $PSScriptRoot\Export-ScanReportSummary.ps1
. $PSScriptRoot\Get-ADUserReport.ps1
. $PSScriptRoot\Export-SQLVAReport.ps1
. $PSScriptRoot\Export-SQLVAReportAggregate.ps1

# IMPORT WINDOWS FUNCTIONS
. $PSScriptRoot\Get-WinLogs.ps1
. $PSScriptRoot\Get-ActiveGWUser.ps1
. $PSScriptRoot\Get-ADUserStatus.ps1
. $PSScriptRoot\Get-RemoteBitLocker.ps1
. $PSScriptRoot\Deploy-Script.ps1
. $PSScriptRoot\Get-ServiceAccount.ps1
. $PSScriptRoot\Get-ActiveSmartCardCert.ps1
. $PSScriptRoot\Revoke-SupersededCert.ps1

# IMPORT OTHER FUNCTIONS
. $PSScriptRoot\Invoke-SDelete.ps1
. $PSScriptRoot\Get-HAGroup.ps1

# INTERNAL FUNCTIONS
. $PSScriptRoot\Confirm-ValidPath.ps1

# DEPRECATE
. $PSScriptRoot\ConvertTo-DbScanReport.ps1

# VARIABLES
# $EventTable = Get-Content -Raw -Path $PSScriptRoot\EventTable.json | ConvertFrom-Json

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
