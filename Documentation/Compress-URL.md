# Compress-URL

## SYNOPSIS
Compress URL

## SYNTAX

```
Compress-URL [-URL] <Uri> [-ApiKey] <String> [<CommonParameters>]
```

## DESCRIPTION
Get shortened URL

## EXAMPLES

### EXAMPLE 1
```
Compress-URL -URL 'https://www.google.com'
Get a shortened URL for 'https://www.google.com'
```

## PARAMETERS

### -URL
URL to compress

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

### System.Object.
## NOTES
Name: Compress-URL
Author: Justin Johns
Version: 0.1.0 | Last Edit: 2024-01-28
- 0.1.0 - (2024-01-28) Initial version
General notes
https://onesimpleapi.com/docs/url-shortener

## RELATED LINKS
