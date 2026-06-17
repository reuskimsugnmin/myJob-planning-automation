---
name: reference-research
description: 신규 제품 기능(레거시 기반이 아닌 그린필드)일 때 3단계 도메인 스터디 대신 동일 도메인의 다른 레퍼런스 서비스를 조사·분석한다. 레퍼런스 공개 웹링크·화면 캡쳐 이미지·Figma 레퍼런스를 읽어 주요 기능·필요 기획/정책·UX 패턴을 정리한다. research/reference-research.md를 생성한다. (워크플로우 3단계-alt)
---

# Reference Research (신규 제품 레퍼런스 리서치 · 3단계-alt · 오케스트레이션)

워크플로우 3단계의 **신규 제품용 분기**(domain-study의 자매). 프로젝트 유형이 **신규**일 때 수행한다.
동일 도메인 레퍼런스를 **각 소스 읽기 스킬로 수집 → 분석 3축 → md 종합**한다. 읽기 방법(how)은 소스별 스킬에 위임한다.

## 선행
- `00-project-brief.md` 에서 **프로젝트 유형 = 신규 기능·화면**(또는 혼합)임을 확인하고 목표를 얻는다. 레거시면 `domain-study` 로 가야 한다.
- 소스 레지스트리 `./.planning/sources.json`. 런타임 인자(레퍼런스 이미지/웹)도 수용.

## ⚠️ 핵심 정책 — UI 금지, UX 패턴만
- 레퍼런스의 **UI(비주얼/색/타이포/컴포넌트 외형)는 학습·기술하지 않는다.**
- **UX 패턴(인터랙션·플로우·정보구조·상태 분기)만** 추출한다. UI는 우리 서비스에 맞게 **재디자인 필요**로 명시한다.

## 절차

### 1. 수집 (읽기는 각 소스 스킬에 위임)
격리/병렬 이점이 큰 대량 읽기는 `research-agent` 로 위임 가능.
- **공개 웹링크**: `web-explore` 스킬(`reference.web`). public notion.site 포함.
- **레퍼런스 이미지**: `image-explore` 스킬(`reference.images`). 선별·직렬 비전 분석.
- **Figma 레퍼런스**: `figma-explore` 스킬(`figma.reference_files`).

### 2. 분석 3축
1. **도메인 주요 기능**: 이 신규 기능 도메인에서 레퍼런스들이 공통/차별로 제공하는 핵심 기능(교차 분석).
2. **필요한 기획 내용 · 주요 서비스 정책**: 그 기능들을 제공하려면 필요한 기획 항목과 서비스 정책.
3. **UX 패턴**: 위 핵심 정책에 따라 UI가 아닌 UX 패턴만.

### 3. 종합 → `research/reference-research.md`
- `${CLAUDE_PLUGIN_ROOT}/templates/reference-research.template.md` 를 채운다.
- 모든 사실에 출처(레퍼런스 URL / 이미지 경로)와 `as_of` 인용. UI 미학습·재디자인 배너 유지.
- 채택/차별화 같은 전략 결정은 `⛳DECISION` 후보로 표시.

### 4. 저장 · 보고
- 소스는 `knowledge-base` 의 `source-manifest`(출처·as_of, type=web/image/figma)에만 기록(별도 구조화 registry 없음).
- 핵심 기능·차별화 기회·갭을 요약하고 `tech-research` 를 제안.

## 원칙
- 수집 방법론을 여기에 복붙하지 않는다 — `web-explore`·`image-explore`·`figma-explore`·`knowledge-base` 참조.
- 출처 없는 단정 금지. UI는 절대 학습 대상이 아니다.
