Describe 'gly test reports' {
  It 'exports valid JUnit for ANSI failures and setup errors while retaining failure status' {
    $fixturePath = Join-Path $PSScriptRoot 'fixtures/Invoke-ReportFailureFixture.ps1'
    $outputPath = Join-Path $TestDrive 'failures.junit.xml'
    $powerShellPath = (Get-Process -Id $PID).Path

    & $powerShellPath -NoProfile -NonInteractive -File $fixturePath -OutputPath $outputPath | Out-Null

    $LASTEXITCODE | Should -Be 1
    $outputPath | Should -Exist
    $text = Get-Content -LiteralPath $outputPath -Raw
    $report = [xml] $text
    @($report.SelectNodes('//testcase/failure')).Count | Should -BeGreaterOrEqual 3
    @($report.SelectNodes('//testcase[not(failure)]')).Count | Should -BeGreaterOrEqual 1
    $text | Should -Not -Match "`e"
    $messages = @($report.SelectNodes('//failure') | ForEach-Object { $_.GetAttribute('message') }) -join "`n"
    $messages | Should -Match '\\u001b\[31m'
    $messages | Should -Match 'before\\u0000after'
    $messages | Should -Match 'café 😀'
    $messages | Should -Match 'Most likely a setup in some parent block failed'
  }
}
