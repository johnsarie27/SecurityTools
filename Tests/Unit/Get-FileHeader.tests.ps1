BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-FileHeader' -Fixture {

    BeforeAll {
        $script:TempDir  = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
        New-Item -Path $script:TempDir -ItemType Directory | Out-Null

        # Write a known byte sequence to a temp file: 50 4B 03 04 05 06 07 08 (ZIP magic + filler).
        $script:KnownBytes = [System.Byte[]] @(0x50, 0x4B, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08)
        $script:TempFile   = Join-Path -Path $script:TempDir -ChildPath 'known.bin'
        [System.IO.File]::WriteAllBytes($script:TempFile, $script:KnownBytes)
    }

    AfterAll {
        if (Test-Path -Path $script:TempDir) {
            Remove-Item -Path $script:TempDir -Recurse -Force -ErrorAction Ignore
        }
    }

    Context -Name 'happy path' -Fixture {
        It -Name 'returns the first 4 bytes as space-separated hex by default' -Test {
            Get-FileHeader -Path $script:TempFile | Should -Be '50 4B 03 04'
        }

        It -Name 'returns the requested number of bytes when -Bytes is specified' -Test {
            Get-FileHeader -Path $script:TempFile -Bytes 8 | Should -Be '50 4B 03 04 05 06 07 08'
        }

        It -Name 'returns exactly 2 bytes when -Bytes is at the minimum of 2' -Test {
            $result = Get-FileHeader -Path $script:TempFile -Bytes 2
            ($result -split ' ').Count | Should -Be 2
            $result | Should -Be '50 4B'
        }

        It -Name 'accepts -Path via pipeline' -Test {
            $script:TempFile | Get-FileHeader | Should -Be '50 4B 03 04'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a -Path that does not exist' -Test {
            { Get-FileHeader -Path (Join-Path -Path $script:TempDir -ChildPath 'missing.bin') } | Should -Throw
        }

        It -Name 'rejects a -Path that is a directory rather than a file' -Test {
            { Get-FileHeader -Path $script:TempDir } | Should -Throw
        }

        It -Name 'rejects -Bytes below the minimum of 2' -Test {
            { Get-FileHeader -Path $script:TempFile -Bytes 1 } | Should -Throw
        }

        It -Name 'rejects -Bytes above the maximum of 100' -Test {
            { Get-FileHeader -Path $script:TempFile -Bytes 101 } | Should -Throw
        }
    }
}
