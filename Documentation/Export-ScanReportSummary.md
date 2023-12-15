# Export-ScanReportSummary

## SYNOPSIS
Summarize scan results into a single report

## SYNTAX

```
Export-ScanReportSummary [[-DestinationPath] <String>] [[-NessusSystemScan] <String>]
 [[-NessusWebScan] <String>] [[-AlertLogicWebScan] <String>] [[-DatabaseScan] <String>]
 [[-AcunetixScan] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function takes a web scan and system scan report and merges the
pertinent information into a summary view of the vulnerabilities found

## EXAMPLES

### EXAMPLE 1
```
Export-ScanReportSummary -NessusSystemScan $Sys -AlertLogicWebScan $Web
Merge and aggregate data from $Sys and $Web scans and return an Excel
spreadsheet file.
```

## PARAMETERS

### -DestinationPath
Path to new or existing Excel spreadsheet file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
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
Path to CSV file for AlertLogic Web scan report

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
Path to XLSX file for MSSQL scan report

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

### None.
## OUTPUTS

### None.
## NOTES

## RELATED LINKS
