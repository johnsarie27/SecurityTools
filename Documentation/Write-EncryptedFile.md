# Write-EncryptedFile

## SYNOPSIS
Create encrypted file

## SYNTAX

### __key
```
Write-EncryptedFile -Content <String[]> -Path <String> -Key <String> [<CommonParameters>]
```

### __keybytes
```
Write-EncryptedFile -Content <String[]> -Path <String> -KeyBytes <Byte[]> [<CommonParameters>]
```

## DESCRIPTION
Create encrypted file

## EXAMPLES

### EXAMPLE 1
```
Write-EncryptedFile -Content ($settings | ConvertTo-Json) -Path C:\temp\mySettings -Key 'Password123'
Encrypts user settings in new file mySettings with the encryption key specified
```

## PARAMETERS

### -Content
Data to encrypt

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
Path to new encrypted file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Key
Encryption key

```yaml
Type: String
Parameter Sets: __key
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyBytes
Encryption key in byte array

```yaml
Type: Byte[]
Parameter Sets: __keybytes
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[].
## OUTPUTS

### System.Object.
## NOTES
General notes
This function was written by Tim Curwick in PowerShell Conference Book 2
(minor changes made)

## RELATED LINKS
