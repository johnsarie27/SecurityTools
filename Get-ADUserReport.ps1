function Get-ADUserReport {
    <# =========================================================================
    .SYNOPSIS
        Generate new Active Directory report
    .DESCRIPTION
        This function generates a list of objects that can be used to review
        account access and login information.
    .PARAMETER DomainController
        Hostname of Domain Controller.
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object[].
    .EXAMPLE
        PS C:\> Get-ADUserReport
        Get report of Active Directory users
    .EXAMPLE
        PS C:\> Get-ADUserReport -DC MyDC
        Get report of Active Directory users from MyDC
    .NOTES
        $List = Get-ADUser -Filter {Name -eq 'Justin Johns'} -Properties * | select -exp MemberOf
        foreach ( $item in $List ) { $item -split ',' | select -First 1 }
    ========================================================================= #>
    [CmdletBinding()]
    [Alias('New-ADUserReport', 'Export-ADUserReport')]

    Param(
        [Parameter(HelpMessage = 'Hostname of Domain Controller')]
        [ValidateScript( { Test-Connection -ComputerName $_ -Quiet -Count 1 })]
        [Alias('DC')]
        [string] $DomainController
    )

    Begin {
        # SET PROPERTIES
        $PropList = @(
            @{Name = 'Name'; Expression = { $_.CN } },
            @{Name = "Type"; Expression = { $_.Department } },
            @{Name = "Username"; Expression = { $_.SamAccountName } },
            @{Name = "Role"; Expression = { $_.Title } },
            'Enabled',
            'LastLogonDate',
            'PasswordLastSet',
            @{N = 'DaysSincePwLastSet'; E = { (New-TimeSpan -Start $_.PasswordLastSet -End (Get-Date)).Days } }
            @{N = 'OU'; E = { $_.CanonicalName -split '/' | Select-Object -Skip 1 -First 1 } },
            @{N = 'DaysSinceLogon'; E = { (New-TimeSpan -Start $_.LastLogonDate -End (Get-Date)).Days } }
        )
    }

    Process {
        # CHECK FOR DC
        if ( $PSBoundParameters.ContainsKey('DomainController') ) {
            # GET DATA FROM SPECIFIED DC
            $Report = Get-ADUser -Filter * -Properties * -Server $DomainController | Select-Object -Property $PropList
        } else {
            # GET DATA
            $Report = Get-ADUser -Filter * -Properties * | Select-Object -Property $PropList
        }
    }

    End {
        # RETURN RESULTS
        $Report
    }
}
