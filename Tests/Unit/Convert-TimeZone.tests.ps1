BeforeDiscovery {
    # Taken with love from @juneb_get_help (https://raw.githubusercontent.com/juneb/PesterTDD/master/Module.Help.Tests.ps1)
    # Import module
    if (-not (Get-Module -Name $env:BHProjectName -ListAvailable)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
    $Cmdlets = Get-Command -Module $env:BHProjectName -CommandType 'Cmdlet', 'Function' -ErrorAction 'Stop'
}

Describe -Name "Convert-TimeZone" -Fixture {
    Context -Name "converts single time" -Fixture {
        It -Name "converts Pacific to Eastern time" -Test {
            $convert = Convert-TimeZone -Time $time -SourceTimeZone Pacific -TargetTimeZone Eastern
            $convert.Eastern | Should -Be $time.AddHours(3)
        }

        It -Name "converts Eastern to UTC time" -Test {
            $convert = Convert-TimeZone -Time $time -SourceTimeZone Eastern -TargetTimeZone UTC
            $convert.UTC | Should -Be (Get-Date -Date '10/5/2011 7:00:00 PM')
        }

        It -Name "converts UTC to Pacific time" -Test {
            $convert = Convert-TimeZone -Time $time -SourceTimeZone UTC -TargetTimeZone Pacific
            $convert.Pacific | Should -Be (Get-Date -Date '10/5/2011 8:00:00 AM')
        }
    }

    Context -Name "converts multiple times" -Fixture {
        It -Name "converts times through pipeline" -Test {
            $convert = $time, $time2, $time3 | Convert-TimeZone -SourceTimeZone Pacific -TargetTimeZone Mountain
            $convert | Should -HaveCount 3
        }

        It -Name "converts multiple times in an array" -Test {
            $array = @($time, $time2, $time3)
            $convert = Convert-TimeZone -Time $array -SourceTimeZone Pacific -TargetTimeZone Mountain
            $convert | Should -HaveCount 3
        }

        BeforeAll {
            $time2 = Get-Date
            $time3 = Get-Date -Date "2050-06-01 4:20pm"
        }
    }

    BeforeAll {
        $time = Get-Date -Date "2011-10-05 3:00pm"
    }
}
