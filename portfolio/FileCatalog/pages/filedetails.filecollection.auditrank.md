# FileCollection.AuditRank Property

## Definition
Namespace: FileDetails  
Module: FileDetails  
Source: Get-FileDetails.ps1

The sum of values based on the relationships between the three file dates, if `CreationTimeUtc` occurs within the last five years, and on the presence of a file owner. This value is set by the File.SetAuditRank File Class method.

PowerShell
***
``` powershell
[int] $AuditRank {File.SetAuditRank($p1,$p2)}
```

## Property value

Int32

### Remarks

Ranking is based on preferences. That is, a higher rank might be set for old items that can easily be purged (i.e., "low-hanging grapes"). Each major step in the calculation adds to the previous when a condition proves true. If the results of Step 1 is `6` and Step 2 is `2`, then the running total is `8`.

Although rare, file system administrations can affect the metadata. For example, a file write date can occur before a create date.

### Logic and interpretations

#### Terms

- **_Today_**: the current system datetime of when an inventory capture was made. This means that the audit rank will vary across multiple executions. Check the `RowModifiedDateTime` and the table's extended property for more date information.  
- **date**: The dates of `CreationTimeUtc`, `LastAccessTimeUtc`, and `LastWriteTimeUtc` are evaluated and assigned a rank SQL exclusive rank determinations are indicated in **bold** in the interpretation below.

|AuditRank|Has Activity|Interpretation|Statement|
|:--:|--|--|--|
|`15`|Yes|The **SQL** file was created within 5 years prior to _Today_, has not been accessed or written to since its creation date, and the file owner's account is not listed with the VA.|_Case not yet observed_.|
|`15`|No|The **SQL** file was created before the 5 years prior to _Today_, has not been accessed or written to since its creation date, and the file owner's account is **not** listed with the VA.|This may be a source code file for a database object (e.g., a table, view, function, or procedure). Follow the data disposition.|
|`14`|Yes|The **SQL** file was created within 5 years prior to _Today_, has not been accessed or written to since its creation date, and the file owner was not recorded by the file system.|_Case not yet observed_. This may be a source code file for a database object (e.g., a table, view, function, or procedure). Follow the data disposition.|
|`14`|No|The **SQL** file is older than 5 years prior, has not been accessed or written to since its creation date, and the file owner was not recorded by the file system.|_Case not yet observed_. This old, unused file may have served as source code for a persisting database object (e.g., a table, view, function, or procedure).|
|`13`|Yes|The file was created within 5 years prior to _Today_, but has had no activity since its creation date.|This file may be less than a day old or not yet acted on. This is the highest expected value for modern files () and the data disposition should register as `keep`.|
|`12`|Yes|The file was created within 5 years prior to _Today_, has not been accessed or written to since its creation date, and the file owner was not recorded by the file system.|These may be supportive files like `.xlsx` data sets and `.msg` emails. The data disposition should register as `keep`.|
|`12`|No|The file was not created within 5 years prior to _Today_, has not been accessed or written to since its creation date, and either the file is `.sql` or the file owner was not recorded by the file system.|_Case not yet observed_. Follow the data dispostion.|
|`11`|Yes|The file was created before the 5 years prior to _Today_ and has not been accessed or written to since its creation.|Considered a new file, although at 5 years with no activity, the file is aging out. Follow the data dispostion.|
|`11`|No|The file is older than 5 years from _Today_ and has not been accessed or written to since its creation date.|Follow the data disposition.|
|`10`|-|This rank is not possible under the set of current circumstances.|-|
|`9`|Yes|The **SQL** file was created within 5 years prior to _Today_, has had activity, and the file owner's account is not listed with the VA.|The data disposition should register as `keep`.|
|`8`|Yes|The **SQL** file was created within 5 years prior to _Today_, has had activity, and the file owner was not recorded by the file system.|The data disposition should register as `keep`.|
|`7`|Yes|The file was created within 5 years prior to _Today_, has had activity, and 1) the file is `.sql` or 2) and the file owner's account is not listed with the VA.|The data disposition should register as `keep`.|
|`6`|Yes|The file was created within 5 years prior to _Today_, has had activity, and the file owner was not recorded by the file system.|Follow the data disposition.|
|`5`|Yes|The file was created within 5 years prior to _Today_ and has had activity.|The data disposition should register as `keep`.|
|`4`|Yes|The **SQL** file was not created within the 5 years prior to _Today_, has had activity (likely within 5 years prior to _Today_ ¹), and the file owner's account is not listed with the VA.|The data disposition should register as `keep`.|
|`4`|No|The **SQL** file was not created within the 5 years prior to _Today_, has had activity (likely before the 5 years prior to _Today_ ¹), and the file owner's account is not listed with the VA.|Follow the data disposition.|
|`3`|No|The **SQL** file was not created within the 5 years prior to _Today_, has had activity (likely before the 5 years prior to _Today_ ¹), and the file owner was not recorded by the file system.|_Case not yet observed_. Follow the data disposition.|
|`2`|Yes|The **SQL** file was not created within the 5 years prior to _Today_, has had activity (likely within 5 years prior to _Today_ ¹), and 1) the file type is `.sql` or 2) and the file owner's account is not listed with the VA.|The data disposition should register as `keep`. The `sql` file may have served as source code for a persisting database object (e.g., a table, view, function, or procedure).|
|`2`|No|The file was not created within the 5 years prior to _Today_, has had activity (likely before 5 years prior to _Today_ ¹), and 1) the file type is `.sql` or 2) and the file owner's account is not listed with the VA.|Follow the data disposition.|
|`1`|Yes|The file was not created within the 5 years prior to _Today_, has had activity (likely within the 5 years prior to _Today_ ¹), and the file owner was not recorded by the file system.|The data disposition should register as `keep`.|
|`1`|No|The file was not created within the 5 years prior to _Today_, has had activity (likely before the 5 years prior to _Today_ ¹), and the file owner was not recorded by the file system.|Follow the data disposition.|
|`0`|Yes|The file was not created within the 5 years prior to _Today_ and has had activity (likely within the 5 years prior to _Today_ ¹).|These are likely supportive files for other work. The data disposition should register as `keep`.|
|`0`|Yes|The file was not created within the 5 years prior to _Today_ and has had activity (likely before the 5 years prior to _Today_ ¹).|Consider deleting large files like `csv` and `.xlsx` as these are likely snapshot results. Follow the data disposition.|

## See also

- File.SetAuditRank
- FileCollection Class

## Notes

¹ _Likely_ activity is determined through the consideration of the `IsActive` value that is set independently and by the nature of the different dates in relation to the current date minus 3 years.
