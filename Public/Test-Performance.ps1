function Test-Performance {
    <#
    .SYNOPSIS
        Test performance of script block
    .DESCRIPTION
        Test performance of script block over given number of executions
    .PARAMETER ScriptBlock
        ScriptBlock to test performance
    .PARAMETER Runs
        Number of test runs
    .PARAMETER ShowResults
        Show all run results in milliseconds
    .INPUTS
        None.
    .OUTPUTS
        System.Object[].
    .EXAMPLE
        PS C:\> Test-Performance -ScriptBlock { Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 }

        Run ScriptBlock 10 times and returns statistical results as shown below:

        MaxMilliseconds : 3897
        MinMilliseconds : 3756
        AvgMilliseconds : 3824
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'ScriptBlock to test performance')]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.ScriptBlock] $ScriptBlock,

        [Parameter(HelpMessage = 'Number of test runs')]
        [ValidateRange(3, 10000)]
        [System.Int32] $Runs = 10,

        [Parameter(HelpMessage = 'Show all run results in milliseconds')]
        [System.Management.Automation.SwitchParameter] $ShowResults
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # CREATE COLLECTION
        $measurements = [System.Collections.Generic.List[System.TimeSpan]]::new()
    }
    Process {
        # LOOP THROUGH TEST 10 TIMES
        foreach ($run in (0..$Runs)) {

            # RUN GARBAGE COLLECTION
            [System.GC]::Collect()

            # MEASURE RUN
            $measure = Measure-Command -Expression $ScriptBlock

            # ADD MEASURE TO MEASUREMENT COLLECTION
            $measurements.Add($measure)
        }

        # GET RESULTS
        $results = $measurements | Out-MeasureResult

        # CONFIRM REQUESTED RETURN
        if ($PSBoundParameters.ContainsKey('ShowResults')) {
            # ADD ALL MEASUREMENTS TO RESULTS
            $results | Add-Member -NotePropertyMembers @{ Measurements = $measurements.TotalMilliseconds }
        }
    }
    End {
        # RETURN RESULTS
        $results
    }
}
