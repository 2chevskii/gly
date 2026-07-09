function Initialize-GlyGlyphSets {
    $script:GlyGlyphSets = [ordered]@{}

    $commonRules = @(
        [ordered]@{ Selector = [ordered]@{ Kind = 'Directory' }; Glyph = 'dir' },
        [ordered]@{ Selector = [ordered]@{ Kind = 'Symlink' }; Glyph = 'lnk' },
        [ordered]@{ Selector = [ordered]@{ Name = '.gitignore' }; Glyph = 'git' },
        [ordered]@{ Selector = [ordered]@{ Name = 'Dockerfile' }; Glyph = 'dock' },
        [ordered]@{ Selector = [ordered]@{ Extension = '.ps1' }; Glyph = 'ps' },
        [ordered]@{ Selector = [ordered]@{ Extension = '.psm1' }; Glyph = 'ps' },
        [ordered]@{ Selector = [ordered]@{ Extension = '.psd1' }; Glyph = 'ps' },
        [ordered]@{ Selector = [ordered]@{ Extension = '.cs' }; Glyph = 'cs' },
        [ordered]@{ Selector = [ordered]@{ Extension = '.js' }; Glyph = 'js' },
        [ordered]@{ Selector = [ordered]@{ Extension = '.ts' }; Glyph = 'ts' },
        [ordered]@{ Selector = [ordered]@{ Extension = '.d.ts' }; Glyph = 'tsd' },
        [ordered]@{ Selector = [ordered]@{ Extension = '.json' }; Glyph = 'json' },
        [ordered]@{ Selector = [ordered]@{ Extension = '.md' }; Glyph = 'md' },
        [ordered]@{ Selector = [ordered]@{ Extension = '.tar.gz' }; Glyph = 'arc' },
        [ordered]@{ Selector = [ordered]@{ Attributes = @('Hidden') }; Glyph = 'hid' }
    )

    $maps = @{
        NerdFonts = @{
            Default = [char]0xf15b
            dir = [char]0xf07b; lnk = [char]0xf0c1; git = [char]0xf1d3; dock = [char]0xf308
            ps = [char]0xf489; cs = [char]0xf81a; js = [char]0xe74e; ts = [char]0xe628; tsd = [char]0xe628
            json = [char]0xe60b; md = [char]0xf48a; arc = [char]0xf410; hid = [char]0xf070
        }
        ANSI = @{
            Default = '[file]'
            dir = '[dir]'; lnk = '[link]'; git = '[git]'; dock = '[docker]'
            ps = '[ps]'; cs = '[cs]'; js = '[js]'; ts = '[ts]'; tsd = '[d.ts]'
            json = '[json]'; md = '[md]'; arc = '[archive]'; hid = '[hidden]'
        }
        ANSICompact = @{
            Default = 'f'
            dir = 'd'; lnk = 'l'; git = 'g'; dock = 'D'
            ps = 'p'; cs = 'c'; js = 'j'; ts = 't'; tsd = 'T'
            json = 'J'; md = 'm'; arc = 'z'; hid = 'h'
        }
        Unicode = @{
            Default = '□'
            dir = '▣'; lnk = '↗'; git = '⑂'; dock = '⬢'
            ps = '▸'; cs = '◇'; js = 'JS'; ts = 'TS'; tsd = 'DTS'
            json = '{}'; md = 'M'; arc = '▤'; hid = '·'
        }
        Emoji = @{
            Default = '📄'
            dir = '📁'; lnk = '🔗'; git = '⑂'; dock = '🐳'
            ps = '💻'; cs = '#'; js = 'JS'; ts = 'TS'; tsd = 'DTS'
            json = '{}'; md = '📝'; arc = '🗜'; hid = '·'
        }
    }

    foreach ($name in @('NerdFonts', 'ANSI', 'ANSICompact', 'Unicode', 'Emoji')) {
        $map = $maps[$name]
        $rules = foreach ($rule in $commonRules) {
            $copy = Copy-GlyObject -InputObject $rule
            $copy.Glyph = $map[$copy.Glyph]
            $copy
        }

        $script:GlyGlyphSets[$name] = [ordered]@{
            Name = $name
            BuiltIn = $true
            Default = $map.Default
            Rules = @($rules)
        }
    }
}
