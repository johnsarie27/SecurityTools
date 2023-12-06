# Compare-Lists

## SYNOPSIS
Compare 2 lists as input objects or in a CSV file.

## SYNTAX

### __list (Default)
```
Compare-Lists -ListA <Object[]> -ListB <Object[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### __file
```
Compare-Lists -Path <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function will accept a file path parameter for a csv file or two lists
of the same object type.
The script will then validate the file has only 2
columns and output the similarities and differences in each lists.
If 2
lists are provided, it will validate the object types are equal.

## EXAMPLES

### EXAMPLE 1
```
Compare-Lists -FilePath C:\List.csv
```

### EXAMPLE 2
```
Compare-Lists -ListA $ListA -ListB $ListB
```

## PARAMETERS

### -Path
Path to a CSV file containing only two columns of strings to
be compared to each other.
This parameter should be used alone, not in
conjunction with the List parameters.

```yaml
Type: String
Parameter Sets: __file
Aliases: FilePath, File, Data, DataFile

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListA
First list of objects for comparisson

```yaml
Type: Object[]
Parameter Sets: __list
Aliases: List1, A

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListB
Second list which will be compared to the first

```yaml
Type: Object[]
Parameter Sets: __list
Aliases: List2, B

Required: True
Position: Named
Default value: None
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

### System.Object.
## OUTPUTS

### System.Object.
## NOTES
Remove $compSheet section and have use Import-Csv with two lists?

## RELATED LINKS
