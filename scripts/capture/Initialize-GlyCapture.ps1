Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$env:TERM = 'xterm-256color'
$env:COLORTERM = 'truecolor'
$env:LANG = 'C.UTF-8'

Import-Module (Join-Path $PSScriptRoot '../../src/gly.psd1') -Force -Global -ErrorAction Stop
$global:GlyStyleRenderer = 'Ansi'
function global:prompt { 'PS> ' }

# VHS waits for this output before sending preview commands.
Write-Output 'GLY_CAPTURE_READY'
