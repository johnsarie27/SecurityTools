# Expand-GZip

## SYNOPSIS
Expand GZip compressed file

## SYNTAX

```
Expand-GZip [-Path] <String> [[-DestinationPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Expand GZip compressed file

## EXAMPLES

### EXAMPLE 1
```
Expand-GZip -Path C:\E3IU1BL3AWXV9B.2023-10-30-21.b3052b06.gz
Extracts file to C:\E3IU1BL3AWXV9B.2023-10-30-21.b3052b06
```

## PARAMETERS

### -Path
Path to GZip file

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

### -DestinationPath
Destination path to extract file to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: ($Path -replace '\.gz$', '')
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
Name:     Expand-GZip
Author:   RiffyRiot
Version:  0.1.0 | Last Edit: 2023-10-30
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes:
https://social.technet.microsoft.com/Forums/windowsserver/en-US/5aa53fef-5229-4313-a035-8b3a38ab93f5/unzip-gz-files-using-powershell?forum=winserverpowershell

## RELATED LINKS
