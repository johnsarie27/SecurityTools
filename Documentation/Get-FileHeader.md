# Get-FileHeader

## SYNOPSIS
Get file header

## SYNTAX

```
Get-FileHeader [-Path] <String> [[-Bytes] <Int16>] [<CommonParameters>]
```

## DESCRIPTION
Get the desired number of bytes (starting from the beginning) of a file
(a.k.a., magic numbers)

## EXAMPLES

### EXAMPLE 1
```
Get-FileHeader -Path "C:\myFile.xlsx"
Returns the first 4 bytes as hex
```

## PARAMETERS

### -Path
File path

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

### -Bytes
Number of bytes

```yaml
Type: Int16
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 4
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
Name:     Get-FileHeader
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2022-08-23
- 0.1.0 - Initial version
- 0.1.1 - Added parameter for number of bytes to return
Comments: \<Comment(s)\>
General notes
https://stackoverflow.com/questions/26194071/recognize-file-types-in-powershell

## RELATED LINKS
