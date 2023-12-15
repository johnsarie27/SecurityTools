# Invoke-InfoGraphicScan

## SYNOPSIS
Invoke InfoGraphic scan

## SYNTAX

```
Invoke-InfoGraphicScan [-Path] <String[]> [-DataLine] <Int32> [[-TitleLine] <Int32>] [[-TempPath] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Scan HTML InfoGraphic file by removing variable data, generating hash
for static code, and validating JSON data.

## EXAMPLES

### EXAMPLE 1
```
Invoke-InfoGraphicScan -Path C:\temp\100.html -Line 71
Invoke scan of InfoGraphic and return custom object with hash of static
HTML file code and validation status of report data JSON.
```

## PARAMETERS

### -Path
Path to HTML file

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DataLine
Report data JSON line number

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TitleLine
Report title line number

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 6
Accept pipeline input: False
Accept wildcard characters: False
```

### -TempPath
Temporary directory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: "$env:TEMP\infograph_scan"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.Object.
## NOTES
General notes

## RELATED LINKS
