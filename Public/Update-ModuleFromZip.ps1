function Update-ModuleFromZip {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER Name
        Module name
    .PARAMETER Path
        Path to zipped module
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Update-ModuleFromZip -Name SecurityTools -Path "$HOME\Desktop\SecurityTools.zip"
        Updates the module "SecurityTools" using the local zip file
    .NOTES
        Name:     Update-ModuleFromZip
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-01-23
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Module name')]
        [ValidateScript({ Get-Module -ListAvailable -Name $_ })]
        [System.String] $Name,

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'Path to zipped module')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.zip" })]
        [System.String] $Path
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # GET MODULE
        $module = Get-Module -ListAvailable -Name $Name

        # VALIDATE MODULE
        if (-Not $module) {
            # LOG
            Write-Warning -Message ('Module "{0}" not found' -f $Name)
        }
        else {
            # SHOULD PROCESS
            if ($PSCmdlet.ShouldProcess($module.Name, "Replace module")) {
                # REMOVE OLD MODULE
                Remove-Item -Path $module.ModuleBase -Recurse -Force -Confirm:$false

                # EXTRACT NEW MODULE
                Expand-Archive -Path $Path -DestinationPath (Split-Path -Path $module.ModuleBase)

                # SHOULD PROCESS
                if ($PSCmdlet.ShouldProcess($module.Name, "Trust module") -and ($IsWindows -or $IsMacOS)) {

                    # TRUST MODULE
                    Get-ChildItem -Path $module.ModuleBase -Recurse | Unblock-File -Confirm:$false
                }

                # LOG SUCCESS
                if ($? -eq $true) { Write-Verbose -Message 'Module installed successfully.' }
            }
        }
    }
}
