BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'ConvertTo-MarkdownTable' -Fixture {

    Context -Name 'header + body' -Fixture {
        It -Name 'emits a header row, separator row, and one data row per input' -Test {
            $rows = @(
                [PSCustomObject] @{ Name = 'alpha'; Value = 1 }
                [PSCustomObject] @{ Name = 'beta' ; Value = 2 }
            )
            $result = $rows | ConvertTo-MarkdownTable
            $result.Count | Should -Be 4
            $result[0] | Should -Be '| Name | Value |'
            # second row is the dashed separator — same width per column as the header letters
            $result[1] | Should -Be '| ---- | ----- |'
            $result[2] | Should -Be '| alpha | 1 |'
            $result[3] | Should -Be '| beta | 2 |'
        }
    }

    Context -Name 'pipe escaping' -Fixture {
        It -Name 'escapes pipe characters in values so they do not break the table' -Test {
            $row = [PSCustomObject] @{ Col = 'left|right' }
            $result = $row | ConvertTo-MarkdownTable
            # Header (no pipe in name), separator, then the data row with the escaped pipe
            $result[-1] | Should -Be '| left\|right |'
        }
    }

    Context -Name 'single column / single row' -Fixture {
        It -Name 'still emits the three-line structure for a single column' -Test {
            $result = ([PSCustomObject] @{ Only = 'value' }) | ConvertTo-MarkdownTable
            $result.Count | Should -Be 3
            $result[0] | Should -Be '| Only |'
        }
    }
}
