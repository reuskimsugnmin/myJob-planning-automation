---
description: 레거시 정책·도메인 자료를 소스에서 수집→지식베이스화→종합 (워크플로우 3)
argument-hint: [engagement-slug] [--figma-pages "p1,p2"] [--local zip|dir 경로]
---

`domain-study` 스킬을 사용해 도메인 스터디를 수행하세요. 대상 engagement: $ARGUMENTS (생략 시 현재 작업 중인 engagement 폴더). `--figma-pages` 로 탐색할 Figma 페이지를, `--local` 로 추가 zip/폴더 경로를 전달할 수 있습니다.

`.planning/sources.json` 의 노션/Figma/로컬/웹 소스를 각 소스 읽기 스킬(`notion-explore`/`figma-explore`/`local-source-ingest`)로 수집하고 `knowledge-base` 에 적재한 뒤, `research/domain-study.md` 를 생성하세요. 모든 사실에 출처를 인용하고, Figma 탐색 페이지가 지정되지 않았으면 사용자에게 확인하세요. 폭이 넓은 대량 읽기는 `research-agent` 서브에이전트로 격리하되 Figma는 직렬로 진행하세요.
