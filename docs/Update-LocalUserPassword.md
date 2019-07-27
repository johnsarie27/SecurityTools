---
external help file: UtilityFunctions-help.xml
Module Name: UtilityFunctions
online version:
schema: 2.0.0
---

# Update-LocalUserPassword

## SYNOPSIS
Change the password for a local user

## SYNTAX

### input (Default)
```
Update-LocalUserPassword -UserName <String> -SecurePassword <SecureString> [-ComputerName <String[]>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### stored
```
Update-LocalUserPassword -UserName <String> [-ComputerName <String[]>] -FilePath <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function updates the password for a Windows local user account on one or more systems.

## EXAMPLES

### Example 1
```powershell
PS C:\> Update-LocalUserPassword -User JSmith -CN $Servers
```

Change the password for user JSmith on all systems in array $Servers. This will prompt for the new password as Secure String.

## PARAMETERS

### -ComputerName
Target comuter(s)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Target, CN, System

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
Clixml file containing SecureString

```yaml
Type: String
Parameter Sets: stored
Aliases: Path, File, FP

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurePassword
New password

```yaml
Type: SecureString
Parameter Sets: input
Aliases: Password, PW

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UserName
User account name

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name, User

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Security.SecureString

### System.String[]

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS
