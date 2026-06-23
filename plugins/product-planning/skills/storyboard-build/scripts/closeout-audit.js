// storyboard-build §9 — 자동 마감 검수 게이트 7항목 중 스크립트화된 4개(#1·#2·#7·#8). 각 섹션 독립 실행.

// --- #1 DS 커버리지 — authored 비-콘텐츠 UI에 bespoke 잔재 0 ---
const bad=[]; for(const sec of page.children.filter(c=>c.type==='SECTION'))
 for(const n of sec.findAll(x=>['FRAME','RECTANGLE','ELLIPSE','VECTOR'].includes(x.type))){ if(insideInstance(n))continue;
   if(/chip|tab|btn|button|toggle|radio|checkbox|select|input|badge|card|pill|switch/i.test(n.name)) bad.push(sec.name+'/'+n.name); }
// bad=[] 이어야. 남으면 figma-design §M/§L 정본 컴포넌트로 교체(인풋=use_form·탭/칩=M-9/10·버튼=btn54…)

// --- #2 액션 배지 완전성(★ 카운트 아님 — 요소별 배지 실재) — 인터랙티브 요소 ↔ 최근접 배지 대조(미스 리포트) ---
const acts=sec.findAll(n=>n.visible&&/btn|button|EL_input|use_form|tab$|chip|EL_tab|product-card|toggle|radio|checkbox|EL_Select|Close|닫기|확인|취소/i.test(n.name)&&!insideInstance(n.parent));
const badges=sec.children.filter(c=>c.name==='label-group').map(b=>b.absoluteBoundingBox);
const miss=acts.filter(a=>{const ab=a.absoluteBoundingBox;return !badges.some(b=>Math.hypot((b.x+b.width/2)-(ab.x), (b.y+b.height/2)-(ab.y))<120);});
// miss=[] 이어야. 남으면 해당 요소 위에 배지 추가(양식은 design-description badge-matching)

// --- #7 컴포넌트 무결성 — authored 최상위 INSTANCE 전수(detach 0·override 유지) ---
const broken=[]; for(const sec of page.children.filter(c=>c.type==='SECTION'))
 for(const inst of sec.findAll(x=>x.type==='INSTANCE')){ if(insideInstance(inst))continue;
   const mc=await inst.getMainComponentAsync(); if(!mc){broken.push(inst.id+' DETACHED');continue;}
   if(inst.children&&inst.children.length===0)broken.push(inst.id+' EMPTY'); }
// detach/empty 0. + get_screenshot로 swap 잔재(이중테두리·팬텀여백·색 이상=figma-design §F)·텍스트 오버라이드 유실 육안 확인

// --- #8 SB 라벨 == 섹션명 — 불일치는 figma-design §A 리플로우 4단계 재실행으로 자동 교정 ---
for(const sb of page.children.filter(c=>c.type==='INSTANCE'&&c.name==='SB_Templates')){
  const sec=page.children.find(s=>s.type==='SECTION'&&Math.abs(s.absoluteBoundingBox.y-(sb.absoluteBoundingBox.y+142))<60); if(!sec)continue;
  const sp=sec.name.indexOf(' '), id=sp>0?sec.name.slice(0,sp):sec.name, title=sp>0?sec.name.slice(sp+1):sec.name;
  const idT=sb.findOne(n=>n.type==='TEXT'&&n.name==='[화면 ID]'), tiT=sb.findOne(n=>n.type==='TEXT'&&n.name==='화면 / 기능명');
  if(idT&&idT.characters!=='['+id+']') /* mismatch → 리플로우 */; }
