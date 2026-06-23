# 수직 행 리플로우 — 상세 절차 (figma-design §A)

> `figma-design` SKILL.md §A의 핀 대상. SB_Templates 카드·SECTION·Description 행을 자동 발견해 높이 리사이즈 + Y cascade + SB 라벨 동기화하는 실행 패스의 전체 절차. 마감 게이트(편집 커맨드/`/design-sync`)에서 이 루틴을 따른다.

- **수직 행 리플로우 — 규칙이 아니라 "실행 패스"(겹침 금지).** ★ `SB_Templates` 카드·SECTION·Description은 **부모 auto-layout 없이 페이지에 절대좌표로 놓인 독립 형제**이고 `SB_Templates`는 **고정 높이 인스턴스**다 → Description가 길어져도 **자동으로 안 커지고 안 밀린다.** 반드시 아래 **리플로우 패스를 명시적으로 실행**해야 한다(규칙만 적고 안 돌리면 미반영):
  - 행을 위→아래로 순회하며 `rowTop` 누적. 헤더오프셋 = SECTION/Description top − SB top(예 142).
  - **`SB_Templates` 인스턴스 height를 강제 리사이즈**: `sb.resize(폭, 헤더오프셋 + max(SECTION.height, Description.height) + pad(≈40))` — 카드가 콘텐츠 전체를 덮게(인스턴스 resize 가능; 막히면 보고). SB_Header 밴드는 상단 고정·카드 바디가 늘어남.
  - 같은 행 `SB.y = rowTop`, `SECTION.y = Description.y = rowTop + 헤더오프셋`. 다음 행 `rowTop += SB.height + gap(≈60)`.
  - **SECTION 노드도 자기 콘텐츠를 담게 리사이즈**: 폰을 2행(오버레이 등)으로 추가하면 SECTION 높이가 콘텐츠보다 작아 디자인이 섹션 밖으로 빠진다 → `sec.resizeWithoutConstraints(폭, 자식 최대 bottom − sec.y)`. (SB 카드만 키우고 SECTION을 안 키운 게 e02 "섹션이 디자인 미포함" 결함.)
  - 리플로우 후 `get_metadata`/`get_screenshot` 으로 카드가 Description를 덮고 **SECTION이 모든 폰을 포함**(`section.height ≥ 자식 extent`)하며 행 간 겹침 0 확인.
- **자동 발견 리플로우 루틴(하드코딩 id 금지 · 재사용).** 특정 화면 id를 박지 말고 페이지에서 행을 **스스로 찾아** 리플로우한다 — 어떤 스토리보드 페이지에도 동작:
  ```
  // 1) 행 발견: SB_Templates 인스턴스를 Y 오름차순 정렬
  rows = page.children.filter(n => n.type==='INSTANCE' && n.name==='SB_Templates').sort(byY)
  for each sb (위→아래, rowTop = 첫 행 sb.y 부터 누적):
    // 2) 같은 행의 SECTION·Description 매칭(Y 근접 + X 위치)
    sec  = page.children.find(SECTION, |n.y-(sb.y+OFF)|<선, n.x≈36)         // 디자인 섹션
    desc = page.children.find(FRAME name='Description', |n.y-(sb.y+OFF)|<선, n.x≈1421)
    OFF = sec.y - sb.y (첫 행에서 측정; 보통 142)
    // 3) 리사이즈 + cascade — desc는 먼저 AUTO(콘텐츠 hug)로, 높이는 실제 콘텐츠 extent로
    desc.primaryAxisSizingMode='AUTO'   // FIXED면 오버플로해도 height 안 변해 아래 행 침범
    secBot = realBottom(sec); descBot = realBottom(desc)   // = absoluteBoundingBox + 자식 최대 extent (height 직접 사용 금지)
    // ★ SECTION도 자기 콘텐츠(폰 2행 등)를 담게 리사이즈 — SB 카드만 키우면 섹션이 디자인을 못 담는다(실패: e02 2폰행이 섹션 밖)
    sec.resizeWithoutConstraints(sec.width, Math.ceil(secBot - sec.absoluteBoundingBox.y))
    rowH = OFF + max(secBot-sec.y, descBot-desc.y) + pad(40)
    sb.resize(sb.width, rowH); sb.y=rowTop; sec.y=desc.y=rowTop+OFF
    // 4) ★ SB 라벨 자동 동기화 — [화면 ID]·타이틀을 섹션명에서 파생(stale 드리프트 방지)
    sp = sec.name.indexOf(' '); id = sp>0?sec.name.slice(0,sp):sec.name; title = sp>0?sec.name.slice(sp+1):sec.name
    sb.findOne(TEXT name='[화면 ID]').characters = '['+id+']'   // 폰트 로드 후
    sb.findOne(TEXT name='화면 / 기능명').characters = title     // 'e05 본인인증' → [e05] / 본인인증
    rowTop += rowH + gap(60)
  return 매칭 카운트(행수·미매칭) // dry-run 보고로 오매칭 0 확인
  ```
  - **★ 리플로우 대상 페이지 = 편집한 SECTION의 parent 페이지.** `figma.currentPage`(호출 간 첫 페이지로 리셋)·문서 첫 페이지를 가정 금지 — 디자인 SECTION·Description이 별도 페이지에 있을 수 있고(스토리보드가 자체 페이지), 첫 페이지엔 **무관한 다른 스토리보드**가 있을 수 있다. 편집 노드에서 `node.parent`(PAGE)로 실제 페이지를 구해 **그 페이지의 행만** 리플로우한다(실패 사례 e01: 디스크립션이 별도 페이지 `466:5338`인데 첫 페이지 `0:1`엔 Taxi 스토리보드 → 첫 페이지를 스캔하면 무관 스토리보드를 옮길 뻔).
  - **★ idempotency 검산(타 행 오이동 방지).** cascade 적용 전, 편집 행 외 **미편집 행 1~2개**의 계산 `rowH = OFF + max(secExt, descExt) + PAD`가 현재 SB height와 일치하는지 먼저 검산한다. 불일치면 OFF/GAP/PAD 상수가 페이지 컨벤션과 달라 타 행을 잘못 이동시킨다 → 상수 보정 후 진행(편집 행 + 그 아래 cascade만 움직여야 정상. e01에선 e02/e03/e04 SB height 일치 확인 후 진행 → 타 행 오이동 0).
  - **★ `desc.height`(및 `sec.height`)를 직접 신뢰하지 말 것.** Description은 `primaryAxisSizingMode='AUTO'`여야 하고, 행 높이·겹침은 **`absoluteBoundingBox` + 자식 콘텐츠 최대 extent**(`realBottom`)로 계산한다 — FIXED 프레임은 콘텐츠가 넘쳐도 height가 안 변해 검사를 속인다(실패 사례 e05: 697 frame에 1204 콘텐츠 → e-loading 침범).
  - **완료 게이트(필수).** 디자인/디스크립션을 **편집한 커맨드는 마감에서 이 루틴을 항상 실행**한다(`storyboard-build`/`design-description`/`/design-sync`). 사용자가 따로 요청하지 않아도 자동. *단* Figma에서 손으로 직접 편집한 경우는 자동이 아니므로 `/design-sync`로 1회 트리거.
  - 미매칭(비표준 행: SB 없음/Description 이름 불일치)은 건너뛰고 **카운트로 보고**(임의 이동 금지).
