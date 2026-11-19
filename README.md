# claude-config

Мои настройки [Claude Code](https://claude.com/claude-code): скиллы, агенты, конфигурация MCP-серверов и плагинов. Чтобы разворачивать одни и те же настройки на разных машинах (macOS, Windows). Репозиторий публичный — секретов здесь нет и быть не должно.

## Что внутри

| Файл / папка | Что это |
|---|---|
| `skills/` | Мои скиллы — 127 штук (копируются в `~/.claude/skills/`) |
| `agents/` | Сабагенты — 159 штук (копируются в `~/.claude/agents/`) |
| `settings.json.example` | Базовый `settings.json` (модель, права, плагины) |
| `mcp-servers.template.json` | Шаблон MCP с подсказками по путям для разных ОС |
| `mcp-servers.macos.json` | Реальный рабочий снимок MCP с macOS (референс) |
| `plugins-config/` | Список установленных плагинов и маркетплейсов |
| `install.sh` | Установщик для macOS/Linux |
| `install.ps1` | Установщик для Windows (PowerShell) |
| `sync.sh` | Забирает текущие скиллы и агентов из `~/.claude` в репозиторий |
| `.gitignore` | Защита от заливки секретов и мусора |

> **Важно:** файл `~/.claude.json` целиком сюда НЕ кладётся — в нём `userID`, OAuth и личные данные. Переносится только секция `mcpServers`.

**Чего здесь нет специально:**
- `~/.claude/skills/synced/` — скиллы Anthropic с claude.ai (pdf, docx, xlsx, deep-research…). Подтягиваются сами после входа в аккаунт.
- Движок `impeccable` (`skills/impeccable/scripts/bin/`) — скилл скачивает его сам при первом запуске.
- Скиллы из плагинов (Figma, taste-skill) — ставятся через `/plugin`, список в `plugins-config/`.

---

## Как развернуть на новой машине (Windows)

### Шаг 1. Установи нужное ПО
- **Git** — https://git-scm.com/download/win
- **Node.js** (нужен для MCP playwright) — https://nodejs.org/
- **Claude Code** — https://claude.com/claude-code

### Шаг 2. Склонируй этот репозиторий
Входить в GitHub не нужно — репозиторий публичный. В PowerShell:
```powershell
cd $env:USERPROFILE
git clone https://github.com/GovSun/claude-config
cd claude-config
```

### Шаг 3. Запусти Claude Code хотя бы раз
Чтобы создался файл `%USERPROFILE%\.claude.json`. Потом закрой его.

### Шаг 4. Запусти установщик
```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```
Скрипт сам разложит скиллы, агентов, settings и кроссплатформенные MCP (playwright, higgsfield).

### Шаг 5. Доделай платформо-зависимые MCP вручную
- **pencil** — нужен установленный десктоп-Pencil; путь к его `mcp-server` указан в `mcp-servers.template.json`.
- **blender** — установи [uv](https://docs.astral.sh/uv/), затем сервер запускается как `uvx blender-mcp`.

Подробные подсказки по путям — в комментариях `mcp-servers.template.json`.

---

## Как развернуть на macOS/Linux
```bash
git clone https://github.com/GovSun/claude-config
cd claude-config
bash install.sh
```

---

## Как обновить настройки в репозитории (с macOS, где они «эталонные»)
Когда добавил/поменял скиллы или агентов на основной машине — обнови репо:
```bash
cd ~/claude-config
bash sync.sh          # забирает ~/.claude/skills и ~/.claude/agents, симлинки разворачивает в файлы
git status            # посмотреть, что изменилось; секретов быть не должно — репозиторий публичный
git add -A
git commit -m "Обновил скиллы и агентов"
git push
```
А на другой машине потом: `git pull` и снова `install`.
