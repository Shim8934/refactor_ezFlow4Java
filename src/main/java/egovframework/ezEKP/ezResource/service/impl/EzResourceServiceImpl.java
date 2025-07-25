package egovframework.ezEKP.ezResource.service.impl;


import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CookieValue;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezResource.dao.EzResourceDAO;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResDateVO;
import egovframework.ezEKP.ezResource.vo.ResFavoriteCategoryVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetClsAclListVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSendMailToUserVO;
import egovframework.ezEKP.ezResource.vo.ResMakeDupResultVO;
import egovframework.ezEKP.ezResource.vo.ResOccuVO;
import egovframework.ezEKP.ezResource.vo.ResScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzResourceService")
public class EzResourceServiceImpl extends EgovAbstractServiceImpl implements EzResourceService{
	
	private static final Logger logger = LoggerFactory.getLogger(EzResourceServiceImpl.class);
	
	@Resource(name="EzResourceDAO")
	private EzResourceDAO ezResourceDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Value("#{globals['Globals.DbType']}")
	private String dbType;

	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID,String companyID, String treeType, int tenantID, String adminType) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("tenantID", tenantID);
		if(adminType.equals("Y")) {
			map.put("adminType", adminType);
		}
		return ezResourceDAO.getAdmSubClsTree(map);
	}

	public List<ResGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("v_P_USERID", pUserID);
		map.put("v_PCOMID", comID);
		map.put("v_PDEPTID", deptID);
		map.put("v_PUSERID", userID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getSubClsTree(map);
	}
	
	public ResGetAdminFlagVO getAdmFlag(String companyID, String resID,String memberID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("resID", resID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getAdmFlag(map);
	}

	@Override
	public List<ResGetItemListVO> getBrdMainList(String brdID,String companyID, String lang, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_BRD_ID", brdID);
		map.put("v_COMPANY", companyID);
		map.put("v_LANG", lang);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrdMainList(map);
	}
	
	public List<ResDateVO> getScheduleDateList(String ownerID, String num, String companyID, String startDate, String endDate, String offset, int tenantID) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_P_NUM", num);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getScheduleDateList(map);
	}
	
	public List<ResGetScheduleVO> getScheduleList(String ownerID, String companyID, String startDate, String endDate, String title, String writerName, String writerDept, String offset, int tenantID, String lang) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate.replace(".", "-"));
		map.put("v_PENDDATE", endDate.replace(".", "-"));
		map.put("v_WRITERNAME", writerName);
		map.put("v_WRITERDEPT", writerDept);
		if(!title.equals("")) {
			map.put("v_TITLE", title);
		}
		map.put("tenantID", tenantID);
		map.put("v_lang", lang);
		return ezResourceDAO.getScheduleList(map);
	}

	public List<ResGetScheduleVO> getScheduleListMain(String ownerID, String companyID, String startDate, String endDate, String offset, int tenantID, String lang) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pStartDate", startDate);
		map.put("v_pEndDate", endDate);
		map.put("tenantID", tenantID);
		map.put("v_lang", lang);
		
		return ezResourceDAO.getScheduleListMain(map);
	}

	public List<ResGetScheduleVO> getScheduleListRepetiti(String ownerID, String companyID, String startDate, String endDate, String title, String writerName, String writerDept, String offset, int tenantID, String lang) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERNAME", writerName);
		map.put("v_WRITERDEPT", writerDept);
		if(!title.equals("")) {
			map.put("v_TITLE", title);
		}
		map.put("tenantID", tenantID);
		map.put("v_lang", lang);
		
		return ezResourceDAO.getScheduleListRepetiti(map);
	}

	public List<ResGetScheduleVO> getScheduleListRepetitim( String ownerID, String companyID, String startDate, int tenantID, String offset, String lang) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("tenantID", tenantID);
		map.put("v_lang", lang);
		
		return ezResourceDAO.getScheduleListRepetitim(map);
	}

	public List<String> getDeletedRepScheduleDate(int pNum, String companyID, String ownerID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_pNum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_ownerID", ownerID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getDeletedRepScheduleDate(map);
	}
	
	@Override
	public ResGetScheduleRepetitionVO getRepDateTimes(String ownerID, String companyID, int num, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pNum", num);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getRepDateTimes(map);
	}

	/* 2024-07-05 홍승비 - SQL Injection 수정 > 다국어 칼럼은 쿼리 내부 분기로 처리 */
	@Override
	public List<ResBrdListVO> getBrdList(int topCnt, int brdID, String CompanyID, String lang, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PTOPCNT", topCnt);
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", CompanyID);
		map.put("v_lang", lang);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrdList(map);
	}

	@Override
	public int getBrdCnt(int brdID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrdCnt(map);
	}

	@Override
	public ResBrdVO getBrd(int brdID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pBrdID", brdID);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrd(map);
	}
	
	public void delResData(String brdID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_CompanyID", companyID);
		map.put("tenantID", tenantID);
		
		ezResourceDAO.delResData(map);
		ezResourceDAO.delResData_U(map);
		ezResourceDAO.delResData1(map);
		ezResourceDAO.delResData3(map);
		ezResourceDAO.delResDataForm(map);
		
		/* 2024-08-09 유길상 - 자원 삭제 시 즐겨찾기 정보도 삭제 */
		List<String> delBrdCatList = ezResourceDAO.delBrdCatList(map);
		ezResourceDAO.delResData_F(map);
		
		for (String catId : delBrdCatList) {
			Map<String,Object> map1 = new HashMap<String, Object>();
			map1.put("CAT_ID", catId);
			map1.put("COMPANY_ID", companyID);
			map1.put("TENANT_ID", tenantID);
			int cnt = ezResourceDAO.selectBrdCnt(map1);
			if (cnt == 0) {
				map1.put("brdYn","N");
				ezResourceDAO.updateFavoriteCategoryBrdYN2(map1);
			}
		}
	}
	
	public void modifyResData(String brdID, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String resLocation,
	String brdExplain,String companyID, String approve, String brdNm2, String deptNm2, String ownerNm2, String ownerPos2, int tenantID, String realPath, String strAttachList1, String strAttachList2, String strReturn, String repeat, String strResMaxDate, String strResMaxUserCnt) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_ResLocation", resLocation);
		map.put("v_P_Brd_Explain", brdExplain);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Approve", approve);
		map.put("v_P_Return", strReturn);
		map.put("v_P_Repeat", repeat);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("v_P_ODeptNm2", deptNm2);
		map.put("v_P_OwnerNm2", ownerNm2);
		map.put("v_P_OwnerPos2", ownerPos2);
		map.put("tenantID", tenantID);
		
		// 2024-09-02 유길상 - 최대 예약 가능 기간, 정원
		map.put("v_P_ResMaxDate", strResMaxDate);
		map.put("v_P_ResMaxUserCnt", strResMaxUserCnt);
		
		ezResourceDAO.modifyResData(map);
		
		// 첨부파일 등록 실행
		//deleteAttachFiles(brdID, realPath, companyID, tenantID);
		Map<String, Object> attachMap = new HashMap<String, Object>();
		attachMap.put("companyID", companyID);
		attachMap.put("tenantID", tenantID);
		attachMap.put("resID", brdID);
		
		String pDirPath = realPath + commonUtil.getUploadPath("upload_resource.ROOT", tenantID);
		
		File file = new File(pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + brdID + "_uploadFile");
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		ezResourceDAO.delAttachFile(attachMap);
		
		// 기존 존재하는 파일인 경우
		if(strAttachList1.indexOf("/") != -1) {
			String beforeFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + strAttachList1;
			
			strAttachList1 = strAttachList1.substring(strAttachList1.lastIndexOf("/")+1);
			
			String afterFilePath = pDirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + strAttachList1;
			
			File beforeFile = new File(beforeFilePath);
			File afterFile = new File(afterFilePath);
			
			FileUtils.moveFile(beforeFile, afterFile);
		}
		
		if(strAttachList2.indexOf("/") != -1) {
			String beforeFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + strAttachList2;
			
			strAttachList2 = strAttachList2.substring(strAttachList2.lastIndexOf("/")+1);
			
			String afterFilePath = pDirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + strAttachList2;
			
			File beforeFile = new File(beforeFilePath);
			File afterFile = new File(afterFilePath);
			
			FileUtils.moveFile(beforeFile, afterFile);
		}
		
		if(file.exists()) {
			File[] files = file.listFiles();
			
			for(File f: files){
				f.delete();
			}
		}
		
		if(!strAttachList1.equals("") && strAttachList1 != null) {
			String uploadFilePath = "";
			long fileSize = 0;

			uploadFilePath = commonUtil.separator + brdID + "_uploadFile" + commonUtil.separator + strAttachList1;
			String beforeFilePath = pDirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + strAttachList1;
			String afterFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + brdID + "_uploadFile" + commonUtil.separator + strAttachList1;

			File beforeFile = new File(beforeFilePath);
			fileSize = beforeFile.length();
			
			File afterFile = new File(afterFilePath);
			
			if (!afterFile.exists()) {
				FileUtils.moveFile(beforeFile, afterFile);
			}
			
			attachMap.put("fileName", strAttachList1);
			attachMap.put("fileSize", fileSize);
			attachMap.put("filePath", uploadFilePath);
			
			logger.debug("file1 upload End");
			ezResourceDAO.addAttachFile(attachMap);		// 첨부파일 추가
		}
		
		if(!strAttachList2.equals("") && strAttachList2 != null) {
			String uploadFilePath = "";
			long fileSize = 0;
			
			uploadFilePath = commonUtil.separator + brdID + "_uploadFile" + commonUtil.separator + strAttachList2;
			String beforeFilePath = pDirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + strAttachList2;
			String afterFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + brdID + "_uploadFile" + commonUtil.separator + strAttachList2;

			File beforeFile = new File(beforeFilePath);
			fileSize = beforeFile.length();
			
			File afterFile = new File(afterFilePath);
			
			if (!afterFile.exists()) {
				FileUtils.moveFile(beforeFile, afterFile);
			}
			
			attachMap.put("fileName", strAttachList2);
			attachMap.put("fileSize", fileSize);
			attachMap.put("filePath", uploadFilePath);
			
			logger.debug("file2 upload End");
			ezResourceDAO.addAttachFile(attachMap);
		}
	}
	
	public void addResData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String resLocation,
	String brdExplain, String companyID, String approve, String brdNm2, String deptNm2, String ownerNm2, String ownerPos2,String strBreAccess, int tenantID, String realPath, String strAttachList1, String strAttachList2, String strReturn, String repeat, String strResMaxDate, String strResMaxUserCnt) throws Exception {
		logger.debug("addResData Start");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantID", tenantID);
		
		int brdID = ezResourceDAO.addResData_S1(map);
		
		map.put("v_P_ClassGB", classGB);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_ResLocation", resLocation);
		map.put("v_P_Brd_Explain", brdExplain);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Approve", approve);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("v_P_ODeptNm2", deptNm2);
		map.put("v_P_OwnerNm2", ownerNm2);
		map.put("v_P_OwnerPos2", ownerPos2);
		map.put("v_Brd_GB", "2");
		map.put("v_Brd_ID", brdID);
		map.put("v_Brd_Access", strBreAccess);
		map.put("v_P_Return", strReturn);
		map.put("v_P_Repeat", repeat);
		
		// 2024-09-02 유길상 - 최대 예약 가능 기간, 정원
		map.put("v_P_ResMaxDate", strResMaxDate);
		map.put("v_P_ResMaxUserCnt", strResMaxUserCnt);
		
		Map<String,Object> map2 = new HashMap<String, Object>();
		logger.debug("classGB="+classGB);
		logger.debug("companyID="+companyID);
		logger.debug("tenantID="+tenantID);
		map2.put("v_P_ClassGB", classGB);
		map2.put("v_P_CompanyID", companyID);
		map2.put("tenantID", tenantID);
		
		int v_Brd_Level = 0;
		v_Brd_Level = ezResourceDAO.addResData_S2(map2);
		
		int v_Brd_Step = ezResourceDAO.addResData_S3(map2);
		map.put("v_Brd_Level", v_Brd_Level);
		map.put("v_Brd_Step", v_Brd_Step);
		ezResourceDAO.addResData(map);
		
		// 첨부파일 등록 실행
		Map<String, Object> attachMap = new HashMap<String, Object>();
		attachMap.put("companyID", companyID);
		attachMap.put("tenantID", tenantID);
		attachMap.put("resID", brdID);
		
		String pDirPath = realPath + commonUtil.getUploadPath("upload_resource.ROOT", tenantID);
		
		File file = new File(pDirPath + "uploadFile" + commonUtil.separator + brdID + "_uploadFile");
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		if(!strAttachList1.equals("") && strAttachList1 != null) {
			String uploadFilePath = commonUtil.separator + brdID + "_uploadFile" + commonUtil.separator + strAttachList1;
			String beforeFilePath = pDirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + strAttachList1;
			String afterFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + brdID + "_uploadFile" + commonUtil.separator + strAttachList1;

			File beforeFile = new File(beforeFilePath);
			long fileSize = beforeFile.length();
			
			File afterFile = new File(afterFilePath);
			
			if (!afterFile.exists()) {
				FileUtils.moveFile(beforeFile, afterFile);
			}
			
			attachMap.put("fileName", strAttachList1);
			attachMap.put("fileSize", fileSize);
			attachMap.put("filePath", uploadFilePath);
			
			logger.debug("file1 upload End");
			ezResourceDAO.addAttachFile(attachMap);		// 첨부파일 추가
		}
		
		if(!strAttachList2.equals("") && strAttachList2 != null) {
			String uploadFilePath = commonUtil.separator + brdID + "_uploadFile" + commonUtil.separator + strAttachList2;
			String beforeFilePath = pDirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + strAttachList2;
			String afterFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + brdID + "_uploadFile" + commonUtil.separator + strAttachList2;

			File beforeFile = new File(beforeFilePath);
			long fileSize = beforeFile.length();
			
			File afterFile = new File(afterFilePath);
			
			if (!afterFile.exists()) {
				FileUtils.moveFile(beforeFile, afterFile);
			}
			
			attachMap.put("fileName", strAttachList2);
			attachMap.put("fileSize", fileSize);
			attachMap.put("filePath", uploadFilePath);
			
			logger.debug("file2 upload End");
			ezResourceDAO.addAttachFile(attachMap);
		}
		
		logger.debug("addResData End");
	}
	
	public void updateScheduleDateTime(int num, String ownerID, String companyID, String startDate, String endDate, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", num);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pStartDate", startDate);
		map.put("v_pEndDate", endDate);
		map.put("tenantID", tenantID);
		ezResourceDAO.updateScheduleDateTime(map);
	}
	
	@Override
	public ResGetScheduleVO getSchedule(int pNum, String ownerID, String companyID, int tenantID, String lang) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", pNum);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		map.put("v_lang", lang);
		return ezResourceDAO.getSchedule(map);
	}
	
	public void insertScheduleRepetition(int num, String ownerID, String startDateTime, String endDateTime, String reWay, String reDay, String reNum, String reYoil, String reMonth,
			String reOrd, String endFlag, String reCount, String companyID, int tenantID, String offset) throws Exception {
		logger.debug("insertScheduleRepetition started");
		
		startDateTime = commonUtil.getDateStringInUTC(startDateTime, offset, true);
		endDateTime = commonUtil.getDateStringInUTC(endDateTime, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", num);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pStartDateTime", startDateTime);
		map.put("v_pEndDateTime", endDateTime);
		map.put("v_pReWay", reWay);
		map.put("v_pReDay", reDay);
		map.put("v_pReNum", reNum);
		map.put("v_pReYoil", reYoil);
		map.put("v_pReMonth", reMonth);
		map.put("v_pReOrd",  reOrd);
		map.put("v_pEndFlag", endFlag);
		map.put("v_pReCount", reCount);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		
		ezResourceDAO.insertScheduleRepetition(map);

		logger.debug("insertScheduleRepetition ended");
	}
	
	public List<ResGetScheduleVO> getScheduleInfo(int pNum, String entryID, String ownerID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", pNum);
		map.put("v_pEntryID", entryID);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getScheduleInfo(map);
	}
	
	public void updateScheduleRepetition(int pNum, String ownerID, String startDateTime, String endDateTime, String reWay, String reDay, String reNum, String reYoil, String reMonth,
			String reOrd, String endFlag, String reCount, String companyID, int tenantID, String offset) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", pNum);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pStartDateTime", commonUtil.getDateStringInUTC(startDateTime, offset, true));
		map.put("v_pEndDateTime", commonUtil.getDateStringInUTC(endDateTime, offset, true));
		map.put("v_pReWay", reWay);
		map.put("v_pReDay", reDay);
		map.put("v_pReNum", reNum);
		map.put("v_pReYoil", reYoil);
		map.put("v_pReMonth", reMonth);
		map.put("v_pReOrd", reOrd);
		map.put("v_pEndFlag", endFlag);
		map.put("v_pReCount", reCount);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		ezResourceDAO.updateScheduleRepetition(map);
	}
	
	@Override
	public void deleteRepetition(String ownerID, int num, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pNum", num);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		ezResourceDAO.deleteRepetition(map);
	}
	
	public List<ResGetScheduleRepetitionVO> getScheduleRepetition(int pNum, String ownerID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", pNum);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getScheduleRepetition(map);
	}
	
	@Override
	public ResSelectFormIDVO selectFormID(String resID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pRESID", resID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.selectFormID(map);
	}
	
	public String getAclTblBrd(String companyID, String brdID, String userID, String mode, int tenantID, String deptID) throws Exception {
		logger.debug("getAclTblBrd Start");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PBRDID", brdID);
		map.put("v_PUSERID", userID);
		map.put("v_PMODE", mode);
		map.put("tenantID", tenantID);
		logger.debug(companyID);
		logger.debug(brdID);
		logger.debug(userID);
		logger.debug(mode);
		String ownerID = "";
		String brdUpper = "";
		String accessLvl = "";
		String result = "";
		ownerID = ezResourceDAO.getAclTblBrd_S1(map);
		logger.debug("ownerID="+ownerID);
		
		boolean flag = false;
		String[] ownerList = ownerID.split(",");			// 자원 관리자 체크
		
		for (int i = 0; i < ownerList.length; i++) {
			if (userID.equals(ownerList[i])) {
				flag = true;
			}
		}
		
		if (!flag) {
			brdUpper = ezResourceDAO.getAclTblBrd_S2(map);
			map.put("v_BRD_UPPER", brdUpper);
			accessLvl = ezResourceDAO.getAclTblBrd_S3(map);
			logger.debug("brdUpper = " + brdUpper + " / accessLvl = " + accessLvl);
			
			if (accessLvl != null && accessLvl.trim().equals("1")) {		// 유저의 권한 체크
				logger.debug("user accessLvl = admin");
				return "Y";
			} else {
				if (accessLvl != null && accessLvl.trim().equals("2")) {
					logger.debug("user accessLvl = user");
					result = "U";
				} 

				if (mode.equals("everyone")) {							// 'everyone' 권한 체크	
					map.put("v_PUSERID", "everyone");
					accessLvl = ezResourceDAO.getAclTblBrd_S3(map);
					if (accessLvl != null && accessLvl.trim().equals("1")) {
						logger.debug("everyone accessLvl = admin");
						return "Y";
					} else {
						if (accessLvl != null && accessLvl.trim().equals("2")) {
							logger.debug("everyone accessLvl = user");
							result = "U";
						}

						String deptPath = ezOrganService.getDeptPath(deptID, tenantID);			// 부서 권한 체크
						List<String> deptIds = new ArrayList<String>();
						Collections.addAll(deptIds, deptPath.split(","));
						//deptIds.remove(0);				// companyID 삭제
						
						if (deptIds.size() > 0) {
							Collections.reverse(deptIds);
							map.put("v_PUSERID", deptIds.get(0));
							accessLvl = ezResourceDAO.getAclTblBrd_S3(map);
								
							if (accessLvl != null && accessLvl.trim().equals("1")) {
								logger.debug("user dept accessLvl = admin");
								return "Y";
							}
							else {
								if (accessLvl != null && accessLvl.trim().equals("2")) {
									logger.debug("user dept accessLvl = user");
									result = "U";
								}
								// 부서 상위 권한 체크
								deptIds.remove(0);				// 현재 부서ID 삭제
								if (deptIds.size() > 0) {
									/* 2024-07-05 홍승비 - SQL Injection 수정 > 문자열 대신 배열 리스트 파라미터 전달 */
									map.put("v_PUSERID", deptIds);
									
									List<ResGetClsAclListVO> deptAclList = ezResourceDAO.getDeptAcl(map);
		
									if (deptAclList != null) {
										for (int i = 0; i < deptAclList.size(); i++) {
											if (deptAclList.get(i).getAccessLvl().equals("1")) {
												logger.debug("user upper dept accessLvl = admin");
												return "Y";
											}
											else {
												logger.debug("user upper dept accessLvl = user");
												result = "U";
											}
										}
									}
								}
							}
						}
						
						// 사내 겸직 권한 체크
						List<OrganUserVO> userAddJobList = ezOrganAdminService.getUserAddJobList(userID, "1", tenantID);

						if (userAddJobList.size() > 0) {
							for (int i = 0; i < userAddJobList.size(); i++) {
								String addJobDeptPath = ezOrganService.getDeptPath(userAddJobList.get(i).getDepartment(), tenantID);
								List<String> addJobDeptIds = new ArrayList<String>();
								Collections.addAll(addJobDeptIds, addJobDeptPath.split(","));
								//addJobDeptIds.remove(0);				// companyID 삭제
								
								if (addJobDeptIds.size() > 0) {
									Collections.reverse(addJobDeptIds);
									map.put("v_PUSERID", addJobDeptIds.get(0));
									accessLvl = ezResourceDAO.getAclTblBrd_S3(map);
									
									if (accessLvl != null && accessLvl.trim().equals("1")) {
										logger.debug("user addjob dept accessLvl = admin");
										return "Y";
									}
									else {
										if (accessLvl != null && accessLvl.trim().equals("2")) {
											logger.debug("user addjob dept accessLvl = user");
											result = "U";
										} 
										// 부서 상위 권한 체크
										addJobDeptIds.remove(0);				// 현재 부서ID 삭제
										if (addJobDeptIds.size() > 0) {
											map.put("v_PUSERID", addJobDeptIds);
											
											List<ResGetClsAclListVO> deptAclList = ezResourceDAO.getDeptAcl(map);
											
											if (deptAclList != null) {
												for (int j = 0; j < deptAclList.size(); j++) {
													if (deptAclList.get(j).getAccessLvl().equals("1")) {
														logger.debug("user addjob upper dept accessLvl = admin");
														return "Y";
													}
													else {
														logger.debug("user addjob upper dept accessLvl = user");
														result = "U";
													}
												}
											}
										}
									}
								}
							}
						}
					}
				} else {
					logger.debug("This user does not have access.");
					result = "";
				}
			}
		} else {
			logger.debug("user brd accessLvl = admin");
			result = "Y";
		}
		logger.debug("result="+result);
		logger.debug("getAclTblBrd End");
		return result;
	}
	
	@Override
	public String getBrdApproveFlag(int brdID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrdApproveFlag(map);
	}

	@Override
	public String getBrdRepeatFlag(int brdID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrdRepeatFlag(map);
	}
	
	@Override
	public void insertForm(String resID, String brdNm, String formText, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_RESID", resID);
		map.put("v_BRDNM", brdNm);
		map.put("v_FORMTEXT", formText);
		map.put("tenantID", tenantID);
		
		int count = ezResourceDAO.insertForm_S(map);
		
		if (count == 0) {
			ezResourceDAO.insertForm_I(map);
		} else if (count > 0) {
			ezResourceDAO.insertForm_U(map);
		}
		
		//ezResourceDAO.insertForm(map);
	}
	
	@Override
	public void delFormID(String delCode, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_DELCODE", delCode);
		map.put("tenantID", tenantID);
		ezResourceDAO.delFormID(map);
	}
	
	@Override
	public void updateSchedule(int num, String ownerID, String companyID, String approve, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PNUM", num);
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PAPPROVE", approve);
		map.put("tenantID", tenantID);
		ezResourceDAO.updateSchedule(map);
	}
	
	@Override
	public void updateSchedule2(int num, String ownerID, String companyID, String returnFlag, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PNUM", num);
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PRETURN", returnFlag);
		map.put("tenantID", tenantID);
		ezResourceDAO.updateSchedule2(map);
	}
	
	public void modifyResSch(String ownerID, String num, String pNum, String companyID, String writerID, String title, String location, String timeDisplay, String startDate, String endDate,
			String allDay, String alertTime, String content, String importance, String reFlag, String gresFlag, String entryList, String characterID, String attachFlag, String typeVal,
			String approve, int tenantID, String offset) throws Exception {
		logger.debug("modifyResSch Start");
		
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ownerID", ownerID);
		map.put("v_P_num", num);
		map.put("v_P_pnum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_writerID", writerID);
		map.put("v_P_title", title);
		map.put("v_P_location", location);
		map.put("v_P_timeDisplay", timeDisplay);
		map.put("v_P_startDate", startDate);
		map.put("v_P_endDate", endDate);
		map.put("v_P_allDay", allDay);
		map.put("v_P_alertTime", alertTime);
		map.put("v_P_content", content);
		map.put("v_P_importance", importance);
		map.put("v_P_reFlag", reFlag);
		map.put("v_P_gresFlag", gresFlag);
		map.put("v_P_entryList", entryList);
		map.put("v_P_characterID", characterID);
		map.put("v_P_attachFlag", attachFlag);
		map.put("v_P_typeVal", typeVal);
		map.put("v_P_Approve", approve);
		map.put("maxNum", "");
		map.put("tenantID", tenantID);
		map.put("nowDate", nowDate);
		
		logger.debug("typeVal=" + typeVal);
		
		if (reFlag.equals("1") && typeVal.equals("MASTER")) {
			String ownerNm = ezResourceDAO.modifyResSch_S1(map);
			String deptNm = ezResourceDAO.modifyResSch_S2(map);
			
			ezResourceDAO.modifyResSch_D1(map);
			
			map.put("v_tmpOwnerNm", ownerNm);
			map.put("v_tmpDeptNm", deptNm);
			
			ezResourceDAO.modifyResSch_I1(map);
		} else if (typeVal.equals("INSTANCE")) {
			int result = ezResourceDAO.modifyResSch_U1(map);
			
			logger.debug("result=" + result);
			
			if (result == 0) {
				ezResourceDAO.modifyResSch_I2(map);
			}
		} else {
			//ezResourceDAO.modifyResSch_D2(map);
			ezResourceDAO.modifyResSch_U2(map);
		}
		logger.debug("modifyResSch End");
	}

	public void delResSch(String ownerID, String num, String pNum, String companyID, String writerID, String sDate, String eDate, int insType, String offset, int tenantID) throws Exception {
		logger.debug("delResSch Start");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ownerID", ownerID);
		map.put("v_P_num", num);
		map.put("v_P_pnum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_writerID",  writerID);
		map.put("v_P_insType", insType);
		map.put("tenantID", tenantID);
		
		String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		map.put("nowDate", nowDate);
		
		//ezResourceDAO.delResSch(map);
		logger.debug("insType="+insType);
		if (insType == 3) {
			if (ezResourceDAO.delResSch_S1(map) != null && ezResourceDAO.delResSch_S1(map).equals("1")) {
				ezResourceDAO.delResSch_U(map);
			} else {
				int maxNum = ezResourceDAO.delResSch_S2(map);
				logger.debug("maxNum="+maxNum);
				map.put("v_MaxNum", maxNum);
				
				String lang = "1";
				ResGetScheduleVO vo = getSchedule(Integer.parseInt(pNum), ownerID, companyID, tenantID, lang);
				sDate += " " + commonUtil.getDateStringInUTC(vo.getStartDate(), offset, false).substring(11);
				eDate += " " + commonUtil.getDateStringInUTC(vo.getEndDate(), offset, false).substring(11);
				
				sDate = commonUtil.getDateStringInUTC(sDate, offset, true);
				eDate = commonUtil.getDateStringInUTC(eDate, offset, true);
				
				map.put("v_P_sDate", sDate);
				map.put("v_P_eDate", eDate);
				
				ezResourceDAO.delResSch_I(map);
			}
		} else {
			logger.debug("delResSch_delete");
			logger.debug("companyID="+companyID);
			logger.debug("ownerID="+ownerID);
			logger.debug("num="+num);
			logger.debug("pNum="+pNum);
			ezResourceDAO.delResSch_D1(map);
			ezResourceDAO.delResSch_D2(map);
			ezResourceDAO.delResSch_D3(map);
		}
		logger.debug("delResSch End");
	}
	
	public int addResSch(String ownerID, String pNum, String companyID, String writerID, String title, String location, String timeDisplay,
			String startDate, String endDate, String allDay, String alertTime, String content, String importance, String reFlag, String gresFlag,
			String entryList, String characterID, String attachFlag, String deptNm, String ownerNm, String approve, String scheduleID, int tenantID, String offset, String deptId) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		
		if (pNum == null || pNum.equals("")) {
			pNum = "0";
		}
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ownerID", ownerID);
		map.put("v_P_pnum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_writerID", writerID);
		map.put("v_P_title", title);
		map.put("v_P_location", location);
		map.put("v_P_timeDisplay", timeDisplay);
		map.put("v_P_startDate", startDate);
		map.put("v_P_endDate", endDate);
		map.put("v_P_allDay", allDay);
		map.put("v_P_alertTime", alertTime);
		map.put("v_P_content", content);
		map.put("v_P_importance", importance);
		map.put("v_P_reFlag", reFlag);
		map.put("v_P_gresFlag", "0");
		map.put("v_P_entryList", entryList);
		map.put("v_P_characterID", "0");
		map.put("v_P_attachFlag", attachFlag);
		map.put("v_P_deptNM", deptNm);
		map.put("v_P_ownerNM", ownerNm);
		map.put("v_P_Approve", approve);
		map.put("v_P_ScheduleID", scheduleID);
		map.put("v_Num", "");
		map.put("v_WriteDay", "");
		map.put("tenantID", tenantID);
		map.put("deptId", deptId);
		map.put("nowDate", nowDate);

		String approveFlag = ezResourceDAO.addRessch_S1(map);
		
		if (approveFlag.equals("1")) {
			approveFlag = "0";
		} else {
			approveFlag = "1";
		}
		
		map.put("v_P_Approve", approveFlag);
		
		String returnFlag = ezResourceDAO.addRessch_S3(map);
		
		map.put("v_P_ReturnFlag", returnFlag);
		
		ezResourceDAO.addResSch(map);
		
		return ezResourceDAO.addRessch_S2(map);
	}
	
	public List<ResGetScheduleRepetitionVO> getRepResourceRepeat(String ownerID, String num, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_p_ownerID", ownerID);
		map.put("v_p_num", num);
		map.put("v_p_companyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getRepResourceRepeat(map);
	}
	
	@Override
	public List<ResAdminVO> getResourceAdminInfo(String brdID, int tenantID, String[] ownerList) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_BRD_ID", brdID);
		map.put("tenantID", tenantID);
		map.put("ownerList", ownerList);
		return ezResourceDAO.getResourceAdminInfo(map);
	}
	
	@Override
	public ResGetSendMailToUserVO getSendMailToUser(String resID, int num, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("resID", resID);
		map.put("num", num);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getSendMailToUser(map);
	}

	@Override
	public String getScheduleXML(String xmlStr, String ownerID, String companyID, String groupID, String gubun, String pType, String pTitle, String pWriterName, String pWriterDept, int tenantID, String offset, String lang) throws Exception {
		logger.debug("getScheduleXML Start");
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String sDate = xmlRes.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
		String eDate = xmlRes.getElementsByTagName("ENDDATETIME").item(0).getTextContent();
		String app = xmlRes.getElementsByTagName("APP").item(0).getTextContent().trim();
		
		// 스케줄 정보 가져옴
		String scheRs = getScheduleList(ownerID, companyID, groupID, gubun, sDate, eDate, pType, pTitle, pWriterName, pWriterDept, tenantID, offset, lang);
		
		Document scheRSDom = commonUtil.convertStringToDocument(scheRs);
		
		//return할 xml string 생성
		StringBuilder returnStr = new StringBuilder();
		returnStr.append("<root>");
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		
		for (int i=0; i<scheRSDom.getElementsByTagName("ROW").getLength(); i++) {
			String num = scheRSDom.getElementsByTagName("num").item(i).getTextContent();
			String pNum = scheRSDom.getElementsByTagName("pnum").item(i).getTextContent();
			String ownerIDStr = scheRSDom.getElementsByTagName("ownerID").item(i).getTextContent();
			String writerIDStr = scheRSDom.getElementsByTagName("writerID").item(i).getTextContent();
			String title = scheRSDom.getElementsByTagName("title").item(i).getTextContent();
			String loc = scheRSDom.getElementsByTagName("location").item(i).getTextContent();
			String startDateTime = scheRSDom.getElementsByTagName("startDate").item(i).getTextContent();
			String endDateTime = scheRSDom.getElementsByTagName("endDate").item(i).getTextContent();
			String reFlag = scheRSDom.getElementsByTagName("reFlag").item(i).getTextContent();
			String gresFlag = scheRSDom.getElementsByTagName("gresFlag").item(i).getTextContent();
			String allDay = scheRSDom.getElementsByTagName("allDay").item(i).getTextContent();
			String writeDay = scheRSDom.getElementsByTagName("writeDay").item(i).getTextContent();
				
			/*if (pType == null || pType.equals("")) {
				 jobTitle = scheRSDom.getElementsByTagName("jobtitle").item(i).getTextContent();
				 jobTitle2 = scheRSDom.getElementsByTagName("jobtitle2").item(i).getTextContent();
			}*/
			if (app.equals("0")) {
				returnStr.append("<appointment>");
					
				returnStr.append("<dtstart>" + startDateTime + "</dtstart>");
				returnStr.append("<dtend>" + endDateTime + "</dtend>");
				returnStr.append("<alldayevent>" + allDay + "</alldayevent>");
					
				String timeDisplay = scheRSDom.getElementsByTagName("timeDisplay").item(i).getTextContent(); 
				if (timeDisplay.equals("1")) {
					timeDisplay = "Busy";
				} else if (timeDisplay.equals("2")) {
					timeDisplay = "Tentative";
				} else if (timeDisplay.equals("3")) {
					timeDisplay = "OOF";
				} else if (timeDisplay.equals("4")) {
					timeDisplay = "Free";
				} else {
					timeDisplay = "";
				}
				returnStr.append("<busystatus>"+timeDisplay+"</busystatus>");
				returnStr.append("<title>"+ title +"</title>");
				returnStr.append("</appointment>");
			} else {
				returnStr.append("<appointment>");
				returnStr.append("<number>" + num + "</number>");
					
				if (pNum.equals("Null") || pNum.equals("NULL")) {
					pNum = "";
				}
				returnStr.append("<pnumber>" + pNum + "</pnumber>");
				returnStr.append("<owner_id>" + ownerIDStr + "</owner_id>");
					
				if (writerIDStr.equals("Null") || writerIDStr.equals("NULL")) {
					writerIDStr = "";
				}
				returnStr.append("<writer_id>" + writerIDStr + "</writer_id>");
					
				if (title.equals("Null") || title.equals("NULL")) {
					title = "";
				}
				returnStr.append("<subject><![CDATA[" + title + "]]></subject>");
				returnStr.append("<instancetype>" + reFlag + "</instancetype>");
					
				if (loc.equals("Null") || loc.equals("NULL")) {
					loc = "";
				}
				returnStr.append("<location><![CDATA[" + loc + "]]></location>");
				returnStr.append("<dtstart>" + startDateTime + "</dtstart>");
				returnStr.append("<dtend>" + endDateTime + "</dtend>");
				
				cal.setTime(format.parse(startDateTime));
				returnStr.append("<dstartTime>" + (cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)) + "</dstartTime>");
				returnStr.append("<dsDaytype>" + (cal.get(Calendar.DAY_OF_WEEK) - 1) + "</dsDaytype>");
				
				cal.setTime(format.parse(endDateTime));
				returnStr.append("<dendTime>" + (cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)) + "</dendTime>");
				returnStr.append("<deDaytype>" + (cal.get(Calendar.DAY_OF_WEEK) - 1) + "</deDaytype>");
				returnStr.append("<alldayevent>"+ allDay +"</alldayevent>");
				
				String timeDisplay = scheRSDom.getElementsByTagName("timeDisplay").item(i).getTextContent();
					
				if (timeDisplay.equals("1")) {
					timeDisplay = "Busy";
				} else if (timeDisplay.equals("2")) {
					timeDisplay = "Tentative";
				} else if (timeDisplay.equals("3")) {
					timeDisplay = "OOF";
				} else if (timeDisplay.equals("4")) {
					timeDisplay = "Free";
				} else {
					timeDisplay = "";
				}
				returnStr.append("<busystatus>"+ timeDisplay +"</busystatus>");
				if (gresFlag.equals("Null") || gresFlag.equals("NULL")) {
					gresFlag = "";
				}
				returnStr.append("<groupflag>"+ gresFlag +"</groupflag>");
				returnStr.append("<gubunFlag>"+ gubun +"</gubunFlag>");
				returnStr.append("<importance>"+ scheRSDom.getElementsByTagName("importance").item(i).getTextContent() +"</importance>");
				returnStr.append("<approveFlag>"+ scheRSDom.getElementsByTagName("approveFlag").item(i).getTextContent() +"</approveFlag>");
				returnStr.append("<returnFlag>"+ scheRSDom.getElementsByTagName("returnFlag").item(i).getTextContent() +"</returnFlag>");
				returnStr.append("<owner_nm><![CDATA[" + scheRSDom.getElementsByTagName("owner_nm").item(i).getTextContent() + "]]></owner_nm>");
				returnStr.append("<dept_name><![CDATA[" + scheRSDom.getElementsByTagName("dept_name").item(i).getTextContent() + "]]></dept_name>");
				returnStr.append("<writeDay>"+ writeDay +"</writeDay>");
				returnStr.append("<title>"+ title +"</title>");
					
				/*if (pType == null || pType.equals("")) {
					returnStr.append("<owner_nm2><![CDATA[" + scheRSDom.getElementsByTagName("owner_nm2").item(i).getTextContent() + "]]></owner_nm2>");
					returnStr.append("<dept_name2><![CDATA[" + scheRSDom.getElementsByTagName("dept_name2").item(i).getTextContent() + "]]></dept_name2>");
					returnStr.append("<jobtitle><![CDATA[" +jobTitle + "]]></jobtitle>");
					returnStr.append("<jobtitle2><![CDATA[" + jobTitle2 + "]]></jobtitle2>");
				}*/
				returnStr.append("</appointment>");
			}
		}
		returnStr.append("</root>");
		
		logger.debug("getScheduleXML End");
		return returnStr.toString();
	}
	
	/*public String getScheduleList(String ownerID, String companyID, String groupID, String gubun, String sDate, String eDate, String pType, String pWriterName, String pWriterDept, int tenantID, String offset) throws Exception {
		logger.debug("getScheduleList Start");

		String startDateLimit = eDate + " 23:59:59";
		String endDateLimit = sDate + " 00:00:01";

		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약이 아닌 것만 가져옴)
		String returnSchedule = "<DATA>";
		if (pType.equals("")) {
			List<ResGetScheduleVO> getScheduleList = getScheduleList(ownerID, companyID, startDateLimit, endDateLimit, pWriterName, pWriterDept, offset, tenantID);
			logger.debug("getScheduleListSize=" + getScheduleList.size());
			
			for (ResGetScheduleVO vo :  getScheduleList) {
				returnSchedule += commonUtil.getQueryResult(vo);
			}
		} else if (pType.equals("MAIN")) {
			List<ResGetScheduleVO> getScheduleListMain = getScheduleListMain(ownerID, companyID, startDateLimit, endDateLimit, offset, tenantID);
			logger.debug("getScheduleListMainSize=" + getScheduleListMain.size());
			
			for (ResGetScheduleVO vo :  getScheduleListMain) {
				returnSchedule += commonUtil.getQueryResult(vo);
			}
		}
		returnSchedule += "</DATA>";
		
		Document returnDom1 = commonUtil.convertStringToDocument(returnSchedule);
		
		// return할 xml string 생성(반복예약 제외)
		StringBuilder returnStr = new StringBuilder();
		returnStr.append("<DATA>");
		
		if (returnDom1 != null) {
			for (int m=0; m<returnDom1.getElementsByTagName("ROW").getLength(); m++) {
				returnStr.append("<ROW>");
				returnStr.append("<num>" + returnDom1.getElementsByTagName("NUM").item(m).getTextContent() + "</num>");
				returnStr.append("<pnum>" + returnDom1.getElementsByTagName("PNUM").item(m).getTextContent() + "</pnum>");
				returnStr.append("<ownerID>" + returnDom1.getElementsByTagName("OWNERID").item(m).getTextContent() + "</ownerID>");
				returnStr.append("<title><![CDATA[" + returnDom1.getElementsByTagName("TITLE").item(m).getTextContent() + "]]></title>");
				returnStr.append("<location><![CDATA[" + returnDom1.getElementsByTagName("LOCATION").item(m).getTextContent() + "]]></location>");
				returnStr.append("<timeDisplay><![CDATA[" + returnDom1.getElementsByTagName("TIMEDISPLAY").item(m).getTextContent() + "]]></timeDisplay>");
				returnStr.append("<startDate>" + commonUtil.getDateStringInUTC(returnDom1.getElementsByTagName("STARTDATE").item(m).getTextContent(), offset, false) + "</startDate>");
				returnStr.append("<endDate>" + commonUtil.getDateStringInUTC(returnDom1.getElementsByTagName("ENDDATE").item(m).getTextContent(), offset, false) + "</endDate>");
				returnStr.append("<alertTime>" + returnDom1.getElementsByTagName("ALERTTIME").item(m).getTextContent() + "</alertTime>");
				returnStr.append("<reFlag>" + returnDom1.getElementsByTagName("REFLAG").item(m).getTextContent() + "</reFlag>");
				returnStr.append("<gresFlag>" + returnDom1.getElementsByTagName("GRESFLAG").item(m).getTextContent() + "</gresFlag>");
				returnStr.append("<writerID>" + returnDom1.getElementsByTagName("WRITERID").item(m).getTextContent() + "</writerID>");
				returnStr.append("<importance>" + returnDom1.getElementsByTagName("IMPORTANCE").item(m).getTextContent() + "</importance>");
				returnStr.append("<entryList>" + returnDom1.getElementsByTagName("ENTRYLIST").item(m).getTextContent() + "</entryList>");
				returnStr.append("<allDay>" + returnDom1.getElementsByTagName("ALLDAY").item(m).getTextContent() + "</allDay>");
				returnStr.append("<writeDay>" + commonUtil.getDateStringInUTC(returnDom1.getElementsByTagName("WRITEDAY").item(m).getTextContent(), offset, false) + "</writeDay>");
				returnStr.append("<attachFlag>" + returnDom1.getElementsByTagName("ATTACHFLAG").item(m).getTextContent() + "</attachFlag>");
				returnStr.append("<characterID>" + returnDom1.getElementsByTagName("CHARACTERID").item(m).getTextContent() + "</characterID>");
				returnStr.append("<approveFlag>" + returnDom1.getElementsByTagName("APPROVEFLAG").item(m).getTextContent() + "</approveFlag>");
				returnStr.append("<owner_nm><![CDATA[" + returnDom1.getElementsByTagName("OWNERNM").item(m).getTextContent() + "]]></owner_nm>");
				returnStr.append("<dept_name><![CDATA[" + returnDom1.getElementsByTagName("DEPTNM").item(m).getTextContent() + "]]></dept_name>");
				
				if (pType.equals("")) {
					returnStr.append("<owner_nm2><![CDATA[" + returnDom1.getElementsByTagName("OWNERNM2").item(m).getTextContent() + "]]></owner_nm2>");
					returnStr.append("<dept_name2><![CDATA[" + returnDom1.getElementsByTagName("DEPTNM2").item(m).getTextContent() + "]]></dept_name2>");
					returnStr.append("<jobtitle><![CDATA[" + returnDom1.getElementsByTagName("JOBTITLE").item(m).getTextContent() + "]]></jobtitle>");
					returnStr.append("<jobtitle2><![CDATA[" + returnDom1.getElementsByTagName("JOBTITLE2").item(m).getTextContent() + "]]></jobtitle2>");
				}
				
				returnStr.append("</ROW>");
			}
		}
			
		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약인 것만 가져옴)
		String returnRepetition = "<DATA>";
		if (pType.equals("")) {
			List<ResGetScheduleVO> getScheduleListRept = getScheduleListRepetiti(ownerID, companyID, startDateLimit, endDateLimit, pWriterName, pWriterDept, offset, tenantID);
			
			for(int j=0; j<getScheduleListRept.size(); j++) {
				returnRepetition += commonUtil.getQueryResult(getScheduleListRept.get(j));
			}
		} else {
			List<ResGetScheduleVO> getScheduleListReptMain = getScheduleListRepetitim(ownerID, companyID, startDateLimit, tenantID, offset);

			for(int j=0; j<getScheduleListReptMain.size(); j++) {
				returnRepetition += commonUtil.getQueryResult(getScheduleListReptMain.get(j));
			}
		}
		returnRepetition += "</DATA>";
		
		Document returnRepetitionDom = commonUtil.convertStringToDocument(returnRepetition);
		
		// return할 xml string 생성(반복예약)
		if (returnRepetitionDom != null) {
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			for (int i=0; i<returnRepetitionDom.getElementsByTagName("ROW").getLength(); i++) {
				String reCompanyID = returnRepetitionDom.getElementsByTagName("COMPANYID").item(i).getTextContent();
				String reNum = returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent();
				String reOwnerID = returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent();
				
				// tbl_schedulerepetition에서 정보 가져옴
				ResGetScheduleRepetitionVO vo = getRepDateTimes(reOwnerID, reCompanyID, Integer.parseInt(reNum), tenantID);
				
				if (vo != null) {
					
					vo.setStartDateTime(commonUtil.getDateStringInUTC(vo.getStartDateTime(), offset, false));
					vo.setEndDateTime(commonUtil.getDateStringInUTC(vo.getEndDateTime(), offset, false));
					
					// ResGetScheduleRepetitionVO -> ResScheduleRepetitionVO
					ResScheduleRepetitionVO rvo = resStruct(vo);
					
					// 반복예약의 반복되는 날짜리스트 뽑아옴
					List<Date[]> returnRepDateTimes = getRepDateTimes(rvo, sDate, eDate, offset);
					
					// 반복예약 중에 삭제된 예약 가져옴
					List<String> deletedDateStrList = getDeletedRepScheduleDate(Integer.parseInt(reNum), reCompanyID, reOwnerID, tenantID);
					logger.debug("deletedDateStrList.size=" + deletedDateStrList.size());
					
					for (int j=0; j<deletedDateStrList.size(); j++) {
						deletedDateStrList.set(j, commonUtil.getDateStringInUTC(deletedDateStrList.get(j), offset, false));
					}
					
					for (Date[] dateArr : returnRepDateTimes) {
						// 삭제된 예약이면 넘어감
						if (deletedDateStrList.contains(format.format(dateArr[0]))) {
							continue;
						}
						
						returnStr.append("<ROW>");
						returnStr.append("<num>" + returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent() + "</num>");
						returnStr.append("<pnum>" + returnRepetitionDom.getElementsByTagName("PNUM").item(i).getTextContent() + "</pnum>");
						returnStr.append("<ownerID>" + returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent() + "</ownerID>");
						returnStr.append("<title><![CDATA[" + returnRepetitionDom.getElementsByTagName("TITLE").item(i).getTextContent() + "]]></title>");
						returnStr.append("<location><![CDATA[" + returnRepetitionDom.getElementsByTagName("LOCATION").item(i).getTextContent() + "]]></location>");
						returnStr.append("<timeDisplay><![CDATA[" + returnRepetitionDom.getElementsByTagName("TIMEDISPLAY").item(i).getTextContent() + "]]></timeDisplay>");
						returnStr.append("<startDate>" + format.format(dateArr[0]) + "</startDate>");
						returnStr.append("<endDate>" + format.format(dateArr[1]) + "</endDate>");
						returnStr.append("<alertTime>" + returnRepetitionDom.getElementsByTagName("ALERTTIME").item(i).getTextContent() + "</alertTime>");
						returnStr.append("<reFlag>" + returnRepetitionDom.getElementsByTagName("REFLAG").item(i).getTextContent() + "</reFlag>");
						returnStr.append("<gresFlag>" + returnRepetitionDom.getElementsByTagName("GRESFLAG").item(i).getTextContent() + "</gresFlag>");
						returnStr.append("<writerID>" + returnRepetitionDom.getElementsByTagName("WRITERID").item(i).getTextContent() + "</writerID>");
						returnStr.append("<importance>" + returnRepetitionDom.getElementsByTagName("IMPORTANCE").item(i).getTextContent() + "</importance>");
						returnStr.append("<entryList>" + returnRepetitionDom.getElementsByTagName("ENTRYLIST").item(i).getTextContent() + "</entryList>");
						returnStr.append("<allDay>" + returnRepetitionDom.getElementsByTagName("ALLDAY").item(i).getTextContent() + "</allDay>");
						returnStr.append("<writeDay>" + commonUtil.getDateStringInUTC(returnRepetitionDom.getElementsByTagName("WRITEDAY").item(i).getTextContent(), offset, false) + "</writeDay>");
						returnStr.append("<attachFlag>" + returnRepetitionDom.getElementsByTagName("ATTACHFLAG").item(i).getTextContent() + "</attachFlag>");
						returnStr.append("<characterID>" + returnRepetitionDom.getElementsByTagName("CHARACTERID").item(i).getTextContent() + "</characterID>");
						returnStr.append("<approveFlag>" + returnRepetitionDom.getElementsByTagName("APPROVEFLAG").item(i).getTextContent() + "</approveFlag>");
						returnStr.append("<owner_nm><![CDATA[" + returnRepetitionDom.getElementsByTagName("OWNERNM").item(i).getTextContent() + "]]></owner_nm>");
						returnStr.append("<dept_name><![CDATA[" + returnRepetitionDom.getElementsByTagName("DEPTNM").item(i).getTextContent() + "]]></dept_name>");
						
						if (pType == null || pType.equals("")) {
							returnStr.append("<owner_nm2><![CDATA[" + returnRepetitionDom.getElementsByTagName("OWNERNM2").item(i).getTextContent() + "]]></owner_nm2>");
							returnStr.append("<dept_name2><![CDATA[" + returnRepetitionDom.getElementsByTagName("DEPTNM2").item(i).getTextContent() + "]]></dept_name2>");
							returnStr.append("<jobtitle><![CDATA[" + returnRepetitionDom.getElementsByTagName("JOBTITLE").item(i).getTextContent() + "]]></jobtitle>");
							returnStr.append("<jobtitle2><![CDATA[" + returnRepetitionDom.getElementsByTagName("JOBTITLE2").item(i).getTextContent() + "]]></jobtitle2>");
						}
						
						returnStr.append("</ROW>");
					}
					
				}
				
			}
		}
		returnStr.append("</DATA>");
		logger.debug("getScheduleList End");
		return returnStr.toString();
	}*/
	
	public String getScheduleList(String ownerID, String companyID, String groupID, String gubun, String sDate, String eDate, String pType, String pTitle, String pWriterName, String pWriterDept, int tenantID, String offset, String lang) throws Exception {
		logger.debug("getScheduleList Start");
		
		sDate = sDate.replace(".", "-");
		eDate = eDate.replace(".", "-");
		
		String startDateLimit = eDate + " 23:59:59";
		String endDateLimit = sDate + " 00:00:01";
		
		List<ResGetScheduleVO> getScheduleList = new ArrayList<>();
		List<ResGetScheduleVO> getScheduleListRept = null;

		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약이 아닌 것만 가져옴)
		if (pType.equals("")) {
			getScheduleList = getScheduleList(ownerID, companyID, startDateLimit, endDateLimit, pTitle, pWriterName, pWriterDept, offset, tenantID, lang);
			logger.debug("getScheduleListSize=" + getScheduleList.size());
		}
		else if (pType.equals("MAIN")) {
			getScheduleList = getScheduleListMain(ownerID, companyID, startDateLimit, endDateLimit, offset, tenantID, lang);
			logger.debug("getScheduleListMainSize=" + getScheduleList.size());
		}

		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약인 것만 가져옴)
		if (pType.equals("")) {
			getScheduleListRept = getScheduleListRepetiti(ownerID, companyID, startDateLimit, endDateLimit, pTitle, pWriterName, pWriterDept, offset, tenantID, lang);
		} else {
			getScheduleListRept = getScheduleListRepetitim(ownerID, companyID, startDateLimit, tenantID, offset, lang);
		}
			
		// return할 xml string 생성(반복예약)
		if (getScheduleListRept.size() > 0) {
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
			for (int i=0; i< getScheduleListRept.size(); i++) {
				String reCompanyID = getScheduleListRept.get(i).getCompanyID();
				int reNum = getScheduleListRept.get(i).getNum();
				String reOwnerID = getScheduleListRept.get(i).getOwnerID();
				
				// tbl_schedulerepetition에서 정보 가져옴
				ResGetScheduleRepetitionVO vo = getRepDateTimes(reOwnerID, reCompanyID, reNum, tenantID);
				
				if (vo != null) {
					
					vo.setStartDateTime(commonUtil.getDateStringInUTC(vo.getStartDateTime(), offset, false));
					vo.setEndDateTime(commonUtil.getDateStringInUTC(vo.getEndDateTime(), offset, false));
					
					// ResGetScheduleRepetitionVO -> ResScheduleRepetitionVO
					ResScheduleRepetitionVO rvo = resStruct(vo);
					
					// 반복예약의 반복되는 날짜리스트 뽑아옴
					List<Date[]> returnRepDateTimes = getRepDateTimes(rvo, sDate, eDate, offset);
					
					// 반복예약 중에 삭제된 예약 가져옴
					List<String> deletedDateStrList = getDeletedRepScheduleDate(reNum, reCompanyID, reOwnerID, tenantID);
					logger.debug("deletedDateStrList.size=" + deletedDateStrList.size());
					
					for (int j=0; j<deletedDateStrList.size(); j++) {
						deletedDateStrList.set(j, (commonUtil.getDateStringInUTC(deletedDateStrList.get(j), offset, false)).substring(0,10));
					}
					
					for (Date[] dateArr : returnRepDateTimes) {
						// 삭제된 예약이면 넘어감
						if (deletedDateStrList.contains(format2.format(dateArr[0]))) {		// 날짜만 비교하도록 수정
							continue;
						}
						
						ResGetScheduleVO temp = new ResGetScheduleVO();

						temp.setNum(getScheduleListRept.get(i).getNum());
						temp.setpNum(getScheduleListRept.get(i).getNum());
						temp.setOwnerID(getScheduleListRept.get(i).getOwnerID());
						temp.setTitle(getScheduleListRept.get(i).getTitle());
						temp.setLocation(getScheduleListRept.get(i).getLocation());
						temp.setTimeDisplay(getScheduleListRept.get(i).getTimeDisplay());
						temp.setStartDate(commonUtil.getDateStringInUTC(format.format(dateArr[0]), offset, true));
						temp.setEndDate(commonUtil.getDateStringInUTC(format.format(dateArr[1]), offset, true));
						temp.setAlertTime(getScheduleListRept.get(i).getAlertTime());
						temp.setReFlag(getScheduleListRept.get(i).getReFlag());
						temp.setGresFlag(getScheduleListRept.get(i).getGresFlag());
						temp.setWriterID(getScheduleListRept.get(i).getWriterID());
						temp.setImportance(getScheduleListRept.get(i).getImportance());
						temp.setEntryList(getScheduleListRept.get(i).getEntryList());
						temp.setAllDay(getScheduleListRept.get(i).getAllDay());
						temp.setWriteDay(getScheduleListRept.get(i).getWriteDay());
						temp.setAttachFlag(getScheduleListRept.get(i).getAttachFlag());
						temp.setCharacterID(getScheduleListRept.get(i).getCharacterID());
						temp.setApproveFlag(getScheduleListRept.get(i).getApproveFlag());
						temp.setReturnFlag(getScheduleListRept.get(i).getReturnFlag());
						temp.setOwnerNm(getScheduleListRept.get(i).getOwnerNm());
						temp.setDeptNm(getScheduleListRept.get(i).getDeptNm());
						/*temp.setOwnerNm2(getScheduleListRept.get(i).getOwnerNm2());
						temp.setDeptNm2(getScheduleListRept.get(i).getOwnerNm2());
						temp.setJobTitle(getScheduleListRept.get(i).getJobTitle());
						temp.setJobTitle2(getScheduleListRept.get(i).getJobTitle2());*/
						
						getScheduleList.add(temp);
					}
					
				}
				
			}
		}
		
		//자원별 일정 정렬
	    //시간순, 제목순
        Collections.sort(getScheduleList, new Comparator<ResGetScheduleVO>() {
			@Override
			public int compare(ResGetScheduleVO o1, ResGetScheduleVO o2) {
					
				if(o1.getAllDay().compareTo(o2.getAllDay()) == 0){
					if(o1.getStartDate().compareTo(o2.getStartDate()) == 0){
						
						if(o1.getEndDate().compareTo(o2.getEndDate()) == 0){
							
							return o1.getTitle().compareTo(o2.getTitle());
						}else {
							return o1.getEndDate().compareTo(o2.getEndDate());
						}
						
					}else {
						return o1.getStartDate().compareTo(o2.getStartDate());
					}	
				}else {
					return o1.getAllDay().compareTo(o2.getAllDay());
				}
							
			}
		});
		
		StringBuilder returnScheduleBld = new StringBuilder();
		returnScheduleBld.append("<DATA>");
		
		for (ResGetScheduleVO vo :  getScheduleList) {
			returnScheduleBld.append(commonUtil.getQueryResult(vo));
		}
		
		returnScheduleBld.append("</DATA>");
		
		Document returnDom1 = commonUtil.convertStringToDocument(returnScheduleBld.toString());
		
		// return할 xml string 생성(반복예약 제외)
		StringBuilder returnStr = new StringBuilder();
		returnStr.append("<DATA>");
		
		if (returnDom1 != null) {
			for (int m=0; m<returnDom1.getElementsByTagName("ROW").getLength(); m++) {
				returnStr.append("<ROW>");
				returnStr.append("<num>" + returnDom1.getElementsByTagName("NUM").item(m).getTextContent() + "</num>");
				returnStr.append("<pnum>" + returnDom1.getElementsByTagName("PNUM").item(m).getTextContent() + "</pnum>");
				returnStr.append("<ownerID>" + returnDom1.getElementsByTagName("OWNERID").item(m).getTextContent() + "</ownerID>");
				returnStr.append("<title><![CDATA[" + returnDom1.getElementsByTagName("TITLE").item(m).getTextContent() + "]]></title>");
				returnStr.append("<location><![CDATA[" + returnDom1.getElementsByTagName("LOCATION").item(m).getTextContent() + "]]></location>");
				returnStr.append("<timeDisplay><![CDATA[" + returnDom1.getElementsByTagName("TIMEDISPLAY").item(m).getTextContent() + "]]></timeDisplay>");
				returnStr.append("<startDate>" + commonUtil.getDateStringInUTC(returnDom1.getElementsByTagName("STARTDATE").item(m).getTextContent(), offset, false) + "</startDate>");
				returnStr.append("<endDate>" + commonUtil.getDateStringInUTC(returnDom1.getElementsByTagName("ENDDATE").item(m).getTextContent(), offset, false) + "</endDate>");
				returnStr.append("<alertTime>" + returnDom1.getElementsByTagName("ALERTTIME").item(m).getTextContent() + "</alertTime>");
				returnStr.append("<reFlag>" + returnDom1.getElementsByTagName("REFLAG").item(m).getTextContent() + "</reFlag>");
				returnStr.append("<gresFlag>" + returnDom1.getElementsByTagName("GRESFLAG").item(m).getTextContent() + "</gresFlag>");
				returnStr.append("<writerID>" + returnDom1.getElementsByTagName("WRITERID").item(m).getTextContent() + "</writerID>");
				returnStr.append("<importance>" + returnDom1.getElementsByTagName("IMPORTANCE").item(m).getTextContent() + "</importance>");
				returnStr.append("<entryList>" + returnDom1.getElementsByTagName("ENTRYLIST").item(m).getTextContent() + "</entryList>");
				returnStr.append("<allDay>" + returnDom1.getElementsByTagName("ALLDAY").item(m).getTextContent() + "</allDay>");
				returnStr.append("<writeDay>" + commonUtil.getDateStringInUTC(returnDom1.getElementsByTagName("WRITEDAY").item(m).getTextContent(), offset, false) + "</writeDay>");
				returnStr.append("<attachFlag>" + returnDom1.getElementsByTagName("ATTACHFLAG").item(m).getTextContent() + "</attachFlag>");
				returnStr.append("<characterID>" + returnDom1.getElementsByTagName("CHARACTERID").item(m).getTextContent() + "</characterID>");
				returnStr.append("<approveFlag>" + returnDom1.getElementsByTagName("APPROVEFLAG").item(m).getTextContent() + "</approveFlag>");
				returnStr.append("<returnFlag>" + returnDom1.getElementsByTagName("RETURNFLAG").item(m).getTextContent() + "</returnFlag>");
				returnStr.append("<owner_nm><![CDATA[" + returnDom1.getElementsByTagName("OWNERNM").item(m).getTextContent() + "]]></owner_nm>");
				returnStr.append("<dept_name><![CDATA[" + returnDom1.getElementsByTagName("DEPTNM").item(m).getTextContent() + "]]></dept_name>");
				
				/*if (pType.equals("")) {
					returnStr.append("<owner_nm2><![CDATA[" + returnDom1.getElementsByTagName("OWNERNM2").item(m).getTextContent() + "]]></owner_nm2>");
					returnStr.append("<dept_name2><![CDATA[" + returnDom1.getElementsByTagName("DEPTNM2").item(m).getTextContent() + "]]></dept_name2>");
					returnStr.append("<jobtitle><![CDATA[" + returnDom1.getElementsByTagName("JOBTITLE").item(m).getTextContent() + "]]></jobtitle>");
					returnStr.append("<jobtitle2><![CDATA[" + returnDom1.getElementsByTagName("JOBTITLE2").item(m).getTextContent() + "]]></jobtitle2>");
				}*/
				
				returnStr.append("</ROW>");
			}
		}
		
		returnStr.append("</DATA>");
		
		logger.debug("getScheduleList End");
		return returnStr.toString();
	}
	
	public List<Date[]> getRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, String offset) throws Exception {
		logger.debug("getRepDeteTimes started");
		
		int maxTemp = 1000;
		
		List<Date[]> returnList = new ArrayList<Date[]>();
			
		int freq = vo.getFreq();
		
		if (sDate.length() == 10) {
			sDate += " 00:00:00";
		}
		if (eDate.length() == 10) {
			eDate += " 23:59:59";
		}
		
		if (freq == 4) {
			returnList = getDailyRepDateTimes(vo, sDate, eDate, maxTemp); 
		} else if (freq == 5) {
			returnList = getWeeklyRepDateTime(vo, sDate, eDate, maxTemp);
		} else if (freq == 6 || freq == 7) {
			returnList = getMonthlyRepDateTimes(vo, sDate, eDate, maxTemp);
		}
		
		logger.debug("returnList.size()=" + returnList.size());
		logger.debug("getRepDeteTimes ended");
		
		return returnList;
	}
	
	public List<Date[]> getDailyRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception {
		int selType = vo.getSelType();
		int interval = vo.getInterval();
		int endRecurType = vo.getEndRecurType();
		int instances = vo.getInstances();
		int tempYoil = 0;
		
		// 자원예약 기간
		Date resEndDate = vo.getEndDate();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		// 요청 기간
		Date startDate = sdf.parse(sDate);
		Date endDate = sdf.parse(eDate);
		String tmpStartDateStr = sdf.format(vo.getStartDate());
		String tmpEndDateStr = tmpStartDateStr.substring(0, 10) + sdf.format(vo.getEndDate()).substring(10);
		
		Date tmpStartDate = vo.getStartDate();
		Date tmpEndDate = sdf.parse(tmpEndDateStr);
		
		Calendar tempStartCal = Calendar.getInstance();
		tempStartCal.setTime(tmpStartDate);
		
		Calendar tempEndCal = Calendar.getInstance();
		tempEndCal.setTime(tmpEndDate);
		
		// timezone으로 인해 tmpStartDate가 tmpEndDate보다 늦은 경우 tmpEndDate를 하루 늘려준다.
		if (tmpStartDate.after(tmpEndDate)) {
			tempEndCal.add(Calendar.DATE, 1);
			tmpEndDate = tempEndCal.getTime();
		}
		
		long diff = tmpEndDate.getTime() - tmpStartDate.getTime();
		
		/*logger.debug("sDate=" + sDate);
		logger.debug("eDate=" + eDate);
		logger.debug("selType=" + selType);
		logger.debug("interval=" + interval);
		logger.debug("endRecurType=" + endRecurType);
		logger.debug("instances=" + instances);
		logger.debug("startDate=" + sdf.format(startDate));
		logger.debug("endDate=" + sdf.format(endDate));
		logger.debug("resStartDate=" + sdf.format(resStartDate));
		logger.debug("resEndDate=" + sdf.format(resEndDate));
		logger.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		logger.debug("tmpEndDate=" + sdf.format(tmpEndDate));*/
		
		List<Date[]> returnList = new ArrayList<Date[]>();
		
		int temp = maxTemp; // 최대 maxTemp번 반복
		while (true) {
			// 40일 때(매 n일)
			if (selType == 0) {
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tmpStartDate.after(endDate)) {
						break;
					} else if (!tmpStartDate.before(startDate)) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tmpStartDate.after(endDate) || tmpStartDate.after(resEndDate)) {
						break;
					} else if (!tmpStartDate.before(startDate)) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tmpStartDate.after(endDate) || instances <= 0) {
						break;
					} else {
						if (!tmpStartDate.before(startDate)) {
							tempEndCal.setTime(tmpStartDate);
							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tmpStartDate, 
									tempEndCal.getTime()
							});
						}
						
						instances--;
					}
				}
			}
			// 41일 때(평일 매일)
			else {
				tempYoil = tempStartCal.get(Calendar.DAY_OF_WEEK);
				
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tmpStartDate.after(endDate)) {
						break;
					} else if (!tmpStartDate.before(startDate) && tempYoil > 1 && tempYoil < 7) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tmpStartDate.after(endDate) || tmpStartDate.after(resEndDate)) {
						break;
					} else if (!tmpStartDate.before(startDate) &&tempYoil > 1 && tempYoil < 7) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tmpStartDate.after(endDate) || instances <= 0) {
						break;
					} else if (tempYoil > 1 && tempYoil < 7) {
						if (!tmpStartDate.before(startDate)) {
							tempEndCal.setTime(tmpStartDate);
							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tmpStartDate, 
									tempEndCal.getTime()
							});
						}
						
						instances--;
					}
				}
			}
			
			tempStartCal.add(Calendar.DATE, interval);
			tmpStartDate = tempStartCal.getTime();
			
			temp--;
			
			if (temp < 0) {
				logger.debug("Repeat time over 1000.");
				break;
			}
		}
		
		return returnList;
	}
	
	public List<Date[]> getWeeklyRepDateTime (ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception  {
		int interval = vo.getInterval();
		int endRecurType = vo.getEndRecurType();
		int instances = vo.getInstances();
		List<Integer> wDay = vo.getDaysOfWeek();
		
		if (wDay != null && wDay.size() > 0) {
			instances = instances * wDay.size();
		}
		
		// 자원예약 기간
		Date resStartDate = vo.getStartDate();
		Date resEndDate = vo.getEndDate();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		// 요청 기간
		Date startDate = sdf.parse(sDate);
		Date endDate = sdf.parse(eDate);

		String tmpStartDateStr = sdf.format(vo.getStartDate());
		String tmpEndDateStr = tmpStartDateStr.substring(0, 10) + sdf.format(vo.getEndDate()).substring(10);
		
		Date tmpStartDate = vo.getStartDate();
		Date tmpEndDate = sdf.parse(tmpEndDateStr);
		
		Calendar tempStartCal = Calendar.getInstance();
		tempStartCal.setTime(tmpStartDate);
		
		Calendar tempEndCal = Calendar.getInstance();
		tempEndCal.setTime(tmpEndDate);
		
		// timezone으로 인해 tmpStartDate가 tmpEndDate보다 늦은 경우 tmpEndDate를 하루 늘려준다.
		if (tmpStartDate.after(tmpEndDate)) {
			tempEndCal.add(Calendar.DATE, 1);
			tmpEndDate = tempEndCal.getTime();
		}
		
		long diff = tmpEndDate.getTime() - tmpStartDate.getTime();
		
		/*logger.debug("sDate=" + sDate);
		logger.debug("eDate=" + eDate);
		logger.debug("interval=" + interval);
		logger.debug("endRecurType=" + endRecurType);
		logger.debug("instances=" + instances);
		logger.debug("startDate=" + sdf.format(startDate));
		logger.debug("endDate=" + sdf.format(endDate));
		logger.debug("resStartDate=" + sdf.format(resStartDate));
		logger.debug("resEndDate=" + sdf.format(resEndDate));
		logger.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		logger.debug("tmpEndDate=" + sdf.format(tmpEndDate));*/
		
		List<Date[]> returnList = new ArrayList<Date[]>();
		
		int temp = maxTemp; // 최대 maxTemp번 반복
		
		boolean loopFlag = true;
		while (loopFlag) {
			
			for (int i=0; i<wDay.size(); i++) {
				tempStartCal.set(Calendar.DAY_OF_WEEK, wDay.get(i) + 1);
				tmpStartDate = tempStartCal.getTime();
				
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tmpStartDate.after(endDate)) {
						loopFlag = false;
						break;
					} else if (!tmpStartDate.before(startDate) && !tmpStartDate.before(resStartDate)) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tmpStartDate.after(endDate) || tmpStartDate.after(resEndDate)) {
						loopFlag = false;
						break;
					} else if (!tmpStartDate.before(startDate) && !tmpStartDate.before(resStartDate)) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tmpStartDate.after(endDate) || instances <= 0) {
						loopFlag = false;
						break;
					} else if (!tmpStartDate.before(resStartDate)) {
						instances--;
						
						if (!tmpStartDate.before(startDate)) {
							tempEndCal.setTime(tmpStartDate);
							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tmpStartDate, 
									tempEndCal.getTime()
							});
						}
					}
				}
				
			}
			
			tempStartCal.add(Calendar.DATE, interval * 7);
			
			temp--;
			
			if (temp < 0) {
				logger.debug("Repeat time over 1000.");
				break;
			}
			
		}
		
		return returnList;
	}
	
	public List<Date[]> getMonthlyRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception {
		logger.debug("getMonthlyRepDateTimes started.");
		int freq = vo.getFreq();
		int selType = vo.getSelType();
		int interval = vo.getInterval();
		int daysOfMonth = vo.getDaysOfMonth();
		int monthsOfYear = vo.getMonthsOfYear();
		int byPosition = vo.getByPosition();
		int endRecurType = vo.getEndRecurType();
		int instances = vo.getInstances();
		List<Integer> wDay = vo.getDaysOfWeek();
		
		if (wDay != null && wDay.size() > 0) {
			instances = instances * wDay.size();
		}
		
		// 자원예약 기간
		Date resStartDate = vo.getStartDate();
		Date resEndDate = vo.getEndDate();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		// 요청 기간
		Date startDate = sdf.parse(sDate);
		Date endDate = sdf.parse(eDate);

		String tmpStartDateStr = sdf.format(vo.getStartDate());
		String tmpEndDateStr = tmpStartDateStr.substring(0, 10) + sdf.format(vo.getEndDate()).substring(10);
		
		Date tmpStartDate = vo.getStartDate();
		Date tmpEndDate = sdf.parse(tmpEndDateStr);
		
		Calendar tempStartCal = Calendar.getInstance();
		tempStartCal.setTime(tmpStartDate);
		
		Calendar tempEndCal = Calendar.getInstance();
		tempEndCal.setTime(tmpEndDate);
		
		// timezone으로 인해 tmpStartDate가 tmpEndDate보다 늦은 경우 tmpEndDate를 하루 늘려준다.
		if (tmpStartDate.after(tmpEndDate)) {
			tempEndCal.add(Calendar.DATE, 1);
			tmpEndDate = tempEndCal.getTime();
		}
		
		long diff = tmpEndDate.getTime() - tmpStartDate.getTime();
		
		/*logger.debug("sDate=" + sDate);
		logger.debug("eDate=" + eDate);
		logger.debug("interval=" + interval);
		logger.debug("endRecurType=" + endRecurType);
		logger.debug("instances=" + instances);
		logger.debug("startDate=" + sdf.format(startDate));
		logger.debug("endDate=" + sdf.format(endDate));
		logger.debug("resStartDate=" + sdf.format(resStartDate));
		logger.debug("resEndDate=" + sdf.format(resEndDate));
		logger.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		logger.debug("tmpEndDate=" + sdf.format(tmpEndDate));*/
		
		List<Date[]> returnList = new ArrayList<Date[]>();
		
		int temp = maxTemp; // 최대 maxTemp번 반복
		
		List<Date> tsdList = new ArrayList<Date>();
		
		boolean loopFlag = true;
		while (loopFlag) {
			tsdList.clear();
			
			if (freq == 7) {
				tempStartCal.set(Calendar.MONTH, monthsOfYear - 1);
			}
			
			// 날짜
			if (selType == 0) {
				// daysOfMonth가 해당 달의 마지막날보다 크지 않으면 list에 추가
				int lastDate = tempStartCal.getActualMaximum(Calendar.DAY_OF_MONTH);
				if (daysOfMonth <= lastDate) {
					tempStartCal.set(Calendar.DAY_OF_MONTH, daysOfMonth);
					tsdList.add(tempStartCal.getTime());
				}
			}
			// 요일
			else {
				// 마지막 요일일 때
				if (byPosition == -1) {
					// 해당 달의 뒤에서 부터 원하는 요일의 날짜를 찾아감.
					int lastDate = tempStartCal.getActualMaximum(Calendar.DAY_OF_MONTH);
					tempStartCal.set(Calendar.DATE, lastDate);
					int lastYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					
					// 발견할 때까지 날짜 줄여나감
					while (!wDay.contains(lastYoil)) {
						tempStartCal.add(Calendar.DATE, -1);
						lastYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
					
					// 발견하면 그때부터 list에 추가
					while (wDay.contains(lastYoil)) {
						tsdList.add(tempStartCal.getTime());
						
						tempStartCal.add(Calendar.DATE, -1);
						lastYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
					
					//뒤에서부터 찾았기 때문에 횟수제한이 있을 때에는 문제가 있으므로 reverse해줌.
					Collections.reverse(tsdList);
				}
				// 마지막 요일 아닐 때
				else {
					// 해당 달의 앞에서 부터 n번째 요일의 날짜를 찾아감.
					tempStartCal.set(Calendar.DATE, 1);
					int firstYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					
					//발견할 때까지 날짜 늘려나감
					while (!wDay.contains(firstYoil)) {
						tempStartCal.add(Calendar.DATE, 1);
						firstYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
					
					tempStartCal.add(Calendar.DATE, (byPosition - 1) * 7);
					
					// 발견하면 그때부터 list에 추가
					while (wDay.contains(firstYoil)) {
						tsdList.add(tempStartCal.getTime());
						
						tempStartCal.add(Calendar.DATE, 1);
						firstYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
				}
			}
			
			for (Date tsd : tsdList) {
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tsd.after(endDate)) {
						loopFlag = false;
						break;
					} else if (!tsd.before(startDate) && !tsd.before(resStartDate)) {
						tempEndCal.setTime(tsd);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tsd, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tsd.after(endDate) || tsd.after(resEndDate)) {
						loopFlag = false;
						break;
					} else if (!tsd.before(startDate) && !tsd.before(resStartDate)) {
						tempEndCal.setTime(tsd);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tsd, 
								tempEndCal.getTime()
						});
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tsd.after(endDate) || instances <= 0) {
						loopFlag = false;
						break;
					} else if (!tsd.before(resStartDate)) {
						instances--;
						
						if (!tsd.before(startDate)) {
							tempEndCal.setTime(tsd);
							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tsd, 
									tempEndCal.getTime()
							});
						}
					}
				}
			}
			
			if (freq == 6) {
				tempStartCal.add(Calendar.MONTH, interval);
			} else {
				tempStartCal.add(Calendar.YEAR, 1);
			}
			
			temp--;
			
			if (temp < 0) {
				logger.debug("Repeat time over 1000.");
				break;
			}
			
		}
		
		logger.debug("getMonthlyRepDateTimes End");
		return returnList;
	}
	
	@Override
	public String getAdminFlag(String companyID, String brdID, String userID, int tenantID, String deptID) throws Exception {
		String accessLvl = "";
		

		/* 2018-07-13 홍승비 - everyone을 관리자로 설정한 경우 우선적으로 해당 관리자 플래그 받아오도록 수정 */
		ResGetAdminFlagVO resGetAdminFlag = getAdmFlag(companyID, brdID, userID, tenantID);
		
		if (resGetAdminFlag != null && resGetAdminFlag.getAccessLvl() != null && !resGetAdminFlag.getAccessLvl().equals("")) {
			String strXML = "<DATA>"+commonUtil.getQueryResult(resGetAdminFlag)+"</DATA>";
			Document xmlDom = commonUtil.convertStringToDocument(strXML);
			
			if(xmlDom.getElementsByTagName("ROW") != null) {
				for(int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
					accessLvl = xmlDom.getElementsByTagName("ACCESSLVL").item(i).getTextContent().trim();
				}
			}
			
			logger.debug("everyone or user accessLvl : " + accessLvl);
		}
			if(accessLvl.equals("1")) {			// everyone 혹은 user 권한이 관리자 이면 Y 리턴, 그 외 U + 부서권한 체크
				return "Y";
			} /*else {
				//해안
				String vTenantID = String.valueOf(tenantID);
				Map<String,Object> deptAccessLvlMap = new HashMap<String, Object>();
				deptAccessLvlMap.put("IN_DEPT_CN", deptID);
				deptAccessLvlMap.put("IN_TENANT_ID", vTenantID);
				deptAccessLvlMap.put("IN_BRD_ID", brdID);
				logger.debug("deptID : " + deptID + " tenant_id : " + vTenantID + " brd_ID : " + brdID);
				
				ezResourceDAO.getDeptAccessLvl(deptAccessLvlMap);
				
				String AccessDeptLvl = deptAccessLvlMap.get("OUT_RESULT_ACL").toString();
				logger.debug("AccessDeptLvl : " + AccessDeptLvl);
				
				if (AccessDeptLvl != null && !AccessDeptLvl.equals("") && AccessDeptLvl.equals("1")) {
					accessLvl = AccessDeptLvl;
				}
			} */
			/*else {		// 아이디 혹은 everyone에서 관리자 권한 있을 때
				return "Y";
			}*/
		else {	//부서의 관리자 권한 확인
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("v_PCOMPANYID", companyID);
			map.put("v_BRD_UPPER", brdID);
			map.put("tenantID", tenantID);
			
			String deptPath = ezOrganService.getDeptPath(deptID, tenantID);
			List<String> deptIds = new ArrayList<String>();
			Collections.addAll(deptIds, deptPath.split(","));
			//deptIds.remove(0);				// companyID 삭제
			if(deptIds.size() > 0) {
				Collections.reverse(deptIds);
				
				map.put("v_PUSERID", deptIds.get(0));
				String deptAccLvl = ezResourceDAO.getAclTblBrd_S3(map);
					
				if(deptAccLvl != null && deptAccLvl.trim().equals("1")) {
					logger.debug("user dept accessLvl = admin");
					return "Y";
				}
				else {
					if (deptAccLvl != null && deptAccLvl.trim().equals("2")) {
						logger.debug("user dept accessLvl = user");
						accessLvl = "2";
					}
					// 부서 상위 권한 체크
					deptIds.remove(0);				// 현재 부서ID 삭제
					if(deptIds.size() > 0) {
						map.put("v_PUSERID", deptIds);
						
						List<ResGetClsAclListVO> deptAclList = ezResourceDAO.getDeptAcl(map);
		
						if(deptAclList != null) {
							for(int i=0; i<deptAclList.size(); i++) {
								if(deptAclList.get(i).getAccessLvl().equals("1")) {
									logger.debug("user upper dept accessLvl = admin");
									return "Y";
								}
								else {
									logger.debug("user upper dept accessLvl = user");
									accessLvl = "2";
								}
							}
						}
					}
				}
			}
			
			// 사내 겸직 권한 체크
			List<OrganUserVO> userAddJobList = ezOrganAdminService.getUserAddJobList(userID, "1", tenantID);

			if(userAddJobList.size() > 0) {
				for(int i=0; i<userAddJobList.size(); i++) {
					String addJobDeptPath = ezOrganService.getDeptPath(userAddJobList.get(i).getDepartment(), tenantID);
					List<String> addJobDeptIds = new ArrayList<String>();
					Collections.addAll(addJobDeptIds, addJobDeptPath.split(","));
					//addJobDeptIds.remove(0);				// companyID 삭제
					if(addJobDeptIds.size() > 0) {
						Collections.reverse(addJobDeptIds);
						
						map.put("v_PUSERID", addJobDeptIds.get(0));
						String addJobAccLvl = ezResourceDAO.getAclTblBrd_S3(map);
							
						if(addJobAccLvl != null && addJobAccLvl.trim().equals("1")) {
							logger.debug("user addjob dept accessLvl = admin");
							return "Y";
						}
						else {
							if (addJobAccLvl != null && addJobAccLvl.trim().equals("2")) {
								logger.debug("user addjob dept accessLvl = user");
								accessLvl = "2";
							} 
							// 부서 상위 권한 체크
							addJobDeptIds.remove(0);				// 현재 부서ID 삭제
							if(addJobDeptIds.size() > 0) {
								map.put("v_PUSERID", addJobDeptIds);
								
								List<ResGetClsAclListVO> deptAclList = ezResourceDAO.getDeptAcl(map);
								
								if(deptAclList != null) {
									for(int j=0; j<deptAclList.size(); j++) {
										if(deptAclList.get(j).getAccessLvl().equals("1")) {
											logger.debug("user addjob upper dept accessLvl = admin");
											return "Y";
										}
										else {
											logger.debug("user addjob upper dept accessLvl = user");
											accessLvl = "2";
										}
									}
								}
							}
						}
					}
				}
			}
			
			/* //해안
 			String vTenantID = String.valueOf(tenantID);
			Map<String,Object> deptAccessLvlMap = new HashMap<String, Object>();
			deptAccessLvlMap.put("IN_DEPT_CN", deptID);
			deptAccessLvlMap.put("IN_TENANT_ID", vTenantID);
			deptAccessLvlMap.put("IN_BRD_ID", brdID);
			logger.debug("deptID : " + deptID + " tenant_id : " + vTenantID + " brd_ID : " + brdID);
			
			ezResourceDAO.getDeptAccessLvl(deptAccessLvlMap);
			
			String AccessDeptLvl = deptAccessLvlMap.get("OUT_RESULT_ACL").toString();
			logger.debug("AccessDeptLvl : " + AccessDeptLvl);
			
			if (AccessDeptLvl != null && !AccessDeptLvl.equals("")) {
				accessLvl = AccessDeptLvl;
			} */
		}
		
		if(accessLvl.trim().equals("1")) {
			return "Y";
		} else if(accessLvl.trim().equals("2")) {
			return "U";
		} else {
			return "";
		}
	
	}
	
	@Override
	public String getItemList(@CookieValue("loginCookie") String loginCookie,String brdID) throws Exception {
		StringBuilder childBrdBld = new StringBuilder();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<ResGetItemListVO> list = getBrdMainList(brdID, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
		
		for(int i=0; i<list.size(); i++) {
			childBrdBld.append(list.get(i).getBrd_ID() + "/" + commonUtil.cleanValue(list.get(i).getBrd_Nm()) + "/" + list.get(i).getApproveFlag()  +  ",");
		}
		
		return childBrdBld.toString();
	}
	
	@Override
	public String getSubClsTree(String xmlStr, String langStr, String pComID, String pDeptID, String pUserID, int tenantID) throws Exception {
        String strUserID = "";
        String userAdminFlag = "";
        String strAdminType = "";
   
        Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
        String strParentID = xmlRes.getElementsByTagName("PARENT_ID").item(0).getTextContent().trim();
        String strCompanyID = xmlRes.getElementsByTagName("COMPANY_ID").item(0).getTextContent().trim();
        String strAccessFlag = xmlRes.getElementsByTagName("ACCESS_FLAG").item(0).getTextContent().trim();
        String strFirstNode = xmlRes.getElementsByTagName("FIRST_NODE").item(0).getTextContent().trim();
        String strTreeType = xmlRes.getElementsByTagName("TREE_TYPE").item(0).getTextContent().trim();
        if(strTreeType.equals("0")) {
        	strAdminType = xmlRes.getElementsByTagName("ADMIN_CHECK").item(0).getTextContent().trim();
        }

        if(xmlRes.getElementsByTagName("BRDLIST").getLength() > 5) {
        	strUserID = xmlRes.getElementById("BRDLIST").getChildNodes().item(5).getTextContent().trim();
        }
        
        if(strAdminType.equals("Y")) {
        	userAdminFlag = getAdminFlag(pComID, strParentID, pUserID, tenantID, pDeptID);
        }
        
        List<ResGetAdmSubClsTreeVO> resGetAdmSubClsTree = new ArrayList<ResGetAdmSubClsTreeVO>();
        if(strAccessFlag.equals("0")) {
        	resGetAdmSubClsTree = getAdmSubClsTree(strParentID, strCompanyID, strTreeType, tenantID, userAdminFlag);
        } else {
        	resGetAdmSubClsTree = getSubClsTree(strParentID, strCompanyID, strTreeType, strUserID, pComID, pDeptID, pUserID, tenantID);
        }
        
        StringBuilder strTreeStyle = new StringBuilder();
        if(strFirstNode.equals("Y")) {
        	strTreeStyle.append("<TREEVIEWDATA>");
        	strTreeStyle.append("<TEXTCOLOR>");
        	strTreeStyle.append("<NAME>ENTUMTEXTCOLOR</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<DEFAULTTEXTCOLOR>black</DEFAULTTEXTCOLOR>");					
        	strTreeStyle.append("<DEFAULTBGCOLOR>ffffff</DEFAULTBGCOLOR>");
        	strTreeStyle.append("<SELECTEDTEXTCOLOR>164AAD</SELECTEDTEXTCOLOR>");
        	strTreeStyle.append("<SELECTEDBGCOLOR>ffffff</SELECTEDBGCOLOR>");
        	strTreeStyle.append("<HOTTRACKINGTEXTCOLOR>164AAD</HOTTRACKINGTEXTCOLOR>");
        	strTreeStyle.append("<HOTTRACKINGBGCOLOR>ffffff</HOTTRACKINGBGCOLOR>");
        	strTreeStyle.append("</TEXTCOLOR>");
        	strTreeStyle.append("<NODEICONIMAGE>");
        	strTreeStyle.append("<NAME>RESCLASS</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_01.gif</LEAFDEFAULTICON>");
        	strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_01.gif</LEAFSELECTEDICON>");
        	strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_01.gif</BRANCHDEFAULTICON>");
        	strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_01.gif</BRANCHSELECTEDICON>");
        	strTreeStyle.append("</NODEICONIMAGE>");
        	strTreeStyle.append("<NODEICONIMAGE>");
        	strTreeStyle.append("<NAME>RESOURCE</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_02.gif</LEAFDEFAULTICON>");
        	strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_02.gif</LEAFSELECTEDICON>");
        	
        	strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_02.gif</BRANCHDEFAULTICON>");
        	strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_02.gif</BRANCHSELECTEDICON>");
        	strTreeStyle.append("</NODEICONIMAGE>");
        	strTreeStyle.append("<HERITAGEICONIMAGE>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<BLANKICON>/images/left/blank.gif</BLANKICON>");
        	strTreeStyle.append("<VERTICALLINEICON>/images/left/vline.gif</VERTICALLINEICON>");
        	strTreeStyle.append("<NODEICON>/images/left/02.gif</NODEICON>");
        	strTreeStyle.append("<MNODEICON>/images/left/02_minus.gif</MNODEICON>");
        	strTreeStyle.append("<PNODEICON>/images/left/02_plus.gif</PNODEICON>");
        	strTreeStyle.append("<ROOTNODEICON>/images/left/03.gif</ROOTNODEICON>");
        	strTreeStyle.append("<MROOTNODEICON>/images/left/03_minus.gif</MROOTNODEICON>");
        	strTreeStyle.append("<PROOTNODEICON>/images/left/03_plus.gif</PROOTNODEICON>");
        	strTreeStyle.append("<LASTNODEICON>/images/left/03.gif</LASTNODEICON>");
        	strTreeStyle.append("<MLASTNODEICON>/images/left/03_minus.gif</MLASTNODEICON>");
        	strTreeStyle.append("<FIRSTROOTNODEICON>/images/left/02.gif</FIRSTROOTNODEICON>");
        	strTreeStyle.append("<MFIRSTROOTNODEICON>/images/left/02_minus.gif</MFIRSTROOTNODEICON>");
        	strTreeStyle.append("<PFIRSTROOTNODEICON>/images/left/02_plus.gif</PFIRSTROOTNODEICON>");
        	strTreeStyle.append("</HERITAGEICONIMAGE>");
        }
        else {
        	strTreeStyle.append("<NODES>");
        }
        if(strFirstNode.equals("Y")) {
        	for(int i = 0; i < resGetAdmSubClsTree.size(); i++) {
        		if(i == 0) {
        			strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), true, langStr));
        		} else {
        			if(resGetAdmSubClsTree.get(i).getApproveFlag().equals("2")) {
            			if(userAdminFlag.equals("Y")) {
            				strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), false, langStr));
            			}
            		} 
        			else {
        				strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), false, langStr));
        			}
        		}
        	}
        	strTreeStyle.append("</TREEVIEWDATA>");
        } else {
        	for(int i=0; i<resGetAdmSubClsTree.size(); i++) {
        		// approveflag = 2이면서 관리자 아니면 값 빼기
        		if(resGetAdmSubClsTree.get(i).getApproveFlag().equals("2")) {
        			if(userAdminFlag.equals("Y")) {
        				strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), false, langStr));
        			}
        		} else {
        			strTreeStyle.append(makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), false, langStr));
        		}
        	}
        	strTreeStyle.append("</NODES>");
        }
		return strTreeStyle.toString();
	}
	
	public String makeNodesFromADOFlds(String xmlStr, boolean blnFirstNode, String langStr) throws Exception{
		String returnXML = "";
        String strData2 = "";
        int intSubCnt = 0;
        String strIsLeaf = "";
        String strSetNodeIconByName = "";
        
        Document xmlRes = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        xmlRes = commonUtil.convertStringToDocument(xmlStr);
        String strData1 = xmlRes.getElementsByTagName("BRDID").item(0).getTextContent();
        
        if(langStr.equals("1")) {
        	strData2 = xmlRes.getElementsByTagName("BRDNM").item(0).getTextContent();
        } else {
        	strData2 = commonUtil.cleanValue(xmlRes.getElementsByTagName("BRDNM"+langStr).item(0).getTextContent());
        }
        String strData3 = xmlRes.getElementsByTagName("BRDLEVEL").item(0).getTextContent();
        String strData4 = xmlRes.getElementsByTagName("BRDSTEP").item(0).getTextContent();
        String strData5 = xmlRes.getElementsByTagName("BRDPOSTTERM").item(0).getTextContent();
        String strData6 = xmlRes.getElementsByTagName("BRDUPPER").item(0).getTextContent();
        String strData7 = xmlRes.getElementsByTagName("BRDGB").item(0).getTextContent();
        String strData8 = xmlRes.getElementsByTagName("BRDURL").item(0).getTextContent();
        String strData9 = xmlRes.getElementsByTagName("BRDEXPLAIN").item(0).getTextContent();
        String strData10 = xmlRes.getElementsByTagName("BRDACCESS").item(0).getTextContent();
        String strData11 = xmlRes.getElementsByTagName("ATTACHSIZE").item(0).getTextContent();
        String strData12 = xmlRes.getElementsByTagName("SUBCLSCNT").item(0).getTextContent();
        String strData13 = xmlRes.getElementsByTagName("SUBRESCNT").item(0).getTextContent();
        String strData14 = xmlRes.getElementsByTagName("ACCESSLVL").item(0).getTextContent();
        String strData15 = xmlRes.getElementsByTagName("APPROVEFLAG").item(0).getTextContent();
  
        intSubCnt = Integer.parseInt(strData12.trim()) + Integer.parseInt(strData13.trim());
        
        String strValue = strData2;
        String strStyle = "font-weight:normal;height:10px;";
        
        returnXML += "<NODE>";
        returnXML += makeXMLElement(strValue, "VALUE", false);
        returnXML += makeXMLElement(strStyle, "STYLE", false);
        returnXML += makeXMLElement(strData1, "DATA1", false);
        returnXML += makeXMLElement(strData2, "DATA2", false);
        returnXML += makeXMLElement(strData3, "DATA3", false);
        returnXML += makeXMLElement(strData4, "DATA4", false);
        returnXML += makeXMLElement(strData5, "DATA5", false);
        returnXML += makeXMLElement(strData6, "DATA6", false);
        returnXML += makeXMLElement(strData7, "DATA7", false);
        returnXML += makeXMLElement(strData8, "DATA8", false);
        returnXML += makeXMLElement(strData9, "DATA9", true);
        returnXML += makeXMLElement(strData10, "DATA10", false);
        returnXML += makeXMLElement(strData11, "DATA11", false);
        returnXML += makeXMLElement(strData12, "DATA12", false);
        returnXML += makeXMLElement(strData13, "DATA13", false);
        returnXML += makeXMLElement(strData14, "DATA14", false);
        returnXML += makeXMLElement(strData15, "DATA15", false);
        
        if(intSubCnt == 0) {
        	strIsLeaf = "TRUE";
        } else {
        	strIsLeaf = "FALSE";
        }
        
        if(strData7.equals("1")) {
        	strSetNodeIconByName = "RESCLASS";
        } else {
        	strSetNodeIconByName = "RESOURCE";
        }
        
        returnXML += makeXMLElement(strIsLeaf, "ISLEAF", false);
        returnXML += makeXMLElement(strSetNodeIconByName, "SETNODEICONBYNAME", false);
        returnXML += makeXMLElement("FALSE", "EXPANDED", false);
        
        if(blnFirstNode == true) {
        	returnXML += makeXMLElement("", "SELECT", true);
        }
        returnXML += "</NODE>";
		return returnXML;
	}
	
	public String makeXMLElement(String strElementText, String strElementName, boolean blnCData) {
		if(blnCData == true) {
			return "<"+strElementName+"><![CDATA["+strElementText+"]]></"+strElementName+">";
		} else {
			return "<"+strElementName+">"+strElementText+"</"+strElementName+">";
		}
	}
	
	@Override
	public boolean multiDelResData(String xmlStr, int tenantID, String realPath) throws Exception {
		String brdID = "";
		String companyID = "";
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		brdID = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		companyID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();

		for (int i=0; i<brdID.split(",").length; i++) {
			delResData(brdID.split(",")[i], companyID, tenantID);
			deleteAttachFiles(brdID.split(",")[i], realPath, companyID, tenantID);
		}
		return true;
	}
	
	public void deleteAttachFiles(String resID, String realPath, String companyID, int tenantID) {
		Map<String, Object> attachMap = new HashMap<String, Object>();
		attachMap.put("companyID", companyID);
		attachMap.put("tenantID", tenantID);
		attachMap.put("resID", resID);
		
		String pDirPath = realPath + commonUtil.getUploadPath("upload_resource.ROOT", tenantID);
		
		File file = new File(pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + resID + "_uploadFile");
		
		if(file.exists()) {
			File[] files = file.listFiles();
			
			for(File f: files){
				f.delete();
			}
			
			file.delete();
		}
		
		ezResourceDAO.delAttachFile(attachMap);
	}
	
	@Override
	public boolean modifyResData(String xmlStr, int tenantID) throws Exception {
		String strBrdID = "";
		String strODeptID = "";
		String strODeptNm = "";
		String strOwnerID = "";
		String strOwnerNm = "";
		String strOwnerPos = "";
	    String strOwnerCall = "";
	    String strBrdNm = "";
	    String strResLocation = "";
	    String strBrdExplain = "";
	    String strCompanyID = "";
	    String strApprove = "";
	    String strBrdNm2 = "";
	    String strODeptNm2 = "";
	    String strOwnerNm2 = "";
	    String strOwnerPos2 = "";
	    String realPath = "";
	    String strAttachList1 = "";
	    String strAttachList2 = "";
	    String strReturn = "";
		String strRepeat = "";
		
		// 2024-09-02 유길상 - 최대 예약 가능 기간, 정원
		String strResMaxDate = "";
		String strResMaxUserCnt = "";
	    
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		strBrdID = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		strODeptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
		strODeptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
		strOwnerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
		strOwnerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
		strOwnerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
		strOwnerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
		strBrdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
		strResLocation = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		strBrdExplain = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
		strCompanyID = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();
		strApprove = xmlRes.getElementsByTagName("DATA").item(11).getTextContent().trim();
		strBrdNm2 = xmlRes.getElementsByTagName("DATA").item(12).getTextContent().trim();
		strODeptNm2 = xmlRes.getElementsByTagName("DATA").item(17).getTextContent().trim();
		strOwnerNm2 = xmlRes.getElementsByTagName("DATA").item(18).getTextContent().trim();
		strOwnerPos2 = xmlRes.getElementsByTagName("DATA").item(19).getTextContent().trim();
			
		realPath = xmlRes.getElementsByTagName("DATA").item(20).getTextContent().trim();
		strAttachList1 = xmlRes.getElementsByTagName("DATA").item(13).getTextContent().trim();
		strAttachList2 = xmlRes.getElementsByTagName("DATA").item(14).getTextContent().trim();
		strReturn = xmlRes.getElementsByTagName("DATA").item(15).getTextContent().trim();
		strRepeat = xmlRes.getElementsByTagName("DATA").item(16).getTextContent().trim();
		
		// 2024-09-02 유길상 - 최대 예약 가능 기간, 정원
		strResMaxDate = xmlRes.getElementsByTagName("RESMAXDATE").item(0).getTextContent().trim();
		strResMaxUserCnt = xmlRes.getElementsByTagName("RESMAXUSERCNT").item(0).getTextContent().trim();
		
		modifyResData(strBrdID, strODeptID, strODeptNm, strOwnerID, strOwnerNm, strOwnerPos, strOwnerCall, strBrdNm, strResLocation, strBrdExplain, strCompanyID, strApprove, strBrdNm2, strODeptNm2, strOwnerNm2, strOwnerPos2, tenantID, realPath, strAttachList1, strAttachList2, strReturn, strRepeat, strResMaxDate, strResMaxUserCnt);

		return true;
	}
	
	@Override
	public boolean addResData(String xmlStr, int tenantID,Locale locale) throws Exception {
		String strClassGB = "";
		String strODeptID = "";
		String strODeptNm = "";
		String strOwnerID = "";
		String strOwnerNm = "";
		String strOwnerPos = "";
	    String strOwnerCall = "";
	    String strBrdNm = "";
	    String strResLocation = "";
	    String strBrdExplain = "";
	    String strCompanyID = "";
	    String strApprove = "";
	    String strBrdNm2 = "";
	    String strODeptNm2 = "";
	    String strOwnerNm2 = "";
	    String strOwnerPos2 = "";
	    String strBreAccess = "";
	    String realPath = "";
	    String strAttachList1 = "";
	    String strAttachList2 = "";
	    String strReturn = "";
		String strRepeat = "";
		
		// 2024-09-02 유길상 - 최대 예약 가능 기간, 정원
		String strResMaxDate = "";
		String strResMaxUserCnt = "";
	    
	   	Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		strClassGB = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		strODeptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
		strODeptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
		strOwnerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
		strOwnerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
		strOwnerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
		strOwnerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
		strBrdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
		strResLocation = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		strBrdExplain = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
		strCompanyID = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();
		strApprove = xmlRes.getElementsByTagName("DATA").item(11).getTextContent().trim();
		strBrdNm2 = xmlRes.getElementsByTagName("DATA").item(12).getTextContent().trim();
		strODeptNm2 = xmlRes.getElementsByTagName("DATA").item(17).getTextContent().trim();
		strOwnerNm2 = xmlRes.getElementsByTagName("DATA").item(18).getTextContent().trim();
		strOwnerPos2 = xmlRes.getElementsByTagName("DATA").item(19).getTextContent().trim();
		
		realPath = xmlRes.getElementsByTagName("DATA").item(20).getTextContent().trim();
		strAttachList1 = xmlRes.getElementsByTagName("DATA").item(13).getTextContent().trim();
		strAttachList2 = xmlRes.getElementsByTagName("DATA").item(14).getTextContent().trim();
		strReturn = xmlRes.getElementsByTagName("DATA").item(15).getTextContent().trim();
		strRepeat = xmlRes.getElementsByTagName("DATA").item(16).getTextContent().trim();
		strBreAccess = egovMessageSource.getMessage("ezResource.t58", locale);
		
		// 2024-09-02 유길상 - 최대 예약 가능 기간, 정원
		strResMaxDate = xmlRes.getElementsByTagName("RESMAXDATE").item(0).getTextContent().trim();
		strResMaxUserCnt = xmlRes.getElementsByTagName("RESMAXUSERCNT").item(0).getTextContent().trim();
		
		addResData(strClassGB, strODeptID, strODeptNm, strOwnerID, strOwnerNm, strOwnerPos, strOwnerCall, strBrdNm, strResLocation, strBrdExplain, strCompanyID, strApprove, strBrdNm2, strODeptNm2, strOwnerNm2, strOwnerPos2, strBreAccess, tenantID, realPath, strAttachList1, strAttachList2, strReturn, strRepeat, strResMaxDate, strResMaxUserCnt);

		return true;
	}
	
	@Override
	public String updateScheduleDateTime(String xmlStr, String companyID, int tenantID, String offset) throws Exception {
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		String num = xmlDom.getElementsByTagName("NUM").item(0).getTextContent();
		String ownerID = xmlDom.getElementsByTagName("OWNERID").item(0).getTextContent();
		String sDate = xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
		String eDate = xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();

		updateScheduleDateTime(Integer.parseInt(num), ownerID, companyID, commonUtil.getDateStringInUTC(sDate, offset, true), commonUtil.getDateStringInUTC(eDate, offset, true), tenantID);
		return xmlStr;
	}
	
	@Override
	public boolean saveRepetition(String companyID, String num, String ownerID, String xmlStr, String cmd, int tenantID, String offset, String lang) throws Exception {
		String interval = "";
		String daysOfWeek = "";
		String daysOfMonth = "";
		String byPosition = "";
		String monthsOfYear = "";
		String instances = "";
		String reWay = "";
		String reDay = "";
		String reNum = "";
		String reYoil = "";
		String reMonth = "";
		String reOrd = "";
		String endFlag = "";
		String reCount = "";
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String frequency = xmlRes.getElementsByTagName("frequency").item(0).getTextContent().trim();
		String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent();
		String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent();
		String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent();
		String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent();
		
		startDateTime = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");
		endDateTime = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");

		if (frequency.equals("4")) {
			interval = xmlRes.getElementsByTagName("interval").item(0).getTextContent();
			daysOfWeek = "";
			daysOfMonth = "";
			byPosition = "";
			monthsOfYear = "";
		} else if (frequency.equals("5")) {
			interval = xmlRes.getElementsByTagName("interval").item(0).getTextContent();
			daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent();
			daysOfMonth = "";
			byPosition = "";
			monthsOfYear = "";
		} else if (frequency.equals("6")) {
			if (selType.equals("0")) {
				interval = xmlRes.getElementsByTagName("interval").item(0).getTextContent();
				daysOfMonth = xmlRes.getElementsByTagName("daysOfMonth").item(0).getTextContent();
				daysOfWeek = "";
				byPosition = "";
			} else {
				interval = xmlRes.getElementsByTagName("interval").item(0).getTextContent(); 
				byPosition = xmlRes.getElementsByTagName("byPosition").item(0).getTextContent();
				daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent();
				daysOfMonth = "";
			}
			monthsOfYear = "";
		} else if (frequency.equals("7")) {
			if (selType.equals("0")) {
				monthsOfYear = xmlRes.getElementsByTagName("monthsOfYear").item(0).getTextContent();
				daysOfMonth = xmlRes.getElementsByTagName("daysOfMonth").item(0).getTextContent();
				daysOfWeek = "";
				byPosition = "";
			} else {
				monthsOfYear = xmlRes.getElementsByTagName("monthsOfYear").item(0).getTextContent();
				byPosition = xmlRes.getElementsByTagName("byPosition").item(0).getTextContent();
				daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent();
				daysOfMonth = "";
			}
			interval = "";
		}
		
		if (endRecurType.trim().equals("1")) {
			instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent();
		} else {
			instances = "";
		}
		reWay = frequency.trim() + selType.trim();
		reDay = daysOfMonth.trim();
		reNum = interval.trim();
		reYoil = daysOfWeek.trim();
		reMonth = monthsOfYear.trim();
		reOrd = byPosition.trim();
		endFlag = endRecurType.trim();
		reCount = instances.trim();
		
		String orgGresFlag = "";
		String orgEntryList = "";
		
		ResGetScheduleVO resGetSchedule = new ResGetScheduleVO();
		try {
			resGetSchedule = getSchedule(Integer.parseInt(num), ownerID, companyID, tenantID, lang);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		if (resGetSchedule != null) {
			orgGresFlag = resGetSchedule.getGresFlag();
			orgEntryList = resGetSchedule.getEntryList();
		} else {
			orgGresFlag = "0";
			orgEntryList = "";
		}
		
		String[] entry;
		int entryNum = 0;
		String[] entryArr;
		String[] entryEmail;
		String entryID = "";
//		String entryName = "";
		
		if (cmd.equals("add")) {
			if (!orgGresFlag.equals("0") && !orgEntryList.equals("")) {
				insertScheduleRepetition(Integer.parseInt(num), ownerID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
				
				entry = orgEntryList.split(">");
				entryNum = entry.length;
				
				for (int i=0; i<entryNum; i++) {
					entryArr = entry[i].split("<");
//					entryName = entryArr[0];
					entryEmail = entryArr[1].split("@");
					entryID = entryEmail[0];
					
					List<ResGetScheduleVO> resGetScheduleInfo = getScheduleInfo(Integer.parseInt(num), entryID, ownerID, companyID, tenantID);
					
					for (ResGetScheduleVO list : resGetScheduleInfo) {
						insertScheduleRepetition((list.getNum()), entryID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
					}
				}
			} else {
				insertScheduleRepetition(Integer.parseInt(num), ownerID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
			}
		} else if (cmd.equals("mod")) {
			if (!orgGresFlag.equals("0") && !orgEntryList.equals("")) {
				entry = orgEntryList.split(">");
				entryNum = entry.length;
				for (int i=0; i<entryNum; i++) {
					entryArr = entry[i].split("<");
					//entryName = entryArr[0];
					entryEmail = entryArr[1].split("@");
					entryID = entryEmail[0];
					
					List<ResGetScheduleVO> resGetScheduleInfo = getScheduleInfo(Integer.parseInt(num), entryID, ownerID, companyID, tenantID);
					
					for (ResGetScheduleVO list : resGetScheduleInfo) {
						 List<ResGetScheduleRepetitionVO> getScheduleRepetition =  getScheduleRepetition(list.getNum(), entryID, companyID, tenantID);
						 
						 if (getScheduleRepetition != null) {
							 for (ResGetScheduleRepetitionVO list1 : getScheduleRepetition) {
								 updateScheduleRepetition(list1.getNum(), entryID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
							 }
						 } else {
							 insertScheduleRepetition(list.getNum(), entryID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
						 }
					}
				}
			}
			updateScheduleRepetition(Integer.parseInt(num), ownerID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
		}
		
		return true;
	}
	
	@Override
	public boolean deleteRepetition(String xmlStr, String companyID, int tenantID) throws Exception {
		String num = "";
		String ownerID = "";
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		num = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(0).getTextContent().trim();
		ownerID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(1).getTextContent().trim();
		
		deleteRepetition(ownerID, Integer.parseInt(num), companyID, tenantID);
	
		return true;
	}
	
	@Override
	public String getRepetition(String xmlStr, int tenantID, String offset) throws Exception {
		String num = "";
		String ownerID = "";
		String companyID = "";
		StringBuilder resultXml = new StringBuilder();
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		num = xmlRes.getElementsByTagName("NUM").item(0).getTextContent().trim();
		ownerID = xmlRes.getElementsByTagName("OWNERID").item(0).getTextContent().trim();
		companyID = xmlRes.getElementsByTagName("companyID").item(0).getTextContent().trim();
		
		List<ResGetScheduleRepetitionVO> getScheduleRepetition = getScheduleRepetition(Integer.parseInt(num), ownerID, companyID, tenantID);
		
		String startDateTime = "";
		String endDateTime = "";
		String reWay = "";
		String reDay = "";
		String reNum = "";
		String reYoil = "";
		String reMonth = "";
		String reOrd = "";
		String endFlag = "";
		String reCount = "";
		String freq = "";
		String sel = "";
		
		for (ResGetScheduleRepetitionVO vo : getScheduleRepetition) {
			startDateTime = commonUtil.getDateStringInUTC(vo.getStartDateTime(), offset, false);
			endDateTime = commonUtil.getDateStringInUTC(vo.getEndDateTime(), offset, false);
			reWay = vo.getReWay();
			reDay = vo.getReDay();
			reNum = vo.getReNum();
			reYoil = vo.getReYoil();
			reMonth = vo.getReMonth();
			reOrd = vo.getReOrd();
			endFlag = vo.getEndFlag();
			reCount = vo.getReCount();
		}
		
		freq = reWay.substring(0, 1);
		sel = reWay.substring(1);
		
		resultXml.append("<recurrence>");
		resultXml.append("<frequency>" + freq + "</frequency>");
		resultXml.append("<selType>" + sel + "</selType>");
		resultXml.append("<endRecurType>" + endFlag + "</endRecurType>");
		resultXml.append("<startDateTime>" + startDateTime + "</startDateTime>");
		resultXml.append("<endDateTime>" + endDateTime + "</endDateTime>");
		
		if (freq.equals("4")) {
			if (sel.equals("0")) {
				resultXml.append("<interval>" + reNum + "</interval>");
			}
		} else if (freq.equals("5")) {
			resultXml.append("<interval>" + reNum + "</interval>");
			resultXml.append("<daysOfWeek>" + reYoil + "</daysOfWeek>");
		} else if (freq.equals("6")) {
			if (sel.equals("0")) {
				resultXml.append("<interval>" + reNum + "</interval>");
				resultXml.append("<daysOfMonth>" + reDay + "</daysOfMonth>");
			} else {
				resultXml.append("<interval>" + reNum + "</interval>");
				resultXml.append("<byPosition>" + reOrd + "</byPosition>");
				resultXml.append("<daysOfWeek>" + reYoil + "</daysOfWeek>");
			}
		} else if (freq.equals("7")) {
			if (sel.equals("0")) {
				resultXml.append("<monthsOfYear>" + reMonth + "</monthsOfYear>");
				resultXml.append("<daysOfMonth>" + reDay + "</daysOfMonth>");
			} else {
				resultXml.append("<monthsOfYear>" + reMonth + "</monthsOfYear>");
				resultXml.append("<byPosition>" + reOrd + "</byPosition>");
				resultXml.append("<daysOfWeek>" + reYoil + "</daysOfWeek>");
			}
		}
		if (endFlag.equals("1")) {
			resultXml.append("<instances>" + reCount + "</instances>");
		}
		resultXml.append("</recurrence>");
			
	
		return resultXml.toString();
	}
	
	@Override
	public String getACL(String pCompanyID, String pBrdID, String pUserID, String pMode, int tenantID, String pDeptID) throws Exception {
		String aclTblBrd = "";
		
		 aclTblBrd = getAclTblBrd(pCompanyID, pBrdID, pUserID, pMode, tenantID, pDeptID);
			
		return aclTblBrd;
	}
	
	@Override
	public boolean delResSch(String xmlStr, int tenantID, String offset) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		
		String ownerID = xmlRes.getElementsByTagName("OWNERID").item(0).getTextContent();
		String num = xmlRes.getElementsByTagName("NUM").item(0).getTextContent();
		String pNum = xmlRes.getElementsByTagName("PNUM").item(0).getTextContent();
		String companyID = xmlRes.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String writerID = xmlRes.getElementsByTagName("WRITERID").item(0).getTextContent();
		
		String sDate = EgovDateUtil.convertDate(xmlRes.getElementsByTagName("STARTDATE").item(0).getTextContent(), "yyyy-M-d", "yyyy-MM-dd", "");
		String eDate = EgovDateUtil.convertDate(xmlRes.getElementsByTagName("ENDDATE").item(0).getTextContent(), "yyyy-M-d", "yyyy-MM-dd", "");
		
		String insType = xmlRes.getElementsByTagName("INSTYPE").item(0).getTextContent();
			
		delResSch(ownerID, num, pNum, companyID, writerID, sDate, eDate, Integer.parseInt(insType), offset, tenantID);
		return true;
	}
	
	@Override
	public String modifyResSch(String xmlStr, int tenantID, String offset) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String attachFlag = "";
		
		NodeList nodeList = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes();
		
		String title = nodeList.item(0).getTextContent().trim();
		String location = nodeList.item(1).getTextContent().trim();
		String timeDisplay = nodeList.item(2).getTextContent().trim();
		String startDate = nodeList.item(3).getTextContent().trim();
		String endDate = nodeList.item(4).getTextContent().trim();
		String allDay = nodeList.item(5).getTextContent().trim();
		String alertTime = nodeList.item(6).getTextContent().trim();
		String content = nodeList.item(7).getTextContent().trim();
		String writerID = nodeList.item(8).getTextContent().trim();
		String importance = nodeList.item(9).getTextContent().trim();
		String entryList = nodeList.item(10).getTextContent().trim();
		String reFlag = nodeList.item(11).getTextContent().trim();
		String gresFlag = nodeList.item(12).getTextContent().trim();
		String num = nodeList.item(13).getTextContent().trim();
		String pNum = nodeList.item(14).getTextContent().trim();
		String ownerID = nodeList.item(15).getTextContent().trim();
		String attachFiles = nodeList.item(16).getTextContent().trim();
		String companyID = nodeList.item(17).getTextContent().trim();
		String characterID = nodeList.item(18).getTextContent().trim();
		String typeVal = nodeList.item(19).getTextContent().trim();
		String strApprove = xmlRes.getElementsByTagName("APPROVE").item(0).getTextContent().trim();
			
		if (attachFiles != null && !attachFiles.equals("")) {
			attachFlag = "1";
		} else {
			attachFlag = "0";
		}
			
		modifyResSch(ownerID, num, pNum, companyID, writerID, title, location, timeDisplay, startDate, endDate, allDay, alertTime, content, importance,
							reFlag, gresFlag, entryList, characterID, attachFlag, typeVal, strApprove, tenantID, offset);
		String returnStr = "";
		returnStr += "<RTN_DATA>";
        returnStr += "<NUM>" + num + "</NUM>";
        returnStr += "<OWNERID>" + ownerID + "</OWNERID>";
        returnStr += "</RTN_DATA>";

        return returnStr;
	}
	
	@Override
	public String addResSch(String xmlStr, int tenantID, String offset) throws Exception {
		logger.debug("addResSch Start");
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String attachFlag = "";
		String scheduleID = "";
		
		NodeList nodeList = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes();
		
		String title = nodeList.item(0).getTextContent().trim();
		String location = nodeList.item(1).getTextContent().trim();
		String timeDisplay = nodeList.item(2).getTextContent().trim();
		String startDate = nodeList.item(3).getTextContent().trim();
		String endDate = nodeList.item(4).getTextContent().trim();
		String allDay = nodeList.item(5).getTextContent().trim();
		String alertTime = nodeList.item(6).getTextContent().trim();
		String content = nodeList.item(7).getTextContent().trim();
		String writerID = nodeList.item(8).getTextContent().trim();
		String importance = nodeList.item(9).getTextContent().trim();
		String entryList = nodeList.item(10).getTextContent().trim();
		String reFlag = nodeList.item(11).getTextContent().trim();
		String gresFlag = nodeList.item(12).getTextContent().trim();
		String pNum = nodeList.item(14).getTextContent().trim();
		String ownerID = nodeList.item(15).getTextContent().trim();
		String attachFiles = nodeList.item(16).getTextContent().trim();
		String companyID = nodeList.item(17).getTextContent().trim();
		String characterID = nodeList.item(18).getTextContent().trim();
		String deptNm = nodeList.item(20).getTextContent().trim();
		String ownerNm = nodeList.item(21).getTextContent().trim();
		String strApprove = nodeList.item(22).getTextContent().trim();
			
		if (nodeList.getLength() > 23) {
			scheduleID = nodeList.item(23).getTextContent().trim();
		}

		Node nodeDept = xmlRes.getElementsByTagName("DEPTID").item(0);
		String deptId = nodeDept != null ? nodeDept.getTextContent() : "";
		
		if (attachFiles != null && !attachFiles.equals("")) {
			attachFlag = "1";
		} else {
			attachFlag = "0";
		}
		
		timeDisplay = "1";
		int num = addResSch(ownerID, pNum, companyID, writerID, title, location, timeDisplay, startDate, endDate, allDay, alertTime, content, importance, reFlag, gresFlag, 
				entryList, characterID, attachFlag, deptNm, ownerNm, strApprove, scheduleID, tenantID, offset,  deptId);
		String returnStr = "";
		returnStr += "<RTN_DATA>";
        returnStr += "<NUM>" + num + "</NUM>";
        returnStr += "<OWNERID>" + writerID + "</OWNERID>";
        returnStr += "</RTN_DATA>";
        
        logger.debug("returnStr=" + returnStr);
        logger.debug("addResSch End");
        return returnStr;
	}
	//2018-09-02 dateList 날짜 정렬을 위해 함수 정의
//	private static void selectionSortMin(List<Date> startDates, int length) {
//	    int min;
//	    Date tmp;
//	    for (int i = 0; i < length - 1; i++) {
//	      min = i;
//	      for (int j = i + 1; j < length; j++) {
//	        if (startDates.get(j).compareTo(startDates.get(min)) < 0 )
//	          min = j;
//	      }
//	      tmp = startDates.get(i);
//	      startDates.set(i, (startDates.get(min)));
//	      startDates.set(min, tmp);
//	    }
//	 }
//	
//	 private static void selectionSortMax(List<Date> endDates, int length) {
//	    int max;
//	    Date tmp;
//	    for (int i = length - 1; i > 0; i--) {
//	      max = i;
//	      for (int j = i -1; j >= 0; j--) {
//	        if (endDates.get(j).compareTo(endDates.get(max)) > 0 )
//	          max = j;
//	      }
//	      tmp = endDates.get(i);
//	      endDates.set(i, (endDates.get(max)));
//	      endDates.set(max, tmp);
//	    }
//	 }
//	
	//반복예약일때
	@Override
	public boolean getRepResource(String strFrequency, String strSelType, String strEndRecurType, String strStartDateTime, String strEndDateTime, String strInterval,
		String strDaysOfWeek, String strInstances, String strByPosition, String strDaysOfMonth, String strMonthsOfYear, String strPownerID, String strPnum, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception {
		logger.debug("getRepResource Start");
		logger.debug("===반복예약일때===");
		
		strStartDateTime = EgovDateUtil.convertDate(strStartDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");
		strEndDateTime = EgovDateUtil.convertDate(strEndDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");
		
		String pOwnerID = strPownerID.equals("") ? null : strPownerID;
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//		SimpleDateFormat dsdf = new SimpleDateFormat("yyyy-MM-dd");

		ResScheduleRepetitionVO vo = resStruct(strFrequency, strSelType, strEndRecurType, strStartDateTime, strEndDateTime, strInterval, strDaysOfWeek, strInstances, strByPosition, strDaysOfMonth, strMonthsOfYear);
		
		//TODO: sDate,eDate setting
		List<Date[]> dateList = getRepDateTimes(vo, "2000-01-01", "2999-12-31", offset);
//		logger.debug("strStartDateTime.substring(0,10) : " + strStartDateTime.substring(0,10));
//		logger.debug("strEndDateTime.substring(0,10) : " + strEndDateTime.substring(0,10));
//		List<Date[]> dateList = getRepDateTimes(vo, strStartDateTime.substring(0,10), strEndDateTime.substring(0,10), offset);
		
		boolean isDup = false;
		
		//자원의 일반예약 스케줄을 가져옴 TODO: sDate,eDate 수정해야함. -> dateList 정렬후 처음과 끝
		List<ResDateVO> scheduleDateList = getScheduleDateList(pOwnerID, strPnum, companyID, "2999-12-31 23:59:59", "2000-01-01 00:00:00", offset, tenantID);
		logger.debug("scheduleDateList.size=" + scheduleDateList.size());
		
		List<Date[]> dateList2 = new ArrayList<Date[]>();
		String tmpEndDateTime2 = "";
		for (ResDateVO dateVO : scheduleDateList) {
			
			//2018-09-02 구해안 기간이 상이할때 각 사이에 있는 날짜를 하나씩 다 꺼내와서 비교하기 위해 사이에 있는 예약을 다 가져옴
			Date getD1 = format.parse( commonUtil.getDateStringInUTC(dateVO.getStartDate(), offset, false) );
			Date getD2 = format.parse( commonUtil.getDateStringInUTC(dateVO.getEndDate(), offset, false) );
			tmpEndDateTime2 = format.format(getD1.getTime()).substring(0, 10) + format.format(getD2.getTime()).substring(10);
//			tmpEndDateTime2 = dateVO.getStartDate().substring(0, 10) + dateVO.getEndDate().substring(10);
			
//			Date getDe1 = format.parse( commonUtil.getDateStringInUTC(tmpEndDateTime2, offset, false) );
			Date getDe1 = format.parse(tmpEndDateTime2);
			logger.debug("tmpEndDateTime2 : " + tmpEndDateTime2);

			Calendar getC1 = Calendar.getInstance();
			Calendar getC2 = Calendar.getInstance();
			Calendar getCe1 = Calendar.getInstance();
			
			//Calendar 타입으로 변경 add()메소드로 1일씩 추가해 주기위해 변경
			getC1.setTime( getD1 );
			getC2.setTime( getD2 );
			getCe1.setTime( getDe1 );

			//시작날짜와 끝 날짜를 비교해, 시작날짜가 작거나 같은 경우 출력
			while( getC1.compareTo( getC2 ) !=1 ){

			//담기
			dateList2.add(new Date[] {
					getD1,
					getDe1
			});

			//시작날짜 + 1 일
			getC1.add(Calendar.DATE, 1);
			getD1 = getC1.getTime();
			getCe1.add(Calendar.DATE, 1);
			getDe1 = getCe1.getTime();
			}
		}
		logger.debug("dateList2.size() : " + dateList2.size());
		//end
		
		if (dateList2.size() != 0) {
			isDup = chkTableRepeat(dateList, dateList2, null, offset);
			
			if (isDup) {
				logger.debug("getRepResource End. isDup=" + isDup);
				return isDup;
			}
		}
		
//		List<Date> startDates = new ArrayList<Date>();
//		List<Date> endDates = new ArrayList<Date>();
//		for (Date[] dates : dateList) {
//			startDates.add(dates[0]);
//			endDates.add(dates[1]);
//		}
//		Date minStartDate = Collections.min(startDates);
//		Date maxEndDate = Collections.max(endDates);
//		
//		logger.debug("minStartDate : " + minStartDate);
//		logger.debug("maxEndDate : " + maxEndDate);
		
		List<ResGetScheduleRepetitionVO> repScheduledList = getRepResourceRepeat(pOwnerID, strPnum, companyID, tenantID);
		logger.debug("repScheduledList.size=" + repScheduledList.size());
		
		for (ResGetScheduleRepetitionVO schedule : repScheduledList) {
			schedule.setStartDateTime(commonUtil.getDateStringInUTC(schedule.getStartDateTime(), offset, false));
			schedule.setEndDateTime(commonUtil.getDateStringInUTC(schedule.getEndDateTime(), offset, false));
			
			ResScheduleRepetitionVO vo2 = resStruct(schedule);

			//TODO: sDate,eDate 수정해야함. -> dateList 정렬후 처음과 끝
			dateList2 = getRepDateTimes(vo2, "2000-01-01", "2999-12-31", offset);
			//dateList2 = getRepDateTimes(vo2, dsdf.format(minStartDate), dsdf.format(maxEndDate), offset);
			
			// 반복예약 중에 삭제된 예약 가져옴
			List<String> deletedDateStrList = getDeletedRepScheduleDate(schedule.getNum(), companyID, pOwnerID, tenantID);
			logger.debug("deletedDateStrList.size=" + deletedDateStrList.size());
			
//			for (String date : deletedDateStrList) {
//				date = commonUtil.getDateStringInUTC(date, offset, false);
//			}
			
			List<String> deletedDateStrListConvertedInUTC  = new ArrayList<String>();
			for (String date : deletedDateStrList) {
				date = commonUtil.getDateStringInUTC(date, offset, false).substring(0,10);
				deletedDateStrListConvertedInUTC.add(date);
			}
			
			if (dateList2.size() == 0) {
				continue;
			}

			isDup = chkTableRepeat(dateList, dateList2, deletedDateStrListConvertedInUTC, offset);
			
			if (isDup) {
				break;
			}
		}

		logger.debug("getRepResource End. isDup=" + isDup);
		return isDup;
	}
	
	//일반예약일때
	@Override
	public boolean getRepResource(String strStartDateTime, String strEndDateTime, String strPownerID, String strPnum, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception {
		logger.debug("getRepResource started");
		logger.debug("===예약자원이 일반예약일때===");
		
		strStartDateTime = EgovDateUtil.convertDate(strStartDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");
		strEndDateTime = EgovDateUtil.convertDate(strEndDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");

		String pOwnerID = strPownerID.equals("") ? null : strPownerID;
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		List<Date[]> dateList = new ArrayList<Date[]>();
		dateList.add(new Date[] {
				format.parse(strStartDateTime),
				format.parse(strEndDateTime)
		});
		
		boolean isDup = false;
		
		//자원의 일반예약 스케줄을 가져옴 TODO: sDate,eDate 수정해야함. -> dateList 정렬후 처음과 끝
		List<ResDateVO> scheduleDateList = getScheduleDateList(pOwnerID, strPnum, companyID, strEndDateTime, strStartDateTime, offset, tenantID);
		List<Date[]> dateList2 = new ArrayList<Date[]>();
		for (ResDateVO dateVO : scheduleDateList) {
			dateList2.add(new Date[] {
					format.parse(commonUtil.getDateStringInUTC(dateVO.getStartDate(), offset, false)),
					format.parse(commonUtil.getDateStringInUTC(dateVO.getEndDate(), offset, false))
			});
		}
		
		if (dateList2.size() != 0) {
			isDup = chkTableRepeat(dateList, dateList2, null, offset);
			
			if (isDup) {
				logger.debug("getRepResource End. isDup=" + isDup);
				return isDup;
			}
		}
		
		List<ResGetScheduleRepetitionVO> repScheduledList = getRepResourceRepeat(pOwnerID, strPnum, companyID, tenantID);
		
		for (ResGetScheduleRepetitionVO schedule : repScheduledList) {
			schedule.setStartDateTime(commonUtil.getDateStringInUTC(schedule.getStartDateTime(), offset, false));
			schedule.setEndDateTime(commonUtil.getDateStringInUTC(schedule.getEndDateTime(), offset, false));
			
			
			ResScheduleRepetitionVO vo2 = resStruct(schedule);
			
			dateList2 = getchkRepDateTimes(vo2, strStartDateTime, strEndDateTime, offset);
			logger.debug("반복예약의 dateList2.size() : " + dateList2.size());
			
			// 반복예약 중에 삭제된 예약 가져옴
			List<String> deletedDateStrList = getDeletedRepScheduleDate(schedule.getNum(), companyID, pOwnerID, tenantID);
			logger.debug("deletedDateStrList.size=" + deletedDateStrList.size());
			
			List<String> deletedDateStrListConvertedInUTC  = new ArrayList<String>();
			for (String date : deletedDateStrList) {
				date = commonUtil.getDateStringInUTC(date, offset, false).substring(0,10);
				deletedDateStrListConvertedInUTC.add(date);
			}
			
			if (dateList2.size() == 0) {
				continue;
			}

			isDup = chkTableRepeat(dateList, dateList2, deletedDateStrListConvertedInUTC, offset);
			if (isDup) {
				logger.debug("===예약된 자원이 반복예약일때===");
				break;
			}
		}

		logger.debug("getRepResource End. isDup=" + isDup);
		return isDup;
	}
	
	public boolean chkTableRepeat(List<Date[]> dateList, List<Date[]> dateList2, List<String> deletedList, String offset) throws Exception {
		logger.debug("============ chkTableRepeat started ============");
		
		logger.debug("dateList.size = " + dateList.size());
		logger.debug("dateList2.size = " + dateList2.size());
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
		if (deletedList == null || deletedList.size() == 0) {
			for (Date[] dateVO : dateList) {
				for (Date[] dateVO2 : dateList2) {
					
					logger.debug("dateVO[0] : " + format.format(dateVO[0]) + " before? dateVO2[1] : " + format.format(dateVO2[1]));
					logger.debug("dateVO[1] : " + format.format(dateVO[1]) + " after? dateVO2[0] : " + format.format(dateVO2[0]));
					
					if (!(!dateVO[0].before(dateVO2[1]) || !dateVO[1].after(dateVO2[0]))) {
						logger.debug("첫번째 조건 : " + (dateVO[0].before(dateVO2[1])));
						logger.debug("두번째 조건 : " + (dateVO[1].after(dateVO2[0])));
						return true;
					}
				}
			}
		} else {
			for (Date[] dateVO : dateList) {
				for (Date[] dateVO2 : dateList2) {
					
					logger.debug("dateVO[0] : " + format.format(dateVO[0]) + " before? dateVO2[1] : " + format.format(dateVO2[1]));
					logger.debug("dateVO[1] : " + format.format(dateVO[1]) + " after? dateVO2[0] : " + format.format(dateVO2[0]));
					
					if (!(!dateVO[0].before(dateVO2[1]) || !dateVO[1].after(dateVO2[0]))) {
						// 삭제된 예약이면 넘어감
						/*if (deletedList.contains(format2.format(dateVO[0]))) {		// 날짜만 비교하도록 수정
							continue;
						}*/
						if (!deletedList.contains(format2.format(dateVO2[0]))) {
							
							logger.debug("첫번째 조건 : " + (dateVO[0].before(dateVO2[1])));
							logger.debug("두번째 조건 : " + (dateVO[1].after(dateVO2[0])));
							return true;
						}
					}
				}
			}
		}

		logger.debug("chkTableRepeat ended");
		return false;
	}
	
	public ResScheduleRepetitionVO resStruct(String strFrequency, String strSelType, String strEndRecurType, String strStartDateTime, String strEndDateTime, 
			String strInterval, String strDaysOfWeek, String strInstances, String strByPosition, String strDaysOfMonth, String strMonthsOfYear) throws Exception {
		logger.debug("resStruct started");

		ResScheduleRepetitionVO result = new ResScheduleRepetitionVO();
		
		if (strFrequency != null && !strFrequency.trim().equals("")) {
			result.setFreq(Integer.parseInt(strFrequency));
		}
		
		if (strSelType != null && !strSelType.trim().equals("")) {
			result.setSelType(Integer.parseInt(strSelType));
		} else {
			result.setSelType(-1);
		}
		
		if (strInterval != null && !strInterval.trim().equals("")) {
			result.setInterval(Integer.parseInt(strInterval));
		}
		
		if (strEndRecurType != null && !strEndRecurType.trim().equals("")) {
			result.setEndRecurType(Integer.parseInt(strEndRecurType));
		} else {
			result.setEndRecurType(-1);
		}
		
		if (strInstances != null && !strInstances.trim().equals("")) {
			result.setInstances(Integer.parseInt(strInstances));
		}
		
		if (strDaysOfWeek != null && !strDaysOfWeek.trim().equals("")) {
			List<Integer> yoilList = new ArrayList<Integer>();
			String[] yoilArr = strDaysOfWeek.split(",");
			
			for (String yoil : yoilArr) {
				yoilList.add(Integer.parseInt(yoil.trim())); 
			}
			
			result.setDaysOfWeek(yoilList);
		}
		
		if (strDaysOfMonth != null && !strDaysOfMonth.trim().equals("")) {
			result.setDaysOfMonth(Integer.parseInt(strDaysOfMonth));
		}
		
		if (strMonthsOfYear != null && !strMonthsOfYear.trim().equals("")) {
			result.setMonthsOfYear(Integer.parseInt(strMonthsOfYear));
		}
		
		if (strByPosition != null && !strByPosition.trim().equals("")) {
			result.setByPosition(Integer.parseInt(strByPosition));
		}
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if (strStartDateTime != null && !strStartDateTime.trim().equals("")) {
			result.setStartDate(format.parse(strStartDateTime));
		}
		
		if (strEndDateTime != null && !strEndDateTime.trim().equals("")) {
			result.setEndDate(format.parse(strEndDateTime));
		}
		
		logger.debug("resStruct ended");
		return result;
	}
	
	public ResScheduleRepetitionVO resStruct(ResGetScheduleRepetitionVO vo) throws Exception {
		logger.debug("resStruct started");

		ResScheduleRepetitionVO result = new ResScheduleRepetitionVO();
		
		if (vo.getReWay() != null && vo.getReWay().length() == 2) {
			result.setFreq(Integer.parseInt(vo.getReWay().substring(0, 1)));
			result.setSelType(Integer.parseInt(vo.getReWay().substring(1)));
		} else {
			result.setSelType(-1);
		}
		
		if (vo.getReNum() != null && !vo.getReNum().trim().equals("")) {
			result.setInterval(Integer.parseInt(vo.getReNum().trim()));
		}
		
		if (vo.getEndFlag() != null && !vo.getEndFlag().trim().equals("")) {
			result.setEndRecurType(Integer.parseInt(vo.getEndFlag().trim()));
		} else {
			result.setEndRecurType(-1);
		}
		
		if (vo.getReCount() != null && !vo.getReCount().trim().equals("")) {
			result.setInstances(Integer.parseInt(vo.getReCount().trim()));
		}
		
		if (vo.getReYoil() != null && !vo.getReYoil().trim().equals("")) {
			List<Integer> yoilList = new ArrayList<Integer>();
			String[] yoilArr = vo.getReYoil().split(",");
			
			for (String yoil : yoilArr) {
				yoilList.add(Integer.parseInt(yoil.trim())); 
			}
			
			result.setDaysOfWeek(yoilList);
		}
		
		if (vo.getReDay() != null && !vo.getReDay().trim().equals("")) {
			result.setDaysOfMonth(Integer.parseInt(vo.getReDay().trim()));
		}
		
		if (vo.getReMonth() != null && !vo.getReMonth().trim().equals("")) {
			result.setMonthsOfYear(Integer.parseInt(vo.getReMonth().trim()));
		}
		
		if (vo.getReOrd() != null && !vo.getReOrd().trim().equals("")) {
			result.setByPosition(Integer.parseInt(vo.getReOrd().trim()));
		}
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if (vo.getStartDateTime() != null && !vo.getStartDateTime().trim().equals("")) {
			result.setStartDate(format.parse(vo.getStartDateTime()));
		}
		
		if (vo.getEndDateTime() != null && !vo.getEndDateTime().trim().equals("")) {
			result.setEndDate(format.parse(vo.getEndDateTime().trim()));
		}
		
		if (vo.getAllDay() != null && vo.getAllDay().equals("1")) {
			result.setAllDay(true);
		}
		
		logger.debug("resStruct ended");
		return result;
	}
	
	// 2018-07-06 김민성 - 사간겸직 시 deptID값 조회
	public String getDeptID(String writerID, String deptNm, int tenantID, String companyID) throws Exception {
		logger.debug("getDeptID ended");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("writerID", writerID);
		map.put("deptNm", deptNm);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		logger.debug("getDeptID ended");
		return ezResourceDAO.getDeptID(map);
	}
	
	public List<Date[]> getchkRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, String offset) throws Exception {
		logger.debug("getchkRepDateTimes started");
		
		int maxTemp = 100;
		
		List<Date[]> returnList = new ArrayList<Date[]>();
			
		int freq = vo.getFreq();
		
		if (sDate.length() == 10) {
			sDate += " 00:00:00";
		}
		if (eDate.length() == 10) {
			eDate += " 23:59:59";
		}
		
		if (freq == 4) {
			returnList = getchkDailyRepDateTimes(vo, sDate, eDate, maxTemp); 
		} else if (freq == 5) {
			returnList = getchkWeeklyRepDateTime(vo, sDate, eDate, maxTemp);
		} else if (freq == 6 || freq == 7) {
			returnList = getchkMonthlyRepDateTimes(vo, sDate, eDate, maxTemp);
		}
		
		logger.debug("returnList.size()=" + returnList.size());
		logger.debug("getRepDeteTimes ended");
		
		return returnList;
	}
	
	public List<Date[]> getchkDailyRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception {
		logger.debug("getchkDailyRepDateTimes started");
		int selType = vo.getSelType();
		int interval = vo.getInterval();
		int endRecurType = vo.getEndRecurType();
		int instances = vo.getInstances();
		int tempYoil = 0;
		
		// 자원예약 기간
		Date resEndDate = vo.getEndDate();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat osdf = new SimpleDateFormat("yyyy-MM-dd");
		
		// 요청 기간
		Date startDate = sdf.parse(sDate);
		Date endDate = sdf.parse(eDate);
		
		String tmpStartDateStr = sdf.format(vo.getStartDate());
		String tmpEndDateStr = tmpStartDateStr.substring(0, 10) + sdf.format(vo.getEndDate()).substring(10);
		
		Date tmpStartDate = vo.getStartDate();
		Date tmpEndDate = sdf.parse(tmpEndDateStr);
		
		Calendar tempStartCal = Calendar.getInstance();
		tempStartCal.setTime(tmpStartDate);
		
		Calendar tempEndCal = Calendar.getInstance();
		tempEndCal.setTime(tmpEndDate);
		
		Calendar oEndCal = Calendar.getInstance();
		oEndCal.setTime(resEndDate);
		
		// timezone으로 인해 tmpStartDate가 tmpEndDate보다 늦은 경우 tmpEndDate를 하루 늘려준다.
		if (tmpStartDate.after(tmpEndDate)) {
			tempEndCal.add(Calendar.DATE, 1);
			tmpEndDate = tempEndCal.getTime();
		}
		
		long diff = tmpEndDate.getTime() - tmpStartDate.getTime();
		
	/*	logger.debug("sDate=" + sDate);
		logger.debug("eDate=" + eDate);
		logger.debug("selType=" + selType);
		logger.debug("interval=" + interval);
		logger.debug("endRecurType=" + endRecurType);
		logger.debug("instances=" + instances);
		logger.debug("startDate=" + sdf.format(startDate));
		logger.debug("endDate=" + sdf.format(endDate));
		logger.debug("resStartDate=" + sdf.format(resStartDate));
		logger.debug("resEndDate=" + sdf.format(resEndDate));
		logger.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		logger.debug("tmpEndDate=" + sdf.format(tmpEndDate));*/
		
		List<Date[]> returnList = new ArrayList<>();
		
		int temp = maxTemp; // 최대 maxTemp번 반복
		
		String oSDate;
		String oStartDate;
		String oEndDate;
		String tEDate;
		
		Date resEndDate1 = resEndDate;
		
		while (true) {
			oSDate = osdf.format(tmpStartDate);
			oStartDate = osdf.format(startDate);
			oEndDate = osdf.format(endDate);
			tEDate = osdf.format(tmpEndDate);
			
			logger.debug("oSDate : " + oSDate + " == oStartDate : " + oStartDate);
			logger.debug("tEDate : " + tEDate + " == oEndDate : " + oEndDate);
			// 40일 때(매 n일)
			if (selType == 0) {
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tmpStartDate.after(endDate)) {
						break;
					} else if (oSDate.compareTo(oStartDate) >= 0 && tEDate.compareTo(oEndDate) <= 0) {
//						tempEndCal.setTime(tmpStartDate);
//						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tmpStartDate.after(endDate) || tmpStartDate.after(resEndDate1)) {
						break;
					} else if (oSDate.compareTo(oStartDate) >= 0 && tEDate.compareTo(oEndDate) <= 0) {
//						tempEndCal.setTime(tmpStartDate);
//						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tmpStartDate.after(endDate) || instances <= 0) {
						break;
					} else {
						if (oSDate.compareTo(oStartDate) >= 0 && tEDate.compareTo(oEndDate) <= 0) {
//							tempEndCal.setTime(tmpStartDate);
//							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tmpStartDate, 
									tempEndCal.getTime()
							});
						}
						
						instances--;
					}
				}
			}
			// 41일 때(평일 매일)
			else {
				tempYoil = tempStartCal.get(Calendar.DAY_OF_WEEK);
				
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tmpStartDate.after(endDate)) {
						break;
					} else if (oSDate.compareTo(oStartDate) >= 0 && tEDate.compareTo(oEndDate) <= 0 && tempYoil > 1 && tempYoil < 7) {
//						tempEndCal.setTime(tmpStartDate);
//						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tmpStartDate.after(endDate) || tmpStartDate.after(resEndDate1)) {
						break;
					} else if (oSDate.compareTo(oStartDate) >= 0 && tEDate.compareTo(oEndDate) <= 0 && tempYoil > 1 && tempYoil < 7) {
//						tempEndCal.setTime(tmpStartDate);
//						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
//						tmpEndDate = tempEndCal.getTime();
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
					
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tmpStartDate.after(endDate) || instances <= 0) {
						break;
					} else if (tempYoil > 1 && tempYoil < 7) {
						if (oSDate.compareTo(oStartDate) >= 0 && tEDate.compareTo(oEndDate) <= 0) {
//							tempEndCal.setTime(tmpStartDate);
//							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tmpStartDate, 
									tempEndCal.getTime()
							});
						}
						
						instances--;
					}
				}
			}
			
			tempStartCal.add(Calendar.DATE, interval);
			tmpStartDate = tempStartCal.getTime();
			
			tempEndCal.setTime(tmpStartDate);
			tempEndCal.add(Calendar.MILLISECOND, (int)diff);
			tmpEndDate = tempEndCal.getTime();
			
			oEndCal.add(Calendar.DATE, interval);
			resEndDate = oEndCal.getTime();
			
			temp--;
			
			if (temp < 0) {
				logger.debug("Repeat time over 1000.");
				break;
			}
		}
		logger.debug("getchkDailyRepDateTimes started");
		return returnList;
	}
	
	public List<Date[]> getchkWeeklyRepDateTime (ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception  {
		logger.debug("getchkWeeklyRepDateTime started");
		int interval = vo.getInterval();
		int endRecurType = vo.getEndRecurType();
		int instances = vo.getInstances();
		List<Integer> wDay = vo.getDaysOfWeek();
		
		if (wDay != null && wDay.size() > 0) {
			instances = instances * wDay.size();
		}
		
		// 자원예약 기간
		Date resStartDate = vo.getStartDate();
		Date resEndDate = vo.getEndDate();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat osdf = new SimpleDateFormat("yyyy-MM-dd");
		
		// 요청 기간
		Date startDate = sdf.parse(sDate);
		Date endDate = sdf.parse(eDate);

		String tmpStartDateStr = sdf.format(vo.getStartDate());
		String tmpEndDateStr = tmpStartDateStr.substring(0, 10) + sdf.format(vo.getEndDate()).substring(10);
				
		Date tmpStartDate = vo.getStartDate();
		Date tmpEndDate = sdf.parse(tmpEndDateStr);
		
		
		Calendar tempStartCal = Calendar.getInstance();
		tempStartCal.setTime(tmpStartDate);
		
		Calendar tempEndCal = Calendar.getInstance();
		tempEndCal.setTime(tmpEndDate);
		
		Calendar oEndCal = Calendar.getInstance();
		oEndCal.setTime(resEndDate);
		
		// timezone으로 인해 tmpStartDate가 tmpEndDate보다 늦은 경우 tmpEndDate를 하루 늘려준다.
		if (tmpStartDate.after(tmpEndDate)) {
			tempEndCal.add(Calendar.DATE, 1);
			tmpEndDate = tempEndCal.getTime();
		}
		
		long diff = tmpEndDate.getTime() - tmpStartDate.getTime();
		
		
		
//		logger.debug("=====주간반복 스타트=====");
//		logger.debug("sDate=" + sDate);
//		logger.debug("eDate=" + eDate);
//		logger.debug("interval=" + interval);
//		logger.debug("endRecurType=" + endRecurType);
//		logger.debug("instances=" + instances);
//		logger.debug("startDate=" + sdf.format(startDate));
//		logger.debug("endDate=" + sdf.format(endDate));
//		logger.debug("resStartDate=" + sdf.format(resStartDate));
//		logger.debug("resEndDate=" + sdf.format(resEndDate));
//		logger.debug("tmpStartDate=" + sdf.format(tmpStartDate));
//		logger.debug("tmpEndDate=" + sdf.format(tmpEndDate));
//		logger.debug("=====주간반복 끝=====");
		
		List<Date[]> returnList = new ArrayList<Date[]>();
		
		int temp = maxTemp; // 최대 maxTemp번 반복
		
		boolean loopFlag = true;
		String oSDate;
		String oStartDate;
		@SuppressWarnings("unused")
		String oEDate;
		String oEndDate;
		String tEDate;
		Date resEndDate1 = resEndDate;
		
		while (loopFlag) {
			for (int i=0; i<wDay.size(); i++) {
				tempStartCal.set(Calendar.DAY_OF_WEEK, wDay.get(i) + 1);
				tmpStartDate = tempStartCal.getTime();
				oEndCal.set(Calendar.DAY_OF_WEEK, wDay.get(i) + 1);
				
				resEndDate = oEndCal.getTime();
				
				tempEndCal.setTime(tmpStartDate);
				tempEndCal.add(Calendar.MILLISECOND, (int)diff);
				tmpEndDate = tempEndCal.getTime();
				
				oSDate = osdf.format(tmpStartDate);
				oStartDate = osdf.format(startDate);
				oEDate = osdf.format(resEndDate);
				oEndDate = osdf.format(endDate);
				tEDate = osdf.format(tmpEndDate);
				
				logger.debug("oSDate : " + oSDate + " == oStartDate : " + oStartDate);
				logger.debug("tEDate : " + tEDate + " == oEndDate : " + oEndDate);
				
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tmpStartDate.after(endDate)) {
						loopFlag = false;
						break;
					} else if (oSDate.compareTo(oStartDate) >= 0 && tEDate.compareTo(oEndDate) <= 0) {
//						tempEndCal.setTime(tmpStartDate);
//						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tmpStartDate.after(endDate) || tmpStartDate.after(resEndDate1)) {
						loopFlag = false;
						break;
					} else if (!tmpStartDate.before(resStartDate)) {
						if (oSDate.compareTo(oStartDate) >= 0 && tEDate.compareTo(oEndDate) <= 0) {
//						tempEndCal.setTime(tmpStartDate);
//						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
						}
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tmpStartDate.after(endDate) || instances <= 0) {
						loopFlag = false;
						break;
					} else if (!tmpStartDate.before(resStartDate)) {
						instances--;
						if(oSDate.compareTo(oStartDate) >= 0 && tEDate.compareTo(oEndDate) <= 0){
//							tempEndCal.setTime(tmpStartDate);
//							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tmpStartDate, 
									tempEndCal.getTime()
							});
						}
					}
				}
				
			}
			
			tempStartCal.add(Calendar.DATE, interval * 7);
			oEndCal.add(Calendar.DATE, interval * 7);
			
			temp--;
			
			if (temp < 0) {
				logger.debug("Repeat time over 1000.");
				break;
			}
			
		}
		logger.debug("getchkWeeklyRepDateTime ended");
		return returnList;
	}
	
	// 월간 반복예약된 일자을 리턴하는 메서드
	public List<Date[]> getchkMonthlyRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception {
		logger.debug("getMonthlyRepDateTimes started.");
		int freq = vo.getFreq();
		int selType = vo.getSelType();
		int interval = vo.getInterval();
		int daysOfMonth = vo.getDaysOfMonth();
		int monthsOfYear = vo.getMonthsOfYear();
		int byPosition = vo.getByPosition();
		int endRecurType = vo.getEndRecurType();
		int instances = vo.getInstances();
		List<Integer> wDay = vo.getDaysOfWeek();
		
		if (wDay != null && !wDay.isEmpty()) {
			instances = instances * wDay.size();
		}
		
		// 자원예약 기간
		Date resStartDate = vo.getStartDate();
		Date resEndDate = vo.getEndDate();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat osdf = new SimpleDateFormat("yyyy-MM-dd");
		
		// 요청 기간
		Date startDate = sdf.parse(sDate);
		Date endDate = sdf.parse(eDate);
		
		String tmpStartDateStr = sdf.format(vo.getStartDate());
		String tmpEndDateStr = tmpStartDateStr.substring(0, 10) + sdf.format(vo.getEndDate()).substring(10);
		
		Date tmpStartDate = vo.getStartDate();
		Date tmpEndDate = sdf.parse(tmpEndDateStr);
		
		Calendar tempStartCal = Calendar.getInstance();
		tempStartCal.setTime(tmpStartDate);
		
		Calendar tempEndCal = Calendar.getInstance();
		tempEndCal.setTime(tmpEndDate);
		
		Calendar oEndCal = Calendar.getInstance();
		oEndCal.setTime(resEndDate);
		
		// timezone으로 인해 tmpStartDate가 tmpEndDate보다 늦은 경우 tmpEndDate를 하루 늘려준다.
		if (tmpStartDate.after(tmpEndDate)) {
			tempEndCal.add(Calendar.DATE, 1);
			tmpEndDate = tempEndCal.getTime();
		}
		
		long diff = tmpEndDate.getTime() - tmpStartDate.getTime();
		
		/*logger.debug("sDate=" + sDate);
		logger.debug("eDate=" + eDate);
		logger.debug("interval=" + interval);
		logger.debug("endRecurType=" + endRecurType);
		logger.debug("instances=" + instances);
		logger.debug("startDate=" + sdf.format(startDate));
		logger.debug("endDate=" + sdf.format(endDate));
		logger.debug("resStartDate=" + sdf.format(resStartDate));
		logger.debug("resEndDate=" + sdf.format(resEndDate));
		logger.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		logger.debug("tmpEndDate=" + sdf.format(tmpEndDate));*/
		
		List<Date[]> returnList = new ArrayList<Date[]>();
		
		int temp = maxTemp; // 최대 maxTemp번 반복
		
		List<Date> tsdList = new ArrayList<Date>();
		
		boolean loopFlag = true;
		
		String oStartDate;
		String oEndDate;
		Date resEndDate1 = resEndDate;
		
		while (loopFlag) {
			oStartDate = osdf.format(startDate);
			oEndDate = osdf.format(endDate);
			
			tsdList.clear();
			
			if (freq == 7) {
				tempStartCal.set(Calendar.MONTH, monthsOfYear - 1);
			}
			
			// 날짜
			if (selType == 0) {
				// daysOfMonth가 해당 달의 마지막날보다 크지 않으면 list에 추가
				int lastDate = tempStartCal.getActualMaximum(Calendar.DAY_OF_MONTH);
				if (daysOfMonth <= lastDate) {
					tempStartCal.set(Calendar.DAY_OF_MONTH, daysOfMonth);
					tsdList.add(tempStartCal.getTime());
				}
			}
			// 요일
			else {
				// 마지막 요일일 때
				if (byPosition == -1) {
					// 해당 달의 뒤에서 부터 원하는 요일의 날짜를 찾아감.
					int lastDate = tempStartCal.getActualMaximum(Calendar.DAY_OF_MONTH);
					tempStartCal.set(Calendar.DATE, lastDate);
					int lastYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					
					// 발견할 때까지 날짜 줄여나감
					while (!wDay.contains(lastYoil)) {
						tempStartCal.add(Calendar.DATE, -1);
						lastYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
					
					// 발견하면 그때부터 list에 추가
					while (wDay.contains(lastYoil)) {
						tsdList.add(tempStartCal.getTime());
						
						tempStartCal.add(Calendar.DATE, -1);
						lastYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
					
					//뒤에서부터 찾았기 때문에 횟수제한이 있을 때에는 문제가 있으므로 reverse해줌.
					Collections.reverse(tsdList);
				}
				// 마지막 요일 아닐 때
				else {
					// 해당 달의 앞에서 부터 n번째 요일의 날짜를 찾아감.
					tempStartCal.set(Calendar.DATE, 1);
					int firstYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					
					//발견할 때까지 날짜 늘려나감
					while (!wDay.contains(firstYoil)) {
						tempStartCal.add(Calendar.DATE, 1);
						firstYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
					
					tempStartCal.add(Calendar.DATE, (byPosition - 1) * 7);
					
					// 발견하면 그때부터 list에 추가
					while (wDay.contains(firstYoil)) {
						tsdList.add(tempStartCal.getTime());
						
						tempStartCal.add(Calendar.DATE, 1);
						firstYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
				}
			}
			
			for (Date tsd : tsdList) {
				// 종료일 지정 안했을 경우
				
				if (endRecurType == 0) {
					String tsdDate = osdf.format(tsd);
					logger.debug("tsdDate : " + tsdDate + " == oStartDate : " + oStartDate);
					logger.debug("tsdDate : " + tsdDate + " == oEndDate : " + oEndDate);
					if (tsd.after(endDate)) {
						loopFlag = false;
						break;
						//oSDate.compareTo(oStartDate) >= 0 && oEDate.compareTo(oEndDate) <= 0
					} else if (tsdDate.compareTo(oStartDate) >= 0 && tsdDate.compareTo(oEndDate) <= 0) {
						tempEndCal.setTime(tsd);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tsd, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					String tsdDate = osdf.format(tsd);
					logger.debug("tsdDate : " + tsdDate + " == oStartDate : " + oStartDate);
					logger.debug("tsdDate : " + tsdDate + " == oEndDate : " + oEndDate);
					if (tsd.after(endDate) || tsd.after(resEndDate1)) {
						loopFlag = false;
						break;
					} else if (tsdDate.compareTo(oStartDate) >= 0 && tsdDate.compareTo(oEndDate) <= 0) {
						tempEndCal.setTime(tsd);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tsd, 
								tempEndCal.getTime()
						});
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					String tsdDate = osdf.format(tsd);
					logger.debug("tsdDate : " + tsdDate + " == oStartDate : " + oStartDate);
					logger.debug("tsdDate : " + tsdDate + " == oEndDate : " + oEndDate);
					if (tsd.after(endDate) || instances <= 0) {
						loopFlag = false;
						break;
					} else if (tsdDate.compareTo(oStartDate) >= 0 && tsdDate.compareTo(oEndDate) <= 0) {
						tempEndCal.setTime(tsd);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tsd, 
								tempEndCal.getTime()
						});
					}
					instances--;
				}
			}
			
			if (freq == 6) {
				tempStartCal.add(Calendar.MONTH, interval);
			} else {
				tempStartCal.add(Calendar.YEAR, 1);
			}
			
			temp--;
			
			if (temp < 0) {
				logger.debug("Repeat time over 1000.");
				break;
			}
			
		}
		
		/* 2021-03-16 홍승비 - 월간 예약의 경우, 실제 예약의 시작일보다 이후의 예약일만 리턴하도록 한다. */
		List<Date[]> returnList2 = new ArrayList<Date[]>();
		for (Date[] dateVO : returnList) {
			if (dateVO[0].after(resStartDate) || dateVO[0].equals(resStartDate)) {
				returnList2.add(dateVO);
			} else {
				logger.debug("월간 예약의 실제 시작일보다 이전의 예약일은 제외합니다. (실제시작일 = " + osdf.format(resStartDate) + ", 이전 예약일 = " + osdf.format(dateVO[0]) + ")");
			}
		}
		
		logger.debug("getMonthlyRepDateTimes End");
		return returnList2;
	}
	
	public List<OrganUserVO> getOwnerInfo(String[] ownerList, int tenantID, String companyID, String lang) throws Exception {
		logger.debug("getOwnerInfo started");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("ownerList", ownerList);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("ownerID", ownerList[0]);
		map.put("lang", lang);
		
		logger.debug("getOwnerInfo ended");
		return ezResourceDAO.getOwnerInfo(map);
	}
	//public void changeResourceOrder(String selectedResourceId, String targetResourceId, int tenantId,String companyID,String upperResourceId);
	
	@Override
	public void changeResourceOrder(String selectedResourceId, String targetStatus, int tenantId,String companyID,String upperResourceId) throws Exception {
		logger.debug("changeResourceOrder start");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resourceId", selectedResourceId);
		map.put("tenantId", tenantId);
		map.put("brd_company", companyID);
		map.put("upperResourceId", upperResourceId);
		
		String selectedResourceIdOrder = ezResourceDAO.getResourceOrder(map);

		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("status", targetStatus);
		map2.put("tenantId", tenantId);
		map2.put("brd_company", companyID);
		map2.put("upperResourceId", upperResourceId);
		map2.put("brd_step", selectedResourceIdOrder);
		
		Map<String, Object> targetResource = ezResourceDAO.getTargetResourceOrder(map2);
		
		if (dbType.equals("mysql")) {
			map.put("resourceOrder", Long.toString((Long)targetResource.get("brd_step")));
			map2.put("resourceId", targetResource.get("brd_id"));
		} else {
			map.put("resourceOrder", String.valueOf(targetResource.get("BRD_STEP")));
			map2.put("resourceId", targetResource.get("BRD_ID"));
		}
		map2.put("resourceOrder", selectedResourceIdOrder);
		
		ezResourceDAO.changeResourceOrder(map);
		ezResourceDAO.changeResourceOrder(map2);
		logger.debug("changeResourceOrder ended");
	}
	
	@Override
	public void moveResourceToOtherResourceGroup(String originResourceGroupId, String selectedResourceGroupId, int tenantId, String companyID) throws Exception {
		logger.debug("moveResourceToOtherResourceGroup start");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("brd_company", companyID);
		map.put("upperResourceGroupId", selectedResourceGroupId);
		
		String maxBrdStep = ezResourceDAO.getMaxBrdStepInSelectedResourceGroup(map);
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		
		map2.put("originResourceGroupId", originResourceGroupId);
		map2.put("tenantId", tenantId);
		map2.put("brd_company", companyID);
		map2.put("selectedResourceGroupId", selectedResourceGroupId);
		
		maxBrdStep = maxBrdStep == null ? "0" : maxBrdStep;
		
		map2.put("brd_step", String.valueOf(Integer.parseInt(maxBrdStep)+1));
		
		ezResourceDAO.moveResourceToOtherResourceGroup(map2);
		logger.debug("moveResourceToOtherResourceGroup ended");
	}
	
	@Override
	public String isResourceGroupManager(String selectedResourceGroupId, String userId, int tenantId, String companyID, String deptID) throws Exception {
		logger.debug("isResourceGroupManager start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("brd_company", companyID);
		map.put("selectedResourceGroupId", selectedResourceGroupId);
		
		String isManager = ezResourceDAO.isResourceGroupManager(map);
		
		// 개인으로 관리자 권한이 없음 > 부서 권한 체크
		if(isManager.equals("0")) {
			String deptPath = ezOrganService.getDeptPath(deptID, tenantId);
			
			List<String> deptIds = new ArrayList<String>();
			Collections.addAll(deptIds, deptPath.split(","));
			
			if(deptIds.size() > 0) {
				map.put("companyID", companyID);
				map.put("tenantID", tenantId);
				map.put("brdID", selectedResourceGroupId);
				map.put("userID", userId);
				
				Collections.reverse(deptIds);
				map.put("deptID", deptIds.get(0));
				isManager = ezResourceDAO.userResPermissionCheck(map);
				
				// 현재 부서 권한 체크 > 상위 부서 권한 체크
				if(isManager.equals("0")) {
					deptIds.remove(0);				// 부서 ID 삭제
					map.put("v_BRD_UPPER", selectedResourceGroupId);
					map.put("v_PCOMPANYID", companyID);
					map.put("v_PUSERID", deptIds);
					
					List<ResGetClsAclListVO> deptAclList = ezResourceDAO.getDeptAcl(map);
					
					if(deptAclList.size() > 0) {
						for(int i=0; i<deptAclList.size(); i++) {
							if(deptAclList.get(i).getSdaYn().equals("Y")) {
								return "1";
							}
						}
					}
				}
				else {
					return isManager;
				}
				
				// 사내 겸직 권한 체크
				List<OrganUserVO> userAddJobList = ezOrganAdminService.getUserAddJobList(userId, "1", tenantId);

				if(userAddJobList.size() > 0) {
					for(int i=0; i<userAddJobList.size(); i++) {
						String addJobDeptPath = ezOrganService.getDeptPath(userAddJobList.get(i).getDepartment(), tenantId);
						List<String> addJobDeptIds = new ArrayList<String>();
						Collections.addAll(addJobDeptIds, addJobDeptPath.split(","));
						
						if(addJobDeptIds.size() > 0) {
							Collections.reverse(addJobDeptIds);
							map.put("deptID", addJobDeptIds.get(0));
							
							String result2 = ezResourceDAO.userResPermissionCheck(map);	
							
							if(result2.equals("1")) {
								return result2;
							}
							
							addJobDeptIds.remove(0);			// deptID 삭제
			
							if(addJobDeptIds.size() > 0) {
								map.put("v_PUSERID", addJobDeptIds);
								
								List<ResGetClsAclListVO> deptAclList2 = ezResourceDAO.getDeptAcl(map);
								
								if(deptAclList2.size() > 0) {
									for(int j=0; j<deptAclList2.size(); j++) {
										if(deptAclList2.get(j).getSdaYn().equals("Y")) {
											return "1";
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
 		logger.debug("isResourceGroupManager ended");
		return isManager;
	}
	
	@Override
	public String userResPermissionCheck(String userID, String companyID, int tenantID, String brdID, String deptID) throws Exception {
		logger.debug("userResPermissionCheck start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("brdID", brdID);
		map.put("deptID", deptID);
		
		String result = ezResourceDAO.userResPermissionCheck(map);
		
		if(result.equals("1")) {
			return result;
		}
		
		String deptPath = ezOrganService.getDeptPath(deptID, tenantID);	
		List<String> deptIds = new ArrayList<String>();
		Collections.addAll(deptIds, deptPath.split(","));
		//deptIds.remove(0);				// companyID 삭제
		if(deptIds.size() > 1) {
			Collections.reverse(deptIds);
			deptIds.remove(0);				// 부서 ID 삭제
			
			// 상위 부서 권한 체크
			map.put("v_BRD_UPPER", brdID);
			map.put("v_PCOMPANYID", companyID);
			map.put("v_PUSERID", deptIds);
			
			List<ResGetClsAclListVO> deptAclList = ezResourceDAO.getDeptAcl(map);
			
			if(deptAclList.size() > 0) {
				for(int i=0; i<deptAclList.size(); i++) {
					if(deptAclList.get(i).getSdaYn().equals("Y")) {
						return "1";
					}
				}
			}
		}
		
		
		// 사내 겸직 권한 체크
		List<OrganUserVO> userAddJobList = ezOrganAdminService.getUserAddJobList(userID, "1", tenantID);

		if(userAddJobList.size() > 0) {
			for(int i=0; i<userAddJobList.size(); i++) {
				String addJobDeptPath = ezOrganService.getDeptPath(userAddJobList.get(i).getDepartment(), tenantID);
				List<String> addJobDeptIds = new ArrayList<String>();
				Collections.addAll(addJobDeptIds, addJobDeptPath.split(","));
				//addJobDeptIds.remove(0);				// companyID 삭제
				
				if(addJobDeptIds.size() > 0) {
					Collections.reverse(addJobDeptIds);
					map.put("deptID", addJobDeptIds.get(0));
					
					String result2 = ezResourceDAO.userResPermissionCheck(map);	
					
					if(result2.equals("1")) {
						return result2;
					}
					
					addJobDeptIds.remove(0);			// deptID 삭제
	
					if(addJobDeptIds.size() > 0) {
						map.put("v_PUSERID", addJobDeptIds);
						
						List<ResGetClsAclListVO> deptAclList2 = ezResourceDAO.getDeptAcl(map);
						
						if(deptAclList2.size() > 0) {
							for(int j=0; j<deptAclList2.size(); j++) {
								if(deptAclList2.get(j).getSdaYn().equals("Y")) {
									return "1";
								}
							}
						}
					}
				}
			}
		}

		logger.debug("userResPermissionCheck end");
		return result;
	}

	@Override
	public List<ResBrdVO> getResourcePortlet(LoginVO userInfo, String date) throws Exception {
		logger.debug("Service getResourePortlet started");

		String  id        = userInfo.getId();
		String  companyID = userInfo.getCompanyID();
		String  offset    = userInfo.getOffset();
		String  deptID    = userInfo.getDeptID();
		int     tenantID  = userInfo.getTenantId();
		String lang = userInfo.getLang();
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cn",          id);
		map.put("tenant_id",   tenantID);
		map.put("brd_company", companyID);
		List<ResBrdVO> resources = ezResourceDAO.getResourcePortlet(map);

		int cnt = resources.size();
		for(int i=0; i<cnt; i++) {
			// 접근 권한이 없을 경우 삭제
			if(getACL(companyID, resources.get(i).getBrdID(), id, "everyone", tenantID, deptID).equals("")) {
				resources.remove(i);
				i--;
				cnt--;
			} else {// 접근 권한이 있을 경우
				// date 조회가 필요할 경우
				if(date != null && !date.equals("")) {
					StringBuilder sb       = new StringBuilder();	// 자원1의시작시간~종료시간;자원2의시작시간~종료시간;....
					StringBuilder number   = new StringBuilder();	// 자원1의번호;자원2의번호;....
					StringBuilder ownName  = new StringBuilder();	// 소유자1의이름;소유자2의이름;...
					StringBuilder deptName = new StringBuilder();	// 소유자1부서;소유자2의부서
					StringBuilder titleName = new StringBuilder();	// 자원예약1의제목;자원예약2의제목
					StringBuilder startAllTime = new StringBuilder();	// 예약1의시작날짜시간;예약1의시작날짜시간
					StringBuilder endAllTime = new StringBuilder();	// 예약1의종료날짜시간;예약1의종료날짜시간
					String retVal = getScheduleXML(date, resources.get(i).getBrdID(), companyID, "", "P", "", "",  "", "", tenantID, offset, lang);
					Document xmlDom2 = commonUtil.convertStringToDocument(retVal);
					for (int j=0; j<xmlDom2.getDocumentElement().getChildNodes().getLength(); j++) {
						// 허가되지 않은 자원의 리스트는 skip 비승인0 승인1 
						if(xmlDom2.getElementsByTagName("approveFlag").item(j).getTextContent().equals("0")) continue;
						String sDate = xmlDom2.getElementsByTagName("dtstart").item(j).getTextContent().substring(11, 16);
						String eDate = xmlDom2.getElementsByTagName("dtend").item(j).getTextContent().substring(11, 16);
						String num   = xmlDom2.getElementsByTagName("number").item(j).getTextContent();
						String own   = xmlDom2.getElementsByTagName("owner_nm").item(j).getTextContent();
						String dept  = xmlDom2.getElementsByTagName("dept_name").item(j).getTextContent();
						String title  = xmlDom2.getElementsByTagName("title").item(j).getTextContent();
						String startDateAll = xmlDom2.getElementsByTagName("dtstart").item(j).getTextContent();
						String endDateAll  = xmlDom2.getElementsByTagName("dtend").item(j).getTextContent();
						sb.append(sDate + "~" + eDate + ";");
						number.append(num + ";" );
						ownName.append(own + ";");
						deptName.append(dept + ";");
						titleName.append(title + ";");
						startAllTime.append(startDateAll + ";");
						endAllTime.append(endDateAll + ";");
					}
					resources.get(i).setRsPortletTime(sb.toString());
					resources.get(i).setRsPortletNum(number.toString());
					resources.get(i).setRsPortletOwnName(ownName.toString());
					resources.get(i).setRsPortletDeptName(deptName.toString());
					resources.get(i).setRsPortletTitle(titleName.toString());
					resources.get(i).setRsPortletStratAllTime(startAllTime.toString());
					resources.get(i).setRsPortletEndAllTime(endAllTime.toString());
				}
			}
		}
		
		logger.debug("Service getResourePortlet ended");
		return resources;
	}

	@Override
	public String saveResourcePortlet(@CookieValue("loginCookie") String loginCookie, String resources) throws Exception {
		logger.debug("Service saveResourcePortlet started");
		
		LoginVO   userInfo   = commonUtil.userInfo(loginCookie);
		String[]  resourceId = resources.split(",");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cn", userInfo.getId());
		map.put("tenant_id", userInfo.getTenantId());
		map.put("brd_company", userInfo.getCompanyID());
		ezResourceDAO.cleanResourcePortlet(map);
		
		// len > 0 일때 insert
		if(!resourceId[0].equals("")) {
			for(String id:resourceId) {
				map.put("brd_id", id);
				ezResourceDAO.insertResourcePortlet(map);
			}
		}
		
		logger.debug("service saveResourcePortlet ended");
		return "ok";
	}

	@Override
	public List<String> getAttachList(String resID, String companyID, int tenantId) throws Exception {
		logger.debug("getAttachList start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resID", resID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantId);
		
		logger.debug("getAttachList end");
		return ezResourceDAO.getAttachList(map);
		
	}
	
	@Override
	public List<ResOccuVO> getResOccuList(String companyID, int tenantID, String startTime, String endTime, String offset) throws Exception {
		logger.debug("getResOccuList started");
		
		startTime = startTime.replace(".", "-");
		endTime = endTime.replace(".", "-");
		
		String startDateLimit = startTime + " 00:00:00";
		String endDateLimit = endTime + " 23:59:59";
		
		String startDate = commonUtil.getDateStringInUTC(startDateLimit, offset, true);
		String endDate = commonUtil.getDateStringInUTC(endDateLimit, offset, true); 
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PSTARTDATE", startDate.replace(".", "-"));
		map.put("v_PENDDATE", endDate.replace(".", "-"));
		map.put("v_PCOMPANYID", companyID);
		map.put("tenantID", tenantID);
		
		List<ResOccuVO> getResOccuList = ezResourceDAO.getResOccuList(map);
		List<ResOccuVO> getScheduleListRept = ezResourceDAO.getScheduleListRepetiti2(map);
		List<ResOccuVO> getResRepOccuList = new ArrayList<ResOccuVO>();
		
		if (getScheduleListRept.size() > 0) {
			
			SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
			for (int i = 0; i < getScheduleListRept.size(); i++) {
				String reCompanyID = getScheduleListRept.get(i).getCompanyID();
				int reNum = getScheduleListRept.get(i).getNum();
				String reOwnerID = getScheduleListRept.get(i).getOwnerId();
				int count = 0;
				long timeDiff = 0;
				
				// tbl_schedulerepetition에서 정보 가져옴
				ResGetScheduleRepetitionVO vo = getRepDateTimes(reOwnerID, reCompanyID, reNum, tenantID);
				if (vo != null) {
					vo.setStartDateTime(commonUtil.getDateStringInUTC(vo.getStartDateTime(), offset, false));
					vo.setEndDateTime(commonUtil.getDateStringInUTC(vo.getEndDateTime(), offset, false));
					
					// ResGetScheduleRepetitionVO -> ResScheduleRepetitionVO
					ResScheduleRepetitionVO rvo = resStruct(vo);
					
					// 반복예약의 반복되는 날짜리스트 뽑아옴
					List<Date[]> returnRepDateTimes = getRepDateTimes(rvo, startTime, endTime, offset);
					
					// 반복예약 중에 삭제된 예약 가져옴
					List<String> deletedDateStrList = getDeletedRepScheduleDate(reNum, reCompanyID, reOwnerID, tenantID);
					logger.debug("deletedDateStrList.size=" + deletedDateStrList.size());
					
					for (int j = 0; j < deletedDateStrList.size(); j++) {
						deletedDateStrList.set(j, (commonUtil.getDateStringInUTC(deletedDateStrList.get(j), offset, false)).substring(0,10));
					}
					
					for (Date[] dateArr : returnRepDateTimes) {
						// 삭제된 예약이면 넘어감
						if (deletedDateStrList.contains(format2.format(dateArr[0]))) {		// 날짜만 비교하도록 수정
							continue;
						}
						
						count++;
						timeDiff = timeDiff + ((dateArr[1].getTime() - dateArr[0].getTime()) / 60000);
					}
				}
				
				if (count != 0) {
					ResOccuVO temp = new ResOccuVO();
					
					temp.setOwnerId(getScheduleListRept.get(i).getOwnerId());
					temp.setBrdNm(getScheduleListRept.get(i).getBrdNm());
					temp.setCompanyID(getScheduleListRept.get(i).getCompanyID());
					temp.setCount(count);
					temp.setUsageTime(timeDiff);
					getResRepOccuList.add(temp);
				}
			}
		}
		
		int size = getResRepOccuList.size();
		boolean addResRepOccuList = false;
		if (size > 0) {
			for (int i = 0; i < size; i++) {
				boolean isExist = false;
				if (getResOccuList.size() > 0) {
					for (int j = 0; j < getResOccuList.size(); j++) {
						if (getResRepOccuList.get(i).getOwnerId().equals(getResOccuList.get(j).getOwnerId())) {
							int count = getResOccuList.get(j).getCount() + getResRepOccuList.get(i).getCount();
							long usageTime = getResOccuList.get(j).getUsageTime() + getResRepOccuList.get(i).getUsageTime();
							getResOccuList.get(j).setCount(count);
							getResOccuList.get(j).setUsageTime(usageTime);
							isExist = true;
							addResRepOccuList = true;
							break;
						} else if (!isExist && j == (getResOccuList.size() - 1)) {
							ResOccuVO temp2 = new ResOccuVO();
							temp2.setOwnerId(getResRepOccuList.get(i).getOwnerId());
							temp2.setBrdNm(getResRepOccuList.get(i).getBrdNm());
							temp2.setCompanyID(getResRepOccuList.get(i).getCompanyID());
							temp2.setCount(getResRepOccuList.get(i).getCount());
							temp2.setUsageTime(getResRepOccuList.get(i).getUsageTime());
							getResOccuList.add(temp2);
							addResRepOccuList = true;
							break;
						}
					}
				} else {
					ResOccuVO temp2 = new ResOccuVO();
					temp2.setOwnerId(getResRepOccuList.get(i).getOwnerId());
					temp2.setBrdNm(getResRepOccuList.get(i).getBrdNm());
					temp2.setCompanyID(getResRepOccuList.get(i).getCompanyID());
					temp2.setCount(getResRepOccuList.get(i).getCount());
					temp2.setUsageTime(getResRepOccuList.get(i).getUsageTime());
					getResOccuList.add(temp2);
					addResRepOccuList = true;
				}
			}
		}
		
		if (addResRepOccuList && getResOccuList.size() > 0) {
			Collections.sort(getResOccuList, new Comparator<ResOccuVO>() {
				public int compare(ResOccuVO v1, ResOccuVO v2) {
					if (Integer.parseInt(v1.getOwnerId()) > Integer.parseInt(v2.getOwnerId())) {
						return 1;
					} else if (Integer.parseInt(v1.getOwnerId()) < Integer.parseInt(v2.getOwnerId())) {
						return -1;
					} 
					return 0;
				}
			});
		}
		
		logger.debug("getResOccuList end");
		return getResOccuList;
	}

	@Override
	public List<ResBrdVO> getUserResourceList(String userId, String companyId, String deptId, int tenantId) throws Exception {
		logger.debug("getUserResourceList start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cn",          userId);
		map.put("tenant_id",   tenantId);
		map.put("brd_company", companyId);
		
		logger.debug("getAttachList start");
		List<ResBrdVO> resources = ezResourceDAO.getResourcePortlet(map);
		int cnt = resources.size();
		for(int i=0; i < cnt; i++) {
			// 접근 권한이 없을 경우 삭제
			if(getACL(companyId, resources.get(i).getBrdID(), userId, "everyone", tenantId, deptId).equals("")) {
				resources.remove(i);
				i--;
				cnt--;
			}
		}
		return resources;
	}

	@Override
	public List<ResBrdVO> getResourceScheduleList(String brdId, String date, int currentPage, int listCnt, int tenantId, String companyId, String offset, String lang) throws Exception {
		List<ResBrdVO> resourceScheduleList = new ArrayList<ResBrdVO>();
		
		if(date != null && !date.equals("")) {
			String retVal = getScheduleXML(date, brdId, companyId, "", "P", "", "",  "", "", tenantId, offset, lang);
			Document xmlDom2 = commonUtil.convertStringToDocument(retVal);
			for (int i = 0; i < xmlDom2.getDocumentElement().getChildNodes().getLength(); i++) {
				// 허가되지 않은 자원의 리스트는 skip 비승인0 승인1 
				if (xmlDom2.getElementsByTagName("approveFlag").item(i).getTextContent().equals("0")) {
					continue;
				}
				
				String sDate = xmlDom2.getElementsByTagName("dtstart").item(i).getTextContent().substring(11, 16);
				String eDate = xmlDom2.getElementsByTagName("dtend").item(i).getTextContent().substring(11, 16);
				String num   = xmlDom2.getElementsByTagName("number").item(i).getTextContent();
				String own   = xmlDom2.getElementsByTagName("owner_nm").item(i).getTextContent();
				String dept  = xmlDom2.getElementsByTagName("dept_name").item(i).getTextContent();
				String title  = xmlDom2.getElementsByTagName("title").item(i).getTextContent();
				String startDateAll = xmlDom2.getElementsByTagName("dtstart").item(i).getTextContent();
				String endDateAll  = xmlDom2.getElementsByTagName("dtend").item(i).getTextContent();
				
				ResBrdVO resourceReservation = new ResBrdVO();
						
				resourceReservation.setRsPortletTime(startDateAll.replaceAll("-", ".").substring(0, 16) + " ~ " + endDateAll.replaceAll("-", ".").substring(0, 16));
				resourceReservation.setRsPortletNum(num);
				resourceReservation.setRsPortletOwnName(own);
				resourceReservation.setRsPortletDeptName(dept);
				resourceReservation.setRsPortletTitle(title);
				resourceReservation.setRsPortletStratAllTime(startDateAll);
				resourceReservation.setRsPortletEndAllTime(endDateAll);
				
				resourceScheduleList.add(resourceReservation);
			}
		}
		
		int totalCnt = resourceScheduleList.size();
		int startRow = (currentPage - 1) * listCnt;
		int lastRow = Math.min(totalCnt, startRow + listCnt);
		
		List<ResBrdVO> resultList = null;
		resultList = resourceScheduleList.subList(startRow, lastRow);
		
		return resultList;
	}
	
	/**
	 * 즐겨찾기 카테고리 추가
	 */
	@Override
	public void addFavoriteCategory(String catName, String catId, String userID, String companyID, int teanatId) throws Exception {
		logger.debug("addFavoriteCategory start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("TOP_ID", catId);
		map.put("USER_ID", userID);
		
		String newCatId=ezResourceDAO.getNewFavoriteCategoryId();
		logger.debug("newCatId=" + newCatId);
		
		map.put("CAT_ID", newCatId);
		map.put("CAT_NAME", catName);
		map.put("COMPANYID", companyID);
		map.put("TENANT_ID", teanatId);
		ezResourceDAO.insertFavoriteCategory(map);
		
		logger.debug("addFavoriteCategory end");
	}
	
	/**
	 * 즐겨찾기 카테고리 목록 조회
	 */
	@Override
	public List<ResFavoriteCategoryVO> getFavoriteCategoryList(String catId, String userID) throws Exception {
		logger.debug("getFavoriteCategoryList start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("TOP_ID", catId);
		map.put("USER_ID", userID);
		
		List<ResFavoriteCategoryVO> list = ezResourceDAO.selectFavoriteCategoryList(map);
		
		for (ResFavoriteCategoryVO vo : list) {
			map.put("TOP_ID", vo.getCatId());
			map.put("USER_ID", userID);
			List<ResFavoriteCategoryVO> childList = ezResourceDAO.selectFavoriteCategoryList(map);
			vo.setChildList(childList);
		}
		
		logger.debug("getFavoriteCategoryList end");
		return list;
	}
	
	/**
	 * 즐겨찾기 카테고리 수정
	 */
	@Override
	public void modFavoriteCategory(String catName, String catId, String userID) throws Exception {
		logger.debug("modFavoriteCategory start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("CAT_ID", catId);
		map.put("CAT_NAME", catName);
		map.put("USER_ID", userID);
		ezResourceDAO.updateFavoriteCategory(map);
		
		logger.debug("modFavoriteCategory end");
	}
	
	/**
	 * 즐겨찾기 카테고리 삭제
	 */
	@Override
	public void delFavoriteCategory(String catId, String userID, String companyID, int tenantID) throws Exception {
		logger.debug("delFavoriteCategory start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("TOP_ID", catId);
		map.put("USER_ID", userID);
		map.put("TENANT_ID", tenantID);
		map.put("COMPANY_ID", companyID);
		map.put("CAT_ID", catId);
		
		ezResourceDAO.delFavoriteCategory(map);
		
		
		// 삭제할 카테고리 하위 카테고리 목록 조회
		List<String> childeCatIdList = ezResourceDAO.checkChildYN(map);
		
		// 하위 카테고리, 자원 정보 삭제
		deletChild(childeCatIdList, userID, companyID, tenantID);
		ezResourceDAO.deleteCatBrd(map);
		ezResourceDAO.deleteChildList(map);
		
		logger.debug("delFavoriteCategory end");
	}

	/**
	 * 카테고리 삭제시 하위 계층 카테고리 확인 후 하위 카테고리 삭제를 위한 메서드 
	 */
	private void deletChild(List<String> childeCatIdList, String userID, String companyID, int tenantID) throws Exception {
		logger.debug("deletChild start");
		
		boolean flag = childeCatIdList.size()>0;
		
		if (flag) {
			for(String id: childeCatIdList) {
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("USER_ID", userID);
				map1.put("COMPANY_ID", companyID);
				map1.put("TENANT_ID", tenantID);
				map1.put("CAT_ID", id);
				map1.put("TOP_ID", id);
				
				List<String> childeCatIdList2 = ezResourceDAO.checkChildYN(map1);
				
				// 하위 체크 후 반복 삭제
				deletChild(childeCatIdList2, userID, companyID, tenantID);
				ezResourceDAO.deleteCatBrd(map1);
				ezResourceDAO.deleteChildList(map1);
			}
		}
		
		logger.debug("deletChild end");
	}
	
	/**
	 * 자원을 즐겨찾기 카테고리(분류)에 추가 하는 메서드
	 */
	@Override
	public String addBrdFavoriteCategory(String brdId, String catId, String userID, String companyID, int tenantID) throws Exception {
		logger.debug("addBrdFavoriteCategory start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("CAT_ID", catId);
		map.put("BRD_ID", brdId);
		map.put("USER_ID", userID);
		map.put("TENANT_ID", tenantID);
		map.put("COMPANY_ID", companyID);
		
		int cnt = ezResourceDAO.selectBrdFavoriteCategoryList(map);
		String result = "";
		if (cnt > 0) {
			result = "fail";
		} else {
			ezResourceDAO.insertBrdFavoriteCategory(map);
			
			map.put("brdYn", "Y");
			ezResourceDAO.updateFavoriteCategoryBrdYN(map);
			result =  "ok";
		}
		
		logger.debug("addBrdFavoriteCategory end");
		return result;
	}
	
	/**
	 * 즐겨찾기 카테고리(분류) 자원 목록 조회 메서드
	 */
	@Override
	public List<ResBrdVO> getFavoriteBrdList(String catId, String companyId, int tenantId, String userID) throws Exception {
		logger.debug("getFavoriteBrdList start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("catId", catId);
		map.put("companyId", companyId);
		map.put("userID", userID);
		map.put("tenantId", tenantId);
		
		List<ResBrdVO> favoriteBrdList = ezResourceDAO.selectFavoriteBrdList(map);
		
		logger.debug("getFavoriteBrdList end");
		return favoriteBrdList;
	}
	
	/**
	 * topId 최종적으로 이동될 위치 카테고리 ID
	 * catId 이동 대상 카테고리
	 */
	@Override
	public String moveCategory(String userID, String companyID, int tenantID, String catId, String topId) throws Exception {
		logger.debug("moveCategory start");
		
		String result = "";
		if (topId.equals(catId)) {
			// 이동하려는 카테고리와 현재 카테고리가 같을 경우
			result = "equalfail";
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			// 이동 시킬 카테고리(분류) ID
			map.put("CAT_ID", catId);
			// 최종 이동될 카테고리(분류) ID
			map.put("TOP_ID", topId);
			map.put("USER_ID", userID);
			map.put("TENANT_ID", tenantID);
			map.put("COMPANY_ID", companyID);
			
			// 옮겨질 카테고리를 상위로 가지고 있는 카테고리 ID LIST
			List<String> childeCatIdList = ezResourceDAO.checkChildYN(map);
			// 바로 하위 시도 여부 파악
			boolean contains = childeCatIdList.contains(topId);
			
			if (contains) {
				// 바로 하위로 이동 시도
				result = "fail";
			} else {
				// 현재 카테고리의 하위 계층에 이동을 시도 하려는지 검증
				boolean containsFlag = checkIfContains(childeCatIdList, topId, userID, companyID, tenantID);
				if (containsFlag) {
					// 검증 통과
					ezResourceDAO.moveCategoryToCategory(map);
					result = "true";
				} else {
					// 자식 요소로 이동 시도
					result = "fail";
				}
			}
		}
		
		logger.debug("moveCategory end");
		return result;
	}
	
	/**
	 * @param initialList : 하위 목록 검증할 catId 목록  
	 * @param topId : 검증 대상 ID 
	 * @return initialList에 top ID 가 포함되어 있으면 false
	 */
	private boolean checkIfContains(List<String> initialList, String topId, String userID, String companyID, int tenantID) throws Exception {
		
	    for (String id : initialList) {
	        if (!recursiveCheck(id, topId, userID, companyID, tenantID)) {
	            return false;
	        }
	    }
	    
	    return true;
	}
	
	/**
	 * @param currentId : 하위 검증 위한 CAT_ID 해당 카테고리 하위에 있는 카테고리 전부 검증
	 * @param topId : 검증할 TOP_ID
	 * @return curentId 의 하위 카테고리의 top_id 가 파라미터 top_id 와 같으면 false
	 */
	private boolean recursiveCheck(String currentId, String topId, String userID, String companyID, int tenantID) throws Exception {
	    Map<String, Object> map = new HashMap<>();
	    map.put("CAT_ID", currentId);
	    map.put("USER_ID", userID);
	    map.put("COMPANY_ID", companyID);
	    
	    List<String> childList = ezResourceDAO.checkChildYN(map);
	    
	    if (childList.contains(topId)) {
	        return false;
	    }
	    
	    for (String childId : childList) {
	        if (!recursiveCheck(childId, topId, userID, companyID, tenantID)) {
	            return false;
	        }
	    }
	    
	    return true;
	}
	
	/**
	 * 자원을 다른 즐겨찾기 카테고리(분류)로 이동하기 위한 메서드
	 */
	@Override
	public String moveResource(String userID, String companyID, int tenantID, String catId, String brdId, String topId) throws Exception {
		logger.debug("moveResource start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		// 이동할 카테고리
		map.put("CAT_ID", catId);
		// 자원 brdId
		map.put("BRD_ID", brdId);
		// 현재 속한 카테고리
		map.put("CUR_ID", topId);
		map.put("USER_ID", userID);
		map.put("COMPANY_ID", companyID);
		map.put("TENANT_ID", tenantID);
		
		int cnt = ezResourceDAO.selectBrdCategoryCnt(map);
		String resultStr = "";
		if (cnt > 0) {
			resultStr = "no";
		} else {
			// 자원 이동
			ezResourceDAO.moveBrdCategoryToCategory(map);
			
			// 이동한 카테고리 자원 여부 Y
			map.put("brdYn", "Y");
			ezResourceDAO.updateFavoriteCategoryBrdYN(map);
			
			// 기존 카테고리 자원 여부 파악 후 없을경우 N
			map.put("catId", topId);
			if (ezResourceDAO.selectFavoriteBrdList(map).size() == 0) {
				map.put("brdYn", "N");
				map.put("CAT_ID", topId);
				ezResourceDAO.updateFavoriteCategoryBrdYN(map);
			}
			
			resultStr = "ok";
		}
		
		logger.debug("moveResource end");
		return resultStr;
	}
	
	/**
	 * 즐겨찾기 카테고리(분류)에 속한 자원정보 삭제 메서드
	 */
	@Override
	public void delBrdFavoriteCategory(String userId, int tenantId, String companyId, String delBrdId, String delTopId) throws Exception {
		logger.debug("delBrdFavoriteCategory start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("BRD_ID", delBrdId);
		map.put("CAT_ID", delTopId);
		map.put("USER_ID", userId);
		map.put("TENANT_ID", tenantId);
		map.put("COMPANY_ID", companyId);
		
		ezResourceDAO.deleteBrdFavoriteCategory(map);
		
		// 카테고리 자원 보유 여부 변경
		map.put("catId", delTopId);
		map.put("userID", userId);
		if (ezResourceDAO.selectFavoriteBrdList(map).size() == 0) {
			map.put("brdYn", "N");
			map.put("CAT_ID", delTopId);
			ezResourceDAO.updateFavoriteCategoryBrdYN(map);
		}
		
		logger.debug("delBrdFavoriteCategory end");
	}
	
	@Override
	public String getBrdResMaxDate(String resourceId, String companyID, int tenantID) throws Exception {
		logger.debug("getBrdResMaxUserDate start");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resourceID", resourceId);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("getBrdResMaxUserDate end");
		return ezResourceDAO.selectResMaxDate(map);
	}
}