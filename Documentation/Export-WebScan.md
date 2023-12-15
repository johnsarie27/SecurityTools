# Export-WebScan

## SYNOPSIS
Export vulnerability report

## SYNTAX

```
Export-WebScan [-Path] <String> [[-OutputDirectory] <String>] [<CommonParameters>]
```

## DESCRIPTION
Export vulnerability report from provided Acunetix XML report

## EXAMPLES

### EXAMPLE 1
```
Export-WebScan -Path C:\myReport.xml
Processes the Acunetix XML report and produces an Excel Spreadsheet of the results
```

## PARAMETERS

### -Path
Path to Acunetix report file in XML format

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputDirectory
Path to output directory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: "$HOME\Desktop"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### None.
## NOTES
General notes

## RELATED LINKS
