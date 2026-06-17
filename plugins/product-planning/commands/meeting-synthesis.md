---
description: 회의록(Google Doc) 또는 Slack 스레드를 읽어 PRD/SDD에 반영·체크리스트 확정 (워크플로우 6)
argument-hint: [engagement-slug] [--gdoc url] [--slack thread-url]
---

`meeting-synthesis` 스킬을 사용해 회의 결과를 PRD/SDD에 반영하세요. 대상 engagement: $ARGUMENTS. `--gdoc` 로 Gemini 회의록(Google Doc) URL을, `--slack` 으로 Slack 스레드 URL을 전달하세요(둘 다 가능).

회의 소스는 `gdrive-explore`(Google Doc) / `slack-explore`(Slack)로 읽고, 현재 `PRD.md`/`SDD.md` 와 대조해 수정·추가·삭제·갱신 지점을 분석하세요. 결정된 의사결정 체크리스트 항목은 `decision-checklist` 의 최종 결정 반영 플로우로 확정하세요. ⚠️ **이해/맥락이 모호한 부분은 절대 자의적으로 해석하지 말고 반드시 사용자에게 확인**한 뒤 반영하세요. 마지막에 확인한 내용과 PRD/SDD에서 바꾼 부분을 보고하세요.
