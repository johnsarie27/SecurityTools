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
    }

    Context -Name 'ExcludeProperty' -Fixture {
        It -Name 'omits any property whose name is listed in -ExcludeProperty' -Test {
            $obj = [PSCustomObject] @{ Keep = 1; Drop = 2 }
            $result = ConvertTo-FlatObject -Object $obj -ExcludeProperty 'Drop'
            $result.PSObject.Properties.Name | Should -Contain 'Keep'
            $result.PSObject.Properties.Name | Should -Not -Contain 'Drop'
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
