# ==============================================================================
# Updated:      2019-02-24
# Created by:   Justin Johns
# Filename:     SecurityTools.psm1
# Link:         https://github.com/johnsarie27/SecurityTools
# ==============================================================================

# IMPORT SYSTEM CENTER FUNCTIONS
. $PSScriptRoot\New-DeploymentGroup.ps1
. $PSScriptRoot\New-PatchDeployment.ps1
. $PSScriptRoot\New-UpdateGroup.ps1
. $PSScriptRoot\Get-DeviceCollections.ps1
. $PSScriptRoot\Confirm-CMResource.ps1

# IMPORT SCANNING AND REPORTING FUNCTIONS
. $PSScriptRoot\ConvertTo-DbScanReport.ps1
. $PSScriptRoot\New-AggregateReport.ps1
. $PSScriptRoot\New-SummaryReport.ps1
. $PSScriptRoot\New-ADUserReport.ps1

# IMPORT WINDOWS FUNCTIONS
. $PSScriptRoot\Get-WinLogs.ps1
. $PSScriptRoot\Get-ActiveGWUsers.ps1
. $PSScriptRoot\Get-ADUserStatus.ps1
. $PSScriptRoot\Get-RemoteBitLocker.ps1
. $PSScriptRoot\Deploy-Script.ps1
. $PSScriptRoot\Get-ServiceAccounts.ps1

# IMPORT OTHER FUNCTIONS
. $PSScriptRoot\Invoke-SDelete.ps1
. $PSScriptRoot\Get-HAGroup.ps1

# VARIABLES
$EventTable = Get-Content -Raw -Path $PSScriptRoot\EventTable.json | ConvertFrom-Json

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
