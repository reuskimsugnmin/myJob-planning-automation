# PRD: {{PRODUCT_TITLE}}

> 버전: draft · 작성: {{DATE}} · 담당: {{OWNER}}
> 연결: [프로젝트 브리프](./00-project-brief.md) · [도메인/레퍼런스 리서치](./research/) · [기술 리서치](./research/tech-research.md)
>
> 표기 규칙: `추가 기획 필요 → D-n` = 아직 결정 안 된 항목(하단 의사결정 체크리스트 참조, 임시 채택안으로 초안 진행). 모든 사실은 출처 인용.
> 독자: ① 사람(이 문서만으로 제품 기획 100% 파악) ② AI 에이전트(안정적 ID·구조화 필드로 디자인/스토리보드 자동화의 입력).

---
# Part A — 원페이저 요약 (1화면 스캔)

## A1. 문제 · 배경 (왜 지금)
{{PROBLEM_AND_WHY_NOW}}

## A2. 목표 · 비목표
- 목표: {{GOAL}}
- 비목표(Non-goals): {{NON_GOAL}}

## A3. 성공 지표 (측정 가능)
- {{METRIC}}

## A4. 타겟 사용자 · 핵심 시나리오
- 타겟: {{TARGET}}
- 핵심 시나리오: {{SCENARIO}}

## A5. 제품 핵심 밸류 · 차별성
- 핵심 밸류: {{VALUE}}
- 차별성: {{DIFFERENTIATION}}

## A6. 핵심 의사결정 요약
<!-- 하단 체크리스트의 미결 핵심 항목 포인터 -->
- {{KEY_DECISION_POINTER}} (→ D-n)

---
# Part B — 상세 요구사항 (사람 완결 + AI 파싱)

## B1. 유저 스토리
| ID | As a (역할) | I want (목표) | So that (가치) | 우선순위 | 출처 |
|---|---|---|---|---|---|
| US-1 | {{ROLE}} | {{WANT}} | {{BENEFIT}} | P0/P1/P2 | {{SOURCE}} |

## B2. 기능 명세 (Functional Requirements)
<!-- 각 FR: 수용기준(Given/When/Then) + 다운스트림 파싱 필드(관련 화면/엔티티/플로우) -->
### FR-1 {{REQUIREMENT_NAME}}
- 설명: {{DESC}}
- 우선순위: P0/P1/P2 · 대응 유저스토리: US-n · 출처: {{SOURCE}}
- 수용 기준:
  - Given {{CONTEXT}}, When {{ACTION}}, Then {{OUTCOME}}
- 관련 화면: {{SCREENS}} · 관련 엔티티: {{ENTITIES}} · 관련 플로우: {{FLOWS}}

## B3. 비기능 요구사항 (NFR)
| ID | 항목(성능/보안/접근성/규정) | 기준 | 출처 |
|---|---|---|---|
| NFR-1 | {{NFR}} | {{CRITERIA}} | {{SOURCE}} |

## B4. 주요 서비스 정책
- (확정) {{POLICY}} — 출처
- 추가 기획 필요 → D-n (임시: {{TENTATIVE}})

## B5. UX 흐름 · 화면 구성 (개략 — 디자인 단계 입력)
<!-- 화면 목록·전환·상태. low/mid-fi 디자인·스토리보드 자동화가 읽는다 -->
{{UX_FLOW}}

## B6. 의존성 · 제약 (기술 리서치 연계)
{{DEPENDENCY}}

---
# Part C — 의사결정 체크리스트 & 운영

## C1. 의사결정 체크리스트
<!-- decision-checklist 스킬 스키마. 추천안·임시채택안 컬럼은 최종 결정 후에도 보존 -->
| ID | 결정 필요 항목 | 영역 | 추천안(트레이드오프) | 임시 채택안 | 결정 | 최종 결정안 | 영향 범위 |
|---|---|---|---|---|---|---|---|
| D-1 | {{DECISION_ITEM}} | 서비스정책/기획요건/기술요건 | A) … · B) … · C) … | {{TENTATIVE}} | ☐ | (미정) | {{IMPACT}} |

## C2. 마일스톤 · 오픈 이슈
- 오픈 이슈: {{OPEN_ISSUE}}

## C3. SDD 필요 여부 (판단 결과)
- 권장: {{SDD_RECOMMENDATION}} · 이유: {{SDD_REASON}}
