function Get-RemoteBitLocker {
    <# =========================================================================
    .SYNOPSIS
        Get remote BitLocker encryption info
    .DESCRIPTION
        Get BitLocker encryption info from remote system(s)
    .PARAMETER ComputerName
        Target computer(s)
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object
    .EXAMPLE
        PS C:\> Get-RemoteBitLocker -CN Server01
        Get BitLocker volume info from Server01
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'Target computer(s)')]
        [ValidateScript( { Test-Connection -ComputerName $_ -Count 1 -Quiet })]
        [Alias('CN', 'Target', 'Host')]
        [string[]] $ComputerName
    )

    Begin {
        $Results = @()
        $Properties = @(
            'VolumeType'
            'MountPoint'
            'CapacityGB'
            'VolumeStatus'
            'EncryptionPercentage'
            'KeyProtector'
            'AutoUnlockEnabled'
            'ProtectionStatus'
        )
    }

    Process {
        $ComputerName | ForEach-Object -Process {
            if ( $PSBoundParameters.ContainsKey('ComputerName') ) {
                <# $Session = New-PSSession -ComputerName $_
                $Results += Invoke-Command -Session $Session -ScriptBlock { Get-BitLockerVolume }
                Remove-PSSession -Session $Session #>
                $Results += Invoke-Command -ComputerName $_ -ScriptBlock { Get-BitLockerVolume }
            }
            else { Get-BitLockerVolume }
        }
    }

    End {
        $Results | Select-Object -Property $Properties | Format-Table
    }
}
