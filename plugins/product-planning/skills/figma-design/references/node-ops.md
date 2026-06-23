# 노드 조작 — 텍스트·폰트 / swap·삽입 결함 / 심볼 INSTANCE (figma-design §E·§F·§G)

> `figma-design` SKILL.md §E·§F·§G의 핀 대상. 텍스트 수정·컴포넌트 swap/삽입·인스턴스 내부 수정이 안 먹힐 때의 트러블슈팅 전문. 해당 단계에서 이 파일을 읽어 따른다.

## E. 텍스트·폰트
- 폰트 로드 순서: **기존 폰트 → Pretendard Regular → Inter Regular → Noto Sans KR**. `loadFontAsync` 없이 텍스트 수정 금지.
- mixed 폰트는 `getRangeFontName` 루프로 전수 로드 후 수정.
- **★ `loadFontAsync`는 "글자를 편집하려면 폰트가 메모리에 있어야 한다"는 편집 전제일 뿐, HPDS 타이포 토큰 적용이 아니다.** Pretendard는 HPDS 기본 폰트라 로드 대상이 맞지만, 실제 **HPDS 타이포 매칭은 §K의 텍스트 스타일(`setTextStyleIdAsync`)을 생성 시점에 적용**하는 것이다(둘을 혼동 말 것).

## F. 컴포넌트 swap·삽입 결함 3종 (반드시 점검)
1. **swap 후 색·모양 이상** = 이전 컴포넌트의 per-vector fill 오버라이드 잔재(어두운 variant→밝은 variant 인데 일부 벡터가 어두운 색). → `inst.resetOverrides()` 후 `get_screenshot` 확인.
2. **auto-layout 리스트에 항목 추가 시 FIXED 높이 수동 확장 금지** = 콘텐츠 auto-grow + 높이 추가 → 팬텀 여백(`primaryAxisAlignItems=MAX` 면 상단 빈공간). → 컨테이너 `primaryAxisSizingMode='AUTO'`(HUG).
3. **★ 삽입/clone 후 높이 붕괴·흰 여백 = hug 미처리(가장 잦은 삽입 에러).** 컴포넌트를 auto-layout에 append하면 종종 ① `layoutGrow=1`/`lsV='FILL'`로 **높이가 1px로 붕괴**(숨겨져 보임), ② FIXED 프레임이 visible 콘텐츠보다 훨씬 커서 **흰 여백**(완료헤드처럼 hidden 자식 자리 남음)이 생긴다. **휴리스틱: 화면에 흰 여백이 많거나 컴포넌트가 안 보이면 hug 결함을 의심**한다. → **삽입 후 hug 검증·자동수정**: auto-layout 자식이면 `layoutGrow=0` + `layoutSizingVertical='HUG'`(프레임이면 `primaryAxisSizingMode='AUTO'`). 이 검증은 `storyboard-build` §9 #9로 **마감 시 자동 audit**된다. 점검 스크립트: `scripts/hug-fix.js`(대상 노드 `n`에 바인딩해 실행).
- 같은 계층 구조의 컴포넌트만 `swapComponent` 가능. 구조가 다르면 수동 교체 후 "수동 확인 필요" 명시.
- **교체 시 옛 요소는 완전 삭제.** 새 인스턴스를 옛 그룹 위에 얹지 말 것(잔여 stroke/fill/radius/padding → 이중 테두리·겹침).
- **★ swap/교체 대상은 하드코딩 노드 ID 금지 — 내용·역할로 탐지.** 타일·카드·반복 요소의 자식 ID가 **균일(타일마다 +N)하다고 가정하면 엉뚱한 노드를 건드린다**(실패: 국기 교체 시 row2 이모지 ID를 +4 균일로 가정 → 실제론 국가명 ID라 **국가명을 이모지로 착각해 숨김**). 각 컨테이너 안에서 **역할로 찾는다**: 이모지=`/[\u{1F1E6}-\u{1F1FF}]|\p{Extended_Pictographic}/u`(**국기 이모지는 Regional Indicator라 `Extended_Pictographic`만으로는 못 잡음**), 카운트=키워드(`개`/`상품`), 이름=나머지 텍스트. 교체 후 **이모지 노출 0 · 이름 노출 유지**를 반복 컨테이너 전수 검증(반복 요소는 한 곳만 보지 말 것).

## G. 심볼(INSTANCE) 내부 수정이 안 먹힐 때
아이콘·텍스트·색상 수정이 반영 안 되면 대상이 컴포넌트 인스턴스 내부다.
- **판별**: 노드 id에 `I`·`;`(예 `I32:3259;8:5128`) 또는 `type==='INSTANCE'`.
- 같은 컴포넌트 인스턴스가 여러 개(반복 행·카드)면 **전부 순회**. **같은 의미 요소가 화면마다 다른 컴포넌트로 렌더될 수 있으니("컴포넌트"가 아니라 "요소" 기준 전 화면 점검) — 목록의 INSTANCE_SWAP 아이콘 vs 상세의 독립 썸네일).**
- ① INSTANCE_SWAP/오버라이드 있으면 `inst.setProperties(...)` → ②-a 직접 인스턴스는 `inst.swapComponent(...)` → ②-b 잠금으로 불가하면 `detachInstance()` 후 직접 교체. 수정 후 `get_screenshot` 으로 전 인스턴스 시각 검증(메타데이터 카운트만 믿지 않는다).
