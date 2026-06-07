BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Update-GitHubModule' -Fixture {

    # The function's -Name parameter has a [ValidateScript({ Get-Module -ListAvailable -Name $_ })]
    # guard that fires in caller scope before the function body runs. On CI the staged module path
    # is not on $env:PSModulePath, so Get-Module -ListAvailable returns $null and the parameter
    # validation rejects every call — including those that mock the body's behavior. We exercise
    # only the command's published metadata here.

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Update-GitHubModule' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -Name as mandatory positional parameter' -Test {
            $param = $script:Cmd.Parameters['Name']
            $param.Attributes.Mandatory | Should -Contain $true
            $param.Attributes.Position  | Should -Contain 0
        }

        It -Name 'declares -Replace as a switch parameter' -Test {
            $param = $script:Cmd.Parameters['Replace']
            $param.ParameterType | Should -Be ([System.Management.Automation.SwitchParameter])
        }

        It -Name 'supports ShouldProcess with High confirm impact' -Test {
            $cmdletBinding = $script:Cmd.ScriptBlock.Attributes |
                Where-Object -FilterScript { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
            $cmdletBinding.SupportsShouldProcess | Should -BeTrue
            $cmdletBinding.ConfirmImpact         | Should -Be 'High'
        }

        It -Name 'rejects a -Name that is not an installed module' -Test {
            { Update-GitHubModule -Name 'NonExistentModule_xyz_999' } | Should -Throw
        }
    }
}
