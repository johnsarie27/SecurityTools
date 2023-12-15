# Get-StringHash

## SYNOPSIS
Generate hash

## SYNTAX

```
Get-StringHash [-String] <String> [[-Algorithm] <String>] [<CommonParameters>]
```

## DESCRIPTION
Generate hash from string input

## EXAMPLES

### EXAMPLE 1
```
Get-StringHash -String 'String' -Algorithm SHA256
Generate the SHA256 hash value of "String"
```

## PARAMETERS

### -String
String to has

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Algorithm
Algorithm used to generate hash

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: SHA256
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.String.
## NOTES
General notes

## RELATED LINKS
