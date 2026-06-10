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
}
