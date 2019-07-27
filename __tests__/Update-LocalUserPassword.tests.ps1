#Requires -Modules Pester

Import-Module -Name $PSScriptRoot\..\UtilityFunctions.psd1 -Force

Describe -Name "Update-LocalUserPassword" -Fixture {
    Mock -CommandName 'Get-LocalUser' -MockWith {}
    Mock -CommandName 'Set-LocalUser' -MockWith {}

    It -Name "does not fail" -Test {

    }

    It -Name "should call Set-LocalUser" -Test {
        Assert-MockCalled -CommandName Set-LocalUser -Times 1 -Exactly
    }
}