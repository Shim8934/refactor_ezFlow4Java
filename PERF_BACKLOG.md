# PERF_BACKLOG — 후속 회차 후보

이번 회차(로직 안티패턴 정리, Java 레벨만) 범위 밖이라 **기록만** 하는 발견.
각 항목: 위치 / 패턴 / 확신도 / 사유(왜 이번 회차 미처리) / 개선 방향.

---

## [BL-001] getRecordList — 행당 의견조회 N+1

- **위치**: `EzApprovalGServiceImpl.java:10865-10872` (`getRecordList`)
- **패턴**: P1 (루프 안 DB 호출 / N+1)
- **확신도**: 확실
- **현황**: 행 루프 `if(p==0)` 안에서 `getOpinionAddGB` + `getHasopinionYn` 행당 2회 DB. 이미 `p==0` 가드는 있어 Java 레벨(셀 중복)은 최적. 남은 건 행수만큼의 단건 조회.
- **사유 (미처리)**: 제거하려면 본 목록 쿼리(`EzApprovalG.getRecordList`)에 조인하거나 IN절 배치 조회 sqlmap 신설 필요 → **SQL 변경 = 이번 회차 범위 밖**.
- **개선 방향 (후속)**: 목록 SELECT에 ADDOPINION/HASOPINIONYN 컬럼을 LEFT JOIN으로 합쳐 행당 추가 쿼리 제거. 또는 페이지 DOCID 목록을 IN절로 묶어 1회 배치 조회 후 Map 매핑.

---

## [BL-002] getOpinionAddGB / getHasopinionYn — 문서당 단건 호출 (N+1)

- **위치**: 호출처 다수 — `aprDocList:23725`(이번 회차 p==0 안으로 이동 완료), `getRecordList:10871-10872`, 그 외 목록/상세 메서드
- **패턴**: P1 (N+1) — SQL 자체는 정상(EXISTS 서브쿼리)
- **확신도**: 확실 (N+1), 정황 (SQL 비효율)
- **현황**: `selectOpinionAddGb` = `SELECT CASE WHEN EXISTS(SELECT 1 FROM TBL_(END)APROPINIONINFO WHERE DOCID/COMPANYID/TENANT_ID/OPINIONGB) THEN 'TRUE' ELSE 'FALSE'`. 문서 한 건당 1회 호출.
- **사유 (미처리)**: 배치화/조인 모두 sqlmap 신설·수정 필요 → **SQL 변경 = 범위 밖**. SQL 본문 자체는 EXISTS라 인덱스(`TBL_APROPINIONINFO(DOCID,COMPANYID,TENANT_ID,OPINIONGB)`) 유무가 관건인데 인덱스 분석도 범위 밖.
- **개선 방향 (후속)**: ① 페이지 DOCID 묶어 IN절 1회 조회 → `Map<DOCID, TRUE/FALSE>`. ② 목록 쿼리에 EXISTS를 상관 서브쿼리 컬럼으로 인라인. ③ 인덱스 점검(EXPLAIN).

---

## [BL-003] getRecordList — VO→XML문자열→DOM 왕복 + getElementsByTagName 반복 스캔

- **위치**: `EzApprovalGServiceImpl.java:10679-10925` (`getRecordList`)
- **패턴**: P7/P8 (불필요한 중복 계산 / 자료구조 오용)
- **확신도**: 확실
- **현황**:
  1. `commonUtil.getQueryResult(vo)` = VO 필드를 리플렉션으로 순회해 XML 문자열 직렬화(행마다).
  2. 전체 concat 후 `convertStringToDocument(...)` = DocumentBuilder로 **재파싱**.
  3. 셀마다 `docXML.getElementsByTagName(TAG).item(k)` — `getElementsByTagName`은 **매 호출 문서 전체 트리 스캔** (Xerces deferred NodeList). 행수 × 컬럼수 × 셀당 태그 여러 개 → 실질 **O(N²)**.
- **사유 (미처리)**: 두 단계로 나뉨.
  - **Tier A (Java 레벨, 이번 회차 가능 후보)**: round-trip은 두고, 행 루프 진입 시 해당 ROW의 자식 노드를 `Map<tagName, value>`로 1회 인덱싱 → 셀에서 Map 조회. `getElementsByTagName` 전체스캔 제거. 출력 동일. **사용자 협의 후 처리 가능.**
  - **Tier B (대규모 리팩터, 범위 경계)**: VO→XML→DOM 왕복 자체를 없애고 `apprGRecordVOList` VO에서 직접 읽기. 태그 ~40개가 VO getter와 1:1 매핑되는지·`cleanValue`/`makeListField` 변환 보존 검증 필요. 안전망(mockito) 부재 상태에서 위험 큼 → 후속 회차 권장.
- **개선 방향**: Tier A 먼저(저위험). 동일 패턴이 `aprDocList`, `getCabinetList` 등 다른 목록 빌더에도 존재 → 공통 헬퍼화 검토.

---

## [BL-004] 미정독 목록 메서드 추가 스캔 필요

- **위치**: `getContDocList`, `getSearchDocList*`, `getDeliveryList`, `getUserContList`, `getApproveDocInfo` 등 (본문 미정독)
- **패턴**: P1/P2/P7/P8 동형 예상
- **확신도**: 정황 (스캐너 자기검증에서 P1 과소집계 경고)
- **사유 (미처리)**: 29000줄 파일, 표본만 정독. 동형 "행 루프 안 코드→명칭 / 의견조회 / getElementsByTagName 반복" 다수 존재 개연성 높음.
- **개선 방향 (후속)**: 메서드 단위 추가 스캔 → 동일 Tier A 패턴 일괄 정리.
