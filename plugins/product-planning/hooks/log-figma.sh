#!/usr/bin/env bash
# Figma use_figma 호출 로그. PreToolUse/PostToolUse 공용.
# 사용법: log-figma.sh <phase>   (phase = start | done)
# stdin: Claude Code 훅 JSON (tool_name, tool_input, tool_response 등)
# 로그는 현재 작업 디렉토리(워크스페이스)의 ./.planning/logs 에 누적된다.
set -euo pipefail

PHASE="${1:-unknown}"
LOG_DIR="${PLANNING_LOG_DIR:-./.planning/logs}"
mkdir -p "$LOG_DIR" 2>/dev/null || exit 0

# jq 없으면 로깅을 조용히 건너뛴다(워크플로우를 막지 않음).
command -v jq >/dev/null 2>&1 || exit 0

INPUT="$(cat)"
TS="$(date '+%Y-%m-%dT%H:%M:%S')"

# tool_input 에서 실행 스크립트 요약(앞 200자)과 파일 키를 추출.
SUMMARY="$(printf '%s' "$INPUT" | jq -rc '
  (.tool_input // {}) as $i
  | {
      script: ($i.script // $i.code // $i.command // "" | tostring | .[0:200]),
      fileKey: ($i.fileKey // $i.file_key // null),
      nodeId:  ($i.nodeId  // $i.node_id  // null)
    }' 2>/dev/null || echo '{}')"

# PostToolUse 단계에서는 에러 여부도 기록. -c(compact)로 JSON 값 형태 유지.
ERR="$(printf '%s' "$INPUT" | jq -c '
  (.tool_response // {}) as $r
  | if ($r | type) == "object" then ($r.error // $r.isError // null) else null end' 2>/dev/null || echo null)"
[ -z "$ERR" ] && ERR="null"

printf '{"ts":"%s","tool":"use_figma","phase":"%s","detail":%s,"error":%s}\n' \
  "$TS" "$PHASE" "$SUMMARY" "$ERR" >> "$LOG_DIR/figma-writes.jsonl"

# 에러가 있으면 별도 에러 로그에도 적재.
if [ "$ERR" != "null" ] && [ "$ERR" != "false" ]; then
  printf '{"ts":"%s","source":"use_figma","error":%s}\n' "$TS" "$ERR" >> "$LOG_DIR/errors.jsonl"
fi

exit 0
