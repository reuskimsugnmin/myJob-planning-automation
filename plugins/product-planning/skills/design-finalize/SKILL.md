---
name: design-finalize
description: 디자인 단계(스토리보드·디스크립션·동기화) 공용 "마감 시퀀스"의 단일 소스. 리플로우→hug 무결성→행 겹침 0→자동 마감 검수 7항목→(편집 시)동기화·claim↔노드 대조표의 순서·실행 게이트를 한 곳에 정의한다. /storyboard·/design-desc·/design-sync 커맨드가 마감에서 이 시퀀스를 호출한다. 상세 방법론은 각 owner 스킬(figma-design·storyboard-build·design-description)을 참조한다.
---

# Design Finalize (디자인 마감 시퀀스 · 공용)

디자인 작업(스토리보드 생성·디스크립션·동기화)을 끝낼 때 **항상 실행하는 마감 시퀀스**의 단일 소스다.
**방법론을 새로 정의하지 않는다** — 각 단계의 "어떻게"는 owner 스킬에 있고, 여기서는 **순서·실행 트리거**만 단일화한다(과거 3개 커맨드가 같은 마감 문장을 각자 재기술하던 중복 제거).

> 디자인/디스크립션을 **편집한 커맨드는 마감에서 이 시퀀스를 항상 자동 실행**한다(`/storyboard`·`/design-desc`). 사용자가 따로 요청하지 않아도 자동. **Figma에서 손으로 직접 편집한 경우는 자동이 아니므로 `/design-sync`로 1회 트리거**한다(`/design-sync`가 이 시퀀스의 수동 재트리거 진입점).

## 마감 시퀀스 (이 순서로 실행)

1. **수직 행 리플로우** — 페이지에서 행(SB_Templates+SECTION+Description)을 자동 발견해 SB 카드 height 리사이즈 + SECTION 콘텐츠 포함 + 행 Y cascade + SB 라벨 섹션명 동기화. 하드코딩 id 금지. → 방법: `figma-design` §A(`skills/figma-design/references/reflow.md`).
2. **컴포넌트 hug 무결성** — 삽입/clone 후 높이 붕괴(<6px)·흰 여백 자동 수정. → `figma-design` §F-3(`skills/figma-design/scripts/hug-fix.js`).
3. **행 겹침 0 검사** — `absoluteBoundingBox`+자식 extent로 SECTION·Description 교차 0 확인(`node.height` 금지). → `storyboard-build` §8(`skills/storyboard-build/scripts/reflow-audit.js`).
4. **자동 마감 검수 게이트(7항목)** — DS 커버리지·액션 배지·배지↔디스크립션·양식·엣지케이스→디자인·요소→목적지·인스턴스 무결성. 항목별 PASS/FAIL 리포트. **#1·#7·#8·#9 자동수정 / #2 명확분 자동·애매분 리포트 / #5·#6 누락 화면 리포트 후 HITL**. → `storyboard-build` §9(`skills/storyboard-build/scripts/closeout-audit.js`).
5. **(디스크립션을 편집했으면) 동기화 + claim↔노드 대조표** — Description 내용을 실제 디자인에 반영(visible/variant/characters)하고, claim=실제 대조표로 3자 일치 증명(변경 0건도 표로). → `design-description` §6·§7.

- **완료 게이트(필수).** 위 1~5를 마치고 **겹침 0 + 7항목 리포트(7행 표 + 증거) + (편집 시)대조표**를 보고에 포함해야 마감이다. 미매칭(비표준 행)은 임의 이동 말고 카운트로 보고.
- **단일 소스 원칙.** 각 단계의 알고리즘·스크립트·기준은 owner 스킬에 있고 이 파일은 그것을 **참조**한다. 절차를 여기에 복붙하지 않는다(owner를 고치면 마감도 함께 개선).

## fidelity 목표 레벨 (`--fidelity mid|high` · opt-in)
마감은 **목표 fidelity 레벨**을 받아 그 레벨 게이트를 적용한다. **기본 `mid`(기존 동작 그대로) · `high` opt-in.** high는 위 1~5(구조 마감) 뒤에 **추가 패스로만** 작동한다 — **기존 1~5 게이트 동작 변경 0**(미지정/`mid`면 오늘과 동일).

| 레벨 | 충족 기준 |
|---|---|
| **low** | 화면 골격만(++Top/Body/++Bottom), placeholder 일부 허용 |
| **mid**(기본·종착 보장) | 위 마감 1~5 전부 PASS — DS 컴포넌트 100%·토큰 바인딩·겹침0·배지↔디스크립션·hug |
| **high**(opt-in) | mid + ⓐ 콘텐츠 현실성 ⓑ 머천다이징 surface ⓒ 일러스트/에셋 ⓓ 강조 위계 ⓔ 상태 풍부도 ⓕ 컨테이너 적정성 |

**high 추가 패스(1~5 뒤에 실행):**
6. **fidelity 차원 리포트** — high 기준 ⓐ~ⓕ를 화면별 PASS/FAIL/N-A로 점검. 차원별 방법론은 owner 스킬이 단일 소스(복붙 금지·참조): ⓐ 콘텐츠=`storyboard-build §3`·`design-description §선행/§4` / ⓑ 머천다이징=`storyboard-build §2.5` / ⓒ 일러스트=`figma-design` 에셋 루틴 / ⓓ 강조=`figma-design` emphasis / ⓔ 상태=`storyboard-build §6` / ⓕ 컨테이너=아래 8. 의미 판단 차원은 파싱+HITL.
7. **illustrative 누출 검사(불변식 1 방어)** — content-kit `provenance: illustrative` 값이 **PRD/SDD 본문·디스크립션 `[데이터]/[수용기준]`(개발계약)** 에 등장하면 **FAIL**(예시는 디자인 레이어 전용). 소셜프루프 수치(평점·구매수)는 화면/주석에 "예시" 맥락이 없으면 경고. → 위반 시 사용자 보고·교정.
8. **컨테이너 적정성(F-6) 휴리스틱** — 각 화면이 ① 콘텐츠 밀도 낮음(빈 여백 비율 임계 초과) + ② 글랜스+단일/제로 액션 + ③ 부모 화면 즉시 트리거면 **"바텀시트/인라인 후보" 플래그**(재구성 방법은 `figma-design §M`). **자동 변환 금지 — 제안·미리보기만, 채택은 사람(⛳).**
9. **사람 high-fi 잔여 punch-list** — 도구가 못 채운(취향·머천다이징 확정·일러스트 에셋 부재·시트 전환 등) 항목을 **"남은 사람 몫" 목록**으로 산출. high-fi 최종 확정은 사람(워크플로우 13).

> **보존(보존 계약).** high 패스는 전부 **additive·제안·미리보기** — 매칭 DS 컴포넌트 swap/detach/삭제·사람 수작업 덮어쓰기 금지. **시각 변경(강조 등)은 `--scan` dry-run 보고 → 사용자 승인 후** 적용. 6~9는 owner 스킬을 참조(단일 소스).

## 원칙
- 산출물·로그는 CWD 워크스페이스 `engagements/<slug>/design/`.
- 자동수정이 정본(리플로우 행)을 건드리면 1번 리플로우를 재실행해 정합을 맞춘다.
