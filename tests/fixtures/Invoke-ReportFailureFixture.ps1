param(
  [Parameter(Mandatory)]
  [string] $OutputPath
)

$ErrorActionPreference = 'Stop'
Import-Module Pester -RequiredVersion 5.7.1
. (Join-Path $PSScriptRoot '../../scripts/Export-GlyJUnitReport.ps1')

$configuration = New-PesterConfiguration
$configuration.Run.PassThru = $true
$configuration.Output.Verbosity = 'None'
$configuration.Run.Container = New-PesterContainer -ScriptBlock {
  Describe 'report failures' {
    It 'reports an ANSI assertion failure' {
      "`e[31mred`e[0m" | Should -Be 'green'
    }

    It 'reports XML control characters and Unicode' {
      throw "before`0after`t<text> & café 😀`nnext line"
    }

    It 'keeps passing results' {
      $true | Should -BeTrue
    }
  }

  Describe 'setup failure' {
    BeforeAll {
      throw "`e[31msetup failed`e[0m"
    }

    It 'cannot run' {
      $true | Should -BeTrue
    }
  }
}

$result = Invoke-Pester -Configuration $configuration
$originalMessage = $result.Tests[0].ErrorRecord[0].DisplayErrorMessage
Export-GlyJUnitReport -Result $result -Path $OutputPath
if ($result.Tests[0].ErrorRecord[0].DisplayErrorMessage -cne $originalMessage) {
  throw 'Export changed the original failure message.'
}
if ($result.Result -ne 'Passed') {
  exit 1
}
