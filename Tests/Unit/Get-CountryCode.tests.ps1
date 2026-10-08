BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-CountryCode' -Fixture {

    BeforeAll {
        Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName
    }

    Context -Name 'lookup by Alpha-2 code' -Fixture {
        It -Name 'returns the matching country row' -Test {
            $result = Get-CountryCode -Code 'US'
            $result.'English short name' | Should -BeLike 'United States of America*'
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

    Context -Name 'bundled data' -Fixture {
        It -Name 'makes no network call across multiple lookups' -Test {
            Get-CountryCode -Code 'US' | Out-Null
            Get-CountryCode -Code 'DE' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly
        }

        It -Name 'does not create a global CountryCodes variable' -Test {
            $before = [bool] (Get-Variable -Name 'CountryCodes' -Scope Global -ErrorAction Ignore)
            Get-CountryCode -Code 'US' | Out-Null
            [bool] (Get-Variable -Name 'CountryCodes' -Scope Global -ErrorAction Ignore) | Should -Be $before
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
}
