function Write-EncryptedFile {
    <# =========================================================================
    .SYNOPSIS
        Create encrypted file
    .DESCRIPTION
        Create encrypted file
    .PARAMETER Content
        Data to encrypt
    .PARAMETER Path
        Path to new encrypted file
    .PARAMETER Key
        Encryption key
    .PARAMETER KeyBytes
        Encryption key in byte array
    .INPUTS
        System.String[].
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Write-EncryptedFile -Content ($settings | ConvertTo-Json) -Path C:\temp\mySettings -Key 'Password123'
        Encrypts user settings in new file mySettings with the encryption key specified
    .NOTES
        General notes
        This function was written by Tim Curwick in PowerShell Conference Book 2
        (minor changes made)
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeLine)]
        [string[]] $Content,

        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -Path ([System.IO.Path]::GetDirectoryName($_)) -PathType Container })]
        [string] $Path,

        [Parameter(Mandatory, ParameterSetName = '__key')]
        [string] $Key,

        [Parameter(Mandatory, ParameterSetName = '__keybytes')]
        [byte[]] $KeyBytes
    )
    Begin {
        try {
            # If the key was provided as a string convert it to bytes
            if ( $Key ) { $KeyBytes = [byte[]]$Key.ToCharArray() }

            # If the key is not 256 bits pad it or truncate it as needed
            if ( $KeyBytes.Count -ne 32 ) { $KeyBytes = ( $KeyBytes + [byte[]]'ThePaddingToUseIfWeNeedMoreBytes'.ToCharArray() )[0..31] }

            # Create cryptography engine
            $Crypto = New-Object -TypeName System.Security.Cryptography.RijndaelManaged

            # Set key
            $Crypto.Key = $KeyBytes

            # Use hash of key for initializing vector
            $Crypto.IV = (New-Object -TypeName Security.Cryptography.SHA256Managed).ComputeHash($Crypto.Key)[0..15]

            # Create encryptor
            $Encryptor = $Crypto.CreateEncryptor()

            # Create file stream
            $FileStream = New-Object System.IO.FileStream -ArgumentList @( $Path, [System.IO.FileMode]::Create )

            # Plumb the file stream into a cryptography stream with encryptor
            $CryptoStream = New-Object -TypeName Security.Cryptography.CryptoStream -ArgumentList @( $FileStream, $Encryptor, "Write" )

            # Create stream writer to send the data
            $StreamWriter = New-Object -TypeName IO.StreamWriter -ArgumentList $CryptoStream
        }
        catch {
            # Clean up
            if ( $StreamWriter ) { $StreamWriter.Close() }
            if ( $CryptoStream ) { $CryptoStream.Close() }
            if ( $FileStream ) { $FileStream.Close() }
            if ( $Crypto ) { $Crypto.Clear() }

            throw $_
        }

        # Set first line flag
        $FirstLine = $True
    }
    Process {
        try {
            foreach ( $line in $Content ) {
                if ( $FirstLine ) { $FirstLine = $false }
                else { $StreamWriter.Write( [Environment]::NewLine ) }

                # Dump the data to be encrypted into the stream
                $StreamWriter.Write( $line )
            }
        }
        catch {
            # Clean up
            if ( $StreamWriter ) { $StreamWriter.Close() }
            if ( $CryptoStream ) { $CryptoStream.Close() }
            if ( $FileStream ) { $FileStream.Close() }
            if ( $Crypto ) { $Crypto.Clear() }

            throw $_
        }
    }
    End {
        # Clean up
        if ( $StreamWriter ) { $StreamWriter.Close() }
        if ( $CryptoStream ) { $CryptoStream.Close() }
        if ( $FileStream ) { $FileStream.Close() }
        if ( $Crypto ) { $Crypto.Clear() }

        # Return resulting file
        return ( Get-Item -Path $Path )
    }
}