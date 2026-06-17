---
name: domain-study
description: 이번 기획과 관련된 레거시 제품/서비스 정책과 도메인 지식을 scatter된 자료(노션·Figma·로컬·웹)에서 수집해 지식베이스에 저장하고 한 문서로 종합한다. 도메인 스터디, 레거시 정책 학습, 관련 자료 조사가 필요할 때 사용. research/domain-study.md를 생성한다. (워크플로우 3단계)
---

# Domain Study (레거시 정책 · 도메인 스터디 · 오케스트레이션)

워크플로우 3단계. 흩어진 레거시 자료를 **각 소스 읽기 스킬로 수집 → 지식베이스 적재 → 자립형 문서로 종합**한다.
이 스킬은 오케스트레이션을 담당하고, 수집 방법(how)은 소스별 스킬에 위임한다(중복 금지).

## 선행
- `00-project-brief.md` 가 있어야 한다(없으면 `planning-intake` 먼저). 여기서 프로젝트 유형·목표·**티켓 URL**을 얻는다.
- 소스 레지스트리 `./.planning/sources.json`. 없으면 사용자에게 위치를 묻거나 `${CLAUDE_PLUGIN_ROOT}/config/sources.example.json` 스키마를 안내.

## 절차

### 1. 선행 로드
- `00-project-brief.md`(유형: 레거시 개선/신규, 목표, 티켓 URL)와 `sources.json` 을 읽는다.
- 런타임 인자도 수용: Figma 탐색할 페이지, 추가 로컬 zip/폴더 경로.

### 2. 수집 (읽기는 각 소스 스킬에 위임)
격리/병렬 이점이 큰 대량 읽기는 `research-agent` 서브에이전트로 위임할 수 있다(단, 아래 게이트·Figma 직렬은 메인이 소유).
- **노션**: `notion-explore` 스킬을 따른다. `notion.policy_dbs`/`domain_pages` + **인입 티켓 트리의 레거시 마이닝**(신규 요구사항이 아니라 기존 제품 레거시 정책/기획만 식별).
- **Figma**: `figma-explore` 스킬을 따른다. 탐색할 페이지 미지정 시 **사용자에게 질문**, index-first → 콘텐츠 노드 우선 → **페이지 단위 직렬** → **완료 체크포인트로 남은 작업 확인**.
- **로컬**: `local-source-ingest` 스킬을 따른다. zip 해제·재귀 순회·다중 버전 최신 해소·타입별 읽기.
- **웹**: `web.tech_docs` 중 도메인/정책 관련 링크는 WebFetch.

### 3. 지식베이스 적재
- `knowledge-base` 스킬을 따라 `policy-registry.yaml`/`entity-glossary.md`/`source-manifest.yaml` 을 채운다. dedupe·버전충돌·출처 인용 규칙 준수. 소스 type만 다르고 스키마는 동일.

### 4. 종합 → `research/domain-study.md`
- `${CLAUDE_PLUGIN_ROOT}/templates/domain-study.template.md` 를 채운다.
- **독자 기준**: 도메인을 전혀 모르는 PM/PO/기획자/PD가 **이 문서만 보고도 레거시 제품 서비스를 완벽히 파악**할 수 있게 자립형으로 작성.
- 모든 정책·사실에 출처 인라인 인용(노션 URL / `figma:<file-key>#<node-id>` / 파일 경로). KB 항목 `id` 인용.
- 이번 기획과의 **연결점·영향 범위** 명시. **모순·충돌·빈틈**(버전 충돌 포함) 정리.
- **필수인데 소스로 알 수 없는 항목은 공란 + `추가 확인 필요`**.

### 5. 보고
- 핵심 레거시 정책 N개, 영향 범위, 가장 큰 리스크/빈틈을 요약하고 `tech-research` 를 제안.

## 원칙
- 수집 방법론을 여기에 복붙하지 않는다 — `notion-explore`·`figma-explore`·`local-source-ingest`·`knowledge-base` 를 참조.
- 출처 없는 단정 금지. 자료가 비면 소스 누락을 보고하고 사용자에게 소스 등록을 요청.
- 사용자 확인 게이트(Figma 페이지 선정/완료 체크포인트, 노션 예산 초과)는 메인 컨텍스트에서 수행.
