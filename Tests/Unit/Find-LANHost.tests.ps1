BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Find-LANHost' -Fixture {

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Find-LANHost' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -IP as mandatory' -Test {
            $script:Cmd.Parameters['IP'].Attributes.Mandatory | Should -Contain $true
        }

        It -Name 'declares -ClearARPCache as a switch' -Test {
            $script:Cmd.Parameters['ClearARPCache'].ParameterType |
            Should -Be ([System.Management.Automation.SwitchParameter])
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a -DelayMS above 15000' -Test {
            { Find-LANHost -IP '127.0.0.1' -DelayMS 20000 } | Should -Throw
        }

        It -Name 'rejects a negative -DelayMS' -Test {
            { Find-LANHost -IP '127.0.0.1' -DelayMS -1 } | Should -Throw
        }
    }
}
