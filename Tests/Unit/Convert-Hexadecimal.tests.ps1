BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Convert-Hexadecimal' -Fixture {

    Context -Name 'decimal → hexadecimal (default set)' -Fixture {
        It -Name 'converts 4248 to 0x1098' -Test {
            Convert-Hexadecimal -Decimal '4248' | Should -Be '0x1098'
        }

        It -Name 'converts 0 to 0x0' -Test {
            Convert-Hexadecimal -Decimal '0' | Should -Be '0x0'
        }

        It -Name 'returns lowercase hex digits (per [Convert]::ToString base 16)' -Test {
            # 255 → 'ff' (lowercase from [Convert]::ToString)
            Convert-Hexadecimal -Decimal '255' | Should -Be '0xff'
        }
    }

    Context -Name 'parameter set conflicts' -Fixture {
        It -Name 'rejects -Hexadecimal and -Decimal supplied together' -Test {
            { Convert-Hexadecimal -Hexadecimal '1098' -Decimal '4248' } | Should -Throw
        }
    }
}
