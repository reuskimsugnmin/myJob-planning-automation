---
description: 빅테크 PM 방법론으로 PRD(원페이저+상세) 작성, 미결은 의사결정 체크리스트로 (워크플로우 5)
argument-hint: [engagement-slug (생략 시 현재/최근)]
---

`prd-author` 스킬을 사용해 PRD를 작성하세요. 대상 engagement: $ARGUMENTS (생략 시 현재 작업 중인 engagement 폴더).

**먼저 리서치 산출물 존재 게이트를 확인하세요**: `research/tech-research.md` 가 없으면 멈추고, "4단계 기술 리서치가 누락됐습니다 — `/tech-research` 를 먼저 수행할까요, 아니면 (단순 개선/소규모 건이라) 의도적으로 건너뛸까요?" 를 사용자에게 확인한 뒤에만 진행하세요(자의로 생략 금지). 마찬가지로 프로젝트 유형에 맞는 3단계 산출물(`research/domain-study.md` 또는 `research/reference-research.md`)이 없으면 함께 확인하세요.

게이트 통과 후 `00-project-brief.md` 와 `research/*.md`(+ 지식베이스)를 우선 조회해 **글로벌 빅테크 PM** 관점으로 `PRD.md` 를 작성하세요: 상단 **원페이저 요약** + 하단 **상세 요구사항**(유저스토리·기능명세 FR + 수용기준 Given/When/Then·NFR). 정해져야 하나 미결인 정책/기획 요건은 `decision-checklist` 스킬로 본문에 `추가 기획 필요 → D-n` + 하단 체크리스트(추천안·임시 채택안·결정·최종 결정안·영향 범위)로 처리하고 임시 채택안으로 초안을 완결하세요. 마지막으로 **SDD 필요 여부를 판단해 이유와 함께 사용자에게 제안·확인**하세요(작은 건은 PRD만).
