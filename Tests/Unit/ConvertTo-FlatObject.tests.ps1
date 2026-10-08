BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'ConvertTo-FlatObject' -Fixture {

    Context -Name 'flat object passthrough' -Fixture {
        It -Name 'returns the same properties when the object is already flat' -Test {
            $obj = [PSCustomObject] @{ Name = 'alpha'; Value = 1 }
            $result = ConvertTo-FlatObject -Object $obj
            $result.Name  | Should -Be 'alpha'
            $result.Value | Should -Be 1
        }

        It -Name 'preserves property order' -Test {
            $obj = [PSCustomObject] [ordered] @{ Z = 1; A = 2; M = [PSCustomObject] @{ Q = 3 } }
            $result = ConvertTo-FlatObject -Object $obj
            $result.PSObject.Properties.Name | Should -Be @('Z', 'A', 'M.Q')
        }
    }

    Context -Name 'nested object flattening' -Fixture {
        It -Name 'joins nested property names with the default "." separator' -Test {
            $obj = [PSCustomObject] @{
                Outer = [PSCustomObject] @{ Inner = 'value' }
            }
            $result = ConvertTo-FlatObject -Object $obj
            $result.'Outer.Inner' | Should -Be 'value'
        }

        It -Name 'honors a custom -Separator' -Test {
            $obj = [PSCustomObject] @{
                Outer = [PSCustomObject] @{ Inner = 'value' }
            }
            $result = ConvertTo-FlatObject -Object $obj -Separator '__'
            $result.'Outer__Inner' | Should -Be 'value'
        }

        It -Name 'flattens dictionaries by key, at the root and nested' -Test {
            $obj = [ordered] @{ K = 1; H = [ordered] @{ J = 2 } }
            $result = ConvertTo-FlatObject -Object $obj
            $result.PSObject.Properties.Name | Should -Be @('K', 'H.J')
            $result.'H.J' | Should -Be 2
        }
    }

    Context -Name 'arrays' -Fixture {
        It -Name 'indexes array items from 0 by default' -Test {
            $result = ConvertTo-FlatObject -Object ([PSCustomObject] @{ L = @('x', 'y') })
            $result.PSObject.Properties.Name | Should -Be @('L.0', 'L.1')
            $result.'L.1' | Should -Be 'y'
        }

        It -Name 'indexes array items from 1 with -Base 1' -Test {
            $result = ConvertTo-FlatObject -Object ([PSCustomObject] @{ L = @('x', 'y') }) -Base 1
            $result.PSObject.Properties.Name | Should -Be @('L.1', 'L.2')
        }

        It -Name 'leaves the first item unnamed with -Base ""' -Test {
            $result = ConvertTo-FlatObject -Object ([PSCustomObject] @{ L = @('x', 'y', 'z') }) -Base ''
            $result.PSObject.Properties.Name | Should -Be @('L', 'L.1', 'L.2')
            $result.L | Should -Be 'x'
        }

        It -Name 'flattens objects inside arrays' -Test {
            $obj = [PSCustomObject] @{ L = @([PSCustomObject] @{ N = 'a' }, [PSCustomObject] @{ N = 'b' }) }
            $result = ConvertTo-FlatObject -Object $obj -Separator '/'
            $result.'L/0/N' | Should -Be 'a'
            $result.'L/1/N' | Should -Be 'b'
        }

        It -Name 'flattens nested arrays' -Test {
            $result = ConvertTo-FlatObject -Object ([PSCustomObject] @{ L = @(, @(1, 2)) })
            $result.'L.0.0' | Should -Be 1
            $result.'L.0.1' | Should -Be 2
        }
    }

    Context -Name 'leaf values' -Fixture {
        It -Name 'converts DateTime, TimeSpan and Version values to strings' -Test {
            $obj = [PSCustomObject] @{ D = [datetime] '2020-01-02'; T = [timespan] '00:01:00'; V = [version] '1.2' }
            $result = ConvertTo-FlatObject -Object $obj
            $result.D | Should -BeOfType [System.String]
            $result.T | Should -Be '00:01:00'
            $result.V | Should -Be '1.2'
        }

        It -Name 'converts enum values to their name' -Test {
            $result = ConvertTo-FlatObject -Object ([PSCustomObject] @{ E = [System.DayOfWeek]::Monday })
            $result.PSObject.Properties.Name | Should -Be @('E')
            $result.E | Should -Be 'Monday'
        }

        It -Name 'keeps primitive values as their own type' -Test {
            $result = ConvertTo-FlatObject -Object ([PSCustomObject] @{ I = 5; B = $true })
            $result.I | Should -BeOfType [System.Int32]
            $result.B | Should -BeTrue
        }

        It -Name 'keeps a null property as a null value' -Test {
            $result = ConvertTo-FlatObject -Object ([PSCustomObject] @{ N = $null; S = 's' }) -ErrorAction Stop
            $result.PSObject.Properties.Name | Should -Contain 'N'
            $result.N | Should -BeNullOrEmpty
        }

        It -Name 'returns null for an empty dictionary' -Test {
            $result = ConvertTo-FlatObject -Object ([PSCustomObject] @{ E = @{}; S = 's' })
            $result.PSObject.Properties.Name | Should -Contain 'E'
            $result.E | Should -BeNullOrEmpty
        }
    }

    Context -Name 'Depth' -Fixture {
        BeforeAll {
            $script:nested = [PSCustomObject] @{ A = 1; B = [PSCustomObject] @{ C = 2; D = [PSCustomObject] @{ E = 3 } } }
        }

        It -Name 'stops flattening below -Depth and keeps the deeper value as-is' -Test {
            $result = ConvertTo-FlatObject -Object $script:nested -Depth 2
            $result.PSObject.Properties.Name | Should -Be @('A', 'B.C', 'B.D')
            $result.'B.D'.E | Should -Be 3
        }

        It -Name 'returns top-level properties unflattened with -Depth 1' -Test {
            $result = ConvertTo-FlatObject -Object $script:nested -Depth 1
            $result.PSObject.Properties.Name | Should -Be @('A', 'B')
        }

        It -Name 'flattens without limit for a negative -Depth' -Test {
            $result = ConvertTo-FlatObject -Object $script:nested -Depth -1
            $result.'B.D.E' | Should -Be 3
        }
    }

    Context -Name 'ExcludeProperty' -Fixture {
        It -Name 'omits any property whose name is listed in -ExcludeProperty' -Test {
            $obj = [PSCustomObject] @{ Keep = 1; Drop = 2 }
            $result = ConvertTo-FlatObject -Object $obj -ExcludeProperty 'Drop'
            $result.PSObject.Properties.Name | Should -Contain 'Keep'
            $result.PSObject.Properties.Name | Should -Not -Contain 'Drop'
        }

        It -Name 'omits excluded properties at nested levels' -Test {
            $obj = [PSCustomObject] @{ Keep = 1; O = [PSCustomObject] @{ Drop = 2; Stay = 3 } }
            $result = ConvertTo-FlatObject -Object $obj -ExcludeProperty 'Drop'
            $result.PSObject.Properties.Name | Should -Be @('Keep', 'O.Stay')
        }
    }

    Context -Name 'pipeline + multiple inputs' -Fixture {
        It -Name 'emits one flat object per piped input' -Test {
            $a = [PSCustomObject] @{ X = 1 }
            $b = [PSCustomObject] @{ X = 2 }
            $result = @($a, $b) | ConvertTo-FlatObject
            $result.Count | Should -Be 2
            $result[0].X | Should -Be 1
            $result[1].X | Should -Be 2
        }
    }
}
