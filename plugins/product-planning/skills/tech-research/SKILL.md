---
name: tech-research
description: 이번 신규 제품 개발에 필요한 기술 요건과 구현 문서(공개 웹·API 명세·사내 노션·로컬 파일·라이브러리)를 수집해 정리하고 지식베이스에 적재한다. 기술 리서치, API 명세 파악, 라이브러리/SDK 문서 확인이 필요할 때 사용. research/tech-research.md를 생성한다. (워크플로우 4단계)
---

# Tech Research (요구사항 · 기술 문서 파악 · 오케스트레이션)

워크플로우 4단계. 구현에 필요한 기술 요건·API 명세를 **각 소스 읽기 스킬로 수집 → KB 적재 → 템플릿 종합**한다.
수집 방법(how)은 소스별 스킬에 위임한다(중복 금지). 도메인 스터디와 달리 **신규 개발 기술 요건·API 초점**.

## 선행
- `00-project-brief.md`(요건) · 가능하면 `research/domain-study.md`.
- 소스 레지스트리 `./.planning/sources.json`. 런타임 인자(추가 웹링크/로컬 경로)도 수용.

## 절차

### 1. 수집 (읽기는 각 소스 스킬에 위임)
격리/병렬 이점이 큰 대량 읽기는 `research-agent` 서브에이전트로 위임 가능.
- **웹 / 기술·API 문서**: `web-explore` 스킬을 따른다. 공개 웹링크·public `notion.site` 는 WebFetch, 라이브러리/SDK는 Context7로 최신 검증(`as_of` 기록).
- **사내 노션 기술 페이지**: `notion-explore` 스킬을 따른다(기술 정책/아키텍처 문서).
- **로컬**: `local-source-ingest` 스킬을 따른다. zip 해제·재귀 순회. 단 **도메인이 아니라 신규 개발에 필요한 기술 요건·API 명세** 관점으로 수집.

### 2. 지식베이스 적재
- `knowledge-base` 스킬을 따른다.
  - **내부/파트너 API·연동 스펙** → `tech-registry.yaml`(version+as_of+요건매핑).
  - **서드파티 라이브러리/SDK** → 본문 캐시 금지, `source-manifest.yaml` 에 버전+`as_of` 만(사용 시점 Context7 재검증).

### 3. 종합 → `research/tech-research.md`
- `${CLAUDE_PLUGIN_ROOT}/templates/tech-research.template.md` 를 채운다.
- **요건 ↔ 기술 매핑**(티켓 FR/NFR → 필요한 기술/연동)을 명시. 모든 사실에 출처/검증일 인용.
- 결정 필요 항목은 `⛳DECISION` 후보로 표시(SDD에서 확정).

### 4. 보고
- 핵심 기술 의존성, 가장 큰 구현 리스크, SDD에서 결정할 기술 정책 후보를 요약하고 `prd-author` 를 제안.

## 원칙
- 수집 방법론을 여기에 복붙하지 않는다 — `web-explore`·`notion-explore`·`local-source-ingest`·`knowledge-base` 를 참조.
- 라이브러리 문서는 반드시 Context7/공식 문서로 검증(버전 차이 주의). 출처를 모두 인용하고 불확실한 부분은 명시.
