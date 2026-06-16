---
name: tech-research
description: 배정된 기획에 필요한 요구사항과 기술 구현 관련 문서를 파악한다. 기술 리서치, 기술 문서 조사, 라이브러리/API 문서 확인이 필요할 때 사용. 노션·웹링크·로컬파일·Context7에서 수집해 research/tech-research.md를 생성한다. (워크플로우 4단계)
---

# Tech Research (요구사항 · 기술 문서 파악)

워크플로우 4단계. 구현에 필요한 기술 요구사항과 문서를 모아 정리한다.

## 선행
- `00-ticket.md` (요건) · 가능하면 `research/domain-study.md`.
- 소스 레지스트리 `./.planning/sources.json`.

## 절차

1. **수집** (`research-agent` 로 병렬화 가능):
   - **Web 기술문서**: `sources.json` 의 `web.tech_docs` 및 티켓/도메인 스터디에 등장한 기술 링크를 WebFetch.
   - **라이브러리/프레임워크 공식 문서**: 특정 라이브러리·SDK·API가 관련되면 Context7 MCP `resolve-library-id` → `query-docs` 로 **최신** 문서 확인(기억에 의존 금지).
   - **Notion 기술 페이지**: 사내 기술 정책/아키텍처 문서를 `notion-search`/`notion-fetch`.
   - **Local**: `local.doc_dirs` 의 기술 문서를 Grep/Read.

2. **정리**: `${CLAUDE_PLUGIN_ROOT}/templates/` 에 별도 tech 템플릿이 없으므로 `research/tech-research.md` 를 다음 구조로 작성:
   - 기술 요구사항(기능/비기능) — 티켓 요건과 매핑
   - 관련 기술 스택·라이브러리(버전·핵심 API) — **출처 인용**
   - 제약·의존성·통합 지점
   - 구현 리스크·미해결 기술 질문(SDD의 `⛳DECISION` 후보)

3. **보고**: 핵심 기술 의존성, 가장 큰 구현 리스크, SDD에서 결정해야 할 기술 정책 후보를 요약하고 `prd-author` 를 제안.

## 원칙
- 라이브러리 문서는 반드시 Context7/공식 문서로 검증(버전 차이 주의).
- 출처를 모두 인용하고, 불확실한 부분은 명시.
