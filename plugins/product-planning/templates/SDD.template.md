# SDD (Spec Driven Document): {{PRODUCT_TITLE}}

> 버전: draft · 작성: {{DATE}} · 담당: {{OWNER}}
> 연결: [PRD](./PRD.md) · [기술 리서치](./research/tech-research.md)
>
> 표기 규칙: `⛳DECISION` = 기술 정책 등 사람이 결정해야 하는 항목.

## 1. 개요 · PRD 요구사항 매핑
<!-- 각 스펙이 어떤 PRD 요구사항(FR-n)을 충족하는지 추적 -->
| 스펙 | 대응 PRD 요구사항 |
|---|---|
| {{SPEC}} | {{FR}} |

## 2. 기술 정책 · 아키텍처 결정
- ⛳DECISION 기술 정책: {{TECH_POLICY_OPTIONS_AND_RECOMMENDATION}}
- 아키텍처 개요: {{ARCHITECTURE}}

## 3. 데이터 모델 / 엔티티
<!-- ERD는 Phase 3 storyboard에서 Figma로 시각화 -->
| 엔티티 | 주요 필드 | 관계 |
|---|---|---|
| {{ENTITY}} | {{FIELDS}} | {{RELATION}} |

## 4. 핵심 플로우 / 시퀀스
{{SEQUENCE}}

## 5. API / 인터페이스 (해당 시)
| 엔드포인트/이벤트 | 입력 | 출력 | 비고 |
|---|---|---|---|
| {{ENDPOINT}} | {{INPUT}} | {{OUTPUT}} | {{NOTE}} |

## 6. 엣지 케이스 · 에러 처리
- {{EDGE_CASE}}

## 7. 의존 시스템 · 외부 연동
{{INTEGRATION}}

## 8. 비기능 (성능/보안/접근성)
- {{NFR}}

## 9. 오픈 기술 이슈
- {{OPEN_TECH_ISSUE}}

---
### ⛳DECISION 모아보기 (사람 결정 대기)
- [ ] {{DECISION_ITEM}}
