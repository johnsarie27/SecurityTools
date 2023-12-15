# Get-AlternateDataStream

## SYNOPSIS
Get alternate data streams

## SYNTAX

```
Get-AlternateDataStream [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get alternate data streams

## EXAMPLES

### EXAMPLE 1
```
Get-AlternateDataStream -Path .\*.db
```

Path                 Stream     Size
----                 ------     ----
C:\work\inventory.db LastUpdate   22
C:\work\tickle.db    LastUpdate   22
C:\work\vm.db        secret       18

Gets alternate data streams from all files in current directory with extension .db

## PARAMETERS

### -Path
File path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *.*
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
Name:     Get-AlternateDataStream
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2022-10-23
- 0.1.0 - Initial version
Comments: Taken from Jeff Hicks website below

General notes:
https://jdhitsolutions.com/blog/scripting/8888/friday-fun-with-powershell-and-alternate-data-streams/

Zone.Identifiers
0 = Local computer
1 = Local intranet
2 = Trusted sites
3 = Internet
4 = Restricted sites

## RELATED LINKS
