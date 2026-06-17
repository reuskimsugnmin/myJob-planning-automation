---
description: 빅테크 PM 방법론으로 PRD(원페이저+상세) 작성, 미결은 의사결정 체크리스트로 (워크플로우 5)
argument-hint: [engagement-slug (생략 시 현재/최근)]
---

`prd-author` 스킬을 사용해 PRD를 작성하세요. 대상 engagement: $ARGUMENTS (생략 시 현재 작업 중인 engagement 폴더).

`00-project-brief.md` 와 `research/*.md`(+ 지식베이스)를 우선 조회해 **글로벌 빅테크 PM** 관점으로 `PRD.md` 를 작성하세요: 상단 **원페이저 요약** + 하단 **상세 요구사항**(유저스토리·기능명세 FR + 수용기준 Given/When/Then·NFR). 정해져야 하나 미결인 정책/기획 요건은 `decision-checklist` 스킬로 본문에 `추가 기획 필요 → D-n` + 하단 체크리스트(추천안·임시 채택안·결정·최종 결정안·영향 범위)로 처리하고 임시 채택안으로 초안을 완결하세요. 마지막으로 **SDD 필요 여부를 판단해 이유와 함께 사용자에게 제안·확인**하세요(작은 건은 PRD만).
