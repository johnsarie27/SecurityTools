#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.4.0' }

Import-Module -Name $PSScriptRoot\..\..\SecurityTools.psd1 -Force
Import-Module "C:\Program Files\WindowsPowerShell\Modules\Pester\4.8.1\Pester.psd1"
Import-Module -Name ImportExcel

Describe -Name "Export-ExcelBook" -Fixture {
    It -Name "doesn't fail" -Test {
        { $Data | Export-ExcelBook @ExcelParams } | Should -Not -Throw
    }

    It -Name "contains correct values" -Test {
        $Data | Export-ExcelBook @ExcelParams
        $ExcelData = Import-Excel -Path $ExcelParams['Path']
        $NoteProperties = $ExcelData | Get-Member -MemberType NoteProperty | Select-Object -EXP Name
        $NoteProperties | Should -contain 'Company'
    }

    AfterEach {
        Remove-Item -Path $ExcelParams['Path'] -Force
    }

    AfterAll {
        Remove-Item -Path $Folder -Recurse -Force
    }

    BeforeAll {
        $Folder = "C:\temp\Pester"
        if ( !(Test-Path -Path $Folder) ) { New-Item -Path $Folder -ItemType Directory }
        $ExcelParams = @{ Path = "C:\temp\Pester\Excel.xlsx"; SuppressOpen = $true }
        $Data = Get-Process | Where-Object Name -NE '' |
        Select-Object -Property Name, Company, Handles, CPU, PM, NPM, WS

        $CsvData = @"
OBJECTID,NAME,ADDRESS,CITY,STATE,ZIP,PHONE
1,Hilo High School,556 Waianuenue Avenue,Hilo,HI,96720,(808) 974-4021
2,Holualoa Elementary School,76-5957 Mamalahoa Highway,Holualoa,HI,96725,(808) 322-4800
3,Honaunau Elementary School,83-5360 Mamalahoa Highway,Captain Cook,HI,96704,(808) 328-2727
4,Hookena Elementary School,86-4355 Mamalahoa Highway,Captain Cook,HI,96704,(808) 328-2710
5,Kau High and Pahala Elementary School,96-3150 Pikake Street,Pahala,HI,96777,(808) 313-4100
6,Kaumana Elementary School,1710 Kaumana Drive,Hilo,HI,96720,(808) 974-4190
"@
    }
}
