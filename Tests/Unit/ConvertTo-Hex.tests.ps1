BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'ConvertTo-Hex' -Fixture {

    Context -Name 'single character' -Fixture {
        It -Name "returns 0x41 for 'A' (ASCII 65)" -Test {
            $result = ConvertTo-Hex -Character 'A'
            $result.Char | Should -Be 'A'
            $result.Hex  | Should -Be '0x41'
        }

        It -Name "returns 0x30 for '0' (ASCII 48)" -Test {
            (ConvertTo-Hex -Character '0').Hex | Should -Be '0x30'
        }

        It -Name "returns 0x20 for ' ' (space, ASCII 32)" -Test {
            (ConvertTo-Hex -Character ' ').Hex | Should -Be '0x20'
        }
    }

    Context -Name 'multi-character input' -Fixture {
        It -Name "emits one PSCustomObject per character in 'AB'" -Test {
            $result = ConvertTo-Hex -Character 'A', 'B'
            $result.Count | Should -Be 2
            $result[0].Hex | Should -Be '0x41'
            $result[1].Hex | Should -Be '0x42'
        }
    }

    Context -Name 'pipeline input' -Fixture {
        It -Name 'accepts characters from the pipeline' -Test {
            $result = 'A', 'B', 'C' | ForEach-Object { [char] $_ } | ConvertTo-Hex
            $result.Hex | Should -Be @('0x41', '0x42', '0x43')
        }
    }

    Context -Name 'output shape' -Fixture {
        It -Name 'returns objects with Char and Hex properties' -Test {
            $result = ConvertTo-Hex -Character 'Z'
            $result.PSObject.Properties.Name | Should -Contain 'Char'
            $result.PSObject.Properties.Name | Should -Contain 'Hex'
        }

        It -Name 'always produces 0x followed by exactly two uppercase hex digits' -Test {
            (ConvertTo-Hex -Character 'a').Hex | Should -CMatch '^0x[0-9A-F]{2}$'
            (ConvertTo-Hex -Character '~').Hex | Should -CMatch '^0x[0-9A-F]{2}$'
        }
    }
}
