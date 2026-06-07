BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-DomainRegistration' -Fixture {

    BeforeAll {
        $script:MockResponse = [PSCustomObject] @{
            WhoisRecord = [PSCustomObject] @{
                domainName = 'google.com'
                registrant = [PSCustomObject] @{ organization = 'Google LLC' }
            }
        }

        Mock -CommandName Invoke-RestMethod -MockWith { $script:MockResponse } -ModuleName $env:BHProjectName
    }

    Context -Name 'request shape' -Fixture {
        It -Name 'GETs the WhoisXML API endpoint' -Test {
            Get-DomainRegistration -Domain 'google.com' -ApiKey 'fake-key' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Uri -like 'https://www.whoisxmlapi.com/whoisserver/WhoisService*' -and $Method -eq 'GET'
            }
        }

        It -Name 'embeds the API key and domain in the URL query string' -Test {
            Get-DomainRegistration -Domain 'example.com' -ApiKey 'fake-key' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Uri -like '*apiKey=fake-key*' -and $Uri -like '*domainName=example.com*'
            }
        }

        It -Name 'sends an Accept: application/json header' -Test {
            Get-DomainRegistration -Domain 'example.com' -ApiKey 'fake-key' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Headers.Accept -eq 'application/json' }
        }
    }

    Context -Name 'response handling' -Fixture {
        It -Name 'returns the mocked response unchanged' -Test {
            $result = Get-DomainRegistration -Domain 'google.com' -ApiKey 'fake-key'
            $result.WhoisRecord.domainName             | Should -Be 'google.com'
            $result.WhoisRecord.registrant.organization | Should -Be 'Google LLC'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an empty -Domain' -Test {
            { Get-DomainRegistration -Domain '' -ApiKey 'fake-key' } | Should -Throw
        }

        It -Name 'rejects an empty -ApiKey' -Test {
            { Get-DomainRegistration -Domain 'example.com' -ApiKey '' } | Should -Throw
        }
    }
}
