function Update-LocalUserPassword {
    <# =========================================================================
    .SYNOPSIS
        Change the password for a local user
    .DESCRIPTION
        This function updates the password for a Windows local user account on
        one or more systems.
    .PARAMETER UserName
        User to change password
    .PARAMETER SecurePassword
        New password entered as Secure String
    .PARAMETER ComputerName
        Target computer to change user password
    .PARAMETER FilePath
        Path to CLIXML file containing new password
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
    [CmdletBinding(DefaultParameterSetName = 'input', SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory, HelpMessage = 'User account name')]
        [ValidateScript({ (Get-LocalUser).Name -contains $_ })]
        [string] $UserName,

        [Parameter(Mandatory, HelpMessage = 'New password', ParameterSetName = 'input')]
        [ValidateScript({ $_.Length -gt 13 })]
        [SecureString] $SecurePassword,

        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Target comuter(s)')]
        [ValidateScript({ $_ -notin @($env:COMPUTERNAME, '127.0.0.1', 'localhost', '::1') })]
        [string[]] $ComputerName,

        [Parameter(Mandatory, HelpMessage = 'Clixml file containing SecureString', ParameterSetName = 'stored')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.xml" })]
        [string] $FilePath
    )

    Begin {
        # CHECK FOR FILEPATH PARAM
        if ( $PSBoundParameters.ContainsKey('FilePath') ) {
            $password = (Convert-SecureKey -Retrieve -Path $FilePath).Password
        }
        else {
            $password = $SecurePassword
        }

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
                    Get-LocalUser -Name $UserName @splat | Set-LocalUser -Password $password @splat
                    $result = 'User [{0}] updated successfully on [{1}].' -f $UserName, $computer
                }
                catch {
                    $result = $_.Exception.Message
                }
                Write-Output $result
            }
        }
    }
}
