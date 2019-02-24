function Get-ActiveGWUsers {
    <# =========================================================================
    .SYNOPSIS
        Get users actively connected to the remote desktop gateway
    .DESCRIPTION
        This function shows users who have active connections through the
        remote desktop gateway provided.
    .PARAMETER ComputerName
        Remote desktop computer name
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ActiveGWUsers -CompuaterName Gateway
        Get all users connected through the RDGW "Gateway"
    .NOTES
        Some properties are derived from the data provided by WMI
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Remote desktop gateway server' )]
        [ValidateScript( { Test-Connection -ComputerName $_ -Quiet -Count 2 })]
        [ValidateNotNullOrEmpty()]
        [Alias('Name', 'CN', 'Computer', 'System', 'Target')]
        [string] $ComputerName
    )

    $ParamHash = @{
        Class          = "Win32_TSGatewayConnection"
        Namespace      = "root\cimv2\TerminalServices"
        ComputerName   = $ComputerName
        Authentication = 6
    }

    $PropertyList = @(
        'UserName'
        'ClientAddress'
        @{N = 'ConnectionTime'; E = {Get-Date ($_.ConnectedTime.Substring(0, 4) + '-' + $_.ConnectedTime.Substring(4, 2) + `
                        '-' + $_.ConnectedTime.Substring(6, 2) + ' ' + $_.ConnectedTime.Substring(8, 2) + ':' + `
                        $_.ConnectedTime.Substring(10, 2) + ':' + $_.ConnectedTime.Substring(12, 2))}
        }
        #'{0}-{1}-{2} {3}:{4}:{5}' -f $_.ConnectedTime.Substring(0,4), $_.ConnectedTime.Substring(4,2), $_.ConnectedTime.Substring(6,2),
        #$_.ConnectedTime.Substring(8,2), $_.ConnectedTime.Substring(10,2), $_.ConnectedTime.Substring(12,2)
        # (Select-String -InputObject $_ -Pattern 'day,\s(\w{4,12})\s').Matches.Groups[1].Value
        @{N = 'ElapsedTime'; E = {($_.ConnectionDuration.Substring(8, 2) + ':' + $_.ConnectionDuration.Substring(10, 2) + `
                        ':' + $_.ConnectionDuration.Substring(12, 2) )}
        }
        'ConnectedResource'
    )

    $Users = Get-WmiObject @ParamHash | Select-Object $PropertyList

    $Users
}
