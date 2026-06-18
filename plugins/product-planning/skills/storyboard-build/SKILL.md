---
name: storyboard-build
description: PRD/SDD를 Figma 스토리보드·low/mid-fi 디자인으로 실현하는 오케스트레이션(워크플로우 8~11). PRD에서 화면목록·정책·노출조건·플랫폼분기·에러를 추출해 policy-table을 만들고, 모드 A(운영 in-place)/B(백지 구축)를 선택해 화면을 생성·TO-BE 반영한 뒤 비주얼 게이트로 검증한다. 쓰기 방법론은 figma-design 스킬을 따른다.
---

# Storyboard Build (스토리보드·디자인 실현)

워크플로우 8~11단계. **PRD를 디자인으로 실현**하는 오케스트레이션 스킬.
원리: **디자인을 PRD대로 먼저 실현(③) → 눈으로 검증(④) → 그 디자인을 보고 디스크립션(`design-description`).** ②③을 건너뛰고 디스크립션만 쓰면 PRD가 화면에 안 들어간다.

> Figma "쓰기"의 구체 방법(3세트 구조·골격·clone/조립·swap 결함·심볼·폰트)은 **`figma-design` 스킬** 을 따른다(여기에 복붙하지 않음). 레거시/레퍼런스 화면 "읽기"가 필요하면 `figma-explore`(+대량이면 `research-agent`)를 쓴다. high-fi 고도화·디자인 취향 확정(단계 13)은 사람 몫.

## 선행
- 대상 engagement에 `PRD.md`(있으면 `SDD.md`)가 있어야 한다.
- `.planning/sources.json` 의 `figma.storyboard_template_file`(스토리보드 템플릿)·`figma.design_system_files`(연결 라이브러리)·`figma.legacy_files`/`reference_files` 를 확인. 스토리보드 대상 파일/페이지 URL이 없으면 사용자에게 요청.

## 절차

### 1. 정책 테이블 추출 (PRD → policy-table)
- `PRD.md`(+`SDD.md`)를 읽어 **필요 화면 목록**과 화면별 정책을 도출한다. 도출 기준:
  - 명시된 화면 이름·ID·기능 단계, 플로우 분기/조건으로 파생되는 상태 화면(성공/실패/에러), 이전/다음 화면 관계(백버튼).
  - 각 화면의 **노출 조건·플랫폼 분기·에러 케이스·서비스 정책**(FR/US 참조와 함께).
- `${CLAUDE_PLUGIN_ROOT}/templates/design/policy-table.template.md` 를 채워 **`engagements/<slug>/design/policy-table.md`** 에 저장. 각 항목에 출처(`PRD FR-n`/`US-n`/노션/Figma) 인용.
- `similarTo`(가장 유사할 기존 화면)를 화면별로 메모해 ③의 clone 후보로 쓴다.

### 2. 모드 선택 (필수 HITL)
화면마다 **어떻게 짓느냐**를 정한다(나머지 단계는 공통). intake가 판정한 **프로젝트 유형**을 기본 추천으로 제시하되 **최종은 사용자 확인**:
- **모드 A — 운영(in-place)**: 운영 중 기존 화면을 유지하며 PRD TO-BE **변경분만** 반영(콘텐츠·컴포넌트·노출). 기존 뱃지·디스크립션 보존. → 프로젝트 유형 **레거시 개선** 기본.
- **모드 B — 백지 구축**: layout 구조부터 기성 composite 컴포넌트로 재설계. 남의 템플릿 clone·신규 화면·톤앤매너 변경. → 프로젝트 유형 **신규** 기본.
- **혼합**이면 화면별로 A/B를 달리 선택. 모드 미지정이면 멈추고 사용자에게 묻는다.

### 3. 화면 실현 (figma-design 방법론)
- 기존 파일을 스캔해 화면 목록(SB_Templates+SECTION+Description 3세트)과 컴포넌트 인벤토리를 파악 → policy-table과 **갭 분석**(추가할 화면 / 기존 화면 TO-BE 수정).
- **갭 분석 결과를 사용자에게 제시하고 확인받은 뒤** 실행(잘못된 대량 생성 방지).
- 모드 A: 변경분만 in-place 반영(옛 요소 완전 삭제, 뱃지·디스크립션 보존). 모드 B: `figma-design` 의 ++Top 골격 + region↔컴포넌트 매핑 + zero-bespoke 마감으로 **한 패스에 완전한 구조**(Description 스캐폴드 포함)로 산출.
- "누락 0개"여도 끝이 아님 — **기존 화면도 PRD TO-BE 항목 단위로 대조**해 반영. 5개씩 배치, 15개 초과는 범위 분할.
- `⛳DECISION`: 전략적 UX 배치(핵심 정보 우선순위·차별화 요소)는 단정하지 말고 옵션·추천만.

### 4. 비주얼 게이트 (필수 HITL)
- 생성·변경한 화면을 `get_screenshot`(maxDimension≥800)으로 캡처해 **실제 보이는 콘텐츠**(라벨·이미지·값)가 PRD TO-BE와 맞는지 확인한다. 노드 이름·visible·디스크립션이 아니라 **렌더로 판정**.
- 어긋나면 ③으로 복귀해 디자인 수정. 통과해야 다음(디스크립션) 단계로.
- 구조 점검: 각 region이 기성 컴포넌트 인스턴스인가(bespoke 잔재 0), 미연결/타 도메인 라이브러리 참조 0, 뱃지 최상위 z-order, 겹침·이중 테두리 0.

### 5. 로그 + 보고
- `${CLAUDE_PLUGIN_ROOT}/templates/design/design-log.template.md` 로 `engagements/<slug>/design/logs/build-<YYYY-MM-DD>.md` 에 처리 요약(추가/수정/스킵 화면 표, 주요 변경, 수동 확인 필요 항목)을 남긴다.
- 보고: 추가 N개·수정 M개 화면 표, 주요 변경, ⚠️ 수동 확인 필요(컴포넌트 교체·레이아웃 미세조정), 다음 단계 안내(`/design-desc <slug>`).

## 원칙
- 디스크립션이 PRD를 말해도 화면 비주얼이 안 바뀌면 PRD 미반영이다 — 화면을 PRD대로 **설계·구현**한다.
- 모든 사실에 출처 인용, 지어내지 않는다. 산출물은 CWD `engagements/<slug>/design/`.
- 모드 선택·갭 분석 확인·비주얼 게이트는 생략 불가(메인 컨텍스트 HITL).
