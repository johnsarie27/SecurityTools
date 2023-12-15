# Get-Software

## SYNOPSIS
Get all installed software

## SYNTAX

```
Get-Software [[-Name] <String>] [[-ComputerName] <String>] [-ExcludeUsers] [-All] [<CommonParameters>]
```

## DESCRIPTION
Get software inventory from Windows Registry

## EXAMPLES

### EXAMPLE 1
```
Get-Software -All
This returns all properties of the registry keys holding the software inventory
```

## PARAMETERS

### -Name
Software name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputerName
Remote computer name

```yaml
Type: String
Parameter Sets: (All)
Aliases: CN

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ExcludeUsers
Exclude user software registry hive

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: NoUsers

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Return all properties for registry keys

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.Object.
## NOTES
Name:     Get-Software
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2022-12-14
- 0.1.1 - Converted local vars to camel case, removed function alias "gs"
- 0.1.0 - Initial version
General notes:
https://4sysops.com/archives/find-the-product-guid-of-installed-software-with-powershell/

\[Alias('gs')\]

## RELATED LINKS
