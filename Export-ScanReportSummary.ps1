#Requires -Module ImportExcel

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
    .PARAMETER DestinationPath
        Path to new or existing Excel Workbook
    .INPUTS
        None.
    .OUTPUTS
        None.
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
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.csv" })]
        [ValidateNotNullOrEmpty()]
        [Alias('SystemPath', 'SystemFile', 'SS')]
        [string] $SystemScan,

        [Parameter(Mandatory, ParameterSetName = 'all', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysweb', HelpMessage = 'CSV file for system scan report')]
        [Parameter(Mandatory, ParameterSetName = 'web', HelpMessage = 'CSV file for web scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.csv" })]
        [ValidateNotNullOrEmpty()]
        [Alias('WebPath', 'WebFile', 'WS')]
        [string] $WebScan,

        [Parameter(Mandatory, ParameterSetName = 'all', HelpMessage = 'XLSX file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = 'db', HelpMessage = 'XLSX file for web scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter *.xlsx })]
        [ValidateNotNullOrEmpty()]
        [Alias('DbScan', 'DatabasePath', 'DbFile', 'DS')]
        [string] $DatabaseScan,

        [Parameter(HelpMessage = 'Path to new or existing Excel spreadsheet file')]
        [ValidateScript({ Confirm-ValidPath -Path $_ -Extension '.xlsx' -Force })]
        [Alias('File', 'Path')]
        [string] $DestinationPath
    )

    Begin {
        # IMPORT REQUIRED MODULES
        Import-Module -Name ImportExcel

        # ADD PATH TO EXCEL PARAMS
        $ReportPath = "$HOME\Desktop"; $Date = Get-Date -Format "yyyy-MM"
    }

    Process {
        # PROCESS DATABASE SCAN DATA
        if ( $PSBoundParameters.ContainsKey('DatabaseScan') ) {
            $DbScan = Import-Excel -Path $DatabaseScan -WorksheetName 'DBScan'
            $UDbScan = $DbScan <# | Where-Object Status -EQ 'Fail'  #>| Sort-Object -Unique ID
            foreach ( $object in $UDbScan ) {
                # CREATE COLUMNS FOR SUMMARY REPORT
                $Count = ($DbScan | Where-Object ID -EQ $object.ID | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $Count
                $object | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'DB Scan'
                $object | Add-Member -MemberType NoteProperty -Name 'Risk Adj.' -Value ''
                $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value 0

                <# # ADDING THE PROPERTIES BELOW IS SLOWER THAN DEFINING AND SELECTING PROPERTIES
                # KEEPING THIS HERE FOR HISTORICAL PURPOSES
                $object | Add-Member -MemberType NoteProperty -Name 'Name' -Value $object.'Security Check'
                $object | Add-Member -MemberType NoteProperty -Name 'Notes' -Value $object.ID
                $object | Add-Member -MemberType NoteProperty -Name 'Severity' -Value $object.Risk #>
            }

            # SET PROPERTY CONVERSION
            $NewProps = (
                'Count', 'Source', 'Risk Adj.', 'TFS', 'Status',
                @{N = 'Name'; E = { $_.'Security Check' } },
                @{N = 'Notes'; E = { $_.ID } },
                @{N = 'Severity'; E = { $_.Risk } }
            )

            # CHANGE COLUMN NAMES
            $UDbScan = $UDbScan | Select-Object -Property $NewProps
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
    }

    End {
        # COMBINE UNIQUE OBJECTS AND REMOVE FIELDS
        $ScanObjects = $USysCsv + $UWebCsv + $UDbScan

        # SET REPORT OPTIONS
        $Splat = @{
            WorksheetName = (Get-Date -UFormat %b).ToUpper()
            AutoSize     = $true
            AutoFilter   = $true
            FreezeTopRow = $true
            BoldTopRow   = $true
            MoveToEnd    = $true
        }

        # ADD PATH PARAMETER AND ARGUMENT
        if ( $PSBoundParameters.ContainsKey('DestinationPath') ) { $Splat['Path'] = $DestinationPath }
        else { $Splat['Path'] = Join-Path -Path $ReportPath -ChildPath ('Summary-Scans_{0}.xlsx' -f $Date) }

        # SET DESIRED PROPERTIES
        $Properties = @('Name', 'Severity', 'Source', 'Count', 'Notes', 'Risk Adj.', 'Status', 'TFS')#'CVSS'

        # EXPORT TO EXCEL
        $ScanObjects | Select-Object -Property $Properties | Export-Excel @Splat
    }
}