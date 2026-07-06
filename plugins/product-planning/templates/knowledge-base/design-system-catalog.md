# 디자인 시스템 부품 카탈로그 (design-system-catalog)

> 화면 조립 시 **필드/패턴 → 어떤 DS 컴포넌트**를 쓸지의 "부품 번호표". `figma-design` 스킬 §L·§M이 조회한다.
> **정본 = 워크스페이스** `.planning/knowledge-base/design-system-catalog.md`(팀이 직접 큐레이션·수정). 이 템플릿은 **플러그인 기본 시드**(🔫HPDS_1.0)다 — 다른 팀은 자기 디자인시스템 값으로 교체.
> **규칙(언제 무엇을 쓰나·조립 방식·clone-override 함정)은 `figma-design` 스킬에 있고, 여기엔 구체 식별자만** 둔다. 본문 디스크립션엔 이 컴포넌트명을 쓰지 않는다(`design-description` §4).

## 사용 규약 — 부품 유형 2분류 + 방어적 해석 순서 (이식성)
**모든 픽스 부품은 아래 둘 중 하나다. "없다/미게시"로 단정하지 말 것 — 유형을 확인하라.**
- **keyed(키형)**: 단일 게시 컴포넌트. `라이브러리 키`로 import. 기계용 링크는 `sources.json` `figma.design_component_keys`(빌드가 직접 조회).
- **composite(조립형)**: 단일 게시 키가 **원래 없는** 것(예 M-2 Message·M-7 detail·M-8 empty). **bespoke가 아니다** — DS 원자(텍스트스타일·`title_detail/18`·`ico40/empty` 등 게시 원자)를 §C-결과/§M 레시피로 조립한다. `atoms` 레시피를 따르면 DS 일관성 유지.

**해석 순서(키형):**
1. `design_component_keys`/카탈로그 `라이브러리 키` → `importComponentByKeyAsync(key)` → `createInstance`.
2. 1 실패 → **`search_design_system`로 `컴포넌트 이름` 재검색(게시 여부 재확인)**. 찾으면 import + **키를 카탈로그·레지스트리에 기록**(다음부터 즉시).
3. **found-but-unsubscribed**(그 컴포넌트가 특정 라이브러리에만 있고 대상 파일 미구독) → **STOP + "Assets→Libraries에서 <라이브러리> 추가" 요청.** (예: `popup`·`notification`은 🌸 HDS 3.0 소속.)
4. 진짜 부재 → **STOP + 게시 요청**. **조용히 bespoke로 그리지 않는다**(silent bespoke 금지 — 부득이하면 build-log·보고에 ⚠️ 플래그).
- ★ **구독 프리플라이트(빌드 시작 시 1회)**: `get_libraries`로 대상 파일 구독 목록을 읽어, `design_component_keys._libraries`가 요구하는 라이브러리(HPDS·HDS 3.0 등)가 **다 구독됐는지 화면 그리기 전에 확인**. 빠지면 위 3처럼 먼저 요청(중간 "key not found"·bespoke 사전 차단).
- ★ **harvest(키 수확·재현 가능)**: 카탈로그 키가 비었거나 낡았으면 손으로 노드 뒤지지 말고, 소스 DS 파일의 **게시 인스턴스 `getMainComponentAsync().key`+`.remote`+소속 라이브러리를 스캔해 레지스트리를 채운다**(`figma-design` harvest 루틴). DS 갱신 시 재실행.
- ⚠️ **"미게시"는 시점 추정이지 영구 사실이 아니다** — 매 빌드 2(재검색)로 게시 여부를 재확인. 과거 사고: M-2/3/5/6를 "미게시·키없음"으로 캐시해 매번 bespoke.

## 라이브러리 / 소스 파일 (실제 키는 `sources.json`에서 관리)
| 구분 | 참조 | 비고 |
| --- | --- | --- |
| DS 라이브러리(키형 import 대상) | `sources.json` `figma.design_system_files` | 기본값 🔫HPDS_1.0 — 소비 파일에 **구독** 필요 |
| 작업 파일(clone형 노드의 origin) | `sources.json` `figma.storyboard_template_file` | clone 소스 노드(아래 `409:…`/`514:…`/`577:…`)가 존재하는 파일 |

> 파일키는 카탈로그에 하드코딩하지 않는다(환경별로 다름) — 위 `sources.json` 경유로 해석.

---

## 입력 (Input)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 입력·선택·필드 라벨 합성(상위 타이틀+입력+안내/에러) | `f1df80617cffbbb72a113fc1f6e4e4b8b002e226` | (정본 인스턴스 clone 권장) | `use_form` | 프로퍼티 수십 개라 정본 clone 후 텍스트·visible만 오버라이드. 주요: `타이틀#…`·`Show EL_input/Default#…`·`essential#…`·`error_message#…`/`Information_message#…`·`sub_title#…`. 타이틀 텍스트=내부 `Title Text` 직접 |
| 안쪽 입력 필드(텍스트·휴대폰·이메일·금액) | — | — | `EL_input/*` | variant: default/typing/end/disabled/error. ⚠️ `EL_input_big`=멀티라인 텍스트영역(금액필드 아님) |

## 셀렉트 (Select)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 통신사·국가 등 선택 입력 | — | `448:5318`(안쪽 `EL_Select_Flag`, status swap `448:5312`) | select `use_form` / `EL_Select_Flag` | 셰브론(▼) **내장**(bespoke `▾` 금지). 국가가 아니면 `-아이콘#34811:13=false`(앞 국기 off) + 채워진 값 `flag_ellipse` `visible=false` |

## 바텀 CTA
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 바텀 고정 1차 액션(풀폭) | `8ed6cf4ff1be3524b921d89b0090389d9d5f9969` | — | `btn54_main_set` | `Property 1`: Default/disabled/sub/icon+btn54. 라벨=`Text#35060:3`. raw 버튼·`btn60` 금지 |

## 탭 (1-depth · 언더라인)  (M-9)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 화면 1차 분류 탭(상품 유형·사용/만료 등) | active `65977f0147f60808b9ac405b68b8b64be667749a` · unselected `311a01348d99ff2def2fb81f558b468124742c4b` | 컨테이너 `514:8011`(`EL_tap_set_main`) | `EL_tab_1deapt/active`·`/unselected` | 항목 수만큼 아이템 인스턴스를 가로 컨테이너에 조립. 라벨=내부 `Tab Text`(직접 오버라이드·폰트 로드). 카운트 뱃지(`10건`) 불필요 시 `visible=false`. 선택=active 1 |

## 칩 (2-depth · 필 탭)  (M-10)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 필터/세그먼트 칩(지역·기간 등) | on `4237ca630836721b4c3287d6f840700e8ef4e908` · off `22572897527e4e2cef06a1c912e5b09a9b7add48` | 컨테이너 `514:8012`(`tab_2dept`) | `EL_tab_2deapt/on`·`/off` | 항목 수만큼 인스턴스 조립. 라벨=내부 `Tab Label`. 선택=on 1. **직접 그린 pill/chip 금지** |

## 팝업 (Popup)  (M-5)  ★게시됨(🌸 HDS 3.0 — 대상 파일 구독 필요)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 실행 전 확인 다이얼로그 **및 서버 응답 에러** | **`a0fe298355e1f156d582b5ddd968b188565f3ff4`**(🌸 HDS 3.0, `ui/popup`) | `409:5709` | `ui/popup` | 본문 + 취소/확인 2버튼·Link text 내장(320w). 불필요 요소(잔액·에러줄·링크)는 `visible=false`. **⚠️ HDS 3.0 미구독 파일 import 실패 → 라이브러리 추가 후**. ⚠️인스턴스 mainComponent 키(`f844c8e4`)≠게시 키 — `search_design_system`이 1차 |

## 바텀시트 (BottomSheet)  (M-3 · M-4)  ★게시됨(키 import 확인)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 시트 컨테이너(래퍼) | **`2701fa45f0b46a8e62cb7871bd6a8c0fcc49562a`**(HPDS, import 확인✓) | `409:6368` | `bottom_sheet_main` | 헤더(Close+`Title`) + 콘텐츠 슬롯 + Gradient + Home Indicator. 375폭 |
| 셀렉트 리스트(모든 select 탭 시 공통) | **`a878e543409124be90e722b238bce24fa712842e`** | `409:6376` | `EL_bottom_sheet/셀렉트기본` | 컨테이너 콘텐츠에 얹는 옵션 리스트(327폭) |
| 세부 안내 시트("자세히/이용안내") | `3364e0f751667f0dda61038da88d77b6e278938e`(🌸 HDS 3.0) | `409:5707` | `EL_bottom_sheet/로그인 안내` | 아이콘+타이틀 헤더 + STEP 본문 + 하단 버튼. **HDS 3.0 구독 필요** |

## 인포박스 (안내)  (M-6)  ★게시됨(🌸 HDS 3.0 — 대상 파일 구독 필요)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 안내 문구(평문 캡션 금지) | **`08748b0996b413bdacf71e508b1e000c852d5fcb`**(🌸 HDS 3.0, SET) | `409:5877` | `notification` (set) | `importComponentSetByKeyAsync` → variant `Type=blue/gray/red × Title=True/False`. 아이콘+텍스트, radius12. **red=부정·blue=긍정·gray=중립**. trailing "알림 설정>"(Frame+chevron)은 정적 안내엔 `visible=false`. **⚠️ HDS 3.0 구독 필요**. ⚠️인스턴스 키(`1a1addd7`)≠게시 세트 키 |

## 상세 내역 (detail)  (M-7)  ★composite(조립형 — 단일 키 없음, DS 원자 조립·bespoke 아님)
| 용도 | 게시 원자(키) | clone 소스 노드 | 조립 레시피 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 결과 화면 핵심 데이터(계좌·금액 등) | `title_detail/18` **`595d454f294e60560ebb561f2be8f3adea26fde0`**(HPDS) | `409:5534` | 라벨+값 행(`title_detail/18`) 반복 + divider, bg `🌈bg/03(f4f7fd)`·radius12·pad20/22 | 강조값 primary. **bespoke 요약카드 금지 — 게시 원자 조립** |

## 빈 상태 (empty)  (M-8)  ★composite(조립형 — 단일 키 없음, DS 원자 조립)
| 용도 | 게시 원자(키) | clone 소스 노드 | 조립 레시피 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 리스트/검색 결과 없음 | `ico40/empty` **`42873e176783f907a36572dc2a86556f09baea53`** | `409:6567`(327×232) | 아이콘(`ico40/empty`) + 안내 타이틀(텍스트스타일) (+숨김 서브/CTA) | 컨텐츠 영역 중앙. 타이틀만 교체 |

## 결과 타이틀+서브 (Message)  (M-2)  ★composite(조립형 — 단일 키 없음, 전부 DS 텍스트스타일)
| 용도 | 게시 원자(텍스트스타일) | clone 소스 노드 | 조립 레시피 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 완료·실패·대기 결과 메시지 | `Title/H1_B_24`·`Title/H4_B_18`·`Body/P3_R_14`(HPDS 텍스트스타일, §K) | `409:6524`(`Message` `409:6526`) | Message(center·gap16) = Container(gap12)[타이틀 H1·gray700 + 서브 H4·primary500] + 본문 P3·gray600 | **원자가 전부 DS 토큰이라 bespoke 아님** — §C-결과 패턴. 단일 컴포넌트로 게시된 적 없음 |

## PIN / 비밀번호 입력 화면  (M-11)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| PIN/결제비밀번호 입력 | `75adbdeaacdbbf13bca84dbea67c4374b1a93ad3` | `577:5988`(375×812) | `PIN_004 PIN 비밀번호 입력` | 헤더+6자리 도트+숫자 키패드(0-9·삭제·생체)+변경 링크 **내장**. clone 후 헤더/타이틀/안내만 오버라이드. **bespoke 키패드·도트 금지**. ⚠️ 내부 상태바 `SF Pro Text`(미로드)면 loadFont try/catch |

## 국기 이미지  (M-12)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 국가/지역 표시 | 예 일본 `jp` `91d09dc940c7c67db44b7e46a623c61439a0773e`(모음 `🌸[common] 2. Flag`) | — | HDS 3.0 `icon_flag//{ISO코드}` | 사용 국가코드로 `search_design_system("flag {code}")` → key import. **emoji(🇯🇵)·bespoke 국기 금지** |

## 필터·총 개수  (M-13)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 리스트 상단 결과 수 + 정렬 | `c412841ea3a5840663a97374f7ce4405dbc498cc` | `577:6685` | `main_icon/total_set` | `총 [Count]건/개` + 정렬 버튼(거리순 등). `Count`·정렬 라벨만 오버라이드. bespoke "총 N개·정렬" 텍스트 금지 |

## 뱃지 (Badge)  (M-14)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 상태/속성 라벨 — 작은 필(높이 20) | `2f317e64f15e2579d3206f60f464369fd498fab7` | `32146:209810` | `badge20` | property1: default `blue` / `black_20` / `blue_blue` / `black_20_squere` / `gray` / `red` / `green`. 필(radius100)·px8 py3. 라벨 텍스트만 오버라이드. 텍스트 `Caption/C1_R_12`(12px). bespoke 태그 금지 |
| 상태/속성 라벨 — 큰 박스(높이 24) | `5949e86f1d8e37a710d89e985753581172abf003` | `32146:209811` | `Badge` | property1: default `gray_line` / `blue` / `default` / `fill_black_op40` / `green` / `red` / `blue_blue` / `fill_blue`. radius12·px8 py5. `fill_*`=강조(흰 텍스트)·`*_line`/연배경. 텍스트 `Caption/C1_R_12`. ⚠️large는 set 이름이 `Badge`(대문자)로 매칭 — 적용 전 1회 확인 |

## 약관 동의 (Agreement)  (M-15)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 전체동의 + 개별 약관 체크리스트 | `0c9e5192b229d7b578bd9431870148de893157f7` | `35412:300417` | `Agreement` | "모두 동의" 헤더(`Title/H5_B_16`) + `EL_Agreement` 행들. show 토글로 행 수 조절, 각 행 = `[필수]` 라벨(`Body/P3_R_14`) + 체브론(상세 열기). 라벨·행 수만 오버라이드. 개별 행 컴포넌트 = `EL_Agreement`(set, 키 `c4f40f92dc42de2e75678e29edac5486c9e70f70`, property1 `text`/`title`). 체크 아이콘 `EL_agreement_check_big`/`_normal`. bespoke 체크리스트 금지 |

## 섹션/폼 타이틀 (title 패밀리)  (M-16)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| Body 제목 화면 표준(제목 24px + 설명 16px) | `edd62871bbf29690cfed1c10140a9fb9e67eca9f` | — | `title/24_16` | 타이틀(24px) + 설명(16px). **`figma-design` §47·§49 "제목 화면 = Body에 `title/24_16`"이 이 부품** — 스킬엔 이름만 있고 카탈로그 키가 미등록이던 갭을 키로 확정. ++Top/Body/++Bottom 골격의 Body 제목 |
| 작은 폼/섹션 제목(제목 18px + 설명 16px) | `cf794f679b4141a6b2c83191c34348651f322df5` | `35595:67048` | `title/18_16` | 타이틀(`Title/H4_B_18`·gray900) + 설명(`Body/P2_R_16`·gray600, `showDescriptionText`로 on/off). 두 텍스트만 오버라이드. **결과 화면 타이틀은 M-2 `Message`** |

> **위계로 택1.** 둘은 크기 위계 — 한 화면엔 위계에 맞는 **하나만** 쓴다(`24_16`=화면 주제목 / `18_16`=하위 섹션·폼 제목). 같은 자리에 겹치지 말 것. 주제목 + 독립 하위섹션 제목 공존은 복합 화면에서만 예외.

## 인라인 텍스트 버튼 (btn_text)  (M-17)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 인라인 보조 액션(번역·더보기 등 밑줄 텍스트) | ⚠️미확인(아래 메모) | `30964:16290` | `btn_text_12` | 밑줄 텍스트(`Caption/C1_R_12`·gray700) + 선택 아이콘(`showIcon16`). 라벨·`showIcon16` 오버라이드. ⚠️12px 퍼블리시 키가 `search_design_system`에 안 떠 미확인 — 14px 자매 `btn_text_14`=`b75744829a2b391668445e846c95e672bd10ca94` 확인됨. 12px 퍼블리시 여부 확인 후 키 채우고, 없으면 이름검색/clone 폴백 |

## 배너형 진입 버튼 (Button_68)  (M-18)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 아이콘+텍스트+화살표 배너(홈/리스트 진입 항목) | `d210cab183773d86fd61024014bdd1c81539880f` | `35461:69338` | `Button_68` | 480×68. icon40(좌) + 라벨(`Body/P1_R_18`·gray900) + 체브론 `icon16`(우). white·gray200 라인·radius8. 아이콘·라벨만 오버라이드. bespoke 배너 금지 |

## 그리드 메뉴 항목 (menu)  (M-19)  ★clone형(미퍼블리시)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 국기/아이콘 + 라벨 그리드 셀(국가 선택 등) | — | `37101:97712` | `menu` | `icon_flag`(40) + 라벨(`Body/P3_R_14`·gray800·center), 70w 세로. 국기·라벨만 오버라이드. ⚠️라이브러리 미퍼블리시(search 0) → origin-file clone 또는 **M-12 `icon_flag//{ISO}`(키형) + 라벨** 조합으로 구성 |

## 화면 크롬 — ++Top/++Bottom 시스템 골격  (M-20)
> `figma-design` §C(++Top/Body/++Bottom)가 이름으로 참조하던 공통 골격. 화면 외곽 프레임·시스템 바.
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 노치 프레임(아이폰 상단) | `deb65083b62f6b3505dc350f39933495786f0fd6` | — | `EL_iPhone with Notch` | `++Top` 최상단 디바이스 프레임 |
| 상태바+홈바(오토레이아웃 미사용) | `82c978941dae87467d55d118d6ae83ea9415d185` | — | `Essential` | Status Bar + Home Bar(Home Indicator) 묶음. `++Top` 상단 / `++Bottom` 하단 시스템 바 |
| 공통 24px 아이콘(체브론 등) | `6629c76bd797262456aba5f3864bedecc3f4d3a9` | — | `icon24` (set) | 헤더/리스트 아이콘. variant로 선택 |
| 상단 앱바(헤더) | ⚠️확인 필요 | (예시 `36146:106685` Top Module) | `header/main` | HPDS `search`에 미surface — 별칭/clone 가능성. 백·X·타이틀 헤더. `app_loan_012` Top Module(§C 정본) 참조해 적용 후 키 확정 |
| 하단 탭 내비 | ⚠️HPDS 미확인 | — | `UI/Navigation Bar` | 목록/홈 하단 탭. HPDS `search` 0(타 라이브러리만 존재) → 작업 파일 clone 또는 사용자 확인. **타 라이브러리 혼용 금지**(`figma-design` §83) |

## 결과 상태 일러스트 (Glassmorphism)  (M-21)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 완료·처리중·실패 글래스 일러스트(~240×154) | `1914373c1111750bc38d04c20f15e64de1f60897` | — | `Glassmorphism` (set) | variant: 완료=`Pass_Image` / 처리중·대기=`wait_Image`(시계) / 실패=`error`. `figma-design` §C-결과 화면 Content. ⚠️미퍼블리시 시 import 실패 → §H 게시 요청(직접 그리지 말 것) |

## 선택 표시 (Radio / Checkbox)  (M-22)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 단일 선택(라디오 박스) | `d51deca210b1b614bdbb823545497324faa1cf10` | — | `EL_Radio_box` (set) | 직접 그린 원 금지(§H). 2줄 케이스 = `Radio_box_set/2줄케이스`(`55c774a44f65e947fed8bc2ed22c3f08ebc5a7d6`) |
| 체크박스(약관/멀티) | `f24bd9878684f79fd4f90dbe8929d366cb5214cf` | — | `EL_agreement_check_normal` (set) | 큰 체크 = `EL_agreement_check_big`(`c5903c01179b5c06bbae594b25c00b05c1d9a655`). 약관 묶음은 M-15 `Agreement` 가 내장 |

## 스토리보드 정본 세트  (M-23)  ★ 3세트 골격의 반입 소스 (그린필드 발명 금지)
> 빈 파일에서 SB_Templates+SECTION+Description 3세트 **골격**을 새로 그리지 않는다 — 아래 게시 부품을 `importComponentByKeyAsync`로 반입한다(`figma-design` §A·§D·§M-23). 실제 키는 `sources.json` `figma.storyboard_component_keys`에서 관리(여기 표는 매핑·용도). 정본 파일은 `figma.storyboard_template_file`.

| 부품 | 실제 컴포넌트명 | `sources.json` 키 | 용도 · 메모 |
| --- | --- | --- | --- |
| SB_Templates 보드(전체) | `Type=Version` | `sb_board` = `9472a0125f69b66831f6dc2f8b30975c601c3c19`(remote) | 1920×1347 보드형(`[화면 ID]`+화면명·Links·Version·Update 뱃지). SB 라벨은 리플로우가 섹션명에서 동기화 |
| SB_Templates 보드(기본) | `Type=Basic` | `sb_board_basic` = `7075f69459219de5f15afde77d5981740457d136`(remote) | 1920×1080 간이 보드 변형 |
| 주석 단위(=annotation-frame) | `Description` | `annotation_frame` = `e4ed031c5f888f59db320dd23a298285657b6c41`(remote) | 411폭 주석 1행(뱃지+제목+본문). 화면 배지 수(N)만큼 인스턴스, 텍스트만 오버라이드 |
| 번호 뱃지(=label-group) | `Badge` | `label_group` = `b043d929e3d19a7080495d05e23e17a833dd83b6`(remote) | 40×40 번호 뱃지. 액션 요소마다 인스턴스(최상위 z) |
| SECTION | (일반 SECTION, 컴포넌트 아님) | `section` = clone | 1375폭·`#000000 10%` 틴트 컨테이너. 정본 행 clone 또는 규격 생성 |
| Description 패널 | (일반 FRAME, 컴포넌트 아님) | `description_panel` = clone | 459폭 주석 패널. 정본 행 clone 후 안의 `Description`(annotation) 인스턴스 N개로 채움 |

> ⚠️ 이름 주의: 정본 라이브러리에서 **주석 1행 컴포넌트 이름이 `Description`**(411폭)이고, 이를 담는 **459폭 패널은 동명의 일반 프레임**이다(중첩 동명). 뱃지 컴포넌트명은 `Badge`(=우리가 부르던 label-group).

## 레이아웃 규칙 참조  (M-1)
| 용도 | 값 | 비고 |
| --- | --- | --- |
| body 콘텐츠 좌우 거터 | **24** | 컴포넌트가 아닌 레이아웃 규칙(상세는 `figma-design` §C). 고정 헤더/풋터 제외 |
