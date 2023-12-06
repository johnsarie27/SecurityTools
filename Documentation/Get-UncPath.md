# Get-UncPath

## SYNOPSIS
Generate UNC path from local or relative path

## SYNTAX

```
Get-UncPath [-Path] <String> [[-ComputerName] <String>] [-Unix] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function accepts a relative path (e.g., C:\Windows\temp) and
returns the UNC version of the same path.

## EXAMPLES

### EXAMPLE 1
```
Get-UncPath -Path 'C:\Temp\Share'
```

### EXAMPLE 2
```
Get-UncPath -Path 'D:\Share' -Unix -ComputerName 'MyServer'
```

## PARAMETERS

### -Path
Local or relative path to be changed into a UNC path.
This should
include the drive letter and full path to the target directory.

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

### -ComputerName
\[ValidateScript({ Test-Connection -ComputerName $_ -Quiet -Count 2 })\]

```yaml
Type: String
Parameter Sets: (All)
Aliases: HostName, CN, Computer, Host, Target

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Unix
This is a switch parameter that will return Unix formatted UNC path.

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.String.
## NOTES

## RELATED LINKS
