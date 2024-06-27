# Get-LatestPowerShell

## SYNOPSIS
Short description

## SYNTAX

```
Get-LatestPowerShell [-Architecture] <String> [[-OutputDirectory] <String>] [[-Version] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
Get-LatestPowerShell -Architecture WindowsAmd64
Downloads the latest version of PowerShell for Windows AMD64 to the desktop.
```

## PARAMETERS

### -Architecture
Processor architecture

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

### -OutputDirectory
Output directory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: "$HOME\Desktop"
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Desired version of PowerShell

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### None.
## NOTES
Name:     Get-LatestPowerShell
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-06-27
- Version history is captured in repository commit history
Comments: \<Comment(s)\>

## RELATED LINKS
