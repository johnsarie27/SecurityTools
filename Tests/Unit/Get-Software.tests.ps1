#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.4.0' }

Import-Module -Name $PSScriptRoot\..\..\SecurityTools.psd1 -Force

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
