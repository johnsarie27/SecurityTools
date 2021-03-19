function Export-ScanReportAggregate {
    <# =========================================================================
    .SYNOPSIS
        Aggregate and merge scan results into a single report
    .DESCRIPTION
        This function takes a web scan and system scan report and applies
        standard filters and columns to each for easy review in a single
        spreadsheet with multiple tabs.
    .PARAMETER OutputDirectory
        Path to output directory
    .PARAMETER NessusScan
        Path to System scan as a sting
    .PARAMETER AlertLogicWebScan
        Path to Web scan as a string
    .PARAMETER DatabaseScan
        Path to Database scan as a string
    .PARAMETER AcunetixScan
        Path to Authenticated Web scan as a string
    .INPUTS
        System.String. Format-ScanResults accepts string values for SystemScan
        and AlertLogicWebScan parameters.
    .OUTPUTS
        Com.Excel.Application. Format-ScanResults returns an Excel spreadsheet
    .EXAMPLE
        PS C:\> Export-ScanReportAggregate -SystemScan $Sys -AlertLogicWebScan $Web
        Merge and aggregate data from $Sys and $Web scans into a pre-filtered
        report for easy review.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Path to output directory')]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [Alias('DestinationPath')]
        [string] $OutputDirectory = "$HOME\Desktop",

        [Parameter(Mandatory = $false, HelpMessage = 'CSV file for Nessus scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [string] $NessusScan,

        [Parameter(Mandatory = $false, HelpMessage = 'CSV file for AlertLogic web scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [string] $AlertLogicWebScan,

        [Parameter(Mandatory = $false, HelpMessage = 'CSV file for AlertLogic system scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [string] $AlertLogicSystemScan,

        [Parameter(Mandatory = $false, HelpMessage = 'XLSX file for SQL scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.xlsx" })]
        [string] $DatabaseScan,

        [Parameter(Mandatory = $false, HelpMessage = 'CSV file for Acunetix scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [string] $AcunetixScan
    )

    Begin {
        # PROVIDE HELP FOR THE USER WHEN NO SCANS ARE DECLARED
        $requiredParams = @('NessusScan', 'AlertLogicSystemScan', 'AlertLogicWebScan', 'DatabaseScan', 'AcunetixScan')
        foreach ( $param in $requiredParams ) {
            if ( $param -notin $PSBoundParameters.Keys ) { $fail = $true } else { $fail = $false; break }
        }
        if ( $fail ) { Throw 'Missing scan reports to summarize. Please provide at least one scan report.' }

        # IMPORT REQUIRED MODULES
        Import-Module -Name ImportExcel

        # SET VARS
        $alProperties = @(
            'IP-address'
            'Detected Hostname'
            'Port number'
            'Exposure ID'
            'Name'
            'Protocol'
            'Service Description'
            'Severity'
            'CVSS'
            'Description'
            'Impact'
            'Resolution'
            'Evidence'
            'References'
            @{ Name = 'Status'; Expression = { $_.'Active or inactive' } }
        )

        $authWebProps = @(
            'Name'
            'ModuleName'
            'Details'
            'Parameter'
            'IsFalsePositive'
            'Severity'
            'Type'
            'Impact'
            'Description'
            'Detailed Information'
            'Recommendation'
            'Request'
            'CWEList'
            'CVEList'
            'CVSS Score'
            'CVSS3 Score'
            @{ Name = 'Reference'; Expression = { $_.'Reference (Name|Url' } }
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
        # PROCESS INDIVIDUAL SCAN DATA
        if ( $PSBoundParameters.ContainsKey('AlertLogicWebScan') ) {
            $webCsv = Import-Csv -Path $AlertLogicWebScan
            #foreach ( $i in $webCsv ) { $i | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Web Scan' }

            # EXPORT WEB DATA TO EXCEL
            $webCsv | Select-Object -Property $alProperties | Export-Excel @splat -WorksheetName 'WebScan'
        }
        if ( $PSBoundParameters.ContainsKey('AlertLogicSystemScan') ) {
            $systemCsv = Import-Csv -Path $AlertLogicSystemScan

            $alProperties += @('Detected OS', 'CVE')
            $systemCsv | Select-Object -Property $alProperties | Export-Excel @splat -WorksheetName 'SystemScan'
        }
        if ( $PSBoundParameters.ContainsKey('AcunetixScan') ) {
            $authCsv = Import-Csv -Path $AcunetixScan
            $authCsv | Select-Object -Property $authWebProps | Export-Excel @splat -WorksheetName 'Acunetix'
        }
        if ( $PSBoundParameters.ContainsKey('NessusScan') ) {
            $nessusCsv = Import-Csv -Path $NessusScan
            $nessusCsv | Export-Excel @splat -WorksheetName 'Nessus'
        }
        if ( $PSBoundParameters.ContainsKey('DatabaseScan') ) {
            $DatabaseScan = (Resolve-Path -Path $DatabaseScan).Path
            $dbScan = Import-Excel -Path $DatabaseScan -WorksheetName 'DBScan'
            $dbScan | Export-Excel @splat -WorksheetName 'DBScan'
        }
    }
}