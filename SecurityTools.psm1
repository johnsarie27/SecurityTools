# IMPORT ALL FUNCTIONS
foreach ( $directory in @('Public', 'Private') ) {
    Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1" | ForEach-Object -Process { . $_.FullName }
}

# VARIABLES
$EventTable = Get-Content -Raw -Path $PSScriptRoot\Public\EventTable.json | ConvertFrom-Json

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
