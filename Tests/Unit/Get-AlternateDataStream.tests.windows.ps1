BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-AlternateDataStream' -Fixture {

    # Get-Item -Stream * is Windows/NTFS only. These tests stage a real file with an alternate
    # data stream and verify the function projects it cleanly.

    Context -Name 'happy path' -Fixture {
        BeforeAll {
            $script:TempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
            New-Item -Path $script:TempDir -ItemType Directory | Out-Null

            $script:TestFile = Join-Path -Path $script:TempDir -ChildPath 'fixture.dat'
            Set-Content -Path $script:TestFile -Value 'primary stream content'
            Set-Content -Path $script:TestFile -Stream 'TestStream' -Value 'hidden stream payload'
        }

        AfterAll {
            if (Test-Path -Path $script:TempDir) {
                Remove-Item -Path $script:TempDir -Recurse -Force -ErrorAction Ignore
            }
        }

        It -Name 'returns the alternate data stream and omits the default :$DATA stream' -Test {
            $result = Get-AlternateDataStream -Path $script:TestFile
            $result               | Should -Not -BeNullOrEmpty
            $result.Stream        | Should -Be 'TestStream'
            $result.Stream        | Should -Not -Contain ':$DATA'
        }

        It -Name 'projects each stream with Path / Stream / Size properties' -Test {
            $result = Get-AlternateDataStream -Path $script:TestFile
            $result.Path          | Should -Be $script:TestFile
            $result.Size          | Should -BeGreaterThan 0
        }
    }
}
