# gly

`gly` - PowerShell-модуль для настраиваемого визуального форматирования объектов файловой системы:

- `System.IO.FileInfo`
- `System.IO.DirectoryInfo`

Цель модуля - улучшить интерактивный вывод `Get-ChildItem`, `Get-Item` и пользовательских команд, которые возвращают файловые объекты PowerShell, сохранив объектную модель и совместимость с pipeline.

## Статус

Репозиторий подготовлен как рабочая область для реализации MVP. Исходные проектные материалы лежат в `docs/spec/`, основной документ для передачи агенту-исполнителю - `docs/agent-implementation-plan.md`.

## Ключевые решения

- Минимальная версия PowerShell: `7.0`.
- Windows PowerShell `5.1` не поддерживается в MVP.
- Модуль активируется автоматически при `Import-Module`.
- Стандартный table view меняет только колонку `Name`: добавляет glyph и цвет.
- Human-readable размер, дата, tree/grid/compact/long views реализуются отдельными renderer-командами.
- Темы и glyph sets задаются объектами PowerShell: `hashtable` / `pscustomobject`.
- Постоянное хранение конфигурации на диске не входит в MVP.
- Автоматическое определение Nerd Font и dark/light терминала не входит в MVP.

## Документы

- `docs/spec/full-spec.md` - полная текущая спецификация из проектной папки.
- `docs/spec/branding.md` - naming, aliases и визуальные артефакты.
- `docs/spec/theme-candidates.md` - список кандидатов для built-in тем.
- `docs/agent-implementation-plan.md` - пошаговый план реализации для агента.
- `AGENTS.md` - правила работы агентов в этом репозитории.
- `.agents/` - дополнительные agent-facing правила, чеклисты и контекст.

