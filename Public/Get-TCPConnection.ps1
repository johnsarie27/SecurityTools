function Get-TCPConnection {
    <#
    .SYNOPSIS
        Get Windows processes with open network connections
    .DESCRIPTION
        Query Windows processes and display open connections
    .PARAMETER ComputerName
        Hostname of remote system from which to pull logs.
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object[].
    .EXAMPLE
        PS C:\> Get-TCPConnection.ps1 -ComputerName MyServer
    .NOTES
        This assumes that the identity executing the function has permissions
        to run the cmdlet Get-NetTCPConnection on the remote system when using
        the ComputerName parameter.
    #>
    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'Target computer name')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Count 1 -Quiet })]
        [Alias('Name', 'Computer', 'Host', 'HostName', 'CN')]
        [System.String] $ComputerName
    )

    Begin {
        # PROPERTIES TO RETURN
        $Properties = @(
            'LocalAddress', 'LocalPort', 'RemoteAddress', 'RemotePort', 'State',
            @{N = 'Process'; E = { (Get-Process -Id $_.OwningProcess).ProcessName } },
            @{N = 'PID'; E = { $_.OwningProcess } }
        )
    }

    Process {
        # CHECK FOR COMPUTERNAME PARAMETER
        if ( $PSBoundParameters.ContainsKey('ComputerName') ) {
            # GET TCP CONNECTIONS FROM REMOTE SYSTEM
            $Results = Invoke-Command -ComputerName $ComputerName -ScriptBlock { Get-NetTCPConnection }
        }
        else {
            # GET LOCAL TCP CONNECTIONS
            $Results = Get-NetTCPConnection
        }
    }

    End {
        # RETURN RESULTS WITH SPECIFIED PROPERTIES
        $Results | Select-Object $Properties
    }
}
