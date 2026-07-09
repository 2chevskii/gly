$modulePath = Join-Path $PSScriptRoot '../src/gly/gly.psd1'

Describe 'gly theme registry' {
  Import-Module $modulePath -Force

  It 'lists built-in themes' {
    $names = Get-GlyTheme | Select-Object -ExpandProperty Name
    ($names -contains 'DefaultDark') | Should Be $true
    ($names -contains 'DefaultLight') | Should Be $true
    ($names -contains 'NoColor') | Should Be $true
  }

  It 'does not allow overwriting a built-in theme' {
    $theme = @{
      Name    = 'DefaultDark'
      Default = @{ Foreground = $null; Background = $null; Bold = $false; Italic = $false; Underline = $false }
      Rules   = @()
    }
    $thrown = $false
    try { Register-GlyTheme -Theme $theme } catch { $thrown = $true }
    $thrown | Should Be $true
  }

  It 'copies and registers a user theme' {
    $copy = Copy-GlyTheme -Name DefaultDark -NewName UserDark
    $registered = Register-GlyTheme -Theme $copy
    $registered.Name | Should Be 'UserDark'
    $registered.BuiltIn | Should Be $false
    Set-GlyTheme UserDark | Out-Null
    (Get-GlyConfiguration).Theme | Should Be 'UserDark'
  }

  It 'throws for unknown theme selection' {
    $thrown = $false
    try { Set-GlyTheme MissingTheme } catch { $thrown = $true }
    $thrown | Should Be $true
  }
}
