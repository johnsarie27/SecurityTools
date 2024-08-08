# Uninstall-MSI

## SYNOPSIS
Uninstall existing MSI application

## SYNTAX

```
Uninstall-MSI [-ProductId] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Uninstall existing MSI application

## EXAMPLES

### EXAMPLE 1
```
Uninstall-MSI -ProductId '109A5A16-E09E-4B82-A784-D1780F1190D6'
Remove installed package with ID '{109A5A16-E09E-4B82-A784-D1780F1190D6}'
```

## PARAMETERS

### -ProductId
Product ID

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### None.
## NOTES
Name:     Uninstall-MSI
Author:   Justin Johns
Version:  0.1.2 | Last Edit: 2024-08-08
Comments: (see commit history)
General notes

## RELATED LINKS
