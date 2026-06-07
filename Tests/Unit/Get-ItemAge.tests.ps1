BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-ItemAge' -Fixture {

    BeforeAll {
        # Build a temp directory layout we control. Files have LastWriteTime backdated so the
        # AgeInDays bucketing is deterministic regardless of when the test runs.
        $script:TempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
        $script:SubDir  = Join-Path -Path $script:TempDir -ChildPath 'nested'
        New-Item -Path $script:TempDir -ItemType Directory | Out-Null
        New-Item -Path $script:SubDir  -ItemType Directory | Out-Null

        # Top-level files (one old, one new)
        $oldFile = Join-Path -Path $script:TempDir -ChildPath 'old.txt'
        $newFile = Join-Path -Path $script:TempDir -ChildPath 'new.txt'
        Set-Content -Path $oldFile -Value ('a' * 1024)
        Set-Content -Path $newFile -Value ('b' * 2048)
        (Get-Item -Path $oldFile).LastWriteTime = (Get-Date).AddDays(-30)
        (Get-Item -Path $newFile).LastWriteTime = (Get-Date).AddDays(-1)

        # Nested file (recurse-only)
        $nestedFile = Join-Path -Path $script:SubDir -ChildPath 'deep.txt'
        Set-Content -Path $nestedFile -Value ('c' * 512)
        (Get-Item -Path $nestedFile).LastWriteTime = (Get-Date).AddDays(-10)
        # Backdate the directory entries too — Get-ChildItem -Recurse returns them, and the function
        # sorts ALL items (not just files) when picking OldestFile / NewestFile.
        (Get-Item -Path $script:SubDir).LastWriteTime = (Get-Date).AddDays(-15)
    }

    AfterAll {
        if (Test-Path -Path $script:TempDir) {
            Remove-Item -Path $script:TempDir -Recurse -Force -ErrorAction Ignore
        }
    }

    Context -Name 'happy path with recursion (default)' -Fixture {
        BeforeAll { $script:Result = Get-ItemAge -Path $script:TempDir -AgeInDays 7 }

        It -Name 'reports Deep=$true when -NoRecurse is not specified' -Test {
            $script:Result.Deep | Should -BeTrue
        }

        It -Name 'counts files including nested directory contents' -Test {
            # 2 top-level files + 1 nested + 1 directory entry = 4
            $script:Result.TotalFiles | Should -Be 4
        }

        It -Name 'puts files older than AgeInDays into the older bucket' -Test {
            # old.txt (30d), deep.txt (10d), nested dir (15d) are all older than 7 days
            $script:Result.'OlderThan7-Days' | Should -Be 3
        }

        It -Name 'puts files newer than AgeInDays into the newer bucket' -Test {
            # only new.txt (1d) is newer than 7 days
            $script:Result.'NewerThan7-Days' | Should -Be 1
        }

        It -Name 'reports Directory as the absolute path' -Test {
            $script:Result.Directory | Should -Be (Get-Item -Path $script:TempDir).FullName
        }

        It -Name 'identifies the oldest file as old.txt' -Test {
            $script:Result.OldestFile.Name | Should -Be 'old.txt'
        }

        It -Name 'identifies the newest file as new.txt' -Test {
            $script:Result.NewestFile.Name | Should -Be 'new.txt'
        }
    }

    Context -Name '-NoRecurse behavior' -Fixture {
        It -Name 'reports Deep=$false and excludes nested files when -NoRecurse is specified' -Test {
            $result = Get-ItemAge -Path $script:TempDir -AgeInDays 7 -NoRecurse
            $result.Deep       | Should -BeFalse
            # 2 top-level files + 1 directory entry (the nested subdir itself) = 3
            $result.TotalFiles | Should -Be 3
        }
    }

    Context -Name 'aliases and parameter validation' -Fixture {
        It -Name 'exposes the Get-DirItemAges alias' -Test {
            (Get-Alias -Name 'Get-DirItemAges' -ErrorAction Ignore).ResolvedCommandName | Should -Be 'Get-ItemAge'
        }

        It -Name 'accepts -Path via the Directory alias' -Test {
            { Get-ItemAge -Directory $script:TempDir -AgeInDays 7 } | Should -Not -Throw
        }

        It -Name 'rejects a -Path that does not exist' -Test {
            { Get-ItemAge -Path (Join-Path -Path $script:TempDir -ChildPath 'missing') } | Should -Throw
        }

        It -Name 'rejects a -Path that is a file rather than a container' -Test {
            $file = Join-Path -Path $script:TempDir -ChildPath 'old.txt'
            { Get-ItemAge -Path $file } | Should -Throw
        }

        It -Name 'rejects -AgeInDays outside the 1..365 range' -Test {
            { Get-ItemAge -Path $script:TempDir -AgeInDays 0 }   | Should -Throw
            { Get-ItemAge -Path $script:TempDir -AgeInDays 366 } | Should -Throw
        }
    }
}
