#Requires -Modules AWS.Tools.EC2

function Invoke-SDelete {
    <# =========================================================================
    .SYNOPSIS
        Securely erase disk using SDelete
    .DESCRIPTION
        Clean disk and overwrite free space using SDelete from sysinternals
    .PARAMETER Disk
        Disk object(s) to be securely deleted
    .PARAMETER Path
        Full path to SDelete64.exe
    .PARAMETER OutputDirectory
        Path to log folder
    .INPUTS
        Microsoft.Management.Infrastructure.CimInstance.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-Disk -Number 4 | Invoke-SDelete -LogPath "C:\Temp"
        SDelete disk 4 and log actions to temp directory on C:\Temp
    .NOTES
        General notes
        try using Start-Process -AsJob and -Wait till jobs are all done (or)
        use PS7 with Start-Process -Wait and Foreach-Object -Parallel
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Disk to be cleaned')]
        [ValidateScript( { $_.Number -notcontains 0 })] ## add custom error message
        [Microsoft.Management.Infrastructure.CimInstance[]] $Disk,

        [Parameter(HelpMessage = 'Path to logs folder')]
        [ValidateScript( { Test-Path -Path (Split-Path -Path $_) -PathType Container })]
        [String] $OutputDirectory = 'C:\logs\SDelete',

        [Parameter(HelpMessage = 'Path to SDelete64.exe')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.exe" })]
        [Alias('SDelete')]
        [string] $Path = "C:\TEMP\SDelete\sdelete64.exe"
    )

    Begin {
        # CONFIRM PATHS
        if ( !(Test-Path -Path $Path) ) { Throw "SDelete not found" }
        if ( !(Test-Path -Path $OutputDirectory) ) { New-Item -Path $OutputDirectory -ItemType Directory -Force }

        # CREATE HASH TABLE FOR VOLUME ID'S
        $alphabetList = 0..25 | ForEach-Object { [char](65 + $_) } # 'A'..'Z'
        [int] $i = 0 ; $volumeLookupTable = @{ }
        $alphabetList | ForEach-Object -Process {
            $key = 'T' + $i.ToString("00") ; [string] $value = ('xvd' + $_).ToLower()
            $volumeLookupTable.Add($key, $value) ; $i++
        }
        $volumeLookupTable['T00'] = '/dev/sda1/'

        # GET MAPPINGS FROM INSTANCE
        $instanceVolumes = @{ }
        $instanceId = Invoke-RestMethod -Uri "http://169.254.169.254/latest/meta-data/instance-id"
        $instance = (Get-EC2Instance -InstanceId $instanceId).Instances
        foreach ( $vol in $instance.BlockDeviceMappings ) {
            $instanceVolumes.Add($vol.DeviceName, $vol.Ebs.VolumeId)
        }

        # GET SDELETE DIRECTORY AND INITIALIZE SDELETE
        $procParams = @{
            FilePath     = $Path
            ArgumentList = "-accepteula"
            Wait         = $true
            NoNewWindow  = $true
        }

        # ACCEPT SDELETE EULA
        Start-Process @procParams

        # REMOVE WAIT PARAM
        $procParams.Remove('Wait')
    }

    Process {
        # LOOP THROUGH EACH DISK
        foreach ( $d in $Disk ) {

            # BRING DISK ONLINE AND FORMAT
            $d | Set-Disk -IsOffline $false
            $d | Set-Disk -IsReadOnly $false
            $d | Clear-Disk -RemoveData -Confirm:$false

            # SET COMMAND ARGUMENTS AND LOGGING
            $procParams['ArgumentList'] = @("-p", 3, "-z", $d.Number)
            #$Command = '{0} -p 3 -z {1}' -f $Path, $d.Number

            # ADD LOG FILE
            $targetId = $d.Location.SubString(39, 3) # THIS IS CHANGED IN WINDOWS SERVER 2016
            $volId = $instanceVolumes[$volumeLookupTable[$targetId]]
            $logFile = Join-Path -Path $OutputDirectory -ChildPath ('SDelete_{0}_{1}.log' -f $volId, (Get-Date -F 'yyyyMMddTHHmm'))
            $procParams['RedirectStandardOutput'] = $logFile

            # START SDELETE
            Start-Process @procParams
            #Start-Job -ScriptBlock { Invoke-Expression -Command $Command | Tee-Object -FilePath $logFile }
        }
    }

    End {
        Write-Output "SDelete Process(es) started."
    }
}
