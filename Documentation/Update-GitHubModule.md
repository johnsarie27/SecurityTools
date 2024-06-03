# Update-GitHubModule

## SYNOPSIS
Updates a module hosted in GitHub

## SYNTAX

```
Update-GitHubModule [-Name] <String> [-Replace] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Downloads, extracts, and unblocks module files from GitHub release

## EXAMPLES

### EXAMPLE 1
```
Update-GitHubModule -Name 'SecurityTools'
Checks published version is newer than installed. Then downloads SecurityTools module package from GitHub
and extracts & unblocks as a new version.
```

### EXAMPLE 2
```
Update-GitHubModule -Name 'SecurityTools' -Replace
Checks published version is newer than installed. Removes the old version. Then downloads SecurityTools
module package from GitHub and extracts & unblocks the new version.
```

## PARAMETERS

### -Name
Module name

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

### -Replace
Replace current module version

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Name:     Update-GitHubModule
Author:   Justin Johns, Phillip Glodowski
Version:  0.1.1 | Last Edit: 2024-06-03
- 0.1.1 - Add functionality to allow multiple module versions, keeping a 'replace' option
- 0.1.0 - Initial version
Comments:
- This function assumes that currently installed module has the project URI property set correctly

## RELATED LINKS
