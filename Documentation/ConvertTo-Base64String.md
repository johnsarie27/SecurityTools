# ConvertTo-Base64String

## SYNOPSIS
Convert a byte array to a base64 encoded string

## SYNTAX

```
ConvertTo-Base64String [-ByteArray] <Byte[]> [<CommonParameters>]
```

## DESCRIPTION
Convert a byte array to a base64 encoded string

## EXAMPLES

### EXAMPLE 1
```
$cert = Get-RemoteSSLCertificate -ComputerName 'example.com'
PS C:\> ConvertTo-Base64String -ByteArray $cert.RawData
Convert the remote SSL certificate byte array to a base64 encoded string
```

### EXAMPLE 2
```
$b64s = ConvertTo-Base64String -ByteArray (Get-RemoteSSLCertificate -ComputerName 'example.com').RawData
PS C:\> $pubCert = @('-----BEGIN CERTIFICATE-----')
PS C:\> $pubCert += for ($i = 0; $i -LT $b64s.Length; $i += 64) { $b64s.Substring($i, 64) }
PS C:\> $pubCert += '-----END CERTIFICATE-----'
Gets the SSL certificate from example.com and converts the raw data to the proper Base64 encoded certificate format
```

## PARAMETERS

### -ByteArray
Byte array

```yaml
Type: Byte[]
Parameter Sets: (All)
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
Name:     ConvertTo-Base64String
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-04-19
- Version history is captured in repository commit history
Comments: \<Comment(s)\>

## RELATED LINKS
