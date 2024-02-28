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
        Name:     Get-PublicIP
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-02-28
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
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
