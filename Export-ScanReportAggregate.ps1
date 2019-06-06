#Requires -Module ImportExcel

function Export-ScanReportAggregate {
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
    .PARAMETER DestinationPath
        Path to output directory
    .INPUTS
        System.String. Format-ScanResults accepts string values for SystemScan
        and WebScan parameters.
    .OUTPUTS
        Com.Excel.Application. Format-ScanResults returns an Excel spreadsheet
    .EXAMPLE
        PS C:\> Export-ScanReportAggregate -SystemScan $Sys -WebScan $Web
        Merge and aggregate data from $Sys and $Web scans into a pre-filtered
        report for easy review.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Path to output directory')]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [Alias('DP', 'Destination', 'Folder')]
        [string] $DestinationPath = "$HOME\Desktop",

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

    Begin {
        # IMPORT REQUIRED MODULES
        Import-Module -Name ImportExcel

        # SET VARS
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
            @{N = 'Status'; E = { $_.'Active or inactive' }}
        )

        # SET REPORT OPTIONS
        $Splat = @{
            #AutoSize      = $true
            AutoFilter   = $true
            FreezeTopRow = $true
            BoldTopRow   = $true
            MoveToEnd    = $true
            Path         = Join-Path -Path $DestinationPath -ChildPath ('Aggregate-Scans_{0}.xlsx' -f (Get-Date -F "yyyy-MM"))
        }
    }

    Process {
        # PROCESS DB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('DatabaseScan') ) {
            $DbCsv = Import-Csv -Path $DatabaseScan
            foreach ( $i in $DbCsv ) { $i | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Database Scan' }

            # EXPORT DB DATA TO EXCEL
            $DbCsv | Select-Object -ExcludeProperty Source | Export-Excel @Splat -WorksheetName 'DBScan'
        }

        # PROCESS WEB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('WebScan') ) {
            $WebCsv = Import-Csv -Path $WebScan
            foreach ( $i in $WebCsv ) { $i | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Web Scan' }

            # EXPORT WEB DATA TO EXCEL
            $WebCsv | Select-Object -Property $Properties | Export-Excel @Splat -WorksheetName 'WebScan'
        }

        # PROCESS SYSTEM SCAN DATA
        if ( $PSBoundParameters.ContainsKey('SystemScan') ) {
            $SystemCsv = Import-Csv -Path $SystemScan
            foreach ( $i in $SystemCsv ) { $i | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'System Scan' }

            # ADD SYSTEM SPECIFIC PROPERTIES
            $Properties += @("Detected OS", "CVE")

            # EXPORT SYSTEM DATA TO EXCEL
            $SystemCsv | Select-Object -Property $Properties | Export-Excel @Splat -WorksheetName 'SystemScan'
        }
    }
}