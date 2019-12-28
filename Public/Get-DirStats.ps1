function Get-DirStats {
    <# =========================================================================
    .SYNOPSIS
        Show directory statistics for a given directory
    .DESCRIPTION
        This function will display all files and folders in a given directory
        that are greater than or equal to a given size in GB. The defaul is
        1GB.
    .PARAMETER Path
        Target folder for statistics
    .PARAMETER SizeInGb
        Threshold for which to measure file and folder sizes.
    .PARAMETER Totals
        Calculate totals for file sizes and number of files in folders
    .PARAMETER All
        Measure all files of any size
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-DirStats -Path C:\MyData -SizeInGb 4
    ========================================================================= #>
    Param(
        [Parameter(Mandatory, HelpMessage = 'Directory to evaluate')]
        [ValidateScript( {Test-Path -Path $_ -PathType Container})]
        [string] $Path,

        [Parameter(HelpMessage = 'Minimum file size to search for')]
        [ValidateRange(0, 10)]
        [double] $SizeInGb = 1,

        [Parameter(HelpMessage = 'Show totals at end')]
        [switch] $Totals,

        [Parameter(HelpMessage = 'Measure all files of any size')]
        [switch] $All
    )

    Begin {
        # CREATE VARS
        $fileList = [System.Collections.Generic.List[System.Object]]::new()
        $folderList = [System.Collections.Generic.List[System.Object]]::new()
        if ( $PSBoundParameters.ContainsKey('All') ) { $SizeInGb = 0 }
    }

    Process {
        #region GET FILE SIZES
        # LOOP THROUGH ALL ITEMS IN PATH
        foreach ( $file in (Get-ChildItem -Path $Path -Recurse -Force -ErrorAction 0 -ErrorVariable 'EV') ) {
            # IF SIZE MATCH ADD TO COLLECTION
            if ( ($file.Length / 1GB) -GT $SizeInGb ) {
                try { $fileList.Add($file) }
                catch { Write-Verbose ('Unable to add file {0}' -f $file.Name) }
            }

            # SET WARNING
            if ( $EV ) { $warning = $true }
        }

        # SET PROPERTIES
        $properties = @( @{N = 'Size(GB)'; E = { ($_.Length / 1GB).ToString("0.00") } }, 'FullName' ) #'Directory', 'Name'

        # GET SELECT PROPERTIES
        [System.Collections.Generic.List[System.Object]] $fileList = $fileList | Select-Object -Property $properties
        #endregion

        #region GET FOLDER SIZES
        <# # LOOP THROUGH ALL DIRECTORIES IN PATH
        foreach ( $item in (Get-ChildItem -Path $Path -Directory -Force) ) {
            # GET CHILD MEASUREMENTS FOR FOLDER
            $folder = Get-ChildItem -Path $item.FullName -Recurse -Force -ErrorAction 0 -ErrorVariable EV |
            Measure-Object -Property Length -Sum -ErrorAction 0 -ErrorVariable MO

            # SET WARNING VARIABLE
            if ( $EV -or $MO ) { $warning = $true }

            # EVALUATE FOLDER SIZE
            if ( ($folder.Sum / 1GB) -gt $SizeInGb ) {
                # CREATE NEW OBJECT
                $New = [PSCustomObject] @{
                    Files      = $folder.Count
                    'Size(GB)' = ($folder.Sum / 1GB).ToString("0.00")
                    FolderName = $item.Name
                }

                # ADD NEW OBJECT TO COLLECTION
                try { $folderList.Add($New) } catch { }
            }
        } #>
        #endregion

        #region NEW STUFF
        # LOOP ALL SUB-DIRECTORIES IN ORIGINAL PATH
        foreach ( $item in (Get-ChildItem -Path $Path -Directory -Force) ) {
            # SET VARS
            $count = 0; $sizeTotal = 0

            # LOOP ALL OBJECTS IN EACH DIRECTORY
            foreach ( $i in (Get-ChildItem -Path $item.FullName -Recurse -Force -ErrorAction 0) ) {
                # ADD FILES
                $count++ ; $sizeTotal += $i.Length
            }

            # GET TOTAL SIZE
            $ST = ($sizeTotal / 1GB).ToString("0.00")

            # ADD NEW OBJECT TO COLLECTION
            if ( $ST -ge $SizeInGb ) {
                $New = [PSCustomObject] @{
                    Files      = $count
                    'Size(GB)' = $ST
                    FolderName = $item.Name
                }
                try { $folderList.Add($New) }
                catch { Write-Verbose ('Unable to add object {0}' -f $New) }
            }
        }
        #endregion

        # ADD TOTALS
        if ( $Totals ) {
            # CREATE SIZE AND COUNT VARIABLES
            $fileTotal = 0; $fileCount = 0; $folderNumTotal = 0; $folderSizeTotal = 0

            # LOOP THROUGH ALL FILE OBJECTS
            foreach ( $item in $fileList ) {
                $fileTotal += $item.'Size(GB)'
                $fileCount++
            }
            $New = [PSCustomObject] @{
                'Size(GB)' = $fileTotal
                'FullName' = '--- Totals ---'
            }
            try { $fileList.Add($New) }
            catch { Write-Verbose ('Unable to add object {0}' -f $New) }

            # LOOP THROUGH ALL FOLDER OBJECTS
            foreach ( $item in $folderList ) {
                $folderNumTotal += $item.Files
                $folderSizeTotal += $item.'Size(GB)'
            }
            $New = [PSCustomObject] @{
                'Size(GB)'   = $folderSizeTotal
                'Files'      = $folderNumTotal
                'FolderName' = '--- Totals ---'
            }
            try { $folderList.Add($New) }
            catch { Write-Verbose ('Unable to add object {0}' -f $New) }
        }
    }

    End {
        # RETURN RESULTS
        $dir = (Get-Item $Path -Force).FullName
        Write-Output `n"Directory: $dir"`n
        if ( $fileList ) {
            Write-Output "Files greater than: $SizeInGb GB"
            Write-Output ( $fileList | Format-Table -AutoSize | Out-String )
        }
        if ( $folderList ) {
            Write-Output "Folders greater than: $SizeInGb GB"
            Write-Output ( $folderList | Format-Table -AutoSize | Out-String )
        }
        if ( $warning ) { Write-Warning "One or more directories was not accessible!" }
    }
}
