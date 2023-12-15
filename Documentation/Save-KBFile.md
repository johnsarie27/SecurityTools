# Save-KBFile

## SYNOPSIS
Downloads patches from Microsoft

## SYNTAX

```
Save-KBFile [-Name] <String[]> [[-Path] <String>] [[-FilePath] <String>] [[-Architecture] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Downloads patches from Microsoft

## EXAMPLES

### EXAMPLE 1
```
Save-KBFile -Name KB4057119
Downloads KB4057119 to the current directory. This works for SQL Server or any other KB.
```

### EXAMPLE 2
```
Save-KBFile -Name KB4057119, 4057114 -Path C:\temp
Downloads KB4057119 and the x64 version of KB4057114 to C:\temp. This works for SQL Server or any other KB.
```

### EXAMPLE 3
```
Save-KBFile -Name KB4057114 -Architecture All -Path C:\temp
Downloads the x64 version of KB4057114 and the x86 version of KB4057114 to C:\temp. This works for SQL Server or any other KB.
```

## PARAMETERS

### -Name
The KB name or number.
For example, KB4057119 or 4057119.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The directory to save the file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: .
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
The exact file name to save to, otherwise, it uses the name given by the webserver

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

### -Architecture
Defaults to x64.
Can be x64, x86 or "All"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: X64
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Props to https://keithga.wordpress.com/2017/05/21/new-tool-get-the-latest-windows-10-cumulative-updates/
Adapted for dbatools by Chrissy LeMaire (@cl)
Then adapted again for general use without dbatools
See https://github.com/sqlcollaborative/dbatools/pull/5863 for screenshots
Captured from: https://gist.github.com/potatoqualitee/b5ed9d584c79f4b662ec38bd63e70a2d

## RELATED LINKS
