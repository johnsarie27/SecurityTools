BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-EPSS' -Fixture {

    BeforeAll {
        $mockResponse = [PSCustomObject] @{
            status       = 'OK'
            'status-code' = 200
            version      = '1.0'
            access     = 'public'
            total      = 1
            offset     = 0
            limit      = 100
            data       = @(
                [PSCustomObject] @{
                    cve        = 'CVE-2022-27225'
                    epss       = '0.97534'
                    percentile = '0.99982'
                    date       = '2024-01-01'
                }
            )
        }

        Mock -CommandName Invoke-RestMethod -MockWith { $mockResponse } -ModuleName $env:BHProjectName
    }

    Context -Name 'no parameters (all CVEs)' -Fixture {
        It -Name 'should not throw' -Test {
            { Get-EPSS } | Should -Not -Throw
        }

        It -Name 'calls the base EPSS API URI' -Test {
            Get-EPSS
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'https://api.first.org/data/v1/epss' }
        }
    }

    Context -Name 'single CVE lookup' -Fixture {
        It -Name 'appends the CVE as a query parameter' -Test {
            Get-EPSS -CVE 'CVE-2022-27225'
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -like '*cve=CVE-2022-27225*' }
        }

        It -Name 'should not throw for a valid CVE ID' -Test {
            { Get-EPSS -CVE 'CVE-2022-27225' } | Should -Not -Throw
        }
    }

    Context -Name 'multiple CVEs via pipeline' -Fixture {
        It -Name 'joins multiple CVE IDs into a comma-separated query string' -Test {
            'CVE-2022-27225', 'CVE-2021-44228' | Get-EPSS
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -like '*CVE-2022-27225,CVE-2021-44228*' }
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an invalid CVE format' -Test {
            { Get-EPSS -CVE 'NOT-A-CVE' } | Should -Throw
        }
    }
}
