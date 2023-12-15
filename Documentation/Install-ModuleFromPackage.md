# Install-ModuleFromPackage

## SYNOPSIS
Install module from GitHub download

## SYNTAX

```
Install-ModuleFromPackage [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Install module from GitHub download

## EXAMPLES

### EXAMPLE 1
```
Install-ModuleFromPackage -Path .\SecurityTools.zip
Extracts contents of zip and copies to Windows module directory then removes zip.
```

## PARAMETERS

### -Path
Path to zip file

```yaml
Type: String
Parameter Sets: (All)
Aliases: DataFile, File

Required: True
Position: 1
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
General notes

## RELATED LINKS
