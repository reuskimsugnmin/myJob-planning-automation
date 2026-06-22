#!/usr/bin/env bash
# 세션 종료 시 당일 Figma 쓰기 횟수를 집계해 세션 로그에 기록.
# 로그는 현재 작업 디렉토리(워크스페이스)의 ./.planning/logs 에 누적된다.
set -euo pipefail

LOG_DIR="${PLANNING_LOG_DIR:-./.planning/logs}"
# 로그 디렉토리가 없으면(디자인 작업을 안 한 세션) 조용히 종료.
[ -d "$LOG_DIR" ] || exit 0

TS="$(date '+%Y-%m-%dT%H:%M:%S')"
TODAY="$(date '+%Y-%m-%d')"

FIGMA_LOG="$LOG_DIR/figma-writes.jsonl"
if [ -f "$FIGMA_LOG" ]; then
  DONE_CNT="$(grep -c "\"phase\":\"done\"" "$FIGMA_LOG" 2>/dev/null | tr -d '[:space:]' || echo 0)"
  ERR_CNT="$(grep -c "\"error\":" "$LOG_DIR/errors.jsonl" 2>/dev/null | tr -d '[:space:]' || echo 0)"
else
  DONE_CNT=0
  ERR_CNT=0
fi

printf '{"ts":"%s","event":"session_stop","date":"%s","figma_writes_total":%s,"errors_total":%s}\n' \
  "$TS" "$TODAY" "${DONE_CNT:-0}" "${ERR_CNT:-0}" >> "$LOG_DIR/session.jsonl"

exit 0
