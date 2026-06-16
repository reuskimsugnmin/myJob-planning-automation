# 프로젝트 브리프: {{TITLE}} ({{TASK_NO}})

> 출처 티켓: {{SOURCE_TICKET_URL}}
> 인입일: {{DATE}} · 담당(PM/PD): {{OWNER}} · 상태: intake 완료
> 프로젝트 유형: {{PROJECT_TYPE}} <!-- 레거시 개선 / 신규 기능·화면 -->
>
> 표기 규칙: 티켓에서 확인 불가한 항목은 `미상 — 추가 확인 필요`. 모든 사실은 출처(노션 URL/페이지) 인용. 사람이 결정할 항목은 `⛳DECISION`.

## 0. 티켓 메타 (원문 충실)
- 업무번호: {{TASK_NO}}
- 제목: {{TITLE}}
- 진행 상태 / 진행률: {{STATUS}}
- 우선순위(MoSCoW 등): {{PRIORITY}}
- 계획 일정: {{PLANNED_DATE}}
- 태그: {{TAGS}}
- 상위 위치(ancestor): {{ANCESTOR_PATH}}

### 이해관계자 (mention → 실명 resolve)
| 역할 | 이름 | 비고 |
| --- | --- | --- |
| 사업부 담당자 | {{BIZ_OWNER}} | |
| IT 실무 담당자 | {{IT_OWNER}} | |
| 참조자 | {{CC}} | |

## 1. 한 줄 요약 & 배경
{{ONE_LINER}}

{{BACKGROUND}}

## 2. 목표 & 성공지표
- 목표: {{GOAL}}
- 성공지표: {{METRIC}} <!-- 티켓에 없으면 미상 -->

## 3. 범위 / 비범위
- 범위: {{IN_SCOPE}}
- 비범위: {{OUT_OF_SCOPE}}

## 4. 핵심 요구사항 / 개발 항목 (원문 충실)
<!-- 티켓에 명시된 개발 항목을 번호·원문 그대로 구조화. 추측 금지. -->
1. {{REQUIREMENT}}

## 5. 주요 일정 · 마일스톤
| 일정 | 마일스톤 | 출처 |
| --- | --- | --- |
| {{DATE}} | {{MILESTONE}} | {{SOURCE}} |

## 6. 관련 서비스 정책 요약
<!-- 티켓 본문에 포함된 정책/플로우 발췌 요약 (출처 인용) -->
{{POLICY_SUMMARY}}

## 7. 의존성 · 외부 연동
<!-- 벤더/유관부서/외부 시스템 (예: 파트너사, 사내 타팀) -->
- {{DEPENDENCY}}

## 8. 리스크 · 이슈 히스토리
- {{RISK_OR_ISSUE}}

## 9. 미해결 의사결정 (사람 결정 대기)
<!-- discussion/코멘트에서 추출한 미해결 질문·결정 사항 → ⛳DECISION 후보 -->
- [ ] ⛳DECISION {{DECISION_ITEM}} [출처: {{SOURCE}}]

## 10. 관련 자료 인덱스 (링크 맵)
### 노션 연결 페이지
| 분류 | 제목 | URL | 1줄 요약 |
| --- | --- | --- | --- |
| 상위(ancestor) | {{TITLE}} | {{URL}} | {{SUMMARY}} |
| 하위 일감 | {{TITLE}} | {{URL}} | {{SUMMARY}} |
| relation | {{TITLE}} | {{URL}} | {{SUMMARY}} |

### Figma / 첨부 / 외부 링크
- Figma: {{FIGMA_URL}}
- 첨부파일: {{ATTACHMENT_NAME}} <!-- 바이너리(xlsx/pdf 등)는 인덱스만, 필요 시 수동 확인 -->
- 외부: {{EXTERNAL_URL}}

## 11. 미상 · 추가 확인 필요
- [ ] {{UNKNOWN_ITEM}}
