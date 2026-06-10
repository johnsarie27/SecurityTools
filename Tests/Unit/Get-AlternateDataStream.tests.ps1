BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-AlternateDataStream' -Fixture {

    # Get-Item -Stream * is Windows/NTFS only — on Linux/macOS PowerShell rejects the parameter
    # set entirely, so cross-platform coverage here is metadata + parameter validation only.
    # The Windows-only happy path lives in Get-AlternateDataStream.tests.windows.ps1.

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Get-AlternateDataStream' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -Path with default value "*.*" (not mandatory)' -Test {
            $param = $script:Cmd.Parameters['Path']
            $param.Attributes.Mandatory | Should -Not -Contain $true
            $param.Attributes.Position  | Should -Contain 0
        }

        It -Name 'declares System.Management.Automation.PSCustomObject as the output type' -Test {
            $script:Cmd.OutputType.Type | Should -Contain ([System.Management.Automation.PSCustomObject])
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an empty -Path' -Test {
            { Get-AlternateDataStream -Path '' } | Should -Throw
        }
    }
}
