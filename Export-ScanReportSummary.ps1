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
        [Alias('SS')]
        [string] $SystemScan,

        [Parameter(Mandatory, ParameterSetName = 'all', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysweb', HelpMessage = 'CSV file for system scan report')]
        [Parameter(Mandatory, ParameterSetName = 'web', HelpMessage = 'CSV file for web scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.csv" })]
        [ValidateNotNullOrEmpty()]
        [Alias('WS')]
        [string] $WebScan,

        [Parameter(Mandatory, ParameterSetName = 'all', HelpMessage = 'XLSX file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = 'db', HelpMessage = 'XLSX file for web scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter *.xlsx })]
        [ValidateNotNullOrEmpty()]
        [Alias('DbScan', 'DBS', 'DS')]
        [string] $DatabaseScan,

        [Parameter(HelpMessage = 'Path to new or existing Excel spreadsheet file')]
        [ValidateScript({ Test-Path -Path ([System.IO.Path]::GetDirectoryName($_)) })]
        [ValidateScript({ [System.IO.Path]::GetExtension($_) -eq '.xlsx' })]
        [Alias('DP')]
        [string] $DestinationPath
    )

    Begin {
        # IMPORT REQUIRED MODULES
        Import-Module -Name ImportExcel

        # SET DESTINATION PATH
        if ( -not $PSBoundParameters.ContainsKey('DestinationPath') ) {
            $fileName = 'Summary-Scans_{0}.xlsx' -f (Get-Date -Format "yyyy-MM")
            $DestinationPath = Join-Path -Path "$HOME\Desktop" -ChildPath $fileName
        }
    }

    Process {
        # PROCESS DATABASE SCAN DATA
        if ( $PSBoundParameters.ContainsKey('DatabaseScan') ) {
            $DatabaseScan = (Resolve-Path -Path $DatabaseScan).Path
            $dbScan = Import-Excel -Path $DatabaseScan -WorksheetName 'DBScan'
            $udbScan = $dbScan <# | Where-Object Status -EQ 'Fail'  #>| Sort-Object -Unique ID
            foreach ( $object in $udbScan ) {
                # CREATE COLUMNS FOR SUMMARY REPORT
                $count = ($dbScan | Where-Object ID -EQ $object.ID | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $count
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
            $newProps = (
                'Count', 'Source', 'Risk Adj.', 'TFS', 'Status',
                @{N = 'Name'; E = { $_.'Security Check' } },
                @{N = 'Notes'; E = { $_.ID } },
                @{N = 'Severity'; E = { $_.Risk } }
            )

            # CHANGE COLUMN NAMES
            $udbScan = $udbScan | Select-Object -Property $newProps
        }

        # PROCESS SYSTEM SCAN DATA
        if ( $PSBoundParameters.ContainsKey('SystemScan') ) {
            $systemCsv = Import-Csv -Path $SystemScan
            $uSysCsv = $systemCsv | Sort-Object Name -Unique
            foreach ( $object in $uSysCsv ) {
                $count = ($systemCsv | Where-Object Name -eq $object.Name | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $count
                $object | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'System Scan'
                $object | Add-Member -MemberType NoteProperty -Name 'Notes' -Value ''
                $object | Add-Member -MemberType NoteProperty -Name 'Risk Adj.' -Value ''
                $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value 0
                $object | Add-Member -MemberType NoteProperty -Name 'Status' -Value $object.'Active or inactive'
            }
        }

        # PROCESS WEB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('WebScan') ) {
            $webCsv = Import-Csv -Path $WebScan
            $uWebCsv = $webCsv | Sort-Object Name -Unique
            foreach ( $object in $uWebCsv ) {
                $count = ($webCsv | Where-Object Name -eq $object.Name | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $count
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
        $scanObjects = $uSysCsv + $uWebCsv + $udbScan

        # SET REPORT OPTIONS
        $splat = @{
            WorksheetName = (Get-Date -UFormat %b).ToUpper()
            AutoSize      = $true
            AutoFilter    = $true
            FreezeTopRow  = $true
            BoldTopRow    = $true
            MoveToEnd     = $true
            Style         = (New-ExcelStyle -Bold -Range '1:1' -HorizontalAlignment Center)
            Path          = $DestinationPath
        }

        # SET DESIRED PROPERTIES
        $properties = @('Name', 'Severity', 'Source', 'Count', 'Notes', 'Risk Adj.', 'Status', 'TFS')#'CVSS'

        # EXPORT TO EXCEL
        $scanObjects | Select-Object -Property $properties | Export-Excel @splat
    }
}