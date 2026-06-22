# product-planning

PM/PD 기획 워크플로우 자동화 플러그인. **산출물은 현재 작업 디렉토리(워크스페이스)** 에 생성되고, 템플릿/설정은 `${CLAUDE_PLUGIN_ROOT}` 에서 읽습니다.

## 워크플로우 (도구 ↔ 작업 매핑)

각 도구가 어떤 워크플로우 작업을 맡는지와 **인입 후 레거시/신규 분기**입니다. 사각 노드는 `커맨드 · 단계 (사용 스킬)`, 점선 박스(7~13단계)는 도구 미구현 *추후 업데이트 예정*.

```mermaid
flowchart TD
    Start([노션 티켓 인입]) --> Intake["/intake · 1~2단계<br/>티켓 인입·히스토리·요건 파악<br/>(planning-intake → notion-explore)"]
    Intake --> Type{"레거시 / 신규?<br/>HITL 유형 판정"}

    Type -->|레거시 개선| Domain["/domain-study · 3단계<br/>레거시 정책·도메인 스터디 종합<br/>(domain-study → notion·figma·local·web-explore → knowledge-base)"]
    Type -->|신규 기능·화면| Ref["/reference-research · 3-alt단계<br/>동일 도메인 레퍼런스 리서치 · UX 패턴만<br/>(reference-research → web·image·figma-explore → knowledge-base)"]
    Type -->|혼합| Both["둘 다 수행"]

    Domain --> Tech
    Ref --> Tech
    Both --> Tech

    Tech["/tech-research · 4단계<br/>요구사항·기술문서·API 명세 정리<br/>(tech-research → web-explore+Context7 · notion · local → tech-registry)"]
    Tech --> PRD["/prd · 5단계<br/>빅테크 PM PRD(원페이저+상세)<br/>(prd-author → decision-checklist · prd-sdd-editing)"]

    PRD --> Gate{"SDD 필요?<br/>HITL 판단 게이트"}
    Gate -->|예 · 큰 프로젝트| SDD["/sdd · 5단계<br/>구현 스펙 SDD(FR→SP 매핑)<br/>(sdd-author → Context7 재검증 · prd-sdd-editing)"]
    Gate -->|아니오 · 단순 건| Meeting
    SDD --> Meeting

    Meeting["/meeting-synthesis · 6단계<br/>회의록(Google Doc)/Slack → PRD·SDD 반영<br/>(meeting-synthesis → gdrive·slack-explore · decision-checklist)"]

    Meeting -.-> Future
    subgraph Future ["7~13단계 · 추후 업데이트 예정 ⬜ (도구 미구현)"]
        direction TB
        S7["7 상위 결정"]
        S8["8 스토리보드 템플릿"]
        S9["9 PRD→스토리보드"]
        S10["10 레거시/레퍼런스 학습"]
        S11["11 low/mid-fi 디자인"]
        S12["12 상세 디스크립션"]
        S13["13 high-fi 고도화"]
        S7 --> S8 --> S9 --> S10 --> S11 --> S12 --> S13
    end
```

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
