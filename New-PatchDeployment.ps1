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
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> New-PatchDeployment -UpdateGroupName 'Jan Updates' -CollectionName 'UATAppServers' -Deadline (Get-Date).AddDays(3)
        Create a new patch deployment to deploy 'Jan Updates' to the collection 'UATAppServers' in 3 days from now
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName='one')]
    Param(
        [Parameter(HelpMessage = 'PSDrive for Configuration Manager')]
        [ValidateScript({ Confirm-CMDrive -PSDrive $_ })]
        [Alias('Drive', 'DriveName', 'CMDrive')]
        [string] $PSDrive,

        [Parameter(Mandatory, HelpMessage='CM Software Update Group name')]
        [ValidateScript({ Confirm-CMResource -UpdateGroupName $_ })]
        [Alias('SoftwareUpdateGroup', 'UGN', 'SUGN')]
        [string] $UpdateGroupName,

        [Parameter(Mandatory, ParameterSetName='one', HelpMessage='CM Collection Name')]
        [ValidateScript({ Confirm-CMResource -CollectionName $_ })]
        [Alias('Collection', 'DeviceCollection')]
        [string] $CollectionName,

        [Parameter(Mandatory, ParameterSetName='one', HelpMessage='Deadline for patch install')]
        [ValidateScript({ $_ -gt (Get-Date).AddHours(1) })]
        [Alias('DeadlineDate', 'Date')]
        [DateTime] $Deadline,

        [Parameter(Mandatory, ParameterSetName='many', HelpMessage='PSCustomObject with values Name and UTC')]
        [ValidateScript({ $_.CollectionName -in (Get-CMCollection).Name -and [System.DateTime]::Parse($_.UTC) })]
        [Alias('Collections', 'Groups')]
        [PSObject[]] $PatchTime
    )

    Begin {
        # IMPORT SCCM MODULE AND CD TO SITE
        Import-Module (Join-Path -Path $(Split-Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1")

        if ( !$PSBoundParameters.ContainsKey('PSDrive') ) {
            $Site = (Get-PSDrive -PSProvider CMSite).Name
            if ( !$Site ) { Write-Error "No drives from PSProvider CMSite available."; Pop-Location; Break }
            elseif ( $Site.Count -gt 1 ) { Write-Error "Please specify CMSite."; Pop-Location; Break }
            else { Push-Location -Path ('{0}:' -f $Site) }
        } else { Push-Location -Path ('{0}:' -f $PSDrive) }

        # SETUP SPLAT TABLE
        $Splat = @{
            SoftwareUpdateGroupName         = $UpdateGroupName
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
        if ($PSBoundParameters.ContainsKey('PatchTime') ) {
            # ITERATE THROUGH ARRAY OF OBJECTS AND CREATE NEW DEPLOYMENT FOR EACH
            $PatchTime | ForEach-Object -Process {
                $Splat['CollectionName']   = $_.CollectionName
                $Splat['DeadlineDateTime'] = [DateTime] $_.UTC
                New-CMSoftwareUpdateDeployment @Splat
            }
        }
        if ( $PSBoundParameters.ContainsKey('CollectionName') ) {
            $Splat['CollectionName']   = $CollectionName
            $Splat['DeadlineDateTime'] = [DateTime] $Deadline
            New-CMSoftwareUpdateDeployment @Splat
        }
    }

    End {
        Pop-Location
    }
}
