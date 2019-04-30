function Export-ScanReportSummary {
    <# =========================================================================
    .SYNOPSIS
        Summarize scan results into a single report
    .DESCRIPTION
        This function takes a web scan and system scan report and merges the
        pertinent information into a summary view of the vulnerabilities found
    .PARAMETER SystemScan
        Path to System scan CSV file
    .PARAMETER WebScan
        Path to Web scan CSV file
    .PARAMETER DatabaseScan
        Path to Database scan CSV file
    .PARAMETER ExistingReport
        Path to existing Excel Workbook so new data can be added
    .INPUTS
        System.String. Export-ScanReportSummary accepts string values for SystemScan
        and WebScan parameters.
    .OUTPUTS
        Com.Excel.Application. Export-ScanReportSummary returns an Excel spreadsheet
    .EXAMPLE
        PS C:\> Export-ScanReportSummary -SystemScan $Sys -WebScan $Web
        Merge and aggregate data from $Sys and $Web scans and return an Excel
        spreadsheet file.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'all', HelpMessage = 'CSV file for system scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysweb', HelpMessage = 'CSV file for system scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sys', HelpMessage = 'CSV file for system scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [ValidateNotNullOrEmpty()]
        [Alias('SystemPath', 'SystemFile', 'SS')]
        [string] $SystemScan,

        [Parameter(Mandatory, ParameterSetName = 'all', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysweb', HelpMessage = 'CSV file for system scan report')]
        [Parameter(Mandatory, ParameterSetName = 'web', HelpMessage = 'CSV file for web scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [ValidateNotNullOrEmpty()]
        [Alias('WebPath', 'WebFile', 'WS')]
        [string] $WebScan,

        [Parameter(Mandatory, ParameterSetName = 'all', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = 'db', HelpMessage = 'CSV file for web scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [ValidateNotNullOrEmpty()]
        [Alias('DbScan', 'DatabasePath', 'DbFile', 'DS')]
        [string] $DatabaseScan,

        [Parameter(HelpMessage = 'Create new Excel spreadsheet file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.xlsx" })]
        [Alias('Aggregate', 'File', 'Path')]
        [string] $ExistingReport
    )

    Begin {
        # IMPORT REQUIRED MODULES
        Import-Module -Name UtilityFunctions

        $Properties = @('Name', 'Severity', 'Source', 'Count', 'Notes', 'Risk Adj.', 'Status', 'TFS')
        # 'CVSS'

        # SET REPORT OPTIONS
        $Splat = @{
            SheetName = (Get-Date -UFormat %b).ToUpper()
            AutoSize  = $true
            Freeze    = $true
        }

        # ADD PATH TO EXCEL PARAMS
        $ReportPath = "$HOME\Desktop" ; $Date = Get-Date -Format "yyyy-MM"
        if ( $PSBoundParameters.ContainsKey('ExistingReport') ) {
            $Splat.Path = $ExistingReport
        } else {
            $Splat.Path = Join-Path -Path $ReportPath -ChildPath ('Scan-Summary-Report_{0}.xlsx' -f $Date)
        }
    }

    Process {
        # PROCESS DATABASE SCAN DATA
        if ( $PSBoundParameters.ContainsKey('DatabaseScan') ) {
            $DbCsv = Import-Csv -Path $DatabaseScan
            $UDbCsv = $DbCsv | Sort-Object Name -Unique
            $UDbCsv | ForEach-Object -Process {
                $Count = ($DbCsv | Where-Object Name -EQ $_.Name | Measure-Object).Count
                $_ | Add-Member -MemberType NoteProperty -Name 'Count' -Value $Count
                $_ | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'DB Scan'
                $_ | Add-Member -MemberType NoteProperty -Name 'Notes' -Value ''
                $_ | Add-Member -MemberType NoteProperty -Name 'Risk Adj.' -Value ''
                $_ | Add-Member -MemberType NoteProperty -Name 'TFS' -Value 0
            }
        }

        # PROCESS SYSTEM SCAN DATA
        if ( $PSBoundParameters.ContainsKey('SystemScan') ) {
            $SystemCsv = Import-Csv -Path $SystemScan
            $USysCsv = $SystemCsv | Sort-Object Name -Unique
            foreach ( $object in $USysCsv ) {
                $Count = ($SystemCsv | Where-Object Name -eq $object.Name | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $Count
                $object | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'System Scan'
                $object | Add-Member -MemberType NoteProperty -Name 'Notes' -Value ''
                $object | Add-Member -MemberType NoteProperty -Name 'Risk Adj.' -Value ''
                $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value 0
                $object | Add-Member -MemberType NoteProperty -Name 'Status' -Value $object.'Active or inactive'
            }
        }

        # PROCESS WEB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('WebScan') ) {
            $WebCsv = Import-Csv -Path $WebScan
            $UWebCsv = $WebCsv | Sort-Object Name -Unique
            foreach ( $object in $UWebCsv ) {
                $Count = ($WebCsv | Where-Object Name -eq $object.Name | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $Count
                $object | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Web Scan'
                $object | Add-Member -MemberType NoteProperty -Name 'Notes' -Value ''
                $object | Add-Member -MemberType NoteProperty -Name 'Risk Adj.' -Value ''
                $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value 0
                $object | Add-Member -MemberType NoteProperty -Name 'Status' -Value $object.'Active or inactive'
            }
        }

        # COMBINE UNIQUE OBJECTS AND REMOVE FIELDS
        $ScanObjects = $USysCsv + $UWebCsv + $UDbCsv
    }

    End {
        # EXPORT TO EXCEL
        $ScanObjects | Select-Object -Property $Properties | Export-ExcelBook @Splat
    }
}