<!--
디스크립션 annotation 슬롯 포맷 (design-description 스킬 §4).
Figma 의 각 annotation-frame 본문(Lorem ipsum 슬롯)에 들어가는 텍스트 형식 예시.
정수 뱃지 N = annotation-frame N. 제목(Section Title) = 뱃지가 가리키는 요소명.
실제 작성은 Figma 노드에 쓰며, 이 파일은 포맷 레퍼런스 + 백업용 마크다운이다.
-->

# {{SCREEN_ID}} {{SCREEN_NAME}} — 디스크립션
> 대상 Figma: {{FIGMA_SCREEN_URL}} · 작성: {{DATE}}

## 뱃지별 annotation

### {{BADGE_N}}. {{ELEMENT_NAME}}
{{ROLE_SENTENCE}} <!-- 첫 줄: 요소 역할 1문장, 라벨 없이. Figma 노드/컴포넌트 이름 금지 -->

- [노출 조건]
  - {{CONDITION}} <!-- [필드]=[값] -->
- [Default 상태] <!-- 인터랙티브 컴포넌트 필수: 상시 Enabled / Disabled→조건 충족 시 Enabled -->
  - Default: {{DEFAULT_STATE}}
- [플랫폼 분기]
  - {{PLATFORM_BRANCH}}
- [Action]
  - {{ACTION}} <!-- 트리거→결과→영향 컴포넌트 상태 변화 -->
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

## claim↔노드 대조표 (동기화 완료 증거 — 0건도 필수)

| 뱃지 | claim(노출/상태/텍스트) | 노드 ID | 실제값(visible/variant/characters) | 일치 |
|---|---|---|---|---|
| {{BADGE_N}} | {{CLAIM}} | {{NODE_ID}} | {{ACTUAL}} | ✓/✗ |

## 검증 결과
- 개수: annotation-frame {{FRAME_COUNT}} == 정수 뱃지 {{BADGE_COUNT}} {{COUNT_OK}}
- 의미: edge-최근접 요소 == 제목 (스크린샷 교차검증) {{MEANING_OK}}
- SKIP 항목: {{SKIP_ITEMS}} <!-- SKIP: [이유] · 사용자 확인 필요 -->
