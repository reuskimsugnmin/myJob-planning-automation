# product-planning

PM/PD 기획 워크플로우 자동화 플러그인. **산출물은 현재 작업 디렉토리(워크스페이스)** 에 생성되고, 템플릿/설정은 `${CLAUDE_PLUGIN_ROOT}` 에서 읽습니다.

## 커맨드
| 커맨드 | 단계 | 설명 |
|---|---|---|
| `/new-planning <티켓-URL>` | 1~5 | 인입→리서치→PRD/SDD 전체 파이프라인 |
| `/intake <티켓-URL>` | 1~2 | 티켓 인입·파싱 |
| `/domain-study` | 3 | 레거시 정책·도메인 종합 |
| `/tech-research` | 4 | 요구사항·기술 문서 정리 |
| `/prd` | 5 | PRD 작성 |
| `/sdd` | 5 | SDD 작성 |

## 스킬
`planning-intake` · `domain-study` · `tech-research` · `prd-author` · `sdd-author`
(커맨드 없이도 대화 중 관련 작업이면 자동 트리거됩니다.)

## 서브에이전트
`research-agent` — 노션/Figma/로컬/웹 자료 병렬 수집(출처 인용).

## 설정
- 소스 레지스트리: 워크스페이스 `.planning/sources.json` (스키마: [config/sources.example.json](config/sources.example.json))
- SessionStart 훅이 워크스페이스를 감지해 소스/컨벤션을 컨텍스트로 주입.

## 산출물 구조 (워크스페이스)
```
engagements/<YYYY-MM>-<slug>/
  00-project-brief.md  research/{domain-study,tech-research}.md  PRD.md  SDD.md
```
