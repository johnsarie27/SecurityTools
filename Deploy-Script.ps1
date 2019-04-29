function Deploy-Script {
    <# =========================================================================
    .SYNOPSIS
        Deploy script to remote system(s)
    .DESCRIPTION
        Run provided script on remote systems and return results both to the
        console and to a CSV file
    .PARAMETER ComputerName
        One or more computers to deploy script
    .PARAMETER ScriptPath
        Path to PowerShell script to execute
    .PARAMETER ArgumentList
        Parameters passed to the script
    .PARAMETER OutputPath
        Path to output CSV file
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
        CSV file.
    .EXAMPLE
        PS C:\> Deploy-Script -CN MyComputer -ScriptPath C:\script.ps1 -OutputPath C:\temp\output.csv
        Deploy script "script.ps1" on MyComputer and output results to C:\temp\output.csv
    .NOTES
        # RECEIVE-JOB WILL RETURN THE RESULT ONE TIME AND THEN DISCARD THE RESULT UNLESS SAVED
        $Results = $Jobs | Receive-Job
        $Results
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target computer(s)')]
        [ValidateScript( { Test-Connection -ComputerName $_ -Count 1 -Quiet })]
        [Alias('CN', 'Target', 'Host')]
        [string[]] $ComputerName,

        [Parameter(Mandatory, HelpMessage = 'Script to execute on remote system')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Filter *.ps1 })]
        [Alias('FilePath', 'File', 'Script', 'Path')]
        [String] $ScriptPath,

        [Parameter(HelpMessage = 'Argument list')]
        [Alias('Args')]
        [String[]] $ArgumentList,

        [Parameter(Mandatory, HelpMessage = 'Export path for resutls')]
        [ValidateScript( { Test-Path -Path (Split-Path -Path $_) -PathType Container })]
        [Alias('Output', 'Export')]
        [string] $OutputPath
    )

    # SETUP PARAMETERS AND ARGUMENTS FOR DEPLOYMENT
    $Splat = @{
        Session  = New-PSSession -ComputerName $ComputerName
        FilePath = $ScriptPath
        AsJob    = $true
        JobName  = 'DeployScript'
    }
    if ( $PSBoundParameters.ContainsKey('ArgumentList') ) { $Splat.ArgumentList = $ArgumentList }

    # RUN SCRIPT IN ALL SESSIONS
    $Job = Invoke-Command @Splat

    # WAIT FOR ALL JOBS TO COMPLETE AND SHOW RESULTS
    ($Job | Wait-Job).ChildJobs | Select-Object -Property Location, State, Output

    # SAVE RESULTS
    $Job.ChildJobs | Export-Csv -NoTypeInformation -Path $OutputPath -Force
}
