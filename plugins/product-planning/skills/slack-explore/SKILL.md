---
name: slack-explore
description: Slack 스레드/메시지를 Slack MCP로 읽는 방법론. 스레드 URL에서 channel·ts를 해소하고, 상위 메시지+스레드 전체를 읽고, 멘션 유저를 실명으로 resolve하며, 토큰 예산 안에서 핵심만 추린다. meeting-synthesis(회의록 종합)가 Slack 소스를 다룰 때 따른다.
---

# Slack Explore (Slack 스레드/메시지 읽기)

Slack "읽기"의 단일 소스. 사내 워크스페이스 인증이 필요하므로 WebFetch가 아니라 **Slack MCP**로 읽는다.
파일은 쓰지 않는다 — 저장은 `knowledge-base`(source-manifest), 분석·문서화는 호출자 스킬이 한다.

## 1. URL 해소
- 스레드 URL 예: `https://<workspace>.slack.com/archives/<CHANNEL_ID>/p<TS17>?thread_ts=<PARENT_TS>&cid=<CHANNEL_ID>`.
- `archives/<CHANNEL_ID>` 또는 `cid` → **channel id**. `p1781658610314459` → 메시지 ts `1781658610.314459`(뒤 6자리 앞에 소수점). `thread_ts` → 상위 스레드 ts.
- 채널/스레드를 모를 땐 `slack_search_public`/`slack_search_public_and_private` 로 좁힌다.

## 2. 읽기
- `slack_read_thread`(channel + thread_ts)로 **상위 메시지 + 스레드 전체**를 읽는다. 단일 메시지면 해당 ts 기준.
- 길면 토큰 예산 내에서 **결정·합의·액션아이템 위주**로 추린다(잡담 제외).
- 멘션/작성자 `<@U…>` 는 `slack_read_user_profile` 로 실명·역할 resolve(중복 제거).

## 3. 출처 / 적재
- 모든 사실에 **Slack permalink**(channel + ts) 인용.
- 읽은 소스는 `source-manifest` 에 type=`slack` 로 기록(permalink·as_of).

## 원칙
- 출처 없는 단정 금지. 비공개/접근 불가 스레드는 정직하게 보고하고 사용자에게 요청.
- 잡담·오프토픽으로 토큰 낭비하지 않는다(결정/논의 중심).
