# PERF_BACKLOG — 후속 회차 후보

이번 회차(로직 안티패턴 정리, Java 레벨만) 범위 밖이라 **기록만** 하는 발견.
각 항목: 위치 / 패턴 / 확신도 / 사유(왜 이번 회차 미처리) / 개선 방향.

---

## [BL-007] sendMsg — 알림 발송 N+1 통신 + HTTP 타임아웃 미설정 + 트랜잭션 점유 (운영 핫스팟)

- **정의**: `EzApprovalGServiceImpl.sendMsg(docID, nextUserID, mode, ...)` (~20853). 단건(수신자 1명) 전제. 1회당 DB SELECT 10여 회 + INSERT 1 + (ezTalk 사용 테넌트면) 외부 HTTP 1회.
- **외부 HTTP 경로**: `addEzTalkNotification`(EzEmailServiceImpl ~2216) → `getWebServiceResult`(EzEmailUtil ~4225) → `JGwServerURL + /ezTalkGate/addNotification` 로 `HttpURLConnection` POST 동기 1회.
- **N+1 통신 (fan-out 루프)**: `doSendDoc`(수신처마다 ~19603/19686), `sendRecvMsg`(부서원마다 ~20226, 2차 fan-out, 최대 50명), `doCallBack`(결재선마다 ~22577), `doCancelForce`(~27723), `doSendDocSchedule`(~20201). 수신처 N개 → DB insert N + ezTalk HTTP N.
- **배치 가능성 — 이번 회차 불가**: sendMsg/insertNotifyItem/addEzTalkNotification 전부 단건 시그니처. **다건 insert sqlmap 없음**(iBATIS, `insertNotifyItem` 단건), **ezTalk 다건 엔드포인트 없음**. 배치하려면 ① 다건 INSERT sqlmap 신규 ② ezTalk 다건 엔드포인트+시그니처 신규 → **SQL/외부 API 신규 = 범위 밖**. CLAUDE.md P1("기존 다건 sqlmap 없으면 후속 회차") 해당.
- **⚠ 진짜 운영 통증 (지연 발생 시 문제) — 별도 고가치 후보**:
  1. **HTTP 타임아웃 미설정**: `getWebServiceResult`가 `setConnectTimeout`/`setReadTimeout` 미설정 → ezTalk 지연/무응답 시 무한 대기. fan-out 루프에서 N명 × 무제한 대기 누적. **지연 시 항상 문제됐던 원인 유력.** 단 이 메서드는 알림 외 30여 호출처 공유 → 영향 광범위, 사용자 협의 필요.
  2. **트랜잭션 점유 중 동기 HTTP**: `context-transaction.xml` pointcut `egovframework.ezEKP..*Impl.*(..)` + `<tx:method name="*">`로 doSendDoc 등이 DB 트랜잭션 연 채 루프 내 동기 ezTalk 호출 → 외부 느리면 DB 커넥션/락 점유. (P6 트랜잭션 경계 — 사용자 확정 필요)
  3. 재시도 없음, 한 건 실패(insertNotifyItem 등)가 `throws Exception` 전파 시 이후 수신자 발송 중단 + 롤백.
- **동작 보존 주의(배치/이동 시)**: `insertNotifyItem` seq 채번값이 실제 INSERT에 미사용되는 기존 quirk 유지, `getGroupDocSN` 그룹문서 조기 return 분기 수신자별 재평가, 알림 도착 순서.
- **미정밀 확인**: `doApprove` 16940~16960 `for m` 합의 루프 내 sendMsg fan-out 가능성, `doProcess`의 docID 콤마분해 외곽 N배수.
- **개선 방향 (후속/협의)**: (a) 타임아웃 추가 ✅ **완료**(commit 54e37dd324, EzEmailUtil.getWebServiceResult, config `webservice.connectTimeout`/`webservice.readTimeout` 외부화, 기본 5s/10s) (b) 알림을 트랜잭션 커밋 후로 분리(P6, 미처리) (c) 배치 발송(다건 sqlmap+엔드포인트 신규, 큰 작업, 미처리).
- **타임아웃 동명 중복 미처리분(후속 후보)**: `getWebServiceResult`가 `EzNotificationScheduler`(~121), `LoginServiceImpl`(~644), `EzEmailScheduler.getWebServiceResultForGw`(~1655)에도 별도 정의됨 — 동일 무타임아웃. 일관 적용 검토.

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
- **개선 방향**: Tier A 먼저(저위험). 공통 헬퍼 `indexRowElements(Node)`로 추출.
- **처리 상태**: ✅ **완료** (commit 0e4a19ad66 getRecordList, 4a3630bce6 헬퍼+aprDocList+getCabinetList). Tier B는 미처리(후속).

---

## [BL-005] aprDashBoardDocList — aprDocList의 쌍둥이(near-duplicate) 메서드

- **위치**: `EzApprovalGServiceImpl.java` `aprDashBoardDocList` (메서드 시작 ~40799, 셀 루프 ~40889~)
- **패턴**: P7/P8 (getElementsByTagName 셀별 전체 트리 재스캔, 사실상 O(N^2)) — **aprDocList와 동일**
- **확신도**: 확실
- **현황**: aprDocList와 셀 렌더링 블록이 거의 동일. `Document docXML = convertStringToDocument(docList); docXML.getElementsByTagName("ROW")...` 라운드트립 + 셀마다 `docXML.getElementsByTagName(TAG).item(k).getTextContent()` 약 31건.
- **사유 (미처리)**: 이번 회차 범위(aprDocList/getCabinetList)에 포함 안 함. aprDocList 수정 시 동일 코드라 sed 라인범위로 분리 처리했고 쌍둥이는 의도적으로 미변경.
- **개선 방향 (후속)**: 이미 추출된 `indexRowElements(Node)` 헬퍼를 그대로 적용(aprDocList와 동일 절차). 저위험.
- **추가 검토**: aprDocList/aprDashBoardDocList는 셀 렌더링이 사실상 동일 → **두 메서드의 공통 본문 추출(중복 제거)** 자체가 별도 리팩터 후보(범위 큼, 별도 회차).

---

## [BL-006] 동형 목록/상세 빌더 Tier A 후보 인벤토리 (스캔 결과)

- **패턴**: `getQueryResult(VO)→convertStringToDocument→셀별 getElementsByTagName().item()` 라운드트립 (P7/P8)
- **확신도**: 정황 (셀별 item() 호출 수 기준 자동 집계 — 실제 라운드트립 여부는 메서드별 재확인 필요)
- **셀별 `getElementsByTagName(...).item()` 호출 수 상위 목록 빌더** (이번 회차 미처리분):
  - `getContDocList` (~40), `makeTaskFullListXml` (~39), `getAttachDocInfo` (~36),
    `getInnerLineInfo` (~34), `aprDashBoardDocList` (~31, → BL-005), `getAttachFileInfo` (~29),
    `getContDocListS` (~25), `makeTaskListXmlAll` (~25), `getFindSimpleCabinetListAll` (~25),
    `getLineInfo` (~25), `getReceiptTempletDetailInfo` (~23), `getAprLineInfo` (~22),
    `getUserContList` (~22), `getGongRamLineInfo` (~21), `makeTaskListXml` (~47)
  - (※ `doApprove`(~146), `deleteUserContDoc`(~38) 등은 목록 빌더가 아닌 처리 로직일 수 있어 라운드트립 여부 개별 확인 필요 — 단순 입력 Document 파싱이면 대상 아님)
- **사유 (미처리)**: 메서드 단위 안전망/검증 필요, 범위 분할.
- **개선 방향 (후속)**: 메서드별로 ① 라운드트립 여부 확인 → ② `indexRowElements` 헬퍼 적용 (저위험 Tier A) → ③ Java8 빌드 검증.

### 진행 현황 (Tier A 적용 완료 — 전부 R 라운드트립, Java8 빌드 GREEN)
- 초기: getRecordList, aprDocList, getCabinetList
- 배치1: getCirculationinfo, getLineInfo, getAttachInfo, getOpinionInfo, getFormInfo, getFormContainerInfo
- 배치2: getAprLineInfo, getTempList(5-arg), getLineTempletInfo, getLineTempletDetailInfo, getReceiptTempletInfo
- 배치3: getTempList(4-arg), getListXML, getTempList2, getTempList3, getTaskCategory, getTaskMiddleCategory
- 배치4: getUncompleteDocList, getAttachFileInfo, getAttachDocInfo, getHistoryForDoc
- 배치5: getHistoryForLine, getHistoryForAttach, getHistoryForLineDetail, getGongRamLineInfo, getReceiptHistoryInfo
- 배치6: getFindSimpleCabinetList, getFindSimpleCabinetListAll
- 배치7: getContDocList, getContDocListS, getUserContList, getUserContListAll
- 배치8: getReceiptTempletDetailInfo, getSignInfo, aprDashBoardDocList(=BL-005 쌍둥이, 완료)
- 배치9: getSendOutDocList, getAprType(2개 k-루프), getDeliveryList(역순 j)
- 배치10: getSimpleCabinetList, getCodeInfo(9개 k-루프)
- **누적 43개 메서드.**

### R-중첩군 잔류 → 수동 처리 완료/정정
- `getContainerInfoManage`: ✅ **완료**(commit aff0802b67). if/else 2개 j-루프, 동적 태그는 `rowData.get("CONTAINERTYPENAME"+getMultiData(...))`로 수동 변환.
- `getReceivedDocInfo`: ✅ **완료**(commit aff0802b67). signXML 단건(item(0)) 8회 전체스캔 → ROW(0) 1회 인덱싱.
- `getTaskSubCategoryAll`: ✅ **대상 아님 확정** — VO 직접 조회(`apprGTaskVOList.get(k).getXxx()`), getElementsByTagName 미사용.

→ **R-중첩군(헬퍼 적용 가능 목록 빌더) Tier A 전수 완료.** 누적 45개 메서드.

### 남은 hard tail (자동 일괄 부적합 — 개별 정밀 처리 필요)
- **(P) param-input docXML — 구조 검증 필수**: makeTaskListXml, makeTaskListXmlAll, makeTaskFullListXml, GetRecordInfo, getRecReadHistory, getRecordHistory, getCabinetHistory, getTaskCharger, getCabinetDetailInfo
  - ⚠️ **핵심 주의**: 이들은 docXML이 호출자 입력 Document. `getElementsByTagName(TAG)`는 문서 전체(자손) 검색인데 `indexRowElements`는 ROW **직계 자식만** 인덱싱. 입력 XML의 ROW 자식이 flat 태그가 아니면(중첩/속성) 결과 불일치 → 적용 전 ROW 구조가 `<ROW><TAG>val</TAG>...</ROW>` flat인지 반드시 확인.
- **중첩/멀티 루프 (인덱스 i&k, k&p, 2-loop)**: getContDocList, getContDocListS, getUserContList, getUserContListAll, getReceivedDocInfo, aprDashBoardDocList(→BL-005), getDeliveryList(trim 다수, idx j 역순), getReceiptTempletDetailInfo(k&i), getSimpleCabinetList(nested i + trim), getAprType(2-loop 공유 dlength), getCodeInfo(코드타입별 다중 루프), getSignInfo, getTaskSubCategoryAll, getContainerInfoManage(2-loop), getSendOutDocList
  - 데이터 행 루프의 인덱스 변수를 정확히 식별해 sed 패턴(item(k)/item(j)/item(p)) 매칭 + 헤더/비-docXML 조회는 미변경.
- **(B) 숫자 childNode 인덱스 — tag-map 부적합, 다른 fix**: gongRamSave, gongRamSaveIng, gongRamSaveEnd, updateOpinionInfo, updateAttachFileInfo, updateOpinionSihangReject, updateAddOpinionInfo, getTotalAttachSize/chkAprLines/chkDeptLines. → ROW NodeList 1회 캐싱 + `rows.item(k).getChildNodes()` 1회로 별도 최적화(숫자 인덱스 유지).
- **(제외) 부작용 동반 루프**: doApprove(루프 내 sendMsg/setBujaeInfo 등 부작용) — 호출횟수 보존 까다로움, Tier A 대상 아님.

---

## [BL-008] 의견 배치 조회 SQL 트랙 — 현황 / 재개 가이드

> 브랜치 `perf/getrecordlist-opinion-batch` (base `perf/ezapprovalg-antipattern-1`), PR #2. **PR #1 머지 후 진행.**

### 완료
- 행마다 `getOpinionAddGB`(getRecordList는 `getHasopinionYn`까지) 호출하던 N+1을 페이지 IN절 배치로 축소.
- sqlmap 3종(Mysql/Oracle/Tibero) 신규: `selectOpinionAddGbBatch`(DISTINCT DOCID,COMPANYID + DOCID IN/COMPANYID IN), `selectHasOpinionYnBatch`.
- DAO: `getOpinionAddGbBatch`, `getHasOpinionYnBatch`.
- 서비스 공통 헬퍼: `batchAddOpinionKeys` / `batchAddOpinionKeysFromDoc` / `addOpinionKey`(복합키 "DOCIDCOMPANYID").
- 적용 5개: getRecordList(단일회사), aprDocList(GongHoiRam Y), aprDashBoardDocList(Y), getSearchDocList, getSearchDocListS.
- Java8 빌드 GREEN, sqlmap XML well-formed.

### 재개 시 먼저 할 일 (중요)
1. **DB 통합 검증 (머지 전 필수)**: 빌드는 SQL 미실행. iBATIS `<iterate>` IN절 실제 동작 + 다중 회사(계열사) 페이지에서 단건 vs 배치 결과 동일성 확인. 케이스: 빈 페이지(IN() 방지 — dlength==0/empty 가드 있음), 단건, 다건, 추가의견 유무, DOCID 동일·회사 다름.
2. **복합키 separator**: `addOpinionKey`/`batchAddOpinionKeys`가 `''`(제어문자 char) 사용. 동일 토큰이어야 매칭됨(현재 동일).

### 남은 의견 N+1 후보 (미적용)
- 단건 호출 `getOpinionAddGB` (루프 아님, v_FLAG=ADDN): EzApprovalGServiceImpl 36738(`rtvl`), 36757(`Result`) — N+1 아님, 배치 불필요(기록만).
- `getHasopinionYn` 루프 호출처는 현재 getRecordList뿐(배치 완료). 타 메서드는 addOpinion만.
- 동형 의견조회가 추가로 발견되면 `batchAddOpinionKeysFromDoc(docXML, tenantID, "ADDY", gongHoiRam)` 한 줄 + 행 호출을 `addOpinionKeySet.contains(addOpinionKey(docId, companyId))`로 치환.

## [BL-009] Tier A 누락 — getInnerLineInfo

- **위치**: `EzApprovalGServiceImpl.getInnerLineInfo`
- **현황**: ~~배치1~10 Tier A에서 누락됨. 셀마다 `docXML.getElementsByTagName(TAG).item(k)` 전체 트리 재스캔(O(N^2)).~~
- **처리 상태**: ✅ **완료** (branch `perf/getinnerlineinfo-tiera`). 역순 k-루프, 셀 27건 docXML.item(k) → `indexRowElements` 헬퍼(`innerLineRowList`) rowData.get 치환. 의견 배치는 SQL 트랙에서 이미 적용됨. Java8 빌드 GREEN.
