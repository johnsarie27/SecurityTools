# ==============================================================================
# Filename: SecurityTools.psm1
# Version:  0.1.3 | Updated: 2024-04-22
# Author:   Justin Johns
# ==============================================================================

# SET DIRECTORIES
$dirs = @("$PSScriptRoot\Public", "$PSScriptRoot\Private")

# DOT SOURCE ALL PS SCRIPTS
foreach ($file in (Get-ChildItem -Path $dirs -Filter '*.ps1')) { . $file.FullName }

# SET VARIABLES
New-Variable -Name 'EventTable' -Option ReadOnly -Value (
    Get-Content -Raw -Path "$PSScriptRoot\Private\EventTable.json" | ConvertFrom-Json
)
New-Variable -Name 'InfoModel' -Option ReadOnly -Value (
    Get-Content -Raw -Path "$PSScriptRoot\Private\InformationModel.json" | ConvertFrom-Json
)

# EXPORT MEMBERS
#Export-ModuleMember -Function *
# THESE ITEMS MUST BE LISTED BOTH IN THE MODULE MANIFEST AND BELOW TO BE MADE AVAILABLE AFTER LOADING THE MODULE
Export-ModuleMember -Variable * -Alias *
