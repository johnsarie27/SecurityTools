---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-UncPath

## SYNOPSIS
Convert a relative path to a UNC path

## SYNTAX

```
Get-UncPath [-Path] <String> [[-ComputerName] <String>] [-Unix] [<CommonParameters>]
```

## DESCRIPTION
Convert a relative path to a UNC path

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-UncPath -Path C:\Users
```

Convert C:\Users to a UNC path

## PARAMETERS

### -ComputerName
Targer server hostname

```yaml
Type: String
Parameter Sets: (All)
Aliases: HostName, CN, Computer, Host, Target

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Local path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Unix
Use UNUX-style path

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

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

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
