# Ограничения MVP gly

## PowerShell 7+

MVP поддерживает PowerShell `7+`. Windows PowerShell `5.1` не поддерживается.

## Format data живет в сессии

`gly` загружает `FileSystem.format.ps1xml` через `Update-FormatData -PrependPath`.

PowerShell format data применяется на уровне текущей сессии. После `Remove-Module gly` custom view может остаться активным до завершения сессии.

`Disable-Gly` отключает glyphs и цвета через конфигурацию, но не обещает полностью выгрузить format data.

## Нет persistent config

Конфигурация, пользовательские темы и пользовательские glyph sets хранятся только в памяти текущей PowerShell-сессии.

MVP не пишет пользовательскую конфигурацию на диск.

## Нет автоматического определения терминала

MVP не определяет автоматически:

- установлен ли Nerd Font;
- светлая или темная тема терминала;
- какой glyph set нужно выбрать;
- нужен ли fallback между glyph sets.

Эти параметры выбирает пользователь.

## Нет Git-aware форматирования

MVP не выполняет Git-команды и не вычисляет Git-статус файлов.

## Нет выделения executable-файлов

MVP не выделяет executable-файлы отдельным правилом. Это оставлено на будущие версии.

## Нет импорта тем из файлов

MVP не импортирует темы и glyph sets из `.json`, `.yaml`, `.psd1` или `.ps1`.

Регистрация выполняется только через PowerShell-объекты `hashtable` / `pscustomobject`.
