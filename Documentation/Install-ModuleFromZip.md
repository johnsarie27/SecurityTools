# Install-ModuleFromZip

## SYNOPSIS
Install module from GitHub download

## SYNTAX

```
Install-ModuleFromZip [-Path] <String> [[-Scope] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Install module from GitHub download

## EXAMPLES

### EXAMPLE 1
```
Install-ModuleFromZip -Path .\SecurityTools.zip
Extracts contents of zip and copies to Windows module directory then removes zip.
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
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2024-01-23
- 0.1.1 - (2024-01-23) Renamed function from Install-ModuleFromPackage, cleanup
- 0.1.0 - (2019-03-13) Initial version
Comments: \<Comment(s)\>
The zip should contain the module folder with the appropriate items inside.

## RELATED LINKS
