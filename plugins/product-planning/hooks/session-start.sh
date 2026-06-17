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
emit "## 필요한 MCP 커넥터"
emit "이 플러그인의 단계별 자동화는 아래 MCP를 사용합니다. **이미 설치/인증돼 있으면 그대로 재사용**되며, 플러그인은 MCP를 중복 설치하지 않습니다."

# 로컬 설정 파일에서 MCP 등록 여부를 best-effort 로 감지한다.
# (claude.ai 계정 커넥터는 로컬 파일에 안 나타날 수 있으므로 ⬜ 여도 정상 동작 가능)
detect_mcp() {
  local pat="$1" f
  for f in "./.mcp.json" "$HOME/.claude.json" "./.claude/settings.json" "$HOME/.claude/settings.json"; do
    if [ -f "$f" ] && grep -qiE "$pat" "$f" 2>/dev/null; then
      return 0
    fi
  done
  return 1
}
mark() { if detect_mcp "$1"; then printf '✅'; else printf '⬜'; fi; }

emit ""
emit "| MCP | 감지 | 용도 · 사용 단계 | 필요도 |"
emit "| --- | :--: | --- | --- |"
emit "| **Notion** | $(mark 'notion') | 티켓 인입·노션 자료 읽기 (단계 1·2·3·4) | **필수** |"
emit "| **Context7** | $(mark 'context7') | 라이브러리/SDK 최신 문서 검증 (단계 4·SDD) | 권장 |"
emit "| **Figma** | $(mark 'figma') | 레거시 화면 학습·스토리보드·디자인 (단계 8~13) | 디자인 단계 |"
emit "| **Slack** | $(mark 'slack') | 회의 스레드·결정/액션 추출 (단계 6) | 선택 |"
emit "| **Google Drive** | $(mark 'gdrive|google.?drive|google_drive') | Gemini 회의록(Doc) 종합 (단계 6) | 선택 |"
emit ""
emit "- ✅ = 로컬 설정에서 감지됨 · ⬜ = 미감지(아래 방법으로 설치 필요)."
emit "- claude.ai 계정 커넥터로 이미 인증했다면 ⬜ 로 보여도 동작할 수 있습니다(로컬 설정 파일엔 안 나타남). \`/mcp\` 로 실제 연결 상태를 확인하세요."

emit ""
emit "### 설치/인증 방법"
emit "가장 간단한 방법은 Claude Code에서 \`/mcp\` 를 실행해 커넥터를 추가·인증하는 것입니다(OAuth 자동 처리)."
emit "CLI로 추가하려면:"
emit '```bash'
emit "# 노션 (원격) — 필수"
emit "claude mcp add --transport http notion https://mcp.notion.com/mcp"
emit "# Context7 (로컬) — 기술 문서 조회"
emit "claude mcp add context7 -- npx -y @upstash/context7-mcp"
emit "# Figma / Slack / Google Drive 는 '/mcp' 커넥터 추가 또는 각 제공사 공식 MCP 문서 참고"
emit '```'
emit "설치 후 \`/mcp\` 로 연결 상태를 확인하세요."

emit ""
emit "## 핵심 규칙"
emit "- 사람 결정 항목은 자동으로 채우지 말고 \`⛳DECISION\` 으로 표시하고 옵션·추천만 제시합니다."
emit "- 모든 사실은 출처(노션/Figma/로컬/웹)를 인용합니다."
emit "- 새 기획 시작은 \`/new-planning <노션-티켓-URL>\`."
exit 0
