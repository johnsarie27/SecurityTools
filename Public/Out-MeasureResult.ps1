function Out-MeasureResult {
    <#
    .SYNOPSIS
        Outputs an object that shows maximum, minimum and average of an collection of
        System.TimeSpan objects.
    .DESCRIPTION
        Outputs an object that shows maximum, minimum and average of an collection of
        System.TimeSpan objects.
    .PARAMETER Measurement
        Array of System.TimeSpan objects to measure
    .EXAMPLE
        $measured = [System.Collections.Generic.List[System.TimeSpan]]::new()
        foreach ($run in (0..9)) {

            [System.GC]::Collect()

            $measure = Measure-Command -Expression {
                $stringBuilder = [System.Text.StringBuilder]::new()
                foreach ($int in (0..10000)) {
                    $stringBuilder.Append(" ")
                }
            }
        $measured.Add($measure)
        }

        $measured | Out-MeasureResult | Format-List

        MaxMilliseconds : 2570,0842
        MinMilliseconds : 1852,0017
        AvgMilliseconds : 2241,86343

    .INPUTS
        System.TimeSpan.
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .NOTES
        Status: Stable
        This function comes from the chapter Increasing PowerShell Performance
        in the "PowerShell Conference Book"
    #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [System.Timespan[]] $Measurement
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        # CREATE LIST COLLECTION
        $list = [System.Collections.Generic.List[System.TimeSpan]]::new()
    }
    Process {
        if ($Measurement -is [System.Array]) { $list.AddRange($Measurement) }
        else { $list.Add($Measurement) }
    }
    End {
        $max = ($list | Measure-Object -Property Ticks -Maximum).Maximum
        $min = ($list | Measure-Object -Property Ticks -Minimum).Minimum
        $avg = $list | Measure-Object -Property TotalMilliseconds -Average

        $maxObj = $list.Where( { $_.Ticks -eq $max } )
        $minObj = $list.Where( { $_.Ticks -eq $min } )

        [PSCustomObject] @{
            MaxMilliseconds = [System.Int32] $maxObj.TotalMilliseconds
            MinMilliseconds = [System.Int32] $minObj.TotalMilliseconds
            AvgMilliseconds = [System.Int32] $avg.Average
        }
    }
}
