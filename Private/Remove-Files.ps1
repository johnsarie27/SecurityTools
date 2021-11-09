function Remove-Files {
    <# =========================================================================
    .SYNOPSIS
        Remove files in a directory based on age
    .DESCRIPTION
        This function will remove all log files prior to the provided
        number of days in the provided directory. It can also remove log files
        from sub-directories when the -Recurse switch is provided.
    .PARAMETER Folder
        Folder to look for .log files to delete.
    .PARAMETER Age
        Desired age in days prior to which you wish to delete the logs files.
    .PARAMETER Extension
        File extensions of log files to be removed. Default is .log files.
    .PARAMETER Recurse
        Swithc parameter used to look for and delete log files in the
        sub-directories of the provided folder.
    .INPUTS
        System.String.
        System.Int.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Remove-Files -Folder 'E:\Logs' -Age 30 -Extension csv
    .EXAMPLE
        PS C:\> Remove-Files -Folder 'C\temp\logs' -Age 7 -Recurse
    ========================================================================= #>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Targer folder for file removal')]
        [ValidateScript( {Test-Path $_ -PathType 'Container'})]
        [Alias('Folder', 'Path', 'Dir')]
        [string] $Directory,

        [Parameter(Mandatory, HelpMessage = 'Age (in days) for removal')]
        [int] $Age,

        [Parameter(HelpMessage = 'File type to remove')]
        [ValidateSet('log', 'csv', 'txt', '*')]
        [string] $Extension = 'log',

        [Parameter(HelpMessage = 'Recurse through subfolders and delete')]
        [switch] $Recurse
    )

    if ( $PSBoundParameters.ContainsKey('Recurse') ) { $Recurse = $true } else { $Recurse = $false }
    $Logs = Get-ChildItem -Path $Directory -Filter "*.$Extension" -Recurse:$Recurse

    $DeleteCount = 0
    if ( $Logs.Count -gt 0 ) {
        foreach ( $file in $Logs ) {
            $LogAge = New-TimeSpan -Start $file.LastWriteTime -End ( Get-Date )
            if ( $LogAge.Days -gt $Age ) { Remove-Item $file.FullName -Force; $DeleteCount += 1 }
        }
        Write-Output '[{0}] Logs successfully removed.' -f $DeleteCount
    }
    else { Write-Warning 'No log files found in provided directory.' }

}
