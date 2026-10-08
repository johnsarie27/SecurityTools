BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-WindowsEventCatalog' -Fixture {

    BeforeAll {
        Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName
    }

    Context -Name 'bundled catalog' -Fixture {
        It -Name 'returns the event catalog with EventID and Description columns' -Test {
            $result = Get-WindowsEventCatalog
            $result.Count | Should -BeGreaterThan 0
            $result[0].PSObject.Properties.Name | Should -Be @('EventID', 'Description')
        }

        It -Name 'includes a well-known event' -Test {
            $result = Get-WindowsEventCatalog
            ($result | Where-Object EventID -EQ '1102').Description | Should -Be 'The audit log was cleared'
        }

        It -Name 'makes no network call' -Test {
            Get-WindowsEventCatalog | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly
        }
    }

    Context -Name 'parameters' -Fixture {
        It -Name 'no longer accepts -UseRemoteData' -Test {
            { Get-WindowsEventCatalog -UseRemoteData } | Should -Throw
        }
    }
}
