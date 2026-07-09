function Test-GlyRuleSelector {
    param(
        [Parameter(Mandatory)]
        [object] $Selector,

        [Parameter(Mandatory)]
        [System.IO.FileSystemInfo] $InputObject
    )

    $kind = Get-GlyFileSystemKind -InputObject $InputObject

    $selectorKind = Get-GlyValue -InputObject $Selector -Name 'Kind'
    if ($null -ne $selectorKind -and [string] $selectorKind -ne $kind) {
        return $false
    }

    $selectorName = Get-GlyValue -InputObject $Selector -Name 'Name'
    if ($null -ne $selectorName -and [string] $selectorName -cne $InputObject.Name) {
        return $false
    }

    $selectorExtension = Get-GlyValue -InputObject $Selector -Name 'Extension'
    if ($null -ne $selectorExtension) {
        $name = $InputObject.Name
        $matched = $false
        foreach ($extension in @($selectorExtension)) {
            $extensionText = [string] $extension
            if (-not $extensionText.StartsWith('.')) {
                $extensionText = ".$extensionText"
            }

            if ($name.EndsWith($extensionText, [System.StringComparison]::OrdinalIgnoreCase)) {
                $matched = $true
                break
            }
        }

        if (-not $matched) {
            return $false
        }
    }

    $selectorGlob = Get-GlyValue -InputObject $Selector -Name 'Glob'
    if ($null -ne $selectorGlob) {
        $globMatched = $false
        foreach ($glob in @($selectorGlob)) {
            $pattern = [System.Management.Automation.WildcardPattern]::new(
                [string] $glob,
                [System.Management.Automation.WildcardOptions]::IgnoreCase
            )

            if ($pattern.IsMatch($InputObject.Name) -or $pattern.IsMatch($InputObject.FullName)) {
                $globMatched = $true
                break
            }
        }

        if (-not $globMatched) {
            return $false
        }
    }

    $selectorAttributes = Get-GlyValue -InputObject $Selector -Name 'Attributes'
    if ($null -ne $selectorAttributes) {
        foreach ($attribute in @($selectorAttributes)) {
            $attributeValue = [System.IO.FileAttributes] [string] $attribute
            if (($InputObject.Attributes -band $attributeValue) -eq 0) {
                return $false
            }
        }
    }

    return $true
}
