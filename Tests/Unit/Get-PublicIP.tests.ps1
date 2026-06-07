BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-PublicIP' -Fixture {

    BeforeAll {
        Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith { '203.0.113.42' }
    }

    Context -Name 'request shape' -Fixture {
        It -Name 'GETs ifconfig.me/ip' -Test {
            Get-PublicIP | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $Uri -eq 'http://ifconfig.me/ip' }
        }
    }

    Context -Name 'response handling' -Fixture {
        It -Name 'returns the response body as-is' -Test {
            Get-PublicIP | Should -Be '203.0.113.42'
        }
    }
}
