# Validation Checklist

Перед финальным ответом агент должен выполнить релевантные проверки.

## После изменения документации

- Проверить список измененных файлов:

  ```powershell
  rtk git status --short
  ```

- Проверить, что markdown-файлы открываются и не содержат случайных placeholder-ов вроде `TODO` без причины.

## После изменения PowerShell-кода

- Smoke import:

  ```powershell
  rtk pwsh -NoProfile -Command "Import-Module ./src/gly/gly.psd1 -Force"
  ```

- Проверка публичных команд:

  ```powershell
  rtk pwsh -NoProfile -Command "Import-Module ./src/gly/gly.psd1 -Force; Get-Command -Module gly"
  ```

- Pester, если установлен:

  ```powershell
  rtk pwsh -NoProfile -Command "Invoke-Pester ./tests"
  ```

## После изменения format data

- Проверить `Get-ChildItem`:

  ```powershell
  rtk pwsh -NoProfile -Command "Import-Module ./src/gly/gly.psd1 -Force; Get-ChildItem . | Format-Table"
  ```

- Проверить `Get-Item`:

  ```powershell
  rtk pwsh -NoProfile -Command "Import-Module ./src/gly/gly.psd1 -Force; Get-Item . | Format-Table"
  ```

- Проверить, что `Select-Object` продолжает работать с исходными объектами:

  ```powershell
  rtk pwsh -NoProfile -Command "Import-Module ./src/gly/gly.psd1 -Force; Get-Item . | Select-Object -First 1 -Property Name,FullName,Attributes"
  ```

## Если проверка невозможна

В финальном ответе явно указать:

- какая проверка не выполнена;
- почему;
- что было проверено вместо нее.

