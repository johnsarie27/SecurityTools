# New Function Template

Use this template as a starting point when adding a new function to the
`SecurityTools` module. Follow these rules:

- Place the file under `Public/` (exported) or `Private/` (internal use only).
- Name the file `Verb-Noun.ps1`, matching the function name exactly.
- Use only [approved verbs](https://learn.microsoft.com/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands).
- Always include comment-based help (`.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`,
  `.INPUTS`, `.OUTPUTS`, `.EXAMPLE`, `.NOTES`).
- Add a Pester test under `Tests/Unit/Verb-Noun.tests.ps1`.
- If the function is **exported**, add its name to `FunctionsToExport` in
  [SecurityTools.psd1](../SecurityTools.psd1).
- For Windows-only functions, add a runtime platform guard in the `Begin` block.
- For functions that depend on an optional/external module, call
  `Import-Module -Name <Name> -ErrorAction Stop` in the `Begin` block (not a
  script-level `#Requires` for optional dependencies).
- Run `./Build/build.ps1 -TaskList Analyze` and `./Build/build.ps1 -TaskList Test`
  locally before opening the PR.

## Template

```powershell
function Verb-Noun {
    <#
    .SYNOPSIS
        One-line summary of what the function does
    .DESCRIPTION
        Longer description of behavior, side effects, and intended use
    .PARAMETER Foo
        Description of the Foo parameter
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Verb-Noun -Foo 'bar'
        Explanation of what the example does
    .NOTES
        Name:     Verb-Noun
        Author:   <Your Name>
        Version:  0.1.0 | Last Edit: <YYYY-MM-DD>
        Comments: (see commit history)
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Description of Foo')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Foo
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.MyCommand)"

        # Platform guard (only for Windows-only functions)
        # if (-not $IsWindows) { Write-Error -Message 'Verb-Noun requires Windows.' -ErrorAction Stop }

        # Optional module import (only for functions with external dependencies)
        # Import-Module -Name SomeModule -ErrorAction Stop
    }
    Process {
        # Function logic here
    }
}
```

## Test Skeleton

```powershell
BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Verb-Noun' -Fixture {
    Context -Name 'normal usage' -Fixture {
        It -Name 'should not throw for valid input' -Test {
            { Verb-Noun -Foo 'bar' } | Should -Not -Throw
        }
    }
}
```
