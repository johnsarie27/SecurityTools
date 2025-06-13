function Expand-GZip {
    <#
    .SYNOPSIS
        Expand GZip compressed file
    .DESCRIPTION
        Expand GZip compressed file
    .PARAMETER Path
        Path to GZip file
    .PARAMETER OutputDirectory
        Destination directory to extract file to
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Expand-GZip -Path C:\E3IU1BL3AWXV9B.2023-10-30-21.b3052b06.gz
        Extracts file to C:\E3IU1BL3AWXV9B.2023-10-30-21.b3052b06
    .NOTES
        Name:     Expand-GZip
        Author:   RiffyRiot
        Version:  0.1.1 | Last Edit: 2025-06-13
        - see commit history for version history
        General Notes:
        https://social.technet.microsoft.com/Forums/windowsserver/en-US/5aa53fef-5229-4313-a035-8b3a38ab93f5/unzip-gz-files-using-powershell?forum=winserverpowershell
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Path to GZip file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include '*.gz' })]
        [System.IO.FileInfo] $Path,

        [Parameter(Mandatory = $false, Position = 1, HelpMessage = 'Destination directory to extract file to')]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [System.IO.FileInfo] $OutputDirectory
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # CHECK FOR DESTINATION PATH
        if ($PSBoundParameters.ContainsKey('OutputDirectory')) {
            # SET DESTINATION TO FULL, DECOMPRESSED FILE PATH
            #$destFullPath = Join-Path -Path $OutputDirectory -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($Path))
            $destFullPath = Join-Path -Path $OutputDirectory -ChildPath (Split-Path -Path $Path -LeafBase)
        }
        else {
            # IF NO DESTINATION PATH IS PROVIDED, USE THE SAME PATH AS THE GZIP FILE BUT WITHOUT THE .GZ EXTENSION
            #$destFullPath = $Path -replace '\.gz$', ''
            $destFullPath = Join-Path -Path (Split-Path -Path $Path) -ChildPath (Split-Path -Path $Path -LeafBase)
        }

        # OUTPUT VERBOSE MESSAGE
        Write-Verbose -Message ('Expanding GZip file [{0}] to [{1}]' -f $Path, $destFullPath)

        # CREATE .NET OBJECTS
        $ip = New-Object System.IO.FileStream $Path, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read)
        $op = New-Object System.IO.FileStream $destFullPath, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None)
        $gzipStream = New-Object System.IO.Compression.GzipStream $ip, ([IO.Compression.CompressionMode]::Decompress)

        $buffer = New-Object byte[](1024)
        while ($true) {
            $read = $gzipstream.Read($buffer, 0, 1024)
            if ($read -le 0) { break }
            $op.Write($buffer, 0, $read)
        }
    }
    End {
        # CLOSE STREAMS
        $gzipStream.Close()
        $op.Close()
        $ip.Close()
    }
}
