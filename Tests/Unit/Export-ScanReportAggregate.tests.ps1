BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Export-ScanReportAggregate' -Fixture {

    BeforeAll {
        # Each scan branch reads from disk via Import-Csv or Import-Excel and writes one
        # worksheet via Export-Excel. Tests pre-create empty fixture files for the path
        # ValidateScripts and mock the import/export cmdlets so no real I/O happens.
        $script:OutDir = Join-Path -Path $TestDrive -ChildPath 'out'
        New-Item -Path $script:OutDir -ItemType Directory -Force | Out-Null

        $script:NessusSystemCsv  = Join-Path -Path $TestDrive -ChildPath 'nessus-sys.csv'
        $script:NessusWebCsv     = Join-Path -Path $TestDrive -ChildPath 'nessus-web.csv'
        $script:AlertLogicCsv    = Join-Path -Path $TestDrive -ChildPath 'alertlogic.csv'
        $script:AcunetixCsv      = Join-Path -Path $TestDrive -ChildPath 'acunetix.csv'
        $script:DatabaseXlsx     = Join-Path -Path $TestDrive -ChildPath 'mssql.xlsx'
        foreach ($p in $script:NessusSystemCsv, $script:NessusWebCsv, $script:AlertLogicCsv, $script:AcunetixCsv, $script:DatabaseXlsx) {
            Set-Content -Path $p -Value 'fixture'
        }

        Mock -CommandName Import-Csv -ModuleName $env:BHProjectName -MockWith {
            @([PSCustomObject] @{ Name = 'Vuln1'; Severity = 'High'; 'CVSS Score' = '7.5'; 'CVSS3 Score' = '8.1' })
        }
        Mock -CommandName Import-Excel -ModuleName $env:BHProjectName -MockWith {
            @([PSCustomObject] @{ ID = 'DB1'; 'Security Check' = 'Weak password'; Risk = 'High'; Status = 'Fail' })
        }
        Mock -CommandName Export-Excel   -MockWith {} -ModuleName $env:BHProjectName
        Mock -CommandName New-ExcelStyle -MockWith { @{} } -ModuleName $env:BHProjectName
    }

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Export-ScanReportAggregate' -Module $env:BHProjectName
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
            { Export-ScanReportAggregate -OutputDirectory $script:OutDir -ErrorAction Stop } |
                Should -Throw -ExpectedMessage '*Missing scan reports*'
        }

        It -Name 'rejects an -OutputDirectory that does not exist' -Test {
            { Export-ScanReportAggregate -OutputDirectory (Join-Path -Path $TestDrive -ChildPath 'nope') -NessusSystemScan $script:NessusSystemCsv } |
                Should -Throw
        }

        It -Name 'rejects a -NessusSystemScan whose extension is not .csv' -Test {
            { Export-ScanReportAggregate -NessusSystemScan $script:DatabaseXlsx } | Should -Throw
        }
    }

    Context -Name 'worksheet routing' -Fixture {
        It -Name 'writes the AlertLogicWeb worksheet from the AlertLogic scan' -Test {
            Export-ScanReportAggregate -OutputDirectory $script:OutDir -AlertLogicWebScan $script:AlertLogicCsv
            Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                -ParameterFilter { $WorksheetName -eq 'AlertLogicWeb' }
        }

        It -Name 'writes the Acunetix worksheet from the Acunetix scan' -Test {
            Export-ScanReportAggregate -OutputDirectory $script:OutDir -AcunetixScan $script:AcunetixCsv
            Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                -ParameterFilter { $WorksheetName -eq 'Acunetix' }
        }

        It -Name 'writes the NessusSystem and NessusWeb worksheets from their respective scans' -Test {
            Export-ScanReportAggregate -OutputDirectory $script:OutDir `
                -NessusSystemScan $script:NessusSystemCsv -NessusWebScan $script:NessusWebCsv
            foreach ($sheet in 'NessusSystem', 'NessusWeb') {
                Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                    -ParameterFilter { $WorksheetName -eq $sheet }
            }
        }

        It -Name 'writes the MSSQL worksheet from the database scan' -Test {
            Export-ScanReportAggregate -OutputDirectory $script:OutDir -DatabaseScan $script:DatabaseXlsx
            Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                -ParameterFilter { $WorksheetName -eq 'MSSQL' }
        }

        It -Name 'targets a dated Aggregate-Scans workbook in -OutputDirectory' -Test {
            Export-ScanReportAggregate -OutputDirectory $script:OutDir -NessusSystemScan $script:NessusSystemCsv
            Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                -ParameterFilter { $Path -match 'Aggregate-Scans_\d{4}-\d{2}\.xlsx$' -and (Split-Path -Path $Path -Parent) -eq $script:OutDir }
        }
    }
}
