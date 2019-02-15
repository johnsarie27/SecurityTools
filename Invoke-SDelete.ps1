function Invoke-SDelete {
    <# =========================================================================
    .SYNOPSIS
        Securely erase disk using SDelete
    .DESCRIPTION
        Clean disk and overwrite free space using SDelete from sysinternals
    .PARAMETER Disk
        Disk object(s) to be securely deleted
    .PARAMETER LogPath
        Path to log folder
    .PARAMETER ExistingDisks
        Number of existing disks attached to system
    .PARAMETER Path
        Full path to SDelete64.exe
    .INPUTS
        Microsoft.Management.Infrastructure.CimInstance.
        System.Int.
        System.String.
    .OUTPUTS
    .EXAMPLE
        PS C:\> Invoke-SDelete.ps1 -ExistingDisks 1 -LogPath "C:\Temp"
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = 'targeted', SupportsShouldProcess)]
    Param(
        [Parameter(
            ParameterSetName = 'targeted',
            Mandatory,
            ValueFromPipeline,
            HelpMessage = 'Disk object to be cleaned'
        )]
        [ValidateScript( { $_.Number -notcontains 0 })] ## add custom error message
        [Microsoft.Management.Infrastructure.CimInstance[]] $Disk,

        [Parameter(HelpMessage = 'Path to folder where logs will be written')]
        [ValidateScript( { Test-Path -Path (Split-Path -Path $_) -PathType Container })]
        [String] $LogPath = 'C:\TEMP\SDeleteLogs',

        [Parameter(
            ParameterSetName = 'all',
            Mandatory,
            HelpMessage = 'Number of existing disks that need to be kept'
        )]
        [ValidateRange(1, 5)]
        [int] $ExistingDisks,

        [Parameter(HelpMessage = 'Path to SDelete64.exe')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.exe" })]
        [Alias('Executable', 'FilePath')]
        [string] $Path = "C:\TEMP\SDelete\sdelete64.exe"
    )

    Begin {
        # GET ALL DISKS ATTACHED TO THE SYSTEM GREATER THAN X
        if ( $PSBoundParameters.ContainsKey('ExistingDisks') ) {
            $Disk = @(Get-Disk | Where-Object Number -GT ($ExistingDisks - 1))
        }

        # CREATE LOG FOLDER IF NOT EXIST
        if ( -not (Test-Path $LogPath) ) { New-Item -Path $LogPath -ItemType Directory -Force }

        # GET SDELETE DIRECTORY AND INITIALIZE SDELETE
        $Splat = @{
            ArgumentList = "-accepteula"
            Wait         = $true
            NoNewWindow  = $true
        }

        if ( $PSBoundParameters.ContainsKey('Path') ) { $Splat.FilePath = $Path }
        else {
            if ( Test-Path -Path $Path ) { $Splat.FilePath = $Path }
            else { Write-Warning "SDelete not found"; break }
        }

        Start-Process @Splat

        # SET NO WAIT FOR EACH EXECUTION
        $Splat.Wait = $false
        # ADD SOME LOGIC TO CHECK FOR SDELETE64.EXE BEFORE EXITING THE SCRIPT
    }

    Process {
        # PERFORM FORMAT AND DELETE
        $Disk | ForEach-Object -Process {

            # BRING DISK ONLINE AND FORMAT
            $_ | Set-Disk -IsOffline $false
            $_ | Set-Disk -IsReadOnly $false
            $_ | Clear-Disk -RemoveData -Confirm:$false

            # SET COMMAND ARGUMENTS AND LOGGING
            $Splat.ArgumentList = @("-p", "3", "-z", $_.Number)
            $Expression = '{0} -p 3 -z {1}' -f $Path, $_.Number
            $LogName = 'SDelete_{1}_{0}.log' -f (Get-Date).ToString('yyMMddTHHmmss'), $_.SerialNumber
            $LogFile = Join-Path -Path $LogPath -ChildPath $LogName

            if ( $LogPath ) {
                $Splat.RedirectStandardOutput = $LogFile
                #Start-Process @Splat
                Start-Job -ScriptBlock { Invoke-Expression -Command $Expression | Tee-Object -FilePath $LogFile }
            }
            else {
                #Start-Process @Splat
                Start-Job -ScriptBlock { Invoke-Expression -Command $Expression }
            }
        }
    }

    End {
        Write-Output "SDelete Process(es) started."
    }
}
