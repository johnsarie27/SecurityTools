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
        Version:  0.1.0 | Last Edit: 2024-02-02
        - 0.1.0 - Initial version
        Comments:
        - This function assumes that currently installed module has the project URI property set correctly
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Module name')]
        [ValidateScript({ $null -NE (Get-Module -ListAvailable -Name $_) })]
        [System.String] $Name
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET PLATFORM TEMP
        $tempDir = if ($IsWindows) { $env:TEMP } elseif ($IsMacOS) { $Env:TMPDIR } else { '/tmp/' }
    }
    Process {
        # GET MODULE: MODULE PRE-EXISTENCE VALIDATED IN PARAMETER ARGUMENT
        $module = Get-Module -ListAvailable -Name $Name

        # VALIDATE PROJECT URI PROPERTY
        if ($module.ProjectUri.AbsoluteUri) {
            # SET URI
            Write-Verbose -Message ('Project URI: "{0}"' -f $module.ProjectUri.AbsoluteUri)
            $uri = 'https://api.{0}/repos{1}/releases/latest' -f $module.ProjectUri.Host, $module.ProjectUri.LocalPath
            Write-Verbose -Message ('Release URI: "{0}"' -f $uri)
        }
        else {
            throw ('Module "{0}" does not contain property "ProjectUri"!' -f $module.Name)
        }

        # GET LATEST RELEASE INFORMATION
        Write-Verbose -Message 'Getting repo release information...'
        $releaseInfo = Invoke-RestMethod -Uri $uri

        # SET LATEST RELEASE VERSION
        $releaseVer = [System.Version] $releaseInfo.tag_name.TrimStart('v')

        # VALIDATE VERSIONS
        if ($module.Version -GE $releaseVer) {
            # OUTPUT RESPONSE
            Write-Verbose -Message ('Installed module version: [{0}]' -f $module.Version.ToString())
            Write-Verbose -Message ('Current release package version: [{0}]' -f $releaseInfo.tag_name.TrimStart('v'))
            Write-Output -InputObject ('Installed module version is same or greater than current release')
        }
        else {
            # WRITE OUTPUT
            Write-Output -InputObject ('Installed version "{0}" will be replaced by current version "{1}"' -f $module.Version.ToString(), $releaseVer.ToString())

            # SHOULD PROCESS
            if ($PSCmdlet.ShouldProcess($module.Name, "Overwrite module")) {
                # REMOVE EXISTING MODULE
                #Remove-Item -Path $module.ModuleBase -Recurse -Force -Confirm:$false

                # SET TEMPORARY PATH
                $tempPath = Join-Path -Path $tempDir -ChildPath ('{0}.zip' -f $module.Name)

                # DOWNLOAD MODULE
                Write-Verbose -Message 'Downloading module package...'
                Invoke-WebRequest -Uri $releaseInfo.assets[0].browser_download_url -OutFile $tempPath

                # DECOMPRESS MODULE TO MODULE PATH. "-Force" OVERWRITES EXISTING DATA
                Write-Verbose -Message 'Expanding package archive...'
                Expand-Archive -Path $tempPath -DestinationPath (Split-Path -Path $module.ModuleBase) -Force

                # UNBLOCK MODULE
                if ($IsWindows) {
                    Write-Verbose -Message 'Unblocking files...'
                    Get-ChildItem -Path $module.ModuleBase -Recurse | Unblock-File
                }

                # VALIDATE UPDATE
                if ((Get-Module -ListAvailable -Name $Name).Version -EQ $releaseVer) {
                    Write-Output -InputObject ('Module successfully updated to version "{0}"' -f $releaseVer)
                }
            }
        }
    }
    End {
        # REMOVE TEMPORARY ZIP FILE
        if ($tempPath -and (Test-Path -Path $tempPath)) {
            Write-Verbose -Message 'Cleanup: removing package archive...'
            Remove-Item -Path $tempPath -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}
