function Register-GlyTheme {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object] $Theme
    )

    process {
        Test-GlyTheme -Theme $Theme | Out-Null
        $copy = Copy-GlyObject -InputObject $Theme
        $name = [string] (Get-GlyValue -InputObject $copy -Name 'Name')

        if ($script:GlyThemes.Contains($name) -and (Get-GlyValue -InputObject $script:GlyThemes[$name] -Name 'BuiltIn' -Default $false)) {
            throw "Built-in gly theme '$name' cannot be overwritten. Use Copy-GlyTheme with a new name."
        }

        $copy.BuiltIn = $false
        $script:GlyThemes[$name] = $copy
        [pscustomobject] (Copy-GlyObject -InputObject $copy)
    }
}
