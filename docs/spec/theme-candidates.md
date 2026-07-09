---
title: Кандидаты для built-in тем
status: working-draft
language: ru
---

# Кандидаты для built-in тем

Документ содержит список популярных цветовых тем, используемых в редакторах кода и терминалах.

Цель документа - выбрать набор built-in тем для `gly`. Наличие темы в списке не означает, что она автоматически войдет в MVP.

Перед переносом конкретной палитры в `gly` нужно отдельно проверить:

- лицензию исходной темы;
- допустимость включения палитры в модуль;
- наличие dark / light вариантов;
- пригодность палитры для файлового вывода, а не только для syntax highlighting.

## Рекомендуемый MVP Shortlist

Предварительно наиболее разумные кандидаты для первой реализации:

- `DefaultDark` - собственная тема `gly`;
- `DefaultLight` - собственная тема `gly`;
- `NoColor` - отключение цветового оформления;
- `Dracula`;
- `Nord`;
- `GruvboxDark`;
- `GruvboxLight`;
- `CatppuccinMocha`;
- `CatppuccinLatte`;
- `TokyoNight`;
- `SolarizedDark`;
- `SolarizedLight`;

## Темы-Кандидаты

| Тема | Основные варианты | Почему в списке | Источник |
| --- | --- | --- | --- |
| Solarized | Dark, Light | Классическая палитра для терминалов и редакторов | [altercation/solarized](https://github.com/altercation/solarized) |
| Dracula | Dark | Одна из самых распространенных cross-app тем | [dracula/dracula-theme](https://github.com/dracula/dracula-theme) |
| Nord | Dark | Популярная холодная low-contrast палитра | [nordtheme/nord](https://github.com/nordtheme/nord) |
| Gruvbox | Dark, Light | Популярная ретро-палитра с хорошей читаемостью | [morhetz/gruvbox](https://github.com/morhetz/gruvbox) |
| Catppuccin | Latte, Frappe, Macchiato, Mocha | Современная тема с сильной экосистемой портов | [catppuccin/catppuccin](https://github.com/catppuccin/catppuccin) |
| Rosé Pine | Main, Moon, Dawn | Популярная мягкая палитра с dark/light вариантами | [rose-pine/rose-pine-theme](https://github.com/rose-pine/rose-pine-theme) |
| Tokyo Night | Night, Storm, Day, Moon | Очень популярная тема в Neovim/VS Code окружении | [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim) |
| Kanagawa | Wave, Dragon, Lotus | Популярная Neovim-тема с выразительной палитрой | [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) |
| Everforest | Dark, Light | Мягкая зеленоватая палитра, популярна в Vim/Neovim | [sainnhe/everforest](https://github.com/sainnhe/everforest) |
| One Dark | Dark | Классическая Atom-палитра, часто портируется | [atom/one-dark-syntax](https://github.com/atom/one-dark-syntax) |
| One Light | Light | Светлая пара для One Dark | [atom/one-light-syntax](https://github.com/atom/one-light-syntax) |
| One Dark Pro | Dark | Популярная VS Code вариация One Dark | [Binaryify/OneDark-Pro](https://github.com/Binaryify/OneDark-Pro) |
| GitHub Theme | Dark, Light, Dimmed, High Contrast | Официальная GitHub-палитра для VS Code | [primer/github-vscode-theme](https://github.com/primer/github-vscode-theme) |
| VS Code Default | Dark+, Light+, High Contrast | Базовые темы VS Code как reference для привычного UX | [microsoft/vscode theme-defaults](https://github.com/microsoft/vscode/tree/main/extensions/theme-defaults) |
| JetBrains Darcula | Dark | Дефолтная темная IDE-палитра JetBrains | [JetBrains/intellij-community themes](https://github.com/JetBrains/intellij-community/tree/master/platform/platform-resources/src/themes) |
| Monokai | Dark | Классическая палитра редакторов кода | [microsoft/vscode theme-monokai](https://github.com/microsoft/vscode/tree/main/extensions/theme-monokai) |
| Monokai Pro | Dark | Коммерчески популярная Monokai-family тема | [monokai.pro](https://monokai.pro/) |
| Molokai | Dark | Известная Vim-тема, близкая к Monokai | [tomasr/molokai](https://github.com/tomasr/molokai) |
| Material Theme | Dark, Light, Palenight, Ocean, etc. | Очень популярная VS Code theme family | [material-theme/vsc-material-theme](https://github.com/material-theme/vsc-material-theme) |
| Palenight | Dark | Популярная Material-like темная палитра | [whizkydee/vscode-material-palenight-theme](https://github.com/whizkydee/vscode-material-palenight-theme) |
| Ayu | Dark, Light, Mirage | Минималистичная тема с сильной редакторной историей | [ayu-theme/ayu-vim](https://github.com/ayu-theme/ayu-vim) |
| Night Owl | Dark, Light | Популярная VS Code тема Sarah Drasner | [sdras/night-owl-vscode-theme](https://github.com/sdras/night-owl-vscode-theme) |
| Cobalt2 | Dark | Известная насыщенная VS Code тема | [wesbos/cobalt2-vscode](https://github.com/wesbos/cobalt2-vscode) |
| SynthWave '84 | Dark | Популярная neon / retro тема | [robb0wen/synthwave-vscode](https://github.com/robb0wen/synthwave-vscode) |
| Shades of Purple | Dark | Популярная яркая VS Code тема | [ahmadawais/shades-of-purple-vscode](https://github.com/ahmadawais/shades-of-purple-vscode) |
| Horizon | Dark | Современная красно-фиолетовая палитра | [jolaleye/horizon-theme-vscode](https://github.com/jolaleye/horizon-theme-vscode) |
| Omni | Dark | Популярная тема Rocketseat / VS Code ecosystem | [getomni/vscode](https://github.com/getomni/vscode) |
| Noctis | Dark, Light | Большая theme family для VS Code | [liviuschera/noctis](https://github.com/liviuschera/noctis) |
| Andromeda | Dark | Популярная dark theme для VS Code и терминалов | [EliverLara/Andromeda](https://github.com/EliverLara/Andromeda) |
| Aura | Dark | Современная фиолетовая тема с портами | [daltonmenezes/aura-theme](https://github.com/daltonmenezes/aura-theme) |
| Eva Theme | Dark, Light | Палитра с редакторными портами | [fisheva/Eva-Theme](https://github.com/fisheva/Eva-Theme) |
| City Lights | Dark | Популярная dark theme для VS Code | [Yummygum/city-lights-syntax-vsc](https://github.com/Yummygum/city-lights-syntax-vsc) |
| Jellybeans | Dark | Классическая Vim-тема | [nanotech/jellybeans.vim](https://github.com/nanotech/jellybeans.vim) |
| PaperColor | Dark, Light | Популярная Vim-тема с light/dark вариантами | [NLKNguyen/papercolor-theme](https://github.com/NLKNguyen/papercolor-theme) |
| Oceanic Next | Dark | Известная редакторная палитра | [voronianski/oceanic-next-color-scheme](https://github.com/voronianski/oceanic-next-color-scheme) |
| Sonokai | Dark | Современная Vim/Neovim тема от автора Everforest | [sainnhe/sonokai](https://github.com/sainnhe/sonokai) |
| Edge | Dark, Light | Vim/Neovim theme family от автора Everforest | [sainnhe/edge](https://github.com/sainnhe/edge) |
| Nightfox | Nightfox, Dayfox, Dawnfox, Nordfox, Carbonfox, etc. | Популярная Neovim theme family с несколькими вариантами | [EdenEast/nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) |
| Flexoki | Dark, Light | Современная low-contrast палитра от автора Obsidian | [kepano/flexoki](https://github.com/kepano/flexoki) |
| Serendipity | Dark, Light | Современная theme family с портами | [serendipity-theme/serendipity](https://github.com/serendipity-theme/serendipity) |
| Iceberg | Dark, Light | Спокойная синяя Vim-тема | [cocopon/iceberg.vim](https://github.com/cocopon/iceberg.vim) |
| Srcery | Dark | Популярная терминально-ориентированная Vim-тема | [srcery-colors/srcery-vim](https://github.com/srcery-colors/srcery-vim) |
| Apprentice | Dark | Low-contrast Vim-тема | [romainl/Apprentice](https://github.com/romainl/Apprentice) |
| Deus | Dark | Vim-тема с заметной contrast-палитрой | [ajmwagar/vim-deus](https://github.com/ajmwagar/vim-deus) |
| Vitesse | Dark, Light | Популярная минималистичная VS Code тема Anthony Fu | [antfu/vscode-theme-vitesse](https://github.com/antfu/vscode-theme-vitesse) |
| Poimandres | Dark | Популярная мягкая dark theme | [drcmda/poimandres-theme](https://github.com/drcmda/poimandres-theme) |
| Spacegray | Dark | Известная Sublime/TextMate-era тема | [kkga/spacegray](https://github.com/kkga/spacegray) |
| Gotham | Dark | Темная терминально-редакторная палитра | [whatyouhide/vim-gotham](https://github.com/whatyouhide/vim-gotham) |
| Flatland | Dark | Классическая Sublime-era тема | [thinkpixellab/flatland](https://github.com/thinkpixellab/flatland) |
| Paraiso | Dark, Light | Base16-era палитра Chris Kempson family | [idleberg/Paraiso-Color-Scheme](https://github.com/idleberg/Paraiso-Color-Scheme) |

## Коллекции Терминальных Тем

Эти источники полезны для поиска terminal-specific портов и дополнительных кандидатов:

| Коллекция | Назначение | Источник |
| --- | --- | --- |
| Base16 schemes | Большой набор схем в Base16-формате | [tinted-theming/base16-schemes](https://github.com/tinted-theming/base16-schemes) |
| iTerm2 Color Schemes | Большая коллекция terminal color schemes | [mbadolato/iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes) |
| Gogh | Коллекция тем для GNOME Terminal, Tilix, XFCE4 Terminal и др. | [Gogh-Co/Gogh](https://github.com/Gogh-Co/Gogh) |
| Alacritty Theme | Коллекция тем для Alacritty | [alacritty/alacritty-theme](https://github.com/alacritty/alacritty-theme) |
| Windows Terminal schemes | Встроенные / reference-схемы Windows Terminal tooling | [microsoft/terminal ColorTool schemes](https://github.com/microsoft/terminal/tree/main/src/tools/ColorTool/schemes) |

## Критерии Отбора Для gly

При выборе built-in тем для `gly` стоит предпочитать темы, которые:

- имеют и dark, и light варианты;
- имеют открытую лицензию;
- хорошо работают в терминальном контексте;
- имеют узнаваемую, но не слишком агрессивную палитру;
- позволяют различать директории, файлы, symlink, hidden, readonly и extension-группы;
- не требуют копирования сложной IDE UI-палитры целиком.

## Открытые Вопросы

1. Сколько тем должно войти в MVP.
2. Какие темы из списка должны быть обязательными built-in.
3. Нужны ли порты тем один-в-один или `gly`-адаптации по мотивам исходных палитр.
