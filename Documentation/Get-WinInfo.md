# Get-WinInfo

## SYNOPSIS
Get Windows information

## SYNTAX

### __list (Default)
```
Get-WinInfo [-List] [<CommonParameters>]
```

### __info
```
Get-WinInfo -Id <Int32> [-ComputerName <String>] [<CommonParameters>]
```

## DESCRIPTION
Get Windows information using WMI and CIM

## EXAMPLES

### EXAMPLE 1
```
Get-WinInfo -List
List available classes to pull information from
```

## PARAMETERS

### -List
List available classes

```yaml
Type: SwitchParameter
Parameter Sets: __list
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Id of class object

```yaml
Type: Int32
Parameter Sets: __info
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputerName
Name of target host

```yaml
Type: String
Parameter Sets: __info
Aliases: CN

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.Object.
## NOTES
Name:     Get-WinInfo
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2023-11-22
- 0.1.1 - Usability updates
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes
https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance

## RELATED LINKS
