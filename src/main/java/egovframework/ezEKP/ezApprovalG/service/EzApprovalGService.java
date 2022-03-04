package egovframework.ezEKP.ezApprovalG.service;

import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachOptionVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocInfoWebSrvVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGGroupDocInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpenGovAttachVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpenGovInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGProxyVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSecondApprVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGgetDeptStacticsVO;
import egovframework.ezEKP.ezApprovalG.vo.KEDSharedUserInfo;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopOtherCompanyAddJobVO;
import egovframework.let.user.login.vo.LoginVO;

import org.json.simple.JSONObject;
import org.springframework.web.multipart.MultipartFile;
import org.w3c.dom.Document;

import javax.servlet.http.HttpServletRequest;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public interface EzApprovalGService {

    // 캐비닛 기록물철 문서 삭제
    public String deleteCapInfo(String cabinetID, String companyID, int tenantID) throws Exception;

    // 캐비닛 기록물철 문서 삭제 정보 추가
    public String insertDelCapInfo(String cabinetID, String delUserID, String ipAddress, String companyID, int tenantID) throws Exception;

    // 캐비닛 기록물철 삭제 전 진행중문서 확인
    public String selectExpCabDocInfo(String cabinetID) throws Exception;

    public List<ApprGLeftVO> getUseContInfo(LoginVO userInfo, String ownFlag) throws Exception;

    public List<ApprGgetDeptStacticsVO> getDeptStactics(String pStartDate, String pEndDate, String pLang, String companyID, int tenantID) throws Exception;

    public String getOptionInfo(String code1, String code2, LoginVO userInfo, String mode) throws Exception;

    public String aprDocList(String listType, String userID, String deptID, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String userLang, String searchQuery, Document dueryData, int tenantID, String offSet) throws Exception;

    public String getProxyUser(String id, String lang, int tenantID, String offset) throws Exception;

    public String getAprLineInfoDB(String docID, String flag, String userID, String formID, String companyID, int tenantID, String isUsed, String beforeDocID, String mode, String docState) throws Exception;

    public String getListHeader(String listCode, String companyID, String lang, int tenantID) throws Exception;

    public String getCode2Name(String code1, String code2, String companyID, String lang, int tenantID) throws Exception;

    public String getListField(String fieldName, String fieldValue, String companyID, String userLang, int tenantID, String offSet) throws Exception;

    public String getAccessYNG(String docID, String userID, String mode, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;

    public String getLineInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;

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

    public String getTaskSubCategoryAll(String deptCode, String companyID, String cateCode, String strType, String initFlag, int tenantID) throws Exception;

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

    public String getRecordList(Document doc, String lang, int tenantID, String offset) throws Exception;

    public String getCodeInfo(String companyID, String lang, int tenantID) throws Exception;

    public String getAttachDocInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset, String approvalFlag) throws Exception;

    public String isCabCharger(String companyID, String cabClassNo, String userID, int tenantID) throws Exception;

    public String updateAttachDocInfo(Document doc, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;

    public String deleteAttachDocInfo(String docID, String companyID, String lang, int tenantID) throws Exception;

    public String getDocInfo(String docID, String mode, String selected, LoginVO userInfo, String companyID, int tenantID, String isUsed, String beforeDocID) throws Exception;

    public void saveRecReadHist(String readRecXML, int tenantID) throws Exception;
    
	public String doApprove(String docID, String userID, String aprState, String userName, String userName2, String dirPath, String deptID, String proxyUserID, String companyID, String lang, LoginVO userInfo, String curDocNum, String chamState, String nonElecRecYN, String passAprLine) throws Exception;

    public String receiverChk(String deptID, String companyID, int tenantID) throws Exception;

    public String getEA5Value(String msg, int tenantID, String companyID) throws Exception;

    public String getMyTaskCode(String userID, String deptID, String companyID, String lang, int tenantID) throws Exception;

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

    public String getReceiveDocList(String userID, String deptID, String receiveDocMode, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String userLang,
                                    String searchQuery, Document xmlDomSub, int tenantID, String offset) throws Exception;

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

    public String doCallBack(String docID, String userID, String companyID, int tenantID) throws Exception;

    public String getFormConnFlag(String docID, String companyID, int tenantID) throws Exception;

    public String getInnerLineInfo(String docID, String deptID, String docState, String companyID, int tenantID) throws Exception;

    public String getSearchDocList(String containerID, String userID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String formName, String draftFromYEAR, String draftFromMONTH,
                                   String draftFromDAY, String draftToYEAR, String draftToMONTH, String draftToDAY, String apprFromYEAR, String apprFromMONTH, String apprFromDAY, String apprToYEAR, String apprToMONTH,
                                   String apprToDAY, String myApprFromYEAR, String myApprFromMONTH, String myApprFromDAY, String myApprToYEAR, String myApprToMONTH, String myApprToDAY, String draftDeptName,
                                   String docState, String aprFlag, String pageSize, String pageNum, String orderCell, String orderOption, String alFlag, String companyID, String lang, String approvUser, int tenantID, String offset, String approvalFlag, Locale locale) throws Exception;

    public String updateSignCheck(String docID, String signCheck, String companyID, int tenantID) throws Exception;

    public String aprAttachMail(String docID, String flag, String companyID, int tenantID) throws Exception;

    public String makeTaskFullListXml(Document docXML, String companyID, String pageSize, String pageNO, String langType, int tenantID) throws Exception;

    public String getContDocList(String containerID, String userID, String subQuery, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String getGamSaSearchDocList(String containerID, String userID, String deptID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String draftFromYEAR,
                                        String draftFromMONTH, String draftFromDAY, String draftToYEAR, String draftToMONTH, String draftToDAY, String apprFromYEAR, String apprFromMONTH, String apprFromDAY, String apprToYEAR,
                                        String apprToMONTH, String apprToDAY, String myApprFromYEAR, String myApprFromMONTH, String myApprFromDAY, String myApprToYEAR, String myApprToMONTH, String myApprToDAY,
                                        String draftDeptName, String docState, String aprFlag, String pageSize, String pageNum, String orderCell, String orderOption, LoginVO userInfo) throws Exception;

    public String getUncompleteDocCount(String deptID, String companyID, String cabinetID, int tenantID) throws Exception;
    
    public String getUncompleteDocList(String deptID, String companyID, String cabinetID, int tenantID, String userLang, LoginVO userInfo) throws Exception;

    public String transferCabinet(Document xmlDom, int tenantID) throws Exception;
    
	/* 2020-02-24 홍승비 - 편집 전후 문서를 판단하기 위한 플래그 isBeforeDoc, 편집전문서 파일경로 beforeDocURL 추가 */
	public String updateHistoryForDoc(String docID, String url, String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String userDeptID, String userDeptName, String userDeptName2, String isBeforeDoc, String beforeDocURL, LoginVO userInfo)  throws Exception;

    public String gongRamUpdate(String docID, String userID, String companyID, String lang, int tenantID) throws Exception;

    public String delayCabEndY(String deptCode, String flag, String cabClassList, String companyID, int tenantID) throws Exception;

    public String getUncabinetedDocCount(String deptID, String confirmYN, String companyID, int tenantID) throws Exception;

    public String chkIfNotArrangedCabExist(String deptID, String companyID, int tenantID) throws Exception;

    public String confirmClassify(String deptID, String companyID, int tenantID) throws Exception;

    public String getSendOutDocList(String userID, String deptID, String susinManagerFlag, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, int tenantID, String offset, String searchQuery) throws Exception;

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

    public String makeTmp2IngDocInfo(String userID, String sn, String companyID, String lang, int tenantID, String docID) throws Exception;

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

    public String getAprDocList(String pListType, String userID, String userDeptID, String pageSize, String pageNum, String sortHeader, String sortOption, String companyID, String pSubQuery, String strLang, int tenantID, String offset) throws Exception;

    public Map<String, Object> getPortletAprList(Map<String, Object> param, String offset) throws Exception;

    public Map<String, Object> getPortletApprGapTime(Map<String, Object> param) throws Exception;

    public String getRecordHistory(Document xmlDom, LoginVO userInfo) throws Exception;

    public String moveRecord(Document xmlDom, String lang, int tenantID) throws Exception;

    public String getRecordSimpleInfo(Document xmlDom, String lang, int tenantID, String offset) throws Exception;

    public String changeRecordInfo(Document xmlDom, String lang, String offset, int tenantID) throws Exception;

    public String getDeliveryList(String p_DeptID, String pPageSize, String pPageNum, String pOrderCell, String pOrderOption, String pQuery, String companyID, String lang, String deptcode, String deptcode2, String title, String sregdate, String eregdate, String debenturer, String isdocprint, String extReceptYN, LoginVO userInfo) throws Exception;

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

    public int getWebPartListCount(String listType, String userID, String deptID, String userIDS, String deptIDS, String userFlag, String companyID, String lang, int tenantID, String offset) throws Exception;

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

    public String getUserContList(String pContID, String pSubQuery, String pPageSize, String pPageNum, String oc, String oo, String companyID, String lang, Document tempDueryDATA, int tenantID, String offSet, String userID) throws Exception;

    public String getUserContListAll(String pContID, String pSubQuery, String pPageSize, String pPageNum, String oc, String oo, String companyID, String lang, Document tempDueryDATA, int tenantID, String offSet) throws Exception;

    public String deleteUserContDoc(String docID, String contID, String companyID, String lang, int tenantId) throws Exception;

    public String getSearchDocListS(String containerID, String userID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String formName, String draftfrom, String draftto, String apprfrom, String papprto, String mypapprfrom, String mypapprto,
                                    String draftDeptName, String docState, String AprFlag, String deptID, String pageSize, String pageNum, String orderCell, String orderOption, String searchStatus, String companyID, String lang, String string2, int tenantID, String offSet, String approvalFlag, Locale locale) throws Exception;

    public List<ApprGContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception;

    public List<ApprGFormVO> getFormInfoByPortal(String formContID, String kind, String searchType, String searchName, String userID, String companyID, String lang, int tenantID) throws Exception;

    public String getAutoDocNumItem(String formID, String lang, String companyID, int tenantID) throws Exception;

    public String doSendOfferS(Document docXML, String companyID, String lang, int tenantID) throws Exception;

    public String checkResend(String docID, String companyID, int tenantId) throws Exception;

    public String doHabyuiHesong(Document doc, String dirPath, String companyID, String lang, int tenantId, LoginVO userInfo, String curDocNum) throws Exception;

    public List<String> getAddress(String userIDs, int tenantID) throws Exception;

    public String deleteSignInfo(String docID, String companyID, int tenantID) throws Exception;

    public String getSameOrgHAPYUIDoc(String docID, String companyID, String lang, int tenantID) throws Exception;

    public String getDocHref(String docID, String docStatus, String type, String docAttachSN, String companyID, int tenantId) throws Exception;

    public String getDocInfoS(String docID, String mode, String selected, LoginVO userInfo, String companyID, int tenantID) throws Exception;

    public String getIsUse(String code1, String code2, String companyID, String userLang, int tenantID) throws Exception;

    public String gongRamSaveIng(Document xmlDom, String dirPath, String companyID, String lang, int tenantId, String offset) throws Exception;

    public void delCirculation(String docID, String companyID, int tenantID) throws Exception;

    public String getCirculationinfo(String docID, String mode, String companyID, String lang, int tenantID, String offset) throws Exception;

    public String setCabinetHesong(String docID, String deptID, String deptName, String deptName2, String userName, String userName2, String dirpath, String docSN, String companyID, String lang, int tenantId, String offset, Locale locale) throws Exception;

    public String doBansong(String docID, String childDocID, String userID, String aprState, String dirPath, String deptID, String companyID, String lang, LoginVO userInfo, String curDocNum) throws Exception;

    public String doBoryu(String docID, String userID, String aprState, String companyID, String lang, int tenantID) throws Exception;

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

    public void setNonElecRecCabID(String docID, String orgDocID, String cabinetID, String companyID, int tenantID) throws Exception;

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

    public List<PortalTopOtherCompanyAddJobVO> getAllCompanyList(String id, int tenantId) throws Exception;

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
	public String convertDocumentToImg(MultipartFile file, String tempUploadPath, String docId, int tenantId, String companyId, String userId) throws Exception;
	
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
    
    public List<ApprGFormVO> getFormContainer(int tenantId, String companyId, String deptId, String userId);

	public List<KEDSharedUserInfo> getShareList(String userId, String deptId, String shareType, int tenantId) throws Exception;
	
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
	public void delGroupDocInfoByDocID(String docID, String orgCompanyID, int tenantID) throws Exception;

	/* 2022-02-11 홍승비 - 일괄기안 > 임시저장문서 또는 재기안문서 가져올 때 수신처 존재여부 체크 */
	public String getReceiptExists(String docID, String mode, String orgCompanyID, int tenantID) throws Exception;

	/* 2022-02-18 홍승비 - 일괄기안 > 그룹으로 묶인 1안의 보류의견 또는 반송의견을 각 안으로 복사하는 메서드 */
	public void copyFirstTabOpinion(String docID, String groupDocSN, String opinionType, String orgCompanyID, int tenantID) throws Exception;

	/* 2022-03-02 홍승비 - 현재 문서가 가진 총 의견의 갯수를 체크하여 의견 존재 여부를 리턴 (Y/N) */
	public String chkOpinionInfoExist(String docID, String orgCompanyID, int tenantID) throws Exception;

    String getFormIdFromApr(String docID, String companyID, int tenantID) throws Exception;

}
