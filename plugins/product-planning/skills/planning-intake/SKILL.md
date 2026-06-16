---
name: planning-intake
description: 노션 기획 티켓을 인입해 파싱하고 글로벌 빅테크 킥오프 수준의 프로젝트 브리프를 만든다. 노션 티켓 URL/ID가 주어지거나 새 기획 업무를 시작할 때 사용. 티켓 본문·properties·연결된 상위/하위/관련 페이지·코멘트를 탐색해 워크스페이스에 engagement 폴더와 00-project-brief.md를 생성한다. (워크플로우 1~2단계)
---

# Planning Intake (티켓 인입 · 요건 파악 · 킥오프 브리프)

워크플로우 1~2단계. 노션 티켓을 트리째 탐색해 **하나의 킥오프 프로젝트 브리프**(`00-project-brief.md`)로 종합한다.

## 입력
- 노션 티켓 URL 또는 ID. 없으면 사용자에게 요청한다.

## 절차

### 1. URL 정규화 & fetch
- 받은 값을 그대로 `notion-fetch`(`include_discussions: true`)에 전달한다. `app.notion.com/p/<id>?v=...&source=...` 형식도 그대로 동작한다.
- 실패하면 URL에서 **32자리 hex ID**(마지막 경로 세그먼트, 쿼리·대시 제거)를 추출해 ID로 재시도한다.

### 2. 엔티티 타입 판별
- 결과 `metadata.type` 확인: `page`면 진행. `database`/data source(`collection://`)면 단일 티켓이 아니므로, 어떤 엔트리를 인입할지 사용자에게 확인하거나 `notion-search`로 좁힌다.
- DB 엔트리 페이지는 `<properties>`와 `<ancestor-path>`를 가진다.

### 3. 메타·요건·링크 추출 (티켓에 없는 건 지어내지 않음)
- **properties**: 업무번호·제목·진행상태·진행률·우선순위(MoSCoW)·계획일정·태그·이슈 히스토리, 담당자/참조자(mention-user), relation(연결 페이지 URL들), 첨부파일(file://), 외부 URL.
- **ancestor-path**: 상위 위치(맥락).
- **content**: 핵심 요구사항/개발 항목(번호 항목 원문 충실), 서비스 정책/플로우, 본문 내 Figma·외부 링크.

### 4. 담당자 resolve
- 추출한 `user://` ID를 모아 `notion-get-users`로 실명·역할을 일괄 resolve(중복 제거). 실패한 ID는 ID 그대로 두고 표기.

### 5. 코멘트/의사결정 추출
- fetch의 `<page-discussions>`에 discussion이 있으면 `notion-get-comments`로 스레드를 가져온다(미해결 우선). 미해결 질문·결정 사항을 `⛳DECISION` 후보로 정리.

### 6. 링크 인벤토리 분류
- 추출한 링크를 분류: 상위(ancestor) / 하위 일감 / 기타 relation / Figma / 첨부 / 외부.

### 7. 우선순위 + 예산 기반 탐색
- **자동 탐색**: ancestor 1-hop + 핵심 relation(하위 일감·프로덕트·업무구분·주요 이슈·회의록 일부). 각 페이지를 `notion-fetch`로 읽어 1줄 요약.
- **예산 상한 N≈8~10페이지**. 연결 페이지가 상한을 넘으면, 전체 목록을 제시하고 **어디까지 탐색할지 사용자에게 확인**한다(무단으로 전부 펼치지 않는다).
- **대량 탐색은 `research-agent` 서브에이전트에 위임**(URL 묶음 → digest 반환). 메인 컨텍스트 오염 방지(§8 원칙). 종합·파일작성은 이 스킬이 한다.

### 8. 폴더 생성 (CWD = 워크스페이스)
- slug: `<YYYY-MM>-<업무번호-소문자>-<제목-kebab>` (예: `2026-06-atm-63-taxi-reservation`). 업무번호 없으면 제목 기반.
- 생성: `engagements/<slug>/` 와 하위 `research/`.

### 9. 브리프 작성
- `${CLAUDE_PLUGIN_ROOT}/templates/project-brief.template.md`를 읽어 `engagements/<slug>/00-project-brief.md`로 채운다.
- 모든 사실에 출처 인용. 티켓에서 알 수 없는 항목은 `미상 — 추가 확인 필요`. 프로젝트 유형(레거시/신규) 판정(불명확하면 사용자 확인).

### 10. 보고
- slug·프로젝트 유형·핵심 요건 3줄·미해결 의사결정·미상 항목·탐색한 연결 페이지 수를 보고하고, 다음 단계(`domain-study`)를 제안.

## 원칙
- 티켓·연결 페이지에 없는 내용을 지어내지 않는다. 모르는 것은 `미상`.
- 산출물은 **항상 현재 작업 디렉토리(워크스페이스)** 에 쓴다. 플러그인 디렉토리에 쓰지 않는다.
- 예산을 넘는 대량 탐색은 사용자 확인 후 진행.
