# ==============================================================================
# Filename: SecurityTools.psm1
# Version:  0.1.2 | Updated: 2024-01-22
# Author:   Justin Johns
# ==============================================================================

# IMPORT ALL FUNCTIONS
foreach ( $directory in @('Public', 'Private') ) {
    foreach ( $fn in (Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1") ) { . $fn.FullName }
}

# VARIABLES
New-Variable -Name 'EventTable' -Option ReadOnly -Value (
    Get-Content -Raw -Path "$PSScriptRoot\Private\EventTable.json" | ConvertFrom-Json
)

New-Variable -Name 'InfoModel' -Option ReadOnly -Value (
    Get-Content -Raw -Path "$PSScriptRoot\Private\InformationModel.json" | ConvertFrom-Json
)

# EXPORT MEMBERS
#Export-ModuleMember -Function *
# THESE ITEMS MUST BE LISTED BOTH IN THE MODULE MANIFEST AND BELOW TO BE MADE AVAILABLE AFTER LOADING THE MODULE
Export-ModuleMember -Variable *
Export-ModuleMember -Alias *
