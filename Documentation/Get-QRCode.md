# Get-QRCode

## SYNOPSIS
Generate QR code

## SYNTAX

```
Get-QRCode [-URL] <Uri> [-ApiKey] <String> [<CommonParameters>]
```

## DESCRIPTION
Generate QR code from URI

## EXAMPLES

### EXAMPLE 1
```
Get-QRCode -URL 'https://www.google.com'
Generate QR code for 'https://www.google.com'
```

## PARAMETERS

### -URL
URL to generate QR code

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
Name: Get-QRCode
Author: Justin Johns
Version: 0.1.0 | Last Edit: 2024-01-28 \[0.1.0\]
- 0.1.0 - Initial version
General notes
https://onesimpleapi.com/docs/qr-code

## RELATED LINKS
