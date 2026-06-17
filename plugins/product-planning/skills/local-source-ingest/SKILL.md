---
name: local-source-ingest
description: 로컬 자료(폴더·zip·문서 파일)를 인제스트하는 방법론. zip 자동 해제, 폴더 재귀 순회, 파일 타입별 읽기(md/txt/csv/PDF 본문, Excel/이미지/hwp는 메타만), 동일 기획의 다중 버전 충돌을 최신 기준으로 해소하는 규칙을 규정한다. domain-study·tech-research가 공통으로 따른다.
---

# Local Source Ingest (로컬 자료 인제스트)

로컬 파일 "읽기"의 단일 소스. `Bash`(unzip/find/stat) + `Glob`/`Grep`/`Read` 사용.
읽은 결과의 저장은 `knowledge-base` 스킬, 최종 문서는 호출자 스킬이 한다.

## 1. 입력 해소
- `sources.json` 의 `local.doc_dirs` + 런타임으로 전달된 zip/파일/폴더 경로를 대상으로 한다.
- `local.exclude` 패턴과 기본 제외(`.git`, `node_modules`, `~$*` 임시, `.DS_Store`)를 적용한다.
- `local.doc_dirs` 에 `./engagements` 가 있으면 과거 산출물을 추가 레거시 소스로 재학습한다.

## 2. 압축 해제 (zip)
- `.zip` 을 만나면 `.planning/knowledge-base/raw/<archive-name>/` 에 직접 해제한다.
- **한글 파일명 인코딩(CP949) 주의**: Linux는 `unzip -O cp949` 가능하나 **macOS 기본 `unzip` 은 `-O` 미지원** → CP949 파일명에서 `Illegal byte sequence` 로 실패한다. 이때 **Python `zipfile` 폴백**을 쓴다(파일명 bytes를 `cp437` 로 인코딩 후 `cp949` 디코딩):
  ```python
  import zipfile, os
  z = zipfile.ZipFile(zip_path)
  for i in z.infolist():
      if i.is_dir(): continue
      try: name = i.filename.encode('cp437').decode('cp949')
      except Exception: name = i.filename
      out = os.path.join(dest, name); os.makedirs(os.path.dirname(out), exist_ok=True)
      open(out,'wb').write(z.open(i).read())
  ```
- 내부에 중첩 zip이 있으면 재귀적으로 해제한다.
- `raw/` 는 워크스페이스 `.gitignore` 에 추가하도록 안내한다(원문 캐시).

## 3. 재귀 순회 + 인벤토리
- 폴더면 안의 **모든 파일을 재귀 순회**한다(`Glob`). exclude 적용.
- 각 파일의 메타를 `stat` 으로 수집: 수정일/생성일·크기. 이는 버전 판정 근거가 된다.

## 4. 파일 타입별 읽기
- **본문 파싱**: `.md` `.txt` `.csv` `.json` → `Read`. **`.pdf` → `Read`(필요 시 `pages` 로 분할)**.
- **메타만 기록**: `.xlsx` `.xls` 등 스프레드시트, `.hwp` `.doc(x)` 는 본문을 파싱하지 않는다. `source-manifest` 에 메타만 기록하고, 필수 정보면 문서에 `추가 확인 필요` 로 표시한다.
- **이미지(`.png` `.jpg` …)**: 기본은 메타만(`status: skipped-binary`). 단 그 **이미지가 스펙/시나리오 등 핵심 콘텐츠**(예: 연동 규격이 PDF가 아닌 이미지로 제공)면 `image-explore` 스킬로 라우팅해 비전 분석한다.
- 참고: 규격 묶음은 PDF(본문 파싱 가능)+PNG(시나리오 다이어그램) 혼합으로 올 수 있다 — PDF 우선 파싱, 이미지는 위 규칙대로.

## 5. 버전 충돌 해소 (핵심)
- 같은 기획 내용에 대해 **여러 버전 파일**이 있을 수 있다.
- 파일명을 정규화(`(1)`·`(2)`, `_v2`, `_final`, 날짜 토큰 등 제거)해 **동일 기획 후보로 그룹화**한다.
- 충돌·중복 시 **항상 최신본 기준**으로 파악한다: 우선순위 = 파일명 버전 토큰 → 생성/수정일 최신.
- 채택되지 않은 구버전은 `source-manifest` 에 `status: superseded` 로 기록한다.
- 최신본끼리 내용이 서로 충돌하면 단정하지 말고 KB·문서에 `모순`으로 표면화한다.

## 출력 / 출처
- 추출한 레거시 정책/엔티티를 출처(파일 경로 + 버전/일자 + 신뢰도)와 함께 `knowledge-base` 스키마로 적재한다(출처 type=`local`).

## 원칙
- 출처 없는 단정 금지. 본문을 못 읽은 이진 파일은 정직하게 `메타만`/`추가 확인 필요` 로 보고.
- 충돌은 임의 병합하지 말고 최신 기준 + 모순 표기.
