# Get-FolderSize

## SYNOPSIS
Returns the size of folders in MB and GB.

## SYNTAX

```
Get-FolderSize [[-Path] <String[]>] [[-FolderName] <String[]>] [-OmitFolder <String[]>] [-NoTotal]
 [<CommonParameters>]
```

## DESCRIPTION
This function will get the folder size in MB and GB of folders found in the Path parameter.
The Path parameter defaults to C:\.
You can also specify a specific folder name via the folderName parameter.

## EXAMPLES

### EXAMPLE 1
```
Get-FolderSize
```

FolderName                Size(Bytes) Size(MB)     Size(GB)
----------                ----------- --------     --------
$GetCurrent                    193768 0.18 MB      0.00 GB
$RECYCLE.BIN                 20649823 19.69 MB     0.02 GB
$SysReset                    53267392 50.80 MB     0.05 GB
Config.Msi                            0.00 MB      0.00 GB
Documents and Settings                0.00 MB      0.00 GB
Games                     48522184491 46,274.36 MB 45.19 GB

### EXAMPLE 2
```
Get-FolderSize -Path 'C:\Program Files'
```

FolderName                                   Size(Bytes) Size(MB)    Size(GB)
----------                                   ----------- --------    --------
7-Zip                                            4588532 4.38 MB     0.00 GB
Adobe                                         3567833029 3,402.55 MB 3.32 GB
Application Verifier                              353569 0.34 MB     0.00 GB
Bonjour                                           615066 0.59 MB     0.00 GB
Common Files                                   489183608 466.52 MB   0.46 GB

### EXAMPLE 3
```
Get-FolderSize -Path 'C:\Program Files' -FolderName IIS
```

FolderName Size(Bytes) Size(MB) Size(GB)
---------- ----------- -------- --------
IIS            5480411 5.23 MB  0.01 GB

### EXAMPLE 4
```
Get-FolderSize
```

FolderName Size(GB) Size(MB)
---------- -------- --------
Public     0.00 GB  0.00 MB
thegn      2.39 GB  2,442.99 MB

### EXAMPLE 5
```
Sort by size descending
Get-FolderSize | Sort-Object 'Size(Bytes)' -Descending
```

FolderName                Size(Bytes) Size(MB)     Size(GB)
----------                ----------- --------     --------
Users                     76280394429 72,746.65 MB 71.04 GB
Games                     48522184491 46,274.36 MB 45.19 GB
Program Files (x86)       27752593691 26,466.94 MB 25.85 GB
Windows                   25351747445 24,177.31 MB 23.61 GB

### EXAMPLE 6
```
Omit folder(s) from being included
.\Get-FolderSize -OmitFolder 'C:\Temp','C:\Windows'
```

## PARAMETERS

### -Path
This parameter allows you to specify the base path you'd like to get the child folders of.
It defaults to C:\.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: C:\
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderName
This parameter allows you to specify the name of a specific folder you'd like to get the size of.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -OmitFolder
This parameter allows you to omit folder(s) (array of string) from being included

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

### -NoTotal
Remove folder sizes total

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### None.
## NOTES
Name:     Get-FolderSize
Author:   Ginger Ninja
Version:  0.1.1 | Last Edit: 2022-06-02 (Justin Johns)
- 0.1.1 - Lots of code clean and consolidation, changed some parameters
- 0.1.0 - Updated object creation, removed try/catch that was causing issues
- 0.0.5 - Just created!
Comments: \<Comment(s)\>
General notes
https://www.gngrninja.com/script-ninja/2016/5/24/powershell-calculating-folder-sizes

## RELATED LINKS
