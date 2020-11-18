function Remove-Signature {
    <# =========================================================================
    .SYNOPSIS
        Remove authenticode signature from script
    .DESCRIPTION
        Remove authenticode signature from PowerShell script
    .PARAMETER ScriptPath
        Path to script file
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> .\myScript.ps1 | Remove-Signature
        Removes the authenticode signature block from the script myScript.ps1
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Path to script file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include '*.ps*' })]
        [Alias('Path', 'Script', 'File')]
        [string[]] $ScriptPath
    )

    Process {
        foreach ($file in $ScriptPath) {
            $content = Get-Content $file
            $line = ($content | Select-String "SIG # Begin signature block").LineNumber
            if ($line) {
                if ($PSCmdlet.ShouldProcess("$file", "Removing signature block")) {
                    $content[0..($line - 3)] | Set-Content -Path $file
                }
                Write-Output -InputObject ('Removed signature from file: {0}' -f $file)
            }
            else {
                Write-Verbose -Message ('No signature found in file: {0}' -f $file)
            }
        }
    }
}