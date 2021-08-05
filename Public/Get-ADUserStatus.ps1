function Get-ADUserStatus {
    <# =========================================================================
    .SYNOPSIS
        Get user status
    .DESCRIPTION
        Get user status information including password and logon details
    .PARAMETER Identity
        AD User Identity
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ADUserStatus -Identity jsmith
        Gets the status information for user jsmith
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'AD User Identity')]
        [ValidateNotNullOrEmpty()]
        [string] $Identity
    )
    Process {
        $props = @(
            'CN'
            'EmailAddress'
            'Created'
            'Enabled'
            'LastLogonDate'
            'DaysSinceLastLogon'
            'LockedOut'
            'AccountLockoutTime'
            'PasswordExpired'
            'ExpiryDate'
            'LastBadPasswordAttempt'
            'BadLogonCount'
            'Modified'
            'PasswordLastSet'
        )

        Get-ADUser -Identity $Identity -Properties "*", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property $props
    }
}