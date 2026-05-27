BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Set-GitHubBranchProtection' -Fixture {

    Context -Name 'parameter validation' -Fixture {
        It -Name 'has a mandatory Owner parameter' -Test {
            (Get-Command -Name Set-GitHubBranchProtection).Parameters['Owner'].Attributes.Mandatory |
                Should -Contain $true
        }

        It -Name 'has a mandatory Repository parameter that accepts pipeline input' -Test {
            $param = (Get-Command -Name Set-GitHubBranchProtection).Parameters['Repository']
            $param.Attributes.Mandatory | Should -Contain $true
            $param.Attributes.ValueFromPipeline | Should -Contain $true
        }

        It -Name 'rejects ApprovalCount values outside 0-6' -Test {
            { Set-GitHubBranchProtection -Owner 'octocat' -Repository 'demo' -ApprovalCount 7 -WhatIf } |
                Should -Throw
        }

        It -Name 'supports ShouldProcess' -Test {
            (Get-Command -Name Set-GitHubBranchProtection).Parameters.ContainsKey('WhatIf') |
                Should -BeTrue
        }
    }
}
