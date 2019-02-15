---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Format-ScanReport

## SYNOPSIS
Format multiple scans into a single spreadsheet

## SYNTAX

```
Format-ScanReport [[-SystemScan] <String>] [[-WebScan] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function takes a web scan and system scan report and applies standard filters and columns to each
 for easy review in a single spreadsheet

## EXAMPLES

### Example 1
```powershell
PS C:\> Format-ScanReport -SystemScan $Sys -WebScan $Web
```

Combine results and format for system scans and web scans

## PARAMETERS

### -SystemScan
CSV file for system scan report

```yaml
Type: String
Parameter Sets: (All)
Aliases: SystemPath, SystemFile

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebScan
CSV file for web scan report

```yaml
Type: String
Parameter Sets: (All)
Aliases: WebPath, WebFile

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
