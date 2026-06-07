BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Compare-List' -Fixture {

    Context -Name '__list parameter set' -Fixture {
        It -Name 'returns shared items under DUPLICATES' -Test {
            $a = 'run', 'jump', 'walk'
            $b = 'run', 'jump', 'swim', 'hike'
            $result = Compare-List -ListA $a -ListB $b
            $result.DUPLICATES | Should -Contain 'run'
            $result.DUPLICATES | Should -Contain 'jump'
        }

        It -Name 'returns items unique to ListA under LIST-A' -Test {
            $a = 'run', 'jump', 'walk'
            $b = 'run', 'jump'
            $result = Compare-List -ListA $a -ListB $b
            $result.'LIST-A' | Should -Contain 'walk'
        }

        It -Name 'returns items unique to ListB under LIST-B' -Test {
            $a = 'run', 'jump'
            $b = 'run', 'jump', 'swim', 'hike'
            $result = Compare-List -ListA $a -ListB $b
            $result.'LIST-B' | Should -Contain 'swim'
            $result.'LIST-B' | Should -Contain 'hike'
        }

        It -Name 'rejects an empty ListA' -Test {
            { Compare-List -ListA @() -ListB ('a') } | Should -Throw
        }

        It -Name 'rejects an empty ListB' -Test {
            { Compare-List -ListA ('a') -ListB @() } | Should -Throw
        }

        It -Name 'returns a single row when the only overlap is one item' -Test {
            $result = Compare-List -ListA @('a') -ListB @('a')
            $result | Should -HaveCount 1
            $result[0].DUPLICATES | Should -Be 'a'
        }
    }

    Context -Name '__file parameter set' -Fixture {
        It -Name 'compares a well-formed two-column CSV' -Test {
            $csvPath = Join-Path -Path $TestDrive -ChildPath 'two-col.csv'
            @(
                [PSCustomObject] @{ A = 'apple';  B = 'apple' }
                [PSCustomObject] @{ A = 'banana'; B = 'cherry' }
            ) | Export-Csv -Path $csvPath -NoTypeInformation

            $result = Compare-List -Path $csvPath
            $result.DUPLICATES | Should -Contain 'apple'
            $result.A          | Should -Contain 'banana'
            $result.B          | Should -Contain 'cherry'
        }

        It -Name 'warns and returns nothing for a one-column CSV' -Test {
            $csvPath = Join-Path -Path $TestDrive -ChildPath 'one-col.csv'
            @(
                [PSCustomObject] @{ Only = 'x' }
                [PSCustomObject] @{ Only = 'y' }
            ) | Export-Csv -Path $csvPath -NoTypeInformation

            $result = Compare-List -Path $csvPath -WarningAction SilentlyContinue
            $result | Should -BeNullOrEmpty
        }

        It -Name 'warns and returns nothing for a three-column CSV' -Test {
            $csvPath = Join-Path -Path $TestDrive -ChildPath 'three-col.csv'
            @(
                [PSCustomObject] @{ A = '1'; B = '2'; C = '3' }
            ) | Export-Csv -Path $csvPath -NoTypeInformation

            $result = Compare-List -Path $csvPath -WarningAction SilentlyContinue
            $result | Should -BeNullOrEmpty
        }

        It -Name 'rejects a path that does not exist' -Test {
            $missing = Join-Path -Path $TestDrive -ChildPath 'no-such-file.csv'
            { Compare-List -Path $missing } | Should -Throw
        }

        It -Name 'rejects a non-CSV file extension' -Test {
            $txtPath = Join-Path -Path $TestDrive -ChildPath 'notes.txt'
            Set-Content -Path $txtPath -Value 'A,B'
            { Compare-List -Path $txtPath } | Should -Throw
        }
    }
}
