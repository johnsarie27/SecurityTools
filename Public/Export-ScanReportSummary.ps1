function Export-ScanReportSummary {
    <# =========================================================================
    .SYNOPSIS
        Summarize scan results into a single report
    .DESCRIPTION
        This function takes a web scan and system scan report and merges the
        pertinent information into a summary view of the vulnerabilities found
    .PARAMETER DestinationPath
        Path to new or existing Excel spreadsheet file
    .PARAMETER NessusSystemScan
        Path to CSV file for Nessus system scan report
    .PARAMETER NessusWebScan
        Path to CSV file for Nessus web scan report
    .PARAMETER AlertLogicWebScan
        Path to CSV file for AlertLogic Web scan report
    .PARAMETER DatabaseScan
        Path to XLSX file for MSSQL scan report
    .PARAMETER AcunetixScan
        Path to CSV file for Acunetix scan report
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Export-ScanReportSummary -NessusSystemScan $Sys -AlertLogicWebScan $Web
        Merge and aggregate data from $Sys and $Web scans and return an Excel
        spreadsheet file.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path ([System.IO.Path]::GetDirectoryName($_)) })]
        [ValidateScript({ [System.IO.Path]::GetExtension($_) -eq '.xlsx' })]
        [string] $DestinationPath,

        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.csv" })]
        [Alias('NessusScan')]
        [string] $NessusSystemScan,

        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.csv" })]
        [string] $NessusWebScan,

        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.csv" })]
        [string] $AlertLogicWebScan,

        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter *.xlsx })]
        [string] $DatabaseScan,

        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter *.csv })]
        [string] $AcunetixScan
    )

    Begin {
        # CREATE MASTER LIST
        $summaryObjects = [System.Collections.Generic.List[System.Object]]::new()

        # PROVIDE HELP FOR THE USER WHEN NO SCANS ARE DECLARED
        $requiredParams = @('NessusSystemScan', 'NessusWebScan', 'AlertLogicWebScan', 'DatabaseScan', 'AcunetixScan')
        foreach ( $param in $requiredParams ) {
            if ( $param -notin $PSBoundParameters.Keys ) { $fail = $true } else { $fail = $false; break }
        }
        if ( $fail ) { Throw 'Missing scan reports to summarize. Please provide at least one scan report.' }

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
        # PROCESS INDIVIDUAL SCAN DATA
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
                $match = $summaryReport.Where({ $_.Name -eq $object.'Security Check' -and $_.Source -eq 'MSSQL' })
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
                @{ Name = 'Source'; Expression = { 'MSSQL' } },
                @{ Name = 'Name'; Expression = { $_.'Security Check' } },
                @{ Name = 'CVE'; Expression = { $_.ID } }
            )

            # CHANGE COLUMN NAMES
            $uniqueDbVulns = $uniqueDbVulns | Select-Object -Property $newProps

            # ADD TO MASTER LIST
            foreach ( $i in $uniqueDbVulns ) { $summaryObjects.Add($i) }
        }

        if ( $PSBoundParameters.ContainsKey('NessusSystemScan') ) {
            $nSysCsv = Import-Csv -Path $NessusSystemScan
            $uniqueNesVulns = $nSysCsv | Sort-Object Name -Unique
            foreach ($object in $uniqueNesVulns) {
                $count = ($nSysCsv | Where-Object Name -eq $object.Name | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $count

                # FIND MATCHING VULNERABILITY FROM LAST MONTH AND SET TFS ACCORDINGLY
                $match = $summaryReport.Where({ $_.Name -eq $object.Name -and $_.Source -eq 'NessusSystem' })
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
                @{ Name = 'Source'; Expression = { 'NessusSystem' } },
                @{ Name = 'CVSSv3'; Expression = { $_.'CVSS v3.0 Base Score' } }
            )

            # CHANGE COLUMN NAMES
            $uniqueNesVulns = $uniqueNesVulns | Select-Object -Property $newProps

            # ADD TO MASTER LIST
            foreach ($i in $uniqueNesVulns) { $summaryObjects.Add($i) }
        }

        if ( $PSBoundParameters.ContainsKey('NessusWebScan') ) {
            $nWebCsv = Import-Csv -Path $NessusWebScan
            $uniqueNesWebVs = $nWebCsv | Sort-Object Name -Unique
            foreach ($object in $uniqueNesWebVs) {
                $count = ($nWebCsv | Where-Object Name -eq $object.Name | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $count

                # FIND MATCHING VULNERABILITY FROM LAST MONTH AND SET TFS ACCORDINGLY
                $match = $summaryReport.Where({ $_.Name -eq $object.Name -and $_.Source -eq 'NessusWeb' })
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
                @{ Name = 'Source'; Expression = { 'NessusWeb' } },
                @{ Name = 'CVSSv3'; Expression = { $_.'CVSS v3.0 Base Score' } }
            )

            # CHANGE COLUMN NAMES
            $uniqueNesWebVs = $uniqueNesWebVs | Select-Object -Property $newProps

            # ADD TO MASTER LIST
            foreach ($i in $uniqueNesWebVs) { $summaryObjects.Add($i) }
        }

        if ( $PSBoundParameters.ContainsKey('AlertLogicWebScan') ) {
            $webCsv = Import-Csv -Path $AlertLogicWebScan
            $uniqueWebVulns = $webCsv | Sort-Object Name -Unique
            foreach ( $object in $uniqueWebVulns ) {
                $count = ($webCsv | Where-Object Name -eq $object.Name | Measure-Object).Count
                $object | Add-Member -MemberType NoteProperty -Name 'Count' -Value $count

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
                $match = $summaryReport.Where({ $_.Name -eq $object.Name -and $_.Source -eq 'AlertLogic-Web' })
                if ( $match ) {
                    $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value $match.TFS
                }
                else {
                    $object | Add-Member -MemberType NoteProperty -Name 'TFS' -Value 0
                }
            }

            # SET PROPERTY CONVERSION
            $newProps = (
                'Name', 'Count', 'TFS', 'CVSSv3', 'CVSS', 'CVE',
                @{ Name = 'Source'; Expression = { 'AlertLogic-Web' } },
                @{ Name = 'Status'; Expression = { $_.'Active or inactive' } },
                @{ Name = 'Risk'; Expression = { $_.'Severity' } }
            )

            # CHANGE COLUMN NAMES
            $uniqueWebVulns = $uniqueWebVulns | Select-Object -Property $newProps

            # ADD TO MASTER LIST
            foreach ( $i in $uniqueWebVulns ) { $summaryObjects.Add($i) }
        }

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
                @{ Name = 'Source'; Expression = { 'Acunetix' } },
                @{ Name = 'Status'; Expression = { $_.'IsFalsePositive' } },
                @{ Name = 'CVE'; Expression = { $_.'CWEList' } },
                @{ Name = 'Risk'; Expression = { $_.'Severity' } },
                @{ Name = 'CVSSv3'; Expression = { $_.'CVSS3 Score' } },
                @{ Name = 'CVSS'; Expression = { $_.'CVSS Score' } }
            )

            # CHANGE COLUMN NAMES
            $uniqueAcuVulns = $uniqueAcuVulns | Select-Object -Property $newProps

            # ADD TO MASTER LIST
            foreach ( $i in $uniqueAcuVulns ) { $summaryObjects.Add($i) }
        }
    }

    End {
        # VERBOSE
        Write-Verbose -Message ( 'Nessus System Scan Count: {0}' -f (($uniqueNesVulns | Measure-Object).Count) )
        Write-Verbose -Message ( 'Nessus Web Scan Count: {0}' -f (($uniqueNesWebVs | Measure-Object).Count) )
        Write-Verbose -Message ( 'AlertLogic Web Scan Count: {0}' -f (($uniqueWebVulns | Measure-Object).Count) )
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

        $summaryObjects | Select-Object -Property $reportProps | Export-Excel @excelParams
    }
}