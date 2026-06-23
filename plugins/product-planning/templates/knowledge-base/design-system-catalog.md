# 디자인 시스템 부품 카탈로그 (design-system-catalog)

> 화면 조립 시 **필드/패턴 → 어떤 DS 컴포넌트**를 쓸지의 "부품 번호표". `figma-design` 스킬 §L·§M이 조회한다.
> **정본 = 워크스페이스** `.planning/knowledge-base/design-system-catalog.md`(팀이 직접 큐레이션·수정). 이 템플릿은 **플러그인 기본 시드**(🔫HPDS_1.0)다 — 다른 팀은 자기 디자인시스템 값으로 교체.
> **규칙(언제 무엇을 쓰나·조립 방식·clone-override 함정)은 `figma-design` 스킬에 있고, 여기엔 구체 식별자만** 둔다. 본문 디스크립션엔 이 컴포넌트명을 쓰지 않는다(`design-description` §4).

## 사용 규약 — 방어적 해석 순서 (이식성)
컴포넌트를 적용할 때 아래 순서로 해석한다. **타 사용자 환경(라이브러리 미구독·다른 파일)에서도 에러로 죽지 않게**:
1. **키형**(`라이브러리 키` 있음) → `importComponentByKeyAsync(key)` → `createInstance`.
2. 1 실패(라이브러리 미구독/키 변경/재퍼블리시) → **`search_design_system`로 `컴포넌트 이름` 재검색**(그래서 이름 칸이 필수).
3. **clone형**(`clone 소스 노드`만 있고 키 없음) → 현재 작업 파일에 **그 노드가 실재하는지 먼저 확인** → 있으면 clone, 없으면 시도하지 않는다(null clone 방지).
4. 1~3 모두 실패 → **사용자에게 플래그**("부품 못 찾음 — 라이브러리 구독 또는 카탈로그 갱신 필요"). **조용히 bespoke로 그리지 않는다**(§H 정신).
- 빌드 전 `sources.json`의 `figma.design_system_files` 라이브러리가 구독됐는지 1회 확인(미구독이면 사용자에게 추가 요청).
- ⚠️ **clone형은 origin-file 한정** — `clone 소스 노드`는 아래 "소스 파일"에만 존재한다. 타 파일/타 사용자 환경에선 무효 → 해당 컴포넌트를 **라이브러리로 퍼블리시해 키를 얻기 전까지**, 타 환경에선 2(이름 검색) 또는 4(플래그)로 처리된다.

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

## 팝업 (Popup)  (M-5)  ★clone형(origin-file 한정)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 실행 전 확인 다이얼로그 **및 서버 응답 에러** | — | `409:5709`(`Popup` `409:5711` > `Popup Content` `409:5712`) | `Popup` | 본문 텍스트 + 취소/확인 2버튼(307 폭). 키 없음 → 퍼블리시 전엔 origin-file 한정 |

## 바텀시트 (BottomSheet)  (M-3 · M-4)  ★clone형(origin-file 한정)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 셀렉트 박스 → 리스트 시트(모든 select 탭 시 공통) | — | `409:6368`(안쪽 `EL_bottom_sheet/셀렉트기본` `409:6376`) | `BottomSheet`(셀렉트) | header(Close `icon24` + `Title`) + 리스트 + Gradient + Home Indicator |
| 세부 안내 시트("자세히/이용안내") | — | `409:5707`(`BottomSheet` `409:5708`) | `BottomSheet`(안내) | 아이콘+타이틀 헤더 + STEP 본문 + 하단 버튼 |

## 인포박스 (안내)  (M-6)  ★clone형(origin-file 한정)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 안내 문구(평문 캡션 금지) | — | `409:5877` | `notification` | 아이콘(`ico20/info2`)+텍스트, radius12·pad16/12. **variant 색: red=부정/주의·blue=긍정·gray=중립 안내** |

## 상세 내역 (detail)  (M-7)  ★clone형(origin-file 한정)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 결과 화면 핵심 데이터(계좌·금액 등) | — | `409:5534` | `ui/detail` | 라벨+값 행(`Label_L#35087:22`·`Label_R#35087:23`) + divider, bg `🌈bg/03(f4f7fd)`·radius12·pad20/22. 강조값 primary. bespoke 요약카드 대체 |

## 빈 상태 (empty)  (M-8)  ★clone형(origin-file 한정)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 리스트/검색 결과 없음 | — | `409:6567`(327×232, VERTICAL) | `Frame 1597884660` | 아이콘 + 안내 타이틀(+숨김 서브/CTA). 컨텐츠 영역 중앙, 타이틀만 교체 |

## 결과 타이틀+서브 (Message)  (M-2)  ★clone형(origin-file 한정)
| 용도 | 라이브러리 키 | clone 소스 노드 | 컴포넌트 이름 | 프로퍼티 · 메모 |
| --- | --- | --- | --- | --- |
| 완료·실패·대기 결과 메시지 | — | `409:6524`(`Message` `409:6526`) | `Message` | Message(center·gap16) = Container(gap12)[타이틀 `Title/H1_B_24`·gray700 + 서브 `Title/H4_B_18`·primary500] + 본문 `Body/P3_R_14`·gray600 |

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

## 레이아웃 규칙 참조  (M-1)
| 용도 | 값 | 비고 |
| --- | --- | --- |
| body 콘텐츠 좌우 거터 | **24** | 컴포넌트가 아닌 레이아웃 규칙(상세는 `figma-design` §C). 고정 헤더/풋터 제외 |
