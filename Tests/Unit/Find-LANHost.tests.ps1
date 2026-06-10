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

    Context -Name 'scan (Windows only)' -Fixture {
        # The scan sends UDP datagrams to the supplied addresses and parses arp.exe output;
        # arp ships with Windows but not with the Linux CI image. Loopback never produces a
        # dynamic ARP entry, so a successful scan returns nothing.
        It -Name 'completes a loopback scan without error and returns no dynamic entries' -Skip:(-not $IsWindows) -Test {
            $result = Find-LANHost -IP '127.0.0.1' -DelayMS 0
            $result | Should -BeNullOrEmpty
        }
    }
}
