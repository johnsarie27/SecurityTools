function Get-PublicIP {
    <#
    .SYNOPSIS
        Get public IP address
    .DESCRIPTION
        Get public IP address of system
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Get-PublicIP
        Returns public IP address of system
    .NOTES
        Status: Stable
    #>
    [CmdletBinding()]
    Param()
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # GET PUBLIC IP
        Invoke-RestMethod -Uri 'http://ifconfig.me/ip'
    }
}
