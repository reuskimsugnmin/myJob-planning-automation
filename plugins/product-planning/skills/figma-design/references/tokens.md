# UI 토큰 바인딩 — 상세 메커니즘 (figma-design §K)

> `figma-design` SKILL.md §K의 핀 대상. 손작업 노드의 색·타이포를 연결 라이브러리 변수/텍스트 스타일에 바인딩하는 절차와 마감 검증. 토큰 적용 단계에서 이 파일을 읽어 따른다.

손으로 만든 노드도 **raw hex·raw 폰트 금지** — 색·타이포는 연결 라이브러리(예 HPDS_1.0) 변수에 바인딩한다. DS 컴포넌트 인스턴스는 자체 바인딩을 갖고 오므로 대상이 아니고, **내가 작성한 TEXT/도형/프레임**이 갭이다(가장 잦은 토큰 미적용 원인).

**★ 1차 적용은 "생성 시점"이다 — 텍스트·도형을 만들 때 바로 텍스트 스타일·색 변수를 바인딩한다(§C·§L).** 아래 전수 검사는 그 1차 적용을 **대체하지 않는 안전망 게이트**다(과거 "텍스트가 raw 폰트로 남아 사용자가 따로 폰트 라이브러리를 입혀야 했던 실패" 후 추가됨). 폰트 로드(§E `loadFontAsync`)는 편집 전제일 뿐 타이포 토큰 적용이 아니다 — 타이포 토큰 = 여기 텍스트 스타일.
- **색**: `node.fills` 의 SOLID paint를 `setBoundVariableForPaint(paint, 'color', variable)` 로 색 변수에 바인딩(텍스트 컬러·배경·라인 모두). 변수는 `search_design_system`(includeVariables) / `get_variable_defs` 로 수집(예 `Grayscale/gray900`·`Primary/primary500`·`Grayscale/gray600_text_fields`).
- **타이포(색만으로는 불충분 — 텍스트 스타일 토큰 필수)**: 손작업 TEXT는 색 변수만이 아니라 **HPDS 텍스트 스타일**을 적용한다 — `node.setTextStyleIdAsync(style.id)`(스타일은 `figma.getLocalTextStylesAsync()`/원격 라이브러리에서 이름으로 조회). 폰트 스타일이 토큰화되지 않으면 색만 라이브러리고 타이포는 raw로 남는다(사용자가 별도 적용해야 했던 실패 사례). 공통 스타일 예: 제목 `✏️ Title/H1_B_24`·`H3_B_20`, 본문 `✏️ Body/P2_R_16`·`P3_B_14`(라벨)·`P3_R_14`, 캡션 `✏️ Caption/C1_R_12`. 스타일 적용 전 해당 폰트 로드(§E). DS에 토큰이 없을 때만 raw, 그 경우 §H 플래그.
- **검증(★ 마감 필수 게이트 — 색만 바인딩하는 부분적용 금지)**: 작업 끝내기 전 authored 노드를 **스크립트로 전수 검사**한다. ① 배경/라인 도형: `fills[0].boundVariables.color` 有 ② 각 TEXT: `textStyleId` 有(빈 문자열/`figma.mixed` 아님). **fillBound=false 또는 styleId 없음이 1건이라도 있으면 미완료.** annotation 배지(`text-area`)·이모지/아이콘 글리프(국기·`›`·`▾` 등 텍스트스타일 부적합)는 제외. 텍스트스타일은 **타이포만 바꾸고 색(fills)은 불변**이므로 안전 — 적용 전 그 스타일의 폰트를 `loadFontAsync`(원격 스타일은 `setTextStyleIdAsync`가 내부 로드하나 실패 시 선로드 필요). 점검 스크립트: `scripts/token-audit.js`(대상 SECTION `sec`에 바인딩해 실행).
- **변수/텍스트스타일 GUID는 캐시하지 않는다.** §M 컴포넌트처럼 카탈로그(`design-system-catalog.md`)에 적재하지 말고 필요할 때마다 `get_variable_defs`/`search_design_system`으로 이름 기반 즉시 조회한다(개수가 많고 이름 기반 조회가 더 안전 — 컴포넌트 key는 안정적이라 카탈로그에 캐시하는 §M과 다른 취급).
