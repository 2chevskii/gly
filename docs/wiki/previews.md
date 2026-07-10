# Theme and Glyph Previews

Preview commands display the fallback and every registered matcher in themes and glyph sets. They return objects, so their rows can still be filtered, selected, or exported through the PowerShell pipeline.

## Theme Colors

`Show-GlyThemeColor` displays each distinct style once. Matchers that share a style, such as symbolic links and junctions in built-in themes, are combined in one row:

```powershell
Show-GlyThemeColor
Show-GlyThemeColor DefaultLight
```

The command uses the active theme when `-Theme` is omitted.

## Glyphs

`Show-GlyGlyph` displays the symbol assigned to every glyph matcher:

```powershell
Show-GlyGlyph
Show-GlyGlyph Unicode
```

The command uses the active glyph set when `-GlyphSet` is omitted.

## Combined Preview

`Show-GlyThemePreview` combines the selected theme and glyph set:

```powershell
Show-GlyThemePreview
Show-GlyThemePreview -Theme Dracula -GlyphSet NerdFonts
```

When one side does not contain the other side's matcher, its default style or glyph is used. This supports custom themes and glyph sets whose rule catalogs differ. Preview commands do not change the active configuration.

Color previews contain ANSI escape sequences and are intended for an ANSI-capable terminal. Their `Matcher`, `Color`, `Glyph`, and `Preview` properties remain available for pipeline processing.
