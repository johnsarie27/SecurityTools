# ==============================================================================
# Updated:      2019-02-14
# Created by:   Justin Johns
# Filename:     SecurityTools.psm1
# Link:         https://github.com/johnsarie27/PowerShell-Modules/SecurityTools
# ==============================================================================

# IMPORT SYSTEM CENTER FUNCTIONS
. $PSScriptRoot\New-DeploymentGroup.ps1
. $PSScriptRoot\New-PatchDeployment.ps1
. $PSScriptRoot\New-UpdateGroup.ps1
. $PSScriptRoot\Get-DeviceCollections.ps1

# IMPORT SCANNING AND REPORTING FUNCTIONS
. $PSScriptRoot\ConvertTo-DbScanReport.ps1
. $PSScriptRoot\New-AggregateReport.ps1
. $PSScriptRoot\New-SummaryReport.ps1

# IMPORT WINDOWS FUNCTIONS
. $PSScriptRoot\Get-WinLogs.ps1

# IMPORT OTHER FUNCTIONS
. $PSScriptRoot\Invoke-SDelete.ps1

# FUNCTIONS
function Get-RemoteBitLocker {
    <# =========================================================================
    .SYNOPSIS
        Get remote BitLocker encryption info
    .DESCRIPTION
        Get BitLocker encryption info from remote system(s)
    .PARAMETER ComputerName
        Target computer(s)
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object
    .EXAMPLE
        PS C:\> Get-RemoteBitLocker -CN Server01
        Get BitLocker volume info from Server01
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline, HelpMessage='Target computer(s)')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Count 1 -Quiet })]
        [Alias('CN', 'Target', 'Host')]
        [string[]] $ComputerName
    )

    Begin {
        $Results = @()
        $Properties = @(
            'VolumeType'
            'MountPoint'
            'CapacityGB'
            'VolumeStatus'
            'EncryptionPercentage'
            'KeyProtector'
            'AutoUnlockEnabled'
            'ProtectionStatus'
        )
    }

    Process {
        $ComputerName | ForEach-Object -Process {
            if ( $PSBoundParameters.ContainsKey('ComputerName') ) {
                <# $Session = New-PSSession -ComputerName $_
                $Results += Invoke-Command -Session $Session -ScriptBlock { Get-BitLockerVolume }
                Remove-PSSession -Session $Session #>
                $Results += Invoke-Command -ComputerName $_ -ScriptBlock { Get-BitLockerVolume }
            }
            else { Get-BitLockerVolume }
        }
    }

    End {
        $Results | Select-Object -Property $Properties | Format-Table
    }
    
}

function Deploy-Script {
    <# =========================================================================
    .SYNOPSIS
        Deploy script to remote system(s)
    .DESCRIPTION
        Run provided script on remote systems and return results both to the
        console and to a CSV file
    .PARAMETER ComputerName
        One or more computers to deploy script
    .PARAMETER ScriptPath
        Path to PowerShell script to execute
    .PARAMETER ArgumentList
        Parameters passed to the script
    .PARAMETER OutputPath
        Path to output CSV file
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
        CSV file.
    .EXAMPLE
        PS C:\> Deploy-Script -CN MyComputer -ScriptPath C:\script.ps1 -OutputPath C:\temp\output.csv
        Deploy script "script.ps1" on MyComputer and output results to C:\temp\output.csv
    .NOTES
        # RECEIVE-JOB WILL RETURN THE RESULT ONE TIME AND THEN DISCARD THE RESULT UNLESS SAVED
        $Results = $Jobs | Receive-Job
        $Results
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage='Target computer(s)')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Count 1 -Quiet })]
        [Alias('CN', 'Target', 'Host')]
        [string[]] $ComputerName,
        
        [Parameter(Mandatory, HelpMessage = 'Script to execute on remote system')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter *.ps1 })]
        [Alias('FilePath', 'File', 'Script', 'Path')]
        [String] $ScriptPath,

        [Parameter(HelpMessage = 'Argument list')]
        [Alias('Args')]
        [String[]] $ArgumentList,

        [Parameter(Mandatory, HelpMessage='Export path for resutls')]
        [ValidateScript({ Test-Path -Path (Split-Path -Path $_) -PathType Container })]
        [Alias('Output', 'Export')]
        [string] $OutputPath
    )

    # SETUP PARAMETERS AND ARGUMENTS FOR DEPLOYMENT
    $Splat = @{
        Session  = New-PSSession -ComputerName $ComputerName
        FilePath = $ScriptPath
        AsJob    = $true
        JobName  = 'DeployScript'
    }
    if ( $PSBoundParameters.ContainsKey('ArgumentList') ) { $Splat.ArgumentList = $ArgumentList }

    # RUN SCRIPT IN ALL SESSIONS
    $Job = Invoke-Command @Splat

    # WAIT FOR ALL JOBS TO COMPLETE AND SHOW RESULTS
    ($Job | Wait-Job).ChildJobs | Select-Object -Property Location, State, Output

    # SAVE RESULTS
    $Job.ChildJobs | Export-Csv -NoTypeInformation -Path $OutputPath -Force
}

function Get-ServiceAccounts {
    <# =========================================================================
    .SYNOPSIS
    .DESCRIPTION
        This function will retrieve the services and identities of all services
        running as a domain account.
    .PARAMETER Environment
        User environment
    .PARAMETER Agency
        Agency or customer name
    .PARAMETER Domain
        Domain name
    .PARAMETER ConfigurationData
        Path to configuration data file
    .INPUTS
        System.String. Get-ServiceAccounts accepts string values for all parameters
    .OUTPUTS
        System.Object.CimInstance. Get-ServiceAccounts returns a list of CimInstance
        Service objects.
    .EXAMPLE
        PS C:\> Get-ServiceAccounts -Environment STG -Agency $Ag -DomainName $DN -ConfigFile $ConfigFile
        This returns all services and identities of those services for all
        systems in the staging environment for a give customer
    .NOTES
        Remove comments to utilize Configuration Manager to retrieve servers
        in SCCM Collections.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Environment')]
        [ValidateSet('PRD', 'STG')]
        [Alias('Env', 'System')]
        [string] $Environment,

        [Parameter(Mandatory, HelpMessage = 'Agency')]
        [ValidateScript({ (Get-ADOrganizationalUnit -Filter * -SearchScope Subtree).Name -contains $_ })]
        [Alias('Customer')]
        [string] $Agency,

        [Parameter(Mandatory, HelpMessage = 'Domain short name')]
        [Alias('Domain')]
        [string] $DomainName,

        [Parameter(Mandatory, HelpMessage = 'Configuration data file')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.json" })]
        [Alias('ConfigFile', 'DataFile', 'CofnigData', 'File', 'Path')]
        [string] $ConfigurationData
    )

    $Config = Get-Content -Raw -Path $ConfigurationData | ConvertFrom-Json

    if ( $Environment -eq 'PRD' ) { $Env = $Config.Domain.PRD } else { $Env = $Config.Domain.STG }

    if ( $PSBoundParameters.ContainsKey('Agency') ) {
        $SearchBase = $Env + ',OU=' + $Agency + ',' + $Config.Domain.CustomerBase
    } else { $SearchBase = $Config.Domain.CustomerBase }

    $ComputerList = Get-ADComputer -Filter * -SearchBase $SearchBase | Select-Object -EXP Name
    # $ComputerList = Get-HAGroup -ConfigurationData $ConfigurationData -Environment STG

    $ServiceList = @()

    foreach ( $server in $ComputerList ) {
        $ServiceList += Get-CimInstance win32_service -ComputerName $server |
            Where-Object StartName -like $DomainName* |
            Select-Object -Property State, Name, SystemName, StartName # PSComputerName
    }

    $ServiceList
}

function Get-HAGroup {
    <# =========================================================================
    .SYNOPSIS
        Get all nodes in a given CM Collection or Collections
    .DESCRIPTION
        This function will return all systems in the specified CM Collection(s)
        that match the station and server type provided.
    .PARAMETER PSDrive
        PowerShell Drive designated for CM Site
    .PARAMETER CollectionName
        CM Collection Name(s) to filter for group servers.
    .PARAMETER Station
        Primary or secondary HA server(s)
    .PARAMETER ServerType
        Primary function of server (app or data)
    .INPUTS
        System.String. Get-HAGroup accepts string values for all parameters
    .OUTPUTS
        System.String. Get-HAGroup returns an array of strings for servers that
        match the arguments provided.
    .EXAMPLE
        PS C:\> Get-HAGroup -PSDrive MySite -CollectionName $Col -Station primary
        Returns all "primary" servers in collection $Col from MySite
    .NOTES
        Need the ability to select data or app
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'PSDriver for Configuration Manager')]
        [ValidateScript({ (Get-PSDrive -PSProvider CMSite).Name -contains $_ })]
        [Alias('Drive', 'DriveName', 'CMDrive')]
        [string] $PSDrive,

        [Parameter(Mandatory, HelpMessage='Array of CM Collection Names')]
        [ValidateScript({ $_ -in (Get-CMCollection).Name })]
        [Alias('Collections', 'GroupNames')]
        [string[]] $CollectionNames,

        [Parameter(HelpMessage = 'Primary or secondary HA group')]
        [ValidateSet('primary', 'secondary')]
        [Alias('HAGroup', 'Group')]
        [string] $Station,

        [Parameter(HelpMessage = 'Server type')]
        [ValidateSet('apps', 'data')]
        [Alias('Type', 'Purpose', 'Designation')]
        [string] $ServerType
    )

    Import-Module (Join-Path -Path $(Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

    # VALIDATE $PSDrive IS PROPERLY FORMATTED
    if ( $PSDrive -match '[a-z0-9]+:' ) { Push-Location $PSDrive } else { Push-Location ($PSDrive + ':') }

    $CollectionNames = $CollectionNames | Where-Object { $_ -match "$ServerType" -and $_ -match "$Station" }

    $Results = @()
    $CollectionNames | ForEach-Object -Process { $Results += Get-CMCollectionMember -CollectionName $_ }

    $Results | Select-Object -ExpandProperty Name
    Pop-Location
}

function New-ADUserReport {
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
        PS C:\> New-ADUserReport
        Get report of Active Directory users
    .EXAMPLE
        PS C:\> New-ADUserReport -Path $HOME\Desktop
        Get report of Active Directory users and save to desktop
    .NOTES
        $List = Get-ADUser -Filter {Name -eq 'Justin Johns'} -Properties * | select -exp MemberOf
        foreach ( $item in $List ) { $item -split ',' | select -First 1 }
    ========================================================================= #>
    [CmdletBinding()]
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

function Get-ActiveGWUsers {
    <# =========================================================================
    .SYNOPSIS
        Get users actively connected to the remote desktop gateway
    .DESCRIPTION
        This function shows users who have active connections through the
        remote desktop gateway provided.
    .PARAMETER ComputerName
        Remote desktop computer name
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ActiveGWUsers -CompuaterName Gateway
        Get all users connected through the RDGW "Gateway"
    .NOTES
        Some properties are derived from the data provided by WMI
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Remote desktop gateway server' )]
        [ValidateScript( { Test-Connection -ComputerName $_ -Quiet -Count 2 })]
        [ValidateNotNullOrEmpty()]
        [Alias('Name', 'CN', 'Computer', 'System', 'Target')]
        [string] $ComputerName
    )

    $ParamHash = @{
        Class          = "Win32_TSGatewayConnection"
        Namespace      = "root\cimv2\TerminalServices"
        ComputerName   = $ComputerName
        Authentication = 6
    }

    $PropertyList = @(
        'UserName'
        'ClientAddress'
        @{N = 'ConnectionTime'; E = {Get-Date ($_.ConnectedTime.Substring(0, 4) + '-' + $_.ConnectedTime.Substring(4, 2) + `
            '-' + $_.ConnectedTime.Substring(6, 2) + ' ' + $_.ConnectedTime.Substring(8, 2) + ':' + `
            $_.ConnectedTime.Substring(10, 2) + ':' + $_.ConnectedTime.Substring(12, 2))}
        }
        #'{0}-{1}-{2} {3}:{4}:{5}' -f $_.ConnectedTime.Substring(0,4), $_.ConnectedTime.Substring(4,2), $_.ConnectedTime.Substring(6,2),
        #$_.ConnectedTime.Substring(8,2), $_.ConnectedTime.Substring(10,2), $_.ConnectedTime.Substring(12,2)
        # (Select-String -InputObject $_ -Pattern 'day,\s(\w{4,12})\s').Matches.Groups[1].Value
        @{N = 'ElapsedTime'; E = {($_.ConnectionDuration.Substring(8, 2) + ':' + $_.ConnectionDuration.Substring(10, 2) + `
            ':' + $_.ConnectionDuration.Substring(12, 2) )}
        }
        'ConnectedResource'
    )

    $Users = Get-WmiObject @ParamHash | Select-Object $PropertyList

    $Users
}

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
    .INPUTS
        System.String.
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
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'username', HelpMessage = 'User account name')]
        [ValidateScript( { Get-ADUser -Identity $_ })]
        [Alias('User')]
        [string] $UserName,

        [Parameter(Mandatory, ParameterSetName = 'fragment', HelpMessage = "Part of user's name")]
        [ValidateScript( { (Get-ADUser -Filter * -Properties *).CN -match "$_" })]
        [Alias('Name', 'Fragment')]
        [string] $PartialName
    )

    if ( $PSBoundParameters.ContainsKey('UserName') ) { $SearchName = $UserName }
    if ( $PSBoundParameters.ContainsKey('PartialName') ) {
        $SearchName = Get-ADUser -Filter * -Properties "SamAccountName", "CN" |
            Where-Object "CN" -Match $PartialName | Select-Object -EXP SamAccountName

        # LIST THE USERS RETURNED AND ALLOW SELECTION
        if ( $SearchName.Count -gt 1 ) { $SearchName = Get-Object -ObjectList $SearchName -String }
        # THERE SHOULD BE NO ELSE STATEMENT IF THE PARAMETER VALIDATION WORKED
    }

    # $Filter = { CN -match $Name Enabled -eq $True -and PasswordNeverExpires -eq $False }
    $Properties = @(
        # --------------------- ACCOUNT INFO
        'CN',
        'EmailAddress',
        'Created',
        'Enabled',
        'LastLogonDate',
        @{N = 'DaysSinceLastLogon'; E = {(New-TimeSpan -Start $_.LastLogonDate -End (Get-Date)).Days}}
        # --------------------- LOCKOUT INFO
        'LockedOut',
        'AccountLockoutTime',
        # --------------------- PASSWORD EXPIRIATION
        'PasswordExpired',
        @{Name = "ExpiryDate"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
        # --------------------- BAD PASSWORDS
        'LastBadPasswordAttempt',
        'BadLogonCount',
        #'logonCount',
        'Modified',
        'PasswordLastSet'
        # --------------------- OTHER
        #@{N='ExpiresTime';E={[datetime]::FromFileTime($_.accountExpires)}},
        #@{N='BadPwTime';E={[datetime]::FromFileTime($_.badPasswordTime)}},
        #'badPwdCount',
        #'CannotChangePassword',
    )

    Get-ADUser -Identity $SearchName -Properties *, "msDS-UserPasswordExpiryTimeComputed" | Select-Object $Properties
}


# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
