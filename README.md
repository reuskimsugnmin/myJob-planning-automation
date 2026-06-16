# myJob Planning Automation

PM/PD 제품 기획 워크플로우를 자동화하는 **Claude Code 플러그인**입니다. 이 레포는 *도구*(플러그인)만 담으며, 마켓플레이스로 팀에 배포됩니다. **실제 기획 산출물은 이 레포가 아니라 별도의 "기획 워크스페이스 레포"에 생성**됩니다.

## 무엇을 자동화하나

13단계 기획 워크플로우 중 반복 노동을 Claude가 주도하고, 전략적 결정만 사람이 내립니다.

| 단계 | 담당 |
|---|---|
| 1 티켓 인입 · 2 요건 파악 · 3 도메인 스터디 · 4 기술 리서치 · 5 PRD/SDD | 🤖 Claude (MVP) |
| 6 회의록 종합 · 7 의사결정 브리프 | 🤖 보조 / 🧑 결정 |
| 8~13 Figma 스토리보드 · low/mid-fi 디자인 · 디스크립션 | 🤖 Claude / 🧑 high-fi 확정 |

> 현재 릴리스(v0.1)는 **Phase 1 MVP = 단계 1~5**를 제공합니다.

## 설치 (팀원)

```
/plugin marketplace add <github-org>/myJob-planning-automation
/plugin install product-planning@myjob-planning
```

## 사용

1. 기획 **워크스페이스 레포**로 이동: `cd myjob-planning-workspace`
2. 새 기획 시작:

```
/new-planning <노션-티켓-URL>
```

→ `engagements/<ticket-slug>/` 에 `00-project-brief.md`, `research/`, `PRD.md`, `SDD.md` 생성.

단계별로 실행할 수도 있습니다: `/intake` `/domain-study` `/tech-research` `/prd` `/sdd`

## 사전 준비

- **MCP 연동**: Notion, Figma, Google Drive, Context7 (Claude 커넥터로 연결)
- **워크스페이스 레포**: `.planning/sources.json`에 레거시 자료 위치(노션 DB ID / Figma file key 등) 등록. 스키마는 [`config/sources.example.json`](plugins/product-planning/config/sources.example.json) 참고.

## 레포 구조

```
.claude-plugin/marketplace.json        # 마켓플레이스 매니페스트
plugins/product-planning/              # 플러그인 본체
  commands/ skills/ agents/ hooks/ templates/ config/
sandbox/                               # 개발 테스트용 (gitignore)
```

자세한 설계 배경은 승인된 계획 문서를 참고하세요. 기여 방법은 [CONTRIBUTING.md](CONTRIBUTING.md).
