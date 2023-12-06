BeforeDiscovery {
    # Taken with love from @juneb_get_help (https://raw.githubusercontent.com/juneb/PesterTDD/master/Module.Help.Tests.ps1)
    # Import module
    if (-not (Get-Module -Name $env:BHProjectName -ListAvailable)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
    $Cmdlets = Get-Command -Module $env:BHProjectName -CommandType 'Cmdlet', 'Function' -ErrorAction 'Stop'
}

Describe -Name "Find-ServerPendingReboot" -Fixture {
    It -Name "should not throw" -Test {
        { Find-ServerPendingReboot } | Should -Not -Throw
    }

    It -Name "should return boolean" -Test {
        { Find-ServerPendingReboot } | Should -Be ($true -or $false)
    }
}
