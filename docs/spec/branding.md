---
title: Брендинг модуля
status: working-draft
language: ru
selected_name: gly
---

# Брендинг модуля

Данный файл фиксирует актуальные решения по брендингу модуля:

- название;
- правила написания;
- naming conventions для публичных сущностей;
- открытые вопросы по alias, логотипу и визуальным артефактам.

Краткая спецификация модуля: [[introduction-spec]]
Полная спецификация модуля: [[full-spec]]

## Название

Публичное имя модуля: `gly`.

Причины выбора:

- короткое и произносимое;
- ассоциируется с glyph, что отражает заметную часть визуального поведения модуля;
- не выглядит как длинная техническая аббревиатура;
- подходит как module name и cmdlet noun;
- не привязывает модуль только к `ls`, потому что модуль форматирует объекты `FileInfo` / `DirectoryInfo` в PowerShell pipeline.

## Написание

Правила написания:

- module name: `gly`;
- имя в тексте: `gly`;
- PowerShell noun: `Gly`;
- переменные и внутренние сущности: `Gly*`;
- названия файлов модуля: `gly.psd1`, `gly.psm1`.

Не используем варианты:

- `Gly` как основное текстовое имя модуля;
- `GLY`;
- `gly-shell`;
- `gly-ls`;
- `ps-gly`, если это не потребуется для публикации или избежания конфликта имен.

## Cmdlet Naming

Для публичных cmdlet используется noun `Gly`.

Основные cmdlet:

- `Enable-Gly`
- `Disable-Gly`
- `Get-GlyConfiguration`
- `Set-GlyConfiguration`
- `Get-GlyTheme`
- `Set-GlyTheme`
- `Register-GlyTheme`
- `Copy-GlyTheme`
- `Get-GlyGlyphSet`
- `Set-GlyGlyphSet`
- `Register-GlyGlyphSet`
- `Copy-GlyGlyphSet`
- `Show-GlyTree`
- `Show-GlyGrid`

Preference-переменная:

- `$GlyStyleRenderer`

## Aliases

Модуль должен предоставлять короткие aliases для интерактивного использования.

### gly

`gly` является alias для основной точки входа форматирования.

Назначение:

- принять `System.IO.FileInfo`;
- принять `System.IO.DirectoryInfo`;
- принять список объектов `FileInfo` / `DirectoryInfo`;
- применить текущую конфигурацию темы, набора глифов и renderer backend;
- вывести результат в выбранном по умолчанию формате.

Предварительное целевое имя команды, на которую указывает alias: `Show-Gly`.

`Show-Gly` должна поддерживать и pipeline input, и параметры `-Path` / `-LiteralPath`.

### glytr

`glytr` является alias для `Show-GlyTree`.

Назначение:

- короткий интерактивный вызов древовидного renderer;
- избегает слишком короткого `glt`, который легче конфликтует с пользовательскими aliases.

### glygr

`glygr` является alias для `Show-GlyGrid`.

Назначение:

- короткий интерактивный вызов grid renderer;
- избегает слишком короткого `glg`, который легче конфликтует с пользовательскими aliases.

## Позиционирование

Короткое описание:

> `gly` добавляет настраиваемое визуальное форматирование для объектов файловой системы PowerShell.

Расширенное описание:

> `gly` предоставляет темы, наборы глифов и дополнительные renderer-команды для отображения `System.IO.FileInfo` и `System.IO.DirectoryInfo` в PowerShell, сохраняя объектную модель и совместимость с pipeline.

## Визуальные Артефакты

Для брендинга проекта требуются raster-артефакты.

Обязательные артефакты:

- баннер `16:9`;
- иконка / логотип `1:1`;
- resized-варианты иконки: `512px`, `256px`, `128px`, `64px`.

Созданные файлы:

- `assets/branding/gly-banner.png`
- `assets/branding/gly-logo.png`
- `assets/branding/gly-logo-512.png`
- `assets/branding/gly-logo-256.png`
- `assets/branding/gly-logo-128.png`
- `assets/branding/gly-logo-64.png`

Визуальное направление:

- чистый terminal / PowerShell / filesystem контекст;
- акцент на glyph, цветовую тему и структурированный вывод;
- без имитации существующих логотипов PowerShell, Microsoft, Nerd Fonts, eza или других проектов;
- без мелкого текста, который должен быть читаемым внутри картинки;
- без перегруженных деталей, чтобы логотип работал в малом размере.

## Открытые Вопросы

1. Нужна ли отдельная monochrome-версия логотипа. Не блокирует MVP.
