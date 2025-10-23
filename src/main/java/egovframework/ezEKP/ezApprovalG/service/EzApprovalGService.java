package egovframework.ezEKP.ezApprovalG.service;

import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachOptionVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocInfoWebSrvVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGGroupDocInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpenGovAttachVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpenGovInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpinionVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOutOfOfficeInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGProxyVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiveDocVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSecondApprVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSummaryVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSusinProcessInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGgetDeptStacticsVO;
import egovframework.ezEKP.ezApprovalG.vo.KEDSharedUserInfo;
import egovframework.ezEKP.ezApprovalG.vo.PortletAprInfoVO;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopOtherCompanyAddJobVO;
import egovframework.let.user.login.vo.LoginVO;
import org.json.simple.JSONObject;
import org.jsoup.nodes.Element;
import org.springframework.web.multipart.MultipartFile;
import org.w3c.dom.Document;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDeliveryListVO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.UnsupportedEncodingException;
import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.zip.ZipOutputStream;
import java.util.Optional;

public interface EzApprovalGService {

    // 캐비닛 기록물철 문서 삭제
    public String deleteCapInfo(String cabinetID, String companyID, int tenantID) throws Exception;

    // 캐비닛 기록물철 문서 삭제 정보 추가
    public String insertDelCapInfo(String cabinetID, String delUserID, String ipAddress, String companyID, int tenantID) throws Exception;

    // 캐비닛 기록물철 삭제 전 진행중문서 확인
    public String selectExpCabDocInfo(String cabinetID) throws Exception;

    public List<ApprGLeftVO> getUseContInfo(LoginVO userInfo, String ownFlag) throws Exception;

    /* 2024-05-27 홍승비 - 호출되지 않는 구버전 메서드 주석처리 */
    // public List<ApprGgetDeptStacticsVO> getDeptStactics(String pStartDate, String pEndDate, String pLang, String companyID, int tenantID) throws Exception;

    public String getOptionInfo(String code1, String code2, LoginVO userInfo, String mode) throws Exception;

    public String aprDocList(String listType, String userID, String deptID, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String userLang, String searchQuery, Document dueryData, int tenantID, String offSet, Map<String, Object> searchMap) throws Exception;

    public String getProxyUser(String id, String lang, int tenantID, String offset) throws Exception;

    public String getAprLineInfoDB(String docID, String flag, String userID, String formID, String companyID, int tenantID, String isUsed, String beforeDocID, String mode, String docState) throws Exception;

    public String getListHeader(String listCode, String companyID, String lang, int tenantID) throws Exception;

    public String getCode2Name(String code1, String code2, String companyID, String lang, int tenantID) throws Exception;

    public String getListField(String fieldName, String fieldValue, String companyID, String userLang, int tenantID, String offSet) throws Exception;

    public String getAccessYNG(String docID, String userID, String mode, String companyID, String lang, int tenantID, String approvalFlag, String deptID) throws Exception;

    public String getLineInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;

	public List<ApprGAprLineVO> getLineList(String docId, String mode, String companyId, String offset, String lang, int tenantId) throws Exception;

    public String getAttachInfo(String docID, String flag, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String getReceiptInfo(String docID, String flag, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset, String approvalFlag, String isUsed, Locale locale) throws Exception;

    public String getOpinionInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String getWebPartList(String listType, String userID, String deptID, String listCount, String mode, String userFlag, String companyID, String lang, int tenantID, String offset) throws Exception;
    
    public String getDocType(String selected, String companyID, String lang, int tenantID, Locale locale, String approvalFlag) throws Exception;

    public String getFormInfo(String formContID, String kind, String searchType, String searchName, String userID, String deptId, String companyID, String lang, int tenantID) throws Exception;

    public String getFormContainerInfo(String id, String deptID, String companyID, String primary, int tenantID, String approvalFlag) throws Exception;

    public String setUserFormInfo(String formID, String userID, String companyID, int tenantID) throws Exception;

    public String delUserFormInfo(String formID, String userID, String companyID, int tenantID) throws Exception;

    public String getApprovalPWD(String userID, int tenantID, String companyID) throws Exception;

    public String getSecurityType(String selected, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;

    public String getAprType(String approvalFlag, String companyID, String lang, int tenantID) throws Exception;

    public String getAprLineInfo(String docID, String userID, String formID, String companyID, String lang, int tenantID, String offset, String reDraftFlag, String isUsed, String beforeDocID, String mode, String docState) throws Exception;

    public String getTempList(String userID, String formID, String companyID, String lang, int tenantID) throws Exception;

    public String updateLineInfo(String ret, String companyID, String lang, LoginVO userInfo, String docIDForDraftAll) throws Exception;

    public String updateReceiptInfo(String ret2, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;

    public String getLineTempletInfo(String formID, String userID, String companyID, int tenantID) throws Exception;

    public String getLineTempletDetailInfo(String formID, String userID, String aprSN, String companyID, String lang, int tenantID) throws Exception;

    public String getFormInfoDetail(String formID, String companyID, int tenantID) throws Exception;

    public String getFormRecvApr(String docID, String formID, String userID, String companyID, String lang, int tenantID, String useReceiveInfoName) throws Exception;

    public String createNewDoc(String formID, String companyID, int tenantID) throws Exception;

    public String deleteDocInfo(String docID, String mode, String companyID, int tenantID) throws Exception;

    public String updateLineTempletDetailInfo(Document xmlDom, Locale locale, String companyID, String lang, int tenantID) throws Exception;

    public String deleteLineTempletDetailInfo(String formID, String userID, String aprLineSN, String companyID, int tenantID) throws Exception;

    public String addToAprLine(String userID, String formID, String aprSN, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String getReceiptTempletInfo(String formID, String userID, String companyID, int tenantID) throws Exception;

    public String getReceiptTempletDetailInfo(String formID, String userID, String aprSN, String companyID, String lang, int tenantID, String offSet, String approvalFlag) throws Exception;

    public String getTempList(String companyID, String lang, int tenantID, String extReceptYn) throws Exception;

    public String getTempList2(String groupID, String companyID, String lang, int tenantID) throws Exception;

    public String getTempList3(String userID, String formID, String companyID, String lang, int tenantID) throws Exception;

    public String getListXML(String groupID, String lang, String companyID, int tenantID, Locale locale, String approvalFlag) throws Exception;

    public String addToAprDept(String userID, String formID, String aprDeptSN, String companyID, String lang, int tenantID, String offset, Locale locale, String approvalFlag) throws Exception;

    public String deleteReceiptTempletDetailInfo(String formID, String userID, String aprDeptSN, String companyID, int tenantID) throws Exception;

    public String updateReceiptTempletDetailInfo(Document doc, String companyID, int tenantID, String approvalFlag) throws Exception;

    public String getTaskCategory(String deptCode, String companyID, String type, int tenantID) throws Exception;

    public String getTaskMiddleCategory(String deptCode, String companyID, String cateCode, int tenantID) throws Exception;

    public String getTaskSubCategory(String deptCode, String companyID, String cateCode, String strType, int tenantID) throws Exception;

    public String getTaskSubCategoryAll(String deptCode, String companyID, String cateCode, String strType, String initFlag, int tenantID, String viewFlag) throws Exception;

    public String getTaskInSubCategory(String deptCode, String companyID, String cateCode, String strType, String langType, int tenantID, String approvalFlag) throws Exception;

    public String getSimpleCabinetList(String companyID, String processDeptCode, String productionYear, String taskCode, String flag, String langType, int tenantID, String selYear) throws Exception;

    public String findTask(String deptCode, String title, String code, String flag, String companyID, String langType, String pageSize, String pageNO, int tenantID, String approvalFlag) throws Exception;

    public String deleteOpinionInfo(String docID, String companyID, String lang, int tenantID) throws Exception;

    public String updateOpinionInfo(Document docXML, String companyID, String lang, int tenantID) throws Exception;

    public String getDocHrefYear(String docID, String companyID, int tenantID) throws Exception;

    public String getDocDir(String docID) throws Exception;

    public String getAttachFileInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String updateHistoryForAttach(String docID, String attachSN, String tempUserID, String tempUserName, String tempUserName2, String tempUserJobTitle, String tempUserJobTitle2,
                                         String tempUserDeptID, String tempUserDeptName, String tempUserDeptName2, String modifyFlag, String dirPath, String companyID, int tenantID) throws Exception;

    public String updateAttachFileInfo(Document xmlDom, String companyID, String lang, int tenantID) throws Exception;

    public String deleteAttachFileInfo(String docID, String companyID, String lang, int tenantID) throws Exception;

    public String getListInfoXml(String listFlag, String listType, String companyID, String lang, LoginVO userInfo) throws Exception;

    public String getRecordList(Document doc, String lang, int tenantID, String offset, String deptID) throws Exception;

    public String getCodeInfo(String companyID, String lang, int tenantID) throws Exception;

    public String getAttachDocInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset, String approvalFlag) throws Exception;

    public String isCabCharger(String companyID, String cabClassNo, String userID, int tenantID) throws Exception;

    public String updateAttachDocInfo(Document doc, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;

    public String deleteAttachDocInfo(String docID, String companyID, String lang, int tenantID) throws Exception;

    public String getDocInfo(String docID, String mode, String selected, LoginVO userInfo, String companyID, int tenantID, String isUsed, String beforeDocID) throws Exception;

    public void saveRecReadHist(String readRecXML, int tenantID) throws Exception;
    
	public String doApprove(String docID, String userID, String aprState, String userName, String userName2, String dirPath, String deptID, String proxyUserID, String companyID, String lang, LoginVO userInfo, String curDocNum, String chamState, String nonElecRecYN, String passAprLine, String sendNotiFlag) throws Exception;

    public String receiverChk(String deptID, String companyID, int tenantID) throws Exception;

    public String getEA5Value(String msg, int tenantID, String companyID) throws Exception;

    public String getMyTaskCode(String userID, String deptID, String companyID, String lang, int tenantID, String upperDeptCode) throws Exception;

    public String setMyTaskCode(String userID, String deptID, String cabinetID, String taskCode, String type, String companyID, int tenantID) throws Exception;

    public String getCabinetInfo(String cabinetID, String companyID, String strType, int tenantID) throws Exception;

    public String registerSepAttach(Document doc, int tenantID, Locale locale) throws Exception;

    public String getHistoryForDoc(String docID, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String getHistoryForLine(String docID, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String getHistoryForAttach(String docID, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset, String approvalFlag, Locale locale) throws Exception;

    public String getHistoryForLineDetail(String docID, String modifySN, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset, String approvalFlag) throws Exception;

    public String deleteTmpDocInfo(String userID, String sn, String path, String companyID, String lang, int tenantID) throws Exception;

    public String doProcess(String aprState, String docID, String userID, String userName, String userName2, String dirPath, String deptID, String html,
                            Document strXML, String proxyUserID, String companyID, String lang, LoginVO userInfo) throws Exception;

    public String getTotalAttachSize(String docID, String companyID, int tenantID) throws Exception;

    public String chkAprLines(Document doc, String lang, LoginVO userInfo) throws Exception;

    public String chkDeptLines(Document doc, String companyID, String lang, LoginVO userInfo) throws Exception;

    public String updateHistoryForLine(String docID, String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String userDeptID, String userDeptName,
                                       String userDeptName2, String chkFlag, String companyID, int tenantID) throws Exception;

    public String getApprovalPWD1(String dUserID, int tenantID, String companyID) throws Exception;

    public String getApproveDocInfo(LoginVO userInfo, String docID, String companyID, String lang, int tenantID, String offset, String mode, String chamState) throws Exception;

    public String getLastOpinionContent(String docID, String companyID, String lang, int tenantID) throws Exception;

    public String getSignInfo(String docID, String offset, Locale locale, String primary, String companyID, int tenantID) throws Exception;

    public String getCabinetNum(String deptID, String subID, String companyID, String docID, String lang, int tenantID, String offSet) throws Exception;

    public String rollbackCabinetNum(String deptID, String subID, String sn, String companyID, String docID, String lang, int tenantID) throws Exception;

    public String updateSignInfo(Document xmlDom, String companyID, String mode, int tenantID) throws Exception;

    public String getCallBackYN(String docID, String tempUserID, String companyID, int tenantID) throws Exception;

    public String getCallBackYNForceLine(String docID, String tempUserID, String companyID, int tenantID) throws Exception;

    public String getTotalDownload(String docID, String mode, String companyID, int tenantID) throws Exception;

    /* 2024-02-23 홍승비 - SQL Injection 제거 > 검색 쿼리를 문자열이 아닌 맵으로 전달, 사용하지 않는 Document xmlDomSub 파라미터 제거 */
    public String getReceiveDocList(String userID, String deptID, String receiveDocMode, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String userLang,
									Map<String, Object> searchQueryMap, int tenantID, String offset, String assignChk, String userPrimary) throws Exception;

    public String gongRamDocInfo(String docID, String companyID, int tenantID) throws Exception;

    public String getOrgDocInfo(String docID, String companyID, int tenantID) throws Exception;

    public String getReceivedDocInfo(LoginVO userInfo, String docID, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String getDocRecvState(String docID, String deptID, String companyID, int tenantID) throws Exception;

    public String setJijung(String docID, String receiveSN, String processorID, String processorName, String processorJobTitle, String receivedDeptID, String receivedDeptName, String docState,
                            String processorName2, String processorJobTitle2, String receivedDeptName2, String companyID, String lang, int tenantID) throws Exception;

    public String updateSusinDocInfo(String orgDocID, String docID, String deptID, String id, String displayName1, String displayName2, String companyID, int tenantID) throws Exception;

    public String getNextDocInfo(String docID, String userID, String userDeptID, String isIEFlag, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String registerCabinet(Document xmlDom, String strLang, int tenantID) throws Exception;

    public String getNewVolumeNo(String cabClassNO, String companyID, int tenantID) throws Exception;

    public String addNewVolume(String cabClassNO, String newVolNO, String companyID, int tenantID) throws Exception;

    public String getFindSimpleCabinetList(String processDeptCode, String productionYear, String searchKeyword, String flag, String companyID, String langType, int tenantID) throws Exception;

    public String setBebu(Document xmlDom, String dirPath, String companyID, String lang, int tenantID, String offSet, LoginVO userInfo, String curDocNum) throws Exception;
    
    public String setReBebu(String docID, String receiveSN, String deptID, LoginVO userInfo, String companyID, int tenantId, String lang) throws Exception;

    public String makeTaskListXml(Document docXML, String companyID, String strType, int tenantID, String approvalFlag, String userFlag) throws Exception;

    public String doSusinHesong(String docID, String receiveSN, String deptID, String docState, String userID, String userName, String userName2, String dirPath, String companyID, String lang, int tenantID, String offSet) throws Exception;

    public String getAprType_AprState(String docID, String userID, String strDocState, String companyID, int tenantID) throws Exception;

    public String doCallBack(String docID, String userID, String companyID, int tenantID, String sendNotiFlag) throws Exception;

    public String getFormConnFlag(String docID, String companyID, int tenantID) throws Exception;

    public String getInnerLineInfo(String docID, String deptID, String docState, String companyID, int tenantID) throws Exception;

    public String getSearchDocList(String containerID, String userID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String formName, String draftFromYEAR, String draftFromMONTH,
                                   String draftFromDAY, String draftToYEAR, String draftToMONTH, String draftToDAY, String apprFromYEAR, String apprFromMONTH, String apprFromDAY, String apprToYEAR, String apprToMONTH,
                                   String apprToDAY, String myApprFromYEAR, String myApprFromMONTH, String myApprFromDAY, String myApprToYEAR, String myApprToMONTH, String myApprToDAY, String draftDeptName,
                                   String docState, String aprFlag, String pageSize, String pageNum, String orderCell, String orderOption, String alFlag, String companyID, String lang, String approvUser, int tenantID, String offset, String approvalFlag, Locale locale) throws Exception;

    public String updateSignCheck(String docID, String signCheck, String companyID, int tenantID) throws Exception;

    public String aprAttachMail(String docID, String flag, String companyID, int tenantID) throws Exception;

    public String makeTaskFullListXml(Document docXML, String companyID, String pageSize, String pageNO, String langType, int tenantID) throws Exception;

    /* 2024-03-07 홍승비 - SQL Injection 제거 > 검색 쿼리를 문자열이 아닌 맵으로 전달 */
    public String getContDocList(String containerID, String userID, Map<String, Object> searchQueryMap, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String getGamSaSearchDocList(String containerID, String userID, String deptID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String draftFromYEAR,
                                        String draftFromMONTH, String draftFromDAY, String draftToYEAR, String draftToMONTH, String draftToDAY, String apprFromYEAR, String apprFromMONTH, String apprFromDAY, String apprToYEAR,
                                        String apprToMONTH, String apprToDAY, String myApprFromYEAR, String myApprFromMONTH, String myApprFromDAY, String myApprToYEAR, String myApprToMONTH, String myApprToDAY,
                                        String draftDeptName, String docState, String aprFlag, String pageSize, String pageNum, String orderCell, String orderOption, LoginVO userInfo) throws Exception;

    public String getUncompleteDocCount(String deptID, String companyID, String cabinetID, int tenantID) throws Exception;
    
    public String getUncompleteDocList(String deptID, String companyID, String cabinetID, int tenantID, String userLang, LoginVO userInfo) throws Exception;

    public String transferCabinet(Document xmlDom, int tenantID) throws Exception;
    
	/* 2020-02-24 홍승비 - 편집 전후 문서를 판단하기 위한 플래그 isBeforeDoc, 편집전문서 파일경로 beforeDocURL 추가 */
	public String updateHistoryForDoc(String docID, String url, String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String userDeptID, String userDeptName, String userDeptName2, String isBeforeDoc, String beforeDocURL, LoginVO userInfo, String editMode, String editVersion)  throws Exception;

    public String gongRamUpdate(String docID, String userID, String companyID, String lang, int tenantID) throws Exception;

    public String delayCabEndY(String deptCode, String flag, String cabClassList, String companyID, int tenantID) throws Exception;

    public String getUncabinetedDocCount(String deptID, String confirmYN, String companyID, int tenantID) throws Exception;

    public String chkIfNotArrangedCabExist(String deptID, String companyID, int tenantID) throws Exception;

    public String confirmClassify(String deptID, String companyID, int tenantID) throws Exception;

    public String getSendOutDocList(String userID, String deptID, String susinManagerFlag, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, int tenantID, String offset, Map<String, Object> queryMap) throws Exception;

    public String endCabProduce(String cabClassNo, String flag, String companyID, int tenantID) throws Exception;

    public String mobileSrvConn(String userID, String result, String formID, String keyVal, String docID, String orgUID, String strLang, String companyID, HttpServletRequest request, LoginVO userInfo, String mode, String aprMemberSN) throws Exception;

    public String mobileSrvConn_HWP(String userID, String result, String formID, String keyVal, String docID, String orgUID, String langType, String companyID, HttpServletRequest request, LoginVO userInfo, String mode, String aprMemberSN) throws Exception;

    public String reqDelayCabEndY(String cabClassList, String flag, String companyID, int tenantID) throws Exception;

    public String doSendOfferApprove(String docID, String orgDocID, String userID, String userName, String userName2, String deptID, String dirPath, String proxyUserID, String companyID, String lang, LoginVO userInfo, String curDocNum) throws Exception;

    public String getFindSimpleCabinetListAll(String processDeptCode, String productionYear, String searchKeyword, String flag, String companyID, String langType, int tenantID) throws Exception;

    public String doSendOfferReject(String docID, String userID, String companyID, int tenantID) throws Exception;

    public String getApprovalPWD2(String dUserID, int tenantID, String companyID) throws Exception;

    public String getUserRecRight(String recID, String sepAttNo, String userID, String companyID, int tenantID) throws Exception;

    public String setCabinetReject(String docID, String deptID, String deptName, String deptName2, String dirPath, String realPath, String flag, String companyID, String lang, int tenantID, String offSet, Locale locale) throws Exception;

    public String gongRamSave(Document xmlDom, String dirPath, String companyID, String lang, int tenantID, String offSet) throws Exception;

    public String gongRamSaveEnd(Document xmlDom, String dirPath, String companyID, String lang, int tenantID, String offSet) throws Exception;

    public String makeTmp2IngDocInfo(String userID, String sn, String companyID, String lang, int tenantID, String docID, String orgDocID, String updateFlag) throws Exception;

    public String checkAprLine(String docID, String mode, String userID, String companyID, int tenantID) throws Exception;

    public String getSusinSN(String docID, String companyID, int tenantID) throws Exception;

    public List<ApprGSecondApprVO> getSecondApprovalInfo(String companyID, int tenantID) throws Exception;

    public Document checkPermission(String docID, String userID, String deptID, String checkMode, String companyID, int tenantID, String docState) throws Exception;

    public String sendOfferCheck(String docID, String userID, String string, String companyID, String lang, int tenantID) throws Exception;

    public String GetRecordInfo(Document xmlDom, String lang, int tenantID, String offSet) throws Exception;

    public String getRecViewer(Document xmlDom, String lang, int tenantID) throws Exception;

    public String saveRecUserRoleInfo(Document xmlDom, String lang, int tenantID, Locale locale) throws Exception;

    public String getRecReadHistory(Document xmlDom, String offset, int tenantID) throws Exception;

    public String getRecordClassInfo(Document xmlDom, int tenantID) throws Exception;

    /*public String getAprDocList(String pListType, String userID, String userDeptID, String pageSize, String pageNum, String sortHeader, String sortOption, String companyID, String pSubQuery, String strLang, int tenantID, String offset, Map<String, Object> searchMap) throws Exception;*/

    /*public Map<String, Object> getPortletAprList(Map<String, Object> param, String offset) throws Exception;*/

    /*public Map<String, Object> getPortletApprGapTime(Map<String, Object> param) throws Exception;*/

    public String getRecordHistory(Document xmlDom, LoginVO userInfo) throws Exception;

    public String moveRecord(Document xmlDom, String lang, int tenantID) throws Exception;

    public String getRecordSimpleInfo(Document xmlDom, String lang, int tenantID, String offset) throws Exception;

    public String changeRecordInfo(Document xmlDom, String lang, String offset, int tenantID) throws Exception;

    public String getDeliveryList(String p_DeptID, String pPageSize, String pPageNum, String pOrderCell, String pOrderOption, String pQuery, String companyID, String lang, String deptcode, String deptcode2, String title, String sregdate, String eregdate, String debenturer, String isdocprint, String extReceptYN, LoginVO userInfo, String upperDeptCode) throws Exception;

    public String getNewID(String companyID, int tenantID) throws Exception;

    public String registerRecord(Document xmlDom, int tenantID, String offset, Locale locale) throws Exception;

    public String getCabinetList(Document xmlDom, LoginVO userInfo) throws Exception;

    public String getCabinetDetailInfo(Document xmlDom, int tenantID, String offset) throws Exception;

    public String getCabScInfo(Document xmlDom, int tenantID) throws Exception;

    public String getCabinetPrintInfo(Document xmlDom, String lang, int tenantID) throws Exception;

    public String getCabinetSimpleInfo(Document xmlDom, int tenantID) throws Exception;

    public String changeCabinetInfo(Document xmlDom, int tenantID, String companyID) throws Exception;

    public String getCabinetHistory(Document xmlDom, LoginVO userInfo) throws Exception;

    public String getTaskCharger(Document xmlDom, String lang, int tenantID) throws Exception;

    public String saveCabRoleInfo(Document xmlDom, int tenantID, String companyID) throws Exception;

    public String updateReceiptOffer(String docID, String orgDocID, String companyID, int tenantID) throws Exception;

    public String doSendOffer(Document xmlDom, String dirPath, String companyID, String lang, int tenantID) throws Exception;

    public String addBebu(Document xmlDom, String dirpath, String companyID, String lang, int tenantID, String offSet, LoginVO userInfo) throws Exception;

    public String updateProcessYN2(String docID, String deptID, String deptName, String deptName2, String processYN, String mode, String companyID, String lang, int tenantID) throws Exception;

    public String updateProcessYN(String docID, String deptID, String processYN, String string, String companyID, String lang, int tenantID) throws Exception;

    public String doReSendDoc(Document xmlDom, String dirPath, String lang, int tenantID) throws Exception;

    public String getRecSCInfo(Document xmlDom, String lang, LoginVO userInfo) throws Exception;

    public String makeContainer(String deptID, String containerType, String companyID, int tenantID) throws Exception;

    // 2024-03-14 분석 결과 구포탈(ezPortal)에서만 사용되던 코드로 확인
    // public int getWebPartListCount(String listType, String userID, String deptID, String userIDS, String deptIDS, String userFlag, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String doCancelForce(String docID, String userID, String companyID, int tenantId) throws Exception;

    public String getKeepType(String lang, int tenantId, String companyID) throws Exception;

    public List<ApprGTaskVO> getCodeContainer(int tenantId, String companyID, String deptID, String primaryLang, String approvalFlag, String lang) throws Exception;

    public String getUserContTree(String id, String ParentContID, String deptName, String companyID, String lang, int tenantId, Locale locale) throws Exception;

    public String insUserCont(String ownUserID, String parentContID, String ownUserName, String description, String companyID, String lang, int tenantID) throws Exception;

    public String updateUserCont(String contID, String ownUserID, String parentContID, String userContName, String description, String companyID, String lang, int tenantID) throws Exception;

    public String delUserCont(String pContID, String pMode, String companyID, String lang, int tenantId) throws Exception;

    public String getCodeTreeInfo(String code, String level, LoginVO userInfo) throws Exception;

    public String getCodeSubTreeInfo(String code, String level, LoginVO userInfo) throws Exception;

    public String getContUseDeptInfo(String pDeptID, String companyID, String lang, int tenantId) throws Exception;

    public String registerUserContDoc(String docID, String contID, String description, String orgCompanyID, String companyID, String lang, int tenantId) throws Exception;

    public String docAttachLineInfo(String docID, String id, String companyID, int tenantId) throws Exception;

    public String getFrequencyClassList(LoginVO userInfo) throws Exception;

    public String getContainerInfoManage(String deptID, String mode, String companyID, String lang, int tenantId) throws Exception;

    public String getContDocListS(String contID, String id, String string, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, int tenantId, String offset, Locale locale) throws Exception;

    public String findTaskS(String deptCode, String title, String code, String companyID, int tenantId, String approvalFlag) throws Exception;

    /* 2024-05-28 홍승비 - 사용되지 않는 pSubQuery 파라미터 제거 */
    public String getUserContList(String pContID, String pPageSize, String pPageNum, String oc, String oo, String companyID, String lang, Document tempDueryDATA, int tenantID, String offSet, String userID, Map<String,Object> queryMap) throws Exception;

    /* 2024-05-31 홍승비 - 사용되지 않는 pSubQuery 파라미터 제거, getUserContList() 메서드와 동일하게 userID 파라미터 추가 */
    public String getUserContListAll(String pContID, String pPageSize, String pPageNum, String oc, String oo, String companyID, String lang, Document tempDueryDATA, int tenantID, String offSet, String userID, Map<String,Object> queryMap) throws Exception;

    public String deleteUserContDoc(String docID, String contID, String companyID, String lang, int tenantId) throws Exception;

    /* 2024-10-28 홍승비 - SQL Injection 제거 > 전자결재 일반 > 서브쿼리 문자열 대신 각 검색조건에 대응하도록 별도 파라미터 분리 (itemCode, endAprType, endAprState) */
    public String getSearchDocListS(String containerID, String userID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String formName, String draftfrom, String draftto, String apprfrom, String papprto, String mypapprfrom, String mypapprto,
                                    String draftDeptName, String docState, String AprFlag, String itemCode, String endAprType, String endAprState, String deptID, String pageSize, String pageNum, String orderCell, String orderOption, String searchStatus, String companyID, String lang, String string2,
                                    int tenantID, String offSet, String approvalFlag, Locale locale) throws Exception;

    public List<ApprGContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception;

    public List<ApprGFormVO> getFormInfoByPortal(String formContID, String kind, String searchType, String searchName, String userID, String companyID, String lang, int tenantID) throws Exception;

    public String getAutoDocNumItem(String formID, String lang, String companyID, int tenantID) throws Exception;

    public String doSendOfferS(Document docXML, String companyID, String lang, int tenantID) throws Exception;

    public String checkResend(String docID, String companyID, int tenantId) throws Exception;

    public String doHabyuiHesong(Document doc, String dirPath, String companyID, String lang, int tenantId, LoginVO userInfo, String curDocNum) throws Exception;

    public List<String> getAddress(String[] userIDArray, int tenantID) throws Exception;

    public String deleteSignInfo(String docID, String companyID, int tenantID) throws Exception;

    public String getSameOrgHAPYUIDoc(String docID, String companyID, String lang, int tenantID) throws Exception;

    public String getDocHref(String docID, String docStatus, String type, String docAttachSN, String companyID, int tenantId) throws Exception;

    public String getDocInfoS(String docID, String mode, LoginVO userInfo, String companyID, int tenantID) throws Exception;

    public String getIsUse(String code1, String code2, String companyID, String userLang, int tenantID) throws Exception;

    public String gongRamSaveIng(Document xmlDom, String dirPath, String companyID, String lang, int tenantId, String offset) throws Exception;

    public void delCirculation(String docID, String companyID, int tenantID) throws Exception;

    public String getCirculationinfo(String docID, String mode, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String setCabinetHesong(String docID, String deptID, String deptName, String deptName2, String userName, String userName2, String dirpath, String docSN, String companyID, String lang, int tenantId, String offset, Locale locale) throws Exception;

    public String doBansong(String docID, String childDocID, String userID, String aprState, String dirPath, String deptID, String companyID, String lang, LoginVO userInfo, String curDocNum, String sendNotiFlag) throws Exception;

    public String doBoryu(String docID, String userID, String aprState, String companyID, String lang, int tenantID, String userName, String sendNotiFlag) throws Exception;

    public void deleteOpinionTypeInfo(String docID, String opinionType, String companyID, int tenantID) throws Exception;
    
	public void OpinionDel2(String docID, String companyID, int tenantId) throws Exception;
	
	public void OpinionDel3(String docID, String companyID, int tenantId) throws Exception;

    public int lastKyulJeHabYuiYN(String docID, String flag, String companyID, int tenantId) throws Exception;

    public String startXmlConvert(String content, String fontFamily, String fontSize, LoginVO userInfo) throws Exception;
    
    public String startXmlConvertHwp(String content, String fontFamily, String fontSize, LoginVO userInfo) throws Exception;

    public String getAprLineXmlForExt(String docID, LoginVO userInfo) throws Exception;

    public String checkPubDocXML(String mapPath) throws Exception;

    public int checkReceivedDoc(String docID, String companyID, int tenantID) throws Exception;

    public String createSendMsgXML(Document xmlDom, String mapPath, LoginVO userInfo) throws Exception;

    public String getFileName(Map<String, Object> sendOutMap, String realPath, String strFileName, String strFolderName, String strXML, int tenantID) throws Exception;

    public boolean insertRelayDB(String strDocID, String strXDocID, String strRecDate, String strFrom, String strTo, String strSubject, String strXMailType, String strXFromCode, String strXToCode,
                                 String strXGW, String strXDocType, String strXDTDVersion, String strXXSLVersion, String strContentType, String strSealURL, String strXmlURL, String strLastDate, String strCompanyID, int tenantID) throws Exception;

    public void fieldUpdate(String strFieldName, String strValue, String strXDocID, String strDeptID, String strCompanyID, int tenantID) throws Exception;

    public void addAttachInfo(String strCont_Name, String strRealFileName, String strDocID, String strSN, String strType, String strCompanyID, int tenantID) throws Exception;

    public void addSignInfo(String strFileName, String strRealFileName, String strDocID, String strCompanyID, int tenantID) throws Exception;

    public boolean createRelayDocInfo(String strWriterName, String strWriterDept, String realPath, String strXDocID, String strReceiveID, String strCompanyID, int tenantID) throws Exception;

    public boolean sendAck(String strXDocID, String strReceiveID, String strSendID, String strTitle, String strDocType, String strDocTypeDept, String strDocTypeName, String strErrMsg, String strCompanyID, int tenantID) throws Exception;

    public boolean updateRelaySusinState(String strDocID, String strPrecDate, String strMode, String strDeptID, String strAcceptName, String strCompanyID, int tenantID) throws Exception;

    public boolean insFailMessage(String strXDocID, String strSendID, String strSendName, String message, String strCompanyID, int tenantID) throws Exception;

    public String getRelayInfo(String docID, LoginVO userInfo) throws Exception;

    public String setHref(String docID, String fileType, String mode, LoginVO userInfo) throws Exception;

    public String setRecvDocInfo(String docID, String publicFlag, String docNo, String docNumCode, String orgDocNumCode, String mode, String fileType, LoginVO userInfo) throws Exception;

    public String updateRecvDocInfo(String docID, String docNo, String docNumCode, String orgDocNumCode, String cabinetID, String taskCode, String userID, String userName, String userName2, String deptID, String userTitle, String userTitle2, String deptName, String deptName2, String tempCompanyID, LoginVO userInfo, String realPath) throws Exception;

    public String sendAck(String docID, String type, String userName, String userDeptName, String errMsg, String companyID, int tenantID) throws Exception;

    public List<OrganUserVO> getTenantID() throws Exception;

    public int getWhoKyulCount(String docID, String id, String companyID, int tenantId, String lang) throws Exception;

    public String doWhoKyulComplete(String docID, String userID, String companyID, int tenantId, String lang) throws Exception;

    public String returnWhoKyulSingInfo(String docID, String userID, String companyID, int tenantId, String lang) throws Exception;

    public String getWhoKyulYN(LoginVO userInfo) throws Exception;

    public String getOrgDraftDeptID(String docID, int tenantId, String companyID) throws Exception;

    public String getLineModeFlag(String docID, String userID, String companyID, int tenantId) throws Exception;

    public String updateSusinState(String docID, String mode, String deptID, String companyID, int tenantID) throws Exception;

    public String getDocManageDeptInfo(String deptID, int tenantID) throws Exception;

    public String getDocExt(String docID, String companyID, int tenantID) throws Exception;

    public void setNonElecRecSusinInit(String docID, String deptID, String deptName, String deptName2, String companyID, int tenantID) throws Exception;

    public String checkNonElecRec(String orgDocID, String companyID, int tenantID) throws Exception;

    public String getNonElecInfoSusinInit(String orgDocID, String companyID, int tenantID) throws Exception;

    public void setNonElecRecCabID(String docID, String orgDocID, String cabinetID, String companyID, int tenantID, Locale locale) throws Exception;

    /**
     * 결재완료문서에서 첨부파일로 쓰이는지 여부를 반환
     *
     * @param attachHref TBL_ENDATTACHINFO 테이블의 ATTACHFILEHREF 컬럼의 값
     * @NOTE 내부결재 시 반송 후 대장등록을 하면 대장등록되는 문서는 새로운 docid가 등록되면서 문서가 복사되지만, 첨부파일은
     * 복사되지 않고 기존의 첨부파일 경로를 쓰므로<br>
     * 반송된 문서를 재기안하여 첨부 버튼을 클릭하여 첨부되었던 파일을 삭제하면 대장등록되어있던 문서에서는 첨부파일을 다운로드할
     * 수 없게 됨.<br>
     * 따라서 첨부파일 삭제 시에 결재완료문서 중에서 해당 파일을 쓰고 있는지 판단하는 API를 추가함.<br>
     * <br>
     * <i>테넌트 파라미터를 안 받는 이유는 어차피 결재완료문서의 첨부파일이 삭제되면 안 되고, 파일 경로에
     * 테넌트가 포함되어있기 때문</i>
     */
    public boolean isLinkedAttachFile(String attachHref) throws Exception;

    /* FormBuilder */

    /**
     * 폼빌더 양식 여부를 반환
     *
     * @param formUrl 양식 경로
     */
    boolean isReform(String formUrl, String userId) throws Exception;

    /**
     * 폼빌더 양식 여부를 반환
     *
     * @param formId    양식 아이디
     * @param companyId 회사 아이디
     * @param tenantId  테넌트 아이디
     */
    boolean isReform(String formId, String companyId, int tenantId) throws Exception;

    /**
     * 폼빌더 양식 여부를 반환
     *
     * @param docSN     아이디@번호
     * @param companyId 회사 아이디
     * @param tenantId  테넌트 아이디
     */
    boolean isReformTempDoc(String docSN, String companyId, int tenantId) throws Exception;

    boolean isReformTempDoc(String formUrl) throws Exception;

    ApprGFormVO getReformInfoApprovalDocument(String docId, String userId, String companyId, int tenantId) throws Exception;
    /* FormBuilder end */

//	public void updateApprovConn(String docID, String companyID, int tenantID) throws Exception;
//
//	public void insertApprovConnSusin(String orgDocID, String formID, String companyID, int tenantID) throws Exception;

    public List<PortalTopOtherCompanyAddJobVO> getAllCompanyList(String id, int tenantId, String primary) throws Exception;

    public void setNonElecRecDocDelFlag(String docID, String companyID, int tenantID) throws Exception;

    public String susinNonElecRecDocDel(String docID, String companyID, int tenantID) throws Exception;

    public String getDocSendType(String docID, String companyID, int tenantID) throws Exception;

    public List<String> getRelayReqDeptID(String docID, String companyID, int tenantID) throws Exception;

    public ApprGDocInfoWebSrvVO getHWPdownload(String docID, int tenantID, String companyID) throws Exception;

    public String getDocNumZeroCnt(String companyID, int tenantID) throws Exception;

    public String setDocNumZeroCnt(String docNumZeroCnt, String companyID, int tenantID) throws Exception;

    public List<String> getShareOwnerId(String userID, int tenantID) throws Exception;

    public int getCheckAprState(String docID, String userID, String docState, String aprMemberSN, String companyID, int tenantID) throws Exception;

    public String checkHabYuiState(String docID, String companyID, int tenantID) throws Exception;

    public void setHesongCabinetID(String docID, String companyID, int tenantId) throws Exception;

    public String sendMailToNextAprMember(String docID, HttpServletRequest request, String loginCookie, LoginVO userInfo, String orgCompanyID, int tenantID) throws Exception;

    void setHesongBansongCabinetID(String docID, String cabinetID, String taskCode, String companyID, int tenantId) throws Exception;

    String getDeptIdOfCabinet(String orgCabinetId, int tenantId, String companyID) throws Exception;
	
	public String getStoragePeriodName(String period, String lang, String approvalFlag, String companyID, int tenantID) throws Exception;
	
	// 변환서버에 변환을 요청
	public String convertDocumentToImg(MultipartFile file, String tempUploadPath, String docId, int tenantId, String companyId, String userId, String ext) throws Exception;
	
	// 이미지로 변환된 오피스문서의 정보를 가져옴
	public JSONObject getConvertedImgInfo(String hash) throws Exception;

    public String getProxyUser2(String userID, String userLang, int tenantID, String offset) throws Exception;

    public List<ApprGProxyVO> getProxyUserInfo(String userID, String userLang, int tenantID, String offSet) throws Exception;

    public String enforceSihangDoc(String formURL, String docHref, String realPath, Locale locale, String companyID, int tenantID) throws Exception;

    ApprGFormVO getFormPath(String formId, String companyId, int tenantId) throws Exception;

    public List<ApprGOpenGovAttachVO> getAttachListForOpenGov(String docID, String companyID, String endFlag, int tenantId) throws Exception;

    public String getGongRamLineInfo(String docID, String mode, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String openGovInfoSave(String openGovListFlag, String fileOpenFlagList, String companyID, String basis, String reason, String publicity, String docID, String limitDate, int tenantId) throws Exception;

    public String getFormId(String formURL) throws Exception;

    public String getOpenGovFlag(String formId, int tenantId, String companyID) throws Exception;

    public Map<String, Object> getOpenGovInfo(String docID, int tenantId, String companyID) throws Exception;

    public String getSearchDocListForOpenGov(String string, String string2, String subQuery, String docNumber, String docTitle, String drafter,
                                             String formID, String formName, String draftFromYear, String draftFromMonth, String draftFromDay, String draftToYear, String draftToMonth,
                                             String draftToDay, String apprFromYear, String apprFromMonth, String apprFromDay, String apprToYear, String apprToMonth,
                                             String apprToDay, String string3, String string4, String string5, String string6, String string7, String string8,
                                             String draftDeptName, String docState, String string9, String pageSize, String pageNum, String orderCell,
                                             String orderOption, String string10, String companyID, String lang, String approvUser, int tenantId, String offset,
                                             String approvalFlag, String keyword, Locale locale) throws Exception;

    void deleteOpenGovDocInfo(String docID, String companyID, int tenantID) throws Exception;

    public ApprGOpenGovInfoVO getOpenGovInfoForUpdate(String docID, String companyID, int tenantId) throws Exception;

    public String updateOpenGovInfo(String openGovListFlag, String fileOpenFlagList, String basis, String reason,
                                    String publicity, String docID, String limitDate, String companyID, int tenantId, String modifyReason, LoginVO userInfo) throws Exception;

    public String getBansongDeptID(String docID, String orgCompanyID, int tenantID, LoginVO userInfo) throws Exception;
    
    public String updateReceivedDept(String docID, String processorID, String processorName, String processorJobTitle, String receivedDeptID, String receivedDeptName, String processorName2, String processorJobTitle2, String receivedDeptName2, String companyID, int tenantId) throws Exception;
    
    public String setApprDocInfo(Document xmlDom, String companyID, int tenantId) throws Exception;

    public String getFormAprOptionInfo(String key, String type, String companyID, int tenantID) throws Exception;
    
    /* 2024-11-14 홍승비 - 개인공유함, 부서공유함, 양식별 문서함 다국어 처리 */
    public List<ApprGFormVO> getFormContainer(int tenantId, String companyId, String deptId, String lang, String userId) throws Exception;

	public List<KEDSharedUserInfo> getShareList(String userId, String deptId, String shareType, String lang, int tenantId) throws Exception;
	
	public void delOpinionsExceptHesong(String docID, String companyID, int tenantId) throws Exception;

	public void delOpinionsExceptDrafters(String docID, String userID, String companyID, int tenantId) throws Exception;
	
	public void sendMailToPassAprMember(String docID, HttpServletRequest request, String loginCookie, LoginVO userInfo, String orgCompanyID, int tenantID) throws Exception;
	
	public String isPassAprLineShow(String docID, String formID, String userID, String companyID, int tenantId) throws Exception;
    
	/* 2020-07-23 홍승비 - 완료문서의 전체 정보를 가져오는 메서드 */
	public ApprGDocListVO getEndDocInfo(String docID, String companyID, int tenantID) throws Exception;
	
	/* 2020-07-23 홍승비 - 전달한 사용자ID에 대하여, 특정 진행문서의 전체 정보를 가져오는 메서드 */
	public ApprGDocListVO getIngDocInfo(String userID, String docID, String companyID, int tenantID) throws Exception;

	/* 2020-10-05 홍승비 - 임시저장문서의 결재선이 정상적인지 체크하는 메서드 */
	public String isTmpDocAprStateOK(String pDocSN, String userID, int tenantID, String companyID) throws Exception;

	public boolean isOuterForm(String formID, String companyID, int tenantID) throws Exception;
	
	public String updateDocInfo(String docID, LoginVO userInfo, String companyID, int tenantID, String delFlag, String delInfo) throws Exception;

	public String getAuditAdd(String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception;

	public String getGamsaYesanDeptInfo(String approvalFlag, String companyID, String lang, int tenantID) throws Exception;
	
	/* 2020-11-13 홍승비 - 특정 첨부파일이 대용량첨부인지, 대용량첨부라면 다운로드가 가능한지 체크하여 반환*/
	public String checkAttachFileCanDownload(String docID, String docAttachSN, String companyID, int tenantID) throws Exception;

	/* 2020-11-13 홍승비 - 대용량첨부파일의 다운로드횟수 초과여부 반환 */
	public String checkBigAttachFileDownloadCntOver(String docID, String docAttachSN, int bigSizeAttachDownloadLimitCount, String companyID, int tenantID) throws Exception;

	/* 2020-11-13 홍승비 - 대용량첨부파일의 다운로드 성공 시, 다운로드 카운트 증가 */
	public void updateBigAttachFileDownloadCnt(String docID, String docAttachSN, String companyID, int tenantID) throws Exception;

	/* 2020-11-13 홍승비 - 대용량첨부파일의 삭제 시, 다운로드 카운트 레코드 삭제 */
	public void deleteBigAttachFileDownloadCnt(String docID, String docAttachSN, String companyID, int tenantID) throws Exception;

	/* 2020-11-13 홍승비 - 자동삭제 스케줄러를 위한 대용량 첨부파일 리스트 리턴 (ISBIGATTACH = Y, ISBIGATTACHDEL = N) */
	public List<ApprGAttachInfoVO> getBigAttachFileForDelete(int tenantID) throws Exception;

	/* 2020-11-16 홍승비 - 대용량첨부파일의 삭제여부 플래그 갱신 */
	public void updateIsBigAttachDel(String docID, String docAttachSN, String tblName, String companyID, int tenantID) throws Exception;

	/* 2020-11-16 홍승비 - 첨부파일의 가장 작은 저장일자 리턴 */
	public String getAttachFileMinSaveDate(String docID, String companyID, int tenantID) throws Exception;
	 
	public Map<String, Object> getDocProcessState(String docID, String orgDocID, LoginVO userInfo) throws Exception;

	// 정주환 수신처 스케쥴러
	public void doSusinSchedule(HashMap<String,Object> map) throws Exception;

	/* 2021-04-19 홍승비 - 문서의 ORGDOCID를 리턴하는 ajax용 함수 추가 (mode에 따라서 진행문서, 완료문서 분기) */
	public String getOrgDocIDByMode(String docID, String mode, String orgCompanyID, int tenantID) throws Exception;
	
	public String getChaebunDept(String deptId, String orgCompanyID, int tenantID) throws Exception;
	
	public String getBujaeInfo(String userID, String deptID, int tenantID, String offset, String companyID) throws Exception;

    public int isMyDeptDeliveryDoc(String deptId, String docId, String orgCompanyID, int tenantID) throws Exception;
	
	public List<Map<String, Object>> getReceiptInfoIng(String docId, String receiptId, LoginVO userInfo) throws Exception;

	public List<HashMap<String,Object>> susinScheduleList() throws Exception;

    public String setSusinRollbackDocID(String beforeAprState, String docId, String orgDocId, LoginVO userInfo) throws Exception;

    public String getAccountingYear(String todayTime, String companyID, String langType, int tenantID) throws Exception;
    
    public void saveFilterDataInfo(String docID, String resultXML) throws Exception;
    
    public String checkbtnReSend24Display(String docID, String companyID, int tenantID) throws Exception;
    public Map<String, Object> getDoc24Info(String docID, String companyID, int tenantID) throws Exception;
    public void insertReciptInfoDoc24(String docID, String docDeptCode, String docDeptName, String companyId, int tenantId) throws Exception;
    
	public String getReceiptHistoryInfo(String docID, String deptID, String companyID, String lang, int tenantID, String offset) throws Exception;
    
    /* 2022-01-11 홍승비 - 일괄기안 시 표출할 양식 리스트 리턴 (deptID 파라미터를 전달하는 경우, 현재 사용자의 부서에서 접근 가능한 양식만 표출함) */
    public List<ApprGFormVO> getDraftAllFormInfo(String deptID, String companyID, int tenantID) throws Exception;
    
    /* 2022-01-17 홍승비 - 임시저장 또는 재기안을 위하여 그룹으로 묶인 일괄기안 문서정보 리턴 */
	public List<ApprGGroupDocInfoVO> getGroupDocList(String docID, String mode, int tenantId, String companyID) throws Exception;
	
	/* 2022-01-17 홍승비 - 임시저장 또는 재기안을 위하여 그룹으로 묶인 일괄기안 문서의 GROUPDOCSN값 리턴 */
	public String getGroupDocSN(String docID, int tenantId, String companyID) throws Exception;
	
	/* 2022-01-17 홍승비 - 일괄기안 > 1안의 일반첨부, 문서첨부 정보를 이후 추가된 안으로 복사 */
	public void copyDocAttach(ApprGAttachOptionVO apprGAttachOptionVO, String realPath) throws Exception;
	
	/* 2022-01-17 홍승비 - 일괄기안 > 1안의 결재선 정보를 이후 추가된 안으로 복사(덮어쓰기)함 */
	public void copyAprLine(ApprGAttachOptionVO apprGAttachOptionVO) throws Exception;
	
	/* 2022-01-17 홍승비 - 일괄기안 > 1안 이후 추가 시 원문공개 첨부파일 정보를 복사 */
	public void copyParentOpenGovFileInfo(String docID, String parentDocID, int tenantID, String companyID) throws Exception;
	
	public List<ApprGOpenGovAttachVO> getAttachListForOpenGovDraftAll(List<String> docIDAry, String companyID, int tenantId) throws Exception;
	
	public String saveTmpGroup(String docID, String tabSN, String groupDocSN, String userID, String lang, String companyID, int tenantID) throws Exception;
	
	// 임시저장용 순번 리턴 함수
	public String getMaxTMPDocSN(String userID, String companyID, String lang, int tenantID) throws Exception;
	
	/* 2022-01-27 홍승비 - 일괄기안 > 주어진 docID에 대해 일괄기안 데이터가 존재하는지 여부를 리턴 (Y/N) */
	public String checkIsGroupDoc(String userID, String docID, String companyID, int tenantID) throws Exception;
	
	/* 2022-02-10 홍승비 - 일괄기안 > 기존 임시저장된 일괄기안 레코드 삭제 및 새롭게 기안된 일괄기안 레코드 삽입 서비스 */
	public void saveAprGroupAndDelTmp(String docID, String tabSN, String newGroupDocSN, String tmpGroupDocSN, String orgCompanyID, int tenantID) throws Exception;
	
	/* 2022-02-10 홍승비 - 일괄기안 > 전달받은 DOCID 또는 DOCSN으로 GROUPDOCSN을 찾아 일괄기안그룹 레코드를 삭제하는 삭제 전용 메서드 */
	public void delGroupDocInfoByDocID(String docID, String mode, String orgCompanyID, int tenantID) throws Exception;

	/* 2022-02-11 홍승비 - 일괄기안 > 임시저장문서 또는 재기안문서 가져올 때 수신처 존재여부 체크 */
	public String getReceiptExists(String docID, String mode, String orgCompanyID, int tenantID) throws Exception;

	/* 2022-02-18 홍승비 - 일괄기안 > 그룹으로 묶인 1안의 보류의견 또는 반송의견을 각 안으로 복사하는 메서드 */
	public void copyFirstTabOpinion(String docID, String groupDocSN, String opinionType, String orgCompanyID, int tenantID) throws Exception;

	/* 2022-03-02 홍승비 - 현재 문서가 가진 총 의견의 갯수를 체크하여 의견 존재 여부를 리턴 (Y/N) */
	public String chkOpinionInfoExist(String docID, String orgCompanyID, int tenantID) throws Exception;

    String getFormIdFromApr(String docID, String companyID, int tenantID) throws Exception;
    
    /* 2022-03-08 홍승비 - 한글 전자결재 양식파일을 읽어 문서번호 필드의 포맷을 리턴 */
	public String getHWPDocNumFormatByFormID(String formID, String realPath, String orgCompanyID, int tenantID) throws Exception;
	
    /* 2022-03-17 홍승비 - 미처리문서함에 들어온 내부시행문의 반송 메서드 (완료된 문서의 의견테이블에 접근) */
	public String updateOpinionSihangReject(Document docXML, String companyID, String lang, int tenantId) throws Exception;
	
	/* 2022-03-17 홍승비 - 미처리문서함에 들어온 내부시행문 반송 시 완료문서의 기존 의견을 전부 삭제 */
	public String deleteEndOpinionInfo(String docID, String companyID, String lang, int tenantID) throws Exception;
	
	/* 2022-03-17 홍승비 - 결재완료된 내부시행문 미처리문서함에서 반송 동작 추가 (완료문서 테이블에 접근) */
	public String doSihangConvReject(String docID, String recordID, String userID, String deptID, String companyID, int tenantID) throws Exception;
	
	/* 2020-11-17 정소미 - 전자결재 미리보기 설정*/
	public String setApprovConfig(String userID, String preView, int tenantID) throws Exception;
	public String getApprovConfig(String userID, int tenantID) throws Exception;
	
    /* 2022-06-28 홍승비 - 전달한 DOCID로 진행중문서(APR) 또는 완료문서(END) 여부를 문자열로 리턴 */
	public String getAprOrEndStr(String docID, String companyID, int tenantID) throws Exception;

	/* 2022-07-20 홍승비 - 기록물철등록부 > 기록물보기로 진입 시 해당 기록물철의 생산년도를 가져오기 위한 메서드 */
	public String getCabProduceYear(String cabinetClassNo, String companyID, int tenantID) throws Exception;

    /* 2023-06-26 민지수 - 완료문서 추가의견 삭제 */
    public String deleteAddOpinionInfo(String docID, String companyID, String lang, int tenantId) throws Exception;

    /* 2023-06-26 민지수 - 완료문서 추가의견 저장 */
    public String updateAddOpinionInfo(Document docXML, String companyID, String lang, int tenantID) throws Exception;

    /* 2023-10-04 박기범 - 유저의 부재 설정 정보를 list vo 로 호출 */
    List<ApprGOutOfOfficeInfoVO> getListOutOfOfficeInfo(String userID, int tenantID) throws Exception;

    /* 2023-10-04 박기범 - 유저의 현재 설정된 부재의 끝나는 시간 */
    Optional<ZonedDateTime> getEndOfAbsence(String userID, int tenantID, String offset);

    /* 2023-10-05 박기범 - 유저의 현재 설정된 부재 클리어 */
    void cleanAbsence(String userID, int tenantID);

    /* 2023-06-20 전인하 - 전자결재G > 기록물대장 미리보기 - 보안결재여부와 지정된 날짜를 체크하는 메소드 */
    public String checkSecurityApprovalDate(String docID, String companyID, int tenantID, String linemode) throws Exception;
    
	// 2023-09-25 전인하 - 전자결재G > 배부대장 미리보기 > 진행문서 열람권한 조회
    public String getAccessYNGforAPR(String docID, String mode, String approvalFlag, LoginVO userInfo) throws Exception;
    
    /* 2023-11-30 홍승비 - 전자결재 > 서명 재맵핑 > TBL_SIGNINFO 테이블의 결재서명 데이터를 XML(문자열) 형식으로 가져오는 메서드 */
	public String getAllAprSignDataXML(String docID, String companyID, int tenantID) throws Exception;
	
	/* 2023-03-20 한태훈 - 전자결재 > 기록물등록대장, 완료문서조회 > 다중 선택 문서 통합PC저장 메서드 */
	public String totalSaveDownloadAll(String[] docIDArr, LoginVO userInfo, String type, String approvalFlag, String accessInfo, String realPath, String opinionTxtFileName, String opinionWriterMark, String opinionContentMark, String attMark) throws Exception;

	/* 2023-03-22  한태훈 - 전자결재 > 통합PC저장시 완료문서 하나의 모든 의견 정보 리턴 */
	public List<ApprGOpinionVO> getDocOpinionList(String docID, LoginVO userInfo) throws Exception;

	/* 2023-03-22 한태훈 - 전자결재  > 단일/다중 문서 통합PC저장 다운로드 이력 남기기 (차후 다운로드 이력 외 다른 이력 삽입 가능) */
	public void insertTotalSaveHistory(List<String> docIDlist, LoginVO userInfo, String gubun)throws Exception;

	/* 2023-03-28 한태훈  - 전자결재G > 기록물등록대장, 완료문서조회 > 다중 문서 통합PC저장 시 선택된 보안결재 문서들 결재선 포함 여부 확인 (현재 사용자가 결재선상에 존재해야 다운로드 가능) */
	public String checkAprLineAll(String[] docIDarr, String mode, String userID, String companyID, int tenantID) throws Exception;

	/* 2023-04-12 한태훈 - 전자결재  > 단일 문서 통합PC저장 시 완료문서의 의견 내용 전체를 문자열 형태의 내용으로 만들어서 리턴하는 메소드 */
	public String makingOpinionFileContent(LoginVO userInfo, List<ApprGOpinionVO> apprGOpinionList, String opinionWriterMark, String opinionContentMark, String lineSepearator) throws Exception;

	/* 2023-04-12 한태훈 - 전자결재G  > 기록물등록대장, 완료문서조회 > 다중 문서 통합PC저장 시 파일들을 압축 파일 안에 다운로드 하여주는 메소드 */
	public void downloadFileInZip(String realPath, String filePath, String fileName, String folderName, ZipOutputStream zout, Map<String, Integer> fileNameMap, boolean isAttachYN, String attMark) throws Exception;

	/* 2023-04-12 한태훈 - 전자결재G  > 기록물등록대장, 완료문서조회 > 다중 문서 통합PC저장 시 하나의 의견내용을 양식에 맞게 만들어주는 메소드 */
	public StringBuilder makeOneOpinionContent(StringBuilder sb, LoginVO userInfo, String lineSepearator, String opinionWriterMark, String opinionContentMark, ApprGOpinionVO apprGOpinion) throws Exception;

	/* 2023-04-12 한태훈 - 전자결재G  > 기록물등록대장, 완료문서조회 > 통합PC저장 시 의견 파일을 .zip 파일에 넣어주는 메소드 */
	public void downloadOpinionFileInZip(String realPath, String tempOpinionFilePath, String opinionTxtFileName, StringBuilder sb, String saveFolderName, ZipOutputStream zout) throws Exception;

    // 2024-06-07 전인하 - 기록물대장 > 하위부서 리스트 조회
    public List<OrganDeptVO> getUnderDeptList(LoginVO userInfo) throws Exception;

    public String attachRecordDoc(LoginVO userInfo, String newDocID, Object attachedDocList) throws Exception;

    /* 2024-06-24 양지혜 - 지정반송 > 반송위치에 표출할 결재라인 호출 */
    String getReturnUserList(String docId, int tenantId, String companyId) throws Exception;

    /* 2024-06-24 양지혜 - 지정반송 > 결재라인 업데이트 */
    String updateReturnByDesignation(LoginVO userInfo, String docID, String returnUserSN) throws Exception;

    void changeAprUserInfo(HttpServletResponse response, String deptID, String deptName, String deptName2, String companyName, String companyName2, String title, String title2, String companyID, String jobID) throws UnsupportedEncodingException;
    
    // 2024-04-23 한태훈 > 결재 알림 발송 위한 결재 문서 정보 가져오기
    public ApprGDocListVO getDocInfoForNoti(String companyID, String docID, int tenantID, String mode) throws Exception;
    
    // 2024-04-23 한태훈 > 결재 알림 발송 위한 결재 순서 가져오기
    public ApprGDocListVO getAprMemberSnForNoti(String companyID, String docID, int tenantID, String userID) throws Exception;
    
    // 2024-04-23 한태훈 > 결재 알림 발송 위한 수신 처리 정보 가져오기
	public ApprGSusinProcessInfoVO getSusinProcessInfo(String docID, int tenantID, String deptId, String companyID, String receiveUserId) throws Exception;
	
	// 2024-04-23 한태훈 > 결재 알림 발송 위한 공람 결재선 정보 가져오기
	public List<ApprGAprLineVO> getGongramAprLineInfo(String docID, String companyID, int tenantId) throws Exception;
	
	// 2024-04-23 한태훈 > 결재 알림 발송
	public String sendNoti(String docID, String senderId, String senderName, String recipientId, String recipientName, String recipientDeptId, String mode, String companyID, String lang, int tenantID) throws Exception;

    // 문서가 parentDocID 의 문서첨부가 맞는지 확인
    public boolean isAttachDoc(String docID, String parentDocID, String userID, String companyID, int tenantID) throws Exception;

    /* 2024-06-11 조소정 - 공람할문서 또는 공람완료문서 재사용 시 원문서 ID 가져오기 */
	public String getOrgDocIDfromGongram(String beforeDocID, String companyID, int tenantId) throws Exception;

	/* 2023-05-16 임정은 - 전자결재G > 기록물등록대장 > 공람정보 > 공람회수  */
	public String gongRamCancel(String docID, int count, int aprMemberSN, String companyID, int tenantId) throws Exception;
    
    // 2024-04-24 조수빈 - hwp 문서 접수 처리 
    public String receiptAll_HWP(String userID, String result, String formID, String keyVal, String docID, String orgUID, String langType, String companyID, HttpServletRequest request, LoginVO userInfo, String mode, String aprMemberSN, Document strXML, String orgDocID, String loginCookie) throws Exception;

    // 2024-04-24 조수빈 - mht 문서 접수 처리 
    public String receiptAll_MHT(String userID, String result, String formID, String keyVal, String docID, String orgUID, String strLang, String companyID, HttpServletRequest request, LoginVO userInfo, String mode, String aprMemberSN, Document strXML, String orgDocID, String loginCookie) throws Exception;
    
    // 2024-04-24 조수빈 - hwp 서명란 세는 메소드
    public int getHwpSignCount(String href, String key, HttpServletRequest request, LoginVO userInfo) throws Exception;

    // 2024-04-24 조수빈 - 일괄 수신 처리 중 에러 발생할 경우 수신 상태를 원래대로 돌려놓는 메소드
	public void resetSusinDoc(String orgDocID, String docID, String deptID, String userID, String companyID, int tenantID) throws Exception;
	
	// 2024-04-23 조수빈 - 요소의 스타일 속성을 map으로 반환
	public Map<String, String> getElemStyleMap(Element elem) throws Exception;
	
	// 2024-04-23 조수빈 - map을 html style 문자열로 반환
	public String convStyleMap2String(Map<String, String> styleMap) throws Exception;
	
	// 2024-06-10 조수빈 - config.useOpenGov = YES일 때 일괄 접수 처리에서는 createDate만 업데이트하기 위한 메소드
	public void updateCreateDateOfOpenGovDocInfo(String docID, int tenant_id, String companyID);

    /* 2024-07-08 임정은 - 전자결재G > 기록물배부대장 > 배부정보  > 문서 기본정보 가져오기 */
    public ApprGDeliveryListVO getDistributeInfo(String docId, String companyId, int tenantId) throws Exception;

    /* 2024-07-09 임정은 - 전자결재G > 기록물배부대장 > 배부정보 > 문서 배부정보 가져오기 */
    public List<ApprGDeliveryListVO> getDistributeInfo2(String docId, String deliverySN, String deptId, String companyID, int tenantId, String offset) throws Exception;
	
	// 2024-09-11 이가은 - 사이트용 포탈 포틀릿 결재 진행문서 리스트
	public List<ApprGDocListVO> portletAprDocList(PortletAprInfoVO portletAprInfoVO) throws Exception;

	// 2024-09-11 이가은 - 사이트용 포탈 포틀릿 결재 완료문서 리스트
	public List<ApprGDocListVO> portletEndAprDocList(PortletAprInfoVO portletAprInfoVO) throws Exception;
    
	// 2024-09-11 이가은 - 사이트용 포탈 포틀릿 결재문서 url 링크 반환
    public String getRedirectUrl(String docID, String mode, LoginVO userInfo);

	public Map<String, Object> getDocRightInfoForAttachApr(String[] docIdList, String userId, String deptId, String rollInfo, String accessInfo, String approvalFlag, String lang, String companyId, int tenantId) throws Exception;
    
    /* 2024-07-11 기민혁 - 전자결재G > 자동 임시저장 문서 확인  */
    public String checkAutoSaveDocId(String docID, String companyID, int tenantId) throws Exception;

    /* 2024-12-10 기민혁 - 전자결재 > 수정 버전 호출 */
    public String getEditVersion(String docID, String companyID, int tenantID) throws Exception;

    /* 2024-12-25 기민혁 - 전자결재 > 일괄 지정 수신 문서 확인 */
    public ApprGReceiveDocVO checkDocReceiveInfo(String companyID, int tenantID, String docID, String receiveSN) throws Exception;

    public Map<String, String> getUpperDeptInfo(String pDeptID, int tenantId) throws Exception;

    public String getSameDeptBoxUseID(String deptID, int tenantId) throws Exception;
    
    // 2024-12-27 이가은 - 전자결재 공람완료문서 삭제 로직
    public String gongramDocDelete(String docID, int aprmemberSn, int tenantID, String companyID) throws Exception;
	
	// 2024-12-19 이가은 - 전자결재 일괄배부 로직
    public String setBebuAll(Document xmlDom, String dirPath, String companyID, String lang, int tenantID, String offSet, LoginVO userInfo, String curDocNum) throws Exception;

    public ApprGSummaryVO getSummaryDB(String docID, String companyID, int tenantID, String mode) throws Exception;
    
    public String getSummaryFileContent(ApprGSummaryVO summary) throws Exception;
    
    public void saveSummaryDB(ApprGSummaryVO summary, String mode) throws Exception;
    
    public String saveSummaryFileContent(ApprGSummaryVO summary, String summaryMhtStr, String mode) throws Exception;
    
    public void deleteSummaryFile(String docID, String companyID, int tenantID) throws Exception;
    
    public String copySummary(ApprGSummaryVO summary, String newDocID, String mode) throws Exception;

    //2025-02-18 박기범 - 프론트에서 문서 편집시, 문서를 오픈한 이후로 다른 문서/결재진행 변화가 있었는지 체크하기 위한 코드
    String getDocumentSnapshotCode(int tenantId, String companyId, String docId) throws Exception;
    
    // 2025-05-28 전인하 - 그리기 서명 이미지 저장하는 코드 / 웹한글기안기 문서 지원을 위해 서명 이미지는 외부저장해야 함
    public String saveSignImg(MultipartFile signImg, String companyID, int tenantID) throws Exception;
}
