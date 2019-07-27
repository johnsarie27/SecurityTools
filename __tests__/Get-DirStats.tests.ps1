#Requires -Modules Pester

Import-Module -Name $PSScriptRoot\..\UtilityFunctions.psd1 -Force

Describe -Name "Get-DirStats" -Fixture {
    It -Name "should not fail" -Test {
        { Get-DirStats -Path $HOME } | Should -Not -Throw
    }
}