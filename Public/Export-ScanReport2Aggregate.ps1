function Export-ScanReport2Aggregate {
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
    .PARAMETER WebScan
        Path to Web scan as a string
    .PARAMETER DatabaseScan
        Path to Database scan as a string
    .PARAMETER AcunetixScan
        Path to Authenticated Web scan as a string
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

        [Parameter(ParameterSetName = '__sys', HelpMessage = 'CSV file for system scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [string] $NessusScan,

        [Parameter(ParameterSetName = '__web', HelpMessage = 'CSV file for web scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [string] $WebScan,

        [Parameter(ParameterSetName = '__dbs', HelpMessage = 'CSV file for DB scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.xlsx" })]
        [string] $DatabaseScan,

        [Parameter(ParameterSetName = '__aut', HelpMessage = 'CSV file for authenticated web scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [string] $AcunetixScan
    )

    Begin {
        # IMPORT REQUIRED MODULES
        Import-Module -Name ImportExcel

        # SET VARS
        $webProps = @(
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

        if ( $PSCmdlet.ParameterSetName -notin @('__sys', '__dbs'. '__web'.'__aut') ) {
            Throw 'Please enter parameters for report aggregation'
        }
    }

    Process {
        # PROCESS WEB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('WebScan') ) {
            $webCsv = Import-Csv -Path $WebScan
            #foreach ( $i in $webCsv ) { $i | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Web Scan' }

            # EXPORT WEB DATA TO EXCEL
            $webCsv | Select-Object -Property $webProps | Export-Excel @splat -WorksheetName 'WebScan'
        }

        # PROCESS AUTHENTICATED WEB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('AuthenticatedWebScan') ) {
            $authCsv = Import-Csv -Path $AcunetixScan
            #foreach ( $i in $authCsv ) { $i | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Web Scan' }

            # EXPORT AUTHENTICATED WEB DATA TO EXCEL
            $authCsv | Select-Object -Property $authWebProps | Export-Excel @splat -WorksheetName 'Acunetix'
        }

        # PROCESS SYSTEM SCAN DATA
        if ( $PSBoundParameters.ContainsKey('SystemScan') ) {
            $systemCsv = Import-Csv -Path $NessusScan
            #foreach ( $i in $systemCsv ) { $i | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'System Scan' }

            # EXPORT SYSTEM DATA TO EXCEL
            $systemCsv | Export-Excel @splat -WorksheetName 'SystemScan'
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