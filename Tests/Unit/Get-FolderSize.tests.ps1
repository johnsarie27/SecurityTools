BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-FolderSize' -Fixture {

    BeforeAll {
        # Build: <Temp>/<guid>/alpha/file_1KB.dat, /<guid>/beta/file_2KB.dat, /<guid>/gamma/file_512B.dat
        $script:TempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
        New-Item -Path $script:TempDir -ItemType Directory | Out-Null

        $script:AlphaDir = Join-Path -Path $script:TempDir -ChildPath 'alpha'
        $script:BetaDir = Join-Path -Path $script:TempDir -ChildPath 'beta'
        $script:GammaDir = Join-Path -Path $script:TempDir -ChildPath 'gamma'
        New-Item -Path $script:AlphaDir -ItemType Directory | Out-Null
        New-Item -Path $script:BetaDir  -ItemType Directory | Out-Null
        New-Item -Path $script:GammaDir -ItemType Directory | Out-Null

        # WriteAllBytes gives us exact, deterministic file sizes.
        [System.IO.File]::WriteAllBytes((Join-Path -Path $script:AlphaDir -ChildPath 'a.dat'), [System.Byte[]]::new(1024))
        [System.IO.File]::WriteAllBytes((Join-Path -Path $script:BetaDir  -ChildPath 'b.dat'), [System.Byte[]]::new(2048))
        [System.IO.File]::WriteAllBytes((Join-Path -Path $script:GammaDir -ChildPath 'c.dat'), [System.Byte[]]::new(512))
    }

    AfterAll {
        if (Test-Path -Path $script:TempDir) {
            Remove-Item -Path $script:TempDir -Recurse -Force -ErrorAction Ignore
        }
    }

    Context -Name 'happy path with explicit -Path' -Fixture {
        BeforeAll { $script:Result = Get-FolderSize -Path $script:TempDir }

        It -Name 'emits one row per child folder plus a GrandTotal row' -Test {
            # 3 folders + GrandTotal = 4
            $script:Result.Count | Should -Be 4
        }

        It -Name 'reports exact byte counts for each subfolder' -Test {
            ($script:Result | Where-Object FolderName -eq 'alpha').'Size(Bytes)' | Should -Be 1024
            ($script:Result | Where-Object FolderName -eq 'beta').'Size(Bytes)'  | Should -Be 2048
            ($script:Result | Where-Object FolderName -eq 'gamma').'Size(Bytes)' | Should -Be 512
        }

        It -Name 'sums the GrandTotal row to the total of all folders' -Test {
            $total = $script:Result | Where-Object FolderName -eq 'GrandTotal'
            $total.'Size(Bytes)' | Should -Be 3584   # 1024 + 2048 + 512
        }
    }

    Context -Name '-NoTotal switch' -Fixture {
        It -Name 'omits the GrandTotal row when -NoTotal is specified' -Test {
            $result = Get-FolderSize -Path $script:TempDir -NoTotal
            $result.Count | Should -Be 3
            ($result | Where-Object FolderName -eq 'GrandTotal') | Should -BeNullOrEmpty
        }
    }

    Context -Name '-OmitFolder filter' -Fixture {
        It -Name 'excludes folders whose full path matches -OmitFolder' -Test {
            $result = Get-FolderSize -Path $script:TempDir -OmitFolder $script:BetaDir -NoTotal
            $result.Count | Should -Be 2
            ($result | Where-Object FolderName -eq 'beta') | Should -BeNullOrEmpty
        }
    }

    Context -Name '-FolderName filter' -Fixture {
        It -Name 'returns only the folder matching -FolderName' -Test {
            $result = Get-FolderSize -Path $script:TempDir -FolderName 'alpha' -NoTotal
            $result.Count           | Should -Be 1
            $result.FolderName      | Should -Be 'alpha'
            $result.'Size(Bytes)'   | Should -Be 1024
        }
    }
}
