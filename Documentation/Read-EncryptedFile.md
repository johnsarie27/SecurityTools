# Read-EncryptedFile

## SYNOPSIS
Read encrypted file

## SYNTAX

### __key
```
Read-EncryptedFile -Path <String> -Key <String> [<CommonParameters>]
```

### __keybytes
```
Read-EncryptedFile -Path <String> -KeyBytes <Byte[]> [<CommonParameters>]
```

## DESCRIPTION
Read encrypted file

## EXAMPLES

### EXAMPLE 1
```
Read-EncryptedFile -Path C:\temp\mySettings -Key 'Password123'
Decrypts user settings from file mySettings with the encryption key specified
```

## PARAMETERS

### -Path
Path to encrypted file

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

### None.
## OUTPUTS

### System.Object.
## NOTES
General notes
This function was written by Tim Curwick in PowerShell Conference Book 2
(minor changes made)

## RELATED LINKS
