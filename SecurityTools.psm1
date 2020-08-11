# IMPORT ALL FUNCTIONS
foreach ( $directory in @('Public', 'Private') ) {
    foreach ( $fn in (Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1") ) { . $fn.FullName }
    <# foreach ( $fn in (Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1") ) {
        try { . $fn.FullName }
        catch { Write-Error -Message ('Failed to load function [{0}] with error: {1}' -f $fn.Name, $_.Exception.Message) }
    } #>
}

# VARIABLES
$EventTable = Get-Content -Raw -Path $PSScriptRoot\Public\EventTable.json | ConvertFrom-Json

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
