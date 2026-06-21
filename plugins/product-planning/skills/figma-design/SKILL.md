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

- **화면 ID**: `P-NN`(예 P-01). `SB_Templates` 내 `[화면 ID]` 텍스트에 기록, 기존 최대+1 순차 부여.
- **Update 뱃지**: 디스크립션 완료 후 `visible=false`, 검토 필요 화면은 `true` 유지.
- 화면 추가·교체 후 **뱃지(label-group/text-area)는 항상 최상위 z-order** 로(`parent.appendChild(badge)`) — 새 프레임 아래로 가려지지 않게.
- **뱃지 배치(운영 양식)**: 뱃지는 `label-group` 그룹으로 **SECTION 노드의 직속 자식**(디자인 프레임의 형제·최상위 z)으로 두어 디자인 프레임과 **겹치지 않게** 좌측 가장자리에 붙인다(요소 edge 옆). **좌표는 부모 기준 상대좌표**다 — SECTION 자식은 섹션 상대, auto-layout 프레임 내부에 둘 땐 `layoutPositioning="ABSOLUTE"` + 프레임 상대. **페이지 절대좌표를 주면 화면 밖/바닥으로 빠진다**(흔한 실수).
- 신규/수정 화면은 항상 이 3세트 구조로 맞춘다.
- **수직 행 리플로우 — 규칙이 아니라 "실행 패스"(겹침 금지).** ★ `SB_Templates` 카드·SECTION·Description은 **부모 auto-layout 없이 페이지에 절대좌표로 놓인 독립 형제**이고 `SB_Templates`는 **고정 높이 인스턴스**다 → Description가 길어져도 **자동으로 안 커지고 안 밀린다.** 반드시 아래 **리플로우 패스를 명시적으로 실행**해야 한다(규칙만 적고 안 돌리면 미반영):
  - 행을 위→아래로 순회하며 `rowTop` 누적. 헤더오프셋 = SECTION/Description top − SB top(예 142).
  - **`SB_Templates` 인스턴스 height를 강제 리사이즈**: `sb.resize(폭, 헤더오프셋 + max(SECTION.height, Description.height) + pad(≈40))` — 카드가 콘텐츠 전체를 덮게(인스턴스 resize 가능; 막히면 보고). SB_Header 밴드는 상단 고정·카드 바디가 늘어남.
  - 같은 행 `SB.y = rowTop`, `SECTION.y = Description.y = rowTop + 헤더오프셋`. 다음 행 `rowTop += SB.height + gap(≈60)`.
  - 리플로우 후 `get_metadata`/`get_screenshot` 으로 카드가 Description를 덮고 행 간 겹침 0 확인.
- **자동 발견 리플로우 루틴(하드코딩 id 금지 · 재사용).** 특정 화면 id를 박지 말고 페이지에서 행을 **스스로 찾아** 리플로우한다 — 어떤 스토리보드 페이지에도 동작:
  ```
  // 1) 행 발견: SB_Templates 인스턴스를 Y 오름차순 정렬
  rows = page.children.filter(n => n.type==='INSTANCE' && n.name==='SB_Templates').sort(byY)
  for each sb (위→아래, rowTop = 첫 행 sb.y 부터 누적):
    // 2) 같은 행의 SECTION·Description 매칭(Y 근접 + X 위치)
    sec  = page.children.find(SECTION, |n.y-(sb.y+OFF)|<선, n.x≈36)         // 디자인 섹션
    desc = page.children.find(FRAME name='Description', |n.y-(sb.y+OFF)|<선, n.x≈1421)
    OFF = sec.y - sb.y (첫 행에서 측정; 보통 142)
    // 3) 리사이즈 + cascade
    rowH = OFF + max(sec.height, desc.height) + pad(40)
    sb.resize(sb.width, rowH); sb.y=rowTop; sec.y=desc.y=rowTop+OFF
    rowTop += rowH + gap(60)
  return 매칭 카운트(행수·미매칭) // dry-run 보고로 오매칭 0 확인
  ```
  - **완료 게이트(필수).** 디자인/디스크립션을 **편집한 커맨드는 마감에서 이 루틴을 항상 실행**한다(`storyboard-build`/`design-description`/`/design-sync`). 사용자가 따로 요청하지 않아도 자동. *단* Figma에서 손으로 직접 편집한 경우는 자동이 아니므로 `/design-sync`로 1회 트리거.
  - 미매칭(비표준 행: SB 없음/Description 이름 불일치)은 건너뛰고 **카운트로 보고**(임의 이동 금지).

## B. 화면 설계 4단계 (이 순서로)
2단계(골격 세팅)와 3단계(세부 UX)를 **분리**하는 게 핵심 — 2에서 멈추면 1:1 교체가 되어 설계가 빠진다.

1. **벤치마킹(★ 하드 선행 — 스킵 금지)** — 동종 서비스 같은 유형 화면을 `lazyweb`(`lazyweb_search`)·웹 검색·`reference-research.md`로 조사해 검증된 UX 패턴·정보 위계·핵심값 파악. "이 화면에서 사용자가 가장 먼저 확인/결정하는 값"을 정의. **이걸 건너뛰면 타 도메인 화면을 답습**하게 된다(도메인 다른데 똑같아 보이는 가장 잦은 치명 실패). 사용자 레퍼런스 Figma가 있으면 IA/패턴만 학습(UI 학습 금지).
2. **기본 레이아웃 골격** — 연결 라이브러리/예시 화면의 컴포넌트로 표준 골격을 먼저 세운다(아래 ++Top 패턴). "재료 모으고 뼈대 세우기"까지.
3. **세부 UX 구성** — 골격 위에 1에서 정한 정보 위계대로 핵심값 강조·상태별 변형·액션 그룹화·여백·플로팅 CTA 설계. 기성 컴포넌트가 맥락에 안 맞으면 베리에이션/재구성.
4. **디스크립션** — 완성 디자인을 보고 뱃지·디스크립션 작성·동기화 → `design-description` 스킬.

## C. 표준 화면 골격 (++Top / Body / ++Bottom — 고정 영역 그룹핑)
화면은 **상단 고정(++Top) · 스크롤 콘텐츠(Body) · 하단 고정(++Bottom)** 3영역으로 나눈다. 상·하단 고정 영역은 콘텐츠와 **별도 프레임으로 그룹핑**한다(평면으로 흩지 않는다 — 운영 레이어 컨벤션).
- **`++Top`(모든 화면 필수, 화면 최상단 고정 프레임):** `Notch`/`UI/Status Bar` + TopAppBar(`header/main` 등). 세로 auto-layout `++Top` 1개로 묶는다.
- **`Body`(스크롤 콘텐츠):** (제목 필요 시) `title/24_16` 등 공통 타이틀 컴포넌트 + 입력/콘텐츠 영역. 제목·입력은 **raw TEXT 금지** — DS 컴포넌트 인스턴스로(§L). 각 요소는 실제 컴포넌트. **좌우 콘텐츠 거터 = 24**(운영 기준, 레퍼런스 Container x=24). 고정 헤더/풋터 DS 컴포넌트는 자체 패딩을 따른다. ★ Body가 auto-layout이면 거터는 **`paddingLeft/Right=24`** 로 주고 구조 자식은 **`layoutSizingHorizontal='FILL'`**(고정폭 좌측정렬은 좌우 비대칭 거터를 만든다 — 자식 `.x`만 바꾸면 Figma가 ABSOLUTE로 전환돼 거터가 어긋남). **`content`/`Agreement` 같은 콘텐츠 프레임은 ABSOLUTE 금지 → Body 자식으로 in-flow(`layoutPositioning='AUTO'`) + `FILL`**(거터는 Body padding, 세로 위치는 gap). 정본 예시 `383:3923`.
- **`++Bottom`(하단 고정 프레임, 1차 액션·내비 화면):** 화면 최하단에 고정되는 영역을 하나의 `++Bottom` 프레임으로 묶는다. 구성: **1차 액션 CTA `btn54_main_set`(풀폭)** + 하단 시스템 바(`UI/Navigation Bar`/`Home Indicator`). CTA만 있고 내비가 없으면 CTA + Home Indicator. 목록·홈 유형은 탭 `Navigation Bar`.
- 인식 규칙: ⓐ 모든 화면 = `++Top` + (하단 고정 필요 시) `++Bottom` ⓑ 제목 화면 = Body에 `title/24_16` ⓒ "선택→다음/구매/확인" 1차 액션 화면 = `++Bottom`에 `btn54_main_set`.
- 참조 정본: HPDS 예시 화면 `app_loan_012`(`NbiTRVYBbGXf3PyBMwxYs1` 36146:106685) = Top Module + title + `use_form` 리스트 / 하단 `btn54_main_set` + Home Indicator. 같은 유형 화면은 이 구조를 따른다.

### C-결과. 결과/상태 화면 패턴 (완료·실패·처리중·빈 결과 공통)
종료성 결과·상태 화면(가입 완료/실패, 처리중, 빈 결과 등)은 입력 화면과 달리 **중앙 정렬 결과 패턴**을 공통으로 쓴다(정본 HPDS `36146:104635`):
- **Top**: Notch(+ 해당 시 header/main 백/X). 종료 화면이라 헤더 없는 경우도 많음.
- **Content(중앙)**: ① **Icon 일러스트(대, ~240×154)** = HPDS **`Glassmorphism` 셋**(상태 글래스 일러스트, set key `1914373c1111750bc38d04c20f15e64de1f60897`) variant — **완료=`Pass_Image`(`514f2…`) · 처리중/대기=`wait_Image`(시계, `4e22f…`) · 실패=`error`(`075eb…`)**. ⚠️ DS 일러스트가 미퍼블리시면 import 실패 → 사용자에게 **라이브러리 게시 요청**(§H, 직접 그리지 말 것). ② **Message**(정본 `409:6524`/Message `409:6526`, center·gap16) = **Message Container**(center·gap12) [ **타이틀**(결과 카피, **`Title/H1_B_24`**·`gray700_text_end`) + **서브타이틀**(상태, **`Title/H4_B_18`**·`primary500`, 예 "처리 중"·"가입 완료") ] + **본문 안내**(gray600 `Body/P3_R_14`, center·멀티라인). ③ (선택) **요약/상세 블록** — 결과에 핵심 데이터(계좌·금액·일자 등)가 있으면 Message 아래에 **`ui/detail`(§M-7)** 라벨+값 행으로(bespoke 카드 금지).
- **Footer(=++Bottom 고정)**: (선택) 불릿 **보조 안내** + **`btn54_main_set`** CTA + **Home Indicator**. 2개 액션이면 btn54 Default + sub.
- 인식 규칙: 화면이 "사용자 입력 없이 결과/상태를 보여주고 한두 개 액션으로 빠져나가는" 유형이면 이 패턴. 처리중은 Icon=로딩, 액션 없음(Footer 생략 가능).

## D. 조립 — clone vs 라이브러리 (채택 우선순위)
1. **기성 composite/section 컴포넌트** 그대로(`importComponentByKeyAsync`→`createInstance`). ← 최우선. 연결 라이브러리는 `search_design_system`(includeLibraryKeys로 한정)·`get_libraries` 로 수집, 페이지 로컬은 `findAllWithCriteria({types:['COMPONENT','COMPONENT_SET']})`.
2. 없으면 **atom**(행·텍스트·아이콘·칩)으로 Auto Layout 조립.
3. **bespoke 도형/그룹은 최후** — 콘텐츠 자산(아이콘·이미지)에만. UI 골격을 bespoke로 만들지 않는다.
- **유사화면 clone**: 가장 유사한 기존 화면의 SB_Templates+SECTION+Description **3개를 함께** clone(하나라도 빠지면 구조 불일치). clone 소스가 없으면(빈 캔버스) 라이브러리 컴포넌트 조립으로 첫 화면을 만든 뒤, 이후 화면의 clone 소스로 재사용.
- **★ clone = 재료가 아니라 "구조"까지 가져온다 → 같은 도메인·같은 IA 화면만 clone.** 픽스 컴포넌트(§M)·골격은 재료로 재사용하되, **타 도메인 화면 전체를 clone해 atom(텍스트·값)만 바꾸지 말 것**(대원칙 위반 — 구조가 남의 것이라 설계가 아니다). 신규 도메인은 §B-1 벤치마크로 IA를 먼저 잡고 DS 조립으로 첫 화면을 지은 뒤, 그 화면을 같은-IA clone 소스로.
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

## J. 상태·활성화 표현 (디자인에 드러내기)
디스크립션의 `[Default 상태]`(예 버튼 Disabled→조건 시 Enabled)는 **텍스트로만 남기지 말고 디자인에도 드러낸다** — 개발·QA가 화면만 보고 규칙을 알 수 있게.
- **진입 상태를 기본 렌더로**: 조건부 활성 버튼/CTA는 진입 시 상태(보통 Disabled=흐림/비활성색)로 그린다. 디스크립션의 시각 상태와 일치(`design-description` §4-c).
- **핵심 인터랙티브는 상태 변형을 같이 보여줌**: 주요 CTA·토글·입력은 가능하면 enabled/disabled(또는 error/focus) 변형을 같은 SECTION 또는 인접 상태 화면으로 함께 배치하거나, 컴포넌트 variant로 표현. 최소한 policy-table `상태/전이`와 디스크립션 `[Default 상태]`에 전이 조건을 `[필드]=[값]` 으로 명시.
- **에러/실패는 별도 상태 화면 또는 visible 토글 요소**로 — §0 인벤토리의 실패 분기와 연결.

## I. 배치 처리
- **5개씩** 배치 처리(API 효율). **15개 초과** 화면은 사용자에게 범위 선택 요청.
- 페이지 작업 전 `setCurrentPageAsync(page)` 호출.

## K. UI 토큰 바인딩 (Foundation = 연결 디자인시스템, 불변)
손으로 만든 노드도 **raw hex·raw 폰트 금지** — 색·타이포는 연결 라이브러리(예 HPDS_1.0) 변수에 바인딩한다. DS 컴포넌트 인스턴스는 자체 바인딩을 갖고 오므로 대상이 아니고, **내가 작성한 TEXT/도형/프레임**이 갭이다(가장 잦은 토큰 미적용 원인).
- **색**: `node.fills` 의 SOLID paint를 `setBoundVariableForPaint(paint, 'color', variable)` 로 색 변수에 바인딩(텍스트 컬러·배경·라인 모두). 변수는 `search_design_system`(includeVariables) / `get_variable_defs` 로 수집(예 `Grayscale/gray900`·`Primary/primary500`·`Grayscale/gray600_text_fields`).
- **타이포(색만으로는 불충분 — 텍스트 스타일 토큰 필수)**: 손작업 TEXT는 색 변수만이 아니라 **HPDS 텍스트 스타일**을 적용한다 — `node.setTextStyleIdAsync(style.id)`(스타일은 `figma.getLocalTextStylesAsync()`/원격 라이브러리에서 이름으로 조회). 폰트 스타일이 토큰화되지 않으면 색만 라이브러리고 타이포는 raw로 남는다(사용자가 별도 적용해야 했던 실패 사례). 공통 스타일 예: 제목 `✏️ Title/H1_B_24`·`H3_B_20`, 본문 `✏️ Body/P2_R_16`·`P3_B_14`(라벨)·`P3_R_14`, 캡션 `✏️ Caption/C1_R_12`. 스타일 적용 전 해당 폰트 로드(§E). DS에 토큰이 없을 때만 raw, 그 경우 §H 플래그.
- **검증**: 작업 노드에 `get_variable_defs`(색) + 각 TEXT의 `textStyleId`(타이포) 확인 → 손작업 텍스트/도형이 DS 변수·스타일로 잡히는지(raw hex/raw 폰트 잔존 0). 안 잡히면 미바인딩.

## L. 컴포넌트 매칭 (필드 → DS 컴포넌트, bespoke 금지)
같은 의미의 UI는 **DS의 전용 컴포넌트**로 짓는다 — 입력/선택/라벨/바텀 액션을 직접 도형·텍스트로 조립하지 않는다(§D 우선순위의 구체화). 반복 오버레이·안내·상세블록은 §M 픽스 컴포넌트 카탈로그의 정본 clone.
- **입력·선택·필드 라벨 = `use_form` 합성 컴포넌트**(HPDS key `f1df80617cffbbb72a113fc1f6e4e4b8b002e226`). `use_form`은 **상위 타이틀(라벨) + 입력 필드 + 안내/에러 메시지**를 한 묶음으로 제공하는 공통 패턴이다. 필드 위 라벨도 raw TEXT가 아니라 use_form의 타이틀로(인풋 상위 타이틀 공통 적용). 안쪽 입력은 `EL_input/*` variant(default/typing/end/disabled/error). **select(통신사/국가 등)** 는 정본 select use_form `448:5318`(안쪽 `EL_Select_Flag`)을 clone — **셰브론(▼)은 내장**이라 bespoke `▾` 텍스트 금지. 국가가 아니면 `-아이콘#34811:13=false`(앞 국기 off) + 채워진 값의 `flag_ellipse` 노드 `visible=false`. 텍스트형(이름)·휴대폰·이메일·금액은 일반 `EL_input`.
- **★ use_form은 프로퍼티가 수십 개(boolean/swap/text)라 0부터 구성하면 오류가 잦다 → 정본 인스턴스를 clone.** DS 레퍼런스 예시(`app_loan_012` 등)나 이미 올바르게 구성된 화면의 use_form 인스턴스를 `clone()`해 **텍스트(타이틀·placeholder·안내)와 visible만 오버라이드**한다. 주요 프로퍼티: `타이틀#…`(라벨 표시) · `Show EL_input/Default#…`(입력 표시) · `essential#…`(필수 닷) · `error_message#…`/`Information_message#…`(메시지 표시) · `sub_title#…`(서브 라벨 텍스트). 타이틀 텍스트는 내부 `Title Text` 노드 직접 오버라이드.
- **바텀 고정 1차 액션 = `btn54_main_set`**(key `8ed6cf4ff1be3524b921d89b0090389d9d5f9969`, 풀폭). `++Bottom` 프레임 안에서 `UI/Navigation Bar`/`Home Indicator` 위에 얹는다(§C). 변형 `Property 1`: `Default`(활성)·`disabled`(비활성)·`sub`·`icon+btn54`. 라벨은 `Text#35060:3`. raw 버튼·`btn60` 직접 사용 금지.
- **DS에 매칭 컴포넌트가 없으면**: 직접 그리되 ① 비슷한 스타일로 정리하고 ② **활용 가능한 DS 패턴(인풋 상위 타이틀·라벨·헬프텍스트 등)은 공통 적용**하며 ③ 색·타이포는 §K로 토큰 바인딩. 그래도 핵심 컴포넌트가 없으면 §H처럼 사용자에게 소스 확인.
- **교체 시 옛 bespoke는 삭제가 아니라 `visible=false`로 숨김**(추적·복구용, 보호 레이어 원칙). 숨긴 노드는 렌더되지 않아 이중 테두리 없음(§F).

## M. 공통 픽스 컴포넌트 카탈로그 (반복 패턴 = 정본 1벌)
자주 쓰는 오버레이·블록·안내는 매번 새로 만들지 말고 **아래 정본 인스턴스를 clone**한다(use_form과 동일 원칙 — §L). 정본은 작업 파일 `J483aVvinTZn5OHSdCAiE8`의 레퍼런스 페이지(음수 X 영역)에 인스턴스로 있고 HPDS DS 컴포넌트가 백킹한다. **clone 후 텍스트·visible·variant만 오버라이드**, 색·타이포는 §K 토큰 유지, 옛 bespoke는 `visible=false`(§L).
- 적용 시점에 정본 노드가 옮겨졌으면 `search_design_system`(컴포넌트명)으로 DS 컴포넌트를 직접 import. 정본 노드 ID는 같은 파일 내 빠른 clone 소스다.

| # | 용도 | 정본 노드 | 핵심 구조 / 컴포넌트 | 적용 |
| --- | --- | --- | --- | --- |
| M-1 | 레이아웃 좌우 마진 | — | — | body 콘텐츠 거터 **24**(§C). 고정 헤더/풋터 제외 |
| M-2 | 결과(완료·실패·대기) 타이틀+서브 | `409:6524`(Message `409:6526`) | Message(center·gap16) = Container(gap12)[타이틀 `Title/H1_B_24`·gray700 + 서브 `Title/H4_B_18`·primary500] + 본문 `Body/P3_R_14`·gray600 | §C-결과 |
| M-3 | 셀렉트 박스 → 리스트 | `409:6368` | `BottomSheet` = Container[header(Close `icon24` + `Title`) + **`EL_bottom_sheet/셀렉트기본`(`409:6376`)**] + Gradient + Home Indicator | 모든 select(통신사·국가·옵션) 탭 시 공통 |
| M-4 | 세부 안내 시트 | `409:5707`(BottomSheet `409:5708`) | 아이콘+타이틀 헤더 + STEP 본문 블록 + 하단 버튼 | "자세히/이용안내" 등 상세 가이드 |
| M-5 | 컨펌·서버에러 팝업 | `409:5709`(Popup `409:5711` > `Popup Content` `409:5712`) | 본문 텍스트 + 취소/확인 2버튼(307 폭) | 실행 전 확인 다이얼로그 **및 서버 응답 에러** |
| M-6 | 안내 인포박스 | `409:5877`(`notification`) | 아이콘(`ico20/info2`)+텍스트, radius12·pad16/12 | 안내 문구. variant 색: **red=부정·blue=긍정·gray=안내** |
| M-7 | 결과 상세 내역 | `409:5534`(`ui/detail`) | 라벨+값 행 + divider, bg `03(f4f7fd)`·radius12 | 완료/실패/대기에 핵심 데이터(계좌·금액 등). 강조값 primary |
| M-8 | 빈 상태(empty) | `409:6567`(`Frame 1597884660`) | 아이콘 + 안내 타이틀(+선택 서브/CTA), VERTICAL | 리스트/검색 결과 없음. 컨텐츠 영역 중앙 배치, 타이틀만 교체 |

- **★ clone-override 함정 2종(인포박스·M-8 등 가변 높이 컴포넌트에서 자주).** ① **불필요한 `setProperties` 금지** — 정본 인스턴스는 이미 원하는 variant·높이로 collapse돼 있는데, 같은 variant라도 `setProperties(Type=…)`를 호출하면 **메인 컴포넌트 기본 상태(모든 줄 노출·큰 높이)로 리셋**된다(예: red 인포박스가 60→380px). variant 변경이 꼭 필요할 때만 호출하고, 텍스트는 **렌더되는 TEXT 노드를 직접** 세팅(프로퍼티가 보이는 노드에 안 묶여 있을 수 있음). ② **auto-layout 부모에 append 시 `layoutGrow`/`layoutAlign`/`layoutSizingHorizontal` 점검** — 컴포넌트가 `layoutGrow=1`이면 **세로 auto-layout 부모에 들어가는 순간 세로를 꽉 채워 부풀어 깨진다**(결과·빈상태 화면 Body, 폼 content 모두 VERTICAL auto-layout인 경우 많음). append 후 **가변높이 컴포넌트는 `layoutGrow=0` + `counterAxisSizingMode='AUTO'`(높이 hug)**, 절대배치 필요 시 `layoutPositioning='ABSOLUTE'`. **auto-layout content 안 구성 자식은 width를 `layoutSizingHorizontal='FILL'`로 통일**(use_form·인포박스 등 — FIXED 폭이면 반응형 깨짐). 부모 content는 가능하면 `primaryAxisSizingMode='AUTO'`(height hug)로 spare 세로여백 제거(grow가 채울 여백 자체를 없앰).
- **오버레이(M-3·M-4·M-5)는 별도 풀스크린 화면이 아니라 트리거 화면 위 오버레이**다 → 스토리보드에선 **트리거 화면 옆 상태 프레임**으로 둔다(상세케이스 방식, `storyboard-build` §6). 디스크립션에 **트리거(어디서 열리나)·복귀 경로**를 명시(`design-description`).
- **오버레이 배지 = parent + 액션 하위배지**(`design-description` §4-e): 오버레이에 **다음 정수 배지(parent)**, 내부 **액션 요소(버튼·항목·닫기)마다 하위 배지 Na/Nb**. ★ 닫기/바깥탭도 오버레이마다 "배지 1"을 또 달지 말 것 — 그 오버레이의 하위 배지(예 5b)로(과거 중복·고아 사고). base 트리거 요소엔 `→ (N)` 포인터.
- **안내 문구는 raw TEXT/캡션이 아니라 M-6 인포박스**로(평문 안내 금지, §H 정신). 부정/주의=red, 긍정/완료=blue, 중립 안내=gray.
- **결과 화면의 상세 데이터는 M-7 `ui/detail`**로(bespoke 요약 카드 금지). §C-결과 ③과 동일.

## 원칙
- 출처 없는 단정 금지. 전략적 UX 배치는 `⛳DECISION` 으로 표시하고 옵션·추천만 제시(사람 결정).
- 모든 산출물(백업·로그)은 **CWD 워크스페이스** `engagements/<slug>/design/` 에. 플러그인 디렉토리에 쓰지 않는다.
- 디자인을 바꾸면 해당 디스크립션도 그에 맞춰 동기화한다(따로 놀지 않게) → `design-description`.
