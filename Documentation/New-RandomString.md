# New-RandomString

## SYNOPSIS
Get random string

## SYNTAX

```
New-RandomString [[-Length] <Int32>] [[-ExcludeCharacter] <String[]>] [-ExcludeNumber] [-ExcludeLowercase]
 [-ExcludeUppercase] [-ExcludeSpecial] [<CommonParameters>]
```

## DESCRIPTION
Generate a random string

## EXAMPLES

### EXAMPLE 1
```
New-RandomString -Length 20
Generates a random string of 20 characters
```

## PARAMETERS

### -Length
String length (default of 8 characters)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 8
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeCharacter
Exclude specified character

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeNumber
Exclude numbers

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

### -ExcludeLowercase
Exclude lowercase letters

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

### -ExcludeUppercase
Exclude uppercase letters

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

### -ExcludeSpecial
Exclude special characters

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

### None.
## OUTPUTS

### System.String.
## NOTES
Name:     New-RandomString
Author:   Justin Johns
Version:  0.1.4 | Last Edit: 2023-11-17
- 0.1.4 - Using Get-SecureRandom for PS 7.4.0 or above
- 0.1.3 - (2023-11-03) Renamed function to use the proper verb
- 0.1.2 - Fixed special character set
- 0.1.1 - Updated comments
- 0.1.0 - Initial version

General notes:
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-random?view=powershell-7.4
https://learn.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Get-SecureRandom?view=powershell-7.4

## RELATED LINKS
