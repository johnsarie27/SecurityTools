BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-Ipinfo' -Fixture {

    BeforeAll {
        Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith {
            [PSCustomObject] @{
                ip       = '1.1.1.1'
                hostname = 'one.one.one.one'
                city     = 'Los Angeles'
                region   = 'California'
                country  = 'US'
                org      = 'AS13335 Cloudflare, Inc.'
            }
        }
    }

    Context -Name 'request shape' -Fixture {
        It -Name 'GETs https://ipinfo.io/<ip> with accept: application/json' -Test {
            Get-Ipinfo -IPAddress '1.1.1.1' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Uri -eq 'https://ipinfo.io/1.1.1.1' -and
                $Method -eq 'GET' -and
                $Headers.accept -eq 'application/json'
            }
        }

        It -Name 'queries once per IP when given an array' -Test {
            Get-Ipinfo -IPAddress '1.1.1.1', '8.8.8.8' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'https://ipinfo.io/1.1.1.1' }
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'https://ipinfo.io/8.8.8.8' }
        }

        It -Name 'accepts pipeline input on -IPAddress' -Test {
            '1.1.1.1' | Get-Ipinfo | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'https://ipinfo.io/1.1.1.1' }
        }
    }

    Context -Name 'response handling' -Fixture {
        It -Name 'returns the mocked response unchanged' -Test {
            $result = Get-Ipinfo -IPAddress '1.1.1.1'
            $result.ip      | Should -Be '1.1.1.1'
            $result.country | Should -Be 'US'
        }
    }
}
