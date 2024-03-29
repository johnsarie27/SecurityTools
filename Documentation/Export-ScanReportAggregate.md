# Export-ScanReportAggregate

## SYNOPSIS
Aggregate and merge scan results into a single report

## SYNTAX

```
Export-ScanReportAggregate [[-OutputDirectory] <String>] [[-NessusSystemScan] <String>]
 [[-NessusWebScan] <String>] [[-AlertLogicWebScan] <String>] [[-DatabaseScan] <String>]
 [[-AcunetixScan] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function takes a web scan and system scan report and applies
standard filters and columns to each for easy review in a single
spreadsheet with multiple tabs.

## EXAMPLES

### EXAMPLE 1
```
Export-ScanReportAggregate -SystemScan $Sys -AlertLogicWebScan $Web
Merge and aggregate data from $Sys and $Web scans into a pre-filtered
report for easy review.
```

## PARAMETERS

### -OutputDirectory
Path to output directory

```yaml
Type: String
Parameter Sets: (All)
Aliases: DestinationPath

Required: False
Position: 1
Default value: "$HOME\Desktop"
Accept pipeline input: False
Accept wildcard characters: False
```

### -NessusSystemScan
Path to CSV file for Nessus system scan report

```yaml
Type: String
Parameter Sets: (All)
Aliases: NessusScan

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NessusWebScan
Path to CSV file for Nessus web scan report

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

### -AlertLogicWebScan
Path to CSV file for AlertLogic web scan report

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseScan
Path to XLSX file for SQL scan report

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AcunetixScan
Path to CSV file for Acunetix scan report

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String. Format-ScanResults accepts string values for SystemScan
### and AlertLogicWebScan parameters.
## OUTPUTS

### Com.Excel.Application. Format-ScanResults returns an Excel spreadsheet
## NOTES

## RELATED LINKS
