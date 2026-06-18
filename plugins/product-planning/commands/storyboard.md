---
description: PRD/SDD를 Figma 스토리보드·low/mid-fi 디자인으로 실현 (워크플로우 8~11)
argument-hint: [engagement-slug] [--figma-url url] [--mode A|B]
---

`storyboard-build` 스킬을 사용해 PRD를 Figma 디자인으로 실현하세요. 대상 engagement: $ARGUMENTS. `--figma-url` 로 스토리보드 대상 파일/페이지 URL을, `--mode` 로 A(운영 in-place)/B(백지 구축)를 지정할 수 있습니다(미지정이면 프로젝트 유형 기반 추천 후 확인).

`PRD.md`(+`SDD.md`)에서 화면목록·정책·노출조건·플랫폼분기·에러를 추출해 `engagements/<slug>/design/policy-table.md` 를 만들고, 기존 파일을 스캔해 갭 분석 → 사용자 확인 → 화면 생성/TO-BE 반영(쓰기 방법은 `figma-design` 스킬) → `get_screenshot` 비주얼 게이트로 검증하세요. 산출물은 모두 **현재 작업 디렉토리**의 `engagements/<slug>/design/` 에 둡니다.

## 일시정지 규칙
- **모드 미지정**: 화면별 A/B를 추천만 하고 멈춰 사용자에게 확인(혼합 가능).
- **소스 미설정**: `.planning/sources.json` 의 `figma.storyboard_template_file`/`design_system_files` 가 없으면 멈추고 대상 파일·페이지 URL을 요청.
- **갭 분석 결과**: 추가/수정 화면 목록을 제시하고 확인받은 뒤에만 생성·수정(대량 오생성 방지).
- **비주얼 게이트 불일치**: 렌더가 PRD TO-BE와 어긋나면 멈추고 디자인 수정 후 재검증. 통과 전 디스크립션 단계로 넘어가지 않음.
- **전략적 UX 배치**: 핵심 정보 우선순위·차별화 요소는 `⛳DECISION` 으로 옵션·추천만 제시(사람 결정).
