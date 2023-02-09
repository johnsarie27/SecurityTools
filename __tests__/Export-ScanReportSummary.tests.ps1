#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.4.0' }, ImportExcel

Import-Module -Name $PSScriptRoot\..\SecurityTools.psd1 -Force

Describe -Name "Export-ScanReportSummary" -Fixture {

}