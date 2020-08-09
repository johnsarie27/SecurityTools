#Requires -Modules @{ ModuleName = 'ImportExcel'; ModuleVersion = '6.5.0' }

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
    .PARAMETER OutputDirectory
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
        [Alias('DestinationPath')]
        [string] $OutputDirectory = "$HOME\Desktop",

        [Parameter(Mandatory, ParameterSetName = 'sys', HelpMessage = 'CSV file for system scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysweb')]
        [Parameter(Mandatory, ParameterSetName = 'sysdb')]
        [Parameter(Mandatory, ParameterSetName = 'all')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [string] $SystemScan,

        [Parameter(Mandatory, ParameterSetName = 'web', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysweb')]
        [Parameter(Mandatory, ParameterSetName = 'webdb')]
        [Parameter(Mandatory, ParameterSetName = 'all')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [string] $WebScan,

        [Parameter(Mandatory, ParameterSetName = 'db', HelpMessage = 'CSV file for DB scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysdb')]
        [Parameter(Mandatory, ParameterSetName = 'webdb')]
        [Parameter(Mandatory, ParameterSetName = 'all')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.xlsx" })]
        [string] $DatabaseScan
    )

    Begin {
        # IMPORT REQUIRED MODULES
        Import-Module -Name ImportExcel

        # SET VARS
        $properties = @(
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
        $splat = @{
            #AutoSize      = $true
            AutoFilter   = $true
            FreezeTopRow = $true
            BoldTopRow   = $true
            MoveToEnd    = $true
            Style        = (New-ExcelStyle -Bold -Range '1:1' -HorizontalAlignment Center)
            Path         = Join-Path -Path $OutputDirectory -ChildPath ('Aggregate-Scans_{0:yyyy-MM}.xlsx' -f (Get-Date))
        }
    }

    Process {
        # PROCESS WEB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('WebScan') ) {
            $webCsv = Import-Csv -Path $WebScan
            #foreach ( $i in $webCsv ) { $i | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Web Scan' }

            # EXPORT WEB DATA TO EXCEL
            $webCsv | Select-Object -Property $properties | Export-Excel @splat -WorksheetName 'WebScan'
        }

        # PROCESS SYSTEM SCAN DATA
        if ( $PSBoundParameters.ContainsKey('SystemScan') ) {
            $systemCsv = Import-Csv -Path $SystemScan
            #foreach ( $i in $systemCsv ) { $i | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'System Scan' }

            # ADD SYSTEM SPECIFIC PROPERTIES
            $properties += @("Detected OS", "CVE")

            # EXPORT SYSTEM DATA TO EXCEL
            $systemCsv | Select-Object -Property $properties | Export-Excel @splat -WorksheetName 'SystemScan'
        }

        # PROCESS DB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('DatabaseScan') ) {
            $DatabaseScan = (Resolve-Path -Path $DatabaseScan).Path
            $dbScan = Import-Excel -Path $DatabaseScan -WorksheetName 'DBScan'
            #foreach ( $i in $dbScan ) { $i | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Database Scan' }

            # EXPORT DB DATA TO EXCEL
            $dbScan | Export-Excel @splat -WorksheetName 'DBScan'
        }
    }
}