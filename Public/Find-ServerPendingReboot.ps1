function Find-ServerPendingReboot {
    <#
    .SYNOPSIS
        Check if a server is pending reboot
    .DESCRIPTION
        Check if a server is pending reboot
    .PARAMETER ComputerName
        Gets the server reboot status on the specified computer.
    .EXAMPLE
        C:\PS> C:\Script\FindServerIsPendingReboot.ps1 -ComputerName "WIN-VU0S8","WIN-FJ6FH","WIN-FJDSH","WIN-FG3FH"

        ComputerName                                          RebootIsPending
        ------------                                          ---------------
        WIN-VU0S8                                             False
        WIN-FJ6FH                                             True
        WIN-FJDSH                                             True
        WIN-FG3FH                                             True

        This command will get the reboot status on the specified remote computers.
    .NOTES
        This script was taken from the site listed below. I've made several
        modifications including formatting for ease of reading.

        https://gallery.technet.microsoft.com/scriptcenter/How-to-check-if-any-4b1e53f2
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, HelpMessage = 'Computer name')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Quiet -Count 1 })]
        [Alias('CN')]
        [System.String[]] $ComputerName = $env:COMPUTERNAME
    )

    Begin {
        # THE REGISTRY KEYS BELOW CONTAIN VALUES THAT DETERMINE WHETHER A SYSTEM REQUIRES A REBOOT
        $pendFileKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\"
        $autoUpdateKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"
        $CBSKeyPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\"

        $sbRemote = @{
            PendingFile = { Get-ItemProperty -Path $Using:pendFileKeyPath -Name PendingFileRenameOperations -ErrorAction SilentlyContinue }
            AutoUpdate  = { Test-Path -Path "$Using:autoUpdateKeyPath\RebootRequired" }
            CBS         = { Test-Path -Path "$Using:CBSKeyPath\RebootPending" }
        }

        # SYSTEMS GOVERNED BY SCCM 2012 CONTAIN ADDITIONAL VALUES TO KEEP TRACK OF REQUIRED REBOOT
        $cimParams = @{
            Namespace   = 'Root\ccm\clientSDK'
            ClassName   = 'CCM_ClientUtilities'
            Name        = 'DetermineIfRebootPending'
            ErrorAction = 'SilentlyContinue'
        }
    }

    Process {
        foreach ($cn in $ComputerName) {
            # SET INITIAL VALUE FOR REBOOT VARIABLES
            $pendingFile = $false
            $autoUpdate = $false
            $cbs = $false
            $sccmPending = $false

            # DETERMINE IF TARGET SYSTEM IS LOCAL OR REMOTE
            if ( $cn -eq $env:COMPUTERNAME ) {
                # REMOVE 'USING' KEYWORD AND CONVERT BACK INTO SCRIPT BLOCK
                $sbLocal = @{ }
                foreach ( $k in $sbRemote.Keys ) {
                    $string = $sbRemote[$k] -replace 'Using:', ''
                    $sbLocal[$k] = [Scriptblock]::Create($String)
                }

                $key = Invoke-Command -ScriptBlock $sbLocal['PendingFile']
                $autoUpdate = Invoke-Command -ScriptBlock $sbLocal['AutoUpdate'] -ErrorAction SilentlyContinue
                $cbs = Invoke-Command -ScriptBlock $sbLocal['CBS']
            }
            else {
                $s = New-PSSession -ComputerName $cn
                $key = Invoke-Command -Session $s -ScriptBlock $sbRemote['PendingFile']
                # THIS RETURNS A BOOLEAN OBJECT WITH ADDITIONAL PROPERTIES (PSComputerName, RunspaceId, etc.)
                # HOWEVER, THOSE PROPERTIES ARE NOT DISPLAYED WITH CALLING THE VARIABLE DIRECTLY
                $autoUpdate = Invoke-Command -Session $s -ScriptBlock $sbRemote['AutoUpdate'] -ErrorAction SilentlyContinue
                $cbs = Invoke-Command -Session $s -ScriptBlock $sbRemote['CBS']

                # CLOSE SESSION
                Remove-PSSession -Session $s
                $cimParams['ComputerName'] = $cn
            }
            if ($key.PendingFileRenameOperations) { $pendingFile = $true }

            $SCCMReboot = Invoke-CimMethod @cimParams
            if ( $cimParams.ContainsKey('ComputerName') ) { $cimParams.Remove('ComputerName') }
            if ( $SCCMReboot.RebootPending -or $SCCMReboot.IsHardRebootPending ) { $sccmPending = $true }

            # CREATE NEW HASH TABLE FOR RESULTS
            $new = @{ ComputerName = $cn ; RebootIsPending = $false }
            if ( $pendingFile -or $autoUpdate -or $cbs -or $sccmPending ) { $new.RebootIsPending = $true }

            # CONVERT HASH TABLE TO OBJECT AND RETURN
            [PSCustomObject] $new
        }
    }
}
