Describe 'gly module' {
  BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '../src/gly/gly.psd1'
  }

  It 'imports without errors and exports expected commands' {
    { Import-Module $modulePath -Force } | Should -Not -Throw
    $commands = Get-Command -Module gly | Select-Object -ExpandProperty Name
    ($commands -contains 'Show-Gly') | Should -Be $true
    ($commands -contains 'Show-GlyTree') | Should -Be $true
    ($commands -contains 'Show-GlyGrid') | Should -Be $true
    ($commands -contains 'Get-GlyConfiguration') | Should -Be $true
  }

  It 'exports interactive aliases' {
    Import-Module $modulePath -Force
    (Get-Alias gly).ResolvedCommandName | Should -Be 'Show-Gly'
    (Get-Alias glytr).ResolvedCommandName | Should -Be 'Show-GlyTree'
    (Get-Alias glygr).ResolvedCommandName | Should -Be 'Show-GlyGrid'
  }

  It 'keeps pipeline objects usable after import' {
    Import-Module $modulePath -Force
    $item = Get-Item -LiteralPath $PSScriptRoot | Select-Object -First 1 -Property Name, FullName, Attributes
    $item.Name | Should -Not -BeNullOrEmpty
    $item.FullName | Should -Not -BeNullOrEmpty
    $item.Attributes | Should -Not -BeNullOrEmpty
  }
}
