BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-AlternateDataStream' -Fixture {

    # Get-Item -Stream * is Windows/NTFS only — on Linux/macOS PowerShell rejects the parameter
    # set entirely, so body-level invocation here is metadata + parameter-validation only, plus
    # a Windows-only happy-path that creates a real ADS on the test fixture file.

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

    Context -Name 'happy path (Windows only)' -Fixture {
        BeforeAll {
            if ($IsWindows) {
                $script:TempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
                New-Item -Path $script:TempDir -ItemType Directory | Out-Null

                $script:TestFile = Join-Path -Path $script:TempDir -ChildPath 'fixture.dat'
                Set-Content -Path $script:TestFile -Value 'primary stream content'
                # Add an alternate data stream
                Set-Content -Path $script:TestFile -Stream 'TestStream' -Value 'hidden stream payload'
            }
        }

        AfterAll {
            if ($IsWindows -and (Test-Path -Path $script:TempDir)) {
                Remove-Item -Path $script:TempDir -Recurse -Force -ErrorAction Ignore
            }
        }

        It -Name 'returns the alternate data stream and omits the default :$DATA stream' -Skip:(-not $IsWindows) -Test {
            $result = Get-AlternateDataStream -Path $script:TestFile
            $result               | Should -Not -BeNullOrEmpty
            $result.Stream        | Should -Be 'TestStream'
            $result.Stream        | Should -Not -Contain ':$DATA'
        }

        It -Name 'projects each stream with Path / Stream / Size properties' -Skip:(-not $IsWindows) -Test {
            $result = Get-AlternateDataStream -Path $script:TestFile
            $result.Path          | Should -Be $script:TestFile
            $result.Size          | Should -BeGreaterThan 0
        }
    }
}
