Class CDWLSVWorkgroupView
{
    hidden [string] $q1 = "\bdob\b|(?:\w)?birth(?=da(te|ay))?|(?<!(c?l(a|e)|busine|byp|su))ssn(?!(um|ot(e|found)|on|apshot))|\bL(ast\w+)?4\b|(?<=(pat(?:ient)|staff|maiden|first|last))name";
    hidden [string] $q2 = "(MyAuthorization|(?<=\[?LSVMembership\]?\.\[?Dflt\]?\.)\[?(All|My)Permissions\]?|(?<=\[?CDWWork\]?\.\[?LCustomer\]?\.)\[?MyPermissions\]?|CustomerAuthorization|(?<=\[?lsv\]?\.\[?S(Staff|Patient)\]?\.)\[?S(Staff|Patient)\]?)";
    hidden [string] $q3 = "((?<=(\bNo\b)[ ]?)(\bPHI\b|\bPII\b)|\bUs(es|ing)\b\s+(an?\s+)?LSV\s+Protected\s+View(s)?)";
    hidden [string] $q4 = "PAID(\s+)?=(\s+)?1";
    hidden [string] $q5 = "PHIPII(\s+)?=(\s+)?1";

    [datetime] $CreateDate;
    [int] $CriticalColumnCount;
    [string] $CriticalColumns;
    [datetime] $DateLastModified;
    [bool] $HasAfterTrigger;
    [bool] $HasColumnSpecification;
    [bool] $HasDataSetFilter;
    [bool] $HasDeleteTrigger;
    [bool] $HasExtendedProperties;
    [bool] $HasFullTextIndex;
    [bool] $HasIndex;
    [bool] $HasInsertTrigger;
    [bool] $HasInsteadOfTrigger;
    [bool] $HasPAIDBool;
    [bool] $HasPHIPIIBool;
    [bool] $HasSDataExpression;
    [bool] $HasUpdateTrigger;
    [int] $ID;
    [bool] $IsDesignMode;
    [bool] $IsDeveloperSecured;
    [bool] $IsEncrypted;
    [bool] $IsIndexable;
    [bool] $IsSchemaBound;
    [bool] $IsSchemaOwned;
    [bool] $IsSystemObject;
    [string] $Name;
    [int] $NbrColumns;
    [string] $Owner;
    [guid] $ParentGuid;
    [string] $ParentName;
    [bool] $ReturnsViewMetadata;
    [string] $SchemaName;
    [string] $ServerName;
    [string] $State;
    [bool] $TextMode;
    [string] $Urn;
    [string] $HashID;

    CDWLSVWorkgroupView($view)
    {
        $viewColumns = $view.Columns;
        $mu = $this.GetCriticalColumns($viewColumns.Name);

        $criticalClmns = if($mu -and $mu -ne "false"){$mu -join'^'}else{$null};
        $criticalClmnsCount = if($mu -eq $False){0} else{$mu.Count};
        $dataSetFilter = $view.TextBody -match $this.q2;
        $developerSecured = $view.TextHeader+$view.TextBody -match $this.q3;
        $PAIDBool = $view.TextBody -match $this.q4;
        $PHIPIIBool = $view.TextBody -match $this.q5;
        $sDataColumn = $this.SetSDataExpFlag($viewColumns.Name);

        $this.CreateDate = $view.CreateDate;
        $this.CriticalColumnCount = $criticalClmnsCount;
        $this.CriticalColumns = $criticalClmns;
        $this.DateLastModified = $view.DateLastModified;
        $this.HasAfterTrigger = $view.HasAfterTrigger;
        $this.HasDataSetFilter = $dataSetFilter;
        $this.HasDeleteTrigger = $view.HasDeleteTrigger;
        $this.HasExtendedProperties = if([string]::IsNullOrEmpty($view.ExtendedProperties)){$false}else{$true};
        $this.HasFullTextIndex = if([string]::IsNullOrEmpty($view.FullTextIndex)){$false}else{$true};
        $this.HasIndex = $view.HasIndex;
        $this.HasInsertTrigger = $view.HasInsertTrigger;
        $this.HasInsteadOfTrigger = $view.HasInsteadOfTrigger;
        $this.HasPAIDBool = $PAIDBool;
        $this.HasPHIPIIBool = $PHIPIIBool;
        $this.HasSDataExpression = $sDataColumn;
        $this.HasUpdateTrigger = $view.HasUpdateTrigger;
        $this.ID = $view.ID;
        $this.IsDeveloperSecured = $developerSecured;
        $this.IsEncrypted = $view.IsEncrypted;
        $this.IsIndexable = $view.IsIndexable;
        $this.IsSchemaBound = $view.IsSchemaBound;
        $this.Name = $view.Name;
        $this.NbrColumns = $viewColumns.Count;
        $this.Owner = $view.Owner;
        $this.ParentGuid = $view.Parent.DatabaseGuid;
        $this.ParentName = $view.Parent.Name;
        $this.ReturnsViewMetadata = $view.ReturnsViewMetadata
        $this.SchemaName = $view.Schema;
        $this.ServerName = ($view.Parent.Parent).Name;
        $this.State = $view.State;
        $this.TextMode = $view.TextMode;
        $this.Urn = $view.Urn.Value.Replace("'","''");
        $this.HashID = $this.NewHashID( @($dataSetFilter,$view.HasIndex,$sDataColumn,$developerSecured,$viewColumns.Count,$view.urn)-join'' );
    }

    [System.Collections.Generic.List[string]] GetCriticalColumns($columnNames)
    {
        $lamba = [System.Collections.Generic.List [string]]::new();
        $matchTerms = {param($x) process{ $x -match "$($this.q1)"} }
        &$matchTerms $columnNames|&{process{[void]$lamba.Add($_)}}
        return $lamba;
    }

    [bool] SetSDataExpFlag($columnNames)
    {
        $regex = $columnNames -match $this.q1;

        if($null -eq $regex){return $false;}
        elseif($regex.Count -eq 0){return $false;}
        elseif($regex -eq $false){return $false;}
        else{return $true;}
    }
}