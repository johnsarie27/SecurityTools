#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.4.0' }

Import-Module -Name $PSScriptRoot\..\SecurityTools.psd1 -Force

Describe -Name "Get-DirStats" -Fixture {
    It -Name "should not fail" -Test {
        { Get-DirStats -Path $HOME } | Should -Not -Throw
    }
}