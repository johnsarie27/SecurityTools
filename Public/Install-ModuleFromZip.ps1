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
        Other versions of the same module are left in place.
    .EXAMPLE
        PS C:\> Install-ModuleFromZip -Path .\SecurityTools.zip -Replace
        Extracts contents of zip and copies to Windows module directory then removes zip.
        Removes other versions of the same module.
    .NOTES
        Name:     Install-ModuleFromZip
        Author:   Justin Johns, Phillip Glodowski
        Version:  0.1.4 | Last Edit: 2024-10-10
        Comments: (see commit history)
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

        Write-Verbose -Message ('Module home: [{0}]' -f $moduleHome)

        # SET TEMP PATH
        $tempPath = Join-Path -Path $tempDir -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($Path))
    }
    Process {

        # INSPECT AND PREPARE INPUT ARCHIVE FILE
        try {
            # DECOMPRESS ZIP FILE TO TEMP PATH
            Expand-Archive -Path $Path -DestinationPath $tempPath

            # GET MODULE INFO
            $psDataFile = Get-ChildItem $tempPath -Recurse -Filter '*.psd1'
            $psData = Import-PowerShellDataFile -Path $psDataFile.FullName
            $moduleInfo = @{
                ModuleName      = [System.IO.Path]::GetFileNameWithoutExtension($psDataFile)
                RequiredVersion = [System.Version] $psData.ModuleVersion
            }

            # RENAME MODULE FOLDER TO VERSION NUMBER
            Rename-Item -Path (Get-ChildItem $tempPath).FullName -NewName $moduleInfo.RequiredVersion.ToString()
            $moduleFolder = Get-ChildItem $tempPath

            # SET MODULE PATH
            $modulePath = Join-Path -Path $moduleHome -ChildPath $moduleInfo.ModuleName

            Write-Verbose -Message ('Module name: [{0}]' -f $moduleInfo.ModuleName)
            Write-Verbose -Message ('Version: [{0}]' -f $moduleInfo.RequiredVersion.ToString())
        }
        catch {
            Write-Error -Message  'Error while inspecting input module archive file.'
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }

        # IS MODULE INSTALLED
        $getModule = Get-Module -ListAvailable -Name $moduleInfo.ModuleName

        if ($getModule) {
            # THE MODULE IS ALREADY INSTALLED
            $versionList = $getModule | ForEach-Object { "$($_.Version)" }
            Write-Warning -Message ('Module [{0}] identified. Installed version(s): [{1}]' -f $moduleInfo.ModuleName, ($versionList -join ', '))

            # CHECK FOR INPUT VERSION
            if ($getModule.Version -contains $moduleInfo.RequiredVersion) {
                # THIS VERSION IS ALREADY INSTALLED
                Write-Warning -Message ('Module [{0}] version [{1}] is already installed. No changes have been made.' -f $moduleInfo.ModuleName, $moduleInfo.RequiredVersion.ToString())
            }
            elseif ($getModule.Version -notcontains $moduleInfo.RequiredVersion) {
                # THIS VERSION IS NOT INSTALLED
                # IF REPLACE SWITCH
                if ($Replace) {
                    # ALL OTHER VERSIONS WILL BE REMOVED
                    Write-Warning -Message ('"-Replace" switch specified. Version [{0}] will be installed and all other versions removed.' -f $moduleInfo.RequiredVersion.ToString())

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
                    if (Get-Module -FullyQualifiedName $moduleInfo -ListAvailable) {
                        Write-Output 'Module installed successfully'
                    }
                }
                else {
                    # INSTALL VERSION
                    Write-Output ('Module [{0}] version [{1}] will be installed. Existing versions will not be affected.' -f $moduleInfo.ModuleName, $moduleInfo.RequiredVersion.ToString())

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
                    if (Get-Module -FullyQualifiedName $moduleInfo -ListAvailable) {
                        Write-Output 'Module installed successfully'
                    }
                }
            }
        }
        else {
            # NO VERSION OF THE MODULE IS INSTALLED
            Write-Output ('Module [{0}] version [{1}] will be installed.' -f $moduleInfo.ModuleName, $moduleInfo.RequiredVersion.ToString())

            # SHOULD PROCESS
            if ($PSCmdlet.ShouldProcess($Path, "Install module from local package and trust module")) {

                # INSTALL MODULE IN MODULE PATH
                Write-Verbose -Message 'Installing module...'
                Move-Item -Path $tempPath -Destination $modulePath

                # UNBLOCK MODULE
                if ($IsWindows -or $IsMacOS) {
                    Write-Verbose -Message 'Unblocking files...'
                    Get-ChildItem -Path $modulePath -Recurse | Unblock-File
                }
            }

            # VALIDATE MODULE
            if (Get-Module -FullyQualifiedName $moduleInfo -ListAvailable) {
                Write-Output 'Module installed successfully'
            }
        }
    }
    End {
        # REMOVE TEMPORARY ZIP FILE
        if ($tempPath -and (Test-Path -Path $tempPath)) {
            Write-Verbose -Message 'Cleanup: removing package archive...'
            Remove-Item -Path $tempPath -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}
