function New-PatchDeployment {
    <# =========================================================================
    .SYNOPSIS
        Create new CM Deployment
    .DESCRIPTION
        This function creates a new CM Deployment for Windows patches based on
        a pre-defined template and provided parameter arguments.
    .PARAMETER PSDrive
        PowerShell Drive designated for CM Site
    .PARAMETER UpdateGroup
        Name of CMSoftwareUpdateGroup to apply in software deployment
    .PARAMETER CollectionName
        Name of CMCollection to apply software deployment to
    .PARAMETER Deadline
        Date and time of software deployment deadline
    .PARAMETER PatchTimes
        Custom object containing CMCollection name ("Name") and deadline ("UTC")
        or list of aforementioned custom objects.
    .INPUTS
        System.String. New-PatchDeployment accepts string values for UpdateGroup
        and CollectionName parameters.
        System.DateTime. New-PatchDeployment accepts DateTime value for Deadline
        System.PSObject. New-PatchDeployment accepts a custom PSObject for PatchTimes
    .OUTPUTS
        System.Object
    .EXAMPLE
        PS C:\> New-PatchDeployment -UpdateGroupName 'Jan Updates' -CollectionName 'UATAppServers' -Deadline (Get-Date).AddDays(3)
        Create a new patch deployment to deploy 'Jan Updates' to the collection 'UATAppServers' in 3 days from now
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName='one')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'PSDriver for Configuration Manager')]
        [ValidateScript({ (Get-PSDrive -PSProvider CMSite).Name -contains $_ })]
        [Alias('Drive', 'DriveName', 'CMDrive')]
        [string] $PSDrive,

        [Parameter(Mandatory, HelpMessage='CM Software Update Group name')]
        [ValidateScript({ (Get-CMSoftwareUpdateGroup).LocalizedDisplayName -contains $_ })]
        [Alias('SoftwareUpdateGroup', 'UGN', 'SUGN')]
        [string] $UpdateGroupName,

        [Parameter(Mandatory, ParameterSetName='one', HelpMessage='CM Collection Name')]
        [ValidateScript({ (Get-CMCollection).Name -contains $_ })]
        [Alias('Collection', 'DeviceCollection')]
        [string] $CollectionName,

        [Parameter(Mandatory, ParameterSetName='one', HelpMessage='Deadline for patch install')]
        [ValidateScript({ $_ -gt (Get-Date).AddHours(1) })]
        [Alias('DeadlineDate', 'Date')]
        [DateTime] $Deadline,

        [Parameter(Mandatory, ParameterSetName='many', HelpMessage='PSCustomObject with values Name and UTC')]
        [ValidateScript({ $_.CollectionName -in (Get-CMCollection).Name -and [System.DateTime]::Parse($_.UTC) })]
        [Alias('Collections', 'Groups')]
        [PSObject[]] $PatchTimes
    )

    Begin {
        # THIS SHOULD ALREADY BE IMPORTED BY THE SCRIPT CALLING THIS FUNCTION
        Import-Module (Join-Path -Path $(Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

        # VALIDATE $PSDrive IS PROPERLY FORMATTED
        if ( $PSDrive -match '[a-z0-9]+:' ) { Push-Location $PSDrive } else { Push-Location ($PSDrive + ':') }
        
        # SETUP SPLAT TABLE
        $Splat = @{
            SoftwareUpdateGroupName         = $UpdateGroupName # "2018-11 Update Rollup"
            DeploymentName                  = "Microsoft Software Updates - {0}" -f (Get-Date).ToString("yyyy-MM-dd hh:mm:ss tt")
            DeploymentType                  = "Required"
            SendWakeUpPacket                = $false
            VerbosityLevel                  = "AllMessages"
            TimeBasedOn                     = "UTC"
            AvailableDateTime               = Get-Date
            UserNotification                = "DisplayAll"
            SoftwareInstallation            = $true
            AllowRestart                    = $true
            RestartServer                   = $false
            RestartWorkstation              = $false
            PersistOnWriteFilterDevice      = $true
            GenerateSuccessAlert            = $false
            DisableOperationsManagerAlert   = $true
            GenerateOperationsManagerAlert  = $true
            ProtectedType                   = "RemoteDistributionPoint"
            UseBranchCache                  = $false
            DownloadFromMicrosoftUpdate     = $false
            UseMeteredNetwork               = $true
            RequirePostRebootFullScan       = $true
            AcceptEula                      = $true
        }
    }
    
    Process {
        if ($PSBoundParameters.ContainsKey('PatchTimes') ) {
            # ITERATE THROUGH ARRAY OF OBJECTS AND CREATE NEW DEPLOYMENT FOR EACH
            $PatchTimes | ForEach-Object -Process {
                $Splat.CollectionName = $_.CollectionName
                $Splat.Deadline       = [DateTime] $_.UTC
                New-CMSoftwareUpdateDeployment @Splat
            }
        }
        if ( $PSBoundParameters.ContainsKey('CollectionName') ) {
            $Splat.CollectionName   = $CollectionName       # "Ad Hoc Patching and Maintenance"
            $Splat.DeadlineDateTime = [DateTime] $Deadline  # (Get-Date).AddDays(3)
            New-CMSoftwareUpdateDeployment @Splat
        }
    }

    End {
        Pop-Location
    }
}
