BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-EPSS' -Fixture {

    BeforeAll {
        $mockResponse = [PSCustomObject] @{
            status        = 'OK'
            'status-code' = 200
            version       = '1.0'
            access        = 'public'
            total         = 1
            offset        = 0
            limit         = 100
            data          = @(
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
        It -Name 'makes a separate request per CVE piped in' -Test {
            'CVE-2022-27225', 'CVE-2021-44228' | Get-EPSS
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 2 -Exactly
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an invalid CVE format' -Test {
            { Get-EPSS -CVE 'NOT-A-CVE' } | Should -Throw
        }
    }

    Context -Name 'multiple CVEs as array argument (comma-joined)' -Fixture {
        # When -CVE receives an array directly (vs piped), the function comma-joins them
        # into a single request rather than iterating.
        It -Name 'comma-joins multiple CVE values into a single request URI' -Test {
            Get-EPSS -CVE 'CVE-2022-27225', 'CVE-2021-44228'
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $Uri -like '*cve=CVE-2022-27225,CVE-2021-44228*' }
        }
    }

    Context -Name 'API failure' -Fixture {
        # Invoke-RestMethod errors are not caught by the function — they propagate.
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith {
                throw [System.Net.WebException]::new('rate limit exceeded (429)')
            } -ModuleName $env:BHProjectName
        }

        It -Name 'propagates rate-limit / transport errors to the caller' -Test {
            { Get-EPSS -CVE 'CVE-2022-27225' } |
                Should -Throw -ExpectedMessage '*rate limit*'
        }

        It -Name 'propagates errors when no CVE is supplied (bulk request)' -Test {
            { Get-EPSS } | Should -Throw -ExpectedMessage '*rate limit*'
        }
    }

    Context -Name 'non-success API response' -Fixture {
        # The function returns whatever Invoke-RestMethod hands back. If the API returns an
        # error envelope (status != OK) we should still surface it verbatim to the caller.
        BeforeAll {
            $errorEnvelope = [PSCustomObject] @{
                status        = 'ERROR'
                'status-code' = 400
                version       = '1.0'
                data          = @()
            }
            Mock -CommandName Invoke-RestMethod -MockWith { $errorEnvelope } -ModuleName $env:BHProjectName
        }

        It -Name 'returns the API error envelope unmodified' -Test {
            $result = Get-EPSS -CVE 'CVE-2022-27225'
            $result.status        | Should -Be 'ERROR'
            $result.'status-code' | Should -Be 400
            $result.data          | Should -BeNullOrEmpty
        }
    }
}
