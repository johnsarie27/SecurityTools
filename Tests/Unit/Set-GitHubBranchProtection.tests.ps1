BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Set-GitHubBranchProtection' -Fixture {

    Context -Name 'parameter validation' -Fixture {
        It -Name 'declares Owner as mandatory' -Test {
            (Get-Command -Name Set-GitHubBranchProtection).Parameters['Owner'].Attributes.Mandatory |
                Should -Contain $true
        }

        It -Name 'declares Repository as mandatory and accepts pipeline input' -Test {
            $param = (Get-Command -Name Set-GitHubBranchProtection).Parameters['Repository']
            $param.Attributes.Mandatory         | Should -Contain $true
            $param.Attributes.ValueFromPipeline | Should -Contain $true
        }

        It -Name 'supports ShouldProcess (-WhatIf is available)' -Test {
            (Get-Command -Name Set-GitHubBranchProtection).Parameters.ContainsKey('WhatIf') |
                Should -BeTrue
        }

        It -Name 'rejects an empty Repository value' -Test {
            { Set-GitHubBranchProtection -Owner 'octocat' -Repository '' -WhatIf } | Should -Throw
        }
    }

    Context -Name 'pre-flight: gh CLI missing' -Fixture {
        BeforeAll {
            Mock -CommandName Get-Command `
                -ParameterFilter { $Name -eq 'gh' } `
                -MockWith { } `
                -ModuleName $env:BHProjectName
        }

        It -Name 'errors when the gh CLI is not on PATH' -Test {
            { Set-GitHubBranchProtection -Owner 'octocat' -Repository 'demo' -WhatIf -ErrorAction Stop } |
                Should -Throw -ExpectedMessage '*gh CLI not found*'
        }
    }

    Context -Name 'execution paths' -Fixture {

        BeforeAll {
            $script:MatchingExistingJson = @'
{
    "required_signatures": { "enabled": true },
    "enforce_admins": { "enabled": true },
    "required_linear_history": { "enabled": true },
    "allow_force_pushes": { "enabled": false },
    "allow_deletions": { "enabled": false },
    "required_conversation_resolution": { "enabled": true },
    "required_status_checks": { "strict": true, "contexts": [] },
    "required_pull_request_reviews": {
        "dismiss_stale_reviews": false,
        "require_code_owner_reviews": false,
        "required_approving_review_count": 0,
        "require_last_push_approval": false
    }
}
'@

            $script:ConflictingExistingJson = @'
{
    "required_signatures": { "enabled": false },
    "enforce_admins": { "enabled": true },
    "required_linear_history": { "enabled": false },
    "allow_force_pushes": { "enabled": true },
    "allow_deletions": { "enabled": false },
    "required_conversation_resolution": { "enabled": true },
    "required_status_checks": { "strict": true, "contexts": [] },
    "required_pull_request_reviews": {
        "dismiss_stale_reviews": false,
        "require_code_owner_reviews": false,
        "required_approving_review_count": 0,
        "require_last_push_approval": false
    }
}
'@
        }

        BeforeEach {
            $script:ApiGetExitCode = 0
            $script:ApiGetResponse = $script:MatchingExistingJson

            Mock -CommandName gh -ModuleName $env:BHProjectName -MockWith {
                if ($args -contains 'auth') {
                    $global:LASTEXITCODE = 0
                    return 'Logged in to github.com'
                }
                if ($args -contains 'repo' -and $args -contains 'view') {
                    $global:LASTEXITCODE = 0
                    return '{"defaultBranchRef":{"name":"main"}}'
                }
                if ($args -contains 'api') {
                    if ($args -contains '-X' -and $args -contains 'PUT') {
                        $global:LASTEXITCODE = 0
                        return '{"url":"applied"}'
                    }
                    $global:LASTEXITCODE = $script:ApiGetExitCode
                    return $script:ApiGetResponse
                }
                $global:LASTEXITCODE = 0
                return ''
            }
        }

        It -Name 'returns AlreadyProtected and skips PUT when existing rule matches desired policy' -Test {
            $result = Set-GitHubBranchProtection -Owner 'octocat' -Repository 'demo' -Confirm:$false

            $result.Result     | Should -Be 'AlreadyProtected'
            $result.Repository | Should -Be 'octocat/demo'
            $result.Branch     | Should -Be 'main'

            Should -Invoke -CommandName gh -ModuleName $env:BHProjectName `
                -ParameterFilter { $args -contains '-X' -and $args -contains 'PUT' } -Times 0 -Exactly
        }

        It -Name 'returns Conflict and skips PUT when existing rule differs and -Force is absent' -Test {
            $script:ApiGetResponse = $script:ConflictingExistingJson

            $result = Set-GitHubBranchProtection -Owner 'octocat' -Repository 'demo' -Confirm:$false `
                -WarningAction SilentlyContinue

            $result.Result  | Should -Be 'Conflict'
            $result.Message | Should -BeLike '*Existing rule differs*'

            Should -Invoke -CommandName gh -ModuleName $env:BHProjectName `
                -ParameterFilter { $args -contains '-X' -and $args -contains 'PUT' } -Times 0 -Exactly
        }

        It -Name 'returns Protected and issues PUT when existing rule differs and -Force is set' -Test {
            $script:ApiGetResponse = $script:ConflictingExistingJson

            $result = Set-GitHubBranchProtection -Owner 'octocat' -Repository 'demo' -Force -Confirm:$false

            $result.Result | Should -Be 'Protected'

            Should -Invoke -CommandName gh -ModuleName $env:BHProjectName `
                -ParameterFilter { $args -contains '-X' -and $args -contains 'PUT' } -Times 1 -Exactly
        }

        It -Name 'returns Protected and issues PUT when no existing rule is found' -Test {
            $script:ApiGetExitCode = 1
            $script:ApiGetResponse = 'HTTP 404: Branch not protected'

            $result = Set-GitHubBranchProtection -Owner 'octocat' -Repository 'demo' -Confirm:$false

            $result.Result | Should -Be 'Protected'

            Should -Invoke -CommandName gh -ModuleName $env:BHProjectName `
                -ParameterFilter { $args -contains '-X' -and $args -contains 'PUT' } -Times 1 -Exactly
        }

        It -Name '-WhatIf returns Skipped and issues no PUT' -Test {
            $script:ApiGetExitCode = 1
            $script:ApiGetResponse = 'HTTP 404: Branch not protected'

            $result = Set-GitHubBranchProtection -Owner 'octocat' -Repository 'demo' -WhatIf

            $result.Result | Should -Be 'Skipped'

            Should -Invoke -CommandName gh -ModuleName $env:BHProjectName `
                -ParameterFilter { $args -contains '-X' -and $args -contains 'PUT' } -Times 0 -Exactly
        }

        It -Name 'accepts multiple repositories via the pipeline' -Test {
            $results = 'demo-a', 'demo-b' | Set-GitHubBranchProtection -Owner 'octocat' -Confirm:$false

            $results | Should -HaveCount 2
            $results.Repository | Should -Be @('octocat/demo-a', 'octocat/demo-b')
        }
    }
}
