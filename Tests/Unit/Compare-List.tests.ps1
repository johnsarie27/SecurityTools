BeforeDiscovery {
    # Taken with love from @juneb_get_help (https://raw.githubusercontent.com/juneb/PesterTDD/master/Module.Help.Tests.ps1)
    # Import module
    if (-not (Get-Module -Name $env:BHProjectName -ListAvailable)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
    $Cmdlets = Get-Command -Module $env:BHProjectName -CommandType 'Cmdlet', 'Function' -ErrorAction 'Stop'
}

Describe -Name "Compare-List" -Fixture {
    Context -Name "__list parameter set" -Fixture {
        It -Name "compares two arrays of strings" -Test {
            $a = 'run', 'jump', 'walk'
            $b = 'run', 'jump', 'swim', 'hike'
            $compare = Compare-List -ListA $a -ListB $b
            $compare.DUPLICATES | Should -Contain 'run'
        }

        It -Name "compares two arrays of objects" -Test {
            $a = Get-Process | Select-Object -First 5
            $b = $a | Select-Object -First 2
            $compare = Compare-List -ListA $a -ListB $b
            $compare.'LIST-A' | Should -HaveCount 3
        }

        It -Name "should not throw an error" -Test {
            $a = 'run', 'jump', 'walk'
            $b = 'run', 'jump', 'swim', 'hike'
            { Compare-List -ListA $a -ListB $b } | Should -Not -Throw
        }
    }

    Context -Name "__file parameter set" -Fixture {
        It -Name "should not throw an error" -Test {
            { Compare-List -Path $Path } | Should -Not -Throw
        }

        It -Name "compares string data in a csv" -Test {
            $compare = Compare-List -Path $Path
            $compare.Count | Should -Be ($a.Count - $b.Count)
        }

        It -Name "contains accurate count in comparisson" -Test {
            $compare = Compare-List -Path $Path
            $compare.DUPLICATES | Should -Contain $b[0].ProcessName
        }

        BeforeEach {
            $a = Get-Process
            $b = $a | Select-Object -First 8
            $List = @()
            for ( $i = 0; $i -lt $a.Count; $i++ ) {
                $new = @{ A = $a[$i].ProcessName }
                if ( $b[$i] ) { $new['B'] = $b[$i].ProcessName } else { $new['B'] = '' }
                $List += [PSCustomObject] $new
            }
            $Path = 'TestDrive:/test_compare_list.csv' # "TestDrive:\test.csv" OR 'Temp:/test_compare_list.csv'
            $List | Export-Csv -Path $Path
        }
    }
}
