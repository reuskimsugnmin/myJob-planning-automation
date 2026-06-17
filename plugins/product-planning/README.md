# product-planning

PM/PD 기획 워크플로우 자동화 플러그인. **산출물은 현재 작업 디렉토리(워크스페이스)** 에 생성되고, 템플릿/설정은 `${CLAUDE_PLUGIN_ROOT}` 에서 읽습니다.

## 커맨드
| 커맨드 | 단계 | 설명 |
|---|---|---|
| `/new-planning <티켓-URL>` | 1~5 | 인입→(유형 분기)리서치→PRD/(조건부)SDD 전체 파이프라인 |
| `/intake <티켓-URL>` | 1~2 | 티켓 인입·파싱 + 레거시/신규 유형 판정 |
| `/domain-study` | 3 | (레거시) 레거시 정책·도메인 종합 |
| `/reference-research` | 3-alt | (신규) 동일 도메인 레퍼런스 분석 — UI 학습 금지·UX 패턴만 |
| `/tech-research` | 4 | 요구사항·기술 문서·API 명세 정리 |
| `/prd` | 5 | 빅테크 PM 방법론 PRD(원페이저+상세+의사결정 체크리스트) |
| `/sdd` | 5 | (게이트 통과 시) SDD 작성 |
| `/meeting-synthesis` | 6 | 회의록(Google Doc)/Slack 스레드 → PRD/SDD 반영 |

## 스킬
- **워크플로우(오케스트레이션)**: `planning-intake` · `domain-study` · `reference-research` · `tech-research` · `prd-author` · `sdd-author` · `meeting-synthesis`
- **소스별 읽기(7종)**: `notion-explore` · `figma-explore` · `local-source-ingest` · `web-explore` · `image-explore` · `slack-explore` · `gdrive-explore`
- **공용**: `knowledge-base`(파일 KB 쓰기) · `decision-checklist`(기획 공백→추천안→최종결정) · `prd-sdd-editing`(편집 불변식)

(커맨드 없이도 대화 중 관련 작업이면 자동 트리거됩니다.)

## 서브에이전트
`research-agent` — 노션/Figma/로컬/웹 자료 격리·병렬 수집(출처 인용, 방법은 읽기 스킬 참조).

## 설정
- 소스 레지스트리: 워크스페이스 `.planning/sources.json` (스키마: [config/sources.example.json](config/sources.example.json))
- SessionStart 훅이 워크스페이스를 감지해 소스/컨벤션을 컨텍스트로 주입하고, **필요한 MCP 커넥터(Notion 필수·Context7 권장·Figma/Slack/Google Drive)와 감지 여부·설치 방법**을 안내합니다.
- MCP는 번들하지 않습니다 — 이미 설치/인증한 커넥터를 그대로 재사용(중복 설치 없음). 미설치 시 `/mcp` 또는 `claude mcp add` 로 추가하세요.

## 산출물 구조 (워크스페이스)
```
engagements/<YYYY-MM>-<slug>/
  00-project-brief.md
  research/{domain-study|reference-research,tech-research}.md  research/meetings/<date>.md
  PRD.md  SDD.md
.planning/knowledge-base/   # 팀 공용 파일 KB: policy-registry·entity-glossary·tech-registry·source-manifest (raw/는 gitignore)
```
