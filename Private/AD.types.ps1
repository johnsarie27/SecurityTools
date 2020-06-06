# ==============================================================================
# Updated:      2020-06-06
# Created by:   Justin Johns
# Filename:     AD.types.ps1
# Version:      0.0.1
# ==============================================================================

#Requires -Modules activedirectory

# NEW SCRIPT PROPERTIES
$propHash = @{
    DaysSincePwLastSet = { (New-TimeSpan -Start $this.PasswordLastSet -End (Get-Date)).Days }
    OU                 = { $this.CanonicalName -split '/' | Select-Object -Skip 1 -First 1 }
    DaysSinceLogon     = { (New-TimeSpan -Start $this.LastLogonDate -End (Get-Date)).Days }
}

$params = @{
    TypeName   = "Microsoft.ActiveDirectory.Management.ADUser"
    MemberType = "ScriptProperty"
    MemberName = ""
    Value      = ""
    Force      = $true
}

$prophash.GetEnumerator() | ForEach-Object {
    $params['MemberName'] = $_.key
    $params['Value'] = $_.value
    Update-TypeData @params
}

# NEW ALIAS PROPERTIES
$params['MemberType'] = "AliasProperty"

$propHash = @{
    Name     = "CN"
    Type     = "Department"
    Username = "SamAccountName"
    Role     = "Title"
}

$prophash.GetEnumerator() | ForEach-Object {
    $params['MemberName'] = $_.key
    $params['Value'] = $_.value
    Update-TypeData @params
}