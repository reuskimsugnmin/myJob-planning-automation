# SDD (Spec Driven Document): {{PRODUCT_TITLE}}

> 버전: draft · 작성: {{DATE}} · 담당: {{OWNER}}
> 연결: [PRD](./PRD.md) · [기술 리서치](./research/tech-research.md) · 지식베이스 `.planning/knowledge-base/`
>
> 표기 규칙: `추가 기획 필요 → D-n` = 미결 기술 결정(하단 체크리스트). 기술 사실은 tech-research/KB tech-registry 근거 + 출처.
> 작성 조건: PRD 게이트에서 SDD 필요로 확인된 큰/복잡 프로젝트. AI 파싱 + 사람 완결 구조 유지.

## 1. 개요 · PRD 요구사항 매핑
<!-- 각 스펙이 어떤 PRD 요구사항(FR-n/US-n)을 충족하는지 추적. 누락 없도록 검증 -->
| 스펙 ID | 스펙 | 대응 PRD (FR/US) |
|---|---|---|
| SP-1 | {{SPEC}} | {{FR}} |

## 2. 기술 정책 · 아키텍처 결정
- 아키텍처 개요: {{ARCHITECTURE}}
- 기술 정책 미결: 추가 기획 필요 → D-n (임시: {{TENTATIVE}})

## 3. 데이터 모델 / 엔티티
<!-- ERD는 Phase 3 storyboard에서 Figma로 시각화 -->
| 엔티티 | 주요 필드 | 관계 | 대응 FR |
|---|---|---|---|
| {{ENTITY}} | {{FIELDS}} | {{RELATION}} | {{FR}} |

## 4. 핵심 플로우 / 시퀀스
{{SEQUENCE}}

## 5. API / 인터페이스 (해당 시)
<!-- KB tech-registry 의 내부/파트너 API와 일치. 라이브러리는 확정 전 Context7 재검증 -->
| 엔드포인트/이벤트 | 입력 | 출력 | 인증/제약 | 출처 |
|---|---|---|---|---|
| {{ENDPOINT}} | {{INPUT}} | {{OUTPUT}} | {{AUTH}} | {{SOURCE}} |

## 6. 엣지 케이스 · 에러 처리
- {{EDGE_CASE}}

## 7. 의존 시스템 · 외부 연동
{{INTEGRATION}}

## 8. 비기능 (성능/보안/접근성)
- {{NFR}}

---
## 9. 의사결정 체크리스트 (기술)
<!-- decision-checklist 스킬 스키마. 영역=기술요건 중심 -->
| ID | 결정 필요 항목 | 영역 | 추천안(트레이드오프) | 임시 채택안 | 결정 | 최종 결정안 | 영향 범위 |
|---|---|---|---|---|---|---|---|
| D-1 | {{TECH_DECISION_ITEM}} | 기술요건 | A) … · B) … · C) … | {{TENTATIVE}} | ☐ | (미정) | {{IMPACT}} |
