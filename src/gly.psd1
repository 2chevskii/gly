@{
  RootModule           = 'gly.psm1'
  ModuleVersion        = '0.1.0'
  GUID                 = '9b89b623-fc6e-4c5d-94a8-89d76bf2ce98'
  Author               = '2CHEVSKII'
  CompanyName          = '2CHEVSKII'
  Copyright            = '(c) 2026 2CHEVSKII. All rights reserved.'
  Description          = 'Custom visual formatting for PowerShell file system objects.'
  PowerShellVersion    = '7.0'
  CompatiblePSEditions = @('Core')
  FunctionsToExport    = @(
    'Enable-Gly',
    'Disable-Gly',
    'Get-GlyConfiguration',
    'Set-GlyConfiguration',
    'Get-GlyTheme',
    'Set-GlyTheme',
    'Register-GlyTheme',
    'Copy-GlyTheme',
    'Get-GlyGlyphSet',
    'Set-GlyGlyphSet',
    'Register-GlyGlyphSet',
    'Copy-GlyGlyphSet',
    'Show-GlyThemeColor',
    'Show-GlyGlyph',
    'Show-GlyThemePreview',
    'Show-Gly',
    'Show-GlyTree',
    'Show-GlyGrid',
    'Get-GlyFileSystemDisplayName'
  )
  CmdletsToExport      = @()
  VariablesToExport    = @()
  AliasesToExport      = @('gly', 'glytr', 'glygr')
  PrivateData          = @{
    PSData = @{
      Tags         = @('PowerShell', 'FileSystem', 'Formatting', 'Glyphs', 'PSEdition_Core')
      LicenseUri   = 'https://github.com/2CHEVSKII/gly/blob/main/LICENSE'
      ProjectUri   = 'https://github.com/2CHEVSKII/gly'
      IconUri      = 'https://raw.githubusercontent.com/2CHEVSKII/gly/main/assets/branding/gly-logo-128.png'
      ReleaseNotes = 'Initial MVP implementation.'
    }
  }
}
