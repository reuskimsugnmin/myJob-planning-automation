# 기여 가이드

이 레포는 **도구(플러그인)** 만 담습니다. 실제 기획 산출물은 워크스페이스 레포에 두세요.

## 원칙

- **도구 ↔ 산출물 분리**: 스킬/커맨드는 산출물을 항상 **현재 작업 디렉토리(CWD)** 에 쓰고, 템플릿·설정은 `${CLAUDE_PLUGIN_ROOT}` 에서 읽습니다. 플러그인 레포 안에 기획 산출물을 커밋하지 마세요(`sandbox/`만 예외, gitignore됨).
- **팀 공용 포맷 우선**: PRD/SDD 등 산출물 포맷은 `templates/` 의 템플릿을 통해 표준화합니다. 포맷을 바꾸려면 템플릿을 수정하세요.

## 새 스킬/커맨드 추가

1. `plugins/product-planning/skills/<name>/SKILL.md` — frontmatter에 `name`, `description` 필수.
2. 커맨드는 `plugins/product-planning/commands/<name>.md` — frontmatter에 `description`, `argument-hint`.
3. `sandbox/` 에서 실제 티켓으로 E2E 테스트 후 PR.

## 버전 규칙 (SemVer)

- `plugin.json`, `marketplace.json` 의 `version` 을 함께 올립니다.
- patch: 프롬프트/문구 보정 · minor: 스킬/커맨드 추가 · major: 워크스페이스 구조·산출물 포맷 변경.

## PR

- 변경한 스킬이 만든 산출물 예시(또는 diff)를 PR 설명에 첨부.
- 가능하면 과거 사람 작성 산출물과 비교한 품질 노트 포함.
