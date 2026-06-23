// figma-design §F.3 — 삽입/clone 직후 또는 마감: 붕괴(<6px)·흰여백(height>visible콘텐츠+32) 자동수정.
// ★ FRAME뿐 아니라 INSTANCE도 — 컴포넌트 인스턴스가 콘텐츠보다 훨씬 큰 흰여백이 잦다(total_set 177→50 사례).
const content=(n)=>{let b=0;for(const c of (n.children||[])){if(c.visible===false)continue;const cb=(c.y||0)+(c.height||0);if(cb>b)b=cb;}return b;};
const inAL = n.parent && (n.parent.layoutMode==='VERTICAL'||n.parent.layoutMode==='HORIZONTAL');
if(inAL && n.height<6 && n.children?.some(c=>c.visible!==false&&c.height>2)){ n.layoutGrow=0; try{n.layoutSizingVertical='HUG'}catch(e){if(n.type==='FRAME')n.primaryAxisSizingMode='AUTO'} }   // 붕괴
else if(inAL && content(n)>0 && n.height>content(n)+32){ n.layoutGrow=0; try{n.layoutSizingVertical='HUG'}catch(e){if(n.type==='FRAME'&&n.layoutMode)n.primaryAxisSizingMode='AUTO'} }      // 흰여백(FRAME·INSTANCE 공통)
