---
name: domain-study
description: 이번 기획과 관련된 레거시 제품/서비스 정책과 도메인 지식을 scatter된 자료(노션·Figma·로컬·웹)에서 수집해 종합한다. 도메인 스터디, 레거시 정책 학습, 관련 자료 조사가 필요할 때 사용. research/domain-study.md를 생성한다. (워크플로우 3단계)
---

# Domain Study (레거시 정책 · 도메인 스터디)

워크플로우 3단계. 흩어진 레거시 제품 정책과 도메인 자료를 모아 한 문서로 종합한다.

## 선행
- `00-project-brief.md` 가 있어야 한다(없으면 `planning-intake` 먼저).
- 소스 레지스트리: 현재 디렉토리 `./.planning/sources.json`. 없으면 사용자에게 위치를 묻거나 `${CLAUDE_PLUGIN_ROOT}/config/sources.example.json` 스키마를 안내한다.

## 절차

1. **소스 로드**: `.planning/sources.json` 의 `notion`, `figma`, `local`, `web` 항목을 읽는다.

2. **수집** (가능하면 `research-agent` 서브에이전트로 병렬화):
   - **Notion**: `policy_dbs` / `domain_pages` 를 `notion-fetch`, 티켓 키워드로 `notion-search`.
   - **Figma**: 프로젝트 유형이 *레거시 개선*이면 `legacy_files`, *신규*이면 `reference_files` 를 `get_metadata` → `get_design_context`/`get_screenshot` 으로 읽어 화면·플로우 파악.
   - **Local**: `local.doc_dirs` 를 Glob/Grep/Read 로 탐색. `./engagements` 가 포함되면 **과거 산출물을 추가 레거시 소스로 재학습**.
   - **Web**: `web.tech_docs` 중 도메인/정책 관련 링크는 WebFetch.

3. **종합**: `${CLAUDE_PLUGIN_ROOT}/templates/domain-study.template.md` 를 채워 `research/domain-study.md` 작성.
   - 모든 정책·사실에 **출처를 인라인 인용**(노션 URL / Figma 노드 / 파일 경로).
   - 이번 기획과의 **연결점·영향 범위**를 명시.
   - 발견한 **모순·빈틈·리스크**를 별도 정리.

4. **보고**: 핵심 레거시 정책 N개, 영향 범위, 가장 큰 리스크/빈틈을 요약하고 `tech-research` 를 제안.

## 원칙
- 출처 없는 단정 금지. 추정은 "추정"으로 명시.
- 자료가 비면 그 사실(소스 누락)을 보고하고 사용자에게 소스 등록을 요청.
