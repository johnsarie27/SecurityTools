BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-CountryCode' -Fixture {

    BeforeAll {
        # Minimal CSV mirroring the ISO-3166 columns the function reads.
        $script:MockCsv = @'
English short name,Alpha-2 code,Alpha-3 code,Numeric
American Samoa,AS,ASM,016
United States,US,USA,840
United Kingdom,GB,GBR,826
Germany,DE,DEU,276
'@
        $script:MockData = $script:MockCsv | ConvertFrom-Csv

        Mock -CommandName Invoke-RestMethod -MockWith { $script:MockCsv } -ModuleName $env:BHProjectName
    }

    BeforeEach {
        # Force a fresh fetch each test by clearing the cached global the function maintains.
        Remove-Variable -Name 'CountryCodes' -Scope Global -ErrorAction Ignore
    }

    Context -Name 'lookup by Alpha-2 code' -Fixture {
        It -Name 'returns the matching country row' -Test {
            $result = Get-CountryCode -Code 'US'
            $result.'English short name' | Should -Be 'United States'
            $result.'Alpha-3 code'       | Should -Be 'USA'
        }
    }

    Context -Name 'lookup by Alpha-3 code' -Fixture {
        It -Name 'returns the matching country row' -Test {
            $result = Get-CountryCode -Code 'DEU'
            $result.'English short name' | Should -Be 'Germany'
            $result.'Alpha-2 code'       | Should -Be 'DE'
        }
    }

    Context -Name 'lookup by country name' -Fixture {
        It -Name 'returns rows matching a substring of the English name' -Test {
            $result = Get-CountryCode -Country 'United'
            $result.Count | Should -BeGreaterOrEqual 2
            ($result.'Alpha-2 code') | Should -Contain 'US'
            ($result.'Alpha-2 code') | Should -Contain 'GB'
        }
    }

    Context -Name 'caching' -Fixture {
        It -Name 'fetches the catalog only once across multiple lookups' -Test {
            Get-CountryCode -Code 'US' | Out-Null
            Get-CountryCode -Code 'DE' | Out-Null
            Get-CountryCode -Code 'GB' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1 -Exactly
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a 1-letter Code' -Test {
            { Get-CountryCode -Code 'U' } | Should -Throw
        }

        It -Name 'rejects a 4-letter Code' -Test {
            { Get-CountryCode -Code 'USAA' } | Should -Throw
        }

        It -Name 'rejects a Code containing digits' -Test {
            { Get-CountryCode -Code 'U5' } | Should -Throw
        }

        It -Name 'rejects -Code and -Country supplied together (parameter set conflict)' -Test {
            { Get-CountryCode -Code 'US' -Country 'United States' } | Should -Throw
        }
    }

    AfterAll {
        Remove-Variable -Name 'CountryCodes' -Scope Global -ErrorAction Ignore
    }
}
