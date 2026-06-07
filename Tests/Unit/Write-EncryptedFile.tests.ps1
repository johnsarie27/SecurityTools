BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Write-EncryptedFile' -Fixture {

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a Path whose parent directory does not exist' -Test {
            $bad = Join-Path -Path $TestDrive -ChildPath 'no-such-dir/out.enc'
            { Write-EncryptedFile -Content 'data' -Path $bad -Key 'k' } | Should -Throw
        }

        It -Name 'rejects supplying both -Key and -KeyBytes (parameter set conflict)' -Test {
            $dest = Join-Path -Path $TestDrive -ChildPath 'both.enc'
            { Write-EncryptedFile -Content 'data' -Path $dest -Key 'k' -KeyBytes ([byte[]] @(1, 2, 3)) } |
                Should -Throw
        }
    }

    Context -Name 'happy path' -Fixture {
        BeforeEach {
            $script:DestPath = Join-Path -Path $TestDrive -ChildPath ('enc-{0}.bin' -f ([System.Guid]::NewGuid().ToString('N')))
        }

        It -Name 'creates the destination file and returns a FileInfo for it' -Test {
            $result = Write-EncryptedFile -Content 'hello' -Path $script:DestPath -Key 'Password123'
            Test-Path -Path $script:DestPath -PathType Leaf | Should -BeTrue
            $result | Should -BeOfType [System.IO.FileInfo]
            $result.FullName | Should -Be $script:DestPath
        }

        It -Name 'writes encrypted bytes (output differs from plaintext)' -Test {
            $plaintext = 'attack at dawn'
            Write-EncryptedFile -Content $plaintext -Path $script:DestPath -Key 'k'
            $bytes = [System.IO.File]::ReadAllBytes($script:DestPath)
            $bytes.Length | Should -BeGreaterThan 0
            ([System.Text.Encoding]::UTF8.GetString($bytes)) | Should -Not -Be $plaintext
        }

        It -Name 'round-trips through Read-EncryptedFile with a string key' -Test {
            Write-EncryptedFile -Content 'round-trip me' -Path $script:DestPath -Key 'shared'
            (Read-EncryptedFile -Path $script:DestPath -Key 'shared') | Should -Be 'round-trip me'
        }

        It -Name 'round-trips through Read-EncryptedFile with a byte-array key' -Test {
            $keyBytes = [System.Byte[]] 'abcdefghijklmnopqrstuvwxyz012345'.ToCharArray()
            Write-EncryptedFile -Content 'byte-key' -Path $script:DestPath -KeyBytes $keyBytes
            (Read-EncryptedFile -Path $script:DestPath -KeyBytes $keyBytes) | Should -Be 'byte-key'
        }

        It -Name 'pads short keys so a 5-char key round-trips' -Test {
            Write-EncryptedFile -Content 'short-key' -Path $script:DestPath -Key 'short'
            (Read-EncryptedFile -Path $script:DestPath -Key 'short') | Should -Be 'short-key'
        }

        It -Name 'truncates long keys so a 64-char key round-trips' -Test {
            $longKey = 'a' * 64
            Write-EncryptedFile -Content 'long-key' -Path $script:DestPath -Key $longKey
            (Read-EncryptedFile -Path $script:DestPath -Key $longKey) | Should -Be 'long-key'
        }

        It -Name 'round-trips multi-line content via pipeline' -Test {
            'line one', 'line two', 'line three' |
                Write-EncryptedFile -Path $script:DestPath -Key 'multi'
            $decrypted = Read-EncryptedFile -Path $script:DestPath -Key 'multi'
            $decrypted | Should -Be ('line one{0}line two{0}line three' -f [Environment]::NewLine)
        }
    }

    Context -Name 'ShouldProcess behavior' -Fixture {
        It -Name '-WhatIf does not create the destination file' -Test {
            $dest = Join-Path -Path $TestDrive -ChildPath 'whatif.enc'
            Write-EncryptedFile -Content 'data' -Path $dest -Key 'k' -WhatIf
            Test-Path -Path $dest | Should -BeFalse
        }
    }

    Context -Name 'overwrite semantics' -Fixture {
        It -Name 'overwrites an existing file at Path with new ciphertext' -Test {
            $dest = Join-Path -Path $TestDrive -ChildPath 'overwrite.enc'
            Write-EncryptedFile -Content 'first' -Path $dest -Key 'k'
            Write-EncryptedFile -Content 'second' -Path $dest -Key 'k'
            (Read-EncryptedFile -Path $dest -Key 'k') | Should -Be 'second'
        }
    }
}
