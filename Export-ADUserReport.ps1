function Export-ADUserReport {
    <# =========================================================================
    .SYNOPSIS
        Generate new Active Directory report
    .DESCRIPTION
        This function generates a list of objects that can be used to review
        account access and login information.
    .PARAMETER SavePath
        Path to folder of save location.
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Export-ADUserReport
        Get report of Active Directory users
    .EXAMPLE
        PS C:\> Export-ADUserReport -Path $HOME\Desktop
        Get report of Active Directory users and save to desktop
    .NOTES
        $List = Get-ADUser -Filter {Name -eq 'Justin Johns'} -Properties * | select -exp MemberOf
        foreach ( $item in $List ) { $item -split ',' | select -First 1 }
    ========================================================================= #>
    [CmdletBinding()]
    [Alias('New-ADUserReport')]

    Param(
        [Parameter(HelpMessage = 'Directory to save the CSV report')]
        [ValidateScript( { Test-Path -Path $_ -PathType Container })]
        [Alias('DataFile', 'File', 'FilePath', 'Path')]
        [string] $SavePath
    )

    $PropList = @(
        @{Name = 'Name'; Expression = {$_.CN}},
        @{Name = "Type"; Expression = {$_.Department}},
        @{Name = "Username"; Expression = {$_.SamAccountName}},
        @{Name = "Role"; Expression = {$_.Title}},
        'Enabled',
        'LastLogonDate',
        'PasswordLastSet',
        @{N = 'DaysSincePwLastSet'; E = {(New-TimeSpan -Start $_.PasswordLastSet -End (Get-Date)).Days}}
        @{N = 'OU'; E = {$_.CanonicalName -split '/' | Select-Object -Skip 1 -First 1}},
        @{N = 'DaysSinceLogon'; E = {(New-TimeSpan -Start $_.LastLogonDate -End (Get-Date)).Days}}
    )

    $Report = Get-ADUser -Filter * -Properties * | Select-Object -Property $PropList

    if ( $PSBoundParameters.ContainsKey('SavePath') ) {
        $Report | Export-Csv -Path "$SavePath\ADAccounts.csv" -NoTypeInformation
    }
    else { $Report }
}
