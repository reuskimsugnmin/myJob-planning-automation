# 도메인 스터디: {{TICKET_TITLE}}

> 생성: {{DATE}} · 소스: sources.json + 티켓 연결 자료 · 지식베이스: `.planning/knowledge-base/`
> 목적: **이 도메인을 전혀 모르는 PM/PO/서비스 기획자/PD가 이 문서만 보고도 레거시 제품 서비스가 어떻게 기획되어 있는지 완벽히 파악**할 수 있게 한다.
> 규칙: 모든 사실에 출처 인용. 제품 기획에 반드시 알아야 하나 소스로 알 수 없는 항목은 공란으로 두고 **`추가 확인 필요`** 로 표시.

## 1. 한눈에 보기
<!-- 이 제품/서비스가 무엇이고, 무엇을 위해 존재하며, 누가 쓰는가 -->
- 제품/서비스: {{PRODUCT_SUMMARY}}
- 비즈니스 목적/가치: {{BUSINESS_PURPOSE}}
- 주요 액터(사용자/역할): {{ACTORS}}

## 2. 시스템 / 서비스 구성
<!-- 구성요소와 외부 연동 시스템(연동 규격 반영). 상세 기술은 tech-research로 -->
{{SYSTEM_COMPOSITION}}

### 외부 연동 시스템
| 연동 대상 | 역할/용도 | 인터페이스(개요) | 출처 |
|---|---|---|---|
| {{PARTNER}} | {{ROLE}} | {{INTERFACE}} | {{SOURCE}} |

## 3. 핵심 도메인 엔티티 · 데이터 모델
<!-- 엔티티와 관계. KB entity-glossary 인용 -->
{{ENTITY_MODEL}}

## 4. 레거시 서비스 정책 상세
<!-- KB policy-registry 기반. 각 정책 출처 인용 -->
| 정책 | 조건 | 예외 | 현재 동작(AS-IS) | 출처 |
|---|---|---|---|---|
| {{POLICY}} | {{CONDITIONS}} | {{EXCEPTIONS}} | {{CURRENT_BEHAVIOR}} | {{SOURCE}} |

## 5. 주요 사용자 플로우 (레거시)
<!-- Figma 화면/플로우차트 근거. figma:<file-key>#<node-id> 인용 -->
{{LEGACY_FLOW}}

## 6. 외부 연동 / 기술 규격 요약
<!-- 연동 규격 문서 요지. 상세 구현은 tech-research에서 -->
{{TECH_SPEC_SUMMARY}}

## 7. 용어집
| 용어 | 정의 | 비고 | 출처 |
|---|---|---|---|
| {{TERM}} | {{DEFINITION}} | {{NOTE}} | {{SOURCE}} |

## 8. 이번 기획과의 연결점 · 영향 범위
<!-- 어떤 레거시 정책/화면이 이번 작업으로 영향받는가 -->
{{IMPACT}}

## 9. 발견된 모순 · 충돌 · 빈틈 · 리스크
<!-- 버전 충돌, 소스 간 모순 포함 -->
- {{GAP}}

## 10. ⚠️ 추가 확인 필요
<!-- 제품 기획에 반드시 필요하나 학습한 소스만으로 알 수 없는 항목 -->
- {{NEEDS_CONFIRMATION}}

## 11. 출처 · 지식베이스
- 지식베이스: `.planning/knowledge-base/` (policy-registry / entity-glossary / source-manifest)
- 출처 목록: {{SOURCE_CITATION}}
