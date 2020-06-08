# ==============================================================================
# Updated:      2020-06-08
# Created by:   Justin Johns
# Filename:     AD.types.ps1
# Version:      0.0.3
# ==============================================================================

#Requires -Modules activedirectory

# NEW SCRIPT PROPERTIES
$propHash = @{
    DaysSincePwLastSet = { (New-TimeSpan -Start $this.PasswordLastSet -End (Get-Date)).Days }
    OU                 = { $this.CanonicalName -split '/' | Select-Object -Skip 1 -First 1 }
    DaysSinceLastLogon = { (New-TimeSpan -Start $this.LastLogonDate -End (Get-Date)).Days }
    ExpiryDate         = { [datetime]::FromFileTime($this."msDS-UserPasswordExpiryTimeComputed") }
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

# UPDATE WITH PS1XML
Update-TypeData -AppendPath "$PSScriptRoot\Ec2.types.ps1xml"

# NEW METHOD
$params = @{
    TypeName   = "Microsoft.ActiveDirectory.Management.ADUser"
    MemberType = "ScriptMethod"
    MemberName = "GetStatus"
    Value      = { Get-ADUser -Identity $this.SamAccountName -Properties "*", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property UserStatus }
    Force      = $true
}

Update-TypeData @params
