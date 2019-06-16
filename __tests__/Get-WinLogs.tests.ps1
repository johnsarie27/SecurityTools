#Requires -Modules Pester

Import-Module -Name $PSScriptRoot\..\SecurityTools.psd1 -Force -ErrorAction SilentlyContinue

Describe -Name "Get-WinLogs" -Fixture {
    It -Name "lists available options" -Test {
        Get-WinLogs -List | Should -BeOfType PSCustomObject
    }

    It -Name "should return EventLogRecord" -Test {
        Get-WinLogs -Id 5 -Results 5 | Should -BeOfType System.Diagnostics.Eventing.Reader.EventLogRecord
    }
}