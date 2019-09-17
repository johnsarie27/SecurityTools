function Get-MsiInfo {
    <# =========================================================================
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER Path
        Path to MSI file
    .PARAMETER Property
        Desired property to obtain from MSI Database
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .NOTES
        General notes
        This function was originally written by Nickolaj Andersen (see link below)
        https://www.scconfigmgr.com/2014/08/22/how-to-get-msi-file-information-with-powershell/
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo] $Path,
 
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("ProductCode", "ProductVersion", "ProductName", "Manufacturer", "ProductLanguage", "FullVersion")]
        [string] $Property
    )

    Process {
        try {
            # READ PROPERTY FROM MSI DATABASE
            $windowsInstaller = New-Object -ComObject WindowsInstaller.Installer
            $msiDatabase = $windowsInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $null, $windowsInstaller, @($Path.FullName, 0))
            $query = "SELECT Value FROM Property WHERE Property = '$($Property)'"
            $view = $msiDatabase.GetType().InvokeMember("OpenView", "InvokeMethod", $null, $msiDatabase, ($query))
            $view.GetType().InvokeMember("Execute", "InvokeMethod", $null, $view, $null)
            $record = $view.GetType().InvokeMember("Fetch", "InvokeMethod", $null, $view, $null)
            $value = $record.GetType().InvokeMember("StringData", "GetProperty", $null, $record, 1)
 
            # COMMIT DATABASE AND CLOSE VIEW
            $msiDatabase.GetType().InvokeMember("Commit", "InvokeMethod", $null, $msiDatabase, $null)
            $view.GetType().InvokeMember("Close", "InvokeMethod", $null, $view, $null)           
            $msiDatabase = $null
            $view = $null
 
            # RETURN THE VALUE
            return $value
        } 
        catch {
            Throw $_.Exception.Message
        }
    }

    End {
        # RUN GARBAGE COLLECTION AND RELEASE COMOBJECT
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($windowsInstaller) | Out-Null
        [System.GC]::Collect()
    }
}