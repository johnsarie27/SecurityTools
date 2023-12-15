# ConvertTo-FlatObject

## SYNOPSIS
Flattends a nested object into a single level object

## SYNTAX

```
ConvertTo-FlatObject [-Object] <Object[]> [-Separator <String>] [-Base <Object>] [-Depth <Int16>]
 [-ExcludeProperty <String[]>] [-Path <String[]>] [-OutputObject <IDictionary>] [<CommonParameters>]
```

## DESCRIPTION
Flattends a nested object into a single level object

## EXAMPLES

### EXAMPLE 1
```
<example usage>
Explanation of what the example does
```

## PARAMETERS

### -Object
The object to be flatten

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Separator
The separator used between the recursive property names

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: .
Accept pipeline input: False
Accept wildcard characters: False
```

### -Base
The first index name of an embedded array:
- 1, arrays will be 1 based: \<Parent\>.1, \<Parent\>.2, \<Parent\>.3, …
- 0, arrays will be 0 based: \<Parent\>.0, \<Parent\>.1, \<Parent\>.2, …
- "", the first item in an array will be unnamed and than followed with 1: \<Parent\>, \<Parent\>.1, \<Parent\>.2, …

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Depth
The maximal depth of flattening a recursive property.
Any negative value will result in an unlimited depth and could cause a infinitive loop.

```yaml
Type: Int16
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeProperty
Property to exclude

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputObject
Output Object

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

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
Name:     ConvertTo-FlatObject
Version:  0.1.0 | Last Edit: 2022-08-17
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes
Based on the articles below:
https://powersnippets.com/convertto-flatobject/
https://github.com/EvotecIT/PSSharedGoods/blob/master/Public/Converts/ConvertTo-FlatObject.ps1

## RELATED LINKS
