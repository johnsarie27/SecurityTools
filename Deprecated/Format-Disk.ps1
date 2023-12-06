function Format-Disk {
    <#
    .SYNOPSIS
        Format or reformat disk
    .DESCRIPTION
        This function accepts a CIM disk object or disk number and reformats the
        disk by clearing the existing data, creating a new partition, auto-assigning
        a drive letter, and formatting the partition with NTFS. Partition style
        can be GPT or MBR based on parameter argument.
    .EXAMPLE
        PS C:\> Format-Disk -Number 2
        Format disk 2 with GPT partition style and NTFS format
    .INPUTS
        System.Object.
    .OUTPUTS
        System.Object.
    .NOTES
        if ( (Get-Disk -Number $Number).Size -le 2199023255552 ) { $PS = 'MBR' } else { $PS = 'GPT' }
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'num',
            HelpMessage = 'Disk number'
        )]
        [ValidateScript( { (Get-Disk).Number -contains $_ -and $_ -NE 0 })]
        [Alias('DiskNumber')]
        [int] $Number,

        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = 'disk',
            HelpMessage = 'Disk object'
        )]
        [ValidateScript( { (Get-Disk).Number -contains $_.Number -and $_.Number -NE 0 })]
        [System.Object.CimInstance] $Disk,

        [Parameter(HelpMessage = "Partition style")]
        [ValidateSet('MBR', 'GPT')]
        [string] $PartitionStyle = "GPT"
    )

    Begin {
        # SETUP TARGET BASED ON PARAMETER INPUT
        if ( $PSBoundParameters.ContainsKey('Number') ) { $Disk = Get-Disk -Number $Number }
    }

    Process {
        # SHOULDPROCESS
        If ( $PSCmdlet.ShouldProcess("Format Disk?") ) {
            $Disk | Clear-Disk -RemoveData | Set-Disk -PartitionStyle $PartitionStyle |
                New-Partition -AssignDriveLetter -UseMaximumSize |
                Format-Volume -FileSystem NTFS -Confirm:$true
        } # Clear-Disk -Remove -WhatIf:$WhatIf -Force:$Force

        # OUTPUT PARTITION INFO
        $Disk | Get-Partition
    }

    End { Write-Output 'Disk formatted' }
}
