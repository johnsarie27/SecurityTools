function Get-ItemAge {
    <#
    .SYNOPSIS
        Generate age information for a directory of files and sub-files
    .DESCRIPTION
        This function generates a report of content details for a given folder.
    .PARAMETER Path
        Full path to the target directory for which the report should be
        generated.
    .PARAMETER NoRecurse
        This switch parameter causes the scan of only the first level of
        folders.
    .PARAMETER AgeInDays
        Sample age to measure number of files created since.
    .INPUTS
        System.String.
        System.Int.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ItemAge -Directory 'D:\Database\logs' -AgeInDays 7
        Get all content details for D:\Database\logs using 7 day measurement
    .NOTES
        https://blogs.technet.microsoft.com/pstips/2017/05/20/display-friendly-file-sizes-in-powershell/
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-6
    #>
    [CmdletBinding()]
    [Alias('Get-DirItemAges')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target directory')]
        [ValidateScript( { Test-Path -Path $_ -PathType Container })]
        [Alias('Directory', 'Folder')]
        [System.String] $Path,

        [Parameter(HelpMessage = 'Sample age to measure files create before/after')]
        [ValidateRange(1, 365)]
        [System.Int32] $AgeInDays = 7,

        [Parameter(HelpMessage = 'Do not recurse through children directories')]
        [System.Management.Automation.SwitchParameter] $NoRecurse
    )
    Process {
        if ( $NoRecurse ) { $Deep = $false } else { $Deep = $true }
        $Splatter = @{ Recurse = $Deep }

        $Tot = Get-ChildItem $Path @Splatter | Measure-Object | Select-Object -exp Count
        $Avg = [math]::round(((Get-ChildItem $Path @Splatter | Measure-Object -Property Length -Average | Select-Object -exp Average) / 1mb ), 2 )
        $Sum = [math]::round(((Get-ChildItem $Path @Splatter | Measure-Object -Property Length -Sum).Sum / 1gb), 2)

        $OldestFile = Get-ChildItem $Path @Splatter | Sort-Object LastWriteTime | Select-Object -First 1 Name, LastWriteTime
        $NewestFile = Get-ChildItem $Path @Splatter | Sort-Object LastWriteTime | Select-Object -Last 1 Name, LastWriteTime

        $OldFileList = [System.Collections.Generic.List[System.Object]]::new()
        $NewerFileList = [System.Collections.Generic.List[System.Object]]::new()
        foreach ( $item in (Get-ChildItem -Path $Path @Splatter) ) {
            $FileAge = New-TimeSpan -Start $item.LastWriteTime -End (Get-Date)
            if ( $FileAge.Days -ge $AgeInDays ) { $OldFileList.Add($item) }
            else { $NewerFileList.Add($item) }
        }

        # GENERATE REPORT
        $New = New-Object -Type psobject
        $New | Add-Member -MemberType NoteProperty -Name Deep -Value $Deep
        $New | Add-Member -MemberType NoteProperty -Name Date -Value ( Get-Date )
        $New | Add-Member -MemberType NoteProperty -Name ComputerName -Value ( hostname )
        $New | Add-Member -MemberType NoteProperty -Name Directory -Value (Get-Item $Path | Select-Object -EXP FullName)
        $New | Add-Member -MemberType NoteProperty -Name TotalFiles -Value $Tot
        $New | Add-Member -MemberType NoteProperty -Name "AverageFileSize(MB)" -Value $Avg
        $New | Add-Member -MemberType NoteProperty -Name "TotalVolume(GB)" -Value $Sum
        $New | Add-Member -MemberType NoteProperty -Name OldestFile -Value $OldestFile
        $New | Add-Member -MemberType NoteProperty -Name NewestFile -Value $NewestFile
        $New | Add-Member -MemberType NoteProperty -Name "OlderThan$AgeInDays-Days" -Value $OldFileList.Count
        $New | Add-Member -MemberType NoteProperty -Name "NewerThan$AgeInDays-Days" -Value $NewerFileList.Count

        $New
    }
}
