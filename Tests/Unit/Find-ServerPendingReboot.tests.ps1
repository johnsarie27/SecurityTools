BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Find-ServerPendingReboot' -Fixture {

    Context -Name 'platform guard' -Fixture {
        It -Name 'errors when not running on Windows' -Skip:$IsWindows -Test {
            { Find-ServerPendingReboot -ErrorAction Stop } |
                Should -Throw -ExpectedMessage '*requires Windows*'
        }
    }

    Context -Name 'normal usage' -Fixture {
        It -Name 'does not throw on Windows' -Skip:(-not $IsWindows) -Test {
            { Find-ServerPendingReboot } | Should -Not -Throw
        }

        It -Name 'returns one object per ComputerName with RebootIsPending boolean' -Skip:(-not $IsWindows) -Test {
            $result = Find-ServerPendingReboot
            $result | Should -Not -BeNullOrEmpty
            $result.ComputerName    | Should -Be $env:COMPUTERNAME
            $result.RebootIsPending | Should -BeOfType [System.Boolean]
        }
    }
}
