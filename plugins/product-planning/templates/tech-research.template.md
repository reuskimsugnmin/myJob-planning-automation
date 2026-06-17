# 기술 리서치: {{TICKET_TITLE}}

> 생성: {{DATE}} · 소스: sources.json(web/notion/local) + Context7 · 지식베이스: `.planning/knowledge-base/`
> 목적: 이번 **신규 제품 개발**에 필요한 기술 요건·API 명세를 정리해, PRD/SDD가 **원문 재페치 없이** 바로 가져다 쓰게 한다.
> 규칙: 모든 사실에 출처 인용. 라이브러리/SDK는 Context7 검증일(`as_of`) 명기. 미상 필수항목은 `추가 확인 필요`.

## 1. 요건 ↔ 기술 매핑
<!-- 티켓 FR/NFR → 충족에 필요한 기술/연동. 출처 인용 -->
| 요건(FR/NFR) | 필요한 기술/연동 | 비고 | 출처 |
|---|---|---|---|
| {{REQ}} | {{TECH}} | {{NOTE}} | {{SOURCE}} |

## 2. 외부 API · 연동 스펙
<!-- KB tech-registry 와 일치. 각 항목 출처 인용 -->
| 대상 | base URL | 인증 | 핵심 endpoint / 파라미터 | rate limit / 에러 | 데이터 포맷 | 출처 |
|---|---|---|---|---|---|---|
| {{API}} | {{BASE_URL}} | {{AUTH}} | {{ENDPOINTS}} | {{LIMITS}} | {{FORMATS}} | {{SOURCE}} |

## 3. 기술 스택 · 라이브러리
<!-- 서드파티 라이브러리는 KB에 캐시하지 않음. 버전+Context7 검증일(as_of) 명기 -->
| 라이브러리/SDK | 버전 | 핵심 API/용도 | Context7 검증일(as_of) | 출처 |
|---|---|---|---|---|
| {{LIB}} | {{VERSION}} | {{USAGE}} | {{AS_OF}} | {{SOURCE}} |

## 4. 제약 · 의존성 · 통합 지점
{{CONSTRAINTS}}

## 5. 구현 리스크 · 미해결 기술 질문
<!-- SDD의 ⛳DECISION 후보 -->
- {{RISK_OR_DECISION}}

## 6. 출처 · 지식베이스
- 지식베이스: `.planning/knowledge-base/` (tech-registry / source-manifest)
- 출처 목록: {{SOURCE_CITATION}}
