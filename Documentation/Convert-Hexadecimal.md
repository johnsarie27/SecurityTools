# Convert-Hexadecimal

## SYNOPSIS
Convert hexadeciaml

## SYNTAX

### __dcm (Default)
```
Convert-Hexadecimal [-Decimal] <String> [<CommonParameters>]
```

### __hex
```
Convert-Hexadecimal [-Hexadecimal] <String> [<CommonParameters>]
```

## DESCRIPTION
Convert from hexadecimal to decimal or decimal to hexadecimal

## EXAMPLES

### EXAMPLE 1
```
Convert-Hexadecimal 4248
Converts decimal value of 4248 to hexadecimal value
```

## PARAMETERS

### -Hexadecimal
Hexadecimal value to convert to decimal

```yaml
Type: String
Parameter Sets: __hex
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Decimal
Decimal value to convert to hexadecimal

```yaml
Type: String
Parameter Sets: __dcm
Aliases:

Required: True
Position: 1
Default value: None
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
Name:     Convert-Hexadecimal
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2022-07-16
- \<VersionNotes\> (or remove this line if no version notes)
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
