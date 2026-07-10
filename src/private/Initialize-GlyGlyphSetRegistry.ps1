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
    }
    ANSICompact = @{
      Default = 'f'
      dir = 'd'; junction = 'J'; lnk = 'l'; readonly = 'r'; hidden = 'h'
    }
    Unicode = @{
      Default = '□'
      dir = '▣'; junction = '⇄'; lnk = '↗'; readonly = '◆'; hidden = '·'
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
      CompleteCatalog = $name -in @('NerdFonts', 'Emoji')
      RuleCache      = $null
    }
  }
}
