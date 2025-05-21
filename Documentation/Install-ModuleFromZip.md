# Install-ModuleFromZip

## SYNOPSIS
Install module from GitHub download

## SYNTAX

```
Install-ModuleFromZip [-Path] <String> [[-Scope] <String>] [-Replace] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Install module from GitHub download

## EXAMPLES

### EXAMPLE 1
```
Install-ModuleFromZip -Path .\SecurityTools.zip
Extracts contents of zip and copies to Windows module directory then removes zip.
Other versions of the same module are left in place.
```

### EXAMPLE 2
```
Install-ModuleFromZip -Path .\SecurityTools.zip -Replace
Extracts contents of zip and copies to Windows module directory then removes zip.
Removes other versions of the same module.
```

## PARAMETERS

### -Path
Path to zip file

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

### -Scope
Module scope

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: CurrentUser
Accept pipeline input: False
Accept wildcard characters: False
```

### -Replace
Replace current module version

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
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
Name:     Install-ModuleFromZip
Author:   Justin Johns, Phillip Glodowski
Version:  0.1.5 | Last Edit: 2024-10-10
Comments: (see commit history)
The zip should contain the module folder with the appropriate items inside.

## RELATED LINKS
