BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-WinInfo' -Fixture {

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an -Id above the information model range' -Test {
            { Get-WinInfo -Id 99 } | Should -Throw
        }

        It -Name 'rejects an -Id of zero' -Test {
            { Get-WinInfo -Id 0 } | Should -Throw
        }
    }

    Context -Name 'platform guard' -Fixture {
        It -Name 'errors when not running on Windows' -Skip:$IsWindows -Test {
            { Get-WinInfo -List -ErrorAction Stop } |
                Should -Throw -ExpectedMessage '*requires Windows*'
        }
    }
}
