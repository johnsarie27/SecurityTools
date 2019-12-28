function Get-Folder {
    <# =========================================================================
    .SYNOPSIS
        Select folder using Windows dialog
    .DESCRIPTION
        This function opens a Windows dialog and allows use to select a folder
    .PARAMETER Description
        Description presented to user for folder selection
    .PARAMETER InitialPath
        Path of directory to present to user when requesting selection of new
        path.
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-Folder -InitialPath $env:USERPROFILE\Downlads
    .LINK
        http://www.powershellmagazine.com/2013/06/28/pstip-using-the-system-windows-forms-folderbrowserdialog-class/
    ========================================================================= #>
    Param(
        [Parameter(HelpMessage = 'Starting directory for selection window')]
        [ValidateScript( { Test-Path -Path $_ -PathType 'Container' })]
        [string] $InitialPath = "$env:USERPROFILE\Downloads",

        [Parameter(HelpMessage = 'Folder description')]
        [ValidateScript( { $_.Lenght -LT 64 })]
        [string] $Description
    )

    Add-Type -AssemblyName System.Windows.Forms
    $Dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ( $PSBoundParameters.ContainsKey('Description') ) { $Dialog.Description = $Description }
    $Dialog.SelectedPath = "$InitialPath"
    $Dialog.ShowDialog() | Out-Null
    $Dialog.SelectedPath
}
