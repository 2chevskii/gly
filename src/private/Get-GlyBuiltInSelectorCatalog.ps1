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
