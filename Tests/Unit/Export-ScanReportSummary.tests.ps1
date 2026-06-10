BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Export-ScanReportSummary' -Fixture {

    BeforeAll {
        # Pre-create empty fixture files so the ValidateScript path checks pass; Import-Csv,
        # Import-Excel and the Excel writers are mocked, so the on-disk content is irrelevant.
        $script:NessusSystemCsv = Join-Path -Path $TestDrive -ChildPath 'nessus-sys.csv'
        $script:NessusWebCsv = Join-Path -Path $TestDrive -ChildPath 'nessus-web.csv'
        $script:AlertLogicCsv = Join-Path -Path $TestDrive -ChildPath 'alertlogic.csv'
        $script:AcunetixCsv = Join-Path -Path $TestDrive -ChildPath 'acunetix.csv'
        $script:DatabaseXlsx = Join-Path -Path $TestDrive -ChildPath 'mssql.xlsx'
        foreach ($p in $script:NessusSystemCsv, $script:NessusWebCsv, $script:AlertLogicCsv, $script:AcunetixCsv, $script:DatabaseXlsx) {
            Set-Content -Path $p -Value 'fixture'
        }

        # When -DestinationPath is not supplied the function assigns the default
        # ~/Desktop/Summary-Scans_<yyyy-MM>.xlsx, which re-fires the parameter's
        # ValidateScript on the new value. On runners without a Desktop folder
        # (e.g. ubuntu-latest) that re-validation fails, so every test supplies an
        # explicit -DestinationPath under $TestDrive.
        $script:OutFile = Join-Path -Path $TestDrive -ChildPath 'summary.xlsx'

        # Synthetic scan rows. Each branch maps to one fixture row; Sort-Object -Unique on Name
        # keeps the count predictable at one row per scan source.
        Mock -CommandName Import-Csv -ModuleName $env:BHProjectName -MockWith {
            param([System.String] $Path)
            switch -Wildcard ($Path) {
                '*nessus-sys.csv' { @([PSCustomObject] @{ Name = 'NesSysFinding'; Risk = 'High'; Status = 'Open'; CVE = 'CVE-2023-1'; CVSS = '7.5'; 'CVSS v3.0 Base Score' = '8.1' }) }
                '*nessus-web.csv' { @([PSCustomObject] @{ Name = 'NesWebFinding'; Risk = 'Medium'; Status = 'Open'; CVE = 'CVE-2023-2'; CVSS = '5.5'; 'CVSS v3.0 Base Score' = '6.1' }) }
                '*alertlogic.csv' { @([PSCustomObject] @{ Name = 'CVE-2023-3 vuln'; Severity = 'High'; 'Active or inactive' = 'active'; CVE = 'CVE-2023-3'; CVSS = '7.0' }) }
                '*acunetix.csv' { @([PSCustomObject] @{ Name = 'AcunetixFinding'; Severity = 'medium'; IsFalsePositive = '0'; CWEList = 'CWE-79'; 'CVSS Score' = '6.4'; 'CVSS3 Score' = '7.1' }) }
            }
        }
        Mock -CommandName Import-Excel -ModuleName $env:BHProjectName -MockWith {
            @([PSCustomObject] @{ ID = 'DB1'; 'Security Check' = 'Weak password'; Risk = 'High'; Status = 'Fail'; CVSSv3 = '7.5' })
        }
        Mock -CommandName Get-CVSSv3BaseScore -ModuleName $env:BHProjectName -MockWith {
            [PSCustomObject] @{ CVE = 'CVE-2023-3'; Severity = 'High'; Score = 7.8; Vector = 'AV:N' }
        }
        Mock -CommandName Export-Excel   -MockWith {} -ModuleName $env:BHProjectName
        Mock -CommandName New-ExcelStyle -MockWith { @{} } -ModuleName $env:BHProjectName
    }

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Export-ScanReportSummary' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares all five scan inputs as optional' -Test {
            foreach ($name in 'NessusSystemScan', 'NessusWebScan', 'AlertLogicWebScan', 'DatabaseScan', 'AcunetixScan') {
                $script:Cmd.Parameters[$name].Attributes.Mandatory | Should -Not -Contain $true
            }
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'errors when no scan reports are supplied' -Test {
            { Export-ScanReportSummary -ErrorAction Stop } |
            Should -Throw -ExpectedMessage '*Missing scan reports*'
        }

        It -Name 'rejects a -DestinationPath whose extension is not .xlsx' -Test {
            { Export-ScanReportSummary -DestinationPath (Join-Path -Path $TestDrive -ChildPath 'summary.csv') -NessusSystemScan $script:NessusSystemCsv } |
            Should -Throw
        }
    }

    Context -Name 'scan routing' -Fixture {
        It -Name 'writes the summary worksheet named after the current month (uppercase abbrev)' -Test {
            $monthSheet = (Get-Date -UFormat %b).ToUpper()
            Export-ScanReportSummary -NessusSystemScan $script:NessusSystemCsv -DestinationPath $script:OutFile
            Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                -ParameterFilter { $WorksheetName -eq $monthSheet }
        }

        It -Name 'looks up CVSSv3 for AlertLogic findings that contain a CVE id' -Test {
            Export-ScanReportSummary -AlertLogicWebScan $script:AlertLogicCsv -DestinationPath $script:OutFile
            Should -Invoke -CommandName Get-CVSSv3BaseScore -ModuleName $env:BHProjectName `
                -ParameterFilter { $CVE -eq 'CVE-2023-3' }
        }

        It -Name 'reads the database scan workbook from the DBScan worksheet' -Test {
            Export-ScanReportSummary -DatabaseScan $script:DatabaseXlsx -DestinationPath $script:OutFile
            Should -Invoke -CommandName Import-Excel -ModuleName $env:BHProjectName `
                -ParameterFilter { $WorksheetName -eq 'DBScan' }
        }

        It -Name 'reads each provided CSV via Import-Csv exactly once' -Test {
            Export-ScanReportSummary `
                -NessusSystemScan $script:NessusSystemCsv `
                -NessusWebScan    $script:NessusWebCsv `
                -AcunetixScan     $script:AcunetixCsv `
                -DestinationPath  $script:OutFile
            foreach ($csv in $script:NessusSystemCsv, $script:NessusWebCsv, $script:AcunetixCsv) {
                Should -Invoke -CommandName Import-Csv -ModuleName $env:BHProjectName -Times 1 -Exactly `
                    -ParameterFilter { $Path -eq $csv }
            }
        }
    }
}
