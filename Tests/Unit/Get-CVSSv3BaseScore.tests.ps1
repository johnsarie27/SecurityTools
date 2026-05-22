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
}
