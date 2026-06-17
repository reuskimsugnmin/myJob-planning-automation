---
name: sdd-author
description: PRD와 기술 리서치를 토대로 SDD(Spec Driven Document)를 작성/갱신한다. SDD 작성, 기술 스펙·데이터 모델·아키텍처 정리가 필요할 때 사용. PRD 요구사항과 스펙을 매핑하고, 기술 정책 결정 항목은 ⛳DECISION으로 표시한다. SDD.md를 생성한다. (워크플로우 5단계)
---

# SDD Author (Spec Driven Document 작성)

워크플로우 5단계. PRD + 기술 리서치를 구현 가능한 스펙으로 구체화한다.

## 선행 (모두 읽고 시작)
- `PRD.md`, `research/tech-research.md`. 보조로 `research/domain-study.md`.
- 기술 사실은 **`research/tech-research.md` + 지식베이스 `tech-registry.yaml` 를 우선 조회**해 사용한다(원문 재페치 X, 출처는 KB `id`/문서 인용).
- **라이브러리/SDK 재검증 게이트**: SDD 확정 전, `source-manifest` 에 기록된 라이브러리/SDK 버전을 **Context7(`resolve-library-id`→`query-docs`)로 재검증**한다. stale하면 `tech-research` 갱신을 요청한 뒤 진행한다.

## 절차

1. `${CLAUDE_PLUGIN_ROOT}/templates/SDD.template.md` 를 읽어 `SDD.md` 를 채운다.

2. **PRD 추적성**: 각 스펙이 어떤 PRD 요구사항(FR-n)을 충족하는지 매핑 표를 채운다. 충족되지 않은 PRD 요구사항이 없도록 검증.

3. **자동 작성 가능 항목**: 데이터 모델/엔티티(필드·관계), 핵심 플로우/시퀀스, API/인터페이스, 엣지 케이스·에러 처리, 외부 연동, 비기능 요구사항. 모두 tech-research 출처에 근거.

4. **⛳DECISION 항목**: 기술 정책·아키텍처 선택처럼 사람이 정해야 하는 부분은 옵션·트레이드오프·추천을 제시하고 `⛳DECISION` 으로 표시, 하단 모아보기에 수집.

5. **데이터 모델/플로우는 텍스트로 먼저** 정리한다. Figma 시각화(ERD/플로우차트)는 Phase 3 `storyboard-build` 가 이 SDD를 입력으로 수행한다.

6. **보고**: 매핑 누락 여부, 미결 ⛳DECISION, 구현 리스크를 요약.

## 원칙
- PRD에 없는 스펙을 임의로 추가하지 않는다(필요하면 PRD 갱신을 제안).
- 기술 사실은 tech-research/공식 문서에 근거하고 출처를 단다.
