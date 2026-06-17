---
name: gdrive-explore
description: Google Drive 문서(특히 Gemini가 생성한 Google Meet 자동 회의록 Google Doc)를 Google Drive MCP로 읽는 방법론. 문서 URL에서 file id를 해소하고, 본문을 읽어 요약·결정·액션아이템 구조를 파악한다. meeting-synthesis(회의록 종합)가 Google Doc 소스를 다룰 때 따른다.
---

# Gdrive Explore (Google Doc/Drive 읽기)

Google Drive "읽기"의 단일 소스. 사내 계정 인증이 필요하므로 WebFetch가 아니라 **Google Drive MCP**로 읽는다.
파일은 쓰지 않는다 — 저장은 `knowledge-base`(source-manifest), 분석·문서화는 호출자 스킬이 한다.

## 1. URL 해소
- Google Doc URL 예: `https://docs.google.com/document/d/<FILE_ID>/edit`. `/d/<FILE_ID>` 가 file id.
- 폴더에서 찾을 땐 `search_files`(예: `sources.json` 의 `gdrive.meeting_notes_folder`) 로 좁힌다. 메타는 `get_file_metadata`(제목·수정일).

## 2. 읽기
- `read_file_content`(file id)로 본문을 읽는다(필요 시 `download_file_content`).
- **Gemini 자동 회의록 구조**를 인식: 요약(Summary)·핵심 논의·결정 사항·액션 아이템·전체 transcript. **결정·합의·액션·변경 요청** 위주로 추리고, 긴 transcript는 근거가 필요할 때만 참조.

## 3. 출처 / 적재
- 모든 사실에 **문서 URL**(+ 섹션) 인용. 작성일/수정일(`as_of`) 기록.
- 읽은 소스는 `source-manifest` 에 type=`gdrive` 로 기록(URL·as_of).

## 원칙
- 출처 없는 단정 금지. 접근 불가 문서는 정직하게 보고하고 사용자에게 권한/링크 재요청.
- 회의록 해석이 모호하면 자의적으로 단정하지 말고 호출자(meeting-synthesis)의 확인 게이트로 넘긴다.
