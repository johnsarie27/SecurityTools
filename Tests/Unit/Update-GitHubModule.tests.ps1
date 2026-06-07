BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Update-GitHubModule' -Fixture {

    BeforeAll {
        # ValidateScript on -Name calls Get-Module -ListAvailable in the caller scope, so we use the
        # currently imported module ($env:BHProjectName) as the name under test.
        $script:ModuleName = $env:BHProjectName
        $script:InstalledVer = (Get-Module -ListAvailable -Name $script:ModuleName |
            Sort-Object Version -Descending)[0].Version

        # Mocks for the destructive download/expand path. Update-GitHubModule calls Invoke-WebRequest
        # outside of ShouldProcess, so -WhatIf will not suppress it. Mock anything that touches disk.
        Mock -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName
        Mock -CommandName Expand-Archive   -ModuleName $env:BHProjectName
        Mock -CommandName Rename-Item      -ModuleName $env:BHProjectName
        Mock -CommandName Remove-Item      -ModuleName $env:BHProjectName
        Mock -CommandName Unblock-File     -ModuleName $env:BHProjectName
        Mock -CommandName Get-ChildItem    -ModuleName $env:BHProjectName -MockWith { @() }
    }

    Context -Name 'release URL construction' -Fixture {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith {
                [PSCustomObject] @{
                    tag_name = 'v{0}' -f $script:InstalledVer
                    assets   = @([PSCustomObject] @{ browser_download_url = 'https://example.com/pkg.zip' })
                }
            }
        }

        It -Name 'derives the releases/latest URL from the module ProjectUri' -Test {
            Update-GitHubModule -Name $script:ModuleName -WhatIf | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -like 'https://api.github.com/repos/*/releases/latest' }
        }
    }

    Context -Name 'version comparison' -Fixture {
        It -Name 'short-circuits when installed version equals release version' -Test {
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith {
                [PSCustomObject] @{
                    tag_name = 'v{0}' -f $script:InstalledVer
                    assets   = @([PSCustomObject] @{ browser_download_url = 'https://example.com/pkg.zip' })
                }
            }

            $result = Update-GitHubModule -Name $script:ModuleName -WhatIf
            $result | Should -Be 'Installed module version is same or greater than current release'
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName -Times 0 -Exactly
        }

        It -Name 'downloads the asset when release version is newer than installed' -Test {
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith {
                $newer = [System.Version]::new(
                    $script:InstalledVer.Major + 1, 0, 0, 0)
                [PSCustomObject] @{
                    tag_name = 'v{0}' -f $newer
                    assets   = @([PSCustomObject] @{ browser_download_url = 'https://example.com/pkg.zip' })
                }
            }

            Update-GitHubModule -Name $script:ModuleName -WhatIf | Out-Null
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'https://example.com/pkg.zip' }
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a -Name that is not an installed module' -Test {
            { Update-GitHubModule -Name 'NonExistentModule_xyz_999' } | Should -Throw
        }
    }
}
