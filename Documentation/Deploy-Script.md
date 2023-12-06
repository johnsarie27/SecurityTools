---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Deploy-Script

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
Deploy-Script [-ComputerName] <String[]> [-ScriptPath] <String> [[-ArgumentList] <String[]>]
 [-OutputPath] <String> [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ArgumentList
Argument list

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Args

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputerName
Target computer(s)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: CN, Target, Host

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
Export path for resutls

```yaml
Type: String
Parameter Sets: (All)
Aliases: Output, Export

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptPath
Script to execute on remote system

```yaml
Type: String
Parameter Sets: (All)
Aliases: FilePath, File, Script, Path

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
