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
        [Parameter(Mandatory, ParameterSetName = '__initialize', HelpMessage = 'Folder where log should be created')]
        [ValidateScript({ Test-Path -Path (Split-Path -Path $_) -PathType Container })]
        [Alias('Dir', 'D')]
        [string] $Directory,

        [Parameter(Mandatory, ParameterSetName = "__initialize", HelpMessage='Log name')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(ParameterSetName = "__initialize", HelpMessage='New log file creation frequency')]
        [ValidateSet('Daily', 'Monthly', 'Yearly')]
        [Alias('F')]
        [string] $Frequency = 'Daily',

        [Parameter(Mandatory, ParameterSetName = "__log", HelpMessage='Log file path')]
        [ValidateScript({ Test-Path $_ -PathType 'Leaf' -Include "*.log" })]
        [Alias('P')]
        [string] $Path,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "__log", HelpMessage = 'Log entry message')]
        [ValidateNotNullOrEmpty()]
        [Alias('M')]
        [string] $Message,

        [Parameter(ParameterSetName = "__log", HelpMessage = 'Log entry type')]
        [ValidateSet('Info', 'Error', 'Warning', 'Debug')]
        [Alias('T')]
        [string] $Type = 'Info',

        [Parameter(ParameterSetName = "__log", HelpMessage = 'Source of log message')]
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
            $Date = switch ($Frequency) {
                'Yearly'  { Get-Date -Format "yyyy" }
                'Monthly' { Get-Date -Format "yyyy-MM" }
                'Daily'   { Get-Date -Format "yyyy-MM-dd" }
            }

            # CREATE LOG FILE PATH
            $FilePath = Join-Path -Path $Directory -ChildPath ('{0}-Log_{1}.log' -f $Name, $Date)
        } else {
            # SET TYPE AND DATE
            #$Type = $Type.ToUpper()
            $Status = switch ($Type) {
                'Info'    { 'INFO' }
                'Error'   { 'EROR' }
                'Warning' { 'WARN' }
                'Debug'   { 'DBUG' }
            }

            # SET FILEPATH TO PROVIDED PATH ARGUMENT
            $FilePath = $Path
        }
    }

    Process {
        # SET/RESET DATE VAR
        $Date = Get-Date -F "yyyy-MM-dd_hh:mm:ss"

        # CHECK FOR PARAMETER SET
        if ( $PSCmdlet.ParameterSetName -eq '__log' ) {
            # CHECK FOR COMPUTERNAME
            if ( $PSBoundParameters.ContainsKey('ComputerName') ) {
                $LogEntry = '{0} -- {1} -- {2} -- {3}' -f $Date, $Status, $ComputerName, $Message
            }
            else {
                $LogEntry = '{0} -- {1} -- {2}' -f $Date, $Status, $Message
            }
        } else {
            # ADD INITIAL LOG ENTRY
            $LogEntry = '{0} -- INFO -- Begin Logging' -f $Date
        }

        # ADD TO LOG
        Add-Content -Path $FilePath -Value $LogEntry
    }

    End {
        # RETURN
        if ( $PSCmdlet.ParameterSetName -eq '__initialize' ) { $FilePath }
    }
}
