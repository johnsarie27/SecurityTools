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
        $Results = [System.Collections.Generic.List[System.Object]]::new()

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
        foreach ( $Computer in $ComputerName ) {
            if ( $PSBoundParameters.ContainsKey('ComputerName') ) {
                $Results.Add( (Invoke-Command -ComputerName $Computer -ScriptBlock { Get-BitLockerVolume }) )
            } else {
                Get-BitLockerVolume
            }
        }
    }

    End {
        $Results | Select-Object -Property $Properties | Format-Table
    }
}
