function Test-GlyArgumentCompleterCommand {
  param(
    [Parameter(Mandatory)]
    [string] $CommandName
  )

  if (-not (Get-Module -Name gly)) {
    return $false
  }

  $command = Get-Command -Name $CommandName -ErrorAction SilentlyContinue
  return $null -ne $command -and $command.ModuleName -eq 'gly'
}

function Register-GlyArgumentCompleters {
  $themeCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    if (-not (Test-GlyArgumentCompleterCommand -CommandName $commandName)) {
      return
    }

    Get-GlyRegistryNameCompletion -Registry $script:GlyThemes -WordToComplete $wordToComplete -ItemLabel 'theme'
  }

  $glyphSetCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    if (-not (Test-GlyArgumentCompleterCommand -CommandName $commandName)) {
      return
    }

    Get-GlyRegistryNameCompletion -Registry $script:GlyGlyphSets -WordToComplete $wordToComplete -ItemLabel 'glyph set'
  }

  Register-ArgumentCompleter -CommandName Set-GlyTheme -ParameterName Name -ScriptBlock $themeCompleter
  Register-ArgumentCompleter -CommandName Set-GlyGlyphSet -ParameterName Name -ScriptBlock $glyphSetCompleter
  Register-ArgumentCompleter -CommandName Set-GlyConfiguration -ParameterName Theme -ScriptBlock $themeCompleter
  Register-ArgumentCompleter -CommandName Set-GlyConfiguration -ParameterName GlyphSet -ScriptBlock $glyphSetCompleter
}
