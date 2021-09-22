function Read-EncryptedFile {
    <# =========================================================================
    .SYNOPSIS
        Read encrypted file
    .DESCRIPTION
        Read encrypted file
    .PARAMETER Path
        Path to encrypted file
    .PARAMETER Key
        Encryption key
    .PARAMETER KeyBytes
        Encryption key in byte array
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Read-EncryptedFile -Path C:\temp\mySettings -Key 'Password123'
        Decrypts user settings from file mySettings with the encryption key specified
    .NOTES
        General notes
        This function was written by Tim Curwick in PowerShell Conference Book 2
        (minor changes made)
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string] $Path,

        [Parameter(Mandatory, ParameterSetName = '__key')]
        [string] $Key,

        [Parameter(Mandatory, ParameterSetName = '__keybytes')]
        [byte[]] $KeyBytes
    )
    Process {
        try {
            # If the key was provided as a string Convert it to bytes
            if ( $Key ) { $KeyBytes = [byte[]]$Key.ToCharArray() }

            # If the key is not 256 bits Pad it or truncate it as needed
            if ( $KeyBytes.Count -ne 32 ) { $KeyBytes = ( $KeyBytes + [byte[]]'ThePaddingToUseIfWeNeedMoreBytes'.ToCharArray() )[0..31] }

            # Create cryptography engine
            $Crypto = New-Object -TypeName System.Security.Cryptography.RijndaelManaged

            # Set key
            $Crypto.Key = $KeyBytes

            # Use hash of key for initializing vector
            $Crypto.IV = (New-Object -TypeName Security.Cryptography.SHA256Managed).ComputeHash( $Crypto.Key )[0..15]

            # Create decryptor
            $Decryptor = $Crypto.CreateDecryptor()

            # Open file stream from source file
            $FileStream = New-Object System.IO.FileStream -ArgumentList @( $Path, [System.IO.FileMode]::Open )

            # Plumb the file stream into a cryptography stream with decryptor
            $CryptoStream = New-Object -TypeName Security.Cryptography.CryptoStream -ArgumentList @( $FileStream, $Decryptor, "Read" )

            # Create stream reader to get the data
            $StreamReader = New-Object -TypeName IO.StreamReader $CryptoStream

            ## Turn on the spigot and get the results,
            ## dumping them directly into the output stream
            $StreamReader.ReadToEnd()
        }
        catch { }
        finally {
            # Clean up
            if ( $StreamWriter ) { $StreamWriter.Close() }
            if ( $CryptoStream ) { $CryptoStream.Close() }
            if ( $FileStream ) { $FileStream.Close() }
            if ( $Crypto ) { $Crypto.Clear() }
        }
    }
}