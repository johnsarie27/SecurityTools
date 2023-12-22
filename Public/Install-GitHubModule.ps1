function Install-GitHubModule {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER Account
        GitHub account or organization name
    .PARAMETER Repository
        Repository name
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .EXAMPLE
        PS C:\> Install-GitHubModule -Account 'johnsarie27' -Repository 'SecurityTools'
        Explanation of what the example does
    .NOTES
        Name:     Install-GitHubModule
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-12-22
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'GitHub account or organization name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Account,

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'Repository name')]
        [Alias('Repo')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Repository
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET PATH HASHTABLE
        $pathHash = @{
            PS5Global = "$env:ProgramFiles\WindowsPowerShell\Modules"
            PS5User   = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"
            PS7Global = "$env:ProgramFiles\PowerShell\Modules"
            PS7User   = "$env:USERPROFILE\Documents\PowerShell\Modules"
        }
    }
    Process {
        # GET LATEST RELEASE INFORMATION
        $request = Invoke-RestMethod -Uri ('https://api.github.com/repos/{0}/{1}/releases/latest' -f $Account, $Repository)

        # GET INSTALLED MODULE
        $insMod = Get-Module -ListAvailable -Name $Repository -ErrorAction SilentlyContinue

        $insMod.ProjectUri

        # VALIDATE VERSIONS
        if ($insMod.Version -GE ([System.Version] $request.tag_name.TrimStart('v'))) {
            # OUTPUT RESPONSE
            Write-Output -InputObject ('Installed module version is same or greater than current release')
        }
        else {
            # SET PATHS
            $tempPath = Join-Path -Path $env:TEMP -ChildPath ('{0}.zip' -f $Repository)
            $modPath = Split-Path -Path $insMod.ModuleBase

            # DOWNLOAD MODULE
            Invoke-WebRequest -Uri $request.assets_url -OutFile $tempPath

            # DECOMPRESS MODULE TO MODULE PATH
            Expand-Archive -Force -Path ($Repository + '.zip') -DestinationPath $modPath

            # UNBLOCK MODULE
            Get-ChildItem -Path (Join-Path -Path $modPath -ChildPath $Repository) -Recurse | Unblock-File
        }

    }
    End {

    }
}
