BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-MsiInfo' -Fixture {

    # Reading the property table of a real MSI requires the WindowsInstaller COM object plus a
    # binary .msi fixture, neither of which suits a unit test, so the happy path is not
    # exercised here. The validation and error paths below all run before COM is touched.

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Get-MsiInfo' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -Path as mandatory with pipeline support' -Test {
            $param = $script:Cmd.Parameters['Path']
            $param.Attributes.Mandatory                       | Should -Contain $true
            $param.Attributes.ValueFromPipeline               | Should -Contain $true
            $param.Attributes.ValueFromPipelineByPropertyName | Should -Contain $true
        }
    }

    Context -Name 'error paths' -Fixture {
        It -Name 'rejects an empty path' -Test {
            { Get-MsiInfo -Path '' } | Should -Throw
        }

        It -Name 'throws when the file is not an msi' -Test {
            $file = Join-Path -Path $TestDrive -ChildPath 'installer.txt'
            Set-Content -Path $file -Value 'not an msi'
            { Get-MsiInfo -Path $file } | Should -Throw -ExpectedMessage '*must be an msi*'
        }

        It -Name 'throws when a relative path cannot be resolved' -Test {
            { Get-MsiInfo -Path 'no-such-dir/missing.msi' } | Should -Throw
        }
    }
}
