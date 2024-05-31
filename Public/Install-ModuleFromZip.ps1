function Install-ModuleFromZip {
    <#
    .SYNOPSIS
        Install module from GitHub download
    .DESCRIPTION
        Install module from GitHub download
    .PARAMETER Path
        Path to zip file
    .PARAMETER Scope
        Module scope
    .PARAMETER Replace
        Replace current module version
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Install-ModuleFromZip -Path .\SecurityTools.zip
        Extracts contents of zip and copies to Windows module directory then removes zip.
    .NOTES
        Name:     Install-ModuleFromZip
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2024-01-23
        - 0.1.1 - (2024-01-23) Renamed function from Install-ModuleFromPackage, cleanup
        - 0.1.0 - (2019-03-13) Initial version
        Comments: <Comment(s)>
        The zip should contain the module folder with the appropriate items inside.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Path to module archive file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.zip" })]
        [System.String] $Path,

        [Parameter(Mandatory = $false, Position = 1, HelpMessage = 'Module home folder')]
        [ValidateSet('AllUsers', 'CurrentUser')]
        [System.String] $Scope = 'CurrentUser',

        [Parameter(Mandatory = $false, position = 2, HelpMessage = 'Replace current version(s)')]
        [System.Management.Automation.SwitchParameter] $Replace
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET PLATFORM VARIABLES
        if ($IsWindows) { $tempDir = $env:TEMP; $splitChar = ';' }
        if ($IsLinux) { $tempDir = '/tmp/'; $splitChar = ':' }
        if ($IsMacOS) { $tempDir = $Env:TMPDIR; $splitChar = ':' }

        # SET DEFAULT MODULE HOME PATH
        $moduleHome = switch ($Scope) {
            'CurrentUser' { ($env:PSModulePath.Split("$splitChar"))[0] }
            'AllUsers' { ($env:PSModulePath.Split("$splitChar"))[1] }
        }

        Write-Verbose -Message ('Module home: "{0}"' -f $moduleHome)

        $tempPath = Join-Path -Path $tempDir -ChildPath (Split-Path $Path -LeafBase)
    }
    Process {

        # INSPECT AND PREPARE INPUT ARCHIVE FILE
        try {
            # DECOMPRESS ZIP FILE TO TEMP PATH
            Expand-Archive -Path $Path -DestinationPath $tempPath

            # GET MODULE INFO
            $psDataFile = Get-ChildItem $tempPath -Recurse | Where-Object Name -Like '*.psd1'
            $psData = Import-PowerShellDataFile -Path $psDataFile.FullName
            $moduleName = Split-Path $psDataFile -LeafBase
            $moduleVersion = [System.Version] $psData.ModuleVersion

            # RENAME MODULE FOLDER TO VERSION NUMBER
            Rename-Item -Path (Get-ChildItem $tempPath).FullName -NewName $moduleVersion.ToString()
            $moduleFolder = Get-ChildItem $tempPath

            # SET MODULE PATH
            $modulePath = Join-Path -Path $moduleHome -ChildPath $moduleName

            Write-Verbose -Message ('Module name: "{0}"' -f $moduleName)
            Write-Verbose -Message ('Version: "{0}"' -f $moduleVersion.ToString())
        }
        catch {
            Write-Output 'Error while inspecting input module archive file.'
            Write-Output $_
        }

        # IS MODULE INSTALLED
        $getModule = Get-Module -ListAvailable -Name $moduleName

        if ($getModule) {
            # THE MODULE IS ALREADY INSTALLED
            Write-Verbose -Message ('Module "{0}" identified. Installed versions:' -f $moduleName)

            # LIST VERSIONS
            foreach ($m in $getModule) {
                Write-Verbose -Message $m.Version.ToString()
            }

            # CHECK FOR INPUT VERSION
            if ($getModule.Version -contains $moduleVersion) {
                # THIS VERSION IS ALREADY INSTALLED
                Write-Warning -Message ('"{0}" version "{1}" is already installed.' -f $moduleName, $moduleVersion.ToString())
            }
            elseif ($getModule.Version -notcontains $moduleVersion) {
                # THIS VERSION IS NOT INSTALLED
                Write-Verbose -Message ('Version "{0}" is not installed.' -f $moduleVersion.ToString())

                # IF REPLACE SWITCH
                if ($Replace) {
                    # ALL OTHER VERSIONS WILL BE REMOVED
                    Write-Warning -Message ('"-Replace" switch specified. Version "{0}" will be installed and all other versions removed.' -f $moduleVersion.ToString())

                    # SHOULD PROCESS
                    if ($PSCmdlet.ShouldProcess($Path, "Install module from local package, remove other versions, and trust module")) {

                        # REMOVE OTHER VERSIONS
                        Write-Verbose -Message 'Removing other versions...'
                        foreach ($v in (Get-ChildItem -Path $modulePath)) {
                            Remove-Item -Path $v.FullName -Recurse
                        }

                        # INSTALL MODULE IN MODULE PATH
                        Write-Verbose -Message 'Installing module...'
                        Move-Item -Path $moduleFolder.FullName -Destination $modulePath

                        # UNBLOCK MODULE
                        if ($IsWindows -or $IsMacOS) {
                            Write-Verbose -Message 'Unblocking files...'
                            Get-ChildItem -Path $modulePath -Recurse | Unblock-File
                        }
                    }

                    # VALIDATE MODULE
                    if (Get-Module -Name $moduleName) {
                        Write-Output -InputObject 'Module installed successfully'
                    }
                }
                else {
                    # INSTALL VERSION
                    Write-Output ('Version "{0}" will be installed. Other versions will not be affected.')

                    # SHOULD PROCESS
                    if ($PSCmdlet.ShouldProcess($Path, "Install module from local package and trust module")) {

                        # INSTALL MODULE IN MODULE PATH
                        Write-Verbose -Message 'Installing module...'
                        Move-Item -Path $moduleFolder.FullName -Destination $modulePath

                        # UNBLOCK MODULE
                        if ($IsWindows -or $IsMacOS) {
                            Write-Verbose -Message 'Unblocking files...'
                            Get-ChildItem -Path $modulePath -Recurse | Unblock-File
                        }
                    }

                    # VALIDATE MODULE
                    if (Get-Module -Name $moduleName) {
                        Write-Output -InputObject 'Module installed successfully'
                    }
                }
            }
        }
        else {
            # NO VERSION OF THE MODULE IS INSTALLED
            Write-Output ('Module "{0}" is not installed.' -f $moduleName)

            # SHOULD PROCESS
            if ($PSCmdlet.ShouldProcess($Path, "Install module from local package and trust module")) {

                # INSTALL MODULE IN MODULE PATH
                Write-Verbose -Message 'Installing module...'
                Move-Item -Path $moduleFolder.FullName -Destination $modulePath

                # UNBLOCK MODULE
                if ($IsWindows -or $IsMacOS) {
                    Write-Verbose -Message 'Unblocking files...'
                    Get-ChildItem -Path $modulePath -Recurse | Unblock-File
                }
            }

            # VALIDATE MODULE
            if (Get-Module -Name $moduleName) {
                Write-Output -InputObject 'Module installed successfully'
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
