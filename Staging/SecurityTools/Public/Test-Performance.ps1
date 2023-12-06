function Test-Performance {
    <# =========================================================================
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
        PS C:\> Test-Performance -SB $S

        Run ScriptBlock $S 10 times and returns statistical results as shown below:

        MaxMilliseconds : 3897
        MinMilliseconds : 3756
        AvgMilliseconds : 3824
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage='ScriptBlock to test performance')]
        [ValidateNotNullOrEmpty()]
        [Alias('SB')]
        [System.Management.Automation.ScriptBlock] $ScriptBlock,

        [Parameter(HelpMessage = 'Number of test runs')]
        [ValidateRange(10, 10000)]
        [System.Int32] $Runs = 10,

        [Parameter(HelpMessage = 'Show all run results in milliseconds')]
        [Alias('All', 'ShowAll')]
        [System.Management.Automation.SwitchParameter] $ShowResults
    )

    # CREATE COLLECTION
    $Measurements = [System.Collections.Generic.List[System.TimeSpan]]::new()

    # LOOP THROUGH TEST 10 TIMES
    foreach ( $run in (0..$Runs) ) {

        # RUN GARBAGE COLLECTION
        [System.GC]::Collect()

        # MEASURE RUN
        $Measure = Measure-Command -Expression $ScriptBlock

        # ADD MEASURE TO MEASUREMENT COLLECTION
        $Measurements.Add($Measure)
    }

    # RETURN MEASUREMENT STATISTICS
    $Measurements | Out-MeasureResult | Format-List

    # RETURN ALL RESULTS IN MILLISECONDS
    if ( $PSBoundParameters.ContainsKey('ShowResults') ) { $Measurements.TotalMilliseconds }
}