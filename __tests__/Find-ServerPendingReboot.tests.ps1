#Requires -Modules Pester

Import-Module -Name $PSScriptRoot\..\UtilityFunctions.psd1 -Force

Describe -Name "Find-ServerPendingReboot" -Fixture {
    It -Name "should not throw" -Test {
        { Find-ServerPendingReboot } | Should -Not -Throw
    }

    It -Name "should return boolean" -Test {
        { Find-ServerPendingReboot } | Should -Be ($true -or $false)
    }
}