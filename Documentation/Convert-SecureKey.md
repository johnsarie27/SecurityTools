# Convert-SecureKey

## SYNOPSIS
Convert string to PSCredential object or store as CliXML

## SYNTAX

### _retrieve (Default)
```
Convert-SecureKey -Path <String> [<CommonParameters>]
```

### _create
```
Convert-SecureKey -Username <String> [-SecurePassword <SecureString>] -DestinationPath <String> [-PassThru]
 [-Force] [<CommonParameters>]
```

## DESCRIPTION
This simple function will either create a PSCredential object and store it
as XML or retrieve a PSCredential object from a Clixml file.

## EXAMPLES

### EXAMPLE 1
```
-- EXAMPLE 1 --
PS C:\> Convert-SecureKey -Username 'Password' -DestinationPath "$HOME\Documents\Creds.xml"
```

### EXAMPLE 2
```
-- EXAMPLE 2 --
PS C:\> Convert-SecureKey -Path C:\Store\Credentials.xml
```

## PARAMETERS

### -Path
Path to CliXML file containing Credential object

```yaml
Type: String
Parameter Sets: _retrieve
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
Username

```yaml
Type: String
Parameter Sets: _create
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurePassword
Password in SecureString type format

```yaml
Type: SecureString
Parameter Sets: _create
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationPath
Path to directory for new credential file

```yaml
Type: String
Parameter Sets: _create
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return new credential object

```yaml
Type: SwitchParameter
Parameter Sets: _create
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Overwrite existing file

```yaml
Type: SwitchParameter
Parameter Sets: _create
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.PSCredential.
## NOTES
It appears that the Clixml file is locked to the user and computer where
it was created.
It cannot be accessed by another user or computer.
The
article below has more information based on a different Cmdlet.
https://www.randomizedharmony.com/blog/2018/11/25/using-credentials-in-production-scripts

## RELATED LINKS
