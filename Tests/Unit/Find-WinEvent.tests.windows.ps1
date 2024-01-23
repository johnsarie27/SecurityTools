BeforeDiscovery {
    # Taken with love from @juneb_get_help (https://raw.githubusercontent.com/juneb/PesterTDD/master/Module.Help.Tests.ps1)
    # Import module
    if (-not (Get-Module -Name $env:BHProjectName -ListAvailable)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
    $Cmdlets = Get-Command -Module $env:BHProjectName -CommandType 'Cmdlet', 'Function' -ErrorAction 'Stop'
}

Describe -Name "Find-WinEvent" -Fixture {
    It -Name "lists available options" -Test {
        Find-WinEvent -List | Should -BeOfType PSCustomObject
    }

    It -Name "should return EventLogRecord" -Test {
        Find-WinEvent -Id 5 -Results 5 | Should -BeOfType System.Diagnostics.Eventing.Reader.EventLogRecord
    }

    It -Name "should return 5 objects" -Test {
        Find-WinEvent -Id 3 -Results 5 | Should -HaveCount 5
    }
}
