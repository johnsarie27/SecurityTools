#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.4.0' }

Import-Module -Name $PSScriptRoot\..\..\SecurityTools.psd1 -Force

Describe -Name "Find-ServerPendingReboot" -Fixture {
    It -Name "should not throw" -Test {
        { Find-ServerPendingReboot } | Should -Not -Throw
    }

    It -Name "should return boolean" -Test {
        { Find-ServerPendingReboot } | Should -Be ($true -or $false)
    }
}
