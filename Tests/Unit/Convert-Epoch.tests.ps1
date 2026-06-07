BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Convert-Epoch' -Fixture {

    Context -Name 'seconds → DateTime' -Fixture {
        It -Name 'converts 0 to the Unix epoch (1970-01-01 UTC)' -Test {
            $result = Convert-Epoch -Seconds 0
            $result.ToUniversalTime() | Should -Be ([DateTime] '1970-01-01T00:00:00Z').ToUniversalTime()
        }

        It -Name 'converts 1577836800 to 2020-01-01T00:00:00Z (verified Unix time)' -Test {
            $result = Convert-Epoch -Seconds 1577836800
            $result.ToUniversalTime() | Should -Be ([DateTime]::new(2020, 1, 1, 0, 0, 0, [DateTimeKind]::Utc))
        }
    }

    Context -Name 'milliseconds → DateTime' -Fixture {
        It -Name 'converts 1577836800000 ms identically to 1577836800 s' -Test {
            $fromSec = Convert-Epoch -Seconds 1577836800
            $fromMs = Convert-Epoch -Milliseconds 1577836800000
            $fromMs | Should -Be $fromSec
        }
    }

    Context -Name 'DateTime → epoch (default parameter set)' -Fixture {
        It -Name 'returns an object with Date / Seconds / Milliseconds properties' -Test {
            $result = Convert-Epoch -Date ([DateTime] '2020-01-01T00:00:00Z')
            $result.PSObject.Properties.Name | Should -Contain 'Date'
            $result.PSObject.Properties.Name | Should -Contain 'Seconds'
            $result.PSObject.Properties.Name | Should -Contain 'Milliseconds'
        }

        It -Name 'reports 1577836800 seconds for 2020-01-01T00:00:00Z' -Test {
            $result = Convert-Epoch -Date ([DateTime]::new(2020, 1, 1, 0, 0, 0, [DateTimeKind]::Utc))
            $result.Seconds      | Should -Be 1577836800
            $result.Milliseconds | Should -Be 1577836800000
        }
    }

    Context -Name 'parameter set conflicts' -Fixture {
        It -Name 'rejects -Seconds and -Milliseconds supplied together' -Test {
            { Convert-Epoch -Seconds 1 -Milliseconds 1000 } | Should -Throw
        }
    }
}
