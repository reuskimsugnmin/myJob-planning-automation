# 콘텐츠 키트: {{PRODUCT_TITLE}}
> 출처: [PRD](../PRD.md) · 작성: {{DATE}} · 담당: {{OWNER}}

> `storyboard-build §3` high-fi **콘텐츠 레인**(F-1). 화면을 "현실적으로" 채우기 위한 도메인 콘텐츠를 출처·성격 태그와 함께 큐레이션한다. `--fidelity high`에서만 사용(기본 `mid`는 빈칸을 ⛳로).

## 사용 규약 (불변식 — 반드시 준수)
- 각 항목에 **`source:`**(근거)와 **`provenance:`**(`spec` | `illustrative`) 태그 필수.
  - **`spec`** = PRD/SDD/policy-table의 사실값(출처 인용). 화면·디스크립션 어디든 사용 가능.
  - **`illustrative`** = 디자인을 살리는 **예시(사실 아님)**. **디자인 레이어 전용** — PRD/SDD 본문·디스크립션 `[데이터]/[수용 기준]`(개발계약)에 **누출 금지**. 디스크립션엔 **"예시값"** 으로 표기(`design-description §4`). → `design-finalize` 누출 검사 대상.
- **채움 우선순위**(storyboard-build §3): ① PRD 사실값(`spec`) ② 없으면 여기 `illustrative` ③ 둘 다 없으면 `⛳`.
- **소셜프루프 수치(평점·구매수)는 항상 `illustrative`** + 화면/주석에 "예시" 맥락(허위 지표 방지).
- 마케팅·머천다이징 카피의 **채택 확정은 사람**(⛳ `decision-checklist` D-n).

## 1. 샘플 데이터셋 (상품·도메인 엔티티)
| 항목 | 예시값 | source | provenance |
|---|---|---|---|
| {{ENTITY}} | {{SAMPLE}} | {{SOURCE}} | spec / illustrative |
<!-- 예: 상품명 "일본 무제한 3일" · 가격 "19,800원" · 통신사 "Softbank" · 속도 "5G" · 기간 "3일" -->

## 2. 소셜프루프 패턴 (항상 illustrative)
| 위치 | 표기 규약 | 예시 | provenance |
|---|---|---|---|
| {{WHERE}} | {{FORMAT}} | {{EXAMPLE}} | illustrative |
<!-- 예: 상품 카드 — ⭐{평점} ({리뷰수}) · 누적 구매 {n}+  →  ⭐4.9 (3,351) · 누적 12만+ -->

## 3. 마이크로카피 (헤드라인·서브·빈상태·에러)
| 슬롯 | 카피 | source | provenance |
|---|---|---|---|
| 헤드라인 | {{HEADLINE}} | ref / illustrative | {{PROV}} |
| 서브카피 | {{SUBCOPY}} | ref / illustrative | {{PROV}} |
| 빈 상태 | {{EMPTY_COPY}} | ref / illustrative | {{PROV}} |
| 에러 | {{ERROR_COPY}} | PRD FR-n / illustrative | {{PROV}} |

## 4. 머천다이징 카피 (채택은 사람 ⛳)
| surface | 카피 | 채택 | provenance |
|---|---|---|---|
| 프로모 배너 | {{PROMO_COPY}} | → D-n | illustrative |
| 크로스셀 | {{CROSS_SELL_COPY}} | → D-n | illustrative |
| 가치제안 | {{VALUE_PROP}} | → D-n | illustrative |
