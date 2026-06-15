#!/usr/bin/env bash
# install.sh — разворачивает настройки Claude Code на macOS/Linux.
# Запуск из папки репозитория:  bash install.sh
# Скрипт НЕ перезаписывает существующий settings.json и НЕ трогает секреты.

set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "==> Разворачиваю настройки Claude Code в $CLAUDE_DIR"

# --- 1. Skills ---
if [ -d "$REPO/skills" ]; then
  mkdir -p "$CLAUDE_DIR/skills"
  cp -R "$REPO/skills/." "$CLAUDE_DIR/skills/"
  echo "    [OK] Скопировано скиллов: $(find "$CLAUDE_DIR/skills" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')"
fi

# --- 2. settings.json ---
if [ -f "$REPO/settings.json.example" ]; then
  if [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo "    [!] settings.json уже существует — НЕ перезаписываю. Сравни с settings.json.example"
  else
    mkdir -p "$CLAUDE_DIR"
    cp "$REPO/settings.json.example" "$CLAUDE_DIR/settings.json"
    echo "    [OK] settings.json установлен"
  fi
fi

# --- 3. MCP (только кроссплатформенные) через jq, если доступен ---
CLAUDE_JSON="$HOME/.claude.json"
if command -v jq >/dev/null 2>&1 && [ -f "$CLAUDE_JSON" ]; then
  tmp="$(mktemp)"
  jq '.mcpServers.playwright = {"type":"stdio","command":"npx","args":["@playwright/mcp@latest"],"env":{}}
      | .mcpServers.higgsfield = {"type":"http","url":"https://mcp.higgsfield.ai/mcp"}' \
      "$CLAUDE_JSON" > "$tmp" && mv "$tmp" "$CLAUDE_JSON"
  echo "    [OK] MCP playwright и higgsfield добавлены в .claude.json"
else
  echo "    [!] jq не найден или нет .claude.json — добавь MCP вручную из mcp-servers.template.json"
fi

echo ""
echo "==> Готово. Платформо-зависимые MCP (pencil, blender) доделай вручную — см. mcp-servers.template.json"
