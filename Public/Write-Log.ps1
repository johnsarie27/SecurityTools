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
        if ( $PSCmdlet.ParameterSetName -eq '__initialize' ) {
            # CREATE DIRECTORY IF NOT EXIST
            if ( -not (Test-Path $Directory) ) { New-Item -Path $Directory -ItemType "Directory" -Force | Out-Null }

            $dateFormat = switch ($Frequency) {
                'Yearly'  { '{0:yyyy}' -f (Get-Date) }
                'Monthly' { '{0:yyyy-MM}' -f (Get-Date) }
                'Daily'   { '{0:yyyy-MM-dd}' -f (Get-Date) }
            }

            $filePath = Join-Path -Path $Directory -ChildPath ('{0}-Log_{1}.log' -f $Name, $dateFormat)
        }
        else {
            $status = switch ($Type) {
                'Info'    { 'INFO' }
                'Error'   { 'ERROR' }
                'Warning' { 'WARN' }
                'Debug'   { 'DEBUG' }
            }

            $filePath = $Path
        }
    }

    Process {
        $date = '{0:yyyy-MM-dd HH:mm:ss,ffff}' -f (Get-Date)

        if ( $PSCmdlet.ParameterSetName -eq '__log' ) {
            if ( $PSBoundParameters.ContainsKey('ComputerName') ) { $ComputerName = '{0}: ' -f $ComputerName }
            $logEntry = '{0} {1} [{2,-5}] - {3}{4}' -f $date, $Id, $status, $ComputerName, $Message
        }
        else {
            # ADD INITIAL LOG ENTRY
            $logEntry = '{0} {1} [INFO ] - Begin Logging' -f $date, $Id
        }

        Add-Content -Path $filePath -Value $logEntry
    }

    End {
        if ( $PSCmdlet.ParameterSetName -eq '__initialize' ) { $filePath }
    }
}
