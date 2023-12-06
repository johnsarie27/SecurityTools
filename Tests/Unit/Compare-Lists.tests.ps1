#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.4.0' }

Import-Module -Name $PSScriptRoot\..\..\SecurityTools.psd1 -Force

Describe -Name "Compare-Lists" -Fixture {
    Context -Name "__list parameter set" -Fixture {
        It -Name "compares two arrays of strings" -Test {
            $a = 'run', 'jump', 'walk'
            $b = 'run', 'jump', 'swim', 'hike'
            $compare = Compare-Lists -ListA $a -ListB $b
            $compare.DUPLICATES | Should -Contain 'run'
        }

        It -Name "compares two arrays of objects" -Test {
            $a = Get-Process | Select-Object -First 20
            $b = $a | Select-Object -First 5
            $compare = Compare-Lists -ListA $a -ListB $b
            $compare.'LIST-A' | Should -HaveCount 15
        }

        It -Name "should not throw an error" -Test {
            $a = 'run', 'jump', 'walk'
            $b = 'run', 'jump', 'swim', 'hike'
            { Compare-Lists -ListA $a -ListB $b } | Should -Not -Throw
        }
    }

    Context -Name "__file parameter set" -Fixture {
        It -Name "should not throw an error" -Test {
            { Compare-Lists -Path $Path } | Should -Not -Throw
        }

        It -Name "compares string data in a csv" -Test {
            $compare = Compare-Lists -Path $Path
            $compare.Count | Should -Be ($a.Count - $b.Count)
        }

        It -Name "contains accurate count in comparisson" -Test {
            $compare = Compare-Lists -Path $Path
            $compare.DUPLICATES | Should -Contain $b[0].ProcessName
        }

        BeforeEach {
            $a = Get-Process
            $b = $a | Select-Object -First 10
            $List = @()
            for ( $i = 0; $i -lt $a.Count; $i++ ) {
                $new = @{ A = $a[$i].ProcessName }
                if ( $b[$i] ) { $new['B'] = $b[$i].ProcessName } else { $new['B'] = '' }
                $List += [PSCustomObject] $new
            }
            $Path = "TestDrive:\test.csv" #"$HOME\Desktop\test.csv"
            $List | Export-Csv -Path $Path
        }
    }
}
