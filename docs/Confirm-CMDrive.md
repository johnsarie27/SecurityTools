---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Confirm-CMDrive

## SYNOPSIS
Validate PSDrive

## SYNTAX

```
Confirm-CMDrive [-PSDrive] <String> [<CommonParameters>]
```

## DESCRIPTION
Validate PSDrive

## EXAMPLES

### Example 1
```powershell
PS C:\> Confirm-CMDrive -PSDrive 764
```

Returns true if PSDrive 764 exists and is of type CMSite. Returns false otherwise

## PARAMETERS

### -PSDrive
PS Drive name

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
