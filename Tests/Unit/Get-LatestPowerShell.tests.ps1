BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-LatestPowerShell' -Fixture {

    BeforeAll {
        $script:LatestRelease = [PSCustomObject] @{ tag_name = 'v7.5.1' }

        Mock -CommandName Invoke-RestMethod -MockWith { $script:LatestRelease } -ModuleName $env:BHProjectName
        Mock -CommandName Invoke-WebRequest -MockWith {} -ModuleName $env:BHProjectName

        New-Item -Path 'TestDrive:/pwsh-out' -ItemType Directory -Force | Out-Null
    }

    Context -Name 'version resolution' -Fixture {
        It -Name 'calls the GitHub releases/latest API when -Version is omitted' -Test {
            Get-LatestPowerShell -Architecture WindowsAmd64 -OutputDirectory 'TestDrive:/pwsh-out'
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest' }
        }

        It -Name 'does NOT call the releases/latest API when -Version is supplied' -Test {
            Get-LatestPowerShell -Architecture WindowsAmd64 -OutputDirectory 'TestDrive:/pwsh-out' -Version '7.4.0'
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly
        }

        It -Name 'strips the leading v from the tag name when building the URL' -Test {
            Get-LatestPowerShell -Architecture WindowsAmd64 -OutputDirectory 'TestDrive:/pwsh-out'
            # tag_name is "v7.5.1"; the URL must contain "7.5.1" not "v7.5.1".
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -like '*/v7.5.1/*' -and $Uri -notlike '*/vv7.5.1/*' }
        }
    }

    Context -Name 'per-architecture URL' -Fixture {
        It -Name 'uses the Windows MSI URL for WindowsAmd64' -Test {
            Get-LatestPowerShell -Architecture WindowsAmd64 -OutputDirectory 'TestDrive:/pwsh-out' -Version '7.4.0'
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -like '*PowerShell-7.4.0-win-x64.msi' }
        }

        It -Name 'uses the .deb URL for LinuxAmd64' -Test {
            Get-LatestPowerShell -Architecture LinuxAmd64 -OutputDirectory 'TestDrive:/pwsh-out' -Version '7.4.0'
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -like '*powershell_7.4.0-1.deb_amd64.deb' }
        }

        It -Name 'uses the .tar.gz URL for LinuxArm64' -Test {
            Get-LatestPowerShell -Architecture LinuxArm64 -OutputDirectory 'TestDrive:/pwsh-out' -Version '7.4.0'
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -like '*powershell-7.4.0-linux-arm64.tar.gz' }
        }
    }

    Context -Name 'OutputDirectory plumbing' -Fixture {
        It -Name 'writes -OutFile under the supplied OutputDirectory' -Test {
            Get-LatestPowerShell -Architecture WindowsAmd64 -OutputDirectory 'TestDrive:/pwsh-out' -Version '7.4.0'
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $OutFile -like '*pwsh-out*PowerShell-7.4.0-win-x64.msi' }
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an unknown -Architecture' -Test {
            { Get-LatestPowerShell -Architecture 'MacArm64' -OutputDirectory 'TestDrive:/pwsh-out' } |
                Should -Throw
        }

        It -Name 'rejects a malformed -Version' -Test {
            { Get-LatestPowerShell -Architecture WindowsAmd64 -OutputDirectory 'TestDrive:/pwsh-out' -Version '7.4' } |
                Should -Throw
        }
    }
}
