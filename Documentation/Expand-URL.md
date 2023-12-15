# Expand-URL

## SYNOPSIS
Expand URL

## SYNTAX

```
Expand-URL [-URL] <Uri> [-ApiKey] <String> [<CommonParameters>]
```

## DESCRIPTION
Expand shortened URL

## EXAMPLES

### EXAMPLE 1
```
Expand-URL -URL http://bitly.com/somethinghere
Show destination URL target for bitly shortened or redirected URL
```

## PARAMETERS

### -URL
URL to expand

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ApiKey
API Key

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
Name: Expand-URL
Author: Justin Johns
Version: 0.1.0 | Last Edit: 2022-01-10 \[0.1.0\]
- \<VersionNotes\> (or remove this line if no version notes)
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
