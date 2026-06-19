---
description: 신규 제품일 때 동일 도메인 레퍼런스를 조사·분석 (워크플로우 3-alt, 도메인 스터디 대체)
argument-hint: [engagement-slug] [--ref-images dir|경로] [--ref-web url]
---

`reference-research` 스킬을 사용해 레퍼런스 리서치를 수행하세요. 대상 engagement: $ARGUMENTS (생략 시 현재 작업 중인 engagement 폴더). `--ref-images` 로 레퍼런스 이미지 경로/폴더를, `--ref-web` 으로 레퍼런스 공개 웹링크를 전달할 수 있습니다.

`00-project-brief.md` 의 프로젝트 유형이 **신규**인지 먼저 확인하세요(레거시면 `domain-study` 로 가야 합니다). 공개 웹링크는 `web-explore`, 레퍼런스 이미지는 `image-explore`(선별·직렬 비전), Figma 레퍼런스는 `figma-explore`(reference_files)로 수집하고, **주요 기능·필요 기획/정책·UX 패턴** 3축으로 `research/reference-research.md` 를 작성하세요. ⚠️ **UI/비주얼은 학습하지 말고 UX 패턴만** 추출하세요(UI는 우리 서비스에 맞게 재디자인). 모든 사실에 출처와 `as_of` 를 인용하세요.

완료 후 핵심 기능·차별화 기회·갭을 보고하고, **다음 단계로 `/tech-research`(4단계)를 제안**하세요. ⚠️ 레퍼런스 리서치가 끝났다고 바로 `/prd`로 넘어가지 마세요 — 신규 분기도 `reference-research → tech-research → prd` 순서이며, tech-research가 PRD의 필수 입력입니다.
