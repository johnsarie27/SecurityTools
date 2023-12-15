# Export-SQLVAReportAggregate

## SYNOPSIS
Aggregate results from SQL Vulnerability Assessment scans

## SYNTAX

### folder (Default)
```
Export-SQLVAReportAggregate -InputPath <String> [-DestinationPath <String>] [-PassThru] [<CommonParameters>]
```

### zip
```
Export-SQLVAReportAggregate -ZipPath <String> [-DestinationPath <String>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Aggregate results from SQL Vulnerability Assessment scans into a single report

## EXAMPLES

### EXAMPLE 1
```
Export-SQLVAReportAggregate -InputPath (Get-ChildItem C:\MyScans).FullName
Combine all scans in C:\MyScans folder into a single report and output to the desktop.
```

## PARAMETERS

### -InputPath
Path to directory of SQL Vulnerability Assessemnt file(s)

```yaml
Type: String
Parameter Sets: folder
Aliases: IP, Directory

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ZipPath
Path to zip file containing repots

```yaml
Type: String
Parameter Sets: zip
Aliases: Zip, ZP

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationPath
Path to output report file

```yaml
Type: String
Parameter Sets: (All)
Aliases: DP

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return report path

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.String.
## NOTES
General notes

## RELATED LINKS
