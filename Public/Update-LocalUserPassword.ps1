function Update-LocalUserPassword {
    <# =========================================================================
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
        PS C:\> Update-LocalUserPassword -User JSmith -CN $Servers
        Change the password for user JSmith on all systems in array $Servers.
        This will prompt for the new password as Secure String.
    .NOTES
        This function has not yet been tested!!!
        https://www.petri.com/how-to-change-user-password-with-powershell
    ========================================================================= #>
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
                    $result = $_.Exception.Message
                }
                Write-Output $result
            }
        }
    }
}
