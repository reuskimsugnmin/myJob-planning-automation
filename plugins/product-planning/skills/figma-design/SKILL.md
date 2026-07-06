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
| `Description` | 기획 디스크립션 프레임(SECTION 우측). 내부: `annotation-frame` × N, 각 프레임 = 텍스트 3개 — 노드명 **`"1"`(뱃지 번호)·`"Section Title.."`(제목)·`"Lorem ipsum..."`(본문)**. 신규 생성도 이 명명 준수 |

- **화면 ID·타이틀**: `SB_Templates` 내 `[화면 ID]`·`화면 / 기능명` 텍스트는 **SECTION 이름에서 파생**한다(섹션명 `e05 본인인증` → ID `[e05]` + 타이틀 `본인인증`; 접두=ID, 나머지=타이틀). 포맷은 페이지 컨벤션을 따른다(`P-NN`이든 `e01`이든 섹션명과 동일). **수동으로 박지 말 것 — 리플로우 루틴이 매 마감 자동 동기화**(아래 §리플로우 4단계)하므로 섹션명만 정확히 두면 라벨은 따라온다(stale `[P-04]` 드리프트 방지).
- **Update 뱃지**: 디스크립션 완료 후 `visible=false`, 검토 필요 화면은 `true` 유지.
- 화면 추가·교체 후 **뱃지(label-group/text-area)는 항상 최상위 z-order** 로(`parent.appendChild(badge)`) — 새 프레임 아래로 가려지지 않게.
- **뱃지 배치(운영 양식)**: 뱃지는 `label-group` 그룹으로 **SECTION 노드의 직속 자식**(디자인 프레임의 형제·최상위 z)으로 두어 디자인 프레임과 **겹치지 않게** 좌측 가장자리에 붙인다(요소 edge 옆). **좌표는 부모 기준 상대좌표**다 — SECTION 자식은 섹션 상대, auto-layout 프레임 내부에 둘 땐 `layoutPositioning="ABSOLUTE"` + 프레임 상대. **페이지 절대좌표를 주면 화면 밖/바닥으로 빠진다**(흔한 실수).
- 신규/수정 화면은 항상 이 3세트 구조로 맞춘다.
- **★ 3세트 골격의 정본 출처 = 게시된 정본 세트(§M-23).** 파일에 clone할 기존 행이 없으면(그린필드) `SB_Templates`·`SECTION`·`Description`·`annotation-frame`·`label-group`을 **`storyboard_template_file`의 게시 컴포넌트로 반입**한다(§D "빈 캔버스" 규칙). **규격 문서만 보고 골격을 새로 그리지 않는다.**
- **수직 행 리플로우 — 규칙이 아니라 "실행 패스"(겹침 금지).** `SB_Templates` 카드·SECTION·Description은 **부모 auto-layout 없이 절대좌표로 놓인 독립 형제** + `SB_Templates`는 **고정 높이 인스턴스**라 Description가 길어져도 자동으로 안 커지고 안 밀린다 → **반드시 리플로우 패스를 명시적으로 실행**한다(하드코딩 id 금지·페이지에서 행을 스스로 발견 → SB 카드 height 리사이즈 + SECTION 콘텐츠 포함 리사이즈 + 행 Y cascade + SB 라벨 섹션명 동기화).
  - **완료 게이트(필수).** 디자인/디스크립션을 **편집한 커맨드는 마감에서 이 루틴을 항상 실행**한다(`storyboard-build`/`design-description`/`/design-sync`). 사용자 요청 불필요·자동. *단* Figma 손편집은 `/design-sync`로 1회 트리거.
  - **상세 절차는 `references/reflow.md`를 읽어 따른다** — 자동발견 루틴(SB→SECTION/Description 매칭)·**행 3세트 원자 단위·SB INSTANCE 포함 read**(부분 행 조작 금지)·`realBottom` 계산(`node.height` 금지)·idempotency 검산(타 행 오이동 방지)·parent 페이지 한정·4단계 라벨 동기화 코드·미매칭 보고.

## B. 화면 설계 4단계 (이 순서로)
2단계(골격 세팅)와 3단계(세부 UX)를 **분리**하는 게 핵심 — 2에서 멈추면 1:1 교체가 되어 설계가 빠진다.

1. **벤치마킹(★ 하드 선행 — 스킵 금지)** — 동종 서비스 같은 유형 화면을 `lazyweb`(`lazyweb_search`)·웹 검색·`reference-research.md`로 조사해 검증된 UX 패턴·정보 위계·핵심값 파악. "이 화면에서 사용자가 가장 먼저 확인/결정하는 값"을 정의. **이걸 건너뛰면 타 도메인 화면을 답습**하게 된다(도메인 다른데 똑같아 보이는 가장 잦은 치명 실패). 사용자 레퍼런스 Figma가 있으면 IA/패턴만 학습(UI 학습 금지).
2. **기본 레이아웃 골격** — 연결 라이브러리/예시 화면의 컴포넌트로 표준 골격을 먼저 세운다(아래 ++Top 패턴). "재료 모으고 뼈대 세우기"까지.
3. **세부 UX 구성** — 골격 위에 1에서 정한 정보 위계대로 핵심값 강조·상태별 변형·액션 그룹화·여백·플로팅 CTA 설계. 기성 컴포넌트가 맥락에 안 맞으면 베리에이션/재구성. **★ 부득이 자작 TEXT를 만들면 그 자리에서 즉시 HPDS 텍스트 스타일·색 토큰을 바인딩한다**(§K로 미루지 말 것 — §K 게이트는 안전망).
4. **디스크립션** — 완성 디자인을 보고 뱃지·디스크립션 작성·동기화 → `design-description` 스킬.

## C. 표준 화면 골격 (++Top / Body / ++Bottom — 고정 영역 그룹핑)
화면은 **상단 고정(++Top) · 스크롤 콘텐츠(Body) · 하단 고정(++Bottom)** 3영역으로 나눈다. 상·하단 고정 영역은 콘텐츠와 **별도 프레임으로 그룹핑**한다(평면으로 흩지 않는다 — 운영 레이어 컨벤션).
- **`++Top`(모든 화면 필수, 화면 최상단 고정 프레임):** `Notch`/`UI/Status Bar` + TopAppBar(`header/main` 등). 세로 auto-layout `++Top` 1개로 묶는다.
- **`Body`(스크롤 콘텐츠):** (제목 필요 시) `title/24_16`(키=카탈로그 M-16) 등 공통 타이틀 컴포넌트 + 입력/콘텐츠 영역. 제목·입력은 **raw TEXT 금지** — DS 컴포넌트 인스턴스로(§L). 각 요소는 실제 컴포넌트. **★ DS 컴포넌트가 없어 부득이 자작 TEXT를 둘 땐, 만드는 즉시 HPDS 텍스트 스타일(`setTextStyleIdAsync`)+색 변수를 바인딩한다**(폰트 로드(§E)는 편집 전제일 뿐 타이포 토큰 적용이 아니다 — §K로 미루지 말고 생성 시점에, §K는 안전망). **좌우 콘텐츠 거터 = 24**(운영 기준, 레퍼런스 Container x=24). 고정 헤더/풋터 DS 컴포넌트는 자체 패딩을 따른다. ★ Body가 auto-layout이면 거터는 **`paddingLeft/Right=24`** 로 주고 구조 자식은 **`layoutSizingHorizontal='FILL'`**(고정폭 좌측정렬은 좌우 비대칭 거터를 만든다 — 자식 `.x`만 바꾸면 Figma가 ABSOLUTE로 전환돼 거터가 어긋남). **`content`/`Agreement` 같은 콘텐츠 프레임은 ABSOLUTE 금지 → Body 자식으로 in-flow(`layoutPositioning='AUTO'`) + `FILL`**(거터는 Body padding, 세로 위치는 gap). 정본 예시 `383:3923`.
- **`++Bottom`(하단 고정 프레임, 1차 액션·내비 화면):** 화면 최하단에 고정되는 영역을 하나의 `++Bottom` 프레임으로 묶는다. 구성: **1차 액션 CTA `btn54_main_set`(풀폭)** + 하단 시스템 바(`UI/Navigation Bar`/`Home Indicator`). CTA만 있고 내비가 없으면 CTA + Home Indicator. 목록·홈 유형은 탭 `Navigation Bar`.
- 인식 규칙: ⓐ 모든 화면 = `++Top` + (하단 고정 필요 시) `++Bottom` ⓑ 제목 화면 = Body에 `title/24_16` ⓒ "선택→다음/구매/확인" 1차 액션 화면 = `++Bottom`에 `btn54_main_set`.
- 참조 정본: HPDS 예시 화면 `app_loan_012`(`NbiTRVYBbGXf3PyBMwxYs1` 36146:106685) = Top Module + title + `use_form` 리스트 / 하단 `btn54_main_set` + Home Indicator. 같은 유형 화면은 이 구조를 따른다.

### C-결과. 결과/상태 화면 패턴 (완료·실패·처리중·빈 결과 공통)
종료성 결과·상태 화면(가입 완료/실패, 처리중, 빈 결과 등)은 입력 화면과 달리 **중앙 정렬 결과 패턴**을 공통으로 쓴다(정본 HPDS `36146:104635`):
- **Top**: Notch(+ 해당 시 header/main 백/X). 종료 화면이라 헤더 없는 경우도 많음.
- **Content(중앙)**: ① **Icon 일러스트(대, ~240×154)** = HPDS **`Glassmorphism` 셋**(상태 글래스 일러스트, 키=카탈로그 M-21) variant — **완료=`Pass_Image` · 처리중/대기=`wait_Image`(시계) · 실패=`error`**. ⚠️ DS 일러스트가 미퍼블리시면 import 실패 → 사용자에게 **라이브러리 게시 요청**(§H, 직접 그리지 말 것). ② **Message**(정본 `409:6524`/Message `409:6526`, center·gap16) = **Message Container**(center·gap12) [ **타이틀**(결과 카피, **`Title/H1_B_24`**·`gray700_text_end`) + **서브타이틀**(상태, **`Title/H4_B_18`**·`primary500`, 예 "처리 중"·"가입 완료") ] + **본문 안내**(gray600 `Body/P3_R_14`, center·멀티라인). ③ (선택) **요약/상세 블록** — 결과에 핵심 데이터(계좌·금액·일자 등)가 있으면 Message 아래에 **`ui/detail`(§M-7)** 라벨+값 행으로(bespoke 카드 금지).
- **Footer(=++Bottom 고정)**: (선택) 불릿 **보조 안내** + **`btn54_main_set`** CTA + **Home Indicator**. 2개 액션이면 btn54 Default + sub.
- 인식 규칙: 화면이 "사용자 입력 없이 결과/상태를 보여주고 한두 개 액션으로 빠져나가는" 유형이면 이 패턴. 처리중은 Icon=로딩, 액션 없음(Footer 생략 가능).

## D. 조립 — clone vs 라이브러리 (채택 우선순위)
1. **기성 composite/section 컴포넌트** 그대로(`importComponentByKeyAsync`→`createInstance`). ← 최우선. 연결 라이브러리는 `search_design_system`(includeLibraryKeys로 한정)·`get_libraries` 로 수집, 페이지 로컬은 `findAllWithCriteria({types:['COMPONENT','COMPONENT_SET']})`.
2. 없으면 **atom**(행·텍스트·아이콘·칩)으로 Auto Layout 조립.
3. **bespoke 도형/그룹은 최후** — 콘텐츠 자산(아이콘·이미지)에만. UI 골격을 bespoke로 만들지 않는다.
- **유사화면 clone**: 가장 유사한 기존 화면의 SB_Templates+SECTION+Description **3개를 함께** clone(하나라도 빠지면 구조 불일치). 이후 화면은 이 행을 clone 소스로 재사용.
- **★ 빈 캔버스(그린필드) — 3세트 골격은 정본 부품에서 반입, 발명 금지.** 파일에 clone할 3세트 행이 없으면 **`sources.json` `figma.storyboard_template_file`의 게시된 정본 세트(§M-23)를 `importComponentByKeyAsync`로 반입**해 첫 행을 구성한다(SB_Templates 보드·SECTION·Description·annotation-frame·label-group). **골격·Description·label-group을 "스킬 규격 문서만 보고" 새로 그리지 말 것**(과거 사고 근본원인 — 규격은 맞아도 팀 정본과 구조가 다름). §M 방어순서 준수: 키 import → `search_design_system` 이름 검색 → 노드 존재 확인 후 clone → **못 찾으면 멈추고 사용자에게 정본 반입/게시 요청**(header/main 게시와 동일 1회 셋업). `storyboard_template_file` 미등록이면 진행하지 말고 요청. **개별 화면 콘텐츠(입력·버튼·결과 등)는 위 1·2·3 우선순위대로 라이브러리 조립**(발명 금지 대상은 3세트 *골격*).
- **★ clone = 재료가 아니라 "구조"까지 가져온다 → 같은 도메인·같은 IA 화면만 clone.** 픽스 컴포넌트(§M)·골격은 재료로 재사용하되, **타 도메인 화면 전체를 clone해 atom(텍스트·값)만 바꾸지 말 것**(대원칙 위반 — 구조가 남의 것이라 설계가 아니다). 신규 도메인은 §B-1 벤치마크로 IA를 먼저 잡고 DS 조립으로 첫 화면을 지은 뒤, 그 화면을 같은-IA clone 소스로.
- 콘텐츠(텍스트·이미지·값)는 **인스턴스 오버라이드/스왑**으로 채운다(구조는 컴포넌트, 값만 주입).
- 신규 화면 Y 좌표 = 마지막 화면 Y + 화면 높이 + 200(gap).

## E. 텍스트·폰트
- 폰트 로드 순서: **기존 폰트 → Pretendard Regular → Inter Regular → Noto Sans KR**. `loadFontAsync` 없이 텍스트 수정 금지. mixed 폰트는 `getRangeFontName` 전수 로드 후 수정. (상세 `references/node-ops.md`)

## F. 컴포넌트 swap·삽입 결함 3종 (반드시 점검)
swap/삽입 시 ① swap 후 색·모양 이상(per-vector fill 잔재 → `resetOverrides`) ② FIXED 높이 수동확장 팬텀여백 ③ **hug 미처리 붕괴·흰여백**(가장 잦음 → `scripts/hug-fix.js`, `storyboard-build` §9 #9 자동 audit)을 점검한다. 같은 계층만 `swapComponent`·옛 요소 완전삭제·**swap 대상은 하드코딩 ID 금지(역할로 탐지)**. **상세·실패사례·이모지 탐지 정규식은 `references/node-ops.md`를 읽어 따른다.**

## G. 심볼(INSTANCE) 내부 수정이 안 먹힐 때
아이콘·텍스트·색상 수정이 반영 안 되면 대상이 인스턴스 내부다(id에 `I`·`;` 또는 `type==='INSTANCE'`). 여러 인스턴스면 전부 순회, `setProperties`→`swapComponent`→`detachInstance` 순, 후 `get_screenshot` 검증. **상세는 `references/node-ops.md`.**

## H. zero-bespoke 마감 (출시 품질)
구조가 선 화면을 출시 품질로 마감하는 별도 패스. **"큰 요소만 DS"가 아니라 "전 요소 DS"가 기준.**
- 안내/상태 문구 → 정보 배너 컴포넌트(평문 금지). **탭 → `EL_tab_1deapt`(M-9) · 필터/세그먼트 칩 → `EL_tab_2deapt`(M-10)** — 직접 그린 pill/탭 금지. 선택 표시 → Radio/Checkbox 컴포넌트(직접 그린 원 금지). 강조 라벨 → Badge/Label.
- 화면 크롬: 상단 Status Bar·Header, 하단 Navigation Bar/Home Indicator 를 DS 인스턴스로.
- 검증: 모든 **비-콘텐츠 UI 노드**가 `type==='INSTANCE'`(+`getMainComponentAsync().remote`)인가. 남은 `RECTANGLE/ELLIPSE/FRAME` bespoke UI 는 DS 컴포넌트로 교체. (이 커버리지는 `storyboard-build` §9 #1, 인스턴스 무결성(detach/override)은 §9 #7로 **마감 시 자동 audit**된다.)
- **★ bespoke 전에 전 연결 라이브러리를 전수 탐색(스킵 금지).** 주 라이브러리(예 🔫HPDS_1.0)에 같은 이름이 없어도 **다른 이름의 동등 컴포넌트가 있을 수 있다** — bespoke로 가기 전 `search_design_system`(query 다양화: tab/탭/segmented/chip/필터 등) + 작업 파일 레퍼런스 노드를 **반드시 먼저 검색**한다. (실패 사례: 탭/칩을 "HPDS_1.0에 없다"고 단정해 bespoke로 만들었으나, 실제로는 `EL_tab_1deapt`/`EL_tab_2deapt`로 존재 — §M-9/10.)
- **★ DS에 없으면 그리지 말고 플래그.** 전수 탐색해도 주 라이브러리에 없으면: ① **타 연결 라이브러리에 있으면 사용자 확인 후 재사용**(라이브러리 혼용은 일관성 영향 — 예: HDS 3.0 혼용은 사용자가 거부, HPDS_1.0 정본 우선) ② 어디에도 없으면 사용자에게 "DS에 없다, 어떤 소스를 쓸까" 확인 후 bespoke+§K 토큰 바인딩.

## J. 상태·활성화 표현 (디자인에 드러내기)
디스크립션의 `[Default 상태]`(예 버튼 Disabled→조건 시 Enabled)는 **텍스트로만 남기지 말고 디자인에도 드러낸다** — 개발·QA가 화면만 보고 규칙을 알 수 있게.
- **진입 상태를 기본 렌더로**: 조건부 활성 버튼/CTA는 진입 시 상태(보통 Disabled=흐림/비활성색)로 그린다. 디스크립션의 시각 상태와 일치(`design-description` §4-c).
- **핵심 인터랙티브는 상태 변형을 같이 보여줌**: 주요 CTA·토글·입력은 가능하면 enabled/disabled(또는 error/focus) 변형을 같은 SECTION 또는 인접 상태 화면으로 함께 배치하거나, 컴포넌트 variant로 표현. 최소한 policy-table `상태/전이`와 디스크립션 `[Default 상태]`에 전이 조건을 `[필드]=[값]` 으로 명시.
- **에러/실패는 별도 상태 화면 또는 visible 토글 요소**로 — §0 인벤토리의 실패 분기와 연결.

## I. 배치 처리
- **5개씩** 배치 처리(API 효율). **15개 초과** 화면은 사용자에게 범위 선택 요청.
- 페이지 작업 전 `setCurrentPageAsync(page)` 호출.

## K. UI 토큰 바인딩 (Foundation = 연결 디자인시스템, 불변)
손작업 노드도 **raw hex·raw 폰트 금지** — 색은 변수(`setBoundVariableForPaint`), 타이포는 텍스트 스타일(`setTextStyleIdAsync`)로 연결 라이브러리에 바인딩한다(DS 인스턴스는 대상 아님, **내가 작성한 TEXT/도형/프레임**이 갭). **★ 1차 적용 = 생성 시점**: 텍스트·도형을 만드는 그 순간 바인딩한다(§C·§L). 폰트 로드(§E)는 편집 전제일 뿐 타이포 토큰 적용이 아니다(타이포 토큰=텍스트 스타일). **아래 마감 검사는 1차 적용을 대체하지 않는 안전망 게이트**(부분적용 금지): authored 노드 전수 검사 — 도형 `fills[0].boundVariables.color` 有 + 각 TEXT `textStyleId` 有, 1건이라도 빠지면 미완료(점검 `scripts/token-audit.js`). **변수/텍스트스타일 GUID는 카탈로그에 캐시하지 않고** 매번 `get_variable_defs`/`search_design_system` 이름 조회(컴포넌트 key 캐시하는 §M과 다른 취급). **상세 절차·스타일 예시·검증 예외는 `references/tokens.md`를 읽어 따른다.**

## L. 컴포넌트 매칭 (필드 → DS 컴포넌트, bespoke 금지)
같은 의미의 UI는 **DS의 전용 컴포넌트**로 짓는다 — 입력/선택/라벨/바텀 액션을 직접 도형·텍스트로 조립하지 않는다(§D 우선순위의 구체화). 반복 오버레이·안내·상세블록은 §M 픽스 컴포넌트 카탈로그의 정본 clone.
- **구체 키·노드·프로퍼티는 `design-system-catalog.md`(부품 카탈로그) + 기계용 `sources.json` `figma.design_component_keys` 레지스트리**에 있다(`knowledge-base` 스킬, 워크스페이스 우선 → 플러그인 시드). 적용은 카탈로그 **사용 규약(부품 유형 2분류 + 방어적 해석 순서)** 을 단일 소스로 따른다. 요지(복붙 아닌 참조):
  - **★ 구독 프리플라이트(빌드 시작 시·화면 그리기 전 1회 필수).** `get_libraries`로 대상 파일 구독 목록을 읽어, `design_component_keys._libraries`(HPDS·🌸HDS 3.0 등)가 **다 구독됐는지 확인**. 빠지면 **STOP + "Assets→Libraries에서 <라이브러리> 추가" 요청**. 이걸 건너뛰면 빌드 중간 "key not found"→bespoke로 샌다(과거 사고: ARGOS가 HDS 3.0 미구독이라 popup/notification import 실패→silent bespoke).
  - **keyed**: 레지스트리/카탈로그 키 import → 실패 시 `search_design_system` 이름 재검색(**게시 여부 재확인**, 찾으면 키를 레지스트리에 기록) → **특정 라이브러리 전용인데 미구독이면 STOP+구독요청** → 진짜 부재면 STOP+게시요청. **"미게시"를 영구 사실로 단정 금지**(매 빌드 재확인).
  - **composite(조립형, M-2 Message·M-7 detail·M-8 empty)**: 단일 키가 원래 없는 부품 — 카탈로그 `조립 레시피`(게시 원자·텍스트스타일)로 조립. **이건 bespoke가 아니다**(원자가 전부 DS 토큰).
  - **★★ silent bespoke 절대 금지.** 위로 못 구하면 **STOP + 사용자 플래그**(구독/게시 옵션 안내). 사용자 명시 승인 없이 원자 재조립하고 완료 보고하지 말 것. 부득이한 bespoke는 build-log·보고에 **⚠️ 플래그**.
  - **★ harvest(키 수확)**: 카탈로그 키가 비었/낡았으면 손으로 노드 뒤지지 말고 소스 DS 파일 게시 인스턴스에서 `getMainComponentAsync().key`+`.remote`+라이브러리를 스캔해 레지스트리를 채운다(§M-harvest).
- **입력·선택·필드 라벨 = `use_form` 합성 컴포넌트.** `use_form`은 **상위 타이틀(라벨) + 입력 필드 + 안내/에러 메시지**를 한 묶음으로 제공하는 공통 패턴이다. 필드 위 라벨도 raw TEXT가 아니라 use_form의 타이틀로(인풋 상위 타이틀 공통 적용). 안쪽 입력은 `EL_input` variant(default/typing/end/disabled/error). **select(통신사/국가 등)** 는 정본 select use_form(`EL_Select_Flag`)을 clone — **셰브론(▼)은 내장**이라 bespoke `▾` 텍스트 금지. 국가가 아니면 앞 국기 아이콘·`flag_ellipse`를 `visible=false`. 텍스트형(이름)·휴대폰·이메일·금액은 일반 `EL_input`. (키·노드·프로퍼티 = 카탈로그)
- **★ use_form은 프로퍼티가 수십 개(boolean/swap/text)라 0부터 구성하면 오류가 잦다 → 정본 인스턴스를 clone.** DS 레퍼런스 예시나 이미 올바르게 구성된 화면의 use_form 인스턴스를 `clone()`해 **텍스트(타이틀·placeholder·안내)와 visible만 오버라이드**한다(주요 프로퍼티 목록은 카탈로그). 타이틀 텍스트는 내부 타이틀 노드 직접 오버라이드.
- **바텀 고정 1차 액션 = `btn54_main_set`**(풀폭). `++Bottom` 프레임 안에서 `UI/Navigation Bar`/`Home Indicator` 위에 얹는다(§C). 변형: Default(활성)·disabled(비활성)·sub·icon+btn54. raw 버튼·`btn60` 직접 사용 금지. (키·라벨 노드 = 카탈로그)
- **DS에 매칭 컴포넌트가 없으면**: 직접 그리되 ① 비슷한 스타일로 정리하고 ② **활용 가능한 DS 패턴(인풋 상위 타이틀·라벨·헬프텍스트 등)은 공통 적용**하며 ③ 색·타이포는 **그릴 때 즉시** 토큰 바인딩(§K 절차 — 텍스트 스타일+색 변수; 게이트는 안전망, 마감까지 미루지 않음). 그래도 핵심 컴포넌트가 없으면 §H처럼 사용자에게 소스 확인.
- **교체 시 옛 bespoke는 삭제가 아니라 `visible=false`로 숨김**(추적·복구용, 보호 레이어 원칙). 숨긴 노드는 렌더되지 않아 이중 테두리 없음(§F).

## M. 공통 픽스 컴포넌트 카탈로그 (반복 패턴 = 정본 1벌)
자주 쓰는 오버레이·블록·안내(M-1~M-13)는 매번 새로 만들지 말고 **정본 컴포넌트를 import/clone**한다(use_form과 동일 원칙 — §L). **clone 후 텍스트·visible·variant만 오버라이드**, 색·타이포는 §K 토큰 유지, 옛 bespoke는 `visible=false`(§L).
- **구체 부품 번호(componentKey·clone 노드·프로퍼티)는 `design-system-catalog.md`(부품 카탈로그)에 있다** — `knowledge-base` 스킬, 워크스페이스 `.planning/knowledge-base/design-system-catalog.md` 우선, 없으면 플러그인 시드(`templates/knowledge-base/design-system-catalog.md`). 카탈로그의 **방어적 해석 순서**(키 import → 이름 검색 폴백 → 노드 존재 확인 후 clone → 못 찾으면 사용자 플래그)를 따른다(아래 §L 동일). M-# 카테고리: M-2 결과 메시지·M-3 셀렉트시트·M-4 안내시트·M-5 팝업·M-6 인포박스·M-7 상세내역·M-8 빈상태·M-9 탭·M-10 칩·M-11 PIN·M-12 국기·M-13 필터/총개수·M-14 뱃지·M-15 약관동의·M-16 타이틀(24_16/18_16)·M-17 텍스트버튼·M-18 배너버튼·M-19 그리드메뉴·M-20 화면크롬(노치/상태바/헤더/내비)·M-21 결과일러스트(Glassmorphism)·M-22 라디오/체크박스·**M-23 스토리보드 정본 세트**(SB_Templates 보드·SECTION·Description·annotation-frame·label-group — §A 3세트 골격의 정본 부품, 그린필드 반입 소스)·M-1 마진(규칙).
- **★ 픽스 컴포넌트(팝업 M-5·시트 M-3/M-4·인포박스 M-6·상세 M-7·빈상태 M-8·결과 M-2)는 "미게시"라 단정하지 말 것 — 매 빌드 게시 여부를 재확인한다.** 많은 경우 이미 게시돼 있고(예: HPDS `bottom_sheet_main`·HDS 3.0 `popup`/`notification`), **키가 카탈로그에 없던 것뿐**이다. 절차: ① 카탈로그 키 있으면 `importComponentByKeyAsync` ② 실패/키 없음이면 `search_design_system`(컴포넌트명, `includeLibraryKeys`로 라이브러리 순회)으로 **게시 여부 재확인** → 찾으면 import + **카탈로그 키 갱신**(다음부터 즉시 적용) ③ 특정 라이브러리(예 🌸 HDS 3.0)에만 있고 대상 파일이 **미구독**이면 import가 "key not found"로 실패 → **사용자에게 그 라이브러리 구독(Assets→Libraries) 또는 정본 인스턴스 복사를 요청**(원인=구독 차이, 미게시 아님).
- **★★ bespoke 재조립은 silent 금지 — 최후·플래그 필수.** 위 ①②③로도 못 구하면 그때만 원자 재조립하되, **build-log·사용자 보고에 "⚠️ bespoke fallback: DS 컴포넌트 X 미확보(라이브러리 Y 구독 필요) — 지정 시스템 아님"** 을 반드시 남긴다. **말없이 bespoke로 짓고 완료 보고하지 말 것**(과거 사고: ARGOS 팝업/시트/인포박스/Message를 HDS 3.0 미구독 상태에서 silent bespoke로 지어 사용자가 뒤늦게 발견). §L ④ "bespoke 금지·사용자 플래그"의 강행.
- **★ 픽스부품 유형 2분류(카탈로그 단일 소스)**: **keyed**(단일 게시 컴포넌트·키 import — M-3/M-4/M-5/M-6 등) vs **composite**(단일 키 없음·DS 원자 조립 — M-2 Message·M-7 detail·M-8 empty). composite는 카탈로그 `조립 레시피`(게시 원자·텍스트스타일)로 짓는 것이지 **bespoke가 아니다**(원자가 전부 DS). "없다"로 넘기지 말고 유형을 확인.
- **★ harvest 루틴(키 수확·재현 가능 — 카탈로그 키가 비었거나 낡았을 때).** **1차 진실은 `search_design_system`(라이브러리 게시 키)** 이다. 인스턴스 mainComponent 스캔은 보조 — ⚠️ **인스턴스의 `getMainComponentAsync().key` ≠ 라이브러리 게시 키일 수 있다**(옛 로컬 사본·재퍼블리시 전 키 → import "not found"). 절차: ① `search_design_system`(컴포넌트명, `includeLibraryKeys`로 라이브러리 순회)로 **게시 키를 얻고** ② `importComponentByKeyAsync`(set이면 `importComponentSetByKeyAsync`)로 **실제 import 검증** ③ 검증된 키를 `design_component_keys` 레지스트리·카탈로그에 기록. composite(단일 컴포넌트로 안 잡히는 것)는 게시 원자(텍스트스타일·`title_detail/18`·`ico40/empty`) 키를 `조립 레시피`로 등재. DS 갱신 시 재실행. (실패 사례: 인스턴스 키 `f844c8e4`로 등재했다 import 실패 → search로 실제 `ui/popup` `a0fe2983` 확인.)
- **★ M-23 스토리보드 정본 세트 = 게시 컴포넌트(키 import).** 키는 `sources.json` `figma.storyboard_component_keys`(+카탈로그 M-23)에 등록. 그린필드에서 3세트 골격을 반입할 때 쓴다(§A·§D). **사용 패턴**: `SB_Templates` 보드·`SECTION`은 인스턴스로 배치(SB 라벨은 리플로우가 섹션명에서 동기화). `Description`은 import 후 **detach**해 편집 가능한 컨테이너로 만들고, 그 안에 `annotation-frame` 인스턴스를 **화면 배지 수(N)만큼** 넣어 텍스트(`"1"`/`"Section Title.."`/`"Lorem ipsum.."`)만 오버라이드, 배지는 `label-group` 인스턴스로. **포맷은 게시본에서 오고, 개수만 화면별.** 미등록/미게시면 §D "못 찾으면 사용자 요청" 규칙.

- **★ clone-override 함정 2종(인포박스·M-8 등 가변 높이 컴포넌트에서 자주).** ① **불필요한 `setProperties` 금지** — 정본 인스턴스는 이미 원하는 variant·높이로 collapse돼 있는데, 같은 variant라도 `setProperties(Type=…)`를 호출하면 **메인 컴포넌트 기본 상태(모든 줄 노출·큰 높이)로 리셋**된다(예: red 인포박스가 60→380px). variant 변경이 꼭 필요할 때만 호출하고, 텍스트는 **렌더되는 TEXT 노드를 직접** 세팅(프로퍼티가 보이는 노드에 안 묶여 있을 수 있음). ② **auto-layout 부모에 append 시 `layoutGrow`/`layoutAlign`/`layoutSizingHorizontal` 점검** — 컴포넌트가 `layoutGrow=1`이면 **세로 auto-layout 부모에 들어가는 순간 세로를 꽉 채워 부풀어 깨진다**(결과·빈상태 화면 Body, 폼 content 모두 VERTICAL auto-layout인 경우 많음). append 후 **가변높이 컴포넌트는 `layoutGrow=0` + `counterAxisSizingMode='AUTO'`(높이 hug)**, 절대배치 필요 시 `layoutPositioning='ABSOLUTE'`. **auto-layout content 안 구성 자식은 width를 `layoutSizingHorizontal='FILL'`로 통일**(use_form·인포박스 등 — FIXED 폭이면 반응형 깨짐). 부모 content는 가능하면 `primaryAxisSizingMode='AUTO'`(height hug)로 spare 세로여백 제거(grow가 채울 여백 자체를 없앰).
- **오버레이(M-3·M-4·M-5)는 별도 풀스크린 화면이 아니라 트리거 화면 위 오버레이**다 → 스토리보드에선 **트리거 화면 옆 상태 프레임**으로 둔다(상세케이스 방식, `storyboard-build` §6). 디스크립션에 **트리거(어디서 열리나)·복귀 경로**를 명시(`design-description`).
- **오버레이 배지 = parent + 액션 하위배지**(`design-description` §4-e): 오버레이에 **다음 정수 배지(parent)**, 내부 **액션 요소(버튼·항목·닫기)마다 하위 배지 Na/Nb**. ★ 닫기/바깥탭도 오버레이마다 "배지 1"을 또 달지 말 것 — 그 오버레이의 하위 배지(예 5b)로(과거 중복·고아 사고). base 트리거 요소엔 `→ (N)` 포인터.
- **안내 문구는 raw TEXT/캡션이 아니라 M-6 인포박스**로(평문 안내 금지, §H 정신). 부정/주의=red, 긍정/완료=blue, 중립 안내=gray.
- **결과 화면의 상세 데이터는 M-7 `ui/detail`**로(bespoke 요약 카드 금지). §C-결과 ③과 동일.

## 원칙
- 출처 없는 단정 금지. 전략적 UX 배치는 `⛳DECISION` 으로 표시하고 옵션·추천만 제시(사람 결정). 이 결정은 `decision-checklist` 스키마로 `policy-table.md` 디자인 의사결정 체크리스트에 `D-n` 적재(`storyboard-build` 참조).
- 모든 산출물(백업·로그)은 **CWD 워크스페이스** `engagements/<slug>/design/` 에. 플러그인 디렉토리에 쓰지 않는다.
- 디자인을 바꾸면 해당 디스크립션도 그에 맞춰 동기화한다(따로 놀지 않게) → `design-description`.
