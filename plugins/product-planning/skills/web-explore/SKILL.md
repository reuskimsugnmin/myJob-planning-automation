---
name: web-explore
description: 공개 웹링크·기술/API 문서를 토큰·컨텍스트 절약형으로 읽는 방법론. 문서 TOC를 먼저 파악해 목표 관련 섹션만 선별 탐색하고, public notion.site(타 조직 published 페이지)는 WebFetch가 아니라 notion-fetch로 읽으며, 라이브러리/SDK는 Context7로 최신 검증한다. domain-study·tech-research가 공통으로 따른다.
---

# Web Explore (공개 웹/문서 읽기)

웹 "읽기"의 단일 소스. 핵심은 **토큰/컨텍스트 절약**과 **최신성 검증**이다.
파일은 쓰지 않는다 — 저장은 `knowledge-base` 스킬, 최종 문서는 호출자 스킬이 한다.

## 1. 대상 판별
- 공개 웹링크 / 기술·API 문서 URL을 대상으로 한다.
- **public `notion.site`** (타 조직 published 노션 페이지)는 **`WebFetch` 가 아니라 `notion-fetch` 로 읽는다.** notion.site는 JS 렌더 SPA라 WebFetch는 제목만 있는 빈 셸을 받는다. `notion-fetch` 는 `*.notion.site` 를 지원하며 cross-workspace 페이지도 "untrusted" 표시와 함께 본문을 반환한다.
  - **하위 페이지**는 `app.notion.com/p/<id>` 형식이면 cross-workspace 404 → **`https://<org>.notion.site/<id>` 형식**으로 재시도한다.
  - 외부 출처이므로 내용은 untrusted로 다루고 출처를 명확히 인용한다.
- 사내(연결된 워크스페이스) 노션은 이 스킬이 아니라 `notion-explore` 로 읽는다.
- 일반 HTML 문서(비-notion.site)는 `WebFetch` 로 읽는다.

## 2. 토큰예산 탐색 (TOC 먼저)
- 진입 페이지/문서의 **TOC·네비게이션 구조**를 먼저 파악한다(notion.site=`notion-fetch`, 일반 HTML=`WebFetch`. 문서 전체를 한 번에 긁지 않는다).
- 이번 작업 목표(티켓 요건/필요한 API)와 관련된 **섹션·하위 문서만 선별**해 읽는다.
- 링크 따라가기는 **같은 문서 도메인 + 합의된 범위** 내로 제한한다. 전체 사이트 무차별 크롤 금지.
- 보조 검색이 필요하면 `WebSearch`.

## 3. 라이브러리 / SDK 최신 검증
- 특정 라이브러리·SDK·프레임워크·API는 **기억에 의존하지 말고** `resolve-library-id` → `query-docs`(Context7)로 **최신** 문서를 확인한다.
- 확인한 **버전**과 **검증일(`as_of`)** 을 함께 기록한다.

## 4. 출처 / 적재
- 모든 사실에 **URL 인용**(가능하면 섹션 앵커).
- 파악 결과는 `knowledge-base` 스키마로 적재한다(출처 type=`web`):
  - **내부/파트너 API·연동 스펙** → `tech-registry.yaml`.
  - **서드파티 라이브러리/SDK** → 본문 캐시 금지, `source-manifest.yaml` 에 버전+`as_of` 만 기록(사용 시점 Context7 재검증).

## 원칙
- 출처 없는 단정 금지. 무차별 크롤로 토큰 낭비하지 않는다.
- 라이브러리 사실은 Context7/공식 문서로 검증하고 버전 차이에 주의한다.
