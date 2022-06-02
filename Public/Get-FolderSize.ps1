function Get-FolderSize {
    <# =========================================================================
    .SYNOPSIS
        Returns the size of folders in MB and GB.
    .DESCRIPTION
        This function will get the folder size in MB and GB of folders found in the Path parameter.
        The Path parameter defaults to C:\. You can also specify a specific folder name via the folderName parameter.
    .PARAMETER Path
        This parameter allows you to specify the base path you'd like to get the child folders of.
        It defaults to C:\.
    .PARAMETER FolderName
        This parameter allows you to specify the name of a specific folder you'd like to get the size of.
    .PARAMETER AddTotal
        This parameter adds a total count at the end of the array
    .PARAMETER OmitFolder
        This parameter allows you to omit folder(s) (array of string) from being included
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        Get-FolderSize.ps1

        FolderName                Size(Bytes) Size(MB)     Size(GB)
        ----------                ----------- --------     --------
        $GetCurrent                    193768 0.18 MB      0.00 GB
        $RECYCLE.BIN                 20649823 19.69 MB     0.02 GB
        $SysReset                    53267392 50.80 MB     0.05 GB
        Config.Msi                            0.00 MB      0.00 GB
        Documents and Settings                0.00 MB      0.00 GB
        Games                     48522184491 46,274.36 MB 45.19 GB
    .EXAMPLE
        Get-FolderSize.ps1 -Path 'C:\Program Files'

        FolderName                                   Size(Bytes) Size(MB)    Size(GB)
        ----------                                   ----------- --------    --------
        7-Zip                                            4588532 4.38 MB     0.00 GB
        Adobe                                         3567833029 3,402.55 MB 3.32 GB
        Application Verifier                              353569 0.34 MB     0.00 GB
        Bonjour                                           615066 0.59 MB     0.00 GB
        Common Files                                   489183608 466.52 MB   0.46 GB
    .EXAMPLE
        Get-FolderSize.ps1 -Path 'C:\Program Files' -FolderName IIS

        FolderName Size(Bytes) Size(MB) Size(GB)
        ---------- ----------- -------- --------
        IIS            5480411 5.23 MB  0.01 GB
    .EXAMPLE
        Get-FolderSize.ps1

        FolderName Size(GB) Size(MB)
        ---------- -------- --------
        Public     0.00 GB  0.00 MB
        thegn      2.39 GB  2,442.99 MB
    .EXAMPLE
        Sort by size descending
        Get-FolderSize.ps1 | Sort-Object 'Size(Bytes)' -Descending

        FolderName                Size(Bytes) Size(MB)     Size(GB)
        ----------                ----------- --------     --------
        Users                     76280394429 72,746.65 MB 71.04 GB
        Games                     48522184491 46,274.36 MB 45.19 GB
        Program Files (x86)       27752593691 26,466.94 MB 25.85 GB
        Windows                   25351747445 24,177.31 MB 23.61 GB
    .EXAMPLE
        Omit folder(s) from being included
        .\Get-FolderSize.ps1 -OmitFolder 'C:\Temp','C:\Windows'
    .NOTES
        Name:     Get-FolderSize
        Author:   Ginger Ninja
        Version:  0.1.1 | Last Edit: 2022-06-02 (Justin Johns)
        - 1.0 - Updated object creation, removed try/catch that was causing issues
        - 0.5 - Just created!
        Comments: <Comment(s)>
        General notes
        https://www.gngrninja.com/script-ninja/2016/5/24/powershell-calculating-folder-sizes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, Position = 0, HelpMessage = 'Base path')]
        [System.String[]] $Path = 'C:\',

        [Parameter(Mandatory = $false, Position = 1, HelpMessage = 'Folder name to get size')]
        [System.String[]] $FolderName = 'all',

        [Parameter(Mandatory = $false, HelpMessage = 'Folder to omit')]
        [System.String[]] $OmitFolder,

        [Parameter(Mandatory = $false, HelpMessage = 'Print running total of all folder sizes')]
        [System.Management.Automation.SwitchParameter] $AddTotal
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # Get a list of all the directories in the base path we're looking for.
        $whereClause = if ($FolderName -eq 'all') { { $_.FullName -notin $OmitFolder } }
        else { { ($_.BaseName -like $FolderName) -and ($_.FullName -notin $OmitFolder) } }

        $allFolders = Get-ChildItem $Path -Directory -Force | Where-Object $whereClause

        # Create array to store folder objects found with size info.
        $folderList = [System.Collections.ArrayList]::new()
    }
    Process {
        # Go through each folder in the base path.
        foreach ($folder in $allFolders) {

            # Clear out the variables used in the loop.
            $fullPath = $null
            $folderObject = $null
            $folderSize = $null
            $folderSizeInMB = $null
            $folderSizeInGB = $null
            $folderBaseName = $null

            # Store the full path to the folder and its name in separate variables
            $fullPath = $folder.FullName
            $folderBaseName = $folder.BaseName

            Write-Verbose "Working with [$fullPath]..."

            # Get folder info / sizes
            $folderSize = Get-Childitem -Path $fullPath -Recurse -Force -ErrorAction 0 | Measure-Object -Property Length -Sum -ErrorAction 0

            # We use the string format operator here to show only 2 decimals, and do some PS Math.
            $folderSizeInMB = '{0:N2} MB' -f ($folderSize.Sum / 1MB)
            $folderSizeInGB = '{0:N2} GB' -f ($folderSize.Sum / 1GB)

            # Here we create a custom object that we'll add to the array
            $folderObject = [PSCustomObject] @{
                FolderName    = $folderBaseName
                'Size(Bytes)' = $folderSize.Sum
                'Size(MB)'    = $folderSizeInMB
                'Size(GB)'    = $folderSizeInGB
            }

            # Add the object to the array
            $folderList.Add($folderObject) | Out-Null
        }
    }
    End {
        if ($PSBoundParameters.ContainsKey('AddTotal')) {

            $grandTotal = $null

            if ($folderList.Count -GT 1) {

                foreach ($fldr in $folderList) { $grandTotal += $fldr.'Size(Bytes)' }

                $totalFolderSizeInMB = '{0:N2} MB' -f ($grandTotal / 1MB)
                $totalFolderSizeInGB = '{0:N2} GB' -f ($grandTotal / 1GB)

                $folderObject = [PSCustomObject] @{
                    FolderName    = 'GrandTotal'
                    'Size(Bytes)' = $grandTotal
                    'Size(MB)'    = $totalFolderSizeInMB
                    'Size(GB)'    = $totalFolderSizeInGB
                }

                # Add the object to the array
                $folderList.Add($folderObject) | Out-Null
            }
        }

        # Return the object array with the objects selected in the order specified.
        $folderList
    }
}