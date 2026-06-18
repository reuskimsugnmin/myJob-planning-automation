---
name: figma-design
description: Figma에 화면을 "쓰는"(생성·수정·조립) 방법론의 단일 소스. SB_Templates+SECTION+Description 3세트 구조, 유사화면 clone vs 디자인시스템 라이브러리 조립, ++Top 표준 골격, 컴포넌트 swap 결함(resetOverrides·HUG)·폰트 로딩·심볼 INSTANCE 처리·배치 한도를 규정한다. storyboard-build·design-description 가 공통으로 따른다.
---

# Figma Design (Figma 쓰기 방법론)

Figma "쓰기"의 단일 소스. 화면을 **설계로 실현**하고 안전하게 수정하는 규칙을 모은다.
이 방법론은 **메인 컨텍스트(이 스킬을 호출한 storyboard-build / design-description)** 가 소유한다 — 디자인 쓰기는 단일 파일 변형 + HITL이 많아 sub-agent로 격리하지 않는다(같은 파일에 복수 에이전트 동시 디스패치 금지).

> **`use_figma` 호출 전 필수:** Figma MCP의 `/figma-use` 스킬(없으면 `skill://figma/figma-use/SKILL.md`)을 먼저 로드해 따른다. 라이브러리 발견·import·조립은 `figma-generate-design`·`figma-generate-library` 스킬을 함께 로드한다. `use_figma` 실행 시 반드시 `return` 으로 결과를 반환한다.

## 대원칙 — 1:1 교체가 아니라 "UX 맥락 설계"
- 화면은 **layout 구조(IA)부터 설계**하고, region마다 **가장 높은 수준의 기성 composite/section 컴포넌트**를 끼워 만든다. 남의 템플릿을 clone해 atom(아이콘·입력)만 바꾸면 구조가 남의 것이라 설계가 아니다(가장 잦은 실패).
- 기성 컴포넌트는 **재료**다. "이 화면에서 사용자가 가장 먼저 확인·판단·실행하는 값"을 먼저 정의해 정보 위계를 설계하고, 그 설계를 컴포넌트로 짓는다. 컴포넌트 모양에 화면을 가두지 말 것.
- 반복 그리드/리스트는 [N개 bespoke 그룹]이 아니라 **그리드/리스트 composite 컴포넌트 1개**.

## A. 화면 3세트 구조 (불변)
모든 화면은 **SB_Templates + SECTION + Description 프레임** 3세트로 구성한다.

| 노드 | 역할 |
| --- | --- |
| `SB_Templates` | 화면 헤더(`[화면 ID]` `화면 / 기능명` 텍스트, `Update` 뱃지 프레임) |
| `SECTION` | 실제 디자인 화면 |
| `Descriptions`(또는 `description`/`annotation`) | 기획 디스크립션 프레임 |

- **화면 ID**: `P-NN`(예 P-01). `SB_Templates` 내 `[화면 ID]` 텍스트에 기록, 기존 최대+1 순차 부여.
- **Update 뱃지**: 디스크립션 완료 후 `visible=false`, 검토 필요 화면은 `true` 유지.
- 화면 추가·교체 후 **뱃지(label-group/text-area)는 항상 최상위 z-order** 로(`parent.appendChild(badge)`) — 새 프레임 아래로 가려지지 않게.
- 신규/수정 화면은 항상 이 3세트 구조로 맞춘다.

## B. 화면 설계 4단계 (이 순서로)
2단계(골격 세팅)와 3단계(세부 UX)를 **분리**하는 게 핵심 — 2에서 멈추면 1:1 교체가 되어 설계가 빠진다.

1. **벤치마킹** — 동종 서비스 같은 유형 화면을 Figma `lazyweb`·웹 검색으로 조사해 검증된 UX 패턴·정보 위계·핵심값 파악. "이 화면에서 사용자가 가장 먼저 확인/결정하는 값"을 정의.
2. **기본 레이아웃 골격** — 연결 라이브러리/예시 화면의 컴포넌트로 표준 골격을 먼저 세운다(아래 ++Top 패턴). "재료 모으고 뼈대 세우기"까지.
3. **세부 UX 구성** — 골격 위에 1에서 정한 정보 위계대로 핵심값 강조·상태별 변형·액션 그룹화·여백·플로팅 CTA 설계. 기성 컴포넌트가 맥락에 안 맞으면 베리에이션/재구성.
4. **디스크립션** — 완성 디자인을 보고 뱃지·디스크립션 작성·동기화 → `design-description` 스킬.

## C. 표준 화면 골격 (++Top 패턴 — 화면 유형 보고 자동 적용)
- **`++Top`(모든 화면 필수, 래핑 프레임):** `UI/Status Bar` + TopAppBar(`header/main` 등) + (제목 필요 시) `UI/타이틀` 컴포넌트. 3종을 평면으로 흩지 말고 세로 auto-layout `++Top` 프레임 1개로 묶는다. 제목은 **raw TEXT 금지** — 공통 타이틀 컴포넌트 인스턴스를 clone/import 해 텍스트만 오버라이드.
- **`Body`(스크롤):** 정보 배너·검색·탭+콘텐츠(그리드/리스트)·진입 배너·안내 섹션 …(PRD 순서). 각 요소는 실제 컴포넌트.
- **`Bottom`(필요 시 고정):** 1차 액션 화면이면 `CTA` 인스턴스 하단 고정, 목록·홈 유형이면 `Navigation Bar`.
- 인식 규칙: ⓐ 모든 화면 = `++Top` ⓑ 제목 화면 = `UI/타이틀` 추가 ⓒ "선택→다음/구매/확인" 1차 액션 화면 = 하단 `CTA`.

## D. 조립 — clone vs 라이브러리 (채택 우선순위)
1. **기성 composite/section 컴포넌트** 그대로(`importComponentByKeyAsync`→`createInstance`). ← 최우선. 연결 라이브러리는 `search_design_system`(includeLibraryKeys로 한정)·`get_libraries` 로 수집, 페이지 로컬은 `findAllWithCriteria({types:['COMPONENT','COMPONENT_SET']})`.
2. 없으면 **atom**(행·텍스트·아이콘·칩)으로 Auto Layout 조립.
3. **bespoke 도형/그룹은 최후** — 콘텐츠 자산(아이콘·이미지)에만. UI 골격을 bespoke로 만들지 않는다.
- **유사화면 clone**: 가장 유사한 기존 화면의 SB_Templates+SECTION+Description **3개를 함께** clone(하나라도 빠지면 구조 불일치). clone 소스가 없으면(빈 캔버스) 라이브러리 컴포넌트 조립으로 첫 화면을 만든 뒤, 이후 화면의 clone 소스로 재사용.
- 콘텐츠(텍스트·이미지·값)는 **인스턴스 오버라이드/스왑**으로 채운다(구조는 컴포넌트, 값만 주입).
- 신규 화면 Y 좌표 = 마지막 화면 Y + 화면 높이 + 200(gap).

## E. 텍스트·폰트
- 폰트 로드 순서: **기존 폰트 → Pretendard Regular → Inter Regular → Noto Sans KR**. `loadFontAsync` 없이 텍스트 수정 금지.
- mixed 폰트는 `getRangeFontName` 루프로 전수 로드 후 수정.

## F. 컴포넌트 swap 결함 2종 (반드시 점검)
1. **swap 후 색·모양 이상** = 이전 컴포넌트의 per-vector fill 오버라이드 잔재(어두운 variant→밝은 variant 인데 일부 벡터가 어두운 색). → `inst.resetOverrides()` 후 `get_screenshot` 확인.
2. **auto-layout 리스트에 항목 추가 시 FIXED 높이 수동 확장 금지** = 콘텐츠 auto-grow + 높이 추가 → 팬텀 여백(`primaryAxisAlignItems=MAX` 면 상단 빈공간). → 컨테이너 `primaryAxisSizingMode='AUTO'`(HUG).
- 같은 계층 구조의 컴포넌트만 `swapComponent` 가능. 구조가 다르면 수동 교체 후 "수동 확인 필요" 명시.
- **교체 시 옛 요소는 완전 삭제.** 새 인스턴스를 옛 그룹 위에 얹지 말 것(잔여 stroke/fill/radius/padding → 이중 테두리·겹침).

## G. 심볼(INSTANCE) 내부 수정이 안 먹힐 때
아이콘·텍스트·색상 수정이 반영 안 되면 대상이 컴포넌트 인스턴스 내부다.
- **판별**: 노드 id에 `I`·`;`(예 `I32:3259;8:5128`) 또는 `type==='INSTANCE'`.
- 같은 컴포넌트 인스턴스가 여러 개(반복 행·카드)면 **전부 순회**. **같은 의미 요소가 화면마다 다른 컴포넌트로 렌더될 수 있으니("컴포넌트"가 아니라 "요소" 기준 전 화면 점검) — 목록의 INSTANCE_SWAP 아이콘 vs 상세의 독립 썸네일).**
- ① INSTANCE_SWAP/오버라이드 있으면 `inst.setProperties(...)` → ②-a 직접 인스턴스는 `inst.swapComponent(...)` → ②-b 잠금으로 불가하면 `detachInstance()` 후 직접 교체. 수정 후 `get_screenshot` 으로 전 인스턴스 시각 검증(메타데이터 카운트만 믿지 않는다).

## H. zero-bespoke 마감 (출시 품질)
구조가 선 화면을 출시 품질로 마감하는 별도 패스. **"큰 요소만 DS"가 아니라 "전 요소 DS"가 기준.**
- 안내/상태 문구 → 정보 배너 컴포넌트(평문 금지). 보조 필터·세그먼트 → 세그먼트/탭/Choice Chips. 선택 표시 → Radio/Checkbox 컴포넌트(직접 그린 원 금지). 강조 라벨 → Badge/Label.
- 화면 크롬: 상단 Status Bar·Header, 하단 Navigation Bar/Home Indicator 를 DS 인스턴스로.
- 검증: 모든 **비-콘텐츠 UI 노드**가 `type==='INSTANCE'`(+`getMainComponentAsync().remote`)인가. 남은 `RECTANGLE/ELLIPSE/FRAME` bespoke UI 는 DS 컴포넌트로 교체.
- **★ DS에 없으면 그리지 말고 플래그.** 필요한 아이콘·컴포넌트가 연결 라이브러리에 없으면(예: 비-telecom DS의 wifi/5G 글리프) 직접 도형으로 그리지 말고 사용자에게 "DS에 없다, 어떤 소스를 쓸까" 확인한다.

## I. 배치 처리
- **5개씩** 배치 처리(API 효율). **15개 초과** 화면은 사용자에게 범위 선택 요청.
- 페이지 작업 전 `setCurrentPageAsync(page)` 호출.

## 원칙
- 출처 없는 단정 금지. 전략적 UX 배치는 `⛳DECISION` 으로 표시하고 옵션·추천만 제시(사람 결정).
- 모든 산출물(백업·로그)은 **CWD 워크스페이스** `engagements/<slug>/design/` 에. 플러그인 디렉토리에 쓰지 않는다.
- 디자인을 바꾸면 해당 디스크립션도 그에 맞춰 동기화한다(따로 놀지 않게) → `design-description`.
