# Headless Terminal Capture Research

Research date: 2026-07-11

## Decision

Use [VHS](https://github.com/charmbracelet/vhs) as the primary capture tool. A single scripted tape can produce a README animation (`.gif`), a documentation video (`.webm` or `.mp4`), a PNG frame sequence, and named PNG screenshots with the `Screenshot` command. Run it on a Linux GitHub Actions runner so captures do not depend on a developer workstation.

Use [Freeze](https://github.com/charmbracelet/freeze) only if bulk static capture proves simpler outside VHS. Keep [asciinema plus agg](https://docs.asciinema.org/manual/agg/) as an alternative when an interactive, replayable terminal session is more important than a conventional image or video.

The first implementation should be a small proof of concept containing:

1. one overview tape that emits `overview.png`, `overview.gif`, and `overview.webm`;
2. one generated theme-gallery tape that emits one PNG per built-in theme;
3. a manually triggered workflow that uploads the generated files as an artifact and fails when committed captures are stale;
4. a follow-up generated-captures pull request after rendering is proven deterministic.

This keeps capture generation separate from the existing documentation deployment workflow until rendering and repository-size costs are known.

## Requirements and constraints

The capture pipeline needs to:

- run without opening a terminal window on a contributor's computer;
- execute PowerShell 7 and import the module from `src/gly.psd1`;
- preserve 24-bit ANSI colors, Unicode, Nerd Font private-use glyphs, and emoji;
- use fixed terminal dimensions, fonts, prompts, sample names, and timing;
- produce assets usable by both the root README and VitePress;
- scale to the current catalog of 90 built-in themes without maintaining 90 handwritten scripts;
- make stale generated assets detectable in CI;
- retain a static alternative and accessible text for moving captures.

The repository already exposes `assets` as the VitePress public directory in `docs/.vitepress/config.mts`. Generated files can therefore live once under `assets/captures`: the README can reference `assets/captures/overview.png`, while documentation can reference `/captures/overview.png`.

## Tool comparison

| Tool | Headless/CI suitability | Static output | Moving output | Font and glyph handling | Fit for `gly` |
| --- | --- | --- | --- | --- | --- |
| [VHS 0.11.0](https://github.com/charmbracelet/vhs) | Strong. It scripts a virtual terminal, has an official GitHub Action, and has a Docker image. It requires `ttyd` and `ffmpeg` when installed directly. | Named PNG screenshots and PNG frame directories. | GIF, MP4, and WebM from the same tape. | Configurable font family, size, theme, terminal dimensions, and extra font installation in the action. | Best overall: one source can create all required formats and can visibly type commands. |
| [Freeze 0.2.2](https://github.com/charmbracelet/freeze) | Strong for a single command. `--execute` captures ANSI output through a terminal and is non-interactive. | SVG, PNG, and WebP. It can embed a TTF, WOFF, or WOFF2 font. | None. | Explicit font file/family, size, line height, window decoration, background, padding, and dimensions. | Good static-only fallback and possibly simpler for one image per theme. |
| [asciinema 3.2.1](https://github.com/asciinema/asciinema) + [agg 1.9.0](https://github.com/asciinema/agg) | Strong on Linux CI. Asciinema 3 has headless mode, scripted commands, terminal sizing, and exit-status propagation. Asciinema itself does not support Windows. | `agg --select` can render selected terminal states, although its normal output is GIF. The web player supplies a poster state. | A compact `.cast` recording can be played interactively or converted to GIF with `agg`. | `agg` includes a Symbols Nerd Font fallback and supports extra font directories, emoji fonts, terminal size, themes, speed, FPS, and idle-time limits. | Best if copyable/searchable playback in the documentation is a later requirement; more moving parts than VHS for the current request. |

VHS is preferred because the requested static and moving assets can be generated from the same declarative tape. Freeze would require a second animation tool, while asciinema plus agg would add a recorder, renderer, and possibly a web-player dependency.

## Recommended capture design

### Repository layout

```text
assets/
  captures/
    overview.png
    overview.gif
    overview.webm
    themes/
      default-dark.png
      default-light.png
      ...
scripts/
  capture/
    Capture-GlyPreview.ps1
    New-GlyThemeGalleryTape.ps1
    overview.tape
    generated/
      theme-gallery.tape
```

Only stable source tapes/scripts and selected published assets should be committed. Temporary PNG frames and intermediate video files should be written under `artifacts/captures` and ignored.

`New-GlyThemeGalleryTape.ps1` should enumerate names from `Get-GlyTheme`, sort them ordinally, and generate repeated `Set-GlyTheme`, preview, and `Screenshot` tape commands. Generating the tape avoids duplicating the module's theme registry in documentation automation. A similar generator can later produce glyph-set gallery screenshots.

### Deterministic PowerShell setup

Every capture should:

- start `pwsh` with `-NoLogo -NoProfile`;
- import `./src/gly.psd1` directly rather than installing a released package;
- set `$global:GlyStyleRenderer = 'Ansi'` so rendering does not depend on host detection;
- set `$ProgressPreference = 'SilentlyContinue'` and use a minimal, fixed prompt;
- set `TERM=xterm-256color`, `COLORTERM=truecolor`, and `LANG=C.UTF-8` on Linux;
- set fixed VHS width, height, font size, line height, theme/background, typing speed, framerate, and cursor behavior;
- use fixed fixture names and the preview commands rather than listing the repository checkout;
- hide setup and cleanup commands with `Hide`/`Show`;
- wait for known screen text instead of relying only on machine-dependent sleep durations.

Use a pinned JetBrains Mono Nerd Font for the `NerdFonts` glyph set and a pinned color-emoji font for `Emoji`. The official VHS action supplies JetBrains Mono by default and can install extra fonts, including Nerd Font variants, with `install-fonts: true`. Pin the exact font release as part of the proof of concept if the action's rolling font bundle produces inconsistent results.

Theme previews need an explicit terminal background. The theme model describes file styles, not a complete terminal palette. Use a small capture manifest that marks each gallery entry as `dark` or `light`, then apply one fixed dark terminal background and one fixed light terminal background. Do not infer the developer's terminal theme.

### Illustrative VHS tape

This is a design sketch; validate shell quoting against the pinned VHS version before committing the workflow.

```text
Output assets/captures/overview.gif
Output assets/captures/overview.webm

Set Shell "pwsh --NoLogo --NoProfile"
Set Width 1000
Set Height 620
Set FontSize 18
Set FontFamily "JetBrainsMono Nerd Font Mono"
Set TypingSpeed 35ms
Set Framerate 30
Set CursorBlink false
Set Theme "Catppuccin Mocha"

Hide
Type "$ProgressPreference = 'SilentlyContinue'"
Enter
Type "Import-Module ./src/gly.psd1 -Force"
Enter
Type "$global:GlyStyleRenderer = 'Ansi'"
Enter
Type "function global:prompt { 'PS> ' }"
Enter
Type "Clear-Host"
Enter
Show

Type "Show-GlyThemePreview -Theme Dracula -GlyphSet NerdFonts"
Enter
Wait+Screen /Directory/
Sleep 1s
Screenshot assets/captures/overview.png
Sleep 2s
```

The overview animation should be short and demonstrate one clear story, such as changing a theme and glyph set and then showing the mock file list. The theme gallery should use static screenshots; repeating 90 themes in a GIF would be large and difficult to navigate.

## CI workflow shape

Start with `workflow_dispatch` and a pull-request verification trigger. Do not auto-commit directly to `master`.

```yaml
name: Capture terminal media

on:
  workflow_dispatch:
  pull_request:
    paths:
      - "src/**"
      - "scripts/capture/**"
      - ".github/workflows/captures.yml"

jobs:
  capture:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - name: Generate gallery tape
        shell: pwsh
        run: ./scripts/capture/New-GlyThemeGalleryTape.ps1

      - name: Render overview
        uses: charmbracelet/vhs-action@v2
        with:
          version: v0.11.0
          path: scripts/capture/overview.tape
          install-fonts: true

      - name: Render gallery
        uses: charmbracelet/vhs-action@v2
        with:
          version: v0.11.0
          path: scripts/capture/generated/theme-gallery.tape
          install-fonts: true

      - name: Verify committed captures
        run: git diff --exit-code -- assets/captures

      - uses: actions/upload-artifact@v6
        if: always()
        with:
          name: terminal-captures
          path: |
            assets/captures
            artifacts/captures
```

For production, pin third-party actions to full commit SHAs and let Dependabot update them. Also pin the VHS version, font archives, and any container digest. The existing repository convention uses version tags in workflow examples, so the sketch follows that style while making the production hardening explicit.

There are two safe update models:

1. CI regenerates and fails if committed captures differ. A contributor runs the same pinned container locally only when intentionally updating media.
2. A separate manually dispatched workflow generates assets on GitHub-hosted infrastructure and opens a generated-media pull request. This fully satisfies the goal of not requiring capture tools on the developer PC.

The second model is recommended after the proof of concept. It keeps binary changes reviewable and avoids granting a normal pull-request workflow write access.

## Publishing formats

### Root README

Use a committed PNG for the first visual and a short committed GIF only when motion adds meaningful information. GitHub renders PNG, GIF, and SVG images, but a README cannot host the script-based asciinema player. A hosted asciinema recording can only be represented there by a linked preview image.

Avoid relying on MP4 or WebM as the only README experience. Keep the GIF below a deliberately chosen size limit and link it to the documentation page containing the higher-quality video. Include descriptive alt text and a nearby text explanation.

### VitePress introduction

Reference shared committed assets by their root public path:

```markdown
![A gly preview showing colored file and directory rules](/captures/overview.png)
```

VitePress processes common image, media, and font assets and adjusts public paths for the configured base URL. For motion, use a controlled video with a static poster and GIF fallback link:

```html
<video controls preload="metadata" poster="/captures/overview.png">
  <source src="/captures/overview.webm" type="video/webm">
  <source src="/captures/overview.mp4" type="video/mp4">
</video>
```

Do not autoplay. A user must be able to pause motion, and the same operation should be described in text below the video.

### Theme gallery

Generate a Markdown page from theme registry data, with one lazy-loaded image and a short name/caption per theme. Organize light and dark captures separately and keep terminal dimensions identical so comparisons are meaningful. The first version should use PNG because it is predictable across README and VitePress. Re-evaluate SVG after measuring embedded-font file sizes and confirming all Nerd Font glyphs render identically on GitHub and GitHub Pages.

Ninety full-resolution PNGs may add substantial repository weight. Before committing the entire gallery, measure:

- total uncompressed and Git repository size;
- average and maximum PNG size after optimization;
- VitePress build output size;
- page load with native image lazy-loading;
- visual differences across repeated CI runs.

If the result is too large, create small gallery thumbnails plus a full-size image on demand, or publish the full gallery as a release/Pages artifact while committing only the thumbnails.

## Validation plan

The proof of concept is successful when all of the following are true:

- a GitHub-hosted Ubuntu runner generates all assets without an interactive desktop;
- the workflow imports the local module and renders ANSI colors, Unicode, Nerd Font icons, and emoji correctly;
- two consecutive runs from the same commit produce no changes under `assets/captures`;
- `npm run docs:build` resolves every image and video path;
- the README renders the PNG and GIF on GitHub;
- the VitePress page renders the PNG poster and both video sources;
- a light and a dark theme remain readable against their assigned capture backgrounds;
- generated media contains no absolute checkout paths, usernames, timestamps, or other machine-specific data;
- the animation has text documentation and does not autoplay.

Pixel comparison should tolerate a very small threshold only if identical bytes cannot be achieved. A threshold can hide real glyph or color changes, so first eliminate nondeterminism through pinned versions, fonts, dimensions, and renderer settings.

## Risks and mitigations

- **Font drift:** pin font archives or a container digest; verify a known Nerd Font glyph and emoji in CI.
- **Theme/background mismatch:** maintain explicit dark/light capture metadata rather than auto-detecting a terminal theme.
- **Binary repository growth:** optimize images, use thumbnails, and keep long videos out of Git history.
- **Stale screenshots:** run a capture diff check when renderer, themes, glyph sets, capture scripts, or relevant docs change.
- **Flaky timing:** use VHS `Wait` with stable output text and reserve `Sleep` for presentation pauses.
- **Unsafe write permissions:** let pull-request workflows read and verify only; use a separately approved manual workflow to open media-update pull requests.
- **Platform mismatch:** generate canonical documentation media on Linux CI and document that terminal rendering can differ slightly on Windows/macOS.
- **Accessibility:** provide alt text, captions or adjacent command transcripts, a static poster, controls, and no autoplay.

## Sources

- [VHS README and tape command reference](https://github.com/charmbracelet/vhs)
- [Official VHS GitHub Action](https://github.com/charmbracelet/vhs-action)
- [Freeze README](https://github.com/charmbracelet/freeze)
- [asciinema CLI](https://docs.asciinema.org/manual/cli/)
- [asciinema embedding guidance](https://docs.asciinema.org/manual/server/embedding/)
- [agg installation](https://docs.asciinema.org/manual/agg/installation/)
- [agg usage, fonts, timing, and rendering](https://docs.asciinema.org/manual/agg/usage/)
- [VitePress asset handling](https://vitepress.dev/guide/asset-handling)
- [GitHub supported non-code image formats](https://docs.github.com/en/repositories/working-with-files/using-files/working-with-non-code-files)

