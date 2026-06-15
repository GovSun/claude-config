# claude-config

Мои личные настройки [Claude Code](https://claude.com/claude-code): skills, конфигурация MCP-серверов и плагинов. Приватный репозиторий — чтобы разворачивать одни и те же настройки на разных машинах (macOS, Windows).

## Что внутри

| Файл / папка | Что это |
|---|---|
| `skills/` | Все мои скиллы (копируются в `~/.claude/skills/`) |
| `settings.json.example` | Базовый `settings.json` (модель, права, плагины) |
| `mcp-servers.template.json` | Шаблон MCP с подсказками по путям для разных ОС |
| `mcp-servers.macos.json` | Реальный рабочий снимок MCP с macOS (референс) |
| `plugins-config/` | Список установленных плагинов и маркетплейсов |
| `install.sh` | Установщик для macOS/Linux |
| `install.ps1` | Установщик для Windows (PowerShell) |
| `.gitignore` | Защита от заливки секретов и мусора |

> **Важно:** файл `~/.claude.json` целиком сюда НЕ кладётся — в нём `userID`, OAuth и личные данные. Переносится только секция `mcpServers`.

---

## Как развернуть на новой машине (Windows)

### Шаг 1. Установи нужное ПО
- **Git** — https://git-scm.com/download/win
- **GitHub CLI (gh)** — https://cli.github.com/  (или `winget install GitHub.cli`)
- **Node.js** (нужен для MCP playwright) — https://nodejs.org/
- **Claude Code** — https://claude.com/claude-code

### Шаг 2. Авторизуйся в GitHub
В PowerShell:
```powershell
gh auth login
```
Выбирай: GitHub.com → HTTPS → Yes (авторизация через браузер) → войди под своим аккаунтом.

### Шаг 3. Склонируй этот репозиторий
```powershell
cd $env:USERPROFILE
gh repo clone GovSun/claude-config
cd claude-config
```

### Шаг 4. Запусти Claude Code хотя бы раз
Чтобы создался файл `%USERPROFILE%\.claude.json`. Потом закрой его.

### Шаг 5. Запусти установщик
```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```
Скрипт сам разложит skills, settings и кроссплатформенные MCP (playwright, higgsfield).

### Шаг 6. Доделай платформо-зависимые MCP вручную
- **pencil** — нужен установленный десктоп-Pencil; путь к его `mcp-server` указан в `mcp-servers.template.json`.
- **blender** — установи [uv](https://docs.astral.sh/uv/), затем сервер запускается как `uvx blender-mcp`.

Подробные подсказки по путям — в комментариях `mcp-servers.template.json`.

---

## Как развернуть на macOS/Linux
```bash
gh repo clone GovSun/claude-config
cd claude-config
bash install.sh
```

---

## Как обновить настройки в репозитории (с macOS, где они «эталонные»)
Когда добавил/поменял скиллы или MCP на основной машине — обнови репо:
```bash
cd ~/claude-config
cp -R ~/.claude/skills/. ./skills/
git add -A
git commit -m "Обновил skills"
git push
```
А на другой машине потом: `git pull` и снова `install`.
