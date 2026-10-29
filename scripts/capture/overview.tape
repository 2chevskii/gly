Output assets/captures/overview.gif
Output assets/captures/overview.webm
Require pwsh

Set Shell pwsh
Set Width 1000
Set Height 620
Set FontFamily "JetBrainsMono Nerd Font Mono"
Set FontSize 18
Set LineHeight 1.2
Set TypingSpeed 35ms
Set Framerate 30
Set CursorBlink false
Set Theme "Catppuccin Mocha"

Source scripts/capture/setup.tape

Type "Show-GlyThemePreview -Theme Dracula -GlyphSet NerdFonts | Select-Object -First 12; Write-Output ('Theme' + ': ' + 'Dracula')"
Enter
Wait+Screen /Theme: Dracula/
Sleep 1s
Screenshot assets/captures/overview.png
Sleep 1s

Type "Clear-Host; Show-GlyThemePreview -Theme DefaultLight -GlyphSet Emoji | Select-Object -First 12; Write-Output ('Theme' + ': ' + 'DefaultLight')"
Enter
Wait+Screen /Theme: DefaultLight/
Sleep 2s
