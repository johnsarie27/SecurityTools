# Get-RSOP

## SYNOPSIS
Generate a Resultant Set of Policy report

## SYNTAX

```
Get-RSOP [-Path] <String> [[-Computer] <String>] [[-ReportType] <String>] [<CommonParameters>]
```

## DESCRIPTION
Generate a Resultant Set of Policy report

## EXAMPLES

### EXAMPLE 1
```
Get-RSOP
Generate a Resultant Set of Policy report for the local system
```

## PARAMETERS

### -Path
Path to report file

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

### -Computer
Target computer name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ReportType
Report type output

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: HTML
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
THIS FUNCTION REQUIRES MODULE GroupPolicy

## RELATED LINKS
