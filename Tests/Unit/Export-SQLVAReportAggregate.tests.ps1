BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Export-SQLVAReportAggregate' -Fixture {

    BeforeAll {
        # The function discovers reports via Get-ChildItem '<InputPath>\*.xlsx', then pipes each
        # through Import-Excel. We stage a folder of fixture .xlsx files (just empty marker files
        # — Import-Excel is mocked) and return synthetic scan rows from the mock.
        $script:InputDir = Join-Path -Path $TestDrive -ChildPath 'in'
        New-Item -Path $script:InputDir -ItemType Directory -Force | Out-Null
        $script:Report1 = Join-Path -Path $script:InputDir -ChildPath 'sql-01.xlsx'
        $script:Report2 = Join-Path -Path $script:InputDir -ChildPath 'sql-02.xlsx'
        Set-Content -Path $script:Report1 -Value 'fixture'
        Set-Content -Path $script:Report2 -Value 'fixture'

        $script:OutFile = Join-Path -Path $TestDrive -ChildPath 'aggregate.xlsx'

        Mock -CommandName Import-Module -MockWith {} -ModuleName $env:BHProjectName `
            -ParameterFilter { $Name -eq 'ImportExcel' }

        Mock -CommandName Import-Excel -ModuleName $env:BHProjectName -MockWith {
            @(
                [PSCustomObject] @{ ID = 'VA1001'; Status = 'Fail';    Risk = 'High' }
                [PSCustomObject] @{ ID = 'VA1002'; Status = 'Pass';    Risk = 'Low'  }
                [PSCustomObject] @{ ID = 'VA1003'; Status = 'Warning'; Risk = 'Medium' }
            )
        }
        Mock -CommandName Export-Excel    -MockWith {} -ModuleName $env:BHProjectName
        Mock -CommandName New-ExcelStyle  -MockWith { @{} } -ModuleName $env:BHProjectName
    }

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Export-SQLVAReportAggregate' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'defaults to the folder parameter set' -Test {
            $script:Cmd.DefaultParameterSet | Should -Be 'folder'
        }

        It -Name 'declares -InputPath and -ZipPath as mutually exclusive mandatory parameters' -Test {
            $script:Cmd.Parameters['InputPath'].ParameterSets['folder'].IsMandatory | Should -BeTrue
            $script:Cmd.Parameters['ZipPath'].ParameterSets['zip'].IsMandatory      | Should -BeTrue
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an -InputPath folder containing no .xlsx files' -Test {
            $empty = Join-Path -Path $TestDrive -ChildPath 'empty'
            New-Item -Path $empty -ItemType Directory -Force | Out-Null
            { Export-SQLVAReportAggregate -InputPath $empty } | Should -Throw
        }

        It -Name 'rejects a -ZipPath that is not a .zip file' -Test {
            $notZip = Join-Path -Path $TestDrive -ChildPath 'sql.xlsx'
            Set-Content -Path $notZip -Value 'fixture'
            { Export-SQLVAReportAggregate -ZipPath $notZip } | Should -Throw
        }

        It -Name 'rejects a -DestinationPath whose extension is not .xlsx' -Test {
            { Export-SQLVAReportAggregate -InputPath $script:InputDir -DestinationPath (Join-Path -Path $TestDrive -ChildPath 'agg.csv') } | Should -Throw
        }
    }

    Context -Name 'aggregation behavior' -Fixture {
        It -Name 'reads every .xlsx in -InputPath via Import-Excel' -Test {
            Export-SQLVAReportAggregate -InputPath $script:InputDir -DestinationPath $script:OutFile
            Should -Invoke -CommandName Import-Excel -ModuleName $env:BHProjectName -Times 2 -Exactly `
                -ParameterFilter { $WorksheetName -eq 'Results' -and $StartRow -eq 8 }
        }

        It -Name 'writes the aggregated DBScan worksheet to -DestinationPath' -Test {
            # Pester counts each pipeline item as a separate Mock invocation, so we assert that
            # the call happened with the right worksheet and path rather than an exact count.
            Export-SQLVAReportAggregate -InputPath $script:InputDir -DestinationPath $script:OutFile
            Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                -ParameterFilter { $WorksheetName -eq 'DBScan' -and $Path -eq $script:OutFile }
        }

        It -Name 'returns the destination path when -PassThru is specified' -Test {
            $passThru = Export-SQLVAReportAggregate -InputPath $script:InputDir -DestinationPath $script:OutFile -PassThru
            $passThru | Should -Be $script:OutFile
        }
    }
}
