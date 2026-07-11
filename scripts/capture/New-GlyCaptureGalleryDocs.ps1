[CmdletBinding()]
param(
  [string] $OutputPath = (Join-Path $PSScriptRoot '../../docs/guide/captures.md')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
Import-Module (Join-Path $repositoryRoot 'src/gly.psd1') -Force

function ConvertTo-CaptureSlug {
  param([Parameter(Mandatory)][string] $Name)

  (($Name -creplace '([a-z0-9])([A-Z])', '$1-$2') -replace '[^A-Za-z0-9]+', '-').Trim('-').ToLowerInvariant()
}

function Get-BuiltInNames {
  param([Parameter(Mandatory)][scriptblock] $Command)

  $names = [System.Collections.Generic.List[string]]::new()
  foreach ($item in & $Command | Where-Object BuiltIn) { $names.Add($item.Name) }
  $names.Sort([System.StringComparer]::Ordinal)
  return $names
}

$themeNames = Get-BuiltInNames { Get-GlyTheme }
$glyphSetNames = Get-BuiltInNames { Get-GlyGlyphSet }
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('<script setup>')
$lines.Add("import { withBase } from 'vitepress'")
$lines.Add('</script>')
$lines.Add('')
$lines.Add('# Terminal capture gallery')
$lines.Add('')
$lines.Add('The previews below are generated on a fixed Ubuntu runner with PowerShell 7, 24-bit ANSI rendering, and a pinned Nerd Font. They show the local module rather than a published package.')
$lines.Add('')
$lines.Add('<video controls preload="metadata" :poster="withBase(''/captures/overview.png'')">')
$lines.Add('  <source :src="withBase(''/captures/overview.webm'')" type="video/webm">')
$lines.Add('  Your browser does not support the preview video. Use the static overview image below.')
$lines.Add('</video>')
$lines.Add('')
$lines.Add('The animation switches from the Dracula theme with Nerd Fonts to DefaultLight with Emoji. It does not autoplay; the same information is available in the screenshots and command examples throughout this guide.')
$lines.Add('')
$lines.Add('## Built-in themes')
$lines.Add('')
$lines.Add('Each theme preview uses the NerdFonts glyph set and shows a fixed representative matcher subset. Open an image to inspect it at full size.')
$lines.Add('')

foreach ($themeName in $themeNames) {
  $path = "/captures/themes/$(ConvertTo-CaptureSlug $themeName).png"
  $lines.Add("<figure><a :href=`"withBase('$path')`"><img :src=`"withBase('$path')`" loading=`"lazy`" alt=`"$themeName theme preview with Nerd Fonts glyphs`"></a><figcaption>$themeName</figcaption></figure>")
}

$lines.Add('')
$lines.Add('## Built-in glyph sets')
$lines.Add('')
$lines.Add('Each glyph-set preview uses the DefaultDark theme and the same representative matcher subset.')
$lines.Add('')

foreach ($glyphSetName in $glyphSetNames) {
  $path = "/captures/glyph-sets/$(ConvertTo-CaptureSlug $glyphSetName).png"
  $lines.Add("<figure><a :href=`"withBase('$path')`"><img :src=`"withBase('$path')`" loading=`"lazy`" alt=`"$glyphSetName glyph set preview with the DefaultDark theme`"></a><figcaption>$glyphSetName</figcaption></figure>")
}

New-Item -ItemType Directory -Path (Split-Path -Parent $OutputPath) -Force | Out-Null
[System.IO.File]::WriteAllLines(
  [System.IO.Path]::GetFullPath($OutputPath),
  $lines,
  [System.Text.UTF8Encoding]::new($false)
)
