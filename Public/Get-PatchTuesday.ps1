function Get-PatchTuesday {
    <#
    .SYNOPSIS
        Get the Patch Tuesday of a month
    .DESCRIPTION
        Get the Patch Tuesday, or any other day, of a month
    .PARAMETER Month
        The month to check
    .PARAMETER Year
        The year to check
    .PARAMETER DayOfWeek
        Day of week
    .PARAMETER WeekOfMonth
        Week of month
    .INPUTS
        None.
    .OUTPUTS
        System.DateTime.
    .EXAMPLE
        Get-PatchTue -Month 6 -Year 2015
    .EXAMPLE
        Get-PatchTue June 2015
    .Notes
        https://gallery.technet.microsoft.com/scriptcenter/Find-Patch-Tuesday-using-94484479
    #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Month')]
        [ValidateRange(1, 12)]
        [System.Int32] $Month = (Get-Date).Month,

        [Parameter(HelpMessage = 'Year')]
        [ValidateRange(1900, 2301)]
        [System.Int32] $Year = (Get-Date).Year,

        [Parameter(HelpMessage = 'Day of week')]
        [ValidateSet('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')]
        [Alias('WeekDay')]
        [System.String] $DayOfWeek = 'Tuesday',

        [Parameter(HelpMessage = 'Week of month')]
        [ValidateRange(1, 5)]
        [System.Int32] $WeekOfMonth = 2
    )
    Process {
        # GET FIRST OF THE MONTH
        $firstDayOfMonth = Get-Date -Month $Month -Year $Year -Day 1 -Hour 0 -Minute 0 -Second 0
        Write-Verbose -Message ('First day of month: {0}' -f $firstDayOfMonth)

        # GET LAST DAY OF MONTH
        $lastDayOfMonth = $firstDayOfMonth.AddMonths(1).AddSeconds(-1)
        Write-Verbose -Message ('Last day of month: {0}' -f $lastDayOfMonth)

        # SET NUMBER OF WEEKS TO SKIP
        $n = $WeekOfMonth - 1

        <# # GET THE SECOND TUESDAY OF THE MONTH
        (0..($lastDayOfMonth.Day) | ForEach-Object { $firstDayOfMonth.AddDays($_) }
            | Where-Object { $_.DayOfWeek -eq $DayOfWeek })[$n] #>

        # GET EACH DAY OF THE MONTH
        $daysOfMonth = foreach ( $day in 0..($lastDayOfMonth.Day-1) ) { $firstDayOfMonth.AddDays($day) }

        # GET ALL DAYS OF THE WEEK IN THE SPECIFIED MONTH, SKIP UNSELECT WEEKS AND OUTPUT SELECTED WEEK
        $daysOfMonth | Where-Object { $_.DayOfWeek -EQ $DayOfWeek } | Select-Object -Skip $n -First 1
    }
}
