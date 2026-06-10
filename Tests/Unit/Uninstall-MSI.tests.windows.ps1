BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Uninstall-MSI' -Fixture {

    Context -Name 'happy path' -Fixture {
        It -Name 'reports "Application... not found" when no registry entry matches the GUID' -Test {
            # Use a GUID that is overwhelmingly unlikely to be installed
            $result = Uninstall-MSI -ProductId 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF'
            $result | Should -Match 'not found'
        }
    }
}
