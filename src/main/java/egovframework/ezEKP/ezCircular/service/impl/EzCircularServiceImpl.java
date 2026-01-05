package egovframework.ezEKP.ezCircular.service.impl;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;

import org.apache.commons.io.IOUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCircular.dao.EzCircularDAO;
import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezCircular.vo.CircularAttachVO;
import egovframework.ezEKP.ezCircular.vo.CircularCommentVO;
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularConfirmVO;
import egovframework.ezEKP.ezCircular.vo.CircularDeptVO;
import egovframework.ezEKP.ezCircular.vo.CircularFolderVO;
import egovframework.ezEKP.ezCircular.vo.CircularListHeaderVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.ezEKP.ezCircular.vo.CircularMemberVO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzCircularService")
public class EzCircularServiceImpl extends EgovAbstractServiceImpl implements EzCircularService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzCircularServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	@Resource(name="EzCircularDAO")
	private EzCircularDAO ezCircularDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Override
	public CircularConfigVO getCircularList_Config(String memberId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_MEMBERID", memberId);
		map.put("v_TENANTID", tenantId);
		
		CircularConfigVO vo = ezCircularDAO.getCircularList_Config(map);
		
		if (vo == null) { // 새로운 유저가 접속했을때 Config 값 없으면 기본 값 설정
			vo = new CircularConfigVO();
			vo.setMemberID(memberId);
			vo.setTenantID(tenantId);
			vo.setListCnt(10);
			vo.setIsPreview(0);
			vo.setPreviewListValue("50");
			vo.setPreviewContentValue("50");
			
			ezCircularDAO.setCircularList_Config_I(vo);
		}
		
		return vo;
	}

	@Override
	public void setCircularList_Config(CircularConfigVO circularConfigVO) throws Exception {
		logger.debug("setCircularList_Config started.");

		ezCircularDAO.setCircularList_Config_U(circularConfigVO);

		logger.debug("setCircularList_Config ended.");
	}
	
	@Override
	public void setCircularList_Config2(String userID, String listCount, String previewMode, String list, String content, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_LISTCNT", listCount);
		map.put("v_PREVIEWMODE", previewMode);
		map.put("v_LIST", list);
		map.put("v_CONTENT", content);
		map.put("v_TENANTID", tenantID);

		ezCircularDAO.setCircularList_Config2_U(map);
	}
	
	@Override
	public String setCircularConfig(String userID, int listCount, String preView, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MEMBERID", userID);
		map.put("v_LISTCOUNT", listCount);
		map.put("v_PREVIEW", preView);
		map.put("v_TENANTID", tenantID);
		
		try {
			String tempString = ezCircularDAO.getCircularConfig(map);

			if (tempString != null && !tempString.equals("")) {
				ezCircularDAO.setCircularConfig(map);
			} else {
				ezCircularDAO.setCircularConfig2(map);
			}
			
			return "OK";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			return "NO";
		}
	}

	@Override
	public List<CircularListVO> getCircularList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, int tenantID, String offset, String orderCell, String orderOption, String companyID, String lang) throws Exception {
		logger.debug("getCircularList started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType =  " + searchType + " || startRow = " + startRow + " || endRow = " + endRow + " || orderCell = " + orderCell + " || orderOption = " + orderOption + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue.trim());
		map.put("searchType", searchType.trim());
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantID", tenantID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		List<CircularListVO> list = ezCircularDAO.getCircularList(map);
		
		logger.debug("getCircularList ended. listSize = " + list.size());
		
		return list;
	}

	@Override
	public void insertCircular(int circularID, String title, int importance, int option, String content, int hasFile, int status, String regDate,
							   String endDate, int receiverLength, String[] receiverID, int updateStatus, int circularUserId, String[] receiverName,
							   String fileList, String[] receiverName2, String pDirPath, String mode, LoginVO userInfo, String loginCookie) throws Exception {
		logger.debug("insertCircular started.");
		Map<String, Object> map = new HashMap<String, Object>();
		
		//파일이 있으면 hasFile을 1로 설정
		if (fileList != null && !fileList.equals("")) {
			hasFile = 1;
		}

		map.put("circularID", circularID);
		map.put("title", title);
		map.put("importance", importance);
		map.put("option", option);
		map.put("content", content);
		map.put("hasFile", hasFile);
		map.put("status", status);
		map.put("memberID", userInfo.getId());
		map.put("memberName", userInfo.getDisplayName1());
		map.put("memberName2", userInfo.getDisplayName2());
		map.put("regDate", regDate);
		map.put("endDate", endDate);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		
		circularID = ezCircularDAO.insertCircular(map);
		
		for (int i=0; i<receiverLength; i++) {
			insertCircularUser(circularUserId, circularID, receiverID[i].trim(), receiverName[i].trim(), receiverName2[i].trim(), status, "", updateStatus, userInfo.getTenantId(), userInfo.getCompanyID());
		}
		
		//첨부파일 저장
		Map<String, Object> attachMap = new HashMap<String, Object>();
		
		if (fileList != null && !fileList.equals("")) {
			//2018-02-13 주홍선 파일경로 잘못되어있던 것 수정
			File file = new File(commonUtil.detectPathTraversal(pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile"));

			if (!file.exists()) {
	        	file.mkdirs();
	        }
			//2018-07-06 김보미 - 파일부분 수정
//			int fileLength = fileList.split(",").length;
//			String[] fileLists = fileList.split(",");
//			
//			attachMap.put("circularID", circularID);
//			attachMap.put("tenantID", userInfo.getTenantId());
//			
//			for (int j=0; j<fileLength; j++) {
//				String[] files = fileLists[j].split(";");
//				String filePath = files[0];
//				String fileName = files[1];
//				String fileSize = files[2];
//				
//				logger.debug("filePath : " + filePath + " | fileName : " + fileName);
//				
//				String uploadFilePath = commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
//				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + ";" + fileName;
//				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
//
//				attachMap.put("fileName", fileName);
//				attachMap.put("fileSize", fileSize);
//				attachMap.put("filePath", uploadFilePath);
//				
//				logger.debug("uploadFilePath : " + uploadFilePath);
//
//				ezCircularDAO.insertCircularAttach(attachMap);
//
//				fileMove(beforeFilePath, afterFilePath); // Temp 폴더에서 첨부파일 이동
//			}
			JSONParser jp = new JSONParser();
			JSONArray jsonArr = (JSONArray)jp.parse(fileList);
			
			int fileLength = jsonArr.size();
			
			attachMap.put("circularID", circularID);
			attachMap.put("tenantID", userInfo.getTenantId());
			
			for (int j = 0; j < fileLength; j++) {
				JSONObject jsonObj = new JSONObject();
				jsonObj = (JSONObject) jsonArr.get(j);
				String filePath = (String) jsonObj.get("newFileName");
				String fileName = (String) jsonObj.get("pFileName");
				String fileSize = (String) jsonObj.get("fileSize");
				
				logger.debug("filePath : " + filePath + " | fileName : " + fileName);
				
				String uploadFilePath = commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + fileName;
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + fileName;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + fileName;

				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);
				
				logger.debug("uploadFilePath : " + uploadFilePath);

				ezCircularDAO.insertCircularAttach(attachMap);

				fileMove(beforeFilePath, afterFilePath); // Temp 폴더에서 첨부파일 이동
			}
		}

		// 임시저장이 아닐 때만 실행
		if (status != 2) {
			confirmStatus(Integer.toString(circularID), userInfo.getId(), userInfo.getTenantId(), "circularConfirm");			
		}

		// 회람자에게 메일 발송
		if (option == 2 || option == 3) {
			// 임시저장 시 미발송
			// 2018-10-01 김민성 - 회람판 확인요청 메일 폰트 수정
			if (status != 2) {
				String subject = egovMessageSource.getMessage("ezCircular.t172", userInfo.getLocale());
				StringBuilder bodyContent = new StringBuilder("");

				bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='circular_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezCircular/circularRead.do?circularID=" + circularID + "&type=new', '', 'width=820, height=900')\">" + commonUtil.cleanValue(title) + "</span></br>");
		    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t122", userInfo.getLocale()) + " : " + userInfo.getDisplayName());
		    	
		    	String content_ = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());

				for (int i=0; i<receiverLength; i++) {
					OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(receiverID[i].trim(), userInfo.getPrimary(), userInfo.getTenantId());
					
					InternetAddress from = new InternetAddress();
					from.setPersonal(userInfo.getDisplayName(), "UTF-8");
					from.setAddress(userInfo.getEmail());
					
					InternetAddress to = new InternetAddress();
					
					if (!receiverID[i].trim().equals(userInfo.getId())) {
						to.setPersonal(receiverName[i].trim(), "UTF-8");
						to.setAddress(AccessUserInfo.getMail());
						
						ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content_, false);
					}
				}	
			}
		}

		logger.debug("insertCircular ended.");
	}

	private void fileMove(String beforeFilePath, String afterFilePath) throws Exception {
		logger.debug("fileMove started.");
		logger.debug("beforeFilePath = " + beforeFilePath + " || afterFilePath = " + afterFilePath);

		File file = new File(commonUtil.detectPathTraversal(beforeFilePath));

		try {
			file.renameTo(new File(commonUtil.detectPathTraversal(afterFilePath)));
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("fileMove ended.");
	}

	@Override
	public void copyFileList(String pDirPath, String fileName, String circularID) throws Exception {
		FileInputStream fis = null;
		FileOutputStream fos = null;
		BufferedReader br = null;
		BufferedWriter bw = null;

		try {
			File originFile = new File(commonUtil.detectPathTraversal(pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + fileName)); // 복사할 파일의 경로
			File copyFilePath = new File(commonUtil.detectPathTraversal(pDirPath + "tempUploadFile" + commonUtil.separator + fileName));

			fis = new FileInputStream(originFile);
			fos = new FileOutputStream(copyFilePath);

			br = new BufferedReader(new FileReader(originFile));
			bw = new BufferedWriter(new FileWriter(copyFilePath));
			
			StringBuilder result = new StringBuilder();
			
			while (br.readLine() != null) {
				result.append(br.readLine());
			}
			
			bw.append(result.toString());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			// 2023-06-01 이사라 : 시큐어코딩 NullPointerException, 리소스 close
			IOUtils.closeQuietly(fis);
			IOUtils.closeQuietly(fos);
			IOUtils.closeQuietly(br);
			IOUtils.closeQuietly(bw);

			/*try {
				fos.close();
				br.close();
				bw.close();
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}*/
		}
	}

	public void insertCircularUser(int circularUserID, int circularID, String memberID, String memberName, String memberName2, int status, String confirmDate, int updateStatus, int tenantID, String companyID) throws Exception {
		logger.debug("insertCircularUser started.");
		logger.debug("circularUserID = " + circularUserID + " || circularID = " + circularID + " || memberID = " + memberID + " || confirmDate = " + confirmDate + " || status = " + status + " || updateStatus = " + updateStatus + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularUserID", circularUserID);
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("memberName", memberName);
		map.put("memberName2", memberName2);
		map.put("confirmDate", confirmDate);
		map.put("status", status);
		map.put("updateStatus", updateStatus);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		ezCircularDAO.insertCircularUser(map);
		
		logger.debug("insertCircularUser ended.");
	}

	@Override
	public CircularListVO getCircular(String circularID, String memberID, String offset, int tenantID, String type, String lang) throws Exception {
		logger.debug("getCircular started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || type = " + type + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("lang", lang);
		
		CircularListVO vo = ezCircularDAO.getCircular(map);
		
		logger.debug("getCircular ended.");
		
		return vo;
	}

	@Override
	public void updateCircular (String title, int importance, int option, String circularID, int tenantID, String memberID, int receiverLength, int status,
			String loginCookie, LoginVO userInfo, String regDate, String content, String fileList, String offset, String[] receiverID, String[] receiverName,
			String[] receiverName2, int circularUserId, int updateStatus, String mode, String pDirPath) throws Exception {
		//파일이 있으면 hasFile을 1로 설정
		int hasFile = 0;

		if (fileList != null && !fileList.equals("")) {
			hasFile = 1;
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("title", title);
		map.put("importance", importance);
		map.put("option", option);
		map.put("content", content);
		map.put("circularID", circularID);
		map.put("hasFile", hasFile);
		map.put("status", status);
		map.put("regDate", regDate);
		map.put("tenantID", tenantID);

		ezCircularDAO.updateCircular(map);

		deleteCircularUser(Integer.parseInt(circularID), tenantID);
		
		String nowDate = commonUtil.getTodayUTCTime("");
		String commentStatusList = "";

		for (int i=0; i<receiverLength; i++) {			
			insertCircularUser(circularUserId, Integer.parseInt(circularID), receiverID[i].trim(), receiverName[i].trim(), receiverName2[i].trim(), status, "", updateStatus, tenantID, userInfo.getCompanyID());

			//의견을 확인 안한 회람자의 commentStatus 를 1 로 update
			List<CircularListVO> commentStatus = getCommentStatus(circularID, receiverID[i].trim(), tenantID);

			for (int j=0; j<commentStatus.size(); j++) {
				commentStatusList += commentStatus.get(j).getCommentStatus() + ";";
			}

			if (commentStatusList.indexOf("0") != -1) {
				updateCircularCommentStatus(circularID, receiverID[i].trim(), 1, 0, nowDate, tenantID);
			}
			
			commentStatusList = "";
		}

		confirmStatus(circularID, memberID, tenantID, "circularConfirm");
		
		//첨부파일 삭제 후 등록
		ezCircularDAO.deleteCircularAttach(map);

		Map<String, Object> attachMap = new HashMap<String, Object>();

		if (fileList != null && !fileList.equals("")) {
			//2018-07-06 김보미 - 파일부분 수정
//			int fileLength = fileList.split(",").length;
//			String[] fileLists = fileList.split(",");
//
//			logger.debug("updateCircular fileList : " + fileList);
//
//			attachMap.put("circularID", circularID);
//			attachMap.put("tenantID", tenantID);
//			
//			for (int j=0; j<fileLength; j++) {
//				String[] files = fileLists[j].split(";");
//				String filePath = files[0];
//				String fileName = files[1];
//				String fileSize = files[2];
//				
//				logger.debug("filePath : " + filePath + " | fileName : " + fileName);
//				
//				String uploadFilePath = commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
//				
//				attachMap.put("fileName", fileName);
//				attachMap.put("fileSize", fileSize);
//				attachMap.put("filePath", uploadFilePath);
//
//				logger.debug("uploadFilePath : " + uploadFilePath);
//
////				ezCircularDAO.updateCircularAttach(attachMap);
//				ezCircularDAO.insertCircularAttach(attachMap);
//
//				// mode = modify -> 회람수정 일 때이므로 수정 시 Temp 폴더에서 첨부파일 이동
//				if (mode.equals("modify")) {
//					String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + ";" + fileName;
//					String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
//					
//					fileMove(beforeFilePath, afterFilePath); // Temp 폴더에서 첨부파일 이동					
//				}
//			}
			JSONParser jp = new JSONParser();
			JSONArray jsonArr = (JSONArray)jp.parse(fileList);
			
			int fileLength = jsonArr.size();

			attachMap.put("circularID", circularID);
			attachMap.put("tenantID", tenantID);
			
			for (int j = 0; j < fileLength; j++) {
				JSONObject jsonObj = new JSONObject();
				jsonObj = (JSONObject) jsonArr.get(j);
				String filePath = (String) jsonObj.get("newFileName");
				String fileName = (String) jsonObj.get("pFileName");
				String fileSize = (String) jsonObj.get("fileSize");
				
				logger.debug("filePath : " + filePath + " | fileName : " + fileName);
				
				String uploadFilePath = commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + fileName;
				
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);

				logger.debug("uploadFilePath : " + uploadFilePath);

				ezCircularDAO.insertCircularAttach(attachMap);

				// mode = modify -> 회람수정 일 때이므로 수정 시 Temp 폴더에서 첨부파일 이동
				if (mode.equals("modify") || mode.equals("temp")) {
					// 해당 폴더가 없을 때 생성
					logger.debug("pDirpath : " + pDirPath);
					File file = new File(pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile");
					 
					if (!file.exists()) {
			        	file.mkdirs();
			        }
					
					String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + fileName;
					String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + fileName;
					
					fileMove(beforeFilePath, afterFilePath); // Temp 폴더에서 첨부파일 이동					
				}
			}
		}
		
		// 회람자에게 메일 발송
		if (option == 2 || option == 3) {
			String subject = egovMessageSource.getMessage("ezCircular.t172", userInfo.getLocale());
			StringBuilder bodyContent = new StringBuilder("");

			bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='circular_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezCircular/circularRead.do?circularID=" + circularID + "&type=new', '', 'width=820, height=900')\">" + commonUtil.cleanValue(title) + "</span></br>");
	    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t122", userInfo.getLocale()) + " : " + userInfo.getDisplayName());
	    	
	    	String content_ = commonUtil.createNotiMailContent(bodyContent.toString(), tenantID, userInfo.getLocale());

			for (int i=0; i<receiverLength; i++) {
				OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(receiverID[i].trim(), userInfo.getPrimary(), userInfo.getTenantId());
				
				InternetAddress from = new InternetAddress();
				from.setPersonal(userInfo.getDisplayName(), "UTF-8");
				from.setAddress(userInfo.getEmail());
				
				InternetAddress to = new InternetAddress();
				
				if (!receiverID[i].trim().equals(userInfo.getId())) {
					to.setPersonal(receiverName[i].trim(), "UTF-8");
					to.setAddress(AccessUserInfo.getMail());
					
					ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content_, false);
				}
			}
		}
	}

	private List<CircularListVO> getCommentStatus(String circularID, String memberID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getCommentStatus(map);
	}

	@Override
	public void modifyCircular(String title, int importance, int option, int circularID, int tenantID, int receiverLength, String[] receiverID, int updateStatus,
			int circularUserId, String memberName, String memberName2, int status, String confirmDate, String content, String fileList, String pDirPath,
			String[] receiverName, String[] receiverName2, String offset, String companyID) throws Exception {
		//파일이 있으면 hasFile을 1로 설정
		int hasFile = 0;

		if (fileList != null && !fileList.equals("")) {
			hasFile = 1;
		}

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("title", title);
		map.put("importance", importance);
		map.put("option", option);
		map.put("content", content);
		map.put("circularID", circularID);
		map.put("hasFile", hasFile);
		map.put("tenantID", tenantID);
		map.put("regDate", commonUtil.getTodayUTCTime(""));
		
		ezCircularDAO.modifyCircular(map);
		
		List<CircularListVO> list = getCircularUserList(circularID, "", "", tenantID, offset);
		
		logger.debug("receiverLength : " + receiverLength);
		logger.debug("listSize : " + list.size());
		
		//회람자 삭제 후 등록
		deleteCircularUser(circularID, tenantID);
		
		for (int i=0; i<receiverLength; i++) {
			insertCircularUser(circularUserId, circularID, receiverID[i].trim(), receiverName[i].trim(), receiverName2[i].trim(), status, confirmDate, updateStatus, tenantID, companyID);
		}
		
		//첨부파일 삭제 후 등록
		ezCircularDAO.deleteCircularAttach(map);
		
		Map<String, Object> attachMap = new HashMap<String, Object>();
		
		if (fileList != null && !fileList.equals("")) {
			File file = new File(commonUtil.detectPathTraversal(pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + circularID + "_uploadFile"));

			if (!file.exists()) {
	        	file.mkdirs();
	        }

			logger.debug("modify fileList : " + fileList);
			
//			int fileLength = fileList.split(",").length;
//			String[] fileLists = fileList.split(",");
//			
//			attachMap.put("circularID", circularID);
//			attachMap.put("tenantID", tenantID);
//			
//			for (int j=0; j<fileLength; j++) {
//				String[] files = fileLists[j].split(";");
//				String filePath = files[0];
//				String fileName = files[1];
//				String fileSize = files[2];
//				
//				logger.debug("filePath : " + filePath + " | fileName : " + fileName);
//				
//				String uploadFilePath = commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
//				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + ";" + fileName;
//				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
//
//				attachMap.put("fileName", fileName);
//				attachMap.put("fileSize", fileSize);
//				attachMap.put("filePath", uploadFilePath);
//				
//				logger.debug("uploadFilePath : " + uploadFilePath);
//				
//				ezCircularDAO.insertCircularAttach(attachMap);
//
//				fileMove(beforeFilePath, afterFilePath); // Temp 폴더에서 첨부파일 이동
//			}
			JSONParser jp = new JSONParser();
			JSONArray jsonArr = (JSONArray)jp.parse(fileList);
			
			int fileLength = jsonArr.size();
			
			attachMap.put("circularID", circularID);
			attachMap.put("tenantID", tenantID);
			
			for (int j = 0; j < fileLength; j++) {
				JSONObject jsonObj = new JSONObject();
				jsonObj = (JSONObject) jsonArr.get(j);
				String filePath = (String) jsonObj.get("newFileName");
				String fileName = (String) jsonObj.get("pFileName");
				String fileSize = (String) jsonObj.get("fileSize");
				
				logger.debug("filePath : " + filePath + " | fileName : " + fileName);
				
				String uploadFilePath = commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + fileName;
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + fileName;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + fileName;

				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);
				
				logger.debug("uploadFilePath : " + uploadFilePath);
				
				ezCircularDAO.insertCircularAttach(attachMap);

				fileMove(beforeFilePath, afterFilePath); // Temp 폴더에서 첨부파일 이동
			}
		}
	}

	@Override
	public void deleteCircularList(String circularIDListInfo, String memberIDListInfo, String pDirpath, String userID, int tenantID) throws Exception {
		logger.debug("deleteCircularList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String[] memberIDList = memberIDListInfo.split(";");
		String[] circularIDList = circularIDListInfo.split(";");

		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		for (int i=0; i<circularIDList.length; i++) {
			String idInfo = circularIDList[i] + "/" + memberIDList[i];
			
			String[] idsArr = idInfo.split("/");
			String circularID = idsArr[0];
			String memberID = idsArr[1];


			logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || userID = " + userID + " || tenantID = " + tenantID);
			
			map.put("circularID", circularID);
			map.put("memberID", memberID);
			
			if (memberID.equals(userID)) {
				ezCircularDAO.deleteCircular(map);
				ezCircularDAO.deleteCircularUser(map);
				ezCircularDAO.deleteCircularAttach(map);
				deleteDirectory(circularID, pDirpath, tenantID);
			} else {
				ezCircularDAO.updateDeleteFlag(map);
				map.put("memberID", userID);
			}
			ezCircularDAO.moveCircular3(map);			// 2019-01-25 김민성 - 회람문서함에서 삭제한 문서 영구삭제시 link 삭제
		}
		
		logger.debug("deleteCircularList ended.");
	}
	
	private void deleteDirectory (String circularID, String pDirpath, int tenantID) throws Exception {
		logger.debug("deleteDirectory ended.");
		
		File directoryFile = new File(commonUtil.detectPathTraversal(pDirpath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile"));
		File[] deleteFileList = directoryFile.listFiles();

		if (directoryFile.exists()) {
			// 디렉토리 하위의 파일을 모두 삭제 한뒤 디렉토리 삭제
			if (deleteFileList.length >0) {
				for (int i=0; i<deleteFileList.length; i++) {
					if (deleteFileList[i].isFile()) {
						deleteFileList[i].delete();
					} else {
						deleteDirectory(circularID, pDirpath, tenantID);
					}
				}
			}

			directoryFile.delete();
		}

		logger.debug("deleteDirectory ended.");
	}

	@Override
	public void deleteCircular(String circularID, String memberID, String userID, int tenantID) throws Exception {
		logger.debug("deleteCircular started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || userID = " + userID + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		if (memberID.equals(userID)) {
			ezCircularDAO.deleteCircular(map);
			ezCircularDAO.deleteCircularUser(map);
			ezCircularDAO.deleteCircularAttach(map);
		} else {
			ezCircularDAO.updateDeleteFlag(map);
		}
		
		logger.debug("deleteCircular ended.");
	}

	@Override
	public void deleteCircularUser(int circularID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.deleteCircularUser(map);
	}

	@Override
	public int getCircularListCount(String memberID, String searchValue, String searchType, String sdate, String edate, String offset, int tenantID, String companyID, String lang) throws Exception {
		logger.debug("getCircularListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType = " + searchType + " || sdate = " + sdate + " || edate = " + edate + " || tenantID = " + tenantID + " || companyID =" + companyID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue.trim());
		map.put("searchType", searchType.trim());
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		int result = ezCircularDAO.getCircularListCount(map);
		
		logger.debug("getCircularListCount ended. result = " + result);
		
		return result;
	}

	public void updateStatus(String circularID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.updateStatus(map);
	}

	@Override
	public void setCircularDeptSave(String title, String userID, String[] memberListStr, int tenantID, String companyID) throws Exception {
		logger.debug("setCircularDeptSave started.");
		logger.debug("title = " + title + " || userID = " + userID + " || tenantID = " + tenantID);
		
		String nowDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("title", title);
		map.put("userID", userID);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		String circularBMId = ezCircularDAO.setCircularDeptSave(map);
		
		map.put("circularBMId", circularBMId);
		
		for(int i=0; i<memberListStr.length; i++) {
			logger.debug("memberID = " + memberListStr[i]);
			map.put("memberID", memberListStr[i]);
			
			ezCircularDAO.setCircularMemberList(map);
		}
		
		logger.debug("setCircularDeptSave ended.");
	}

	@Override
	public List<CircularDeptVO> getcircularDeptList(String memberID, String offset, int tenantID, String companyID) throws Exception {
		logger.debug("getcircularDeptList started.");
		logger.debug("memberID = " + memberID + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		List<CircularDeptVO> list = ezCircularDAO.getcircularDeptList(map);
		
		logger.debug("getcircularDeptList ended. listSize = " + list.size());

		return list;
	}

	@Override
	public void circularDeptDel(String circularBMIdList, int tenantID) throws Exception {
		logger.debug("circularDeptDel started.");
		logger.debug("circularBMIdList = " + circularBMIdList + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantID", tenantID);
		
		for (String circularBMId : circularBMIdList.split(",")) {
			logger.debug("circularBMId = " + circularBMId);
			map.put("circularBMId", circularBMId);
			
			ezCircularDAO.circularDeptDel(map);
			ezCircularDAO.deleteCircularMemberList(map); // 2018-03-26 황윤호 추가
		}
		logger.debug("circularDeptDel ended.");
	}

	@Override
	public void updateCircularDept(String title, String userID, String[] memberListStr, String circularBMId, int tenantID, String companyID) throws Exception {
		logger.debug("updateCircularDept started.");
		logger.debug("title = " + title + " || userID = " + userID + " || circularBMId = " + circularBMId + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("title", title);
		map.put("circularBMId", circularBMId);
		map.put("userID", userID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		ezCircularDAO.updateCircularDept(map);
		ezCircularDAO.deleteCircularMemberList(map);
		
		for(int i=0; i<memberListStr.length; i++) {
			logger.debug("memberID = " + memberListStr[i]);
			
			map.put("memberID", memberListStr[i]);
					
			ezCircularDAO.setCircularMemberList(map);
		}
		
		
		
		logger.debug("updateCircularDept ended.");
	}

	@Override
	public List<CircularListVO> getCircularUserList(int circularID, String searchType, String searchValue, int tenantID, String offset) throws Exception {
		logger.debug("getCircularUserList started.");
		logger.debug("circularID = " + circularID + " || searchValue = " + searchValue + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		List<CircularListVO> list = ezCircularDAO.getCircularUserList(map);
		
		logger.debug("getCircularUserList ended.");
		
		return list;
	}
	
	@Override
	public List<CircularListVO> getCircularDeptUserList(int circularBMId, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("circularBMId", circularBMId);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getCircularDeptUserList(map);
	}

	@Override
	public List<CircularAttachVO> getAttachList(int circularID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getAttachList(map);
	}

	@Override
	public int checkUpdateStatus(int circularID, String memberID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.checkUpdateStatus(map);
	}
	
	@Override
	public List<CircularMemberVO> getMemberName(String circularBMId, int tenantID, String companyID, String primary) throws Exception {
		logger.debug("getMemberName started.");
		logger.debug("circularBMId = " + circularBMId + " || tenantID = " +tenantID + " || companyID = " +companyID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularBMId", circularBMId);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("primary", primary);
		
		List<CircularMemberVO> list = ezCircularDAO.getMemberName(map);
		
		logger.debug("getMemberName ended.");
		
		return list;
	}

	@Override
	public void circularConfirmStatus(String circularIDList, String memberID, int tenantID) throws Exception {
		logger.debug("circularConfirmStatus started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantID", tenantID);
		map.put("memberID", memberID);
		
		for (String circularID : circularIDList.split(";")) {
			logger.debug("circularID = " + circularID + " || memberID = " + memberID);
			
			map.put("circularID", circularID);
			
			confirmStatus(circularID, memberID, tenantID, "all");
		}
		
		logger.debug("circularConfirmStatus ended.");
	}

	@Override
	public List<CircularListVO> getCircularCompleteList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, int tenantID, String offset, String orderCell, String orderOption, String companyID, String lang) throws Exception {
		logger.debug("getCircularCompleteList started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType = " + searchType + " || startRow = " + startRow + " || endRow = " + endRow + " || orderCell = " + orderCell + " || orderOption = " + orderOption + " || tenantID = " + tenantID + " || companyID = " + companyID);

		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue.trim());
		map.put("searchType", searchType.trim());
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		List<CircularListVO> list = ezCircularDAO.getCircularCompleteList(map);
		
		logger.debug("getCircularCompleteList ended. listSize = " + list.size());
		
		return list;
	}

	@Override
	public int getCircularCompleteListCount(String memberID, String searchValue, String searchType, String sdate, String edate, String offset, int tenantID, String companyID, String lang) throws Exception {
		logger.debug("getCircularCompleteListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType = " + searchType + " || sdate = " + sdate + " || edate = " + edate + " || tenantID = " + tenantID + " || companyID = " + companyID);

		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue.trim());
		map.put("searchType", searchType.trim());
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		int result = ezCircularDAO.getCircularCompleteListCount(map);
		
		logger.debug("getCircularCompleteListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public int getCircularTempListCount(String memberID, String searchValue, String searchType, String sdate, String edate, String offset, int tenantID, String companyID, String lang) throws Exception {
		logger.debug("getCircularTempListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType = " + searchType + " || sdate = " + sdate + " || edate = " + edate + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue.trim());
		map.put("searchType", searchType.trim());
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		int result = ezCircularDAO.getCircularTempListCount(map);
		
		logger.debug("getCircularTempListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public List<CircularListVO> getCircularTempList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, String offset, int tenantID, String orderCell, String orderOption, String companyID, String lang) throws Exception {
		logger.debug("getCircularTempList started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType =  " + searchType + " || startRow = " + startRow + " || endRow = " + endRow + " || orderCell = " + orderCell + " || orderOption = " + orderOption + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue.trim());
		map.put("searchType", searchType.trim());
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		List<CircularListVO> list = ezCircularDAO.getCircularTempList(map);
		
		logger.debug("getCircularTempList ended. listSize = " + list.size());
		
		return list;
	}

	@Override
	public int getMyCircularListCount(String memberID, String searchValue, String searchType, String sdate, String edate, String offset, int tenantID, String companyID, String lang) throws Exception {
		logger.debug("getMyCircularListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType = " + searchType + " || sdate = " + sdate + " || edate = " + edate + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue.trim());
		map.put("searchType", searchType.trim());
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		int result = ezCircularDAO.getMyCircularListCount(map);
		
		logger.debug("getMyCircularListCount ended. result = " + result);
		
		return result; 
	}

	@Override
	public List<CircularListVO> getMyCircularList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, String offset, int tenantID, String orderCell, String orderOption, String companyID, String lang) throws Exception {
		logger.debug("getMyCircularList started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType =  " + searchType + " || startRow = " + startRow + " || endRow = " + endRow + " || orderCell = " + orderCell + " || orderOption = " + orderOption + " || tenantID = " + tenantID + " || companyID = " + companyID);

		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue.trim());
		map.put("searchType", searchType.trim());
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		List<CircularListVO> list = ezCircularDAO.getMyCircularList(map);
		
		logger.debug("getMyCircularList ended. listSize = " + list.size());
		
		return list;
	}

	@Override
	public List<CircularFolderVO> getTopFolder(String memberId, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberId", memberId);
		map.put("tenantId", tenantId);
		map.put("companyID", companyID);
		
		return ezCircularDAO.getTopFolder(map);
	}

	@Override
	public void circularClose(String circularIDList, int tenantID, String endDate) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantID", tenantID);
		map.put("endDate", endDate);
		
		for (String circularID : circularIDList.split(";")) {
			map.put("circularID", circularID);

			ezCircularDAO.circularClose(map);
		}
	}

	@Override
	public void circularFolderAdd(String folderName, String memberId, String regDate, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderName", folderName);
		map.put("memberId", memberId);
		map.put("regDate", regDate);
		map.put("tenantId", tenantId);
		map.put("companyID", companyID);
		
		ezCircularDAO.circularFolderAdd(map);
	}
	
	@Override
	public void circularFolderModify(String folderId, String folderName, String memberId, String regDate, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("folderName", folderName);
		map.put("memberId", memberId);
		map.put("regDate", regDate);
		map.put("tenantId", tenantId);
		
		ezCircularDAO.circularFolderModify(map);
	}

	@Override
	public void circularDeleteFolder(String deleteFolderId, String memberId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deleteFolderId", deleteFolderId);
		map.put("memberId", memberId);
		map.put("tenantId", tenantId);
		
		ezCircularDAO.circularDeleteFolder(map);
	}

	@Override
	public String getFolderInfo(int folderId, String memberId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("memberId", memberId);
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getFolderInfo(map);
	}

	@Override
	public int getCircularTDListCount(String memberID, String searchValue, String searchType, int tenantID, String companyID, String lang) throws Exception {
		logger.debug("getCircularTDListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchType", searchType.trim());
		map.put("searchValue", searchValue.trim());
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		int result = ezCircularDAO.getCircularTDListCount(map);
		
		logger.debug("getCircularTDListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public List<CircularListVO> getCircularTDList(String memberID, String searchValue, String searchType, int startRow, int endRow, int tenantID, String offset, String orderCell, String orderOption, String companyID, String lang) throws Exception {
		logger.debug("getCircularTDList started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType =  " + searchType + " || startRow = " + startRow + " || endRow = " + endRow + " || orderCell = " + orderCell + " || orderOption = " + orderOption + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchType", searchType.trim());
		map.put("searchValue", searchValue.trim());
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantID", tenantID);
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		List<CircularListVO> list = ezCircularDAO.getCircularTDList(map);
		
		logger.debug("getCircularTDList ended.");
		
		return list;
	}

	@Override
	public void circularDeleteTemp(String circularIDList, String memberId, int tenantId) throws Exception {
		logger.debug("circularDeleteTemp started.");
		logger.debug("circularIDList = " + circularIDList + " || memberID = " + memberId + " || tenantID = " + tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberId);
		map.put("tenantID", tenantId);
		
		for (String circularID : circularIDList.split(";")) {
			map.put("circularID", circularID);
		
			ezCircularDAO.tempDeleteCircular(map);
		}
		
		logger.debug("circularDeleteTemp ended.");
	}

	@Override
	public void moveCircular(String folderId, String circularIdList, String memberId, String updateStatus, String originLoc, int tenantId, String companyID) throws Exception {
		logger.debug("circularDeleteTemp started.");
		logger.debug("folderId : " + folderId + " | memberId : " + memberId + " | updateStatus : " + updateStatus + " | originLoc : " + originLoc + " || companyID = " + companyID);

		Map<String, Object> map = new HashMap<String, Object>();

		String[] circularIdArr = circularIdList.split(";");

		map.put("folderId", folderId);
		map.put("memberId", memberId);
		map.put("updateStatus", updateStatus);
		map.put("originLoc", originLoc);
		map.put("tenantId", tenantId);
		map.put("companyID", companyID);

		for (int i=0; i<circularIdArr.length; i++) {
			map.put("circularId", circularIdArr[i]);

			ezCircularDAO.moveCircular(map); // updateStatus 값 변경
			ezCircularDAO.moveCircular2(map); // Link 테이블에 Insert
		}
		
		logger.debug("moveCircular ended.");
	}

	@Override
	public int getFolderCircularListCount(String folderID, String memberID, String searchValue, String searchType, String sdate, String edate, String offset, int tenantID, String companyID, String lang) throws Exception {
		logger.debug("getFolderCircularListCount started.");
		logger.debug("folderID = " + folderID + " || memberID = " + memberID + " || searchValue = " + searchValue + " || searchType = " + searchType + " || sdate = " + sdate + " || edate = " + edate + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderID", folderID);
		map.put("memberID", memberID);
		map.put("searchType", searchType.trim());
		map.put("searchValue", searchValue.trim());
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		int result = ezCircularDAO.getFolderCircularListCount(map);
		
		logger.debug("getFolderCircularListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public List<CircularListVO> getFolderCircularList(String folderID, String memberID, int startRow, int endRow, String searchValue, String searchType, String sdate, String edate, String offset, int tenantID, String orderCell, String orderOption, String companyID, String lang) throws Exception {
		logger.debug("getFolderCircularList started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType =  " + searchType + " || startRow = " + startRow + " || endRow = " + endRow + " || orderCell = " + orderCell + " || orderOption = " + orderOption + " || tenantID = " + tenantID + " || companyID = " + companyID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderID", folderID);
		map.put("memberID", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("searchType", searchType.trim());
		map.put("searchValue", searchValue.trim());
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("lang", lang);
		
		List<CircularListVO> list = ezCircularDAO.getFolderCircularList(map);
		
		logger.debug("getFolderCircularList ended. listSize = " + list.size());
		
		return list;
	}

	@Override
	public void updateFolderId(String folderId, String circularIdList, String memberId, int tenantId) throws Exception {
		logger.debug("updateFolderId started.");
		logger.debug("folderId : " + folderId);

		String[] circularIdArr = circularIdList.split(";");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("memberId", memberId);
		map.put("tenantId", tenantId);
		
		for (int i=0; i<circularIdArr.length; i++) {
			map.put("circularId", circularIdArr[i]);
			
			ezCircularDAO.updateFolderId(map);
		}
		
		logger.debug("updateFolderId ended.");
	}

	@Override
	public String getItemXML(String circularID, String memberID, String offset, int tenantID, String lang) throws Exception {
		logger.debug("getItemXML started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || tenantID = " + tenantID);
		
		StringBuilder sb = new StringBuilder();
		
		if (circularID != null) {
			CircularListVO itemInfo  = getCircular(circularID, memberID, offset, tenantID, "read", lang);
			
			sb.append("<NODES>");
			sb.append("<NODE>");
			sb.append("<CircularId>" + itemInfo.getCircularID() + "</CircularId>");
			sb.append("<Importance>" + itemInfo.getImportance() + "</Importance>");
			sb.append("<HasFile>" + itemInfo.getHasFile() + "</HasFile>");
			sb.append("<Status>" + itemInfo.getStatus() + "</Status>");
			sb.append("<Title><![CDATA[" + itemInfo.getTitle() + "]]></Title>");
			sb.append("<MemberId>" + itemInfo.getMemberID() + "</MemberId>");
			sb.append("<MemberName>" + itemInfo.getMemberName() + "</MemberName>");
			sb.append("<RegDate>" + itemInfo.getRegDate() + "</RegDate>");
			sb.append("<Option>" + itemInfo.getOption() + "</Option>");
			sb.append("<MemberFile>" + itemInfo.getUserImageFile() + "</MemberFile>");
			sb.append("<Content>" + commonUtil.cleanValue(itemInfo.getContent()) + "</Content>");
			sb.append("</NODE>");
			sb.append("</NODES>");
		} else {
			sb.append("<NODES>");
			sb.append("</NODES>");
		}
		
		logger.debug("result = " + sb.toString());
		logger.debug("getItemXML ended.");

		return sb.toString();
	}

	@Override
	public List<CircularCommentVO> getCircularComment(CircularCommentVO vo, String searchType, String searchValue, String circularUserID, String commentType, String offset, int tenantID) throws Exception {
		logger.debug("getCircularComment started.");
		logger.debug("circularID = " + vo.getCircularID() + " || searchValue = " + searchValue + " || circularUserID = " + circularUserID + " || commentType = " + commentType + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", vo.getCircularID());
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);
		map.put("circularUserID", circularUserID);
		map.put("commentType", commentType);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		List<CircularCommentVO> list = ezCircularDAO.getCircularComment(map);
		
		logger.debug("getCircularComment ended. listSize=" + list.size());
		
		return list;
	}
	
	@Override
	public int getCommentCount(String circularID, String memberID, String type, int tenantID) throws Exception {
		logger.debug("getCommentCount started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || type = " + type + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		map.put("type", type);
		
		int result = ezCircularDAO.getCommentCount(map);
		
		logger.debug("getCommentCount ended. result = " + result);
		
		return result;
	}

	@Override
	public void editCircularComment(CircularCommentVO vo, LoginVO userInfo, String loginCookie) throws Exception {
		logger.debug("editCircularComment started.");
		logger.debug("circularID = " + vo.getCircularID() + " || circularUserID = " + vo.getCircularUserID() + " || circularComment = " + vo.getCircularComment() + " || memberID = " + userInfo.getId() + " || memberName = " + userInfo.getDisplayName() + " || memberName2 = " + userInfo.getDisplayName2() + " || status = " + vo.getStatus());
		
		String nowDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", vo.getCircularID());
		map.put("circularUserID", vo.getCircularUserID());
		map.put("circularComment", vo.getCircularComment());
		map.put("memberID", userInfo.getId());
		map.put("memberName", userInfo.getDisplayName1());
		map.put("memberName2", userInfo.getDisplayName2());
		map.put("status", vo.getStatus());// 0공개, 1비공개
		map.put("nowDate", nowDate);
		map.put("tenantID", userInfo.getTenantId());
    	
		CircularListVO circularVO = getCircular(vo.getCircularID(), vo.getCircularUserID(), userInfo.getOffset(), userInfo.getTenantId(), "comment", userInfo.getLang());
    	List<CircularCommentVO> list = getCircularCommentUserList(vo.getCircularID(), vo.getCircularUserID(), userInfo.getTenantId(), "circularComment");
    	
		String circularCommentID = ezCircularDAO.insertComment(map);
		
		if (!vo.getCircularUserID().equals(userInfo.getId())) {
			updateCircularCommentStatus(vo.getCircularID(), vo.getCircularUserID(), 1, 0, nowDate, userInfo.getTenantId());
			insertCommentState(circularCommentID, vo.getCircularUserID(), 0, nowDate, userInfo.getTenantId());
			
			if (circularVO.getUpdateStatus() == 2) {
				map = new HashMap<String, Object>();
				map.put("circularID", vo.getCircularID());
				map.put("memberID", vo.getCircularUserID());
				map.put("tenantID", userInfo.getTenantId());
				
				ezCircularDAO.updateCircularStatus(map);
			}
		}
		
		if (!vo.getCircularUserID().equals(userInfo.getId())) {
			String subject = egovMessageSource.getMessage("ezCircular.t163", userInfo.getLocale());
    	
			StringBuilder bodyContent = new StringBuilder("");
			bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='circular_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezCircular/circularRead.do?circularID=" + circularVO.getCircularID() + "&type=new', '', 'width=820, height=900')\">" + commonUtil.cleanValue(circularVO.getTitle()) + "</span></br>");
			bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t164", userInfo.getLocale()) + " : " + userInfo.getDisplayName());
			
			String content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
			
			InternetAddress from = new InternetAddress();
			from.setPersonal(userInfo.getDisplayName(), "UTF-8");
			from.setAddress(userInfo.getEmail());
			
			for (CircularCommentVO commentVO : list) {
				if (vo.getCircularUserID().equals(commentVO.getMemberID())) {
					InternetAddress to = new InternetAddress();
					to.setPersonal(commentVO.getMemberName(), "UTF-8");
					to.setAddress(commentVO.getMail());

					ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
				}
			}
    	}

		logger.debug("editCircularComment ended.");
	}

	@Override
	public CircularAttachVO getAttachInfo(String circularFileID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularFileID", circularFileID);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getAttachInfo(map);
	}
	
	@Override
	public void confirmStatus(String circularID, String memberID, int tenantID, String type) throws Exception {
		logger.debug("confirmStatus started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || tenantID = " + tenantID);
		
		String nowDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		if (type.equals("circularConfirm")) {
			updateUpdateStatus(circularID, memberID, nowDate, tenantID);
			updateConfirmStatus(circularID, memberID, 1, nowDate, tenantID);
		} else if (type.equals("commentConfirm")) {
			updateCommentState(circularID, "", memberID, 1, nowDate, tenantID);
			updateCircularCommentStatus(circularID, memberID, 0, 0, nowDate, tenantID);
//			updateCircularShareStatus(circularID, memberID, 0, 0, nowDate, tenantID);
		} else {
			updateUpdateStatus(circularID, memberID, nowDate, tenantID);
			updateConfirmStatus(circularID, memberID, 1, nowDate, tenantID);
			updateCircularCommentStatus(circularID, memberID, 0, 0, nowDate, tenantID);
//			updateCircularShareStatus(circularID, memberID, 0, 0, nowDate, tenantID);
			updateCommentState(circularID, "", memberID, 1, nowDate, tenantID);
		}
		
		logger.debug("confirmStatus ended.");
	}
	
	private void updateConfirmStatus(String circularID, String circularUserID, int status, String confirmDate, int tenantID) throws Exception {
		logger.debug("updateReadStatus started.");
		logger.debug("circularID = " + circularID + " || circularUserID = " + circularUserID + " || status = " + status + " || confirmDate = " + confirmDate + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", circularUserID);
		map.put("status", status);
		map.put("confirmDate", confirmDate);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.updateConfirmStatus(map);
		
		logger.debug("updateReadStatus ended.");
	}
	
	private void updateUpdateStatus(String circularID, String memberID, String nowDate, int tenantID) throws Exception {
		logger.debug("updateUpdateStatus started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.updateUpdateStatus(map);
		
		logger.debug("updateUpdateStatus ended.");
	}
	
	private void updateCircularCommentStatus(String circularID, String memberID, int commentStatus, int deleteStatus, String nowDate, int tenantID) throws Exception {
		logger.debug("updateCircularCommentStatus started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || commentStatus = " + commentStatus + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("commentStatus", commentStatus);
		map.put("deleteStatus", deleteStatus);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
				
		ezCircularDAO.updateCircularCommentStatus(map);
		
		logger.debug("updateCircularCommentStatus ended.");
	}
	
//	private void updateCircularShareStatus(String circularID, String memberID, int shareStatus, int deleteStatus, String nowDate, int tenantID) throws Exception {
//		logger.debug("updateCircularShareStatus started.");
//		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || shareStatus = " + " || tenantID = " + tenantID);
//		
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("circularID", circularID);
//		map.put("memberID", memberID);
//		map.put("shareStatus", shareStatus);
//		map.put("deleteStatus", deleteStatus);
//		map.put("nowDate", nowDate);
//		map.put("tenantID", tenantID);
//		
//		ezCircularDAO.updateCircularShareStatus(map);
//		
//		logger.debug("updateCircularShareStatus ended.");
//	}
	
	private void updateCommentState(String circularID, String circularCommentID, String memberID, int confirmStatus, String nowDate, int tenantID) throws Exception {
		logger.debug("updateCommentState started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("circularCommentID", circularCommentID);
		map.put("memberID", memberID);
		map.put("status", confirmStatus);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.updateCommentState(map);
		
		logger.debug("updateCommentState ended.");
	}
	
	@Override
	public List<CircularCommentVO> getCircularCommentUserList(String circularID, String circularUserID, int tenantID, String type) throws Exception {
		logger.debug("getCircularCommentUserList started.");
		logger.debug("circularID = " + circularID + " || circularUserID = " + circularUserID + " || type = " + type + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", circularUserID);
		map.put("tenantID", tenantID);
		map.put("type", type);
		
		List<CircularCommentVO> list = ezCircularDAO.getCircularCommentUserList(map);
		
		logger.debug("getCircularCommentUserList ended. listSize = " + list.size());
		
		return list;
	}

	@Override
	public void deleteCircularComment(CircularCommentVO vo, LoginVO userInfo) throws Exception {
		logger.debug("deleteCircularComment started.");
		logger.debug("circularID = " + vo.getCircularID() + " || circularCommentID = " + vo.getCircularCommentID() + " || memberID = " + userInfo.getId() + " || tenantID = " + userInfo.getTenantId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", vo.getCircularID());
		map.put("circularCommentID", vo.getCircularCommentID());
		map.put("memberID", userInfo.getId());
		map.put("tenantID", userInfo.getTenantId());
		
		ezCircularDAO.deleteCommentState(map);
		ezCircularDAO.deleteCircularComment(map);
		
		logger.debug("deleteCircularComment ended.");
	}

	@Override
	public List<CircularListVO> getUserList(String memberID, int tenantID) throws Exception {
		logger.debug("getUserList started.");
		logger.debug("memberID = " + memberID + " || tenantID = " + tenantID);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);

		List<CircularListVO> list = ezCircularDAO.getUserList(map);
		
		logger.debug("getUserList ended. listSize = " + list.size());
		
		return list;
	}

	@Override
	public List<CircularListHeaderVO> getListHeader(String listType, String lang, int tenantID) throws Exception {
		logger.debug("getListHeader started.");
		logger.debug("listType = " + listType + " || lang = " + lang + " || tenantID = " + tenantID);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listType", listType);
		map.put("lang", lang);
		map.put("tenantID", tenantID);

		List<CircularListHeaderVO> list = ezCircularDAO.getListHeader(map);
		
		logger.debug("getListHeader ended. listSize = " + list.size());

		return list;
	}

	@Override
	public void circularReturn(String circularIdList, String folderID, String memberID, int tenantID) throws Exception {
		logger.debug("circularReturn started.");
		logger.debug("circularIDList = " + circularIdList + " || memberID = " + memberID + " || tenantID");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		for (String circularID : circularIdList.split(";")) {
			logger.debug("circularID = " + circularID);
			map.put("circularID", circularID);
			
			ezCircularDAO.updateCircularStatus(map);
			ezCircularDAO.moveCircular3(map); // LINK 테이블에서 제거
		}

		logger.debug("circularReturn ended.");
	}

	@Override
	public int getListCount(String listType, String userID, int tenantID, String companyID) throws Exception {
		logger.debug("getListCount started.");
		logger.debug("listType = " + listType);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listType", listType);
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		int count= ezCircularDAO.getListCount(map);
		
		logger.debug("getListCount ended. count = " + count);
		
		return count;
	}

	@Override
	public void commentShareUser(String circularID, String circularCommentID, String memberIDList, LoginVO userInfo, String loginCookie) throws Exception {
		logger.debug("commentShareUser started.");
		logger.debug("circularID = " + circularID + " || memberIDList = " + memberIDList);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		CircularListVO circularVO = getCircular(circularID, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "comment", userInfo.getLang());
		
		String nowDate = commonUtil.getTodayUTCTime("");
		int tenantID = userInfo.getTenantId();
		
		String subject = egovMessageSource.getMessage("ezCircular.t123", userInfo.getLocale());
    	StringBuilder bodyContent = new StringBuilder("");
    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='circular_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezCircular/circularRead.do?circularID=" + circularID + "&type=new', '', 'width=820, height=900')\">" + commonUtil.cleanValue(circularVO.getTitle()) + "</span></br>");
    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t164", userInfo.getLocale()) + " : " + userInfo.getDisplayName());
    	
    	String content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
    	
    	InternetAddress from = new InternetAddress();
		from.setPersonal(userInfo.getDisplayName(), "UTF-8");
		from.setAddress(userInfo.getEmail());
		
		String memberIDs[] = memberIDList.split(";");
		
		for (String memberID : memberIDs) {
			updateCircularCommentStatus(circularID, memberID, 1, 0, nowDate, tenantID);
			
			String commentStateID = getCommentStateID(circularCommentID, memberID, tenantID);
			
			if (commentStateID == null) {
				insertCommentState(circularCommentID, memberID, 0, nowDate, tenantID);
			} else {
				updateCommentState(circularID, circularCommentID, memberID, 0, nowDate, tenantID);
			}
			
			circularVO = getCircular(circularID, memberID, userInfo.getOffset(), userInfo.getTenantId(), "comment", userInfo.getLang());
			
			if (circularVO.getUpdateStatus() == 2) {
				map = new HashMap<String, Object>();
				map.put("circularID", circularID);
				map.put("memberID", memberID);
				map.put("tenantID", userInfo.getTenantId());
				
				ezCircularDAO.updateCircularStatus(map);
			}
			
			OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(memberID, userInfo.getPrimary(), tenantID);
	    	
			if (AccessUserInfo != null) {
				InternetAddress to = new InternetAddress();
				to.setPersonal(AccessUserInfo.getDisplayName(), "UTF-8");
				to.setAddress(AccessUserInfo.getMail());
				
				ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
			}
		}
		
		logger.debug("commentShareUser ended.");
	}
	
	@Override
	public void restoreCircular(String circularIDList, String memberID, int tenantID) throws Exception {
		logger.debug("restoreCircular started.");
		logger.debug("circularIDList = " + circularIDList);
		logger.debug("memberID = " + memberID + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		for (String circularID : circularIDList.split(";")) {
			map.put("circularID", circularID);
			
			ezCircularDAO.restoreCircular(map);
		}
		
		logger.debug("restoreCircular ended.");
	}

	private String getCommentStateID(String circularCommentID, String memberID, int tenantID) throws Exception {
		logger.debug("getCommentStateID started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularCommentID", circularCommentID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		String result = ezCircularDAO.getCommentStateID(map);
		
		logger.debug("getCommentStateID ended. commentStateID = " + result);
		
		return result;
	}
	
	private void insertCommentState(String circularCommentID, String memberID, int status, String nowDate, int tenantID) throws Exception {
		logger.debug("insertCommentState started.");
		logger.debug("circularCommentID = " + circularCommentID + " || memberID = " + memberID + " || status = " + status + " || nowDate = " + nowDate + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularCommentID", circularCommentID);
		map.put("memberID", memberID);
		map.put("status", status);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.insertCommentState(map);
		
		logger.debug("insertCommentState ended.");
	}

	@Override
	public int checkFolder(String deleteFolder, String memberID, int tenantID) throws Exception {
		logger.debug("checkFolder started.");
		logger.debug("folderID : " + deleteFolder);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("folderID", deleteFolder);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		int deleteListCount = ezCircularDAO.checkFolder(map);

		logger.debug("deleteListCount : " + deleteListCount);
		logger.debug("checkFolder ended.");

		return deleteListCount;
	}
	
	/* 18-05-28 김민성 - 확인자 목록 조회 */
	@Override
	public StringBuffer getConfirmMemberList(String circularID, int pageNum, int perCount, String offset, LoginVO userInfo) throws Exception {
		logger.debug("getConfirmMemberList started");
    	if(pageNum == 0){
    		pageNum = 1;
    	}
    	
    	int startRowNum = ((pageNum - 1) * perCount);
    	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("tenantID", userInfo.getTenantId());
		map.put("start", startRowNum);
		map.put("perCount", perCount);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("companyID", userInfo.getCompanyID());
		map.put("primary", userInfo.getPrimary());
		
		List<CircularConfirmVO> list = ezCircularDAO.getConfirmMember(map);
		
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		
		int totalCount = ezCircularDAO.getConfirmMemberCount(map);
		int totalPage = (int) Math.floor(totalCount / perCount);
		if(totalCount % 10 != 0){
			totalPage = totalPage + 1;
		}
		
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + totalPage + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + perCount + "</PERSONALCNT>");
    	resultXML.append("<LISTVIEWDATA>");
    	
		resultXML.append("<ROWS>");
		for (CircularConfirmVO vo : list) {
			String userTitle = "";		// 직책
			String userDeptName = "";	// 부서
			
			if(vo.getTitle()!= null){
				userTitle = vo.getTitle();
			}
			if( vo.getDescription() != null){
				userDeptName =  vo.getDescription();
			}
			resultXML.append("<ROW>");
			resultXML.append("<CELL><USERID><![CDATA[" + vo.getMemberID() + "]]></USERID>" + "<DEPTID><![CDATA[" + vo.getDeptID() + "]]></DEPTID>" + "<VALUE><![CDATA[" + vo.getDisplayName()+ "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + userDeptName + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + userTitle + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + commonUtil.getDateStringInUTC(vo.getConfirmDate(), offset, false) + "]]></VALUE></CELL>");			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		
		logger.debug(resultXML.toString());
		
		logger.debug("getConfirmMemberList ended");
		return resultXML;
	}
	
	/* 2018-07-03 김민성 - deptID 조회 */
	@Override
	public CircularMemberVO getCircularUserDeptId(int tenantID,  String companyID, String circularUserID) throws Exception {
		logger.debug("getConfirmMemberList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("circularUserID", circularUserID);
		
		logger.debug("getConfirmMemberList ended");
		
		return ezCircularDAO.getCircularUserDeptId(map);
	}

}
