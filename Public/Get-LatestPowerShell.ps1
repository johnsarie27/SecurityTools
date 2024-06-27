function Get-LatestPowerShell {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER Architecture
        Processor architecture
    .PARAMETER OutputDirectory
        Output directory
    .PARAMETER Version
        Desired version of PowerShell
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Get-LatestPowerShell -Architecture WindowsAmd64
        Downloads the latest version of PowerShell for Windows AMD64 to the desktop.
    .NOTES
        Name:     Get-LatestPowerShell
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-06-27
        - Version history is captured in repository commit history
        Comments: <Comment(s)>
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Processor architecture')]
        [ValidateSet('WindowsAmd64', 'LinuxAmd64', 'LinuxArm64')]
        [System.String] $Architecture,

        [Parameter(Mandatory = $false, Position = 1, HelpMessage = 'Output directory')]
        [System.String] $OutputDirectory = "$HOME\Desktop",

        [Parameter(Mandatory = $false, Position = 2, HelpMessage = 'Desired version of PowerShell')]
        [ValidatePattern('^\d(\.\d{1,2}){2}$')]
        [System.String] $Version
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET URI HASH
        $uriHash = @{
            WindowsAmd64 = 'https://github.com/PowerShell/PowerShell/releases/download/v{0}/PowerShell-{0}-win-x64.msi'
            LinuxAmd64   = 'https://github.com/PowerShell/PowerShell/releases/download/v{0}/powershell_{0}-1.deb_amd64.deb'
            LinuxArm64   = 'https://github.com/PowerShell/PowerShell/releases/download/v{0}/powershell-{0}-linux-arm64.tar.gz'
        }
    }
    Process {
        # SET DESIRED VERSION
        if (-Not $PSBoundParameters.ContainsKey('Version')) {
            # GET LATEST RELEASE INFO FOR POWERSHELL REPOSITORY
            $releaseInfo = Invoke-RestMethod -Uri 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest'

            # SET LATEST VERSION
            $Version = $releaseInfo.tag_name.TrimStart('v')

            # OUTPUT ALL ASSSET NAMES
            #$releaseInfo.assets.name

            #$releaseInfo.assets.browser_download_url

            # FIND THE DEB AND TAR FILES FOR AMD64 AND ARM64
            #$releaseInfo.assets.browser_download_url -match 'powershell_.+\.deb_amd64\.deb'
            #$releaseInfo.assets.browser_download_url -match 'linux-arm64\.tar\.gz'
        }

        # SET URI
        $uri = $uriHash[$Architecture] -f $Version

        # SET OUTPUT PATH
        $out = Join-Path -Path $OutputDirectory -ChildPath (Split-Path -Path $uri -Leaf)

        # DOWNLOAD LATEST POWERSHELL
        Invoke-WebRequest -Uri $uri -OutFile $out
    }
}
