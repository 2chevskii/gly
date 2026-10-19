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
      ada = [char]0xe6b5; asm = [char]0xe6ab; astro = [char]0xe735; awk = [char]0xe741
      bicep = [char]0xe63b; clojure = [char]0xe768; cmake = [char]0xe794; coffee = [char]0xe751
      coldfusion = [char]0xe645; dart = [char]0xe798; dlang = [char]0xe7af; elixir = [char]0xe7cd
      elm = [char]0xe7ce; erlang = [char]0xe7b1; fennel = [char]0xe6af; fortran = [char]0xe7de
      graphql = [char]0xe7f4; groovy = [char]0xe775; haskell = [char]0xe777; haxe = [char]0xe7fa
      hcl = [char]0xe8bd; jade = [char]0xe66c; julia = [char]0xe80d; kotlin = [char]0xe81b
      latex = [char]0xe81f; lisp = [char]0xe6b0; lua = [char]0xe826; matlab = [char]0xe82a
      nim = [char]0xe841; nix = [char]0xe843; ocaml = [char]0xe84e; org = [char]0xe633
      perl = [char]0xe769; prisma = [char]0xe86e; prolog = [char]0xe7a1; purescript = [char]0xe875
      r = [char]0xe881; reason = [char]0xe687; rescript = [char]0xe688; scala = [char]0xe737
      scheme = [char]0xe6b1; solidity = [char]0xe8a6; stylus = [char]0xe759; swift = [char]0xe755
      terraform = [char]0xe8bd; twig = [char]0xe61c; vala = [char]0xe8d1; vlang = [char]0xe6ac
      wasm = [char]0xe8e0; zig = [char]0xe8ef
      argdown = [char]0xe636; bsl = [char]0xe63c; cake = [char]0xe63e; cjsx = [char]0xe61b
      crystal = [char]0xe7ac; csv = [char]0xe64a; cuda = [char]0xe64b; ejs = [char]0xe618
      fsharp = [char]0xe7a7; hack = [char]0xe663; haml = [char]0xe664; html = [char]0xe736
      ionic = [char]0xe66b; less = [char]0xe758; liquid = [char]0xe670; livescript = [char]0xe671
      mdo = [char]0xe675; mustache = [char]0xe60f; nunjucks = [char]0xe679; odata = [char]0xe67b
      pddl = [char]0xe67c; puppet = [char]0xe631; sbt = [char]0xe68d; slim = [char]0xe692
      smarty = [char]0xe693; svg = [char]0xe698; wgt = [char]0xe6a4
      angular = [char]0xe753; ansible = [char]0xe723; babel = [char]0xe75d; bower = [char]0xe74d
      deno = [char]0xe7c0; django = [char]0xe71d; dockerfile = [char]0xe7b0; eslint = [char]0xe7d2
      firebase = [char]0xe787; flask = [char]0xe7dc; godot = [char]0xe7ee; gradle = [char]0xe7f2
      gulp = [char]0xe763; grunt = [char]0xe74c; jenkins = [char]0xe767; jinja = [char]0xe66f
      jupyter = [char]0xe80f; make = [char]0xe673; maven = [char]0xe82c; nextjs = [char]0xe83e
      nodejs = [char]0xe719; nuxt = [char]0xe84b; postcss = [char]0xe86a; pytest = [char]0xe87a
      rails = [char]0xe73b; rollup = [char]0xe892; svelte = [char]0xe8b7; vite = [char]0xe8d6
      vue = [char]0xe8dc; webpack = [char]0xe8e3; yarn = [char]0xe8ec
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
      CompleteCatalog = $name -eq 'NerdFonts'
      RuleCache      = $null
    }
  }
}
