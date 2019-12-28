function Get-Software {
    <# =========================================================================
    .SYNOPSIS
        Get all installed software
    .DESCRIPTION
        Get software inventory from Windows Registry
    .PARAMETER Name
        Software name
    .PARAMETER ComputerName
        Remote computer name
    .PARAMETER ExcludeUsers
        Exclude user software registry hive
    .PARAMETER All
        Return all properties for registry keys
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-Software -All
        This returns all properties of the registry keys holding the software inventory
    .NOTES
        General notes
        https://4sysops.com/archives/find-the-product-guid-of-installed-software-with-powershell/
    ========================================================================= #>
    [Alias('gs')]
    [OutputType([System.Management.Automation.PSObject])]
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = "Software name")]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(ValueFromPipeline, HelpMessage = 'Computer name')]
        [ValidateScript( { Test-Connection -ComputerName $_ -Quiet -Count 1 })]
        [Alias('CN')]
        [String] $ComputerName,

        [Parameter(HelpMessage = 'Exclude user software registry hives')]
        [Alias('NoUsers')]
        [switch] $ExcludeUsers,

        [Parameter(HelpMessage = 'Return registry objects with all properties')]
        [switch] $All
    )

    Begin {
        # SET VARS FOR REMOTE CALLS
        if ( $PSBoundParameters.ContainsKey('All') ) { $GetAll = $true } else { $GetAll = $false }
        if ( $PSBoundParameters.ContainsKey('Name') ) { $GetName = $true } else { $GetName = $false }
        if ( $PSBoundParameters.ContainsKey('ExcludeUsers') ) { $GetUsers = $false } else { $GetUsers = $true }

        # CREATE SCRIPTBLOCK
        $ScriptBlock = {
            # SET UNINSTALL REGISTRY HIVE PATH
            $UninstallKeys = @(
                "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
                "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
            )

            # CHECK THAT CURRENT PRINCIPLE HAS ADMIN PRIVILEGES
            $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
            $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            if ( $isAdmin ) { Write-Verbose 'Current user has admin privileges' }

            # GET USER KEYS
            if ( $true -eq $Using:GetUsers -and $isAdmin ) {
                # ADD NEW PSDRIVE FOR HKEY CURRENT USER HIVE
                New-PSDrive -Name HKU -PSProvider Registry -Root Registry::HKEY_USERS | Out-Null

                # ADD USER KEY HIVES
                foreach ( $key in (Get-ChildItem "HKU:") ) {
                    if ( $key.Name -match 'S-\d-\d+-(\d+-){1,14}\d+$' ) {
                        $path = 'HKU:\{0}\Software\Microsoft\Windows\CurrentVersion\Uninstall' -f $key.PSChildName
                        if ( Test-Path $path ) {
                            $UninstallKeys += $path
                        }
                    }
                }
            }
            else {
                Write-Warning 'Unable to retrieve User registry keys. Elevated priveleges required.'
            }

            # SET WHERE STATEMENT
            if ( $true -eq $Using:GetName ) { $Where = { $_.GetValue('DisplayName') -like "*$Using:Name*" } }
            else { $Where = { $_.GetValue('DisplayName') } }

            # GET SOFTWARE REGISTRY KEYS
            if ( $true -eq $Using:GetAll ) {
                Get-ChildItem -Path $UninstallKeys | Where-Object $Where
            }
            else {
                # SET PROPERTIES
                $Properties = @(
                    @{N = 'GUID'; E = { $_.PSChildName } },
                    @{N = 'Name'; E = { $_.GetValue('DisplayName') } },
                    @{N = 'Version'; E = { $_.GetValue('DisplayVersion') } },
                    @{N = 'InstallDate'; E = { $_.GetValue('InstallDate') } },
                    @{N = 'InstallLocation'; E = { $_.GetValue('InstallLocation') } },
                    @{N = 'UninstallString'; E = { $_.GetValue('UninstallString') } }
                )

                # GET SPECIFIED PROPERTIES
                Get-ChildItem -Path $UninstallKeys | Where-Object $Where | Select-Object -Property $Properties
            }
        }

        # SET PARAM HASH
        $Splat = @{ ScriptBlock = $ScriptBlock }
    }

    Process {
        # CHECK FOR LOCAL SYSTEM OR NO COMPUTERNAME
        if ( !$PSBoundParameters.ContainsKey('ComputerName') -or $ComputerName -eq $env:COMPUTERNAME ) {
            # EXECUTE LOCALLY
            #$Software = Invoke-Expression -Command $ScriptBlock.ToString().Replace('Using:', '')
            $String = $ScriptBlock -replace 'Using:', ''
            $Splat['ScriptBlock'] = [Scriptblock]::Create($String)
        } else {
            # ADD COMPUTERNAME IF PROVIDED
            $Splat['ComputerName'] = $ComputerName
        }

        # EXECUTE COMMAND
        $Software = Invoke-Command @Splat

        # RETURN
        if ( $GetAll ) { $Software }
        else { $Software | Sort-Object -Property Name }
    }
}