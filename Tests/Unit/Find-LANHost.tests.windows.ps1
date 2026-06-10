BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Find-LANHost' -Fixture {

    Context -Name 'scan' -Fixture {
        # The scan sends UDP datagrams to the supplied addresses and parses arp.exe output.
        # Loopback never produces a dynamic ARP entry, so a successful scan returns nothing.
        It -Name 'completes a loopback scan without error and returns no dynamic entries' -Test {
            $result = Find-LANHost -IP '127.0.0.1' -DelayMS 0
            $result | Should -BeNullOrEmpty
        }
    }
}
