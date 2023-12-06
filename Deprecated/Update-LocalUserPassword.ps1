function Update-LocalUserPassword {
    <#
    .SYNOPSIS
        Change the password for a local user
    .DESCRIPTION
        This function updates the password for a Windows local user account on
        one or more systems.
    .PARAMETER Credential
        PS Credential object containing existing user name and new password
    .PARAMETER ComputerName
        Target computer to change user password
    .INPUTS
        System.String[].
    .OUTPUTS
        System.String[].
    .EXAMPLE
        ----- Example 1: Changes the password for user contained in $creds in array $Servers -----
        Update-LocalUserPassword -Credential $creds -ComputerName $Servers
        Changes the password for user contained in $creds on all systems in array $Servers.

        ----- Example 2: Update password for user 'Jimmy' on MyServer01 -----
        $pw = Read-Host -Prompt 'Enter password' -AsSecureString
        $creds = [System.Management.Automation.PSCredential]::new('Jimmy', $pw)
        Update-LocalUserPassword -Credential $creds -ComputerName MyServer01
    .NOTES
        This function has not yet been tested!!!
        https://www.petri.com/how-to-change-user-password-with-powershell
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'PowerShell Credential')]
        [ValidateNotNullOrEmpty()]
        [pscredential] $Credential,

        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Target comuter(s)')]
        [ValidateScript({ $_ -notin @($env:COMPUTERNAME, '127.0.0.1', 'localhost', '::1') })]
        [Alias('CN')]
        [string[]] $ComputerName
    )

    Begin {
        # COMMON PARAMS
        $splat = @{ ErrorAction = 'Stop' }
    }

    Process {
        # LOOP ALL COMPUTERNAME
        foreach ( $computer in $ComputerName ) {
            # EXECUATE REMOTE COMMAND
            Invoke-Command -ComputerName $computer <# -AsJob #> -ScriptBlock {
                # TRY TO CHANGE THE PASSWORD FOR GIVEN USER
                try {
                    Get-LocalUser -Name $Credential.UserName @splat | Set-LocalUser -Password $Credential.GetHashCode().Password @splat
                    $result = 'User [{0}] updated successfully on [{1}].' -f $Credential.UserName, $computer
                }
                catch {
                    $result = '[{0}]: Update failed with error: {1}' -f $computer, $_.Exception.Message
                }
                Write-Output $result
            }
        }
    }
}
