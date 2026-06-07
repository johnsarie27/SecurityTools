BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-DirectoryReport' -Fixture {

    BeforeAll {
        $script:TempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
        $script:OutDir  = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
        New-Item -Path $script:TempDir -ItemType Directory | Out-Null
        New-Item -Path $script:OutDir  -ItemType Directory | Out-Null

        # Create a subfolder with two known-size files. Sizes are far below 1 GB; we test by
        # passing very small -SizeInGb thresholds or -All.
        $subDir = Join-Path -Path $script:TempDir -ChildPath 'data'
        New-Item -Path $subDir -ItemType Directory | Out-Null
        [System.IO.File]::WriteAllBytes((Join-Path -Path $subDir -ChildPath 'big.dat'),   [System.Byte[]]::new(4096))
        [System.IO.File]::WriteAllBytes((Join-Path -Path $subDir -ChildPath 'small.dat'), [System.Byte[]]::new(128))
    }

    AfterAll {
        foreach ($d in @($script:TempDir, $script:OutDir)) {
            if (Test-Path -Path $d) { Remove-Item -Path $d -Recurse -Force -ErrorAction Ignore }
        }
    }

    Context -Name 'happy path with -All' -Fixture {
        It -Name 'emits string output including the Directory: header line' -Test {
            $output = Get-DirectoryReport -Path $script:TempDir -All
            ($output -join "`n") | Should -Match 'Directory: '
        }

        It -Name 'emits a "Files greater than: 0 GB" section when -All is used' -Test {
            $output = Get-DirectoryReport -Path $script:TempDir -All
            ($output -join "`n") | Should -Match 'Files greater than: 0'
        }
    }

    Context -Name '-OutputDirectory writes a log file' -Fixture {
        It -Name 'creates a DirStats_<timestamp>.log file in the output directory' -Test {
            # Drain pre-existing logs so we can detect the new one deterministically
            Get-ChildItem -Path $script:OutDir -Filter 'DirStats_*.log' | Remove-Item -Force -ErrorAction Ignore

            Get-DirectoryReport -Path $script:TempDir -OutputDirectory $script:OutDir -All | Out-Null

            $log = Get-ChildItem -Path $script:OutDir -Filter 'DirStats_*.log'
            $log              | Should -Not -BeNullOrEmpty
            $log.Count        | Should -Be 1
            (Get-Content -Path $log.FullName -Raw) | Should -Match 'Directory: '
        }
    }

    Context -Name 'aliases and parameter validation' -Fixture {
        It -Name 'exposes the Get-DirStats alias' -Test {
            (Get-Alias -Name 'Get-DirStats' -ErrorAction Ignore).ResolvedCommandName | Should -Be 'Get-DirectoryReport'
        }

        It -Name 'rejects a -Path that does not exist' -Test {
            { Get-DirectoryReport -Path (Join-Path -Path $script:TempDir -ChildPath 'missing') } | Should -Throw
        }

        It -Name 'rejects a -Path that is a file rather than a container' -Test {
            $f = Join-Path -Path $script:TempDir -ChildPath 'data/small.dat'
            { Get-DirectoryReport -Path $f } | Should -Throw
        }

        It -Name 'rejects an -OutputDirectory that does not exist' -Test {
            { Get-DirectoryReport -Path $script:TempDir -OutputDirectory (Join-Path -Path $script:OutDir -ChildPath 'missing') } | Should -Throw
        }

        It -Name 'rejects -SizeInGb outside the 0..10 range' -Test {
            { Get-DirectoryReport -Path $script:TempDir -SizeInGb 11 } | Should -Throw
        }
    }
}
