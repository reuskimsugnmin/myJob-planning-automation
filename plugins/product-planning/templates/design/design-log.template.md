# 디자인 작업 로그: {{PRODUCT_TITLE}}
> 단계: {{STEP}} <!-- storyboard-build / design-description / design-sync --> · 일자: {{DATE}} · 담당: {{OWNER}}
> 대상 Figma: {{FIGMA_FILE_URL}} · 모드: {{MODE}}

## 처리 요약
- 추가된 화면: {{ADDED_COUNT}}개 · 수정된 화면: {{UPDATED_COUNT}}개 · 스킵: {{SKIPPED_COUNT}}개

| 화면 ID | 화면명 | 처리 | 소스 화면 |
|---|---|---|---|
| {{SCREEN_ID}} | {{SCREEN_NAME}} | ✅ 신규/✅ 수정/⏭ 존재 | {{CLONE_SOURCE}} |

## 주요 변경
- {{SCREEN_NAME}}: {{CHANGE_SUMMARY}}

## 동기화 결과 (해당 시)
- claim↔노드 3자 매칭(뱃지↔디스크립션↔디자인): 일치 {{MATCH_COUNT}} · 불일치 {{MISMATCH_COUNT}} · SKIP {{SKIP_COUNT}}
- 백업: {{BACKUP_PATH}} <!-- engagements/<slug>/design/backups/backup-<ts>.json -->

## 고도화 체크 (해당 시)
- [ ] UI 토큰 바인딩(figma-design §K): 손작업 텍스트/색 = DS 변수, raw hex 잔존 0
- [ ] DS 컴포넌트 매칭(§L): 입력/선택 = use_form 타입별, 바텀 액션 = btn54_main_set (bespoke 0)
- [ ] 상세 케이스 화면화(storyboard-build §6): 의미있는 분기만, 추가 행 {{CASE_ROWS}}개
- [ ] 수직 리플로우(§A): SB_Templates 밴드 확장 + 행 재적층, 겹침 0

## ⚠️ 수동 확인 필요
- {{MANUAL_ITEM}} <!-- 컴포넌트 교체·레이아웃 미세조정·DS 미보유 자산 등 -->

## 다음 단계
- {{NEXT_STEP}} <!-- /design-desc <slug> 등 -->
