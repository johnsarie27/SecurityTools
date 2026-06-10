BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Test-Performance' -Fixture {

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Test-Performance' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -ScriptBlock as mandatory' -Test {
            $script:Cmd.Parameters['ScriptBlock'].Attributes.Mandatory | Should -Contain $true
        }

        It -Name 'declares -Iterations with the Runs alias' -Test {
            $script:Cmd.Parameters['Iterations'].Aliases | Should -Contain 'Runs'
        }

        It -Name 'defaults -Iterations to 10' -Test {
            # The default lives in the param() block; binding without -Iterations exercises it.
            $r = Test-Performance -ScriptBlock { 1 + 1 }
            $r.Measurements.Count | Should -Be 10
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects -Iterations below the ValidateRange minimum (3)' -Test {
            { Test-Performance -ScriptBlock { 1 + 1 } -Iterations 2 } | Should -Throw
        }

        It -Name 'rejects -Iterations above the ValidateRange maximum (10000)' -Test {
            { Test-Performance -ScriptBlock { 1 + 1 } -Iterations 10001 } | Should -Throw
        }

        It -Name 'rejects a null -ScriptBlock' -Test {
            { Test-Performance -ScriptBlock $null -Iterations 3 } | Should -Throw
        }
    }

    Context -Name 'execution' -Fixture {
        It -Name 'runs the script block exactly -Iterations times' -Test {
            $script:counter = 0
            $null = Test-Performance -ScriptBlock { $script:counter++ } -Iterations 3
            $script:counter | Should -Be 3
        }

        It -Name 'returns one measurement per iteration on the Measurements property' -Test {
            # Use Start-Sleep so each iteration accumulates measurable, non-uniform Ticks.
            # A trivial { 1 + 1 } block can measure as TimeSpan.Zero on fast Linux runners,
            # which trips a latent edge case in Out-MeasureResult when all ticks tie.
            $r = Test-Performance -ScriptBlock { Start-Sleep -Milliseconds 1 } -Iterations 4
            $r.Measurements | Should -HaveCount 4
        }

        It -Name 'returns Min/Max/Avg millisecond statistics from Out-MeasureResult' -Test {
            $r = Test-Performance -ScriptBlock { Start-Sleep -Milliseconds 1 } -Iterations 3
            foreach ($prop in 'MinMilliseconds', 'MaxMilliseconds', 'AvgMilliseconds') {
                $r.PSObject.Properties.Name | Should -Contain $prop
            }
            $r.MaxMilliseconds | Should -BeGreaterOrEqual $r.MinMilliseconds
        }
    }
}
