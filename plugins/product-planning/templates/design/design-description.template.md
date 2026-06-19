<!--
디스크립션 annotation 슬롯 포맷 (design-description 스킬 §4) — 정본(badge-matching) 기준.
Figma 구조: `Description` 프레임 > `annotation-frame` × N.
각 annotation-frame = 텍스트 3개(노드명 고정): "1"=뱃지 번호 · "Section Title.."=제목(요소명) · "Lorem ipsum..."=본문.
정수 뱃지 N = annotation-frame N. 제목 = 뱃지가 가리키는 요소명. 본문 = 역할 문장 + [대괄호] 섹션.
실제 작성은 Figma 노드에 쓰며, 이 파일은 포맷 레퍼런스 + 백업 마크다운이다.
-->

# {{SCREEN_ID}} {{SCREEN_NAME}} — 디스크립션
> 대상 Figma: {{FIGMA_SCREEN_URL}} · 작성: {{DATE}}

## 뱃지별 annotation
> 제목 = 요소명. 본문 = (a) 역할 문장(라벨 없이) + (b) 해당하는 [대괄호] 섹션만. 인터랙티브는 `[Default 상태]` 필수.
> 상세 레벨: **`--dev-detailed`(기본)** = 개발 착수용으로 아래 "개발자 상세 추가 섹션"까지 모두 채운다(스킬 §4-D). **`--standard`** = 간략(의도 중심, 개발자 상세 추가 섹션 생략).

### {{BADGE_N}}. {{ELEMENT_NAME}}
{{ROLE_SENTENCE}} <!-- 첫 줄: 요소 역할 1문장, 라벨 없이. Figma 노드/컴포넌트 이름 금지 -->
- [노출 조건]
  - {{CONDITION}} <!-- [필드]=[값] -->
- [Default 상태] <!-- 인터랙티브 컴포넌트 필수: 상시 Enabled / Disabled→조건 충족 시 Enabled -->
  - Default: {{DEFAULT_STATE}}
- [컴포넌트 상태]
  - {{STATE_TRANSITION}} <!-- [상태]: [조건] → [다음 상태] -->
- [플랫폼 분기]
  - {{PLATFORM_BRANCH}}
- [Action]
  - {{ACTION}} <!-- 트리거→결과→영향 -->
- [Validation]
  - {{VALIDATION}}
- [에러 케이스]
  - {{ERROR_CASE}}
- [세부] <!-- 서브 뱃지 -->
  - ({{SUB_BADGE}}) {{SUB_ELEMENT}}: {{SUB_DESC}}
- [플로우] <!-- CONNECTOR 있을 때 -->
  - {{FLOW}}
- [미노출 항목]
  - {{HIDDEN_ITEM}}: {{HIDDEN_REASON}}

<!-- ▼ --dev-detailed 모드: 개발 착수용 추가 섹션 (표준 모드에선 생략). 해당하는 것만. -->
- [상태] <!-- 모든 상태 + 전이 트리거 -->
  - {{STATE}}: {{TRIGGER_OR_DESC}} <!-- 예: Focus: 키패드 노출 / Error: 응답 실패 시 인라인 배너 -->
- [데이터] <!-- 동적 값 명세 -->
  - {{FIELD}}: {{TYPE}}, 출처 {{SOURCE}}, {{RANGE_FORMAT}}, 기본 {{DEFAULT}} <!-- 예: amount: number, 1만~300만, 천단위 콤마 -->
- [인터랙션] <!-- 제스처 → 결과 + 이동화면 + 전달 파라미터 -->
  - {{GESTURE}} → {{RESULT}} (params: {{PARAMS}})
- [연동] <!-- 계약 상세는 SDD 링크, 여기엔 흐름·분기만 -->
  - {{ENDPOINT_OR_FLOW}} → 성공 {{ON_SUCCESS}} / 실패 {{ON_FAIL}} (SDD §{{REF}})
- [엣지/예외]
  - {{EDGE_CASE}} <!-- empty·네트워크오류·타임아웃·권한거부·overflow·긴 텍스트 -->
- [수용 기준] <!-- Given/When/Then, PRD US 연결 -->
  - {{ACCEPTANCE}} ({{US_REF}})
<!-- 안 정해진 값은 지어내지 말고 [미확정]에. 데이터 계약·API 스펙은 SDD로(여기엔 링크만). -->

<!-- 짧은 단일 요소는 (a) 역할 문장만으로 충분(대괄호 섹션 없이 평문 1~2문장 허용). -->

## claim↔노드 대조표 (동기화 완료 증거 — 0건도 필수)

| 뱃지 | claim(노출/상태/텍스트) | 노드 ID | 실제값(visible/variant/characters) | 일치 |
|---|---|---|---|---|
| {{BADGE_N}} | {{CLAIM}} | {{NODE_ID}} | {{ACTUAL}} | ✓/✗ |

## 검증 결과
- 개수: annotation-frame {{FRAME_COUNT}} == 정수 뱃지 {{BADGE_COUNT}} {{COUNT_OK}}
- 의미: edge-최근접 요소 == 제목 (스크린샷 교차검증) {{MEANING_OK}}
- SKIP 항목: {{SKIP_ITEMS}}
