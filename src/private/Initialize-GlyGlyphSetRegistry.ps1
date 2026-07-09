function Initialize-GlyGlyphSetRegistry {
  $script:GlyGlyphSets = [ordered]@{}

  $maps = @{
    NerdFonts = @{
      Default = ''
      dir = ''; junction = ''; lnk = ''; readonly = ''; hidden = ''
      ps = '󰞷'; shell = ''; cs = '󰌛'; cpp = '󰙲'; java = ''; js = ''; ts = ''; tsd = ''; react = ''
      python = ''; rust = ''; go = ''; ruby = ''; php = ''; web = ''
      json = ''; yaml = ''; config = ''; xml = '󰗀'; md = ''; text = '󰈙'; log = ''
      archive = ''; image = ''; audio = ''; video = ''; pdf = ''; word = '󰈬'; excel = '󰈛'
      powerpoint = '󰈧'; database = ''; font = ''; certificate = ''; binary = ''
      dirGit = ''; dirGitHub = ''; dirConfig = ''; dirDependencies = ''; dirSource = ''; dirTests = '󰙨'
      dirDocs = ''; dirBuild = ''; dirCache = '󰃨'; dirDownload = '󰉍'; dirImage = '󰉏'; dirAudio = '󰌳'
      dirVideo = '󰎁'; dirInfra = ''
      git = ''; docker = ''; readme = '󰪷'; license = '󰄤'; changelog = ''; package = ''
      project = ''; settings = ''; ci = ''
    }
    ANSI = @{
      Default = '[file]'
      dir = '[dir]'; junction = '[junction]'; lnk = '[link]'; readonly = '[readonly]'; hidden = '[hidden]'
      ps = '[ps]'; shell = '[shell]'; cs = '[dotnet]'; cpp = '[cpp]'; java = '[java]'; js = '[js]'; ts = '[ts]'; tsd = '[d.ts]'; react = '[react]'
      python = '[py]'; rust = '[rust]'; go = '[go]'; ruby = '[ruby]'; php = '[php]'; web = '[web]'
      json = '[json]'; yaml = '[yaml]'; config = '[config]'; xml = '[xml]'; md = '[md]'; text = '[text]'; log = '[log]'
      archive = '[archive]'; image = '[image]'; audio = '[audio]'; video = '[video]'; pdf = '[pdf]'; word = '[word]'; excel = '[excel]'
      powerpoint = '[slides]'; database = '[db]'; font = '[font]'; certificate = '[cert]'; binary = '[binary]'
      dirGit = '[git-dir]'; dirGitHub = '[github]'; dirConfig = '[config-dir]'; dirDependencies = '[deps]'; dirSource = '[src]'; dirTests = '[tests]'
      dirDocs = '[docs]'; dirBuild = '[build]'; dirCache = '[cache]'; dirDownload = '[downloads]'; dirImage = '[images]'; dirAudio = '[music]'
      dirVideo = '[videos]'; dirInfra = '[infra]'
      git = '[git]'; docker = '[docker]'; readme = '[readme]'; license = '[license]'; changelog = '[changes]'; package = '[package]'
      project = '[project]'; settings = '[settings]'; ci = '[ci]'
    }
    ANSICompact = @{
      Default = 'f'
      dir = 'd'; junction = 'J'; lnk = 'l'; readonly = 'r'; hidden = 'h'
      ps = 'P'; shell = '$'; cs = 'C#'; cpp = 'C++'; java = 'Jv'; js = 'JS'; ts = 'TS'; tsd = 'DTS'; react = 'Rx'
      python = 'Py'; rust = 'Rs'; go = 'Go'; ruby = 'Rb'; php = 'Php'; web = 'W'
      json = '{}'; yaml = 'Y'; config = 'c'; xml = '<>'; md = 'M'; text = 't'; log = 'L'
      archive = 'z'; image = 'i'; audio = 'a'; video = 'v'; pdf = 'PDF'; word = 'W'; excel = 'X'
      powerpoint = 'S'; database = 'DB'; font = 'F'; certificate = 'K'; binary = 'B'
      dirGit = 'G'; dirGitHub = 'GH'; dirConfig = 'Cd'; dirDependencies = 'N'; dirSource = 'S'; dirTests = 'T'
      dirDocs = 'D'; dirBuild = 'B'; dirCache = 'C'; dirDownload = '↓'; dirImage = 'I'; dirAudio = 'A'
      dirVideo = 'V'; dirInfra = 'K'
      git = 'g'; docker = 'D'; readme = 'R'; license = 'L'; changelog = 'Ch'; package = 'p'
      project = 'Pr'; settings = 's'; ci = 'CI'
    }
    Unicode = @{
      Default = '□'
      dir = '▣'; junction = '⇄'; lnk = '↗'; readonly = '◆'; hidden = '·'
      ps = '▸'; shell = '⌘'; cs = 'C#'; cpp = 'C++'; java = 'J'; js = 'JS'; ts = 'TS'; tsd = 'DTS'; react = '⚛'
      python = 'Py'; rust = 'Rs'; go = 'Go'; ruby = '◇'; php = 'PHP'; web = '⌘'
      json = '{}'; yaml = '≡'; config = '⚙'; xml = '<>'; md = 'M'; text = '¶'; log = '☷'
      archive = '▤'; image = '▧'; audio = '♫'; video = '▶'; pdf = 'PDF'; word = 'W'; excel = 'X'
      powerpoint = '▰'; database = '▱'; font = 'Aa'; certificate = '✓'; binary = '◈'
      dirGit = '⑂'; dirGitHub = '◆'; dirConfig = '⚙'; dirDependencies = '⬡'; dirSource = '⌘'; dirTests = '⚗'
      dirDocs = '▤'; dirBuild = '⬢'; dirCache = '↻'; dirDownload = '↓'; dirImage = '▧'; dirAudio = '♫'
      dirVideo = '▶'; dirInfra = '⬡'
      git = '⑂'; docker = '⬢'; readme = 'ℹ'; license = '§'; changelog = '✓'; package = '⬡'
      project = '◇'; settings = '⚙'; ci = '⇢'
    }
    Emoji = @{
      Default = '📄'
      dir = '📁'; junction = '🔀'; lnk = '🔗'; readonly = '🔒'; hidden = '🙈'
      ps = '💻'; shell = '⌨️'; cs = '#️⃣'; cpp = '➕'; java = '☕'; js = '🟨'; ts = '🟦'; tsd = 'DTS'; react = '⚛️'
      python = '🐍'; rust = '🦀'; go = '🐹'; ruby = '💎'; php = '🐘'; web = '🌐'
      json = '{}'; yaml = '📋'; config = '⚙️'; xml = '<>'; md = '📝'; text = '📃'; log = '📜'
      archive = '🗜️'; image = '🖼️'; audio = '🎵'; video = '🎬'; pdf = '📕'; word = '📘'; excel = '📗'
      powerpoint = '📙'; database = '🗄️'; font = '🔤'; certificate = '📜'; binary = '⚙️'
      dirGit = '⑂'; dirGitHub = '🐙'; dirConfig = '⚙️'; dirDependencies = '📦'; dirSource = '💻'; dirTests = '🧪'
      dirDocs = '📚'; dirBuild = '🏗️'; dirCache = '♻️'; dirDownload = '📥'; dirImage = '🖼️'; dirAudio = '🎵'
      dirVideo = '🎬'; dirInfra = '☁️'
      git = '⑂'; docker = '🐳'; readme = 'ℹ️'; license = '📜'; changelog = '✅'; package = '📦'
      project = '🧩'; settings = '⚙️'; ci = '🚦'
    }
  }

  foreach ($name in @('NerdFonts', 'ANSI', 'ANSICompact', 'Unicode', 'Emoji')) {
    $map = $maps[$name]
    $script:GlyGlyphSets[$name] = [pscustomobject]@{
      Name           = $name
      BuiltIn        = $true
      DefinitionKind = 'GlyphSet'
      Map            = $map
    }
  }
}
