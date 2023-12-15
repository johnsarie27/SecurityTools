# Uninstall-AllModules

## SYNOPSIS
Uninstall all dependent modules

## SYNTAX

```
Uninstall-AllModules [-TargetModule] <String> [-Version] <String> [[-Force] <String>] [[-WhatIf] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Uninstall a module and all dependent modules

## EXAMPLES

### EXAMPLE 1
```
Uninstall-AllModules -TargetModule AzureRM -Version 4.4.1 -Force
Remove an older version of Azure PowerShell.
```

## PARAMETERS

### -TargetModule
TargetModule

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Version

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Force

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
WhatIf

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### None.
## NOTES
This function was written by Microsoft.
See link above for details.
https://docs.microsoft.com/en-us/powershell/azure/uninstall-azurerm-ps?view=azurermps-6.13.0

## RELATED LINKS
