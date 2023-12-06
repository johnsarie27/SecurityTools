---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Convert-SecureKey

## SYNOPSIS
Convert string to PSCredential object or store as CliXML

## SYNTAX

### create (Default)
```
Convert-SecureKey [-Create] [-Password <SecureString>] [<CommonParameters>]
```

### retrieve
```
Convert-SecureKey [-Retrieve] [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION
This simple function will either create a PSCredential object and store it as XML or retrieve a PSCredential object
 from a Clixml file.

## EXAMPLES

### Example 1
```powershell
PS C:\> Convert-SecureKey -Create
```

Create a Secure String object

### Example 2
```powershell
PS C:\> Convert-SecureKey -Create -Password ('SuperSecure' | ConvertTo-SecureString -AsPlainText -Force)
```

Convert string variable to Secure String object then write the object to a CliXml file

## PARAMETERS

### -Create
Create CliXML object with SecureString object

```yaml
Type: SwitchParameter
Parameter Sets: create
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Password in SecureString type format

```yaml
Type: SecureString
Parameter Sets: create
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
Path to CliXML file containing SecureString object password

```yaml
Type: String
Parameter Sets: retrieve
Aliases: File

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Retrieve
Retrieve SecureString object in CliXML file and convert to string

```yaml
Type: SwitchParameter
Parameter Sets: retrieve
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SavePath
Path to save new CliXML object

```yaml
Type: String
Parameter Sets: create
Aliases: Folder

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Security.SecureString

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
