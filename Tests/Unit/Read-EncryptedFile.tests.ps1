BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Read-EncryptedFile' -Fixture {

    BeforeAll {
        function New-EncryptedFixture {
            param(
                [Parameter(Mandatory)] [string] $Path,
                [Parameter(Mandatory)] [string] $Content,
                [string] $Key
            )
            Write-EncryptedFile -Content $Content -Path $Path -Key $Key | Out-Null
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a Path that does not exist' -Test {
            $missing = Join-Path -Path $TestDrive -ChildPath 'no-such.enc'
            { Read-EncryptedFile -Path $missing -Key 'k' } | Should -Throw
        }

        It -Name 'rejects a Path that is a directory rather than a file' -Test {
            $dir = Join-Path -Path $TestDrive -ChildPath 'dir-not-file'
            New-Item -Path $dir -ItemType Directory | Out-Null
            { Read-EncryptedFile -Path $dir -Key 'k' } | Should -Throw
        }

        It -Name 'rejects supplying both -Key and -KeyBytes (parameter set conflict)' -Test {
            $src = Join-Path -Path $TestDrive -ChildPath 'both.enc'
            New-EncryptedFixture -Path $src -Content 'data' -Key 'k'
            { Read-EncryptedFile -Path $src -Key 'k' -KeyBytes ([byte[]] @(1, 2, 3)) } |
                Should -Throw
        }
    }

    Context -Name 'happy path' -Fixture {
        It -Name 'decrypts a file with the correct string key' -Test {
            $src = Join-Path -Path $TestDrive -ChildPath 'hp1.enc'
            New-EncryptedFixture -Path $src -Content 'plaintext' -Key 'secret'
            (Read-EncryptedFile -Path $src -Key 'secret') | Should -Be 'plaintext'
        }

        It -Name 'decrypts a file with a byte-array key' -Test {
            $src = Join-Path -Path $TestDrive -ChildPath 'hp2.enc'
            $keyBytes = [System.Byte[]] '0123456789ABCDEF0123456789ABCDEF'.ToCharArray()
            Write-EncryptedFile -Content 'byte-decrypt' -Path $src -KeyBytes $keyBytes | Out-Null
            (Read-EncryptedFile -Path $src -KeyBytes $keyBytes) | Should -Be 'byte-decrypt'
        }

        It -Name 'preserves multi-line content across the round-trip' -Test {
            $src = Join-Path -Path $TestDrive -ChildPath 'hp3.enc'
            'a', 'b', 'c' | Write-EncryptedFile -Path $src -Key 'k' | Out-Null
            (Read-EncryptedFile -Path $src -Key 'k') |
                Should -Be ('a{0}b{0}c' -f [Environment]::NewLine)
        }
    }

    Context -Name 'wrong-key behavior' -Fixture {
        # Decrypting with the wrong key may either throw (CryptographicException padding error)
        # or silently return garbage bytes depending on whether the random plaintext happens to
        # produce valid PKCS7 padding. Both outcomes are acceptable; what matters is that the
        # original plaintext is NOT recovered.
        It -Name 'never returns the original plaintext when given a different key' -Test {
            $src = Join-Path -Path $TestDrive -ChildPath 'wrong-key.enc'
            New-EncryptedFixture -Path $src -Content 'do-not-leak' -Key 'right'

            $result = $null
            try { $result = Read-EncryptedFile -Path $src -Key 'wrong' } catch { $result = $null }
            $result | Should -Not -Be 'do-not-leak'
        }
    }
}
