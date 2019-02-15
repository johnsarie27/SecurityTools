function New-AggregateReport {
    <# =========================================================================
    .SYNOPSIS
        Aggregate and merge scan results into a single report
    .DESCRIPTION
        This function takes a web scan and system scan report and applies
        standard filters and columns to each for easy review in a single
        spreadsheet with multiple tabs.
    .PARAMETER SystemScan
        Path to System scan as a sting
    .PARAMETER WebScan
        Path to Web scan as a string
    .PARAMETER DatabaseScan
        Path to Database scan as a string
    .INPUTS
        System.String. Format-ScanResults accepts string values for SystemScan
        and WebScan parameters.
    .OUTPUTS
        Com.Excel.Application. Format-ScanResults returns an Excel spreadsheet
    .EXAMPLE
        PS C:\> New-AggregateReport -SystemScan $Sys -WebScan $Web
        Merge and aggregate data from $Sys and $Web scans into a pre-filtered
        report for easy review.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'sys', HelpMessage = 'CSV file for system scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysweb')]
        [Parameter(Mandatory, ParameterSetName = 'sysdb')]
        [Parameter(Mandatory, ParameterSetName = 'all')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [Alias('SystemPath', 'SystemFile', 'System')]
        [string] $SystemScan,

        [Parameter(Mandatory, ParameterSetName = 'web', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysweb')]
        [Parameter(Mandatory, ParameterSetName = 'webdb')]
        [Parameter(Mandatory, ParameterSetName = 'all')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [Alias('WebPath', 'WebFile', 'Web')]
        [string] $WebScan,

        [Parameter(Mandatory, ParameterSetName = 'db', HelpMessage = 'CSV file for DB scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysdb')]
        [Parameter(Mandatory, ParameterSetName = 'webdb')]
        [Parameter(Mandatory, ParameterSetName = 'all')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [Alias('DbPath', 'DbFile', 'DataBase', 'D')]
        [string] $DatabaseScan
    )

    Import-Module UtilityFunctions

    $Properties = @(
        "IP-address"
        "Detected Hostname"
        "Port number"
        "Exposure ID"
        "Name"
        "Protocol"
        "Service Description"
        "Severity"
        "CVSS"
        "Description"
        "Impact"
        "Resolution"
        "Evidence"
        "References"
    )

    # GET SAVE FOLDER
    #$Outdir = Get-Folder -Description "Save location"
    $Outdir = "$HOME\Desktop"
    $File = Join-Path -Path $Outdir -ChildPath ('Aggregate-Scans_{0}.xlsx' -f (Get-Date -F "yyyy-MM"))

    # STAGE SPLATTER TABLE
    $Splat = @{ Freeze = $true }
    if ( $PSCmdlet.ParameterSetName -ne 'db' ) { $Splat.SuppressOpen = $true }

    # PROCESS DB SCAN DATA
    if ( $PSBoundParameters.ContainsKey('DatabaseScan') ) {
        $DbCsv = Import-Csv -Path $DatabaseScan
        $DbCsv | ForEach-Object -Process { $_ | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Database Scan' }

        $Splat.SheetName = 'DBScan'
        $Splat.SavePath = $File

        $DbCsv | Select-Object -ExcludeProperty Source | Export-ExcelBook @Splat
    }
        
    # PROCESS WEB SCAN DATA
    if ( $PSBoundParameters.ContainsKey('WebScan') ) {
        $WebCsv = Import-Csv -Path $WebScan
        $WebCsv | ForEach-Object -Process { $_ | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Web Scan' }
        
        $Splat.SheetName = 'WebScan'
        if ( $Splat.SavePath ) { $Splat.Path = $File; $Splat.Remove('SavePath') }
        else { $Splat.SavePath = $File }
        
        $WebCsv | Where-Object {
            $_.'Active or inactive' -ne 'Global inactive' -and $_.Severity -ne 'Informational'
        } | Select-Object -Property $Properties | Export-ExcelBook @Splat
        
        # INACTIVE OR INFO
        $InactiveWeb = $WebCsv | Where-Object {
            $_.'Active or inactive' -match 'inactive' -or $_.Severity -eq 'Informational'
        }
    }

    # PROCESS SYSTEM SCAN DATA
    if ( $PSBoundParameters.ContainsKey('SystemScan') ) {
        $SystemCsv = Import-Csv -Path $SystemScan
        $SystemCsv | ForEach-Object -Process { $_ | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'System Scan' }
        
        $Properties += @("Detected OS", "CVE")
        $Splat.SheetName = 'SystemScan'
        if ( $Splat.SavePath ) { $Splat.Path = $File; $Splat.Remove('SavePath') }
        else { $Splat.SavePath = $File }
        
        $SystemCsv | Where-Object {
            $_.'Active or inactive' -ne 'Global inactive' -and $_.Severity -ne 'Informational'
        } | Select-Object -Property $Properties | Export-ExcelBook @Splat
        
        # INACTIVE OR INFO
        $InactiveSystem = $SystemCsv | Where-Object {
            $_.'Active or inactive' -match 'inactive' -or $_.Severity -eq 'Informational'
        }
    }

    # ADD INACTIVE OR INFORMATIONAL TAB
    if ( $PSCmdlet.ParameterSetName -ne 'db' ) {
        if ( $InactiveWeb -and $InactiveSystem ) { $AllInactive = $InactiveWeb + $InactiveSystem }
        elseif ( $InactiveWeb ) { $AllInactive = $InactiveWeb }
        elseif ( $InactiveSystem ) { $AllInactive = $InactiveSystem }
        $Properties += "Source"
        $Splat.SheetName = 'Inactive' ; $Splat.Remove('SuppressOpen')
        if ( $Splat.SavePath ) { $Splat.Path = $File; $Splat.Remove('SavePath') }
        $AllInactive | Select-Object -Property $Properties | Export-ExcelBook @Splat
    }
}
