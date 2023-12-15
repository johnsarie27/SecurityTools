# Get-Encoded

## SYNOPSIS
Encode string to Base64 or URL encoding

## SYNTAX

```
Get-Encoded [-String] <String> [[-Encoding] <String>] [<CommonParameters>]
```

## DESCRIPTION
Encode string to Base64 or URL encoding

## EXAMPLES

### EXAMPLE 1
```
Get-Encoded -String 'https://google.com/' -Encoding URL
URL encode 'https://google.com/'
```

## PARAMETERS

### -String
Plain text string

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

### -Encoding
Encoding type (Base64 or URL)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Base64
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
Name: Get-Encoded
Author: Justin Johns
Version: 0.1.1 | Last Edit: 2022-01-11 \[0.1.1\]
- Changed class used to perform URL encoding
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
