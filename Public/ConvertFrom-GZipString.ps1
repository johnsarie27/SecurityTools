function ConvertFrom-GZipString {
    <#
    .SYNOPSIS
        Decompresses a Base64 GZipped string
    .DESCRIPTION
        Decompresses a Base64 GZipped string
    .PARAMETER String
        Base64 encoded GZipped string
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> $compressedString | ConvertFrom-GZipString
        Decompresses and returns the original string from a Base64 GZipped string.
    .LINK
        ConvertTo-GZipString
    .NOTES
        Status: Stable
        https://www.dorkbrain.com/docs/2017/09/02/gzip-in-powershell/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]] $String
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        foreach ($str in $String) {
            $compressedBytes = [System.Convert]::FromBase64String($str)
            $ms = New-Object System.IO.MemoryStream
            $ms.write($compressedBytes, 0, $compressedBytes.Length)
            $ms.Seek(0, 0) | Out-Null
            $cs = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Decompress)
            $sr = New-Object System.IO.StreamReader($cs)
            $sr.ReadToEnd()
        }
    }
    End {
        $ms.Dispose()
        $cs.Dispose()
        $sr.Dispose()
    }
}
