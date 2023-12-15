# Get-FileInfo

## SYNOPSIS
Get file information

## SYNTAX

```
Get-FileInfo [-Signature] <String> [<CommonParameters>]
```

## DESCRIPTION
Get file information based on file header bytes from Wikipedia

## EXAMPLES

### EXAMPLE 1
```
Get-FileInfo -Signature '50 4B 03 04'
Get information on a file with signature '50 4B 03 04'
```

## PARAMETERS

### -Signature
File signature

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.Object.
## NOTES
Name:     Get-FileInfo
Author:   Justin Johns
Version:  0.1.2 | Last Edit: 2022-08-23
- 0.1.0 - Initial version
- 0.1.1 - Replaced file with web lookup for file signatures
- 0.1.2 - Added global variable to prevent repeated web requests
Comments: \<Comment(s)\>
General notes
https://en.wikipedia.org/wiki/List_of_file_signatures

## RELATED LINKS
