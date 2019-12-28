# IMPORT ALL FUNCTIONS
Get-ChildItem -Path "$PSScriptRoot\*.ps1" | ForEach-Object -Process { . $_.FullName }

# VARIABLES
$EventTable = Get-Content -Raw -Path $PSScriptRoot\EventTable.json | ConvertFrom-Json

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
