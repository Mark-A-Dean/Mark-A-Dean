# About Audit Flags

The **BISL Resource Inventory Program** objects contain Boolean-typed columns and elements (i.e., *flags*) that use regular expressions to detect matches of key terms and phrases within a name or text. When a match is found, the flag value is set to `1`, or *true*. Otherwise, the value is `0`, or *false*. Null values are not accepted. Unless otherwise noted, matches are not case-sensitive.

The development of these flags was for the purpose of auditing SQL database objects for protected health and identifying information (PHI/PII)—although the auditing processes are not themselves a function of the inventory program.

- [About Audit Flags](#about-audit-flags)
  - [HasDataSetFilter](#hasdatasetfilter)
  - [HasPAIDBool](#haspaidbool)
  - [HasPHIPIIBool](#hasphipiibool)
  - [HasSDataColumn](#hassdatacolumn)
  - [HasSDataExpression](#hassdataexpression)
  - [IsDeveloperSecured](#isdevelopersecured)

## HasDataSetFilter

**Is Part Of**
- CDW Workgroup LSV Audits

**Description**: `1` when a data source reference is matched within the Text Body. Square bracket quoted identifiers are optional around database object names.

**Range Includes**:

- Matches `MyAuthorization`
- Matches `Dflt.AllPermissions` only if preceded by `LSVMembership`.
- Matches `Dflt.MyPermissions` only if preceded by `LSVMembership`.
- Matches `LCustomer.MyPermissions` only if preceded by `CDWWork`.
- Matches `LCustomer.CustomerAuthorization` only if preceded by `CDWWork`.
- Matches `SStaff.SStaff` only if preceded by `LSV`.
- Matches `SPatient.SPatient` only if preceded by `LSV`.

**Remarks**: `SStaff.SPatient` and `SPatient.SStaff` are allowable combinations although the objects do not exist. A future release may preclude these options.

**Definition**

``` PowerShell
$HasDataSetFilter = $i.TextBody -match "(MyAuthorization|(?<=\[?LSVMembership\]?\.\[?Dflt\]?\.)\[?(All|My)Permissions\]?|(?<=\[?CDWWork\]?\.\[?LCustomer\]?\.)\[?MyPermissions\]?|CustomerAuthorization|(?<=\[?lsv\]?\.\[?S(Staff|Patient)\]?\.)\[?S(Staff|Patient)\]?)";
```

**Is Referenced By**

- Get-CDWWorkgroupLSVView
- Inventory.CDWWorkgroupLSVView
- Inventory.DT_CDWWorkgroupLSVView
- Inventory.ManageCDWWorkgroupLSVView

## HasPAIDBool

**Is Part Of**
- CDW Workgroup LSV Audits

**Description**: `1` when the Boolean expression `PAID = 1` is matched within the Text Body. Zero or more whitespace character may separate the terms. First term is not enforced by a word boundary because it must be a member of the referenced object.

**Range Includes**:

- `PAID = 1`
- `PAID=1`

``` PowerShell
$HasPAIDBool = $i.TextBody -match "PAID(\s+)?=(\s+)?1";
```

**Is Referenced By**

- Get-CDWWorkgroupLSVView
- Inventory.CDWWorkgroupLSVView
- Inventory.DT_CDWWorkgroupLSVView
- Inventory.ManageCDWWorkgroupLSVView

## HasPHIPIIBool

**Is Part Of**
- CDW Workgroup LSV Audits

**Description**: `1` when the Boolean expression `PHIPII = 1` is matched within the Text Body. Zero or more whitespace character may separate the terms. First term is not enforced by a word boundary because it must be a member of the referenced object.

**Range Includes**:

- `PHIPII = 1`
- `PHIPII=1`

**Definition**

``` PowerShell
$HasPHIPIIBool = $i.TextBody -match "PHIPII(\s+)?=(\s+)?1";
```

**Is Referenced By**

- Get-CDWWorkgroupLSVView
- Inventory.CDWWorkgroupLSVView
- Inventory.DT_CDWWorkgroupLSVView
- Inventory.ManageCDWWorkgroupLSVView

## HasSDataColumn

**Is Part Of**
- CDW Workgroup LSV Audits

**Description**: `1` when a key term or phrase is matched with a SQL View column name. Terms and phrases may be a part of other terms or phrases (ex: PatientBirthDay). The variable nature of match returns warranted an `if/then` statement to set the flag.

**Range Includes**:

- birth
- birthday
- birthdate
- DOB
- DateOfBirth  (_other `[term]birth[day,date]` matches possible_)
- ssn
- L4
- Last4
- Last(any terms)4
- PatName
- PatientName
- StaffName
- MaidenName
- FirstName
- LastName

**Definition**

``` PowerShell
$y = $i.Columns.Name -match "\bdob\b|(?:\w)?birth(?=da(te|ay))?|(?<!(c?l(a|e)|busine|byp|su))ssn(?!(um|ot(e|found)|on|apshot))|\bL(ast\w+)?4\b|(?<=(pat(?:ient)|staff|maiden|first|last))name";
                    $HasSDataColumn = if($null -eq $y)
                    {
                        $false;
                    }
                    elseif($y.Count -eq 0)
                    {
                        $false;
                    }
                    elseif($y -eq $false)
                    {
                        $false;
                    }
                    else{$true};
```

**Is Referenced By**

- Get-CDWWorkgroupLSVView
- Inventory.CDWWorkgroupLSVView
- Inventory.DT_CDWWorkgroupLSVView
- Inventory.ManageCDWWorkgroupLSVView

## HasSDataExpression

**Is Part Of**
- CDW Workgroup DOEx Audits

**Description**: `1` when a key term or phrase is matched with a SQL View column name. Terms and phrases may be a part of other terms or phrases (ex: PatientBirthDay). The variable nature of match returns warranted an `if/then` statement to set the flag.

> This flag will replace **HasSDataColumn** in future developments. The term "Expression" is used to provide for future functional compatibility for when the class property is applied to other things than database object columns (e.g., SQL text bodies).

**Range Includes**:

- birth
- birthday
- birthdate
- DOB
- DateOfBirth  (_other `[term]birth[day,date]` matches possible_)
- ssn
- L4
- Last4
- Last(any terms)4
- PatName
- PatientName
- StaffName
- MaidenName
- FirstName
- LastName

**Definition**

``` PowerShell
hidden [string] $HasSDataExpression = "\bdob\b|(?:\w)?birth(?=da(te|ay))?|(?<!(c?l(a|e)|busine|byp|su))ssn(?!(um|ot(e|found)|on|apshot))|\bL(ast\w+)?4\b|(?<=(pat(?:ient)|staff|maiden|first|last))name";
```

**Is Referenced By**

- CDWDOExTable Class
- Inventory.CDWDOExTable
- Inventory.DT_CDWDOExTable
- Inventory.ManageCDWDOExTable

## IsDeveloperSecured

**Replaces**: `HasNoSDataComment`

**Description**: `1` when a key phrase is matched within the Text Header or Body.

**Range Includes**:

- `PHI` only if preceded by `No `.  -_The space character is optional_.
- `PII` only if preceded by `No `.  -_The space character is optional_.
- `Using LSV Protected Views`
  - Many allowable variations: verb tense, articles (a/ an), pluralization, white space including tab and carriage return.

**Remarks**: `No PHI/PII` is the standard, but the allowable match combinations exclude the need to script this patterning.`

**Definition**

``` PowerShell
$IsDeveloperSecured = $i.TextHeader+$i.TextBody -match "((?<=(\bNo\b)[ ]?)(\bPHI\b|\bPII\b)|\bUs(es|ing)\b\s+(an?\s+)?LSV\s+Protected\s+View(s)?)"
```

**Is Referenced By**

- Get-CDWWorkgroupLSVView
- Inventory.CDWWorkgroupLSVView
- Inventory.DT_CDWWorkgroupLSVView
- Inventory.ManageCDWWorkgroupLSVView