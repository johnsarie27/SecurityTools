# ConvertFrom-GZipString

## SYNOPSIS
Decompresses a Base64 GZipped string

## SYNTAX

```
ConvertFrom-GZipString [-String] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Decompresses a Base64 GZipped string

## EXAMPLES

### EXAMPLE 1
```
$compressedString | ConvertFrom-GZipString
```

## PARAMETERS

### -String
Base64 encoded GZipped string

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.String.
## NOTES
Name: ConvertFrom-GZipString
Author: Justin Johns
Version: 0.1.1 | Last Edit: 2022-01-27 \[0.1.1\]
- modified parameter to accept array of string
- changed Foreach-Object to foreach command
Comments: \<Comment(s)\>
General notes
https://www.dorkbrain.com/docs/2017/09/02/gzip-in-powershell/

## RELATED LINKS

[ConvertTo-GZipString]()

