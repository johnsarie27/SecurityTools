BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-WinInfo' -Fixture {

    Context -Name 'list mode' -Fixture {
        It -Name 'returns the formatted class list without error' -Test {
            { Get-WinInfo -List } | Should -Not -Throw
            Get-WinInfo -List | Should -Not -BeNullOrEmpty
        }
    }

    Context -Name 'info mode' -Fixture {
        # Get-CimInstance is mocked so no real WMI/CIM query runs; these tests verify the
        # information model entry selected by -Id is translated into the right CIM parameters.
        BeforeAll {
            Mock -CommandName Get-CimInstance -MockWith {
                [PSCustomObject] @{ Name = 'MockedInstance' }
            } -ModuleName $env:BHProjectName
        }

        It -Name 'queries the namespace and class selected by -Id' -Test {
            Get-WinInfo -Id 1 | Should -Not -BeNullOrEmpty
            Should -Invoke -CommandName Get-CimInstance -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $Namespace -eq 'root/CIMV2' -and $ClassName -eq 'cim_process' }
        }

        It -Name 'applies the class filter when the model defines one' -Test {
            Get-WinInfo -Id 4 | Out-Null
            Should -Invoke -CommandName Get-CimInstance -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $ClassName -eq 'win32_ntlogevent' -and $Filter -like '*logfile*' }
        }
    }
}
