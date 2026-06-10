BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Out-MeasureResult' -Fixture {

    Context -Name 'aggregates a TimeSpan collection' -Fixture {
        BeforeAll {
            # 100ms, 200ms, 300ms → max=300, min=100, avg=200
            $script:Spans = @(
                [TimeSpan]::FromMilliseconds(100)
                [TimeSpan]::FromMilliseconds(200)
                [TimeSpan]::FromMilliseconds(300)
            )
        }

        It -Name 'reports MaxMilliseconds from the longest TimeSpan' -Test {
            ($script:Spans | Out-MeasureResult).MaxMilliseconds | Should -Be 300
        }

        It -Name 'reports MinMilliseconds from the shortest TimeSpan' -Test {
            ($script:Spans | Out-MeasureResult).MinMilliseconds | Should -Be 100
        }

        It -Name 'reports AvgMilliseconds from the arithmetic mean' -Test {
            ($script:Spans | Out-MeasureResult).AvgMilliseconds | Should -Be 200
        }
    }

    Context -Name 'output shape' -Fixture {
        It -Name 'returns a single PSCustomObject with the expected properties' -Test {
            $result = @([TimeSpan]::FromMilliseconds(50)) | Out-MeasureResult
            $result | Should -BeOfType [System.Management.Automation.PSCustomObject]
            $result.PSObject.Properties.Name | Should -Contain 'MaxMilliseconds'
            $result.PSObject.Properties.Name | Should -Contain 'MinMilliseconds'
            $result.PSObject.Properties.Name | Should -Contain 'AvgMilliseconds'
        }

        It -Name 'all three values equal the only TimeSpan when a single measurement is supplied' -Test {
            $result = @([TimeSpan]::FromMilliseconds(42)) | Out-MeasureResult
            $result.MaxMilliseconds | Should -Be 42
            $result.MinMilliseconds | Should -Be 42
            $result.AvgMilliseconds | Should -Be 42
        }
    }

    Context -Name 'array argument vs pipeline' -Fixture {
        It -Name 'aggregates identically whether passed via -Measurement or piped' -Test {
            $spans = @(
                [TimeSpan]::FromMilliseconds(10)
                [TimeSpan]::FromMilliseconds(20)
                [TimeSpan]::FromMilliseconds(30)
            )
            $viaParam = Out-MeasureResult -Measurement $spans
            $viaPipe = $spans | Out-MeasureResult
            $viaParam.MaxMilliseconds | Should -Be $viaPipe.MaxMilliseconds
            $viaParam.MinMilliseconds | Should -Be $viaPipe.MinMilliseconds
            $viaParam.AvgMilliseconds | Should -Be $viaPipe.AvgMilliseconds
        }
    }

    Context -Name 'tied measurements' -Fixture {
        It -Name 'handles a collection where every TimeSpan has identical Ticks' -Test {
            # Regression: a prior implementation used $list.Where({ $_.Ticks -eq $max })
            # which returned a multi-element collection when all ticks tied, and the
            # subsequent [System.Int32] cast on the member-enumerated TotalMilliseconds
            # array silently failed — producing a null result.
            $spans = @([TimeSpan]::Zero, [TimeSpan]::Zero, [TimeSpan]::Zero, [TimeSpan]::Zero)
            $result = $spans | Out-MeasureResult
            $result | Should -Not -BeNullOrEmpty
            $result.MaxMilliseconds | Should -Be 0
            $result.MinMilliseconds | Should -Be 0
            $result.AvgMilliseconds | Should -Be 0
        }
    }
}
