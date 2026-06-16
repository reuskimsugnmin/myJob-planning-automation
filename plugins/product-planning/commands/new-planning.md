---
description: 노션 티켓 URL로 새 기획 작업을 시작해 인입→리서치→PRD/SDD까지 자동 진행 (워크플로우 1~5)
argument-hint: <노션-티켓-URL>
---

새 제품 기획 작업을 시작합니다. 대상 티켓: $ARGUMENTS

다음 파이프라인을 **순서대로** 실행하세요. 각 단계 종료 시 핵심 결과를 1~3줄로 보고하고 다음 단계로 이어갑니다.

1. **인입**: `planning-intake` 스킬로 티켓을 파싱하고 워크스페이스 engagement 폴더 + `00-project-brief.md` 생성. 연결 페이지가 탐색 예산을 넘으면 사용자에게 탐색 범위를 확인.
2. **리서치(병렬)**: `domain-study` 와 `tech-research` 스킬을 실행. 둘은 독립적이므로 `research-agent` 서브에이전트로 **병렬** 수행하면 좋습니다. 결과는 `research/domain-study.md`, `research/tech-research.md`.
3. **PRD**: `prd-author` 스킬로 `PRD.md` 작성. 상위 결정 항목은 `⛳DECISION` 으로 옵션·추천만 제시.
4. **SDD**: `sdd-author` 스킬로 `SDD.md` 작성.

## 일시정지 규칙
- 인입 단계에서 **프로젝트 유형(레거시/신규)** 이 불명확하면 멈추고 사용자에게 확인.
- 리서치 단계에서 `.planning/sources.json` 이 없으면 멈추고 소스 등록을 요청.
- PRD/SDD 작성 후 미결 `⛳DECISION` 목록을 모아 사용자에게 제시(사람이 결정할 부분이므로 진행을 강요하지 않음).

## 주의
- 모든 산출물은 **현재 작업 디렉토리**(워크스페이스)의 `engagements/<slug>/` 에 생성합니다. 플러그인 디렉토리에 쓰지 마세요.
- 티켓에 없는 내용을 지어내지 말고, 모든 사실에 출처를 인용합니다.
