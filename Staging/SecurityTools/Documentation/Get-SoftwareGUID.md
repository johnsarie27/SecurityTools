---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-SoftwareGUID

## SYNOPSIS
Retrieves a list of all software installed

## SYNTAX

```
Get-SoftwareGUID [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves a list of all software installed

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-SoftwareGUID
```

This example retrieves all software installed on the local computer

## PARAMETERS

### -Name
Software name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
