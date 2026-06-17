---
name: notion-explore
description: 노션 페이지/티켓/DB를 읽고 트리(상위·하위·relation)를 예산 안에서 탐색하는 방법론. 노션 자료를 수집해야 하는 모든 스킬(planning-intake·domain-study·tech-research)과 research-agent가 공통으로 따른다. 레거시 정책 vs 신규 요구사항 판별, 코멘트·멘션 resolve 규칙을 포함한다.
---

# Notion Explore (노션 읽기 · 트리 탐색 단일 소스)

노션을 읽는 "방법(how)"의 단일 소스. 다른 스킬은 이 절차를 **참조**한다(복붙 금지).
파일을 쓰지 않는다 — 읽은 결과의 저장은 `knowledge-base` 스킬, 최종 문서는 호출자 스킬이 한다.

## 1. fetch & ID 폴백
- 받은 URL/ID를 그대로 `notion-fetch`(`include_discussions: true`)에 전달. `app.notion.com/p/<id>?v=...&source=...` 형식도 그대로 동작.
- 실패하면 URL 마지막 경로 세그먼트에서 **32자리 hex ID**(쿼리·대시 제거)를 추출해 ID로 재시도.

## 2. 엔티티 타입 판별
- `metadata.type` 확인: `page` 면 진행. `database`/data source(`collection://`)면 단일 페이지가 아니므로, 어떤 엔트리를 읽을지 사용자에게 확인하거나 `notion-search` 로 좁힌다.
- DB 엔트리 페이지는 `<properties>` 와 `<ancestor-path>` 를 가진다.

## 3. 트리 순회 + 예산 게이트 (HITL)
- **자동 탐색 범위**: ancestor 1-hop + 핵심 relation(하위 일감·프로덕트·업무구분·주요 이슈·회의록 일부). 각 페이지를 `notion-fetch` 로 읽어 요약.
- **예산 상한 N≈8~10 페이지**. 연결 페이지가 상한을 넘으면 **전체 목록을 제시하고 어디까지 탐색할지 사용자에게 확인**한다. 무단으로 N-hop 깊이 펼치지 않는다(받은/합의된 범위만).
- 키워드 검색이 필요하면 `notion-search`(티켓 제목·핵심 용어).

## 4. 레거시 vs 신규 판별 (domain-study 용)
- 도메인 스터디 목적의 호출에서는 티켓·하위페이지 내용을 **"이번 신규 요구사항/개발 요건"** 과 **"기존 제품 서비스 레거시 정책·기획"** 으로 구분한다.
- 레거시 신호: 현재 동작/현행 정책 서술, "기존/현재/AS-IS", 과거 일자, 운영 중 기능 설명, 데이터/플로우 현황. → 레거시만 골라 지식베이스로.
- 신규 신호: "이번 작업/추가/변경/TO-BE/개선", MoSCoW 우선순위, 이번 일정. → 도메인 스터디 KB가 아니라 요건으로 분류(브리프·PRD가 다룸).
- 판별이 모호하면 단정하지 말고 `추정` 표시 또는 사용자 확인.

## 5. 코멘트 · 멘션 resolve
- `<page-discussions>` 에 discussion이 있으면 `notion-get-comments` 로 스레드를 가져온다(미해결 우선).
- 추출한 `user://` ID는 모아 `notion-get-users` 로 실명·역할을 일괄 resolve(중복 제거). 실패한 ID는 그대로 표기.

## 출력 / 출처
- 모든 사실에 출처(노션 URL 또는 page id)를 단다. 출처 type은 `notion`(일반 정책/도메인) 또는 `ticket`(인입 티켓 트리).
- 파악한 레거시 정책/엔티티는 `knowledge-base` 스킬 스키마로 적재한다.

## 원칙
- 노션에 없는 내용을 지어내지 않는다. 모르는 것은 `미상`/`추정`.
- 예산 초과 탐색은 사용자 확인 후 진행.
