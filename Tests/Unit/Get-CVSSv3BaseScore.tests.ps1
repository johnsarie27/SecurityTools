BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-CVSSv3BaseScore' -Fixture {

    BeforeAll {
        # Minimal HTML fragment matching the regex pattern used by the function
        $mockHtml = '<a class="label label-danger">9.8 Critical</a>'
        Mock -CommandName Invoke-WebRequest -MockWith {
            [PSCustomObject] @{ Content = $mockHtml }
        } -ModuleName $env:BHProjectName
    }

    Context -Name 'single CVE lookup' -Fixture {
        It -Name 'returns an object with CVE, Score, and Severity properties' -Test {
            $result = Get-CVSSv3BaseScore -CVE 'CVE-2020-2659'
            $result | Should -Not -BeNullOrEmpty
            $result.CVE      | Should -Be 'CVE-2020-2659'
            $result.Score    | Should -Be '9.8'
            $result.Severity | Should -Be 'Critical'
        }

        It -Name 'should not throw for a valid CVE ID' -Test {
            { Get-CVSSv3BaseScore -CVE 'CVE-2020-2659' } | Should -Not -Throw
        }
    }

    Context -Name 'pipeline input' -Fixture {
        It -Name 'accepts multiple CVE IDs from the pipeline' -Test {
            $results = 'CVE-2020-2659', 'CVE-2021-44228' | Get-CVSSv3BaseScore
            $results | Should -HaveCount 2
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an invalid CVE format' -Test {
            { Get-CVSSv3BaseScore -CVE 'INVALID-ID' } | Should -Throw
        }
    }

    Context -Name 'malformed / non-matching response' -Fixture {
        # Function does NOT throw when the regex finds no match. It catches the resulting
        # null-property access and emits a warning instead, returning no pipeline output.
        BeforeAll {
            Mock -CommandName Invoke-WebRequest -MockWith {
                [PSCustomObject] @{ Content = '<html><body>no score here</body></html>' }
            } -ModuleName $env:BHProjectName
        }

        It -Name 'emits a "No CVSS v3 score found" warning for unmatched content' -Test {
            $warning = $null
            Get-CVSSv3BaseScore -CVE 'CVE-2020-9999' -WarningVariable warning -WarningAction SilentlyContinue
            $warning | Should -Not -BeNullOrEmpty
            $warning -join ' ' | Should -BeLike '*No CVSS v3 score found*CVE-2020-9999*'
        }

        It -Name 'produces no pipeline output when the score cannot be parsed' -Test {
            $result = Get-CVSSv3BaseScore -CVE 'CVE-2020-9999' -WarningAction SilentlyContinue
            $result | Should -BeNullOrEmpty
        }

        It -Name 'does not throw even when the response is empty' -Test {
            Mock -CommandName Invoke-WebRequest -MockWith {
                [PSCustomObject] @{ Content = '' }
            } -ModuleName $env:BHProjectName
            { Get-CVSSv3BaseScore -CVE 'CVE-2020-9999' -WarningAction SilentlyContinue } |
            Should -Not -Throw
        }
    }

    Context -Name 'transport failure' -Fixture {
        # When Invoke-WebRequest itself fails (network down, 5xx with -ErrorAction Stop default),
        # the function does not catch it — the error propagates to the caller.
        BeforeAll {
            Mock -CommandName Invoke-WebRequest -MockWith {
                throw [System.Net.WebException]::new('upstream unavailable')
            } -ModuleName $env:BHProjectName
        }

        It -Name 'propagates web request exceptions to the caller' -Test {
            { Get-CVSSv3BaseScore -CVE 'CVE-2020-2659' } |
            Should -Throw -ExpectedMessage '*upstream unavailable*'
        }
    }
}
