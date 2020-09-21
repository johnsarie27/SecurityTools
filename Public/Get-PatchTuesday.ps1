function Get-PatchTuesday {
    <# =========================================================================
	.SYNOPSIS
		Get the Patch Tuesday of a month
	.PARAMETER Month
		The month to check
	.PARAMETER Year
		The year to check
	.EXAMPLE
		Get-PatchTue -Month 6 -Year 2015
	.EXAMPLE
		Get-PatchTue June 2015
	.Notes
		https://gallery.technet.microsoft.com/scriptcenter/Find-Patch-Tuesday-using-94484479
	========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Target month')]
        [string] $Month = (Get-Date).Month,

        [Parameter(HelpMessage = 'Target year')]
        [string] $Year = (Get-Date).Year,

        [Parameter(HelpMessage = 'Day of Week')]
        [ValidateSet('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')]
        [String] $WeekDay = 'Tuesday',

        [Parameter(HelpMessage = 'Week of month')]
        [ValidateRange(0, 5)]
        [int] $WeekOfMonth = 2
    )

    Process {
        # GET BOTH THE FIRST AND LAST DAYS OF THE MONTH
        $firstDayOfMonth = [datetime] ('{0}/1/{1}' -f $Month, $Year)
        #$firstDayOfMonth = Get-Date (Get-Date) -Day 1 -Hour 0 -Minute 0 -Second 0
        $lastDayOfMonth = $firstDayOfMonth.AddMonths(1).AddSeconds(-1)

        # GET THE SECOND TUESDAY OF THE MONTH
        $n = $WeekOfMonth - 1
        (0..($lastDayOfMonth.Day) | ForEach-Object { $firstDayOfMonth.AddDays($_) } | Where-Object { $_.DayOfWeek -eq $WeekDay })[$n]
        <# $daysOfMonth = foreach ( $day in 0..($lastDayOfMonth.Day) ) { $firstDayOfMonth.AddDays($day) }
        $daysOfMonth | Where-Object -FilterScript { $_.DayOfWeek -eq $WeekDay } | Select-Object -Skip $n -First 1 #>
    }
}
