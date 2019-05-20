function Get-ADUserStatus {
    <# =========================================================================
    .SYNOPSIS
        Get user account statistics
    .DESCRIPTION
        This script will return the account status information for a given
        active directory account.
    .PARAMETER UserName
        User name of target user.
    .PARAMETER PartialName
        First or last name of user account.
    .PARAMETER DomainController
        Specify Domain Controller to use for query.
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ADUserStatus -PartialName John
        Get Active Directory User Account status for user with John.
    .NOTES
        https://blogs.technet.microsoft.com/poshchap/2014/02/21/one-liner-get-a-list-of-ad-users-password-expiry-dates/
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = 'username')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'username', HelpMessage = 'User account name')]
        [ValidateScript( { Get-ADUser -Identity $_ })]
        [Alias('User')]
        [string] $UserName,

        [Parameter(Mandatory, ParameterSetName = 'fragment', HelpMessage = "Part of user's name")]
        [ValidateScript( { (Get-ADUser -Filter * -Properties *).CN -match "$_" })]
        [Alias('Name', 'Fragment')]
        [string] $PartialName,
        
        [Parameter(HelpMessage = 'Hostname of Domain Controller')]
        [ValidateScript( { Test-Connection -ComputerName $_ -Quiet -Count 1 })]
        [Alias('DC')]
        [string] $DomainController
    )

    Begin {
        # CHECK FOR USERNAME
        if ( $PSBoundParameters.ContainsKey('UserName') ) { $SearchName = $UserName }
        
        # CHECK FOR PARTIAL NAME
        if ( $PSBoundParameters.ContainsKey('PartialName') ) {
            $SearchName = Get-ADUser -Filter * -Properties "SamAccountName", "CN" |
                Where-Object "CN" -Match $PartialName | Select-Object -EXP SamAccountName

            # LIST THE USERS RETURNED AND ALLOW SELECTION
            if ( $SearchName.Count -gt 1 ) { $SearchName = Get-Object -ObjectList $SearchName -String }
            # THERE SHOULD BE NO ELSE STATEMENT IF THE PARAMETER VALIDATION WORKED
        }

        # ACTIVE DIRECTORY PARAMETERS
        $ADParams = @{
            Identity   = $SearchName
            Properties = "*", "msDS-UserPasswordExpiryTimeComputed"
        }

        # ADD DOMAIN CONTROLLER
        if ( $PSBoundParameters.ContainsKey('DomainController') ) { $ADParams['Server'] = $DomainController }

        # $Filter = { CN -match $Name Enabled -eq $True -and PasswordNeverExpires -eq $False }
        $Properties = @(
            # ACCOUNT INFO
            'CN',
            'EmailAddress',
            'Created',
            'Enabled',
            'LastLogonDate',
            @{N = 'DaysSinceLastLogon'; E = {(New-TimeSpan -Start $_.LastLogonDate -End (Get-Date)).Days}}
            # LOCKOUT INFO
            'LockedOut',
            'AccountLockoutTime',
            # PASSWORD EXPIRIATION
            'PasswordExpired',
            @{Name = "ExpiryDate"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
            # BAD PASSWORDS
            'LastBadPasswordAttempt',
            'BadLogonCount',
            #'logonCount',
            'Modified',
            'PasswordLastSet'
            # OTHER
            #@{N='ExpiresTime';E={[datetime]::FromFileTime($_.accountExpires)}},
            #@{N='BadPwTime';E={[datetime]::FromFileTime($_.badPasswordTime)}},
            #'badPwdCount',
            #'CannotChangePassword',
        )
    }
    
    Process {
        # GET DATA
        Get-ADUser @ADParams | Select-Object -Property $Properties
    }
}
