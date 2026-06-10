BeforeDiscovery {
    # Taken with love from @juneb_get_help (https://raw.githubusercontent.com/juneb/PesterTDD/master/Module.Help.Tests.ps1)
    # Import module
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
    $Cmdlets = Get-Command -Module $env:BHProjectName -CommandType 'Cmdlet', 'Function' -ErrorAction 'Stop'
}

Describe -Name "Find-WinEvent" -Fixture {
    It -Name "lists available options" -Test {
        Find-WinEvent -List | Should -BeOfType PSCustomObject
    }

    # ID 9 IS 'EVENT LOG STARTED' (SYSTEM/6005) WHICH EXISTS ON EVERY BOOTED WINDOWS SYSTEM
    It -Name "should return EventLogRecord" -Test {
        Find-WinEvent -Id 9 -Results 5 | Should -BeOfType System.Diagnostics.Eventing.Reader.EventLogRecord
    }

    It -Name "should limit results to the requested count" -Test {
        Find-WinEvent -Id 9 -Results 1 | Should -HaveCount 1
    }
}
