---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Format-Disk

## SYNOPSIS
Format or reformat disk

## SYNTAX

## DESCRIPTION
This function accepts a CIM disk object or disk number and reformats the disk by clearing the existing data, creating a new partition, auto-assigning a drive letter, and formatting the partition with NTFS. Partition style can be GPT or MBR based on parameter argument.

## EXAMPLES

### Example 1
```powershell
PS C:\> Format-Disk -Number 2
```

Format disk 2 with GPT partition style and NTFS format

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object[]

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
