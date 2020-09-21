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
        #[ValidateSet('example-1','example-2')]
        [string] $Month = (Get-Date).Month,

        [Parameter(HelpMessage = 'Target year')]
        #[ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.json" })]
        [string] $Year = (Get-Date).Year
    )

    Process {
        # GET BOTH THE FIRST AND LAST DAYS OF THE MONTH
        $firstDayOfMonth = [datetime] ('{0}/1/{1}' -f $Month, $Year)
        #$firstDayOfMonth = Get-Date (Get-Date) -Day 1 -Hour 0 -Minute 0 -Second 0
        $lastDayOfMonth = $firstDayOfMonth.AddMonths(1).AddSeconds(-1)

        # GET THE SECOND TUESDAY OF THE MONTH
        (0..($lastDayOfMonth.Day) | ForEach-Object { $firstDayOfMonth.AddDays($_) } | Where-Object { $_.DayOfWeek -like "Tue*" })[1]
    }
}
