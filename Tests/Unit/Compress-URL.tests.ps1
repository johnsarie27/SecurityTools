BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Compress-URL' -Fixture {

    BeforeAll {
        $script:MockResponse = [PSCustomObject] @{
            success = $true
            data    = [PSCustomObject] @{
                short_url = 'https://1simpl.io/abc123'
                long_url  = 'https://www.example.com/some/long/path'
            }
        }

        Mock -CommandName Invoke-RestMethod -MockWith { $script:MockResponse } -ModuleName $env:BHProjectName
    }

    Context -Name 'request shape' -Fixture {
        It -Name 'POSTs to the onesimpleapi shortener endpoint' -Test {
            Compress-URL -URL 'https://www.example.com/some/long/path' -ApiKey 'fake-key' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Uri -eq 'https://onesimpleapi.com/api/shortener/new' -and $Method -eq 'POST'
            }
        }

        It -Name 'passes the API key, output=json, and URL in the request body' -Test {
            Compress-URL -URL 'https://www.example.com/' -ApiKey 'fake-key' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Body.token -eq 'fake-key' -and
                $Body.output -eq 'json' -and
                $Body.url -eq 'https://www.example.com/'
            }
        }
    }

    Context -Name 'response handling' -Fixture {
        It -Name 'returns the mocked response unchanged' -Test {
            $result = Compress-URL -URL 'https://www.example.com/' -ApiKey 'fake-key'
            $result.success        | Should -BeTrue
            $result.data.short_url | Should -Be 'https://1simpl.io/abc123'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an empty -ApiKey' -Test {
            { Compress-URL -URL 'https://example.com/' -ApiKey '' } | Should -Throw
        }
    }
}
