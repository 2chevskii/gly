function Get-GlyBuiltInSelectorCatalog {
  if ($null -ne $script:GlyBuiltInSelectorCatalog) {
    return $script:GlyBuiltInSelectorCatalog
  }

  $definitions = @(
    @{ Token = 'dir'; Palette = 'Directory'; Bold = $true; Selector = @{ Kind = 'Directory' } }
    @{ Token = 'junction'; Palette = 'Symlink'; Selector = @{ Kind = 'Junction' } }
    @{ Token = 'lnk'; Palette = 'Symlink'; Selector = @{ Kind = 'Symlink' } }
    @{ Token = 'readonly'; Palette = 'ReadOnly'; Selector = @{ Attributes = @('ReadOnly') } }

    @{ Token = 'ps'; Palette = 'PowerShell'; Selector = @{ Extension = @('.ps1', '.psm1', '.psd1', '.ps1xml', '.psc1', '.pssc') } }
    @{ Token = 'shell'; Palette = 'PowerShell'; Selector = @{ Extension = @('.sh', '.bash', '.zsh', '.fish', '.bat', '.cmd') } }
    @{ Token = 'cs'; Palette = 'PowerShell'; Selector = @{ Extension = @('.cs', '.csx', '.fs', '.fsx', '.vb') } }
    @{ Token = 'cpp'; Palette = 'PowerShell'; Selector = @{ Extension = @('.c', '.h', '.cpp', '.cc', '.cxx', '.hpp') } }
    @{ Token = 'java'; Palette = 'PowerShell'; Selector = @{ Extension = @('.java', '.class', '.jar', '.kt', '.kts', '.scala', '.gradle') } }
    @{ Token = 'js'; Palette = 'PowerShell'; Selector = @{ Extension = @('.js', '.mjs', '.cjs') } }
    @{ Token = 'ts'; Palette = 'PowerShell'; Selector = @{ Extension = '.ts' } }
    @{ Token = 'tsd'; Palette = 'PowerShell'; Selector = @{ Extension = '.d.ts' } }
    @{ Token = 'react'; Palette = 'PowerShell'; Selector = @{ Extension = @('.jsx', '.tsx') } }
    @{ Token = 'python'; Palette = 'PowerShell'; Selector = @{ Extension = @('.py', '.pyw', '.pyc', '.ipynb') } }
    @{ Token = 'rust'; Palette = 'PowerShell'; Selector = @{ Extension = '.rs' } }
    @{ Token = 'go'; Palette = 'PowerShell'; Selector = @{ Extension = '.go' } }
    @{ Token = 'ruby'; Palette = 'PowerShell'; Selector = @{ Extension = @('.rb', '.rake', '.gemspec') } }
    @{ Token = 'php'; Palette = 'PowerShell'; Selector = @{ Extension = '.php' } }
    @{ Token = 'web'; Palette = 'PowerShell'; Selector = @{ Extension = @('.html', '.htm', '.css', '.scss', '.sass', '.less', '.vue', '.svelte') } }
    @{ Token = 'json'; Palette = 'Json'; Selector = @{ Extension = @('.json', '.jsonc') } }
    @{ Token = 'yaml'; Palette = 'Json'; Selector = @{ Extension = @('.yaml', '.yml') } }
    @{ Token = 'config'; Palette = 'ReadOnly'; Selector = @{ Extension = @('.toml', '.ini', '.cfg', '.conf', '.config', '.properties', '.env') } }
    @{ Token = 'xml'; Palette = 'Json'; Selector = @{ Extension = @('.xml', '.xsd', '.xsl', '.xslt', '.resx', '.xaml', '.plist') } }
    @{ Token = 'md'; Palette = 'Markdown'; Selector = @{ Extension = @('.md', '.mdx', '.markdown', '.rst') } }
    @{ Token = 'text'; Palette = 'Markdown'; Selector = @{ Extension = @('.txt', '.rtf') } }
    @{ Token = 'log'; Palette = 'Hidden'; Selector = @{ Extension = @('.log', '.trace') } }
    @{ Token = 'archive'; Palette = 'ReadOnly'; Selector = @{ Extension = @('.tar.gz', '.tar.bz2', '.tar.xz', '.zip', '.tar', '.gz', '.bz2', '.xz', '.7z', '.rar', '.tgz', '.zst') } }
    @{ Token = 'image'; Palette = 'Markdown'; Selector = @{ Extension = @('.png', '.jpg', '.jpeg', '.gif', '.bmp', '.webp', '.ico', '.svg', '.tif', '.tiff') } }
    @{ Token = 'audio'; Palette = 'Markdown'; Selector = @{ Extension = @('.mp3', '.wav', '.flac', '.m4a', '.aac', '.ogg', '.opus') } }
    @{ Token = 'video'; Palette = 'Markdown'; Selector = @{ Extension = @('.mp4', '.mkv', '.avi', '.mov', '.webm', '.wmv') } }
    @{ Token = 'pdf'; Palette = 'Json'; Selector = @{ Extension = '.pdf' } }
    @{ Token = 'word'; Palette = 'Json'; Selector = @{ Extension = @('.doc', '.docx', '.odt') } }
    @{ Token = 'excel'; Palette = 'Json'; Selector = @{ Extension = @('.xls', '.xlsx', '.ods', '.csv', '.tsv') } }
    @{ Token = 'powerpoint'; Palette = 'Json'; Selector = @{ Extension = @('.ppt', '.pptx', '.odp') } }
    @{ Token = 'database'; Palette = 'Symlink'; Selector = @{ Extension = @('.db', '.sqlite', '.sqlite3', '.sql', '.pdb', '.accdb', '.mdb') } }
    @{ Token = 'font'; Palette = 'ReadOnly'; Selector = @{ Extension = @('.ttf', '.otf', '.woff', '.woff2', '.eot') } }
    @{ Token = 'certificate'; Palette = 'ReadOnly'; Selector = @{ Extension = @('.pem', '.cer', '.cert', '.crt', '.pfx', '.gpg', '.asc') } }
    @{ Token = 'binary'; Palette = 'ReadOnly'; Selector = @{ Extension = @('.exe', '.dll', '.so', '.dylib', '.wasm', '.msi', '.msix') } }

    @{ Token = 'ada'; Palette = 'PowerShell'; Selector = @{ Extension = @('.ada', '.adb', '.ads') } }
    @{ Token = 'asm'; Palette = 'PowerShell'; Selector = @{ Extension = @('.asm', '.s', '.inc') } }
    @{ Token = 'astro'; Palette = 'PowerShell'; Selector = @{ Extension = '.astro' } }
    @{ Token = 'awk'; Palette = 'PowerShell'; Selector = @{ Extension = '.awk' } }
    @{ Token = 'bicep'; Palette = 'PowerShell'; Selector = @{ Extension = '.bicep' } }
    @{ Token = 'clojure'; Palette = 'PowerShell'; Selector = @{ Extension = @('.clj', '.cljs', '.cljc', '.edn') } }
    @{ Token = 'cmake'; Palette = 'PowerShell'; Selector = @{ Extension = '.cmake' } }
    @{ Token = 'coffee'; Palette = 'PowerShell'; Selector = @{ Extension = @('.coffee', '.cson') } }
    @{ Token = 'coldfusion'; Palette = 'PowerShell'; Selector = @{ Extension = @('.cfm', '.cfc', '.cfml') } }
    @{ Token = 'dart'; Palette = 'PowerShell'; Selector = @{ Extension = '.dart' } }
    @{ Token = 'dlang'; Palette = 'PowerShell'; Selector = @{ Extension = @('.d', '.di') } }
    @{ Token = 'elixir'; Palette = 'PowerShell'; Selector = @{ Extension = @('.ex', '.exs') } }
    @{ Token = 'elm'; Palette = 'PowerShell'; Selector = @{ Extension = '.elm' } }
    @{ Token = 'erlang'; Palette = 'PowerShell'; Selector = @{ Extension = @('.erl', '.hrl') } }
    @{ Token = 'fennel'; Palette = 'PowerShell'; Selector = @{ Extension = '.fnl' } }
    @{ Token = 'fortran'; Palette = 'PowerShell'; Selector = @{ Extension = @('.f', '.for', '.f90', '.f95') } }
    @{ Token = 'graphql'; Palette = 'Json'; Selector = @{ Extension = @('.graphql', '.gql') } }
    @{ Token = 'groovy'; Palette = 'PowerShell'; Selector = @{ Extension = @('.groovy', '.gvy', '.gy', '.gsh') } }
    @{ Token = 'haskell'; Palette = 'PowerShell'; Selector = @{ Extension = @('.hs', '.lhs') } }
    @{ Token = 'haxe'; Palette = 'PowerShell'; Selector = @{ Extension = '.hx' } }
    @{ Token = 'hcl'; Palette = 'PowerShell'; Selector = @{ Extension = '.hcl' } }
    @{ Token = 'jade'; Palette = 'PowerShell'; Selector = @{ Extension = @('.jade', '.pug') } }
    @{ Token = 'julia'; Palette = 'PowerShell'; Selector = @{ Extension = '.jl' } }
    @{ Token = 'kotlin'; Palette = 'PowerShell'; Selector = @{ Extension = @('.kt', '.kts') } }
    @{ Token = 'latex'; Palette = 'Markdown'; Selector = @{ Extension = @('.tex', '.latex', '.sty', '.cls') } }
    @{ Token = 'lisp'; Palette = 'PowerShell'; Selector = @{ Extension = @('.lisp', '.lsp', '.cl') } }
    @{ Token = 'lua'; Palette = 'PowerShell'; Selector = @{ Extension = '.lua' } }
    @{ Token = 'matlab'; Palette = 'PowerShell'; Selector = @{ Extension = @('.matlab', '.m') } }
    @{ Token = 'nim'; Palette = 'PowerShell'; Selector = @{ Extension = @('.nim', '.nims') } }
    @{ Token = 'nix'; Palette = 'PowerShell'; Selector = @{ Extension = '.nix' } }
    @{ Token = 'ocaml'; Palette = 'PowerShell'; Selector = @{ Extension = @('.ml', '.mli') } }
    @{ Token = 'org'; Palette = 'Markdown'; Selector = @{ Extension = '.org' } }
    @{ Token = 'perl'; Palette = 'PowerShell'; Selector = @{ Extension = @('.pl', '.pm', '.pod') } }
    @{ Token = 'prisma'; Palette = 'PowerShell'; Selector = @{ Extension = '.prisma' } }
    @{ Token = 'prolog'; Palette = 'PowerShell'; Selector = @{ Extension = @('.pro', '.prolog') } }
    @{ Token = 'purescript'; Palette = 'PowerShell'; Selector = @{ Extension = '.purs' } }
    @{ Token = 'r'; Palette = 'PowerShell'; Selector = @{ Extension = @('.r', '.rmd') } }
    @{ Token = 'reason'; Palette = 'PowerShell'; Selector = @{ Extension = @('.re', '.rei') } }
    @{ Token = 'rescript'; Palette = 'PowerShell'; Selector = @{ Extension = @('.res', '.resi') } }
    @{ Token = 'scala'; Palette = 'PowerShell'; Selector = @{ Extension = @('.scala', '.sc') } }
    @{ Token = 'scheme'; Palette = 'PowerShell'; Selector = @{ Extension = @('.scm', '.ss') } }
    @{ Token = 'solidity'; Palette = 'PowerShell'; Selector = @{ Extension = '.sol' } }
    @{ Token = 'stylus'; Palette = 'PowerShell'; Selector = @{ Extension = '.styl' } }
    @{ Token = 'swift'; Palette = 'PowerShell'; Selector = @{ Extension = '.swift' } }
    @{ Token = 'terraform'; Palette = 'PowerShell'; Selector = @{ Extension = @('.tf', '.tfvars') } }
    @{ Token = 'twig'; Palette = 'PowerShell'; Selector = @{ Extension = '.twig' } }
    @{ Token = 'vala'; Palette = 'PowerShell'; Selector = @{ Extension = @('.vala', '.vapi') } }
    @{ Token = 'vlang'; Palette = 'PowerShell'; Selector = @{ Extension = '.v' } }
    @{ Token = 'wasm'; Palette = 'PowerShell'; Selector = @{ Extension = @('.wasm', '.wat') } }
    @{ Token = 'zig'; Palette = 'PowerShell'; Selector = @{ Extension = '.zig' } }
    @{ Token = 'argdown'; Palette = 'Markdown'; Selector = @{ Extension = '.ad' } }
    @{ Token = 'bsl'; Palette = 'PowerShell'; Selector = @{ Extension = '.bsl' } }
    @{ Token = 'cake'; Palette = 'PowerShell'; Selector = @{ Extension = '.cake' } }
    @{ Token = 'cjsx'; Palette = 'PowerShell'; Selector = @{ Extension = '.cjsx' } }
    @{ Token = 'crystal'; Palette = 'PowerShell'; Selector = @{ Extension = '.cr' } }
    @{ Token = 'csv'; Palette = 'Json'; Selector = @{ Extension = '.csv' } }
    @{ Token = 'cuda'; Palette = 'PowerShell'; Selector = @{ Extension = @('.cu', '.cuh') } }
    @{ Token = 'ejs'; Palette = 'PowerShell'; Selector = @{ Extension = '.ejs' } }
    @{ Token = 'fsharp'; Palette = 'PowerShell'; Selector = @{ Extension = @('.fs', '.fsx', '.fsi') } }
    @{ Token = 'hack'; Palette = 'PowerShell'; Selector = @{ Extension = '.hack' } }
    @{ Token = 'haml'; Palette = 'PowerShell'; Selector = @{ Extension = '.haml' } }
    @{ Token = 'html'; Palette = 'PowerShell'; Selector = @{ Extension = @('.html', '.htm') } }
    @{ Token = 'ionic'; Palette = 'PowerShell'; Selector = @{ Extension = '.ionic' } }
    @{ Token = 'less'; Palette = 'PowerShell'; Selector = @{ Extension = '.less' } }
    @{ Token = 'liquid'; Palette = 'PowerShell'; Selector = @{ Extension = '.liquid' } }
    @{ Token = 'livescript'; Palette = 'PowerShell'; Selector = @{ Extension = '.ls' } }
    @{ Token = 'mdo'; Palette = 'Markdown'; Selector = @{ Extension = '.mdo' } }
    @{ Token = 'mustache'; Palette = 'PowerShell'; Selector = @{ Extension = @('.mustache', '.hbs') } }
    @{ Token = 'nunjucks'; Palette = 'PowerShell'; Selector = @{ Extension = @('.njk', '.nunjucks') } }
    @{ Token = 'odata'; Palette = 'Json'; Selector = @{ Extension = '.odata' } }
    @{ Token = 'pddl'; Palette = 'PowerShell'; Selector = @{ Extension = '.pddl' } }
    @{ Token = 'puppet'; Palette = 'PowerShell'; Selector = @{ Extension = '.pp' } }
    @{ Token = 'sbt'; Palette = 'PowerShell'; Selector = @{ Extension = '.sbt' } }
    @{ Token = 'slim'; Palette = 'PowerShell'; Selector = @{ Extension = '.slim' } }
    @{ Token = 'smarty'; Palette = 'PowerShell'; Selector = @{ Extension = '.smarty' } }
    @{ Token = 'svg'; Palette = 'Markdown'; Selector = @{ Extension = '.svg' } }
    @{ Token = 'wgt'; Palette = 'PowerShell'; Selector = @{ Extension = '.wgt' } }

    @{ Token = 'dirGit'; Palette = 'Symlink'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = '.git' } }
    @{ Token = 'dirGitHub'; Palette = 'Symlink'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = '.github' } }
    @{ Token = 'dirConfig'; Palette = 'ReadOnly'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('.config', '.vscode', '.vscode-insiders', '.idea') } }
    @{ Token = 'dirDependencies'; Palette = 'Json'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('node_modules', 'vendor', 'packages', 'bower_components') } }
    @{ Token = 'dirSource'; Palette = 'PowerShell'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('src', 'source', 'scripts') } }
    @{ Token = 'dirTests'; Palette = 'Json'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('test', 'tests', 'spec', 'specs', 'coverage') } }
    @{ Token = 'dirDocs'; Palette = 'Markdown'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('doc', 'docs', 'documentation') } }
    @{ Token = 'dirBuild'; Palette = 'PowerShell'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('build', 'dist', 'out', 'output', 'artifacts', 'target', 'bin') } }
    @{ Token = 'dirCache'; Palette = 'Hidden'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('.cache', '__pycache__', '.pytest_cache', '.mypy_cache') } }
    @{ Token = 'dirDownload'; Palette = 'Directory'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('download', 'downloads') } }
    @{ Token = 'dirImage'; Palette = 'Markdown'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('image', 'images', 'photo', 'photos', 'picture', 'pictures') } }
    @{ Token = 'dirAudio'; Palette = 'Markdown'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('audio', 'music', 'songs') } }
    @{ Token = 'dirVideo'; Palette = 'Markdown'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('video', 'videos', 'movie', 'movies') } }
    @{ Token = 'dirInfra'; Palette = 'Symlink'; Bold = $true; Selector = @{ Kind = 'Directory'; Glob = @('.docker', '.kube', '.terraform', 'infra', 'deploy', 'charts') } }

    @{ Token = 'git'; Palette = 'Symlink'; Selector = @{ Kind = 'File'; Glob = @('.gitignore', '.gitattributes', '.gitmodules', '.gitconfig', '.gitkeep') } }
    @{ Token = 'docker'; Palette = 'Symlink'; Selector = @{ Kind = 'File'; Glob = @('Dockerfile', 'Dockerfile.*', '.dockerignore', 'docker-compose*.yml', 'docker-compose*.yaml', 'compose*.yml', 'compose*.yaml') } }
    @{ Token = 'readme'; Palette = 'Markdown'; Bold = $true; Selector = @{ Kind = 'File'; Glob = @('README', 'README.*') } }
    @{ Token = 'license'; Palette = 'ReadOnly'; Selector = @{ Kind = 'File'; Glob = @('LICENSE', 'LICENSE.*', 'LICENCE', 'LICENCE.*', 'COPYING', 'COPYING.*') } }
    @{ Token = 'changelog'; Palette = 'Markdown'; Selector = @{ Kind = 'File'; Glob = @('CHANGELOG', 'CHANGELOG.*', 'HISTORY', 'HISTORY.*') } }
    @{ Token = 'package'; Palette = 'Json'; Selector = @{ Kind = 'File'; Glob = @('package.json', 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'composer.json', 'composer.lock', 'go.mod', 'go.sum', 'Cargo.toml', 'Cargo.lock', 'requirements.txt', 'pyproject.toml', 'Pipfile') } }
    @{ Token = 'project'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('*.sln', '*.slnx', '*.csproj', '*.fsproj', '*.vbproj', 'CMakeLists.txt', 'Makefile', 'makefile') } }
    @{ Token = 'settings'; Palette = 'ReadOnly'; Selector = @{ Kind = 'File'; Glob = @('.editorconfig', '.eslintrc*', 'eslint.config.*', '.prettierrc*', 'prettier.config.*', 'tsconfig*.json', 'jsconfig*.json') } }
    @{ Token = 'ci'; Palette = 'Symlink'; Selector = @{ Kind = 'File'; Glob = @('.gitlab-ci.yml', '.travis.yml', '.azure-pipelines.yml', 'azure-pipelines.yml', 'bitbucket-pipelines.yml', 'bitbucket-pipelines.yaml', 'Jenkinsfile', '.jenkinsfile') } }
    @{ Token = 'angular'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('angular.json', 'angular-cli.json') } }
    @{ Token = 'ansible'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('ansible.cfg', 'playbook.yml', 'playbook.yaml') } }
    @{ Token = 'babel'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('.babelrc', '.babelrc.*', 'babel.config.*') } }
    @{ Token = 'bower'; Palette = 'Json'; Selector = @{ Kind = 'File'; Glob = @('bower.json', '.bowerrc') } }
    @{ Token = 'deno'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('deno.json', 'deno.jsonc', 'deno.lock') } }
    @{ Token = 'django'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = 'manage.py' } }
    @{ Token = 'dockerfile'; Palette = 'Symlink'; Selector = @{ Kind = 'File'; Glob = @('Dockerfile', 'Dockerfile.*', '.dockerignore') } }
    @{ Token = 'eslint'; Palette = 'ReadOnly'; Selector = @{ Kind = 'File'; Glob = @('.eslintrc*', 'eslint.config.*') } }
    @{ Token = 'firebase'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('firebase.json', '.firebaserc') } }
    @{ Token = 'flask'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = 'app.py' } }
    @{ Token = 'godot'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = 'project.godot' } }
    @{ Token = 'gradle'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('build.gradle', 'build.gradle.kts', 'settings.gradle', 'settings.gradle.kts', 'gradlew', 'gradlew.bat') } }
    @{ Token = 'gulp'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('gulpfile.*', 'gulpfile') } }
    @{ Token = 'grunt'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('gruntfile.*', 'gruntfile') } }
    @{ Token = 'jenkins'; Palette = 'Symlink'; Selector = @{ Kind = 'File'; Glob = @('Jenkinsfile', '.jenkinsfile') } }
    @{ Token = 'jinja'; Palette = 'PowerShell'; Selector = @{ Extension = @('.jinja', '.jinja2', '.j2') } }
    @{ Token = 'jupyter'; Palette = 'PowerShell'; Selector = @{ Extension = '.ipynb' } }
    @{ Token = 'make'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('Makefile', 'makefile', 'GNUmakefile') } }
    @{ Token = 'maven'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = 'pom.xml' } }
    @{ Token = 'nextjs'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('next.config.*', 'next-env.d.ts') } }
    @{ Token = 'nodejs'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('package.json', 'package-lock.json') } }
    @{ Token = 'nuxt'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('nuxt.config.*', 'nuxt.config') } }
    @{ Token = 'postcss'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('postcss.config.*', '.postcssrc*') } }
    @{ Token = 'pytest'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('pytest.ini', 'tox.ini') } }
    @{ Token = 'rails'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('Gemfile', 'Rakefile') } }
    @{ Token = 'rollup'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('rollup.config.*', 'rollup.config') } }
    @{ Token = 'svelte'; Palette = 'PowerShell'; Selector = @{ Extension = '.svelte' } }
    @{ Token = 'vite'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('vite.config.*', 'vite.config') } }
    @{ Token = 'vue'; Palette = 'PowerShell'; Selector = @{ Extension = '.vue' } }
    @{ Token = 'webpack'; Palette = 'PowerShell'; Selector = @{ Kind = 'File'; Glob = @('webpack.config.*', 'webpack.*.js') } }
    @{ Token = 'yarn'; Palette = 'Json'; Selector = @{ Kind = 'File'; Glob = 'yarn.lock' } }
    @{ Token = 'hidden'; Palette = 'Hidden'; Selector = @{ Attributes = @('Hidden') } }
  )

  $script:GlyBuiltInSelectorCatalog = [GlyBuiltInSelectorDefinition[]] $definitions
  for ($i = 0; $i -lt $script:GlyBuiltInSelectorCatalog.Count; $i++) {
    $definition = $script:GlyBuiltInSelectorCatalog[$i]
    $definition.Index = $i
    Initialize-GlySelector -Selector $definition.Selector | Out-Null
  }
  return $script:GlyBuiltInSelectorCatalog
}
