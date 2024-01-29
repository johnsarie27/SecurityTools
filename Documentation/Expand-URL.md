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
Expand-URL -URL 'https://tinyurl.com/RedlandsStake' # https://t.co/Q0uEt49I5D
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

### System.Object.
## NOTES
Name: Expand-URL
Author: Justin Johns
Version: 0.1.0 | Last Edit: 2024-01-28 \[0.1.1\]
- 0.1.1 - (2024-01-28) Moved query arguments to the request body
- 0.1.0 - (2022-01-10) Initial version
General notes
https://onesimpleapi.com/docs/url-unshorten

## RELATED LINKS
