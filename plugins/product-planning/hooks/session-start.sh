#!/usr/bin/env bash
# SessionStart 훅: 기획 워크스페이스를 감지해 소스 레지스트리와 워크플로우 컨벤션을
# 세션 컨텍스트로 주입한다. (산출물은 항상 현재 작업 디렉토리에 생성됨)
set -euo pipefail

SOURCES="./.planning/sources.json"
KB_DIR="./.planning/knowledge-base"

emit() { printf '%s\n' "$1"; }

emit "# product-planning 플러그인 컨텍스트"
emit ""
emit "PM/PD 기획 워크플로우 자동화 플러그인이 활성화되어 있습니다."
emit "산출물은 **현재 작업 디렉토리(워크스페이스)** 의 \`engagements/<ticket-slug>/\` 아래에 생성합니다."
emit "템플릿은 \`\${CLAUDE_PLUGIN_ROOT}/templates/\` 에서 읽습니다. 플러그인 디렉토리 자체에는 산출물을 만들지 마세요."
emit ""

if [ -f "$SOURCES" ]; then
  emit "## 워크스페이스 감지됨"
  emit "소스 레지스트리: \`$SOURCES\` (리서치 스킬이 여기 등록된 레거시/기술 자료를 순회합니다)"
  if command -v jq >/dev/null 2>&1; then
    emit ""
    emit "등록된 소스 키:"
    jq -r 'to_entries[] | select(.key|startswith("_")|not) | "- " + .key + ": " + ((.value | keys | map(select(startswith("_")|not)) | join(", ")) // "")' "$SOURCES" 2>/dev/null || true
  fi
  if [ -d "$KB_DIR" ]; then
    emit ""
    emit "지식베이스 감지됨: \`$KB_DIR\` — 레거시 정책/도메인이 누적되어 있습니다(grep/Read로 조회, domain-study가 갱신)."
  fi
else
  emit "## 워크스페이스 미감지"
  emit "현재 디렉토리에 \`.planning/sources.json\` 이 없습니다."
  emit "- 기획 워크스페이스 레포에서 작업하고 있는지 확인하세요(\`cd <workspace>\`)."
  emit "- 처음이라면 \`\${CLAUDE_PLUGIN_ROOT}/config/sources.example.json\` 을 복사해 \`.planning/sources.json\` 으로 채우세요."
fi

emit ""
emit "## 핵심 규칙"
emit "- 사람 결정 항목은 자동으로 채우지 말고 \`⛳DECISION\` 으로 표시하고 옵션·추천만 제시합니다."
emit "- 모든 사실은 출처(노션/Figma/로컬/웹)를 인용합니다."
emit "- 새 기획 시작은 \`/new-planning <노션-티켓-URL>\`."
exit 0
