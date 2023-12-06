function Update-LocalUserPw {
    <#====
    .SYNOPSIS
        Update local user password
    .DESCRIPTION
        Update the password for a local Windows User.
    .PARAMETER Credential
        PS Credential object containing existing user name and new password
    .PARAMETER ComputerName
        Target computer to change user password
    .INPUTS
        System.String[].
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Update-LocalUserPw -Credential $creds -CN Server01
        Update password for user contained in $creds on Server01.
    .NOTES
        -- CREATE SECURE CREDS EXAMPLE --
        $pw = Read-Host -Prompt 'Enter password' -AsSecureString
        $creds = [System.Management.Automation.PSCredential]::new('Jimmy', $pw)
        $credsFile = $creds | Export-Clixml -Path "C:\Temp\creds.xml"
        -- CMDLETS --
        Using "Get-LocalUser -Name "$UserName" | Set-LocalUser -Password $Pw" does
        not work with PowerShell versions prior to 5.1.
    ====#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, HelpMessage = 'PowerShell Credential')]
        #[ValidateScript({ (Get-LocalUser).Name -contains $_.UserName })]
        [ValidateNotNullOrEmpty()]
        [pscredential] $Credential,

        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Target comuter(s)')]
        [Alias('CN')]
        [string[]] $ComputerName
    )

    # SETUP LOG
    $logFile = '{0}\Desktop\{1:yyyyMMddTHHmmss}_PwUpdateLog.log' -f $HOME, (Get-Date)
    if ( -not (Test-Path -Path $logFile) ) { New-Item -Path $logFile -ItemType File -Force | Out-Null }
    Add-Content -Path $logFile -Value ('Begin Logging: {0:yyyyMMddTHHmmss}' -f (Get-Date))

    # UPDATE PASSWORD
    foreach ( $computer in $ComputerName ) {
        $msg = '{0:yyyyMMddTHHmmss} -- Computer [{1,-14}] -- ' -f (Get-Date), $computer
        $user = '{0}/{1}' -f $computer, $Credential.UserName

        try {
            # SET PASSWORD
            ([adsi]("WinNT://" + $user)).SetPassword($Credential.GetNetworkCredential().Password)
            # LOG RESULT
            $msg += "User updated successfully."
        }
        catch {
            $msg += $_.Exception.Message
        }
        finally {
            Write-Output $msg
            Add-Content -Path $logFile -Value $msg
        }
    }

    # END LOG
    Add-Content -Path $logFile -Value ('{0:yyyyMMddTHHmmss} -- Job completed.' -f (Get-Date))
}
