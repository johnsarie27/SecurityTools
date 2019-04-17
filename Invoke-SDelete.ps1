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
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Disk object to be cleaned')]
        [ValidateScript( { $_.Number -notcontains 0 })] ## add custom error message
        [Microsoft.Management.Infrastructure.CimInstance[]] $Disk,

        [Parameter(HelpMessage = 'Path to folder where logs will be written')]
        [ValidateScript( { Test-Path -Path (Split-Path -Path $_) -PathType Container })]
        [Alias('Log', 'LogFile')]
        [String] $LogPath = 'C:\TEMP\SDeleteLogs',

        [Parameter(HelpMessage = 'Path to SDelete64.exe')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.exe" })]
        [Alias('Executable', 'FilePath', 'SDelete')]
        [string] $Path = "C:\TEMP\SDelete\sdelete64.exe"
    )

    Begin {
        # CONFIRM PATH EXISTENCE
        if ( !(Test-Path -Path $Path) ) { Write-Error "SDelete not found"; Break }
        
        # CREATE LOG FOLDER IF NOT EXIST
        if ( !(Test-Path -Path $LogPath) ) { New-Item -Path $LogPath -ItemType Directory -Force }

        # GET SDELETE DIRECTORY AND INITIALIZE SDELETE
        $Splat = @{
            FilePath     = $Path
            ArgumentList = "-accepteula"
            Wait         = $true
            NoNewWindow  = $true
        }

        # ACCEPT SDELETE EULA
        Start-Process @Splat

        # REMOVE WAIT PARAM
        $Splat.Remove('Wait')
    }

    Process {
        # PERFORM FORMAT AND DELETE
        foreach ( $D in $Disk ) {

            # BRING DISK ONLINE AND FORMAT
            $D | Set-Disk -IsOffline $false
            $D | Set-Disk -IsReadOnly $false
            $D | Clear-Disk -RemoveData -Confirm:$false

            # SET COMMAND ARGUMENTS AND LOGGING
            $Splat['ArgumentList'] = @("-p", 3, "-z", $D.Number)
            #$Command = '{0} -p 3 -z {1}' -f $Path, $D.Number
            
            # ADD LOG FILE
            $LogName = 'SDelete_{1}_{0}.log' -f (Get-Date -F 'yyMMddTHHmmss'), $D.SerialNumber
            $LogFile = Join-Path -Path $LogPath -ChildPath $LogName
            $Splat['RedirectStandardOutput'] = $LogFile
            
            # START SDELETE
            Start-Process @Splat
            #Start-Job -ScriptBlock { Invoke-Expression -Command $Command | Tee-Object -FilePath $LogFile }
        }
    }

    End {
        Write-Output "SDelete Process(es) started."
    }
}
