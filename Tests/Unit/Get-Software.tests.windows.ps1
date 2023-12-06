BeforeDiscovery {
    # Taken with love from @juneb_get_help (https://raw.githubusercontent.com/juneb/PesterTDD/master/Module.Help.Tests.ps1)
    # Import module
    if (-not (Get-Module -Name $env:BHProjectName -ListAvailable)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
    $Cmdlets = Get-Command -Module $env:BHProjectName -CommandType 'Cmdlet', 'Function' -ErrorAction 'Stop'
}

Describe -Name "Get-Software" -Fixture {
    It -Name "should not fail" -Test {
        { Get-Software } | Should -Not -Throw
    }

    It -Name "returns custom objects" -Test {
        Get-Software | Should -BeOfType System.Management.Automation.PSObject
    }

    It -Name "returns registry objects" -Test {
        Get-Software -All | Should -BeOfType Microsoft.Win32.RegistryKey
    }

    It -Name "returns specific software installation" -Test {
        $Software = Get-Software -Name "PowerShell 7-x64"
        $Software.Name | Should -Be "PowerShell 7-x64"
    }
}
