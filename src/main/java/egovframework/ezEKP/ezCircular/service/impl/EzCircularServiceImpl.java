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
public class EzCircularServiceImpl implements EzCircularService {
	
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
	public List<CircularListVO> getCircularList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, int tenantID, String offset, String orderCell, String orderOption1) throws Exception {
		logger.debug("getCircularList started.");
		logger.debug("memberID = " + memberID + " || startRow = " + startRow + " || endRow = " + endRow + " || tenantID = " + tenantID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("searchType", searchType);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantID", tenantID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("orderCell", orderCell);
		map.put("orderOption1", orderOption1);
		
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
		
		circularID = ezCircularDAO.insertCircular(map);
		
		for (int i=0; i<receiverLength; i++) {
			insertCircularUser(circularUserId, circularID, receiverID[i].trim(), receiverName[i].trim(), receiverName2[i].trim(), status, "", updateStatus, userInfo.getTenantId());
		}
		
		//첨부파일 저장
		Map<String, Object> attachMap = new HashMap<String, Object>();
		
		if (fileList != null && !fileList.equals("")) {		
			File file = new File(pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + circularID + "_uploadFile");

			if (!file.exists()) {
	        	file.mkdir();
	        }

			int fileLength = fileList.split(",").length;
			String[] fileLists = fileList.split(",");
			
			attachMap.put("circularID", circularID);
			attachMap.put("tenantID", userInfo.getTenantId());
			
			for (int j=0; j<fileLength; j++) {
				String[] files = fileLists[j].split(";");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];
				
				logger.debug("filePath : " + filePath + " | fileName : " + fileName);
				
				String uploadFilePath = commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + ";" + fileName;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;

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
			if (status != 2) {
				String subject = egovMessageSource.getMessage("ezCircular.t172", userInfo.getLocale());
				StringBuilder bodyContent = new StringBuilder("");
				bodyContent.append("<div id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
				bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + title + " </br>");
		    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t122", userInfo.getLocale()) + " : " + userInfo.getId());
		    	bodyContent.append("</div>");

				for (int i=0; i<receiverLength; i++) {
					OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(receiverID[i].trim(), userInfo.getPrimary(), userInfo.getTenantId());
					
					InternetAddress from = new InternetAddress();
					from.setPersonal(userInfo.getDisplayName(), "UTF-8");
					from.setAddress(userInfo.getEmail());
					
					InternetAddress to = new InternetAddress();
					
					if (!receiverID[i].trim().equals(userInfo.getId())) {
						to.setPersonal(receiverName[i].trim(), "UTF-8");
						to.setAddress(AccessUserInfo.getMail());
						
						ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
					}
				}	
			}
		}

		logger.debug("insertCircular ended.");
	}

	private void fileMove(String beforeFilePath, String afterFilePath) throws Exception {
		logger.debug("fileMove started.");

		File file = new File(beforeFilePath);

		try {
			file.renameTo(new File(afterFilePath));
		} catch (Exception e) {
			e.printStackTrace();
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
			File originFile = new File(pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + fileName); // 복사할 파일의 경로
			File copyFilePath = new File(pDirPath + "tempUploadFile" + commonUtil.separator + fileName);

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
			e.printStackTrace();
		} finally {
			try {
				fis.close();
				fos.close();
				br.close();
				bw.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public void insertCircularUser(int circularUserID, int circularID, String memberID, String memberName, String memberName2, int status, String confirmDate, int updateStatus, int tenantID) throws Exception {
		logger.debug("insertCircularUser started.");
		logger.debug("circularUserID = " + circularUserID + " || circularID = " + circularID + " || memberID = " + memberID + " || confirmDate = " + confirmDate + " || status = " + status + " || updateStatus = " + updateStatus + " || tenantID = " + tenantID);
		
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
		
		ezCircularDAO.insertCircularUser(map);
		
		logger.debug("insertCircularUser ended.");
	}

	@Override
	public CircularListVO getCircular(String circularID, String memberID, String offset, int tenantID, String type) throws Exception {
		logger.debug("getCircular started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || type = " + type + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		
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
			insertCircularUser(circularUserId, Integer.parseInt(circularID), receiverID[i].trim(), receiverName[i].trim(), receiverName2[i].trim(), status, "", updateStatus, tenantID);

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
			int fileLength = fileList.split(",").length;
			String[] fileLists = fileList.split(",");

			logger.debug("updateCircular fileList : " + fileList);

			attachMap.put("circularID", circularID);
			attachMap.put("tenantID", tenantID);
			
			for (int j=0; j<fileLength; j++) {
				String[] files = fileLists[j].split(";");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];
				
				logger.debug("filePath : " + filePath + " | fileName : " + fileName);
				
				String uploadFilePath = commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
				
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);

				logger.debug("uploadFilePath : " + uploadFilePath);

//				ezCircularDAO.updateCircularAttach(attachMap);
				ezCircularDAO.insertCircularAttach(attachMap);

				// mode = modify -> 회람수정 일 때이므로 수정 시 Temp 폴더에서 첨부파일 이동
				if (mode.equals("modify")) {
					String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + ";" + fileName;
					String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
					
					fileMove(beforeFilePath, afterFilePath); // Temp 폴더에서 첨부파일 이동					
				}
			}
		}
		
		// 회람자에게 메일 발송
		if (option == 2 || option == 3) {
			String subject = egovMessageSource.getMessage("ezCircular.t172", userInfo.getLocale());
			StringBuilder bodyContent = new StringBuilder("");
			bodyContent.append("<div id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
			bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + title + " </br>");
	    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t122", userInfo.getLocale()) + " : " + userInfo.getId());
	    	bodyContent.append("</div>");

			for (int i=0; i<receiverLength; i++) {
				OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(receiverID[i].trim(), userInfo.getPrimary(), userInfo.getTenantId());
				
				InternetAddress from = new InternetAddress();
				from.setPersonal(userInfo.getDisplayName(), "UTF-8");
				from.setAddress(userInfo.getEmail());
				
				InternetAddress to = new InternetAddress();
				
				if (!receiverID[i].trim().equals(userInfo.getId())) {
					to.setPersonal(receiverName[i].trim(), "UTF-8");
					to.setAddress(AccessUserInfo.getMail());
					
					ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
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
			String[] receiverName, String[] receiverName2, String offset) throws Exception {
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
		
		ezCircularDAO.modifyCircular(map);
		
		List<CircularListVO> list = getCircularUserList(circularID, "", tenantID, offset);
		
		logger.debug("receiverLength : " + receiverLength);
		logger.debug("listSize : " + list.size());
		
		//회람자 삭제 후 등록
		deleteCircularUser(circularID, tenantID);
		
		for (int i=0; i<receiverLength; i++) {
			insertCircularUser(circularUserId, circularID, receiverID[i].trim(), receiverName[i].trim(), receiverName2[i].trim(), status, confirmDate, updateStatus, tenantID);
		}
		
		//첨부파일 삭제 후 등록
		ezCircularDAO.deleteCircularAttach(map);
		
		Map<String, Object> attachMap = new HashMap<String, Object>();
		
		if (fileList != null && !fileList.equals("")) {
			File file = new File(pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + circularID + "_uploadFile");

			if (!file.exists()) {
	        	file.mkdir();
	        }

			logger.debug("modify fileList : " + fileList);
			
			int fileLength = fileList.split(",").length;
			String[] fileLists = fileList.split(",");
			
			attachMap.put("circularID", circularID);
			attachMap.put("tenantID", tenantID);
			
			for (int j=0; j<fileLength; j++) {
				String[] files = fileLists[j].split(";");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];
				
				logger.debug("filePath : " + filePath + " | fileName : " + fileName);
				
				String uploadFilePath = commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + ";" + fileName;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;

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
	public void deleteCircularList(String circularIDListInfo, String strMemberListInfo, String pDirpath, String userID, int tenantID) throws Exception {
		logger.debug("deleteCircularList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String[] strMemberList = strMemberListInfo.split(";");
		String[] circularIDList = circularIDListInfo.split(";");

		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		for (int i=0; i<circularIDList.length; i++) {
			String idInfo = circularIDList[i] + "/" + strMemberList[i];
			
			String[] idsArr = idInfo.split("/");
			String circularID = idsArr[0];
			String memberID = idsArr[1];

			deleteDirectory(circularID, pDirpath, tenantID);

			logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || userID = " + userID + " || tenantID = " + tenantID);
			
			map.put("circularID", circularID);
			map.put("memberID", memberID);
			
			if (memberID.equals(userID)) {
				ezCircularDAO.deleteCircular(map);
				ezCircularDAO.deleteCircularUser(map);
				ezCircularDAO.deleteCircularAttach(map);
			} else {
				ezCircularDAO.updateDeleteFlag(map);
			}
		}
		
		logger.debug("deleteCircularList ended.");
	}
	
	private void deleteDirectory (String circularID, String pDirpath, int tenantID) throws Exception {
		logger.debug("deleteDirectory ended.");
		
		File directoryFile = new File(pDirpath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile");
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
	public void deleteCircular (String circularID, String memberID, String userID, int tenantID) throws Exception {
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
	public int getCircularListCount(String memberID, String searchValue, String searchType, String sdate, String edate, String offset, int tenantID) throws Exception {
		logger.debug("getCircularListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || searchType = " + searchType + " || sdate = " + sdate + " || edate = " + edate + " || tenantID = " + tenantID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("searchType", searchType);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("offset", offset);
		map.put("tenantID", tenantID);
		
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
	public void set_circularDeptSave(CircularDeptVO circularDeptVO, String[] memberListStr) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
				
		ezCircularDAO.set_circularDeptSave(circularDeptVO);
		
		int tenantId = circularDeptVO.getTenantID();
		int circularBMId = ezCircularDAO.getCircularBMId(); // CircularBMId 값 가져옴
		
		map.put("CIRCULARBMID", circularBMId);
		map.put("TENANTID", tenantId);
		
		for (int i=0; i<memberListStr.length; i++) {
			String memberStr = memberListStr[i].trim();
			
			map.put("v_MEMBERID", memberStr);
			
			ezCircularDAO.set_circularMemberList(map);
		}
	}

//	@Override
//	public String getcircularDeptList(CircularDeptVO circularDeptVO, LoginVO userInfo) throws Exception {
//		logger.debug("getcircularDeptList started.");
//		
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("memberID", circularDeptVO.getMemberID());
//		map.put("tenantID", userInfo.getTenantId());
//		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffset()));
//		
//		List<CircularDeptVO> list = ezCircularDAO.getcircularDeptList(map);
//		
//		StringBuilder sb = new StringBuilder("<DATA>");
//		
//		for (CircularDeptVO vo : list) {
//			sb.append(commonUtil.getQueryResult(vo));
//		}
//		sb.append("</DATA>");
//		
//		logger.debug("getcircularDeptList ended.");
//		
//		return sb.toString();
//	}
	
	@Override
	public List<CircularDeptVO> getcircularDeptList(CircularDeptVO circularDeptVO, LoginVO userInfo) throws Exception {
		logger.debug("getcircularDeptList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("memberID", circularDeptVO.getMemberID());
		map.put("tenantID", userInfo.getTenantId());
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffset()));

		logger.debug("getcircularDeptList ended.");

		return (List<CircularDeptVO>) ezCircularDAO.getcircularDeptList(map);
	}

	@Override
	public void circularDeptDel(String[] delList, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANTID", tenantId);
		
		for (int i=0; i<delList.length; i++) {
			String circularBMId = delList[i];
			
			map.put("v_CIRCULARBMID", circularBMId);
			
			ezCircularDAO.circularDeptDel(map);
		}
		
	}

	@Override
	public void update_circularDept(CircularDeptVO circularDeptVO, String[] memberListStr, String circularBMId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("TITLE", circularDeptVO.getTitle());
		map.put("CIRCULARBMID", Integer.parseInt(circularBMId));
		map.put("TENANTID", circularDeptVO.getTenantID());
		map.put("MEMBERID", circularDeptVO.getMemberID());
		
		ezCircularDAO.update_circularDept(map);
		ezCircularDAO.delete_circularMemberList(map);
		
		for (int i=0; i<memberListStr.length; i++) {	
			String memberStr = memberListStr[i].trim();
			
			map.put("v_MEMBERID", memberStr);
			
			ezCircularDAO.set_circularMemberList(map);
		}
	}

	@Override
	public List<CircularMemberVO> circularDeptModify(int circularBMId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CIRCULARBMID", circularBMId);
		map.put("v_TENANTID", tenantId);
		
		return ezCircularDAO.getMemberName(map);
	}

	@Override
	public List<CircularListVO> getCircularUserList(int circularID, String searchValue, int tenantID, String offset) throws Exception {
		logger.debug("getCircularUserList started.");
		logger.debug("circularID = " + circularID + " || searchValue = " + searchValue + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
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
	
	public List<CircularMemberVO> getMemberName(int circularBMId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CIRCULARBMID", circularBMId);
		map.put("v_TENANTID", tenantId);
		
		return ezCircularDAO.getMemberName(map);
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
	public List<CircularListVO> getCircularCompleteList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, int tenantID, String offset, String orderCell, String orderOption1) throws Exception {
		logger.debug("getCircularCompleteList started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || startRow = " + startRow + " || endRow = " + endRow + " || tenantID = " + tenantID);

		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("searchType", searchType);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("orderCell", orderCell);
		map.put("orderOption1", orderOption1);
		
		List<CircularListVO> list = ezCircularDAO.getCircularCompleteList(map);
		
		logger.debug("getCircularCompleteList ended. listSize = " + list.size());
		
		return list;
	}

	@Override
	public int getCircularCompleteListCount(String memberID, String searchValue, String searchType, String sdate, String edate, int tenantID) throws Exception {
		logger.debug("getCircularCompleteListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || tenantID = " + tenantID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("searchType", searchType);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("tenantID", tenantID);
		
		int result = ezCircularDAO.getCircularCompleteListCount(map);
		
		logger.debug("getCircularCompleteListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public int getCircularTempListCount(String memberID, String searchValue, String searchType, String sdate, String edate, int tenantID) throws Exception {
		logger.debug("getCircularTempListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || tenantID = " + tenantID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("searchType", searchType);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("tenantID", tenantID);
		
		int result = ezCircularDAO.getCircularTempListCount(map);
		
		logger.debug("getCircularTempListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public List<CircularListVO> getCircularTempList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, String offset, int tenantID, String orderCell, String orderOption1) throws Exception {
		logger.debug("getCircularTempList started.");
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("searchType", searchType);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("orderCell", orderCell);
		map.put("orderOption1", orderOption1);
		
		List<CircularListVO> list = ezCircularDAO.getCircularTempList(map);
		
		logger.debug("getCircularTempList ended. listSize = " + list.size());
		
		return list;
	}

	@Override
	public int getMyCircularListCount(String memberID, String searchValue, String searchType, String sdate, String edate, int tenantID) throws Exception {
		logger.debug("getMyCircularListCount started.");
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("searchType", searchType);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("tenantID", tenantID);
		
		int result = ezCircularDAO.getMyCircularListCount(map);
		
		logger.debug("getMyCircularListCount ended. result = " + result);
		
		return result; 
	}

	@Override
	public List<CircularListVO> getMyCircularList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, String offset, int tenantID, String orderCell, String orderOption1) throws Exception {
		logger.debug("getMyCircularList started.");
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("searchType", searchType);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("orderCell", orderCell);
		map.put("orderOption1", orderOption1);
		
		List<CircularListVO> list = ezCircularDAO.getMyCircularList(map);
		
		logger.debug("getMyCircularList ended. listSize = " + list.size());
		
		return list;
	}

	@Override
	public List<CircularFolderVO> getTopFolder(String memberId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberId", memberId);
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getTopFolder(map);
	}

	@Override
	public void circularClose(String circularIDList, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantID", tenantID);
		
		for (String circularID : circularIDList.split(";")) {
			map.put("circularID", circularID);

			ezCircularDAO.circularClose(map);
		}
	}

	@Override
	public void circularFolderAdd(String folderName, String memberId, String regDate, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderName", folderName);
		map.put("memberId", memberId);
		map.put("regDate", regDate);
		map.put("tenantId", tenantId);
		
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
	public int getCircularTDListCount(String memberID, String searchValue, String searchType, int tenantID) throws Exception {
		logger.debug("getCircularTDListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);
		map.put("tenantID", tenantID);
		
		int result = ezCircularDAO.getCircularTDListCount(map);
		
		logger.debug("getCircularTDListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public List<CircularListVO> getCircularTDList(String memberID, String searchValue, String searchType, int startRow, int endRow, int tenantID, String offset, String orderCell, String orderOption1) throws Exception {
		logger.debug("getCircularTDList started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || startRow = " + startRow + " || endRow = " + endRow + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantID", tenantID);
		map.put("orderCell", orderCell);
		map.put("orderOption1", orderOption1);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
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
	public void moveCircular(String folderId, String circularIdList, String memberId, String updateStatus, String originLoc, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String[] circularIdArr = circularIdList.split(";");

		map.put("folderId", folderId);
		map.put("memberId", memberId);
		map.put("updateStatus", updateStatus);
		map.put("originLoc", originLoc);
		map.put("tenantId", tenantId);
		
		for (int i=0; i<circularIdArr.length; i++) {
			map.put("circularId", circularIdArr[i]);

			ezCircularDAO.moveCircular(map); // updateStatus 값 변경
			ezCircularDAO.moveCircular2(map); // Link 테이블에 Insert
		}
	}

	@Override
	public int getFolderCircularListCount(String folderID, String memberID, String searchValue, String searchType, String sdate, String edate, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}

		map.put("folderID", folderID);
		map.put("memberID", memberID);
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getFolderCircularListCount(map);
	}

	@Override
	public List<CircularListVO> getFolderCircularList(String folderID, String memberID, int startRow, int endRow, String searchValue, String searchType, String sdate, String edate, String offset, int tenantID, String orderCell, String orderOption1) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		map.put("folderID", folderID);
		map.put("memberID", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("orderCell", orderCell);
		map.put("orderOption1", orderOption1);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getFolderCircularList(map);
	}

	@Override
	public void updateFolderId(String folderId, String circularIdList, String memberId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String[] circularIdArr = circularIdList.split(";");

		map.put("folderId", folderId);
		map.put("memberId", memberId);
		map.put("tenantId", tenantId);
		
		for (int i=0; i<circularIdArr.length; i++) {
			map.put("circularId", circularIdArr[i]);
			
			ezCircularDAO.updateFolderId(map);
		}
	}

	@Override
	public String getItemXML(String circularID, String memberID, String offset, int tenantID) throws Exception {
		logger.debug("getItemXML started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || tenantID = " + tenantID);
		
		StringBuilder sb = new StringBuilder();
		
		if (circularID != null) {
			CircularListVO itemInfo  = getCircular(circularID, memberID, offset, tenantID, "read");
			
			sb.append("<NODES>");
			sb.append("<NODE>");
			sb.append("<CircularId>" + itemInfo.getCircularID() + "</CircularId>");
			sb.append("<Importance>" + itemInfo.getImportance() + "</Importance>");
			sb.append("<HasFile>" + itemInfo.getHasFile() + "</HasFile>");
			sb.append("<Status>" + itemInfo.getStatus() + "</Status>");
			sb.append("<Title>" + itemInfo.getTitle() + "</Title>");
			sb.append("<MemberId>" + itemInfo.getMemberID() + "</MemberId>");
			sb.append("<MemberName>" + itemInfo.getMemberName() + "</MemberName>");
			sb.append("<RegDate>" + itemInfo.getRegDate() + "</RegDate>");
			sb.append("<Option>" + itemInfo.getOption() + "</Option>");
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
	public List<CircularCommentVO> getCircularComment(CircularCommentVO vo, String searchValue, String circularUserID, String commentType, String offset, int tenantID) throws Exception {
		logger.debug("getCircularComment started.");
		logger.debug("circularID = " + vo.getCircularID() + " || searchValue = " + searchValue + " || circularUserID = " + circularUserID + " || commentType = " + commentType + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", vo.getCircularID());
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
	public void editCircularComment(CircularCommentVO vo, LoginVO userInfo) throws Exception {
		logger.debug("editCircularComment started.");
		
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
		
		if (!vo.getCircularUserID().equals(userInfo.getId())) {
			updateCircularCommentStatus(vo.getCircularID(), vo.getCircularUserID(), 1, 0, nowDate, userInfo.getTenantId());
		}
		
		String circularCommentID = ezCircularDAO.insertComment(map);
		
		if (!vo.getCircularUserID().equals(userInfo.getId())) {
			insertCommentState(circularCommentID, vo.getCircularUserID(), 0, nowDate, userInfo.getTenantId());
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
	public List<CircularListVO> getSearchAllCircularList(String memberID, int startRow, int endRow, int tenantID, String offset, String keyword, int filterVal, String startDate, String endDate) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantID", tenantID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("searchKeyword", keyword);
		map.put("filterVal", filterVal);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		
		return ezCircularDAO.getSearchAllCircularList(map);
	}

	@Override
	public int getSearchAllCircularListCount(String memberID, int tenantID, String keyword, int filterVal, String startDate, String endDate) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		map.put("searchKeyword", keyword);
		map.put("filterVal", filterVal);
		map.put("startDate", startDate);
		map.put("endDate", endDate);

		return ezCircularDAO.getSearchAllCircularListCount(map);
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
			updateCircularCommentStatus(circularID, memberID, 0, 0, nowDate, tenantID);
			updateCircularShareStatus(circularID, memberID, 0, 0, nowDate, tenantID);
			updateCommentState(circularID, "", memberID, 1, nowDate, tenantID);
		} else {
			updateUpdateStatus(circularID, memberID, nowDate, tenantID);
			updateConfirmStatus(circularID, memberID, 1, nowDate, tenantID);
			updateCircularCommentStatus(circularID, memberID, 0, 0, nowDate, tenantID);
			updateCircularShareStatus(circularID, memberID, 0, 0, nowDate, tenantID);
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
	
	/*private void updateStatus(String circularID, String memberID, String nowDate, int tenantID) throws Exception {
		logger.debug("updateStatus started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.updateUpdateStatus(map);
		
		logger.debug("updateStatus ended.");
	}*/
	
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
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || commentStatus = " + " || tenantID = " + tenantID);
		
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
	
	private void updateCircularShareStatus(String circularID, String memberID, int shareStatus, int deleteStatus, String nowDate, int tenantID) throws Exception {
		logger.debug("updateCircularShareStatus started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || shareStatus = " + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("shareStatus", shareStatus);
		map.put("deleteStatus", deleteStatus);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.updateCircularShareStatus(map);
		
		logger.debug("updateCircularShareStatus ended.");
	}
	
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
	public int getConfirmStatus(String circularID, String circularUserID, int tenantID) throws Exception {
		logger.debug("getConfirmStatus started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("circularUserID", circularUserID);
		map.put("tenantID", tenantID);
		
		int confirmStatus = ezCircularDAO.getConfirmStatus(map);
		
		logger.debug("getConfirmStatus ended. confirmStatus = " + confirmStatus);
		
		return confirmStatus;
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

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("memberID", memberID);
		map.put("tenantID", tenantID);

		logger.debug("getUserList ended.");
		
		return ezCircularDAO.getUserList(map);
	}

	@Override
	public List<CircularListHeaderVO> getListHeader(String listType, String lang, int tenantID) throws Exception {
		logger.debug("getUserList started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listType", listType);
		map.put("lang", lang);
		map.put("tenantID", tenantID);

		List<CircularListHeaderVO> list = ezCircularDAO.getListHeader(map);
		
		logger.debug("getUserList ended. listSize = " + list.size());

		return list;
	}

	@Override
	public void circularReturn(String circularIdList, String folderID, String memberID, int tenantID) throws Exception {
		logger.debug("circularReturn started.");
		logger.debug("circularIDList = " + circularIdList + " || memberID = " + memberID + " || tenantID");
		
		Map<String, Object> map = new HashMap<String, Object>();

		// 회람문서의 updateStatus 값을 변경
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		for (String circularID : circularIdList.split(";")) {
			map.put("circularID", circularID);
			
			ezCircularDAO.updateCircularStatus(map);
			ezCircularDAO.moveCircular3(map); // LINK 테이블에서 제거
		}

		logger.debug("circularReturn ended.");
	}

	@Override
	public int getListCount(String listType, String userID, int tenantID) throws Exception {
		logger.debug("getListCount started.");
		logger.debug("listType = " + listType);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listType", listType);
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		int count= ezCircularDAO.getListCount(map);
		
		logger.debug("getListCount ended. count = " + count);
		
		return count;
	}

	@Override
	public void commentShareUser(String circularID, String circularCommentID, String memberIDList, LoginVO userInfo, String loginCookie) throws Exception {
		logger.debug("commentShareUser started.");
		logger.debug("circularID = " + circularID + " || memberIDList = " + memberIDList);
		
		CircularListVO circularVO = getCircular(circularID, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "comment");
		
		String nowDate = commonUtil.getTodayUTCTime("");
		int tenantID = userInfo.getTenantId();
		
		String subject = egovMessageSource.getMessage("ezCircular.t123", userInfo.getLocale());
    	StringBuilder bodyContent = new StringBuilder("");
    	bodyContent.append("<div id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + circularVO.getTitle() + "</br>");
    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t164", userInfo.getLocale()) + " : " + userInfo.getDisplayName());
    	bodyContent.append("</div>");
    	
    	InternetAddress from = new InternetAddress();
		from.setPersonal(userInfo.getDisplayName(), "UTF-8");
		from.setAddress(userInfo.getEmail());
		
		String memberIDs[] = memberIDList.split(";");
		
		for (String memberID : memberIDs) {
			if (!memberID.equals(userInfo.getId())) {
				updateCircularShareStatus(circularID, memberID, 1, 0, nowDate, tenantID);
				
				String commentStateID = getCommentStateID(circularCommentID, memberID, tenantID);
				
				if (commentStateID == null) {
					insertCommentState(circularCommentID, memberID, 0, nowDate, tenantID);
				} else {
					updateCommentState(circularID, circularCommentID, memberID, 0, nowDate, tenantID);
				}
			}
			
			OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(memberID, userInfo.getPrimary(), tenantID);
	    	
			if (AccessUserInfo != null) {
				InternetAddress to = new InternetAddress();
				to.setPersonal(AccessUserInfo.getDisplayName(), "UTF-8");
				to.setAddress(AccessUserInfo.getMail());
				
				ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
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

}