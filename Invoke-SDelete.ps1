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
    .PARAMETER LogPath
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
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Disk to be cleaned')]
        [ValidateScript( { $_.Number -notcontains 0 })] ## add custom error message
        [Microsoft.Management.Infrastructure.CimInstance[]] $Disk,

        [Parameter(HelpMessage = 'Path to logs folder')]
        [ValidateScript( { Test-Path -Path (Split-Path -Path $_) -PathType Container })]
        [String] $LogPath = 'C:\logs\SDelete',

        [Parameter(HelpMessage = 'Path to SDelete64.exe')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.exe" })]
        [Alias('SDelete')]
        [string] $Path = "C:\TEMP\SDelete\sdelete64.exe"
    )

    Begin {
        # CONFIRM PATHS
        if ( !(Test-Path -Path $Path) ) { Throw "SDelete not found" }
        if ( !(Test-Path -Path $LogPath) ) { New-Item -Path $LogPath -ItemType Directory -Force }

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
            $logName = 'SDelete_{1}_{0}.log' -f (Get-Date -F 'yyMMddTHHmmss'), $d.SerialNumber
            $logFile = Join-Path -Path $LogPath -ChildPath $logName
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
