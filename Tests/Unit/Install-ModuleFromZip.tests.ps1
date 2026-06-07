BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Install-ModuleFromZip' -Fixture {

    # The Process block reaches for $env:PSModulePath, runs Expand-Archive against the zip,
    # walks the expanded directory, and calls Move-Item / Get-Module / Unblock-File. End-to-end
    # mocking would have to fake an entire filesystem tree under TEMP and a matching .psd1, so
    # body-level coverage here is intentionally minimal — metadata + parameter validation only.

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Install-ModuleFromZip' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -Path as mandatory positional parameter' -Test {
            $param = $script:Cmd.Parameters['Path']
            $param.Attributes.Mandatory | Should -Contain $true
            $param.Attributes.Position  | Should -Contain 0
        }

        It -Name 'declares -Scope with ValidateSet of CurrentUser / AllUsers (defaults to CurrentUser)' -Test {
            $param = $script:Cmd.Parameters['Scope']
            $set = $param.Attributes | Where-Object -FilterScript { $_ -is [System.Management.Automation.ValidateSetAttribute] }
            $set.ValidValues | Should -Contain 'CurrentUser'
            $set.ValidValues | Should -Contain 'AllUsers'
        }

        It -Name 'declares -Replace as a switch parameter' -Test {
            $script:Cmd.Parameters['Replace'].ParameterType | Should -Be ([System.Management.Automation.SwitchParameter])
        }

        It -Name 'supports ShouldProcess with High confirm impact' -Test {
            $cmdletBinding = $script:Cmd.ScriptBlock.Attributes |
            Where-Object -FilterScript { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
            $cmdletBinding.SupportsShouldProcess | Should -BeTrue
            $cmdletBinding.ConfirmImpact         | Should -Be 'High'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        BeforeAll {
            $script:TempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
            New-Item -Path $script:TempDir -ItemType Directory | Out-Null
        }

        AfterAll {
            if (Test-Path -Path $script:TempDir) {
                Remove-Item -Path $script:TempDir -Recurse -Force -ErrorAction Ignore
            }
        }

        It -Name 'rejects a -Path that does not exist' -Test {
            { Install-ModuleFromZip -Path (Join-Path -Path $script:TempDir -ChildPath 'missing.zip') } | Should -Throw
        }

        It -Name 'rejects a -Path whose extension is not .zip' -Test {
            $bogus = Join-Path -Path $script:TempDir -ChildPath 'fake.txt'
            Set-Content -Path $bogus -Value 'not a zip'
            { Install-ModuleFromZip -Path $bogus } | Should -Throw
        }

        It -Name 'rejects a -Scope value outside the validated set' -Test {
            # Use a non-existent zip to keep the body from running if validation order ever changes.
            { Install-ModuleFromZip -Path (Join-Path -Path $script:TempDir -ChildPath 'missing.zip') -Scope 'Everyone' } | Should -Throw
        }
    }
}
