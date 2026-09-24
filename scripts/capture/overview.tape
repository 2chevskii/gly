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

Hide
Type "$env:TERM = 'xterm-256color'"
Enter
Type "$env:COLORTERM = 'truecolor'"
Enter
Type "$env:LANG = 'C.UTF-8'"
Enter
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
