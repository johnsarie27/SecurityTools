BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Convert-TimeZone' -Fixture {

    BeforeAll {
        $script:Time = Get-Date -Date '2011-10-05 3:00pm'
    }

    Context -Name 'converts single time' -Fixture {
        It -Name 'converts Pacific to Eastern time' -Test {
            $convert = Convert-TimeZone -Time $script:Time -SourceTimeZone Pacific -TargetTimeZone Eastern
            $convert.Eastern | Should -Be $script:Time.AddHours(3)
        }

        It -Name 'converts Eastern to UTC time' -Test {
            $convert = Convert-TimeZone -Time $script:Time -SourceTimeZone Eastern -TargetTimeZone UTC
            $convert.UTC | Should -Be (Get-Date -Date '10/5/2011 7:00:00 PM')
        }

        It -Name 'converts UTC to Pacific time' -Test {
            $convert = Convert-TimeZone -Time $script:Time -SourceTimeZone UTC -TargetTimeZone Pacific
            $convert.Pacific | Should -Be (Get-Date -Date '10/5/2011 8:00:00 AM')
        }

        It -Name 'returns the same instant when Source and Target are equal' -Test {
            $convert = Convert-TimeZone -Time $script:Time -SourceTimeZone Eastern -TargetTimeZone Eastern
            $convert.Eastern | Should -Be $script:Time
        }
    }

    Context -Name 'converts multiple times' -Fixture {
        BeforeAll {
            $script:Time2 = Get-Date -Date '2050-01-15 9:00am'
            $script:Time3 = Get-Date -Date '2050-06-01 4:20pm'
        }

        It -Name 'converts times through pipeline' -Test {
            $convert = $script:Time, $script:Time2, $script:Time3 |
            Convert-TimeZone -SourceTimeZone Pacific -TargetTimeZone Mountain
            $convert | Should -HaveCount 3
        }

        It -Name 'converts multiple times in an array' -Test {
            $array = @($script:Time, $script:Time2, $script:Time3)
            $convert = Convert-TimeZone -Time $array -SourceTimeZone Pacific -TargetTimeZone Mountain
            $convert | Should -HaveCount 3
        }
    }

    Context -Name 'output shape' -Fixture {
        It -Name 'returns a PSCustomObject with Source, UTC, and Target properties' -Test {
            $convert = Convert-TimeZone -Time $script:Time -SourceTimeZone Pacific -TargetTimeZone Eastern
            $convert | Should -BeOfType [System.Management.Automation.PSCustomObject]
            $convert.PSObject.Properties.Name | Should -Contain 'Pacific'
            $convert.PSObject.Properties.Name | Should -Contain 'UTC'
            $convert.PSObject.Properties.Name | Should -Contain 'Eastern'
        }
    }

    Context -Name 'DST awareness' -Fixture {
        # The Pacific time zone is UTC-7 (PDT) in summer and UTC-8 (PST) in winter.
        # The function uses Get-TimeZone + TimeZoneInfo, so the offset must adjust with the date.
        It -Name 'applies PDT offset (UTC-7) for a summer Pacific timestamp' -Test {
            $summer = Get-Date -Date '2024-07-15 12:00:00'
            $convert = Convert-TimeZone -Time $summer -SourceTimeZone Pacific -TargetTimeZone UTC
            $convert.UTC | Should -Be (Get-Date -Date '2024-07-15 19:00:00')
        }

        It -Name 'applies PST offset (UTC-8) for a winter Pacific timestamp' -Test {
            $winter = Get-Date -Date '2024-01-15 12:00:00'
            $convert = Convert-TimeZone -Time $winter -SourceTimeZone Pacific -TargetTimeZone UTC
            $convert.UTC | Should -Be (Get-Date -Date '2024-01-15 20:00:00')
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an unknown -SourceTimeZone value' -Test {
            { Convert-TimeZone -Time $script:Time -SourceTimeZone 'Atlantis' -TargetTimeZone UTC } |
            Should -Throw
        }

        It -Name 'rejects an unknown -TargetTimeZone value' -Test {
            { Convert-TimeZone -Time $script:Time -SourceTimeZone UTC -TargetTimeZone 'Mars' } |
            Should -Throw
        }

        It -Name 'rejects an unparseable -Time string' -Test {
            { Convert-TimeZone -Time 'not a date' -TargetTimeZone UTC } | Should -Throw
        }
    }

    Context -Name 'default behavior' -Fixture {
        It -Name 'uses current time when -Time is omitted' -Test {
            $before = Get-Date
            $convert = Convert-TimeZone -SourceTimeZone Local -TargetTimeZone UTC
            $after = Get-Date
            $convert.Local | Should -BeGreaterOrEqual $before.AddSeconds(-1)
            $convert.Local | Should -BeLessOrEqual $after.AddSeconds(1)
        }
    }
}
