function Get-File {
    <# =========================================================================
    .SYNOPSIS
        Select file using Windows dialog
    .DESCRIPTION
        This function opens a Windows OpenFile or SaveFile dailog window and
        allows the use to complete the chosen task based on the presence of
        the switch parameter -Save.
    .PARAMETER InitialDirectory
        Directory to start with when opening the dialog.
    .PARAMETER Save
        Switch variable that changes select file to save file as.
    .PARAMETER Extension
        Extension type to find or save as.
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-File -Save -Extension xlsx
    .EXAMPLE
        PS C:\> Get-File -InitialDirectory $env:USERPROFILE\Downlads
    .LINK
        https://blogs.technet.microsoft.com/heyscriptingguy/2009/09/01/hey-scripting-guy-can-i-open-a-file-dialog-box-with-windows-powershell/
        https://mcpmag.com/articles/2016/06/09/display-gui-message-boxes-in-powershell.aspx
        http://ilovepowershell.com/tag/savefiledialog/
    ========================================================================= #>
    Param(
        [Parameter(HelpMessage = 'Starting directory for file selection')]
        [ValidateScript( { Test-Path $_ -PathType 'Container' })]
        [string] $InitialDirectory = $env:USERPROFILE,

        [Parameter(HelpMessage = 'Save file as')]
        [switch] $Save,

        [Parameter(HelpMessage = 'File extension')]
        [ValidateSet("csv", "xlsx", "xls", "xml", "json", "log", "txt", "exe", "msi")]
        [string] $Extension = 'csv',

        [Parameter(HelpMessage = 'Title or file name')]
        [ValidateScript( { $_.Lenght -LT 64 })]
        [string] $Title
    )

    if ( $Save ) { $DialogType = 'SaveFileDialog' } else { $DialogType = 'OpenFileDialog' }

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $Dialog = New-Object System.Windows.Forms."$DialogType" # SaveFileDialog | OpenFileDialog
    if ( $PSBoundParameters.ContainsKey('Title') ) { $Dialog.Title = $Title }
    $Dialog.InitialDirectory = $InitialDirectory
    $Dialog.Filter = "$Extension files (*.$Extension)| *.$Extension"
    $Dialog.ShowDialog() | Out-Null
    $Dialog.FileName
}
