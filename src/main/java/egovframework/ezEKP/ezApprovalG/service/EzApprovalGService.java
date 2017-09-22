package egovframework.ezEKP.ezApprovalG.service;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSecondApprVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGgetDeptStacticsVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzApprovalGService {
	
	// 캐비닛 기록물철 문서 삭제
	public String deleteCapInfo(String cabinetID, String companyID, int tenantID) throws Exception;

	// 캐비닛 기록물철 문서 삭제 정보 추가
	public String insertDelCapInfo(String cabinetID, String delUserID, String ipAddress, String companyID, int tenantID) throws Exception;
	
	// 캐비닛 기록물철 삭제 전 진행중문서 확인
	public String selectExpCabDocInfo(String cabinetID) throws Exception;
	
	public List<ApprGLeftVO> getUseContInfo(LoginVO userInfo, String ownFlag) throws Exception;
	
	public List<ApprGgetDeptStacticsVO> getDeptStactics (String pStartDate, String pEndDate, String pLang, String companyID, int tenantID) throws Exception;

	public String getOptionInfo(String code1, String code2, LoginVO userInfo, String mode) throws Exception;

	public String aprDocList(String listType, String userID, String deptID, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String userLang, String searchQuery, Document dueryData, int tenantID, String offSet) throws Exception;

	public String getProxyUser(String id, String lang, int tenantID, String offset) throws Exception;

	public String getAprLineInfoDB(String docID, String flag, String userID, String formID, String companyID, int tenantID) throws Exception;
	
	public String getListHeader(String listCode, String companyID, String lang, int tenantID) throws Exception;
	
	public String getCode2Name(String code1, String code2, String companyID, String lang, int tenantID) throws Exception;
	
	public String getListField(String fieldName, String fieldValue, String companyID, String userLang, int tenantID, String offSet) throws Exception;

	public String getAccessYNG(String docID, String userID, String mode, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;

	public String getLineInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String getAttachInfo(String docID, String flag, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String getReceiptInfo(String docID, String flag, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset, String approvalFlag) throws Exception;
	
	public String getOpinionInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;

	public String getWebPartList(String listType, String userID, String deptID, String listCount, String mode, String userFlag, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String getDocType(String selected, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;
	
	public String getFormInfo(String formContID, String kind, String searchType, String searchName, String userID, String companyID, String lang, int tenantID) throws Exception;

	public String getFormContainerInfo(String id, String deptID, String companyID, String primary, int tenantID, String approvalFlag) throws Exception;
	
	public String setUserFormInfo(String formID, String userID, String companyID, int tenantID) throws Exception;
	
	public String delUserFormInfo(String formID, String userID, String companyID, int tenantID) throws Exception;
	
	public String getApprovalPWD(String userID, int tenantID, String companyID) throws Exception;
	
	public String getSecurityType(String selected, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;
	
	public String getAprType(String approvalFlag, String companyID, String lang, int tenantID) throws Exception;
	
	public String getAprLineInfo(String docID, String userID, String formID, String companyID, String lang, int tenantID, String offset, String reDraftFlag) throws Exception;
	
	public String getTempList(String userID, String formID, String companyID, String lang, int tenantID) throws Exception;
	
	public String updateLineInfo(String ret, String companyID, String lang, LoginVO userInfo) throws Exception;
	
	public String updateReceiptInfo(String ret2, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;
	
	public String getLineTempletInfo(String formID, String userID, String companyID, int tenantID) throws Exception;
	
	public String getLineTempletDetailInfo(String formID, String userID, String aprSN, String companyID, String lang, int tenantID) throws Exception;
	
	public String getFormInfoDetail(String formID, String companyID, int tenantID) throws Exception;
	
	public String getFormRecvApr(String docID, String formID, String userID, String companyID, String lang, int tenantID) throws Exception;
	
	public String createNewDoc(String formID, String companyID, int tenantID) throws Exception;
	
	public String deleteDocInfo(String docID, String mode, String companyID, int tenantID) throws Exception;
	
	public String updateLineTempletDetailInfo(Document xmlDom, Locale locale, String companyID, String lang, int tenantID) throws Exception;
	
	public String deleteLineTempletDetailInfo(String formID, String userID, String aprLineSN, String companyID, int tenantID) throws Exception;
	
	public String addToAprLine(String userID, String formID, String aprSN, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String getReceiptTempletInfo(String formID, String userID, String companyID, int tenantID) throws Exception;
	
	public String getReceiptTempletDetailInfo(String formID, String userID, String aprSN, String companyID, String lang, int tenantID, String offSet, String approvalFlag) throws Exception;
	
	public String getTempList(String companyID, String lang, int tenantID) throws Exception;
	
	public String getTempList2(String groupID, String companyID, String lang, int tenantID) throws Exception;
	
	public String getTempList3(String userID, String formID, String companyID, String lang, int tenantID) throws Exception;
	
	public String getListXML(String groupID, String lang, String companyID, int tenantID, String approvalFlag) throws Exception;
	
	public String addToAprDept(String userID, String formID, String aprDeptSN, String companyID, String lang, int tenantID, String offset, String approvalFlag) throws Exception;
	
	public String deleteReceiptTempletDetailInfo(String formID, String userID, String aprDeptSN, String companyID, int tenantID) throws Exception;
	
	public String updateReceiptTempletDetailInfo(Document doc, String companyID, int tenantID, String approvalFlag) throws Exception;
	
	public String getTaskCategory(String deptCode, String companyID, String type, int tenantID) throws Exception;
	
	public String getTaskMiddleCategory(String deptCode, String companyID, String cateCode, int tenantID) throws Exception;
	
	public String getTaskSubCategory(String deptCode, String companyID, String cateCode, String strType, int tenantID) throws Exception;
	
	public String getTaskInSubCategory(String deptCode, String companyID, String cateCode, String strType, String langType, int tenantID, String approvalFlag) throws Exception;
	
	public String getSimpleCabinetList(String companyID, String processDeptCode, String productionYear, String taskCode, String flag, String langType, int tenantID) throws Exception;
	
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
	
	public String getDocInfo(String docID, String mode, String selected, LoginVO userInfo, String companyID, int tenantID) throws Exception;
	
	public void saveRecReadHist(String readRecXML, int tenantID) throws Exception;
	
	public String receiverChk(String deptID, String companyID, int tenantID) throws Exception;
	
	public String getEA5Value(String msg, int tenantID, String companyID) throws Exception;
	
	public String getMyTaskCode(String userID, String deptID, String companyID, String lang, int tenantID) throws Exception;
	
	public String setMyTaskCode(String userID, String deptID, String cabinetID, String taskCode, String type, String companyID, int tenantID) throws Exception;
	
	public String getCabinetInfo(String cabinetID, String companyID, String strType, int tenantID) throws Exception;
	
	public String registerSepAttach(Document doc, int tenantID, Locale locale) throws Exception;
	
	public String getHistoryForDoc(String docID, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String getHistoryForLine(String docID, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String getHistoryForAttach(String docID, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset, String approvalFlag) throws Exception;
	
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
	
	public String getApproveDocInfo(LoginVO userInfo, String docID, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String getLastOpinionContent(String docID, String companyID, String lang, int tenantID) throws Exception;
	
	public String getSignInfo(String docID, String offset, Locale locale, String companyID, int tenantID) throws Exception;
	
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
	
	public String getNextDocInfo(String docID, String userID, String userDeptID, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String registerCabinet(Document xmlDom, String strLang, int tenantID) throws Exception;
	
	public String getNewVolumeNo(String cabClassNO, String companyID, int tenantID) throws Exception;
	
	public String addNewVolume(String cabClassNO, String newVolNO, String companyID, int tenantID) throws Exception;
	
	public String getFindSimpleCabinetList(String processDeptCode, String productionYear, String searchKeyword, String flag, String companyID, String langType, int tenantID) throws Exception;
	
	public String setBebu(Document xmlDom, String dirPath, String companyID, String lang, int tenantID, String offSet, LoginVO userInfo) throws Exception;
	
	public String makeTaskListXml(Document docXML, String companyID, String strType, int tenantID, String approvalFlag, String userFlag) throws Exception;
	
	public String doSusinHesong(String docID, String receiveSN, String deptID, String docState, String userID, String userName, String userName2, String dirPath, String companyID, String lang, int tenantID, String offSet) throws Exception;
	
	public String getAprType_AprState(String docID, String userID, String companyID, int tenantID) throws Exception;
	
	public String doCallBack(String docID, String userID, String companyID, int tenantID) throws Exception;
	
	public String getFormConnFlag(String docID, String companyID, int tenantID) throws Exception;
	
	public String getInnerLineInfo(String docID, String deptID, String docState, String companyID, int tenantID) throws Exception;
	
	public String getSearchDocList(String containerID, String userID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String draftFromYEAR, String draftFromMONTH,
			String draftFromDAY, String draftToYEAR, String draftToMONTH, String draftToDAY, String apprFromYEAR, String apprFromMONTH, String apprFromDAY, String apprToYEAR, String apprToMONTH,
			String apprToDAY, String myApprFromYEAR, String myApprFromMONTH, String myApprFromDAY, String myApprToYEAR, String myApprToMONTH, String myApprToDAY, String draftDeptName,
			String docState, String aprFlag, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, String approvUser, int tenantID, String offset, String approvalFlag, Locale locale) throws Exception;
	
	public String updateSignCheck(String docID, String signCheck, String companyID, int tenantID) throws Exception;
	
	public String aprAttachMail(String docID, String flag, String companyID, int tenantID) throws Exception;
	
	public String makeTaskFullListXml(Document docXML, String companyID, String pageSize, String pageNO, String langType, int tenantID) throws Exception;
	
	public String getContDocList(String containerID, String userID, String subQuery, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String getGamSaSearchDocList(String containerID, String userID, String deptID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String draftFromYEAR,
			String draftFromMONTH, String draftFromDAY, String draftToYEAR, String draftToMONTH, String draftToDAY, String apprFromYEAR, String apprFromMONTH, String apprFromDAY, String apprToYEAR,
			String apprToMONTH, String apprToDAY, String myApprFromYEAR, String myApprFromMONTH, String myApprFromDAY, String myApprToYEAR, String myApprToMONTH, String myApprToDAY,
			String draftDeptName, String docState, String aprFlag, String pageSize, String pageNum, String orderCell, String orderOption, LoginVO userInfo) throws Exception;
	
	public String getUncompleteDocCount(String deptID, String companyID, String cabinetID, int tenantID) throws Exception;
	
	public String transferCabinet(Document xmlDom, int tenantID) throws Exception;
	
	public String gongRamUpdate(String docID, String userID, String companyID, String lang, int tenantID) throws Exception;
	
	public String delayCabEndY(String deptCode, String flag, String cabClassList, String companyID, int tenantID) throws Exception;
	
	public String getUncabinetedDocCount(String deptID, String confirmYN, String companyID, int tenantID) throws Exception;
	
	public String chkIfNotArrangedCabExist(String deptID, String companyID, int tenantID) throws Exception;
	
	public String confirmClassify(String deptID, String companyID, int tenantID) throws Exception;
	
	public String getSendOutDocList(String userID, String deptID, String susinManagerFlag, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, int tenantID, String offset) throws Exception;
	
	public String endCabProduce(String cabClassNo, String flag, String companyID, int tenantID) throws Exception;
	
	public String mobileSrvConn(String userID, String result, String formID, String keyVal, String docID, String orgUID, String strLang, String companyID, String passWord, HttpServletRequest request, LoginVO userInfo) throws Exception;
	
	public String reqDelayCabEndY(String cabClassList, String flag, String companyID, int tenantID) throws Exception;
	
	public String doSendOfferApprove(String docID, String orgDocID, String userID, String userName, String userName2, String deptID, String dirPath, String proxyUserID, String companyID, String lang, LoginVO userInfo) throws Exception;
	
	public String getFindSimpleCabinetListAll(String processDeptCode, String productionYear, String searchKeyword, String flag, String companyID, String langType, int tenantID) throws Exception;
	
	public String doSendOfferReject(String docID, String userID, String companyID, int tenantID) throws Exception;
	
	public String getApprovalPWD2(String dUserID, int tenantID, String companyID) throws Exception;
	
	public String getUserRecRight(String recID, String sepAttNo, String userID, String companyID, int tenantID) throws Exception;
	
	public String setCabinetReject(String docID, String deptID, String deptName, String deptName2, String dirPath, String flag, String companyID, String lang, int tenantID, String offSet, Locale locale) throws Exception;
	
	public String gongRamSave(Document xmlDom, String dirPath, String companyID, String lang, int tenantID, String offSet) throws Exception;
	
	public String gongRamSaveEnd(Document xmlDom, String dirPath, String companyID, String lang, int tenantID, String offSet) throws Exception;
	
	public String makeTmp2IngDocInfo(String userID, String sn, String companyID, String lang, int tenantID) throws Exception;
	
	public String checkAprLine(String docID, String mode, String userID, String companyID, int tenantID) throws Exception;
	
	public String getSusinSN(String docID, String companyID, int tenantID) throws Exception;
	
	public List<ApprGSecondApprVO> getSecondApprovalInfo(String companyID, int tenantID) throws Exception; 
	
	public Document checkPermission(String docID, String userID, String deptID, String checkMode, String companyID, int tenantID) throws Exception;

	public String sendOfferCheck(String docID, String userID, String string, String companyID, String lang, int tenantID) throws Exception;

	public String GetRecordInfo(Document xmlDom, String lang, int tenantID, String offSet)throws Exception;

	public String getRecViewer(Document xmlDom,String lang, int tenantID)throws Exception;

	public String saveRecUserRoleInfo(Document xmlDom, String lang, int tenantID, Locale locale)throws Exception;

	public String getRecReadHistory(Document xmlDom, String offset, int tenantID) throws Exception;

	public String getRecordClassInfo(Document xmlDom, int tenantID) throws Exception;
	
	public String getAprDocList (String pListType, String userID, String userDeptID, String pageSize, String pageNum, String sortHeader, String sortOption, String companyID, String pSubQuery, String strLang, int tenantID, String offset) throws Exception;

	public String getRecordHistory(Document xmlDom, LoginVO userInfo) throws Exception;

	public String moveRecord(Document xmlDom, String lang, int tenantID) throws Exception;

	public String getRecordSimpleInfo(Document xmlDom, String lang, int tenantID) throws Exception;

	public String changeRecordInfo(Document xmlDom, String lang, int tenantID) throws Exception;

	public String getDeliveryList(String p_DeptID, String pPageSize, String pPageNum, String pOrderCell, String pOrderOption, String pQuery, String companyID, String lang, String deptcode, String deptcode2, String title, String sregdate, String eregdate,	String debenturer, String isdocprint, int tenantID, String offset) throws Exception;

	public String getNewID(String companyID, int tenantID) throws Exception;

	public String registerRecord(Document xmlDom, int tenantID, String offset, Locale locale)throws Exception;

	public String getCabinetList(Document xmlDom, LoginVO userInfo)throws Exception;

	public String getCabinetDetailInfo(Document xmlDom, int tenantID) throws Exception;

	public String getCabScInfo(Document xmlDom, int tenantID) throws Exception;

	public String getCabinetPrintInfo(Document xmlDom, String lang, int tenantID) throws Exception;

	public String getCabinetSimpleInfo(Document xmlDom, int tenantID) throws Exception;

	public String changeCabinetInfo(Document xmlDom, int tenantID, String companyID) throws Exception;

	public String getCabinetHistory(Document xmlDom, LoginVO userInfo) throws Exception;

	public String getTaskCharger(Document xmlDom, String lang, int tenantID) throws Exception;

	public String saveCabRoleInfo(Document xmlDom, int tenantID, String companyID) throws Exception;

	public String updateReceiptOffer(String docID, String orgDocID, String companyID, int tenantID)throws Exception;

	public String doSendOffer(Document xmlDom, String dirPath, String companyID, String lang, int tenantID)throws Exception;

	public String addBebu(Document xmlDom, String dirpath, String companyID, String lang, int tenantID, String offSet)throws Exception;

	public String updateProcessYN2(String docID, String deptID,	String deptName, String deptName2, String processYN, String mode, String companyID, String lang, int tenantID) throws Exception;

	public String updateProcessYN(String docID, String deptID, String processYN, String string, String companyID, String lang, int tenantID) throws Exception;

	public String doReSendDoc(Document xmlDom, String dirPath, String lang, int tenantID) throws Exception;

	public String getRecSCInfo(Document xmlDom, String lang, LoginVO userInfo)throws Exception;
	
	public String makeContainer(String deptID, String containerType, String companyID, int tenantID) throws Exception;
	
	public int getWebPartListCount(String listType, String userID, String deptID, String userIDS, String deptIDS, String userFlag, String companyID, String lang, int tenantID, String offset) throws Exception;

	public String doCancelForce(String docID, String userID, String companyID, int tenantId) throws Exception;

	public String updateHistoryForDoc(String docID, String url, String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String userDeptID, String userDeptName, String userDeptName2, LoginVO userInfo)  throws Exception;

	public String mobileSrvConn_HWP(String userID, String string, String formID, String string2, String textContent, String orgUID, String langType, String companyID, String pw, HttpServletRequest request, LoginVO userInfo) throws Exception;

	public String getKeepType(String lang, int tenantId, String companyID) throws Exception;

	public List<ApprGTaskVO> getCodeContainer(int tenantId, String companyID, String deptID, String lang) throws Exception;

	public String getUserContTree(String id, String ParentContID, String deptName, String companyID, String lang, int tenantId, Locale locale) throws Exception;

	public String insUserCont(String ownUserID, String parentContID, String ownUserName, String description, String companyID, String lang, int tenantID) throws Exception;

	public String updateUserCont(String contID, String ownUserID, String parentContID, String userContName, String description, String companyID, String lang, int tenantID)  throws Exception;

	public String delUserCont(String pContID, String pMode, String companyID, String lang, int tenantId)  throws Exception;

	public String getCodeTreeInfo(String code, String level, LoginVO userInfo) throws Exception;

	public String getCodeSubTreeInfo(String code, String level, LoginVO userInfo) throws Exception;

	public String getContUseDeptInfo(String pDeptID, String companyID,	String lang, int tenantId) throws Exception;

	public String registerUserContDoc(String docID, String contID, String description, String companyID, String lang, int tenantId) throws Exception;

	public String docAttachLineInfo(String docID, String id, String companyID, int tenantId) throws Exception;

	public String getFrequencyClassList(LoginVO userInfo) throws Exception;
	
	public String getContainerInfoManage(String deptID, String mode, String companyID, String lang, int tenantId) throws Exception;

	public String getContDocListS(String contID, String id, String string, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, int tenantId, String offset, Locale locale) throws Exception;

	public String findTaskS(String deptCode, String title, String code, String companyID, int tenantId, String approvalFlag) throws Exception;

	public String getUserContList(String pContID, String pSubQuery,	String pPageSize, String pPageNum, String oc, String oo, String companyID, String lang, Document tempDueryDATA, int tenantID, String offSet) throws Exception;

	public String getUserContListAll(String pContID, String pSubQuery,	String pPageSize, String pPageNum, String oc, String oo, String companyID, String lang, Document tempDueryDATA, int tenantID, String offSet) throws Exception;
	
	public String deleteUserContDoc(String docID, String contID, String companyID, String lang, int tenantId) throws Exception;

	public String getSearchDocListS(String containerID, String userID, 	String subQuery, String docNumber, String docTitle, String drafter,	String formID, String draftfrom, String draftto, String apprfrom, String papprto, String mypapprfrom, String mypapprto,
			String draftDeptName, String docState, String string, String pageSize, String pageNum, String orderCell,	String orderOption, String companyID, String lang, String string2,	int tenantID, String offSet, String approvalFlag, Locale locale) throws Exception;

	public List<ApprGContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception;

	public String getAutoDocNumItem(String formID, String lang, String companyID, int tenantID) throws Exception;

	public String doSendOfferS(Document docXML, String companyID, String lang, int tenantID) throws Exception;
	
	public String checkResend(String docID, String companyID, int tenantId) throws Exception;

	public String doHabyuiHesong(Document doc, String dirPath, String companyID, String lang, int tenantId, LoginVO userInfo) throws Exception;

	public List<String> getAddress(String userIDs, int tenantID) throws Exception;
	
	public String deleteSignInfo(String docID ,String companyID, int tenantID) throws Exception;

	public String getSameOrgHAPYUIDoc(String docID, String companyID, String lang, int tenantID) throws Exception;

	public String getDocHref(String docID, String docStatus, String type, String companyID, int tenantId) throws Exception;

	public String getDocInfoS(String docID, String mode, String selected, LoginVO userInfo, String companyID, int tenantID) throws Exception;

	public String gongRamSaveIng(Document xmlDom, String dirPath, String companyID, String lang, int tenantId, String offset) throws Exception;

	public void delCirculation(String docID, String companyID, int tenantID) throws Exception;

	public String getCirculationinfo(String docID, String mode, String companyID, String lang, int tenantID, String offset) throws Exception;

	public String setCabinetHesong(String docID, String deptID,	String deptName, String deptName2, String userName,	String userName2, String dirpath, String docSN, String companyID, String lang, int tenantId, String offset, Locale locale) throws Exception;

	public String startXmlConvert(String content, String fontFamily, String fontSize, LoginVO userInfo) throws Exception;

	public String getAprLineXmlForExt(String docID, LoginVO userInfo) throws Exception;

	public String checkPubDocXML(String mapPath) throws Exception;

	public String createSendMsgXML(Document xmlDom, String mapPath, LoginVO userInfo) throws Exception;

	public String getFileName(String realPath, String strFileName, String strFolderName, String strXML, int tenantID) throws Exception;

	public boolean insertRelayDB(String strDocID, String strXDocID, String strRecDate, String strFrom, String strTo, String strSubject, String strXMailType, String strXFromCode, String strXToCode,
			String strXGW, String strXDocType, String strXDTDVersion, String strXXSLVersion, String strContentType, String strSealURL, String strXmlURL, String strLastDate, String strCompanyID, int tenantID) throws Exception;

	public void fieldUpdate(String strFieldName, String strValue, String strXDocID, String strDeptID, String strCompanyID, int tenantID) throws Exception;

	public void addAttachInfo(String strCont_Name, String strRealFileName, String strDocID, String strSN, String strType, String strCompanyID,	int tenantID) throws Exception;

	public void addSignInfo(String strFileName, String strRealFileName, String strDocID, String strCompanyID, int tenantID) throws Exception;

	public boolean createRelayDocInfo(String realPath, String strXDocID, String strReceiveID, String strCompanyID, int tenantID) throws Exception;

	public boolean sendAck(String realPath, String strXDocID, String strReceiveID, String strSendID, String strTitle, String strDocType, String strDocTypeDept, String strDocTypeName, String strErrMsg, String strCompanyID, int tenantID) throws Exception;

	public boolean updateSusinState(String strDocID, String strPrecDate, String strMode, String strDeptID, String strAcceptName, String strCompanyID, int tenantID) throws Exception;

	public boolean insFailMessage(String strXDocID, String strSendID, String strSendName, String message, String strCompanyID, int tenantID) throws Exception;

	public String getRelayInfo(String docID, LoginVO userInfo) throws Exception;

	public String setHref(String docID, String fileType, String mode, LoginVO userInfo) throws Exception;

	public String setRecvDocInfo(String docID, String publicFlag, String docNo, String docNumCode, String orgDocNumCode, String mode, String fileType, LoginVO userInfo) throws Exception;

	public String updateRecvDocInfo(String docID, String docNo, String docNumCode, String orgDocNumCode, String cabinetID, String taskCode, String userID, String userName, String userName2, String deptID, String userTitle, String userTitle2, String deptName, String deptName2, String tempCompanyID, LoginVO userInfo, String realPath) throws Exception;

	public String sendAck(String realPath, String docID, String type, String userName, String userDeptName, String errMsg, String companyID, int tenantID) throws Exception;

	public List<OrganUserVO> getTenantID() throws Exception;
}