# 디자인 정책 테이블: {{PRODUCT_TITLE}}
> 출처: [PRD](../PRD.md){{SDD_LINK}} · 작성: {{DATE}} · 담당: {{OWNER}}
> 모드: {{MODE}} <!-- A 운영(in-place) / B 백지 구축 / 혼합(화면별) -->
> 대상 Figma: {{FIGMA_FILE_URL}}

> `storyboard-build` 1단계 산출물. PRD/SDD에서 도출한 화면 목록과 화면별 정책. 모든 항목에 출처(`PRD FR-n`/`US-n`/노션/Figma)를 인용한다.

## 플로우 · 화면 인벤토리 (§0 게이트 산출물)
> end-to-end 흐름. 화면 목록은 여기서 도출된 인벤토리를 그대로 따른다. 흐름도는 `flow.md`(FigJam) 참조.

**흐름**: {{FLOW_ONELINE}} <!-- 예: 진입 → 상품선택 → 금액·기간 → 약관동의 → 본인인증 → 처리중 → 완료 (실패 시 → 에러) -->

| 단계 | 화면 ID | 전이(조건) | 다음/분기 | 출처 |
|---|---|---|---|---|
| {{STEP}} | {{SCREEN_ID}} | {{TRANSITION}} | {{NEXT}} | {{SOURCE}} |

**완전성 체크리스트** (누락은 화면으로 추가):
- [ ] 진입/리스트  [ ] 각 기능 단계  [ ] 처리중/로딩  [ ] 실패/에러 분기  [ ] 완료/결과  [ ] 빈 상태  [ ] 권한·본인인증·약관상세

## 화면 목록

| 화면 ID | 화면명 | 설명 | 모드 | 유사 화면(clone 소스) | 처리 | 출처 |
|---|---|---|---|---|---|---|
| {{SCREEN_ID}} | {{SCREEN_NAME}} | {{SCREEN_DESC}} | A/B | {{SIMILAR_TO}} | add/update/skip | {{SOURCE}} |

## 화면별 정책

### {{SCREEN_ID}} {{SCREEN_NAME}}
- **핵심 맥락**: {{CONTEXT}} <!-- 사용자가 여기서 가장 먼저 확인·판단·실행하는 값 -->
- **주요 요소/콘텐츠**: {{KEY_ELEMENTS}}
- **노출 조건**: {{VISIBILITY_CONDITIONS}} <!-- [필드]=[값] -->
- **플랫폼 분기**: {{PLATFORM_BRANCHES}} <!-- 정식 명칭, project-brief 도메인 용어 -->
- **에러 케이스**: {{ERROR_CASES}}
- **상태/전이**: {{STATES}} <!-- Default 상태·활성 조건 등 -->
- **출처**: {{SOURCE}} <!-- PRD FR-n / US-n -->
- {{DECISION_MARKER}} <!-- ⛳DECISION: 전략적 UX 배치는 옵션·추천만 -->

## TO-BE 변경 요약 (모드 A — 기존 화면 반영분)

| 화면 ID | 변경 종류 | 변경 내용(항목·이미지·값·노출) | 출처 |
|---|---|---|---|
| {{SCREEN_ID}} | 텍스트/컴포넌트/노출 | {{CHANGE_DETAIL}} | {{SOURCE}} |
