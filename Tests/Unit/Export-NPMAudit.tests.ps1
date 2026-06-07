BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Export-NPMAudit' -Fixture {

    BeforeAll {
        # Minimal NPM audit JSON shape covering the fields the function reads.
        $script:AuditFixture = @{
            actions    = @(
                @{
                    action   = 'install'
                    module   = 'lodash'
                    depth    = 1
                    isMajor  = $false
                    resolves = @(@{ id = 1500 })
                }
            )
            advisories = @{
                '1500' = @{
                    title               = 'Prototype Pollution'
                    cves                = @('CVE-2020-1234')
                    module_name         = 'lodash'
                    vulnerable_versions = '<4.17.20'
                    patched_versions    = '>=4.17.20'
                    severity            = 'high'
                    cwe                 = 'CWE-1321'
                    updated             = '2020-07-15'
                    recommendation      = 'Upgrade to 4.17.20'
                    references          = 'https://example.com'
                    overview            = 'Prototype pollution in lodash'
                    url                 = 'https://example.com/advisories/1500'
                    findings            = @(
                        @{ version = '4.17.19'; paths = @('node_modules/lodash') }
                    )
                }
            }
            metadata   = @{
                vulnerabilities = @{
                    info     = 0
                    low      = 0
                    moderate = 0
                    high     = 1
                    critical = 0
                }
            }
        }

        $script:JsonPath = Join-Path -Path 'TestDrive:' -ChildPath 'audit.json'
        $script:AuditFixture | ConvertTo-Json -Depth 8 | Set-Content -Path $script:JsonPath

        $script:OutDir = Join-Path -Path 'TestDrive:' -ChildPath 'out'
        New-Item -Path $script:OutDir -ItemType Directory -Force | Out-Null

        # Replace Excel I/O and CVSS lookup so the test stays hermetic.
        Mock -CommandName Export-Excel    -MockWith {} -ModuleName $env:BHProjectName
        Mock -CommandName New-ExcelStyle  -MockWith { @{} } -ModuleName $env:BHProjectName
        Mock -CommandName Get-CVSSv3BaseScore -ModuleName $env:BHProjectName -MockWith {
            [PSCustomObject] @{ CVE = 'CVE-2020-1234'; Severity = 'HIGH'; Score = 7.5; Vector = 'AV:N' }
        }
    }

    Context -Name 'workbook export' -Fixture {
        It -Name 'writes three worksheets: Info, Actions, Advisories' -Test {
            Export-NPMAudit -Path $script:JsonPath -OutputDirectory $script:OutDir
            # Pester counts each pipeline item as a separate Mock invocation, so don't
            # assert exact call counts — just verify each worksheet name was used.
            foreach ($sheet in 'Info', 'Actions', 'Advisories') {
                Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                    -ParameterFilter { $WorksheetName -eq $sheet }
            }
        }

        It -Name 'writes the workbook under the supplied -OutputDirectory' -Test {
            Export-NPMAudit -Path $script:JsonPath -OutputDirectory $script:OutDir
            Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                -ParameterFilter { $Path -like '*out*NPM-Audit_*.xlsx' }
        }

        It -Name 'looks up the CVSS score for each advisory CVE' -Test {
            Export-NPMAudit -Path $script:JsonPath -OutputDirectory $script:OutDir
            Should -Invoke -CommandName Get-CVSSv3BaseScore -ModuleName $env:BHProjectName `
                -ParameterFilter { $CVE -eq 'CVE-2020-1234' }
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a non-existent input file' -Test {
            { Export-NPMAudit -Path 'TestDrive:/missing.json' -OutputDirectory $script:OutDir } | Should -Throw
        }

        It -Name 'rejects a non-existent OutputDirectory' -Test {
            { Export-NPMAudit -Path $script:JsonPath -OutputDirectory 'TestDrive:/no-such-dir' } | Should -Throw
        }
    }
}
