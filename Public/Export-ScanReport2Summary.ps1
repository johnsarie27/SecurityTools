function Export-ScanReport2Summary {
    <# =========================================================================
    .SYNOPSIS
        Summarize scan results into a single report
    .DESCRIPTION
        This function takes a web scan and system scan report and merges the
        pertinent information into a summary view of the vulnerabilities found
    .PARAMETER DestinationPath
        Path to new or existing Excel Workbook
    .PARAMETER NessusScan
        Path to System scan CSV file
    .PARAMETER WebScan
        Path to Web scan CSV file
    .PARAMETER DatabaseScan
        Path to Database scan CSV file
    .PARAMETER AcunetixScan
        Path to Acunetix scan CSV file
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Export-ScanReportSummary -NessusScan $Sys -WebScan $Web
        Merge and aggregate data from $Sys and $Web scans and return an Excel
        spreadsheet file.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Path to new or existing Excel spreadsheet file')]
        [ValidateScript({ Test-Path -Path ([System.IO.Path]::GetDirectoryName($_)) })]
        [ValidateScript({ [System.IO.Path]::GetExtension($_) -eq '.xlsx' })]
        [string] $DestinationPath,

        [Parameter(Mandatory, ParameterSetName = '__sys', HelpMessage = 'CSV file for Nessus scan report')]
        [Parameter(Mandatory, ParameterSetName = '__sysweb', HelpMessage = 'CSV file for Nessus scan report')]
        [Parameter(Mandatory, ParameterSetName = '__syssql', HelpMessage = 'CSV file for Nessus scan report')]
        [Parameter(Mandatory, ParameterSetName = '__sysacu', HelpMessage = 'CSV file for Nessus scan report')]
        [Parameter(Mandatory, ParameterSetName = '__syswebacu', HelpMessage = 'CSV file for Nessus scan report')]
        [Parameter(Mandatory, ParameterSetName = '__syswebsql', HelpMessage = 'CSV file for Nessus scan report')]
        [Parameter(Mandatory, ParameterSetName = '__sysacusql', HelpMessage = 'CSV file for Nessus scan report')]
        [Parameter(Mandatory, ParameterSetName = '__all', HelpMessage = 'CSV file for Nessus scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.csv" })]
        [ValidateNotNullOrEmpty()]
        [string] $NessusScan,

        [Parameter(Mandatory, ParameterSetName = '__web', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = '__sysweb', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = '__websql', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = '__webacu', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = '__syswebacu', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = '__syswebsql', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = '__websqlacu', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = '__all', HelpMessage = 'CSV file for web scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.csv" })]
        [ValidateNotNullOrEmpty()]
        [string] $WebScan,

        [Parameter(Mandatory, ParameterSetName = '__sql', HelpMessage = 'XLSX file for SQL scan report')]
        [Parameter(Mandatory, ParameterSetName = '__syssql', HelpMessage = 'XLSX file for SQL scan report')]
        [Parameter(Mandatory, ParameterSetName = '__websql', HelpMessage = 'XLSX file for SQL scan report')]
        [Parameter(Mandatory, ParameterSetName = '__sqlacu', HelpMessage = 'XLSX file for SQL scan report')]
        [Parameter(Mandatory, ParameterSetName = '__syswebsql', HelpMessage = 'XLSX file for SQL scan report')]
        [Parameter(Mandatory, ParameterSetName = '__sysacusql', HelpMessage = 'XLSX file for SQL scan report')]
        [Parameter(Mandatory, ParameterSetName = '__websqlacu', HelpMessage = 'XLSX file for SQL scan report')]
        [Parameter(Mandatory, ParameterSetName = '__all', HelpMessage = 'XLSX file for SQL scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter *.xlsx })]
        [ValidateNotNullOrEmpty()]
        [string] $DatabaseScan,

        [Parameter(Mandatory, ParameterSetName = '__acu', HelpMessage = 'CSV file for Acunetix scan report')]
        [Parameter(Mandatory, ParameterSetName = '__sysacu', HelpMessage = 'CSV file for Acunetix scan report')]
        [Parameter(Mandatory, ParameterSetName = '__webacu', HelpMessage = 'CSV file for Acunetix scan report')]
        [Parameter(Mandatory, ParameterSetName = '__sqlacu', HelpMessage = 'CSV file for Acunetix scan report')]
        [Parameter(Mandatory, ParameterSetName = '__syswebacu', HelpMessage = 'CSV file for Acunetix scan report')]
        [Parameter(Mandatory, ParameterSetName = '__sysacusql', HelpMessage = 'CSV file for Acunetix scan report')]
        [Parameter(Mandatory, ParameterSetName = '__websqlacu', HelpMessage = 'CSV file for Acunetix scan report')]
        [Parameter(Mandatory, ParameterSetName = '__all', HelpMessage = 'CSV file for Acunetix scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter *.csv })]
        [ValidateNotNullOrEmpty()]
        [string] $AcunetixScan
    )

    Begin {
        # CREATE MASTER LIST
        $summaryObjects = [System.Collections.Generic.List[System.Object]]::new()

        # SET DESTINATION PATH
        if ( -not $PSBoundParameters.ContainsKey('DestinationPath') ) {
            $fileName = 'Summary-Scans_{0:yyyy-MM}.xlsx' -f (Get-Date)
            $DestinationPath = Join-Path -Path "$HOME\Desktop" -ChildPath $fileName
        }
        else {
            # GET LAST MONTH'S REPORT IF EXISTS
            $lastMonth = (Get-Date -Date (Get-Date).AddMonths(-1) -UFormat %b).ToUpper()
            $summaryReport = Import-Excel -Path $DestinationPath -WorksheetName $lastMonth -ErrorAction SilentlyContinue
        }
    }

    Process {
        # PROCESS DATABASE SCAN DATA
        if ( $PSBoundParameters.ContainsKey('DatabaseScan') ) {
            # RESOLVING PATH IS REQUIRED AS IMPORT-EXCEL WILL NOT ACCEPT LINKS OR REFERENCES
            $DatabaseScan = (Resolve-Path -Path $DatabaseScan).Path
            $dbScan = Import-Excel -Path $DatabaseScan -WorksheetName 'DBScan'

            # FIND UNIQUE VULNERABILITIES
            $uniqueDbVulns = $dbScan | Sort-Object -Unique ID

            # ADD A COUNT AND FIND TFS # FOR EACH VULNERABILITY
            foreach ( $object in $uniqueDbVulns ) {
                # GET A COUNT FOR EACH UNIQUE ITEM
                $count = ($dbScan | Where-Object ID -EQ $object.ID | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $count

                # FIND MATCHING VULNERABILITY FROM LAST MONTH AND SET TFS ACCORDINGLY
                $match = $summaryReport.Where({ $_.Name -eq $object.'Security Check' -and $_.Source -eq 'SQL Scan' })
                if ( $match ) {
                    $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value $match.TFS
                }
                else {
                    $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value 0
                }

                <# # ADDING THE PROPERTIES BELOW IS SLOWER THAN DEFINING AND SELECTING PROPERTIES
                # KEEPING THIS HERE FOR HISTORICAL PURPOSES
                $object | Add-Member -MemberType NoteProperty -Name 'Name' -Value $object.'Security Check'
                $object | Add-Member -MemberType NoteProperty -Name 'Notes' -Value $object.ID
                $object | Add-Member -MemberType NoteProperty -Name 'Severity' -Value $object.Risk #>
            }

            # SET PROPERTY CONVERSION
            $newProps = (
                'Count', 'TFS', 'Status', 'CVSSv3', 'Risk',
                @{ Name = 'Source'; Expression = {'SQL Scan'} },
                @{ Name = 'Name'; Expression = {$_.'Security Check'} },
                @{ Name = 'CVE'; Expression = {$_.ID} }
            )

            # CHANGE COLUMN NAMES
            $uniqueDbVulns = $uniqueDbVulns | Select-Object -Property $newProps

            # ADD TO MASTER LIST
            foreach ( $i in $uniqueDbVulns ) { $summaryObjects.Add($i) }
        }

        # PROCESS SYSTEM SCAN DATA
        if ( $PSBoundParameters.ContainsKey('NessusScan') ) {
            $systemCsv = Import-Csv -Path $NessusScan
            $uniqueSysVulns = $systemCsv | Sort-Object Name -Unique
            foreach ( $object in $uniqueSysVulns ) {
                $count = ($systemCsv | Where-Object Name -eq $object.Name | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $count

                # FIND MATCHING VULNERABILITY FROM LAST MONTH AND SET TFS ACCORDINGLY
                $match = $summaryReport.Where({ $_.Name -eq $object.Name -and $_.Source -eq 'Nessus' })
                if ( $match ) {
                    $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value $match.TFS
                }
                else {
                    $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value 0
                }
            }

            # SET PROPERTY CONVERSION
            $newProps = (
                'Count', 'TFS', 'Status', 'Name', 'Risk', 'CVE', 'CVSS',
                @{ Name = 'Source'; Expression = {'Nessus'} },
                @{ Name = 'CVSSv3'; Expression = {$_.'CVSS v3.0 Base Score'} }
            )

            # CHANGE COLUMN NAMES
            $uniqueSysVulns = $uniqueSysVulns | Select-Object -Property $newProps

            # ADD TO MASTER LIST
            foreach ( $i in $uniqueSysVulns ) { $summaryObjects.Add($i) }
        }

        # PROCESS WEB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('WebScan') ) {
            $webCsv = Import-Csv -Path $WebScan
            $uniqueWebVulns = $webCsv | Sort-Object Name -Unique
            foreach ( $object in $uniqueWebVulns ) {
                $count = ($webCsv | Where-Object Name -eq $object.Name | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $count
                $object | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Web Scan'
                $object | Add-Member -MemberType NoteProperty -Name 'Status' -Value $object.'Active or inactive'
                $object | Add-Member -MemberType NoteProperty -Name 'Risk' -Value $object.Severity

                # GET CVSSv3 SCORE
                if ( $object.Name -match 'CVE-\d{4}-\d+' ) {
                    $cve = $object.Name -replace '^.*(CVE-\d{4}-\d+).*$', '$1'
                    try {
                        $nvd = Get-CVSSv3BaseScore -CVE $cve
                        $object | Add-Member -MemberType NoteProperty -Name 'CVSSv3' -Value $nvd.Score
                        $object.Severity = $nvd.Severity
                    }
                    catch {
                        $object | Add-Member -MemberType NoteProperty -Name 'CVSSv3' -Value ''
                    }
                }

                # FIND MATCHING VULNERABILITY FROM LAST MONTH AND SET TFS ACCORDINGLY
                $match = $summaryReport.Where({ $_.Name -eq $object.Name -and $_.Source -eq 'Web Scan' })
                if ( $match ) {
                    $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value $match.TFS
                }
                else {
                    $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value 0
                }
            }

            # ADD TO MASTER LIST
            foreach ( $i in $uniqueWebVulns ) { $summaryObjects.Add($i) }
        }

        # PROCESS ACUNETIX SCAN DATA
        if ( $PSBoundParameters.ContainsKey('AcunetixScan') ) {
            $acuCsv = Import-Csv -Path $AcunetixScan
            $uniqueAcuVulns = $acuCsv | Sort-Object Name -Unique
            foreach ( $object in $uniqueAcuVulns ) {
                $count = ($acuCsv | Where-Object Name -eq $object.Name | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $count

                # FIND MATCHING VULNERABILITY FROM LAST MONTH AND SET TFS ACCORDINGLY
                $match = $summaryReport.Where({ $_.Name -eq $object.Name -and $_.Source -eq 'Acunetix' })
                if ( $match ) {
                    $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value $match.TFS
                }
                else {
                    $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value 0
                }
            }

            # SET PROPERTY CONVERSION
            $newProps = (
                'Name', 'Count', 'TFS',
                @{ Name = 'Source'; Expression = {'Acunetix'} },
                @{ Name = 'Status'; Expression = {$_.'IsFalsePositive'} },
                @{ Name = 'CVE'; Expression = {$_.'CWEList'} },
                @{ Name = 'Risk'; Expression = { $_.'Severity'} },
                @{ Name = 'CVSSv3'; Expression = {$_.'CVSS3 Score'} },
                @{ Name = 'CVSS'; Expression = {$_.'CVSS Score'} }
            )

            # CHANGE COLUMN NAMES
            $uniqueAcuVulns = $uniqueAcuVulns | Select-Object -Property $newProps

            # ADD TO MASTER LIST
            foreach ( $i in $uniqueAcuVulns ) { $summaryObjects.Add($i) }
        }
    }

    End {
        # VERBOSE
        Write-Verbose -Message ( 'Nessus Scan Count: {0}' -f (($uniqueSysVulns | Measure-Object).Count) )
        Write-Verbose -Message ( 'Web Scan Count: {0}' -f (($uniqueWebVulns | Measure-Object).Count) )
        Write-Verbose -Message ( 'DB Scan Count: {0}' -f (($uniqueDbVulns | Measure-Object).Count) )
        Write-Verbose -Message ( 'Acunetix Scan Count: {0}' -f (($uniqueAcuVulns | Measure-Object).Count) )

        # SET REPORT OPTIONS
        $excelParams = @{
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
        $reportProps = @(
            'Name'
            'CVE'
            'CVSS'
            'CVSSv3'
            'Risk'
            'Source'
            'Count'
            'Risk Adj.'
            'Status'
            'TFS'
            'Notes'
        )

        # EXPORT TO EXCEL
        $summaryObjects | Select-Object -Property $reportProps | Export-Excel @excelParams
    }
}