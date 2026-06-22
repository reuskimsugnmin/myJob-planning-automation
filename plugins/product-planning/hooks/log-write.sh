#!/usr/bin/env bash
# 로컬 파일 쓰기 로그. Write/Edit PostToolUse 용.
# stdin: Claude Code 훅 JSON
# 로그는 현재 작업 디렉토리(워크스페이스)의 ./.planning/logs 에 누적된다.
set -euo pipefail

LOG_DIR="${PLANNING_LOG_DIR:-./.planning/logs}"
mkdir -p "$LOG_DIR" 2>/dev/null || exit 0
command -v jq >/dev/null 2>&1 || exit 0

INPUT="$(cat)"
TS="$(date '+%Y-%m-%dT%H:%M:%S')"

FILE="$(printf '%s' "$INPUT" | jq -rc '(.tool_input.file_path // .tool_input.path // "unknown")' 2>/dev/null || echo unknown)"
TOOL="$(printf '%s' "$INPUT" | jq -rc '(.tool_name // "Write")' 2>/dev/null || echo Write)"

printf '{"ts":"%s","event":"file_write","tool":"%s","file":"%s"}\n' \
  "$TS" "$TOOL" "$FILE" >> "$LOG_DIR/writes.jsonl"

exit 0
