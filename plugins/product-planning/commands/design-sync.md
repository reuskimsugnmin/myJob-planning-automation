---
description: 디스크립션↔디자인 동기화 상태를 검증하고 불일치를 해소 (워크플로우 11/13 검증)
argument-hint: [engagement-slug] [--figma-url url]
---

`design-description` 스킬의 **동기화 절(§6·§7)** 을 사용해 전체 페이지의 디스크립션↔디자인 동기화 상태를 검증하세요. 대상 engagement: $ARGUMENTS. `--figma-url` 로 대상 파일/페이지를 지정하세요.

**먼저 `figma-design` §A의 자동 발견 리플로우 루틴을 실행**하세요(Description 높이에 맞춰 SB 카드 height 리사이즈 + 전 행 Y cascade, 겹침 0). 이 커맨드는 **"리플로우 + 동기화 검증" 단일 트리거**입니다 — Figma에서 손으로 디스크립션/디자인을 편집한 뒤에도 `/design-sync` 한 번이면 정렬이 맞춰집니다. 리플로우 매칭 카운트(행수·미매칭)를 dry-run으로 보고하세요.

그다음 각 화면 annotation 본문에서 노출/상태/텍스트 claim을 추출해 실제 노드값(`visible`/variant/`characters`)과 대조하는 **claim↔노드 대조표**를 만들고, 불일치(✗)가 있으면 자동 수정안을 제시하세요. 변경 0건이어도 모든 claim=일치 ✓ 대조표를 증거로 남깁니다.

## 일시정지 규칙
- **불일치 발견**: 자동 수정 제안을 제시하고 **사용자 확인 후** 수정(특히 INSTANCE 전 인스턴스 스왑/detach는 영향 범위를 먼저 보고).
- **SKIP 조건**: 노드 특정 불가·다수 노드 불확실·플랫폼 분기 불명확·variant 구조 불일치면 `SKIP: [이유]` 기록 후 사용자에게 수동 확인 요청.
