BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Find-ServerPendingReboot' -Fixture {

    Context -Name 'normal usage' -Fixture {
        It -Name 'does not throw on Windows' -Test {
            { Find-ServerPendingReboot } | Should -Not -Throw
        }

        It -Name 'returns one object per ComputerName with RebootIsPending boolean' -Test {
            $result = Find-ServerPendingReboot
            $result | Should -Not -BeNullOrEmpty
            $result.ComputerName    | Should -Be $env:COMPUTERNAME
            $result.RebootIsPending | Should -BeOfType [System.Boolean]
        }
    }
}
