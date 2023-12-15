# Export-VeracodeReport

## SYNOPSIS
Export vulnerability report

## SYNTAX

```
Export-VeracodeReport [-VeracodeXML] <String> [[-OutputDirectory] <String>] [<CommonParameters>]
```

## DESCRIPTION
Export vulnerability report from provided Veracode XML report

## EXAMPLES

### EXAMPLE 1
```
<example usage>
Explanation of what the example does
```

## PARAMETERS

### -VeracodeXML
XML file for Veracode scan report

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
Path to output directory for new SQL Vulnerability Assessment reports

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

### None.
## OUTPUTS

### None.
## NOTES
General notes

## RELATED LINKS
