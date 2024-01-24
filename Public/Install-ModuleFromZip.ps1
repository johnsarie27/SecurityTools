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
        [System.String] $Scope = 'CurrentUser'
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET PLATFORM VARIABLES
        $splitChar = if ($IsWindows) { ';' } else { ':' }

        # SET DEFAULT MODULE HOME PATH
        $moduleHome = switch ($Scope) {
            'CurrentUser' { ($env:PSModulePath.Split("$splitChar"))[0] }
            'AllUsers' { ($env:PSModulePath.Split("$splitChar"))[1] }
        }

        Write-Verbose -Message ('Module home: "{0}"' -f $moduleHome)

        # SET MODULE NAME
        $moduleName = (Split-Path -Path $Path -LeafBase).Split('-')[0]
        Write-Verbose -Message ('Module name: "{0}' -f $moduleName)
    }
    Process {
        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($Path, "Install module from local package")) {

            # UNZIP MODULE
            Expand-Archive -Path $Path -DestinationPath $moduleHome

            # GET NEW MODULE
            $module = Get-Module -ListAvailable -Name $moduleName

            # VALIDATE MODULE
            if (-Not $module) {
                # LOG FAILURE
                throw ('Module "{0}" not found.' -f $moduleName)
            }
            else {
                # SHOULD PROCESS
                if ($PSCmdlet.ShouldProcess($module.Name, "Trust module") -and ($IsWindows -or $IsMacOS)) {

                    # TRUST MODULE
                    Get-ChildItem -Path $module.ModuleBase -Recurse | Unblock-File -Confirm:$false

                    # GET SCRIPT FILES
                    #$Scripts = Get-ChildItem -Path $moduleHome -Include @("*.ps1*", "*.psm1") -Recurse

                    # SIGN SCRIPT FILES
                    #Set-AuthenticodeSignature -FilePath $Scripts.FullName -Certificate $MyCert
                }

                # LOG SUCCESS
                if ($? -eq $true) { Write-Verbose -Message 'Module installed successfully.' }
            }
        }
    }
}
