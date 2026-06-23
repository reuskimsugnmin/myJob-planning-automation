// design-description §5 작성 검증 — 자동 판정 가능한 객관 휴리스틱 (B-2 형식·B-3 컴포넌트명·B-4 얕음).
// 각 annotation 본문(body)·제목(title)에 바인딩해 실행. (A 개수·B 의미·C dev-readiness는 산문/스크린샷 판단 → SKILL §5 본문 참조.)

// --- (B-2) inline 드리프트: 본문에 '['가 있으면 줄바꿈 수 ≥ 대괄호 수여야 한다(미만이면 inline → 줄바꿈 재배치) ---
const inline = (c.match(/\n/g)||[]).length < (c.match(/\[/g)||[]).length;   // true면 교정

// --- (B-3) 컴포넌트명 누출: Figma/DS 컴포넌트 이름이 섞이면 미통과 → 사용자-기능 표현으로 교체 ---
const leak = /\bui\/detail\b|\bbtn54\b|\buse_form\b|EL_[A-Za-z]|EL_tab|total_set|Glassmorphism|main_icon|icon_flag|\bnotification\b|\[컴포넌트\]|Frame \d|Property 1/.test(body);   // true면 교정

// --- (B-4) 얕음("역할 한 줄") 탐지: 인터랙티브 요소는 대괄호 섹션 2개 이상이어야 한다 ---
const isInteractive = /버튼|CTA|입력|필드|금액|탭|칩|카드|토글|체크|라디오|선택|셀렉트|링크/.test(title);
const shallow = isInteractive && (body.match(/\[/g)||[]).length < 2;   // true면 보강(정적 라벨·아이콘은 §4-b1 면제라 제외)
