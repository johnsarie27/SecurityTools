# ConvertTo-MarkdownTable

## SYNOPSIS
Convert array of objects to Markdown table

## SYNTAX

```
ConvertTo-MarkdownTable [-InputObject] <Object> [<CommonParameters>]
```

## DESCRIPTION
Convert array of objects to Markdown table

## EXAMPLES

### EXAMPLE 1
```
$svc = Get-Service | Select-Object -Property DisplayName, Name, Description
PS C:\> $svc | Select-Object -First 5 | ConvertTo-MarkdownTable
Converts the first 5 services to a Markdown table
```

## PARAMETERS

### -InputObject
Input object.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object.
## OUTPUTS

### None.
## NOTES
Name:     ConvertTo-MarkDownTable
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2022-09-28
- 0.1.0 - Initial version
- 0.1.1 - Added spaces around text
Comments: \<Comment(s)\>
General notes:
https://stackoverflow.com/questions/69010143/convert-powershell-output-to-a-markdown-file

## RELATED LINKS
