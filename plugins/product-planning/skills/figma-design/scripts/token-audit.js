// figma-design §K — authored(인스턴스 외부) 노드 raw 검사
let badFill=0,badText=0;
for(const n of sec.findAll(x=>x.type==='FRAME'||x.type==='RECTANGLE')){ if(insideInstance(n)||n.name==='text-area')continue; const f=n.fills&&n.fills[0]; if(f&&f.type==='SOLID'&&!(f.boundVariables&&f.boundVariables.color))badFill++; }
for(const t of sec.findAllWithCriteria({types:['TEXT']})){ if(insideInstance(t)||!t.textStyleId)badText++; }
// badFill==0 && badText==0 이어야 마감
