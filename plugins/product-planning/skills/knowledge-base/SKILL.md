---
name: knowledge-base
description: 레거시 제품 서비스의 정책·도메인 지식을 출처별로 누적 저장하는 파일 기반 지식베이스(KB)의 스키마와 적재 방법론. 노션·Figma·로컬 어떤 소스에서 파악했든 동일 스키마로 저장한다. domain-study·tech-research와 각 소스 읽기 스킬(notion/figma/local-explore)이 호출한다.
---

# Knowledge Base (파일 기반 KB · source-agnostic 쓰기)

레거시 지식을 "어디에·어떻게 저장하는가"의 단일 소스. **소스 무관**(노션/Figma/로컬 모두 동일 스키마, 출처 type만 다름).
벡터 RAG가 아니라 **grep/Read로 온디맨드 조회**하는 구조화 파일 KB다.

## 위치
- 워크스페이스 `./.planning/knowledge-base/` (engagement 간 **공유·누적**, 재사용 목적).
- `sources.json` 의 `knowledge_base.path` 로 재정의 가능(기본 위 경로).
- 템플릿: `${CLAUDE_PLUGIN_ROOT}/templates/knowledge-base/` 를 복사해 초기화.

## 구성 파일
1. **`policy-registry.yaml`** — 레거시 서비스 정책 레지스트리. 항목 필드:
   - `id`(kebab, 안정적), `name`, `area`(도메인 구분), `summary`
   - `conditions[]`, `exceptions[]`, `current_behavior`
   - `status`: `active | deprecated | uncertain`
   - `sources[]`: `{ type: notion|figma|local|web|ticket, ref, version, confidence }`
   - `related_entities[]`, `affected_by_engagement`(이번 기획 영향 여부/메모), `conflicts[]`
2. **`entity-glossary.md`** — 도메인 용어·엔티티: 정의·속성·관계·출처.
3. **`tech-registry.yaml`** — (tech-research) **내부/파트너 API·연동 스펙** 레지스트리:
   - `id, name, kind(internal-api|partner-api|integration-spec), summary, base_url, auth, key_endpoints[], key_params, rate_limit, error_handling, data_formats, constraints[], integration_points[], maps_to_requirement[], version, as_of, sources[], status`
   - ⚠️ **서드파티 라이브러리/SDK는 여기 넣지 않는다**(아래 staleness 정책 참고).
4. **`source-manifest.yaml`** — 수집한 모든 소스 원장(dedupe·버전충돌의 단일 기준):
   - `id, type, ref, title, version, created, modified, confidence, coverage`
   - `status`: `read | partial | skipped-binary | superseded | missing`, `ingested_at`
5. **`raw/`** — zip 해제·fetch 원문 캐시. 워크스페이스 `.gitignore` 대상.

## staleness 정책 (기술 자료)
- tech-registry·manifest 항목은 `as_of`(확인 기준일)를 보유한다.
- **서드파티 라이브러리/SDK 문서는 진실로 캐시하지 않는다**(빠르게 변함, CLAUDE.md §7.4). `source-manifest` 에 이름·버전·`as_of` 만 남기고 **사용 시점(특히 SDD 확정 전) Context7 로 재검증**한다.
- KB는 기술 자료에 대해 "무엇을·어떤 버전으로·언제 확인했는가"의 출처·버전 원장 역할을 한다.

## 적재 방법
- **append + dedupe**: 같은 `id` 가 이미 있으면 덮어쓰지 말고 **출처/내용을 최신 기준으로 갱신**하고 기존 출처는 보존(여러 소스가 한 정책을 뒷받침).
- **모든 항목에 출처 필수**. 출처 없는 정책·용어는 등록하지 않는다.
- **버전 충돌**: `local-source-ingest` 의 최신 기준을 따르고, 구버전 소스는 manifest `status: superseded`. 정책 간 내용 충돌은 항목 `conflicts[]` 에 기록.
- **증분 갱신**: 재실행 시 `source-manifest` 로 이미 읽은 소스를 식별해 중복 수집을 피한다.

## 조회 (후속 단계)
- domain-study·PRD·SDD·후속 기획은 KB를 grep/Read로 조회해 재사용한다. 각 engagement 문서는 KB 항목 `id` 를 인용한다.

## 원칙
- KB는 사실 저장소다. 추정·결정은 저장하지 않거나 `status: uncertain` 로 명시한다.
- 스키마 변경은 개별 KB 파일이 아니라 이 스킬 + `templates/knowledge-base/` 에서 한다.
