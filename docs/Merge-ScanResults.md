---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Merge-ScanResults

## SYNOPSIS
Aggregate and merge scan results into a single report

## SYNTAX

```
Merge-ScanResults [-SystemScan] <String> [-WebScan] <String> [<CommonParameters>]
```

## DESCRIPTION
This function takes a web scan and system scan report and merges the pertinent information for an aggreate
 view of the vulnerabilities found

## EXAMPLES

### Example 1
```powershell
PS C:\> Merge-ScanResults -SystemScan $Sys -WebScan $Web
```

Merge and aggregate results for given system scan and web scan

## PARAMETERS

### -SystemScan
CSV file path for system scan report

```yaml
Type: String
Parameter Sets: (All)
Aliases: SystemPath, SystemFile

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebScan
CSV file path for web scan report

```yaml
Type: String
Parameter Sets: (All)
Aliases: WebPath, WebFile

Required: True
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
