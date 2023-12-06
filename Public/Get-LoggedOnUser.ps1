function Get-LoggedOnUser {
    <#
    .SYNOPSIS
        Show all users currently logged onto system
    .DESCRIPTION
        This function gets all user sessions on a remote system.
    .PARAMETER ComputerName
        Hostname or IP address of target system to find users.
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-ConnectedUser -ComputerName $Computer
    #>
    Param(
        [Parameter(HelpMessage = 'Target hostname')]
        [ValidateScript( { Test-Connection -ComputerName $_ -Quiet -Count 1 })]
        [ValidateNotNullOrEmpty()]
        [Alias('Hostname', 'Host', 'Computer', 'CN')]
        [System.String] $ComputerName
    )

    if ( $PSBoundParameters.ContainsKey('ComputerName') ) {
        if (
            ( $ComputerName -eq 'localhost' ) -or
            ( $ComputerName -eq '127.0.0.1' ) -or
            ( $ComputerName -eq $env:COMPUTERNAME ) -or
            ( $ComputerName -eq '::1' )
        ) { query user }
        else {
            $Session = New-PSSession -ComputerName $ComputerName
            $Response = Invoke-Command -Session $Session -ScriptBlock { query user }
            $Response
        }
    }
    else { query user }
}
