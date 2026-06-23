// storyboard-build §8 — 완료 조건: bbox 교차 0 (node.height/y+height 금지, absoluteBoundingBox + 자식 콘텐츠 최대 extent로 계산)
function realBottom(n){const b=n.absoluteBoundingBox;let m=b.y+b.height;if(n.children)for(const c of n.children){const cb=c.absoluteBoundingBox;if(cb&&cb.y+cb.height>m)m=cb.y+cb.height;}return m;}
const E=page.children.filter(c=>c.type==='SECTION'||(c.type==='FRAME'&&c.name==='Description')).map(c=>{const b=c.absoluteBoundingBox;return {n:c.name,x:b.x,y:b.y,r:b.x+b.width,bot:realBottom(c)};});
let hit=0; for(let i=0;i<E.length;i++)for(let j=i+1;j<E.length;j++){const a=E[i],z=E[j];if(Math.min(a.r,z.r)-Math.max(a.x,z.x)>5 && Math.min(a.bot,z.bot)-Math.max(a.y,z.y)>5)hit++;} // hit===0 이어야 마감
