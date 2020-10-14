function Write-Log {
    <# =========================================================================
    .SYNOPSIS
        Create and/or write to a log file
    .DESCRIPTION
        This function has the ability to create and/or add entries to a log
        file. Notice it has two parameter sets (i.e., "initialize" and "log")
        depending on the intended use.
    .PARAMETER Directory
        Path to folder where the log file(s) are to be created. The paraent
        directory for this folder MUST already exist.
    .PARAMETER Name
        log file name
    .PARAMETER Frequency
        Frequency of new log file creation (defaults to daily)
    .PARAMETER Path
        Path to the log file
    .PARAMETER Type
        log entry type. Accepted values include Info, Warning, Error, and Debug.
    .PARAMETER Id
        Unique ID for the log entry or set of entries (e.g., process id, etc.)
    .PARAMETER Message
        Log message
    .PARAMETER ComputerName
        Computer name of system generating log entry
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> $Path = Write-Log -Directory "D:\Logs\BackupLogs" -Name Backups
    .EXAMPLE
        PS C:\> Write-Log -Path $Path -Message 'No data found' -Type Error
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = "__log")]
    [Alias('wl')]
    Param(
        [Parameter(Mandatory, ParameterSetName='__initialize', HelpMessage='Folder where log should be created')]
        [ValidateScript({ Test-Path -Path (Split-Path -Path $_) -PathType Container })]
        [string] $Directory,

        [Parameter(Mandatory, ParameterSetName="__initialize", HelpMessage='Log name')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(ParameterSetName="__initialize", HelpMessage='New log file creation frequency')]
        [ValidateSet('Daily', 'Monthly', 'Yearly')]
        [string] $Frequency = 'Daily',

        [Parameter(Mandatory, ParameterSetName="__log", HelpMessage='Log file path')]
        [ValidateScript({ Test-Path $_ -PathType 'Leaf' -Include "*.log" })]
        [string] $Path,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName="__log", HelpMessage='Log entry message')]
        [ValidateNotNullOrEmpty()]
        [string] $Message,

        [Parameter(ParameterSetName="__log", HelpMessage='Log entry type')]
        [ValidateSet('Info', 'Error', 'Warning', 'Debug')]
        [string] $Type = 'Info',

        [Parameter(ParameterSetName="__log", HelpMessage='Id')]
        [Parameter(ParameterSetName = "__initialize", HelpMessage = 'Id')]
        [ValidateRange(0, 99999)]
        [int] $Id = 0,

        [Parameter(ParameterSetName="__log", HelpMessage='Source of log message')]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [string] $ComputerName
    )

    Begin {
        # CHECK FOR PARAMETER SET
        if ( $PSCmdlet.ParameterSetName -eq '__initialize' ) {
            # CHECK FOR DIRECTORY
            if ( -not (Test-Path $Directory) ) { New-Item -Path $Directory -ItemType "Directory" -Force | Out-Null }

            # GET DATE FORMAT
            $dateFormat = switch ($Frequency) {
                'Yearly'  { '{0:yyyy}' -f (Get-Date) }
                'Monthly' { '{0:yyyy-MM}' -f (Get-Date) }
                'Daily'   { '{0:yyyy-MM-dd}' -f (Get-Date) }
            }

            # CREATE LOG FILE PATH
            $filePath = Join-Path -Path $Directory -ChildPath ('{0}-Log_{1}.log' -f $Name, $dateFormat)
        }
        else {
            # SET TYPE AND DATE
            $status = switch ($Type) {
                'Info'    { 'INFO' }
                'Error'   { 'ERROR' }
                'Warning' { 'WARN' }
                'Debug'   { 'DEBUG' }
            }

            # SET FILEPATH TO PROVIDED PATH ARGUMENT
            $filePath = $Path
        }
    }

    Process {
        # SET/RESET DATE VAR
        $date = '{0:yyyy-MM-dd HH:mm:ss,ffff}' -f (Get-Date)

        # CHECK FOR PARAMETER SET
        if ( $PSCmdlet.ParameterSetName -eq '__log' ) {
            # CHECK FOR COMPUTERNAME
            if ( $PSBoundParameters.ContainsKey('ComputerName') ) {
                $logEntry = '{0} {4} [{1,-5}] - {2}: {3}' -f $date, $status, $ComputerName, $Message, $Id
            }
            else {
                $logEntry = '{0} {3} [{1,-5}] - {2}' -f $date, $status, $Message, $Id
            }
        }
        else {
            # ADD INITIAL LOG ENTRY
            $logEntry = '{0} {1} [INFO ] - Begin Logging' -f $date, $Id
        }

        # ADD TO LOG
        Add-Content -Path $filePath -Value $logEntry
    }

    End {
        # RETURN
        if ( $PSCmdlet.ParameterSetName -eq '__initialize' ) { $filePath }
    }
}
