---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Compare-Lists

## SYNOPSIS
Compare 2 lists as input objects or in a CSV file

## SYNTAX

### file (Default)
```
Compare-Lists -Path <String> [<CommonParameters>]
```

### list
```
Compare-Lists -ListA <Object[]> -ListB <Object[]> [<CommonParameters>]
```

## DESCRIPTION
This function will accept a file path parameter for a csv file or two lists of the same object type.
 The script will then validate the file has only 2 columns and output the similarities and differences
 in each lists. If 2 lists are provided, it will validate the object types are equal.

## EXAMPLES

### Example 1
```powershell
PS C:\> Compare-Lists -FilePath C:\List.csv
```

Compare two lists contained within a CSV file with cloumn headings

### Example 2
```powershell
PS C:\> Compare-Lists -ListA $Cats -ListB $Dogs
```

Compare two lists of the same object type

## PARAMETERS

### -ListA
First list of objects for comparisson

```yaml
Type: Object[]
Parameter Sets: list
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
Parameter Sets: list
Aliases: List2, B

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path to a CSV file containing only two columns of strings to be compared to each other. THis parameter should be used alone, not in conjunction with the List parameters.

```yaml
Type: String
Parameter Sets: file
Aliases: FilePath, File, Data, DataFile

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
