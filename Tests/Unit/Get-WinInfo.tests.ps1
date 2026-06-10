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

    Context -Name 'list mode (Windows only)' -Fixture {
        It -Name 'returns the formatted class list without error' -Skip:(-not $IsWindows) -Test {
            { Get-WinInfo -List } | Should -Not -Throw
            Get-WinInfo -List | Should -Not -BeNullOrEmpty
        }
    }

    Context -Name 'info mode (Windows only)' -Fixture {
        # Get-CimInstance is mocked so no real WMI/CIM query runs; these tests verify the
        # information model entry selected by -Id is translated into the right CIM parameters
        BeforeAll {
            Mock -CommandName Get-CimInstance -MockWith {
                [PSCustomObject] @{ Name = 'MockedInstance' }
            } -ModuleName $env:BHProjectName
        }

        It -Name 'queries the namespace and class selected by -Id' -Skip:(-not $IsWindows) -Test {
            Get-WinInfo -Id 1 | Should -Not -BeNullOrEmpty
            Should -Invoke -CommandName Get-CimInstance -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $Namespace -eq 'root/CIMV2' -and $ClassName -eq 'cim_process' }
        }

        It -Name 'applies the class filter when the model defines one' -Skip:(-not $IsWindows) -Test {
            Get-WinInfo -Id 4 | Out-Null
            Should -Invoke -CommandName Get-CimInstance -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $ClassName -eq 'win32_ntlogevent' -and $Filter -like '*logfile*' }
        }
    }
}
