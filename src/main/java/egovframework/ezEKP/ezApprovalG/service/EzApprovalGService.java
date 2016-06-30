package egovframework.ezEKP.ezApprovalG.service;

import java.util.List;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzApprovalGService {

	public List<ApprGLeftVO> getUseContInfo(LoginVO userInfo, String ownFlag) throws Exception;

	public String getOptionInfo(String code1, String code2, LoginVO userInfo, String mode) throws Exception;

	public String aprDocList(String listType, String userID, String deptID, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String userLang, String searchQuery, Document dueryData) throws Exception;

	public String getProxyUser(String id, String lang) throws Exception;

	public String getAprLineInfoDB(String docID, String flag, String userID, String formID, String companyID) throws Exception;
	
	public String getListHeader(String listCode, String companyID, String lang) throws Exception;
	
	public String getCode2Name(String code1, String code2, String companyID, String lang) throws Exception;
	
	public String getListField(String fieldName, String fieldValue, String companyID, String userLang) throws Exception;

	public String getAccessYNG(String docID, String userID, String mode, String companyID, String lang) throws Exception;

	public String getLineInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang) throws Exception;
	
	public String getAttachInfo(String docID, String flag, String sortHeader, String sortOption, String companyID, String lang) throws Exception;
	
	public String getReceiptInfo(String docID, String flag, String sortHeader, String sortOption, String companyID, String lang) throws Exception;
	
	public String getOpinionInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang) throws Exception;

	public String getWebPartList(String listType, String userID, String deptID, String listCount, String mode, String userFlag, String companyID, String lang) throws Exception;

	public String getDocType(String selected, String companyID, String lang) throws Exception;
	
	public String getFormInfo(String formContID, String kind, String searchType, String searchName, String userID, String companyID, String lang) throws Exception;

	public String getFormContainerInfo(String id, String deptID, String companyID) throws Exception;
	
	public String setUserFormInfo(String formID, String userID, String companyID) throws Exception;
	
	public String delUserFormInfo(String formID, String userID, String companyID) throws Exception;
	
	public String getApprovalPWD(String userID) throws Exception;
	
	public String getSecurityType(String selected, String companyID, String lang) throws Exception;
	
	public String getAprType(String companyID, String lang) throws Exception;
	
	public String getAprLineInfo(String docID, String userID, String formID, String companyID, String lang) throws Exception;
	
	public String getTempList(String userID, String formID, String companyID, String lang) throws Exception;
	
	public String updateLineInfo(String ret, String companyID, String lang) throws Exception;
	
	public String updateReceiptInfo(String ret2, String companyID, String lang) throws Exception;
	
	public String getLineTempletInfo(String formID, String userID, String companyID) throws Exception;
	
	public String getLineTempletDetailInfo(String formID, String userID, String aprSN, String companyID, String lang) throws Exception;
	
	public String getFormInfoDetail(String formID, String companyID) throws Exception;
	
	public String getFormRecvApr(String docID, String formID, String userID, String companyID, String lang) throws Exception;
	
	public String createNewDoc(String formID, String companyID) throws Exception;
	
	public String deleteDocInfo(String docID, String mode, String companyID) throws Exception;
	
	public String updateLineTempletDetailInfo(Document xmlDom, String companyID, String lang) throws Exception;
	
	public String deleteLineTempletDetailInfo(String formID, String userID, String aprLineSN, String companyID) throws Exception;
	
	public String addToAprLine(String userID, String formID, String aprSN, String companyID, String lang) throws Exception;
	
	public String getReceiptTempletInfo(String formID, String userID, String companyID) throws Exception;
	
	public String getReceiptTempletDetailInfo(String formID, String userID, String aprSN, String companyID, String lang) throws Exception;
	
	public String getTempList(String companyID, String lang) throws Exception;
	
	public String getTempList2(String groupID, String companyID, String lang) throws Exception;
	
	public String getTempList3(String userID, String formID, String companyID, String lang) throws Exception;
	
	public String getListXML(String groupID, String lang, String companyID) throws Exception;
	
	public String addToAprDept(String userID, String formID, String aprDeptSN, String companyID, String lang) throws Exception;
	
	public String deleteReceiptTempletDetailInfo(String formID, String userID, String aprDeptSN, String companyID) throws Exception;
	
	public String updateReceiptTempletDetailInfo(Document doc, String companyID) throws Exception;
	
	public String getTaskCategory(String deptCode, String companyID, String type) throws Exception;
	
	public String getTaskMiddleCategory(String deptCode, String companyID, String cateCode) throws Exception;
	
	public String getTaskSubCategory(String deptCode, String companyID, String cateCode, String strType) throws Exception;
	
	public String getTaskInSubCategory(String deptCode, String companyID, String cateCode, String strType) throws Exception;
	
	public String getSimpleCabinetList(String companyID, String processDeptCode, String productionYear, String taskCode, String flag, String langType) throws Exception;
	
	public String findTask(String deptCode, String title, String code, String flag, String companyID, String langType) throws Exception;
	
	public String deleteOpinionInfo(String docID, String companyID, String lang) throws Exception;
	
	public String updateOpinionInfo(Document docXML, String companyID, String lang) throws Exception;
	
	public String getDocHrefYear(String docID, String companyID) throws Exception;
	
	public String getDocDir(String docID) throws Exception;
	
	public String getAttachFileInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang) throws Exception;
	
	public String updateHistoryForAttach(String docID, String attachSN, String tempUserID, String tempUserName, String tempUserName2, String tempUserJobTitle, String tempUserJobTitle2,
			String tempUserDeptID, String tempUserDeptName, String tempUserDeptName2, String modifyFlag, String dirPath, String companyID) throws Exception;
	
	public String updateAttachFileInfo(Document xmlDom, String companyID, String lang) throws Exception;
	
	public String deleteAttachFileInfo(String docID, String companyID, String lang) throws Exception;
	
	public String getListInfoXml(String listFlag, String listType, String companyID, String lang) throws Exception;
	
	public String getRecordList(Document doc, String lang) throws Exception;
	
	public String getCodeInfo(String companyID, String lang) throws Exception;
	
	public String getAttachDocInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang) throws Exception;
	
	public String isCabCharger(String companyID, String cabClassNo, String userID) throws Exception;
	
	public String updateAttachDocInfo(Document doc, String companyID, String lang) throws Exception;
	
	public String deleteAttachDocInfo(String docID, String companyID, String lang) throws Exception;
	
	public String getDocInfo(String docID, String mode, String selected, String companyID) throws Exception;
	
	public String saveRecReadHist(String readRecXML) throws Exception;
	
	public String receiverChk(String deptID, String companyID) throws Exception;
	
	public String getEA5Value(String msg) throws Exception;
	
	public String getMyTaskCode(String userID, String deptID, String companyID, String lang) throws Exception;
	
	public String setMyTaskCode(String userID, String deptID, String cabinetID, String taskCode, String type, String companyID) throws Exception;
	
	public String getCabinetInfo(String cabinetID, String companyID, String strType) throws Exception;
	
	public String registerSepAttach(Document doc) throws Exception;
	
	public String getHistoryForDoc(String docID, String sortHeader, String sortOption, String companyID, String lang) throws Exception;
	
	public String getHistoryForLine(String docID, String sortHeader, String sortOption, String companyID, String lang) throws Exception;
	
	public String getHistoryForAttach(String docID, String sortHeader, String sortOption, String companyID, String lang) throws Exception;
	
	public String getHistoryForLineDetail(String docID, String modifySN, String sortHeader, String sortOption, String companyID, String lang) throws Exception;
	
	public String deleteTmpDocInfo(String userID, String sn, String path, String companyID, String lang) throws Exception;
	
	public String doProcess(String aprState, String docID, String userID, String userName, String userName2, String dirPath, String deptID, String html,
			Document strXML, String proxyUserID, String companyID, String lang) throws Exception;
	
	public String getTotalAttachSize(String docID, String companyID) throws Exception;
	
	public String chkAprLines(Document doc, String lang) throws Exception;
	
	public String chkDeptLines(Document doc, String companyID, String lang) throws Exception;

	public String getOpinionCount(String docID, String userID, String ingFlag, String companyID, String lang) throws Exception;
	
	public String updateHistoryForLine(String docID, String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String userDeptID, String userDeptName,
			String userDeptName2, String chkFlag, String companyID) throws Exception;
	
	public int checkPermission(String docID, String userID, String deptID, String checkMode, String companyID) throws Exception;



}
