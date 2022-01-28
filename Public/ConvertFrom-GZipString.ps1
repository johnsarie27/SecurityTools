function ConvertFrom-GZipString {
    <# =========================================================================
    .SYNOPSIS
        Decompresses a Base64 GZipped string
    .DESCRIPTION
        Decompresses a Base64 GZipped string
    .PARAMETER String
        A Base64 encoded GZipped string
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        $compressedString | ConvertFrom-GZipString
    .LINK
        ConvertTo-GZipString
    .NOTES
        Name: ConvertFrom-GZipString
        Author: Justin Johns
        Version: 0.1.1 | Last Edit: 2022-01-27 [0.1.1]
        - modified parameter to accept array of string
        - changed Foreach-Object to foreach command
        Comments: <Comment(s)>
        General notes
        https://www.dorkbrain.com/docs/2017/09/02/gzip-in-powershell/
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]] $String
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
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