---
description: 신규 개발에 필요한 기술 요건·API 문서를 수집→지식베이스화→정리 (워크플로우 4)
argument-hint: [engagement-slug] [--web url] [--local zip|dir 경로]
---

`tech-research` 스킬을 사용해 기술 리서치를 수행하세요. 대상 engagement: $ARGUMENTS (생략 시 현재 작업 중인 engagement 폴더). `--web` 으로 추가 웹링크를, `--local` 로 추가 zip/폴더 경로를 전달할 수 있습니다.

웹/문서는 `web-explore`(public notion.site는 WebFetch, 라이브러리·SDK는 Context7로 최신 검증·`as_of` 기록), 사내 노션은 `notion-explore`, 로컬은 `local-source-ingest`(신규 개발 기술요건·API 명세 초점)로 수집하세요. 내부/파트너 API·연동 스펙은 `knowledge-base` 의 `tech-registry.yaml` 에 적재하고, `research/tech-research.md` 를 템플릿 구조(요건↔기술 매핑 포함)로 작성하세요. SDD에서 결정할 기술 정책 후보를 `⛳DECISION` 으로 도출하세요.
