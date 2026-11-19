#!/usr/bin/env bash
# sync.sh — забирает текущие скиллы и агентов из ~/.claude в этот репозиторий (запускать на основной macOS).
# Запуск из папки репозитория:  bash sync.sh   → потом проверить git status, закоммитить и запушить.
# Симлинки разворачиваются в обычные файлы (-L), чтобы на другой машине скиллы работали.

set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

rsync -aL --delete \
  --exclude 'synced/' --exclude '.trash/' --exclude '.DS_Store' \
  --exclude 'impeccable/scripts/bin/' \
  "$CLAUDE_DIR/skills/" "$REPO/skills/"

mkdir -p "$REPO/agents"
rsync -a --delete --exclude '.DS_Store' "$CLAUDE_DIR/agents/" "$REPO/agents/"

echo "Скиллов: $(find "$REPO/skills" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')," \
     "агентов: $(find "$REPO/agents" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')"
echo "Дальше: git status → проверить, что нет секретов → git add -A && git commit && git push"
