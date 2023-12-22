function Update-GitHubModule {
    <#
    .SYNOPSIS
        Updates a module hosted in GitHub
    .DESCRIPTION
        Downloads, extracts, and unblocks module files from GitHub release
    .PARAMETER Name
        Mdoule name
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Update-GitHubModule -Name 'SecurityTools'
        Checks published version is newer than installed, downloads, extracts, and unblocks SecurityTools module package from GitHub
    .NOTES
        Name:     Update-GitHubModule
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-12-22
        - 0.1.0 - Initial version
        Comments:
        - This function assumes that currently installed module has the project URI property set correctly
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Module name')]
        [ValidateScript({ $null -NE (Get-Module -ListAvailable -Name $_) })]
        [System.String] $Name
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET PLATFORM TEMP
        $tempDir = if ($IsWindows) { $env:TEMP } else { '/tmp/' }
    }
    Process {
        # GET MODULE
        $module = Get-Module -ListAvailable -Name $Name

        # SET URI
        Write-Verbose -Message ('Project URI: "{0}"' -f $module.ProjectUri.AbsoluteUri)
        $uri = 'https://api.{0}/repos{1}/releases/latest' -f $module.ProjectUri.Host, $module.ProjectUri.LocalPath
        Write-Verbose -Message ('Release URI: "{0}"' -f $uri)

        # GET LATEST RELEASE INFORMATION
        $releaseInfo = Invoke-RestMethod -Uri $uri

        # VALIDATE VERSIONS
        if ($module.Version -GE ([System.Version] $releaseInfo.tag_name.TrimStart('v'))) {
            # OUTPUT RESPONSE
            Write-Verbose -Message ('Installed module version: [{0}]' -f $module.Version.ToString())
            Write-Verbose -Message ('Current release package version: [{0}]' -f $releaseInfo.tag_name.TrimStart('v'))
            Write-Output -InputObject ('Installed module version is same or greater than current release')
        }
        else {
            # SET TEMPORARY PATH
            $tempPath = Join-Path -Path $tempDir -ChildPath ('{0}.zip' -f $Repository)

            # DOWNLOAD MODULE
            Invoke-WebRequest -Uri $releaseInfo.assets_url -OutFile $tempPath

            # DECOMPRESS MODULE TO MODULE PATH
            Expand-Archive -Path $tempPath -DestinationPath (Split-Path -Path $module.ModuleBase) -Force

            # UNBLOCK MODULE
            Get-ChildItem -Path $module.ModuleBase -Recurse | Unblock-File
        }
    }
    End {
        # REMOVE TEMPORARY ZIP FILE
        if ($tempPath -and (Test-Path -Path $tempPath)) {
            Remove-Item -Path $tempPath -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}
