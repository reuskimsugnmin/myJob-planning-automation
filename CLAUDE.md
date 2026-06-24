# CLAUDE.md

> 이 파일은 새 세션의 Claude가 이 레포의 맥락을 빠르게 잡기 위한 안내서다. 먼저 읽고 판단하라.

## 1. 이 레포는 무엇인가

PM/PD(제품 기획자/디자이너)의 **13단계 제품 기획 워크플로우를 자동화하는 Claude Code 플러그인**이다.
이 레포는 **도구(플러그인) 전용**이다. 실제 기획 산출물(PRD/SDD 등)은 **여기에 만들지 않는다** — 별도의 워크스페이스 레포에 만든다(§4).

- 목표: 반복 노동은 Claude가 주도하고, 전략적 결정만 사람이 내리는 구조를 만들어 GitHub 마켓플레이스로 팀과 공유·공동 개선한다.

## 2. 현업 기획 워크플로우 (원본 13단계 · 자동화 대상)

새 기획 업무가 들어올 때마다 반복되는 사용자의 실제 워크플로우. 각 단계가 어디서 정보를 얻는지(소스/도구)까지 포함한다. 이것이 우리가 자동화하려는 대상의 원본이다.

1. 리더가 제품 개발 기획 업무를 배정 → **노션 티켓**으로 전달.
2. 티켓 내 **이전 히스토리와 간략한 개발 요건** 파악 → 노션 티켓 내용. (이때 **레거시 개선 vs 신규 기능 유형을 판정** — 자율 판정 1원칙, 애매하면 사용자 확인 — 하여 3단계 경로를 확정)
3. 관련 **레거시 제품 서비스 정책·도메인 스터디** → 노션·Figma·로컬파일 등 **scatter된 자료** 학습. **(신규 기능이면 도메인 스터디 대신 동일 도메인 레퍼런스 리서치 — UI는 학습 금지, UX 패턴만)**
4. 필요한 **요구사항과 기술 구현 Document** 파악 → 노션 또는 기술 문서(웹링크·로컬파일).
5. **PRD 및 필요 시 SDD** 작성.
6. 유관부서·개발조직과 **커뮤니케이션(미팅)** → 구글밋 Gemini **자동 회의록** 생성·관리.
7. **상위 결정사항**(제품 핵심밸류/차별성/타겟/기술정책/주요 서비스정책/UX 배치)을 사람이 결정하며 PRD·SDD에 반영·고도화.
8. Figma에 **스토리보드 초안 템플릿** 생성 → `storyboard-build`/`figma-design`이 3세트(SB_Templates+SECTION+Description) 골격을 **자동 생성**(모드 A in-place / 모드 B 백지 구축). 사내 초안 템플릿 파일이 있으면 시드로 사용.
9. 스토리보드에 **서비스정책/플로우차트** 등 PRD→Figma로 작업. (서비스정책=`storyboard-build` policy-table·플로우차트=FigJam `generate_diagram`(+`design/flow.md`)은 자동. **데이터엔티티 흐름/ERD 전용 작도는 자동화 범위에서 의도적 제외** — 워크플로우 스코프 아웃. 필요 시 동일 `generate_diagram` 경로로 ad-hoc 작도 가능)
10. 기존 사내 **Figma 레거시 화면 학습** (신규 기능/화면이면 레퍼런스 학습으로 대체).
11. 학습 내용 토대로 스토리보드에 **low-fi/mid-fi 디자인 아웃풋** 생성.
12. 기획 내용+디자인 토대로 **상세 기획 디스크립션**을 스토리보드 내 작성.
13. **high-fi 디자인 고도화** 및 확정된 UXUI에 맞게 디스크립션 고도화.

## 3. 자동화 경계 (단계별 누가 무엇을 하나)

🤖 = Claude 주도 · 🧑 = 사람 · 🤖+🧑 = Claude 보조 + 사람 결정/확정.

| 단계 | 담당 | Claude 자동화 / 사람 역할 |
| --- | --- | --- |
| 1 티켓 인입 | 🤖 | Notion MCP로 티켓 fetch·파싱 |
| 2 히스토리·요건 파악 | 🤖 (애매 시 🧑 확인) | 티켓 본문·연결 문서 요약·구조화. **프로젝트 유형(레거시/신규) 판정** → 애매하면 사용자 확인 → 3단계 경로 확정 |
| 3 도메인 스터디 **또는 레퍼런스 리서치** | 🤖 | 레거시→`domain-study`(레거시 정책·도메인 수집·종합) / 신규→`reference-research`(동일 도메인 레퍼런스 분석, **UI 학습 금지·UX 패턴만**) |
| 4 기술 리서치 | 🤖 | WebFetch/Context7/노션/로컬에서 요구사항·기술문서 정리 |
| 5 PRD·SDD 작성 | 🤖 (SDD 여부 🧑 확인) | 빅테크 PM 방법론. **PRD 기본**(원페이저+상세: 유저스토리·기능명세·수용기준), **SDD는 판단 게이트로 조건부**(큰 프로젝트). 미결은 `decision-checklist`(추천안·임시채택·최종결정) |
| 6 회의록 종합 | 🤖+🧑 | 미팅 참석은 사람. `meeting-synthesis`: Gemini 회의록(Google Doc) 또는 Slack 스레드→결정·액션 추출→PRD/SDD 반영·체크리스트 확정. **모호하면 자의 해석 금지·사용자 확인** |
| 7 상위 결정 | 🧑 (Claude 보조) | 사람이 결정. Claude는 옵션·트레이드오프·추천 *브리프*만 생성·반영 |
| 8 스토리보드 템플릿 | 🤖 | `storyboard-build`/`figma-design`이 3세트(SB_Templates+SECTION+Description) 골격을 자동 생성(모드 A in-place / B 백지 구축). 사내 템플릿 파일은 시드로 |
| 9 PRD→스토리보드 | 🤖 | 서비스정책(`storyboard-build` policy-table)·플로우차트(FigJam `generate_diagram`+`design/flow.md`)는 자동. 데이터엔티티 흐름/ERD 전용 작도는 자동화 범위 외(의도적 제외) |
| 10 레거시/레퍼런스 학습 | 🤖 | Figma get_design_context/screenshot로 화면·플로우 학습 |
| 11 low/mid-fi 디자인 | 🤖 (적극) | low/mid-fi 화면 자동 생성. high-fi는 사람 |
| 12 상세 디스크립션 | 🤖 | 스토리보드 내 기획 디스크립션 작성 |
| 13 high-fi 고도화 | 🧑 (Claude 보조) | 디자인 취향·확정은 사람. 디스크립션 고도화만 Claude 보조 |

**사람 전용**: 실제 미팅 참석, 7의 최종 전략 결정, 13의 디자인 취향·확정.
**`⛳DECISION` 원칙**: 핵심밸류·차별성·타겟·기술/서비스 정책·UX 배치 등 전략 항목은 Claude가 단정하지 말고 마커로 표시하고 **옵션·트레이드오프·추천만** 제시한다.

## 4. 핵심 아키텍처: 도구 ↔ 산출물 2-레포 분리 (가장 중요)

- **이 레포 (도구)**: `myJob-planning-automation/`. 플러그인 본체는 `plugins/product-planning/`. 마켓플레이스 배포.
- **워크스페이스 레포 (산출물)**: `../myjob-planning-workspace/`. 팀 공유. 기획 1건 = `engagements/<YYYY-MM>-<slug>/` 폴더 하나.

규칙:

- 스킬/커맨드는 산출물을 **항상 현재 작업 디렉토리(CWD = 워크스페이스)** 에 쓴다. 이 플러그인 레포 안에 산출물을 만들지 마라.
- 템플릿·설정은 **`${CLAUDE_PLUGIN_ROOT}`** (= `plugins/product-planning/`)에서 읽는다.
- 소스 레지스트리: 스키마는 플러그인 `config/sources.example.json`, **실제 값은 워크스페이스** `.planning/sources.json`.
- 워크스페이스 `.planning/sources.json`의 `local.doc_dirs`에 `./engagements`가 있어, 과거 산출물이 새 기획의 추가 레거시 소스로 재학습된다.
- 개발/테스트용 산출물만 이 레포의 `sandbox/`(gitignore)에 둔다.

## 5. 레포 구조

```text
.claude-plugin/marketplace.json          # 마켓플레이스 매니페스트
plugins/product-planning/
  .claude-plugin/plugin.json             # 플러그인 매니페스트
  commands/    new-planning, intake, domain-study, reference-research, tech-research, prd, sdd, meeting-synthesis,
               storyboard, design-desc, design-sync (.md)
  skills/      # 방법론 단일 소스
    planning-intake, domain-study, reference-research, tech-research, prd-author, sdd-author, meeting-synthesis
    notion-explore, figma-explore, local-source-ingest, web-explore, image-explore, slack-explore, gdrive-explore  # 소스별 "읽기" 방법론(7소스)
    figma-design, storyboard-build, design-description, design-finalize    # 디자인 단계(8~13) "쓰기" 방법론(design-finalize=마감 시퀀스 공용 단일 소스)
    knowledge-base                                        # source-agnostic "쓰기"(파일 KB)
    decision-checklist                                    # 기획 공백→추천안→임시채택→최종결정 (PRD/SDD 공용)
    prd-sdd-editing                                       # PRD/SDD 편집 불변식(ID 안정성·유실 방지·출처/changelog) 단일 소스
  agents/      research-agent.md          # 격리 수집·digest만(방법은 위 읽기 스킬 참조)
  hooks/       hooks.json + session-start.sh   # 워크스페이스/KB 감지→소스·컨벤션 주입 + 필요 MCP 점검(감지/설치 안내)
               log-figma.sh, log-write.sh, session-stop.sh  # 디자인 단계 관측 로그(워크스페이스 ./.planning/logs)
  templates/   PRD, SDD, domain-study, reference-research, tech-research, project-brief, meeting-log (.template.md)
               knowledge-base/{policy-registry,entity-glossary,tech-registry,source-manifest}.template + design-system-catalog.md(HPDS 부품 카탈로그 시드)
               design/{policy-table,design-description,design-log}.template.md  # 디자인 단계 산출물
  config/      sources.example.json       # 소스 레지스트리 스키마(실제 값 아님)
sandbox/                                  # 개발 테스트용 (gitignore)
```

## 6. 런타임 워크플로우 — 사용자가 기획을 시작하면

워크스페이스 레포에서 `cd` 후 실행:

- `/new-planning <노션-티켓-URL>` — 1~5단계 전체 파이프라인(인입→리서치 병렬→PRD→SDD)
- 단계별 순서(각 커맨드는 완료 시 다음 단계를 제안):
  - 레거시: `/intake` → `/domain-study` → `/tech-research` → `/prd` → (게이트 통과 시) `/sdd` → `/meeting-synthesis`
  - 신규: `/intake` → `/reference-research` → `/tech-research` → `/prd` → (게이트 통과 시) `/sdd` → `/meeting-synthesis`
  - 혼합: 3단계에서 `/domain-study` + `/reference-research` 둘 다 수행 후 `/tech-research`로.
  - **불변식**: 3단계 리서치(domain/reference)만 끝내고 `/prd`로 직행하지 않는다. `/prd` 진입 시 `research/tech-research.md` 부재면 게이트가 멈추고 사용자에게 확인(단순 건은 명시적 생략 허용).
- 디자인 단계(8~13, PRD 확정 후 **명시적 별도 호출**): `/storyboard`(8~11 화면 실현) → `/design-desc`(12 디스크립션+동기화) → `/design-sync`(동기화 검증). high-fi 고도화·디자인 취향은 사람.

산출물: `engagements/<slug>/` 아래 `00-project-brief.md`, `research/{domain-study,tech-research}.md`, `PRD.md`, `SDD.md`, `design/{policy-table.md, descriptions, backups, logs}`. 레거시 지식베이스는 워크스페이스 공용 `.planning/knowledge-base/`(policy-registry/entity-glossary/source-manifest, `raw/`는 gitignore). 디자인 단계 관측 로그는 `.planning/logs/`(gitignore).

## 7. 절대 규칙 (이 레포에서 작업할 때)

1. **도구/산출물 분리**: 산출물은 CWD(워크스페이스)에, 템플릿/설정은 `${CLAUDE_PLUGIN_ROOT}`에서. 플러그인 레포에 기획 산출물 커밋 금지.
2. **사람 결정 존중**: 전략 항목은 `⛳DECISION`으로 표시만. 대신 결정하지 마라.
3. **출처 인용**: 모든 사실(정책·요건·기술)에 출처(노션 URL/Figma 노드/파일 경로) 인용. 지어내지 마라.
4. **최신 문서 검증**: 라이브러리/SDK는 기억이 아니라 Context7/공식 문서로 확인.
5. **팀 공용 포맷**: 산출물 포맷 변경은 개별 산출물이 아니라 `templates/` 수정으로.

## 8. Skill ↔ Sub-agent 설계 원칙 (도구를 만들 때)

Skill과 Sub-agent는 경쟁이 아니라 **축이 다르다**. "둘 다 만들기"는 중복이 아니지만, **같은 방법론을 양쪽에 복붙하면 그건 중복**이다.

- **역할 구분**: Skill = 방법론("어떻게", 메인 컨텍스트 안에서 실행, 사용자와 반복 협업·상태 공유). Sub-agent = 실행 컨텍스트("누가/어디서", 분리된 컨텍스트, 격리·병렬·도구 제한, 요약만 반환).
- **레이어링**: `Command(진입점) → Skill(방법론) → 필요 시 Sub-agent 디스패치 → Sub-agent는 다시 그 Skill을 호출해 "how"를 따름`.
- **단일 진실 소스(중복 방지)**: 방법론은 **Skill에만 1벌**. `agent.md`는 ① 역할 ② 허용 도구 ③ **출력 계약(반환 형식)** 만 두고 "구체적 방법은 `<skill>` 스킬 사용"으로 **참조**시킨다. 절차를 복붙하지 마라 — 팀이 한 곳(skill)만 고치면 메인·sub-agent 양쪽이 함께 개선된다.
- **Sub-agent를 추가할지 판단**:
  - 대량 읽기·중간 산출물로 **메인 컨텍스트가 오염**되나? → 추가(격리)
  - **독립 작업 2개 이상을 동시에** 돌리나? → 추가(병렬)
  - **사용자 실시간 결정·반복 리뷰**가 필요하나? → **Skill만** (맥락 단절 방지)
  - 가벼운 노하우인가? → **Skill만**
- **역할별 적용 지침**:
  - **리서치**(domain/tech): Skill + Sub-agent **둘 다**. 분담 — skill=오케스트레이션·종합·파일작성·출처정책, agent=원자료 수집 후 digest 반환. 소스별 "읽기" 방법론은 7소스 스킬(`notion-explore`/`figma-explore`/`local-source-ingest`/`web-explore`/`image-explore`/`slack-explore`/`gdrive-explore`)에 단일 소스로, KB "쓰기" 스키마(policy-registry/entity-glossary/tech-registry/source-manifest)는 source-agnostic `knowledge-base` 스킬에. domain-study/reference-research/tech-research/intake/meeting-synthesis/research-agent는 이들을 **참조**만 한다.
  - **기술 자료 staleness**: 서드파티 라이브러리/SDK 문서는 KB에 진실로 캐시하지 않는다(§7.4). manifest에 버전+`as_of`만 남기고 사용 시점(특히 SDD 확정 전) Context7 재검증. 내부/파트너 API·연동 스펙만 `tech-registry`에 적재.
  - **HITL 게이트**: 사용자 실시간 확인이 필요한 결정(Figma 페이지 선정·완료 체크포인트, 노션 트리 예산 초과 확인)은 **메인 컨텍스트(Skill)** 가 소유. sub-agent는 게이트를 수행하지 않고 호출자에 위임.
  - **기획자**(PRD/SDD): **Skill만**(sub-agent 비채택 — 입력이 정제된 산출물이라 격리 이득 작고, 의사결정·리뷰가 메인 컨텍스트에서 일어나야 함. PRD/SDD 편집 "전담 sub-agent"도 같은 이유로 비채택: HITL 단절·cold start 상태 유실·격리 이득 작음 → 대신 **공유 스킬**로 일관성 확보). `prd-author`=빅테크 PM 역할·원페이저+상세·PRD↔SDD 판단 게이트, `sdd-author`=게이트 통과 시 상세 스펙. 기획 공백 처리는 `decision-checklist`, **기존 문서 편집 불변식(ID 안정성·유실 방지·출처/changelog·구조 보존)은 `prd-sdd-editing` 스킬 단일 소스**로 prd-author/sdd-author/meeting-synthesis/decision-checklist가 참조. 작성 중 새 원자료가 필요하면 그때만 `research-agent` 재사용.
  - **회의록 종합**(meeting-synthesis): **Skill만**. 회의록을 읽어 PRD/SDD를 편집하고, 모호하면 사용자 확인이 필요(HITL)·결정 반영이 메인 컨텍스트에서 일어나야 함. 읽기는 `gdrive-explore`/`slack-explore` 참조.
  - **디자인**(단계 8~13): **쓰기는 Skill만**(v0.7 결정). Figma 디자인 *쓰기* 는 단일 파일 변형 + 모드선택·비주얼게이트·완료체크 HITL이 많아 메인 컨텍스트(Skill)가 소유해야 하고 단일 파일에 복수 에이전트 동시 디스패치가 금지되므로(PRD/SDD와 동일 논리) sub-agent를 두지 않는다. `figma-design`(쓰기 원시·3세트 구조·골격·clone/조립·swap 결함·심볼·폰트, Figma MCP `/figma-use` 준수) / `storyboard-build`(8~11 오케스트레이션·모드 A·B·비주얼 게이트) / `design-description`(12 디스크립션+동기화·뱃지 매칭·claim↔노드 대조표) / `design-finalize`(마감 시퀀스 공용 단일 소스 — 리플로우→hug→겹침→7항목 검수→동기화, 방법은 owner 스킬 참조·복붙 아님). 상세 기계 절차·점검 스크립트·HPDS 부품 식별자는 각 스킬 `references/`·`scripts/`·KB `design-system-catalog`로 분리(progressive disclosure, 이식성 방어). 레거시/레퍼런스 Figma *읽기*(대량)는 기존 `figma-explore`+`research-agent` 재사용.
- ✅ **정리 완료(v0.2)**: `research-agent.md`의 수집 절차 중복 제거 → 소스 읽기 스킬 참조로 전환. 노션 읽기 로직은 `notion-explore`로 통합(intake도 이를 참조). agent는 역할·도구·출력계약만 보유.

## 9. 개발 방법

- **스킬 추가**: `plugins/product-planning/skills/<name>/SKILL.md` (frontmatter `name`+`description` 필수).
- **커맨드 추가**: `plugins/product-planning/commands/<name>.md` (frontmatter `description`+`argument-hint`).
- **검증(E2E)**: 워크스페이스에서 실제(또는 과거) 티켓으로 `/new-planning` 실행 → 과거 사람 작성 PRD/SDD와 비교해 템플릿·프롬프트 보정.
- **버전**: `plugin.json`+`marketplace.json`의 `version` 동시 갱신(SemVer). 자세한 기여 규칙은 `CONTRIBUTING.md`.
- **커밋/푸시**: 사용자가 요청할 때만. 원격은 `origin` → `github.com/reuskimsugnmin/myJob-planning-automation` (main 추적).
- **main 브랜치 정책**: main에 **PR 필수 룰셋**이 걸려 있으나 **레포 소유자(사용자)는 bypass 허용** → 소유자는 main에 직접 push-merge, **팀 동료는 PR 리뷰를 거쳐야** 머지된다. 따라서 사용자가 커밋·푸시를 요청하면 main 직접 푸시가 정상 동작이다(bypass). 팀 동료 기여 흐름을 다룰 때만 브랜치→PR을 따른다.

## 10. 현황 · 로드맵

- ✅ **Phase 1 (MVP, v0.1)**: 워크플로우 1~5단계 — 스킬 5종, 커맨드 6종, research-agent, SessionStart 훅 구현·커밋 완료. (E2E는 실제 티켓+sources.json 채운 뒤 미수행)
- ✅ **Phase 1.5 (v0.2) — 3단계 도메인 스터디 고도화**: 소스별 읽기 스킬(`notion-explore`/`figma-explore`/`local-source-ingest`) + 파일 KB(`knowledge-base`) 추가, `domain-study` 오케스트레이션 재작성, intake/research-agent 경계정리, 산출물 템플릿·소스 스키마 확장. (E2E는 1→2→3 단계적 검증 예정)
- ✅ **Phase 1.6 (v0.3) — 4단계 기술 리서치 고도화**: `web-explore`(공개 웹·public notion.site·Context7) 추가로 읽기 스킬 4소스 대칭 완성, `tech-research` 오케스트레이션 재작성 + 템플릿 신설, KB `tech-registry`(내부/파트너 API·연동 스펙) + 라이브러리 staleness 정책, PRD/SDD가 KB 우선 조회·SDD Context7 재검증 게이트. (E2E 단계적 검증 예정)
- ✅ **Phase 1.7 (v0.4) — 3단계 신규 제품 분기(레퍼런스 리서치)**: intake 2단계에 **프로젝트 유형 판정 게이트**(자율 판정·애매 시 사용자 확인) 추가, 신규면 `reference-research`로 분기. `image-explore`(레퍼런스 이미지 비전) 추가로 읽기 스킬 5소스, `reference-research` 스킬+템플릿+커맨드 신설(**UI 학습 금지·UX 패턴만**), new-planning 분기. (E2E 단계적 검증 예정)
- ✅ **Phase 1.8 (v0.5) — 5단계 PRD/SDD 고도화**: 빅테크 PM 방법론 역할, PRD **원페이저 요약+상세 요구사항**(US/FR/수용기준/NFR) 재설계, **PRD↔SDD 판단 게이트**(조건부 SDD), `decision-checklist` 신규 스킬(기획 공백→추천안→임시채택→결정상태/최종결정 컬럼→본문 빠른 수정), AI 파싱+사람 완결 구조. (E2E 단계적 검증 예정)
- ✅ **Phase 2 (완료, v0.6)**: 회의록 종합(`meeting-synthesis` — Google Doc/Slack 읽기 `gdrive-explore`/`slack-explore` 추가, PRD/SDD 반영·체크리스트 확정·회의 로그, 모호 시 사용자 확인 게이트). **단계 7 의사결정 브리프는 전용 스킬(`decision-brief`)을 추가하지 않고 기존 도구로 수행** — 옵션·트레이드오프·추천 브리프는 `decision-checklist`(추천안·임시 채택을 PRD/SDD 하단 체크리스트로 생성), 최종 결정 반영은 `meeting-synthesis`(또는 사용자 직접 확정)가 담당. 상위 전략의 *최종 결정* 자체는 사람 몫(`⛳DECISION`).
- ✅ **Phase 3 (완료, v0.9.15) — 디자인 단계(8~13)**: 사용자의 운영 Figma toolset을 §8 아키텍처로 이식. 스킬 4종(`figma-design`/`storyboard-build`/`design-description`/`design-finalize`, 쓰기는 Skill-only), 커맨드 3종(`/storyboard`/`/design-desc`/`/design-sync`), 디자인 템플릿 3종 + KB `design-system-catalog`, 관측 훅 3종, `sources.json` `figma.design_system_files`·`storyboard_target` 추가. **하드닝(v0.9.9~v0.9.15)**: 마감 시퀀스 `design-finalize`로 수렴(3커맨드 중복 제거), 점검 스크립트·HPDS 부품 카탈로그 분리(타 환경 이식성 방어), figma-design/design-description progressive disclosure(`references/`), 디자인 의사결정 **영향 기준 하이브리드 라우팅**(decision-checklist 공용 스키마), 단계 8 자동화(템플릿 골격 자동 생성), 부품 카탈로그 확장(M-14~M-22). **단계 9는 서비스정책(policy-table)·플로우차트(`generate_diagram`+`design/flow.md`) 자동화로 완료** — 데이터엔티티 흐름/ERD 전용 작도는 자동화 범위에서 의도적 제외(워크플로우 스코프 아웃). **E2E는 전용 빌드 없이 기존 커맨드 실사용으로 검증**(과거 PRD+실제 Figma로 `/storyboard`→`/design-desc`→`/design-sync` 돌려 보정, 회의 반영은 `meeting-synthesis`). high-fi 고도화(단계 13)·디자인 취향은 설계상 사람 몫.
- ⬜ **Phase 4**: 팀 배포 + 반복 개선 루프.

## 11. 더 깊은 맥락

- 승인된 전체 계획: `~/.claude/plans/product-manager-product-jazzy-globe.md`
- 프로젝트 메모리: `project-overview` (세션 시작 시 자동 로드됨)
