BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Install-GitHubModule' -Fixture {

    BeforeAll {
        $script:ReleaseInfo = [PSCustomObject] @{
            tag_name = 'v1.2.3'
            assets   = @(
                [PSCustomObject] @{ browser_download_url = 'https://github.com/octocat/MyModule/releases/download/v1.2.3/MyModule.zip' }
            )
        }
    }

    Context -Name 'already-installed branch' -Fixture {
        BeforeAll {
            Mock -CommandName Get-Module -ModuleName $env:BHProjectName -MockWith {
                [PSCustomObject] @{ Name = 'MyModule'; Version = [System.Version] '1.0.0' }
            }
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith { $script:ReleaseInfo }
            Mock -CommandName Write-Warning -ModuleName $env:BHProjectName
        }

        It -Name 'warns and does not query the GitHub releases API' -Test {
            Install-GitHubModule -Account 'octocat' -Repository 'MyModule' -WhatIf | Out-Null
            Should -Invoke -CommandName Write-Warning -ModuleName $env:BHProjectName
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly
        }
    }

    Context -Name 'not-installed branch' -Fixture {
        BeforeAll {
            Mock -CommandName Get-Module -ModuleName $env:BHProjectName -MockWith { $null }
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith { $script:ReleaseInfo }
            Mock -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName
        }

        It -Name 'queries the GitHub releases/latest endpoint with Account/Repository' -Test {
            Install-GitHubModule -Account 'octocat' -Repository 'MyModule' -WhatIf | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Uri -eq 'https://api.github.com/repos/octocat/MyModule/releases/latest'
            }
        }

        It -Name 'does not call Invoke-WebRequest under -WhatIf' -Test {
            Install-GitHubModule -Account 'octocat' -Repository 'MyModule' -WhatIf | Out-Null
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName -Times 0 -Exactly
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an empty -Account' -Test {
            { Install-GitHubModule -Account '' -Repository 'MyModule' } | Should -Throw
        }

        It -Name 'rejects an empty -Repository' -Test {
            { Install-GitHubModule -Account 'octocat' -Repository '' } | Should -Throw
        }

        It -Name 'rejects a -Scope value outside the validated set' -Test {
            { Install-GitHubModule -Account 'octocat' -Repository 'MyModule' -Scope 'Bogus' } | Should -Throw
        }
    }
}
