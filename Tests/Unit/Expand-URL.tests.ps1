BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Expand-URL' -Fixture {

    BeforeAll {
        $script:MockResponse = [PSCustomObject] @{
            success = $true
            data    = [PSCustomObject] @{
                unshortened_url = 'https://www.example.com/destination'
            }
        }

        Mock -CommandName Invoke-RestMethod -MockWith { $script:MockResponse } -ModuleName $env:BHProjectName
    }

    Context -Name 'request shape' -Fixture {
        It -Name 'POSTs to the onesimpleapi unshorten endpoint' -Test {
            Expand-URL -URL 'https://tinyurl.com/test' -ApiKey 'fake-key' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Uri -eq 'https://onesimpleapi.com/api/unshorten' -and $Method -eq 'POST'
            }
        }

        It -Name 'passes the API key, output=json, and URL in the request body' -Test {
            Expand-URL -URL 'https://tinyurl.com/abc' -ApiKey 'fake-key' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Body.token -eq 'fake-key' -and
                $Body.output -eq 'json' -and
                ([System.String] $Body.url) -eq 'https://tinyurl.com/abc'
            }
        }
    }

    Context -Name 'response handling' -Fixture {
        It -Name 'returns the mocked response unchanged' -Test {
            $result = Expand-URL -URL 'https://tinyurl.com/abc' -ApiKey 'fake-key'
            $result.success             | Should -BeTrue
            $result.data.unshortened_url | Should -Be 'https://www.example.com/destination'
        }

        It -Name 'accepts pipeline input on -URL' -Test {
            'https://tinyurl.com/abc' | Expand-URL -ApiKey 'fake-key' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Body.url -ne $null }
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an empty -ApiKey' -Test {
            { Expand-URL -URL 'https://tinyurl.com/abc' -ApiKey '' } | Should -Throw
        }
    }
}
