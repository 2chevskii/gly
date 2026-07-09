## Вдохновление

Идея и функциональность модуля вдохновлена такими модулями, как:
- [Terminal-Icons](https://github.com/devblackops/Terminal-Icons)
- [DirColors](https://github.com/DHowett/DirColors)
- [PSFileIcons](https://github.com/hanthor/PSFileIcons)
- [GlyphShell](https://github.com/SemperFu/GlyphShell)
А также утилитами:
- [eza](https://github.com/eza-community/eza)
- [GNU coreutils ls](https://github.com/coreutils/coreutils/blob/master/src/ls.c)
## Описание модуля

Модуль добавляет специальное форматирование для вывода коммандлета [Get-ChildItem](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem), а также всех остальных, которые используют в пайплайнах [System::IO::FileInfo](https://learn.microsoft.com/en-us/dotnet/api/system.io.fileinfo) и [System::IO::DirectoryInfo](https://learn.microsoft.com/en-us/dotnet/api/system.io.directoryinfo), например - [Get-Item](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-item).

Модуль предоставляет возможность настройки тем оформления, позволяя раздельно настроить цвета для файлов и папок, а также, набор глифов.

Модуль предоставляет встроенный набор глифов и темы.

В качестве иконок для файлов и папок, по умолчанию используются глифы из [NerdFonts](https://www.nerdfonts.com/). Таким образом, для корректной работы модуля, требуется поддержка данных глифов в терминале пользователя.
