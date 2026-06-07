BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-PatchTuesday' -Fixture {

    Context -Name 'known-answer Patch Tuesdays' -Fixture {
        # Verified against published Microsoft Patch Tuesday history.
        # https://patchtuesday.com/
        # Compare .Date to ignore sub-second drift from Get-Date -Hour 0 -Minute 0 -Second 0
        # (which preserves the current millisecond component).
        It -Name 'returns 2015-06-09 for June 2015' -Test {
            (Get-PatchTuesday -Month 6 -Year 2015).Date | Should -Be ([DateTime] '2015-06-09')
        }

        It -Name 'returns 2024-01-09 for January 2024' -Test {
            (Get-PatchTuesday -Month 1 -Year 2024).Date | Should -Be ([DateTime] '2024-01-09')
        }

        It -Name 'returns 2024-12-10 for December 2024' -Test {
            (Get-PatchTuesday -Month 12 -Year 2024).Date | Should -Be ([DateTime] '2024-12-10')
        }

        It -Name 'handles a month where the 1st IS a Tuesday (Aug 2023 → 2023-08-08)' -Test {
            # 2023-08-01 is a Tuesday, so the second Tuesday is 2023-08-08.
            (Get-PatchTuesday -Month 8 -Year 2023).Date | Should -Be ([DateTime] '2023-08-08')
        }
    }

    Context -Name 'arbitrary day-of-week / week-of-month' -Fixture {
        It -Name 'returns the third Wednesday of June 2015 (2015-06-17)' -Test {
            (Get-PatchTuesday -Month 6 -Year 2015 -DayOfWeek Wednesday -WeekOfMonth 3).Date |
                Should -Be ([DateTime] '2015-06-17')
        }

        It -Name 'returns the first Monday of January 2024 (2024-01-01)' -Test {
            (Get-PatchTuesday -Month 1 -Year 2024 -DayOfWeek Monday -WeekOfMonth 1).Date |
                Should -Be ([DateTime] '2024-01-01')
        }

        It -Name 'accepts the WeekDay alias' -Test {
            (Get-PatchTuesday -Month 6 -Year 2015 -WeekDay Wednesday -WeekOfMonth 3).Date |
                Should -Be ([DateTime] '2015-06-17')
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects Month outside 1-12' -Test {
            { Get-PatchTuesday -Month 13 -Year 2024 } | Should -Throw
        }

        It -Name 'rejects Year outside 1900-2301' -Test {
            { Get-PatchTuesday -Month 1 -Year 1800 } | Should -Throw
        }

        It -Name 'rejects an unknown DayOfWeek' -Test {
            { Get-PatchTuesday -Month 1 -Year 2024 -DayOfWeek 'Funday' } | Should -Throw
        }

        It -Name 'rejects WeekOfMonth outside 1-5' -Test {
            { Get-PatchTuesday -Month 1 -Year 2024 -WeekOfMonth 6 } | Should -Throw
        }
    }

    Context -Name 'return type' -Fixture {
        It -Name 'returns a System.DateTime' -Test {
            Get-PatchTuesday -Month 6 -Year 2015 | Should -BeOfType [System.DateTime]
        }
    }
}
