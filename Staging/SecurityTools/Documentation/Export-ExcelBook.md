---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Export-ExcelBook

## SYNOPSIS
Export data to Microsoft Excel spreadsheet

## SYNTAX

```
Export-ExcelBook [-Data] <Object[]> [[-Path] <String>] <String>] [-AutoSize] [-Freeze]
 [[-SheetName] <String>] [-SuppressOpen] [<CommonParameters>]
```

## DESCRIPTION
This function accepts an Array of PSObjects and outputs the NoteProperty and Property Member Types to a Microsoft Excel spreadsheet in XLSX format

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-Process | Select-Object -First 5 | Export-ExcelBook
```

Convert the first 5 processes into an Excel spreadsheet

### Example 2
```powershell
PS C:\> Get-Service | Export-ExcelBook -SheetName 'Services' -Freeze
```

Write the Windows Service to an Excel spreadsheet with tab name "Services" and freeze the top row

## PARAMETERS

### -Data
Array of data objects

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: List

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
Path to new or existing Excel file

```yaml
Type: String
Parameter Sets: (All)
Aliases: FilePath, File, DataFile

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoSize
Autosize columns

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Freeze
Freeze top row

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SheetName
Custom name for sheet or tab

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SuppressOpen
Do not open file after creation

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object[]

## OUTPUTS

## NOTES

## RELATED LINKS