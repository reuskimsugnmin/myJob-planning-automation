# 디자인 정책 테이블: {{PRODUCT_TITLE}}
> 출처: [PRD](../PRD.md){{SDD_LINK}} · 작성: {{DATE}} · 담당: {{OWNER}}
> 모드: {{MODE}} <!-- A 운영(in-place) / B 백지 구축 / 혼합(화면별) -->
> 대상 Figma: {{FIGMA_FILE_URL}}

> `storyboard-build` 1단계 산출물. PRD/SDD에서 도출한 화면 목록과 화면별 정책. 모든 항목에 출처(`PRD FR-n`/`US-n`/노션/Figma)를 인용한다.

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
