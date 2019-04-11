---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# New-SummaryScanReport

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### sys
```
New-SummaryScanReport -SystemScan <String> [-ExistingReport <String>] [<CommonParameters>]
```

### sysweb
```
New-SummaryScanReport -SystemScan <String> -WebScan <String> [-ExistingReport <String>] [<CommonParameters>]
```

### all
```
New-SummaryScanReport -SystemScan <String> -WebScan <String> -DatabaseScan <String> [-ExistingReport <String>]
 [<CommonParameters>]
```

### web
```
New-SummaryScanReport -WebScan <String> [-ExistingReport <String>] [<CommonParameters>]
```

### db
```
New-SummaryScanReport -DatabaseScan <String> [-ExistingReport <String>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -DatabaseScan
CSV file for web scan report

```yaml
Type: String
Parameter Sets: all, db
Aliases: DbScan, DatabasePath, DbFile, DS

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExistingReport
Create new Excel spreadsheet file

```yaml
Type: String
Parameter Sets: (All)
Aliases: Aggregate, File, Path

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SystemScan
CSV file for system scan report

```yaml
Type: String
Parameter Sets: sys, sysweb, all
Aliases: SystemPath, SystemFile, SS

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebScan
CSV file for web scan report

```yaml
Type: String
Parameter Sets: sysweb, all, web
Aliases: WebPath, WebFile, WS

Required: True
Position: Named
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
