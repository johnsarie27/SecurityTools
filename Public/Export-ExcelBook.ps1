function Export-ExcelBook {
    <# =========================================================================
    .SYNOPSIS
        Export data to Microsoft Excel spreadsheet
    .DESCRIPTION
        This function accepts an Array of PSObjects and outputs the NoteProperty
        and Property Member Types to a Microsoft Excel spreadsheet in XLSX format
    .PARAMETER Data
        Input object or Array of objects typically passed to the function through
        the pipeline
    .PARAMETER Path
        Path to new or existing workbook. A new sheet or tab will be added.
    .PARAMETER AutoSize
        Autosize columns to fit values
    .PARAMETER Freeze
        Freeze top row of spredsheet
    .PARAMETER SheetName
        New name for Sheet in Workbook
    .PARAMETER SuppressOpen
        Do not open Excel spreadsheet when done converting
    .INPUTS
        System.Object[].
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Get-Process | Select-Object -First 5 | Export-ExcelBook
        Convert the first 5 processes into an Excel spreadsheet
    .EXAMPLE
        PS C:\> Get-Service | Export-ExcelBook -SheetName 'Services' -Freeze
        Write the Windows Service to an Excel spreadsheet with tab name "Services" and freeze the top row
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    [Alias('ConvertTo-Excel')]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Array of data objects')]
        [ValidateNotNullOrEmpty()]
        [Alias('List')]
        [System.Object[]] $Data,

        [Parameter(HelpMessage = 'Path to new or existing Excel file')]
        [ValidateScript( { Test-Path -Path ([System.IO.Path]::GetDirectoryName($_)) -PathType Container })]
        [Alias('FilePath', 'File', 'DataFile')]
        [string] $Path,

        [Parameter(HelpMessage = 'Autosize columns')]
        [switch] $AutoSize,

        [Parameter(HelpMessage = 'Freeze top row')]
        [switch] $Freeze,

        [Parameter(HelpMessage = 'Custom name for sheet or tab')]
        [ValidateScript({ $_ -match '[\w-]{1,16}' })]
        [string] $SheetName,

        [Parameter(HelpMessage = 'Do not open file after creation')]
        [switch] $SuppressOpen,

        [Parameter(HelpMessage = 'Do not format column headers')]
        [switch] $NoFormatting,

        [Parameter(HelpMessage = 'Start on provided row')]
        [ValidateRange(1,10)]
        [Int32] $StartRow = 1
    )

    Begin {
        # ======================================================================
        # NOTES
        # MAKE SHEET VISIBLE    >> $Exce.Visible = $true
        # CHANGE FONT SIZE      >> $Sheet.Cells.Item($row, $column).Font.Size = 11
        # DELETE SHEET          >> $Workbook.Worksheets.Item('Sheet1').Delete()
        # ======================================================================

        # SET DESTINATION FOLDER
        $DestFolder = "$HOME\Desktop" #$env:TEMP

        # OPEN EXCEL CREATE WORKBOOK AND SHEET
        $Excel = New-Object -ComObject EXCEL.Application

        # IF PATH PARAMETER DECLARED USE PATH, IF NOT, STORE IN TEMP
        if ( $PSBoundParameters.ContainsKey('Path') ) {

            if ( Test-Path -Path $Path -PathType Leaf -Include "*.xlsx" ) {
                # IF THE FILE EXISTS, OPEN THE WORKBOOK AND ADD A NEW WORKSHEET
                $ExistingBook = $true
                $WorkBook = $Excel.Workbooks.Open($Path)
                $Sheet = $WorkBook.Worksheets.Add()
            }
            else {
                # IF THE FILE DOES NOT EXIST, CREATE A NEW WORKBOOK AND USE "SHEET1"
                # THE WORKSHEET WILL BE RENAMED LATER IF PARAMETER ARGUMENT PROVIDED
                $WorkBook = $Excel.Workbooks.Add()
                $Sheet = $WorkBook.Worksheets.Item("Sheet1")
            }
        }
        else {
            $Path = (Join-Path -Path $DestFolder -ChildPath ('{0}.xlsx' -f (Get-Date -F "yyyyMMddTHHmmss")))
            $WorkBook = $Excel.Workbooks.Add()
            $Sheet = $WorkBook.Worksheets.Item("Sheet1")
        }

        # SET STARTROW AS CONSTANT
        Set-Variable -Name SR -Value $StartRow -Option Constant

        # SET ROW VARIABLE
        $CurrentRow = $SR
    }

    Process {
        # ADD OBJECTS
        foreach ( $d in $Data ) {

            # ADD COLUMN HEADERS
            if ( $CurrentRow -eq $SR ) {
                # GET COLUMNS FROM PROPERTIES AND NOTEPROPERTIES
                $Columns = $d | Get-Member -MemberType NoteProperty, Property

                # VALIDATE OBJECTS
                if ( -not $d ) { Throw "Invalid input object" }

                foreach ( $C in $Columns ) {
                    $Sheet.Cells.Item($CurrentRow, ([array]::IndexOf($Columns, $C) + 1)) = $C.Name
                }
                $CurrentRow++
            }

            # ADD DATA ROW BY ROW (OBJECT BY OBJECT)
            foreach ( $i in (1..$Columns.Count) ) {
                $Sheet.Cells.Item($CurrentRow, $i) = $d.($Columns[($i - 1)].Name)
            }
            $CurrentRow++

            <# # COLUMN BY COLUMN -- THIS WON'T WORK WHEN PASSING IN OBJECTS BY PIPELINE
            $CurrentRow..($CurrentRow + $Data.Count) #>
        }
    }

    End {
        # GET HEADER RANGE
        $AlphabetList = foreach ( $i in (0..25) ) { [char](65 + $i) }
        $HeaderRange = $Sheet.Range( ('a{0}' -f $SR), ('{0}{1}' -f $AlphabetList[($Columns.Count - 1)], $SR) )

        # CHECK FOR NOFORMATTING
        if ( !$PSBoundParameters.ContainsKey('NoFormatting') ) {
            # ADD COLUMN FILTERS
            $HeaderRange.AutoFilter() | Out-Null

            # BOLD AND CENTER COLUMN HEADERS
            $HeaderRange.Font.Bold = $true
            $HeaderRange.HorizontalAlignment = -4108
        }

        # AUTOSIZE COLUMNS
        if ($PSBoundParameters.ContainsKey('AutoSize') ) { $($Sheet.UsedRange).EntireColumn.AutoFit() | Out-Null }

        # FREEZE TOP ROW
        if ( $PSBoundParameters.ContainsKey('Freeze') ) {
            $Sheet.Select()
            $Sheet.Application.ActiveWindow.SplitRow = $SR
            $Sheet.Application.ActiveWindow.SplitColumn = 0
            $Sheet.Application.ActiveWindow.FreezePanes = $true
        }

        # RENAME SHEET
        if ( $PSBoundParameters.ContainsKey('SheetName') ) { $Sheet.Name = $SheetName }

        # SAVE WORKBOOK AND CLOSE EXCEL
        if ( $ExistingBook ) { $WorkBook.Save() } else { $WorkBook.SaveAs($Path) }
        $Excel.Quit()

        # GET FILE PATH AND OPEN SPREADSHEET
        if ( -not $PSBoundParameters.ContainsKey('SuppressOpen') ) { Invoke-Item -Path $Path }
    }
}
