# install.ps1 — разворачивает настройки Claude Code на Windows.
# Запуск из папки репозитория:  powershell -ExecutionPolicy Bypass -File .\install.ps1
# Скрипт НЕ перезаписывает твои существующие файлы без спроса и НЕ трогает секреты.

$ErrorActionPreference = "Stop"
$repo = $PSScriptRoot
$claudeDir = Join-Path $env:USERPROFILE ".claude"

Write-Host "==> Разворачиваю настройки Claude Code в $claudeDir" -ForegroundColor Cyan

# --- 1. Skills ---
$skillsSrc = Join-Path $repo "skills"
$skillsDst = Join-Path $claudeDir "skills"
if (Test-Path $skillsSrc) {
    New-Item -ItemType Directory -Force -Path $skillsDst | Out-Null
    Copy-Item -Path (Join-Path $skillsSrc "*") -Destination $skillsDst -Recurse -Force
    $count = (Get-ChildItem $skillsSrc -Directory).Count
    Write-Host "    [OK] Скопировано скиллов: $count" -ForegroundColor Green
}

# --- 1b. Агенты ---
$agentsSrc = Join-Path $repo "agents"
$agentsDst = Join-Path $claudeDir "agents"
if (Test-Path $agentsSrc) {
    New-Item -ItemType Directory -Force -Path $agentsDst | Out-Null
    Copy-Item -Path (Join-Path $agentsSrc "*") -Destination $agentsDst -Recurse -Force
    $count = (Get-ChildItem $agentsSrc -Filter *.md).Count
    Write-Host "    [OK] Скопировано агентов: $count" -ForegroundColor Green
}

# --- 2. settings.json ---
$setSrc = Join-Path $repo "settings.json.example"
$setDst = Join-Path $claudeDir "settings.json"
if (Test-Path $setSrc) {
    if (Test-Path $setDst) {
        Write-Host "    [!] settings.json уже существует — НЕ перезаписываю." -ForegroundColor Yellow
        Write-Host "        Сравни вручную с: $setSrc"
    } else {
        New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null
        Copy-Item $setSrc $setDst
        Write-Host "    [OK] settings.json установлен" -ForegroundColor Green
    }
}

# --- 3. MCP-серверы (только кроссплатформенные: playwright, higgsfield) ---
$claudeJson = Join-Path $env:USERPROFILE ".claude.json"
$crossPlatform = @{
    playwright = @{ type = "stdio"; command = "npx"; args = @("@playwright/mcp@latest"); env = @{} }
    higgsfield = @{ type = "http"; url = "https://mcp.higgsfield.ai/mcp" }
}
if (Test-Path $claudeJson) {
    $cfg = Get-Content $claudeJson -Raw | ConvertFrom-Json
    if (-not $cfg.mcpServers) { $cfg | Add-Member -NotePropertyName mcpServers -NotePropertyValue (@{}) }
    foreach ($name in $crossPlatform.Keys) {
        $cfg.mcpServers | Add-Member -NotePropertyName $name -NotePropertyValue $crossPlatform[$name] -Force
    }
    ($cfg | ConvertTo-Json -Depth 20) | Set-Content $claudeJson -Encoding UTF8
    Write-Host "    [OK] MCP playwright и higgsfield добавлены в .claude.json" -ForegroundColor Green
} else {
    Write-Host "    [!] $claudeJson не найден. Запусти Claude Code хотя бы раз, потом повтори." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==> Готово. ВРУЧНУЮ доделай платформо-зависимые MCP:" -ForegroundColor Cyan
Write-Host "    - pencil  : требует установленного приложения Pencil (см. mcp-servers.template.json)"
Write-Host "    - blender : установи uv (https://docs.astral.sh/uv/), затем добавь сервер blender-mcp"
Write-Host "    Подсказки по путям — в mcp-servers.template.json"
