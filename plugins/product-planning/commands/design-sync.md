---
description: 디스크립션↔디자인 동기화 상태를 검증하고 불일치를 해소 (워크플로우 11/13 검증)
argument-hint: [engagement-slug] [--figma-url url]
---

`design-finalize` 스킬의 **마감 시퀀스**를 사용해 전체 페이지를 정렬·검수·검증하세요. 대상 engagement: $ARGUMENTS. `--figma-url` 로 대상 파일/페이지를 지정하세요(미지정 시 `.planning/sources.json` `figma.storyboard_target` 폴백). 이 커맨드는 **마감 시퀀스의 수동 재트리거 진입점**입니다 — Figma에서 손으로 디스크립션/디자인을 편집한 뒤에도 `/design-sync` 한 번이면 정렬·검수가 맞춰집니다.

**1) 리플로우** (`design-finalize` 1단계 = `figma-design` §A): Description 높이에 맞춰 SB 카드 height 리사이즈 + 전 행 Y cascade, 겹침 0. 리플로우 매칭 카운트(행수·미매칭)를 dry-run으로 보고하세요.

**2) 동기화 검증(claim↔노드 대조표)** (`design-description` §6·§7): 각 화면 annotation 본문에서 노출/상태/텍스트 claim을 추출해 실제 노드값(`visible`/variant/`characters`)과 대조하고, 불일치(✗)가 있으면 자동 수정안을 제시하세요. 변경 0건이어도 모든 claim=일치 ✓ 대조표를 증거로 남깁니다.

**3) 자동 마감 검수 7항목** (`design-finalize` 4단계 = `storyboard-build` §9, hug·겹침 포함): 항목별 PASS/FAIL **검수 리포트(7행 표 + 증거)** 를 산출하고: ① DS 컴포넌트 100%(bespoke UI 0) ② 모든 액션 요소 배지 ③ 배지↔디스크립션 일치 ④ 디스크립션 양식 ⑤ 디스크립션 엣지케이스가 디자인에 존재 ⑥ 요소→목적지 화면 완전성 ⑦ 시스템 컴포넌트 무결성(detach/override 0). **#1·#7은 자동 판정·자동수정, #2는 탐지 후 명확분만 자동·애매분 리포트, #5·#6은 누락 화면을 리포트하고 HITL**(신규 화면은 사용자 확인 후 §6/§0 루프).

## 일시정지 규칙
- **불일치 발견**: 자동 수정 제안을 제시하고 **사용자 확인 후** 수정(특히 INSTANCE 전 인스턴스 스왑/detach는 영향 범위를 먼저 보고).
- **SKIP 조건**: 노드 특정 불가·다수 노드 불확실·플랫폼 분기 불명확·variant 구조 불일치면 `SKIP: [이유]` 기록 후 사용자에게 수동 확인 요청.
