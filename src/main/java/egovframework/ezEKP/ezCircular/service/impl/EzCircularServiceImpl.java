package egovframework.ezEKP.ezCircular.service.impl;

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
	public List<CircularListVO> getCircularList(String memberID, String searchValue, String sdate, String edate, int startRow, int endRow, int tenantID, String offset, String orderCell, String orderOption1) throws Exception {
		logger.debug("getCircularList started.");
		logger.debug("memberID = " + memberID + " || startRow = " + startRow + " || endRow = " + endRow + " || tenantID = " + tenantID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
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
							   String fileList, String[] receiverName2, String realPath, LoginVO userInfo, String loginCookie) throws Exception {
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
		
		ezCircularDAO.insertCircular(map);
		
		//가장 최근에 사용한 autoIncrement값 가져옴
		int lastID = ezCircularDAO.getLastID();
		
		for (int i=0; i<receiverLength; i++) {
			insertCircularUser(circularUserId, lastID, receiverID[i].trim(), receiverName[i].trim(), receiverName2[i].trim(), status, "", updateStatus, userInfo.getTenantId());
		}
		
		//첨부파일 저장
		Map<String, Object> attachMap = new HashMap<String, Object>();
		
		if (fileList != null && !fileList.equals("")) {
			int fileLength = fileList.split(",").length;
			String[] fileLists = fileList.split(",");
			
			for (int j=0; j<fileLength; j++) {
				String[] files = fileLists[j].split("/");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];
				
				String uploadFilePath = commonUtil.separator + "uploadFile";

				filePath = uploadFilePath + commonUtil.separator + filePath;

				attachMap.put("circularID", lastID);
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", filePath);
				attachMap.put("tenantID", userInfo.getTenantId());
				
				ezCircularDAO.insertCircularAttach(attachMap);
			}
		}

		// 임시저장이 아닐 때만 실행
		if (status != 2) {
			confirmStatus(lastID, userInfo.getId(), userInfo.getTenantId());			
		}

		// 회람자에게 메일 발송
		if (option == 2 || option == 3) {
			// 임시저장 시 미발송
			if (status != 2) {
				String subject = egovMessageSource.getMessage("ezCircular.t172", userInfo.getLocale());
				StringBuilder bodyContent = new StringBuilder("");
				bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + title + " </br>");
		    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t166", userInfo.getLocale()) + " : " + content);
				
				for (int i=0; i<receiverLength; i++) {
					InternetAddress from = new InternetAddress();
					from.setPersonal(userInfo.getDisplayName(), "UTF-8");
					from.setAddress(userInfo.getEmail());
					
					InternetAddress to = new InternetAddress();
					
					if (!receiverID[i].trim().equals(userInfo.getId())) {
logger.debug("receiverID = " + receiverID);
						to.setPersonal(receiverName[i].trim(), "UTF-8");
						to.setAddress(receiverID[i].trim());
						
						ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
					}
				}	
			}
		}

		logger.debug("insertCircular ended.");
	}

	@Override
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
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		
		CircularListVO vo = ezCircularDAO.getCircular(map);
		
		if (type.equals("read")) {
			confirmStatus(Integer.parseInt(circularID), memberID, tenantID);
		}
		
		logger.debug("getCircular ended.");
		
		return vo;
	}

	@Override
	public void modifyCircular(String title, int importance, int option, int circularID, int tenantID, int receiverLength, String[] receiverID, int updateStatus, int circularUserId, String memberName, String memberName2, int status, String confirmDate, String content, String fileList, String[] receiverName, String[] receiverName2, String offset) throws Exception {
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
			int fileLength = fileList.split(",").length;
			String[] fileLists = fileList.split(",");
			
			for (int j=0; j<fileLength; j++) {
				String[] files = fileLists[j].split("/");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];
				
				String uploadFilePath = commonUtil.separator + "uploadFile";
				
				filePath = uploadFilePath + commonUtil.separator + filePath;
				
				attachMap.put("circularID", circularID);
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", filePath);
				attachMap.put("tenantID", tenantID);
				
				ezCircularDAO.insertCircularAttach(attachMap);
			}
		}
		
	}

	@Override
	public void circularDeleteItem(String circularIDList, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String[] circularIDArr = circularIDList.split(";");
		
		for (int i=0; i<circularIDArr.length; i++) {
			map.put("circularID", circularIDArr[i]);
			map.put("tenantID", tenantID);
		
			ezCircularDAO.deleteCircular(map);
			ezCircularDAO.deleteCircularUser(map);
			ezCircularDAO.deleteCircularAttach(map);			
		}
	}

	@Override
	public void deleteCircularUser(int circularID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.deleteCircularUser(map);
	}

	@Override
	public int getCircularListCount(String memberID, String searchValue, String sdate, String edate, int tenantID) throws Exception {
		logger.debug("getCircularListCount started.");
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("tenantID", tenantID);
		
		int result = ezCircularDAO.getCircularListCount(map);
		
		logger.debug("getCircularListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public void updateStatus(int status, int circularID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("status", status);
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
		
		for (int i=0; i<memberListStr.length; i++) {
			String memberStr = memberListStr[i].trim();
			
			map.put("CIRCULARBMID", circularBMId);
			map.put("v_MEMBERID", memberStr);
			map.put("TENANTID", tenantId);			
			
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
		
		for (int i=0; i<delList.length; i++) {
			String circularBMId = delList[i];
			
			map.put("v_CIRCULARBMID", circularBMId);
			map.put("v_TENANTID", tenantId);
			
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
	public void circularConfirmStatus(String[] circularIDList, String memberID, int tenantID) throws Exception {
		logger.debug("circularConfirmStatus started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantID", tenantID);
		
		for (String circularID : circularIDList) {
			logger.debug("circularID = " + circularID + " || memberID = " + memberID);
			
			map.put("circularID", circularID);
			map.put("memberID", memberID);
			
			confirmStatus(Integer.parseInt(circularID), memberID, tenantID);
		}
		
		logger.debug("circularConfirmStatus ended.");
	}

	@Override
	public List<CircularListVO> getCircularCompleteList(String memberID, String searchValue, String sdate, String edate, int startRow, int endRow, int tenantID, String offset, String orderCell, String orderOption1) throws Exception {
		logger.debug("getCircularCompleteList started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || startRow = " + startRow + " || endRow = " + endRow + " || tenantID = " + tenantID);

		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
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
	public int getCircularCompleteListCount(String memberID, String searchValue, String sdate, String edate, int tenantID) throws Exception {
		logger.debug("getCircularCompleteListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || tenantID = " + tenantID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("tenantID", tenantID);
		
		int result = ezCircularDAO.getCircularCompleteListCount(map);
		
		logger.debug("getCircularCompleteListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public int getCircularTempListCount(String memberID, String searchValue, String sdate, String edate, int tenantID) throws Exception {
		logger.debug("getCircularTempListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || tenantID = " + tenantID);
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("tenantID", tenantID);
		
		int result = ezCircularDAO.getCircularTempListCount(map);
		
		logger.debug("getCircularTempListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public List<CircularListVO> getCircularTempList(String memberID, String searchValue, String sdate, String edate, int startRow, int endRow, String offset, int tenantID, String orderCell, String orderOption1) throws Exception {
		logger.debug("getCircularTempList started.");
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
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
	public int getMyCircularListCount(String memberID, String searchValue, String sdate, String edate, int tenantID) throws Exception {
		logger.debug("getMyCircularListCount started.");
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("tenantID", tenantID);
		
		int result = ezCircularDAO.getMyCircularListCount(map);
		
		logger.debug("getMyCircularListCount ended. result = " + result);
		
		return result; 
	}

	@Override
	public List<CircularListVO> getMyCircularList(String memberID, String searchValue, String sdate, String edate, int startRow, int endRow, String offset, int tenantID, String orderCell, String orderOption1) throws Exception {
		logger.debug("getMyCircularList started.");
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
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
	public void circularClose(String[] circularIDList, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		for (String circularID : circularIDList) {
			map.put("circularID", circularID);
			map.put("tenantID", tenantID);

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
	public int getCircularTDListCount(String memberID, String searchValue, int tenantID) throws Exception {
		logger.debug("getCircularTDListCount started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("tenantID", tenantID);
		
		int result = ezCircularDAO.getCircularTDListCount(map);
		
		logger.debug("getCircularTDListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public List<CircularListVO> getCircularTDList(String memberID, String searchValue, int startRow, int endRow, int tenantID, String offset, String orderCell, String orderOption1) throws Exception {
		logger.debug("getCircularTDList started.");
		logger.debug("memberID = " + memberID + " || searchValue = " + searchValue + " || startRow = " + startRow + " || endRow = " + endRow + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
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
		Map<String, Object> map = new HashMap<String, Object>();
		
		String[] circularIDArr = circularIDList.split(";");
		
		for (int i=0; i<circularIDArr.length; i++) {
			map.put("circularID", circularIDArr[i]);
			map.put("memberID", memberId);
			map.put("tenantID", tenantId);
		
			ezCircularDAO.tempDeleteCircular(map);
		}
	}

	@Override
	public void moveCircular(String folderId, String circularIdList, String memberId, String updateStatus, String originLoc, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String[] circularIdArr = circularIdList.split(";");

		for (int i=0; i<circularIdArr.length; i++) {
			map.put("folderId", folderId);
			map.put("circularId", circularIdArr[i]);
			map.put("memberId", memberId);
			map.put("updateStatus", updateStatus);
			map.put("originLoc", originLoc);
			map.put("tenantId", tenantId);

			ezCircularDAO.moveCircular(map); // updateStatus 값 변경
			ezCircularDAO.moveCircular2(map); // Link 테이블에 Insert
		}
	}

	@Override
	public int getFolderCircularListCount(String folderID, String memberID, String searchValue, String sdate, String edate, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}

		map.put("folderID", folderID);
		map.put("memberID", memberID);
		map.put("searchValue", searchValue);
		map.put("sdate", sdate);
		map.put("edate", edate);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getFolderCircularListCount(map);
	}

	@Override
	public List<CircularListVO> getFolderCircularList(String folderID, String memberID, int startRow, int endRow, String searchValue, String sdate, String edate, String offset, int tenantID, String orderCell, String orderOption1) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (!sdate.equals("")) {
			sdate += " 00:00:00";
			edate += " 23:59:59";			
		}
		
		map.put("folderID", folderID);
		map.put("memberID", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
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

		for (int i=0; i<circularIdArr.length; i++) {
			map.put("folderId", folderId);
			map.put("circularId", circularIdArr[i]);
			map.put("memberId", memberId);
			map.put("tenantId", tenantId);
			
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
	public List<CircularCommentVO> getCircularComment(CircularCommentVO vo, String searchValue, String circularUserID, String offset, int tenantID) throws Exception {
		logger.debug("getCircularComment started.");
		logger.debug("circularID = " + vo.getCircularID() + " || searchValue = " + searchValue + " || circularUserID = " + circularUserID + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", vo.getCircularID());
		map.put("searchValue", searchValue);
		map.put("circularUserID", circularUserID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		List<CircularCommentVO> list = ezCircularDAO.getCircularComment(map);
		ezCircularDAO.updateCommentState(map);
		logger.debug("getCircularComment ended. listSize=" + list.size());
		
		return list;
	}
	
	@Override
	public int getCommentCount(String circularID, String id, int tenantID) throws Exception {
		logger.debug("getCommentCount started.");
		logger.debug("circularID = " + circularID + " || circularUserID = " + id + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("circularUserID", id);
		map.put("tenantID", tenantID);
		
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
		
		updateCircularCommentStatus(vo.getCircularID(), vo.getCircularUserID(), 1, nowDate, userInfo.getTenantId());
		
		int circularCommentID = ezCircularDAO.insertComment(map);
		
		map.put("circularCommentID", circularCommentID);
		map.put("commentConfirmStatus", 0);
		
		//공유기능 추가 -> 모든회람자의 확인날짜가 찍혀야할수도있음.
		ezCircularDAO.insertCommentState(map);
		
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
	public String getCircularStatus(String circularIdList, String memberID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String rtnValue = "";
		String[] circularIdArr = circularIdList.split(";");
		
		for (int i=0; i<circularIdArr.length; i++) {
			map.put("circularID", circularIdArr[i]);
			map.put("memberID", memberID);
			map.put("tenantID", tenantID);
			
			rtnValue += ezCircularDAO.getCircularStatus(map) + ";";
		}
		
		return rtnValue;
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
	
	private void updateCircularCommentStatus(String circularID, String memberID, int commentStatus, String nowDate, int tenantID) throws Exception {
		logger.debug("updateCircularUser started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || commentStatus = " + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("commentStatus", commentStatus);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
				
		ezCircularDAO.updateCircularCommentStatus(map);
		
		logger.debug("updateCircularUser ended.");
	}
	
	private void updateCircularShareStatus(String circularID, String memberID, int shareStatus, String nowDate, int tenantID) throws Exception {
		logger.debug("updateCircularShareStatus started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || shareStatus = " + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("shareStatus", shareStatus);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.updateCircularShareStatus(map);
		
		logger.debug("updateCircularShareStatus ended.");
	}	

	private void updateReadStatus(int circularID, String circularUserID, int status, String confirmDate, int tenantID) throws Exception {
		logger.debug("updateReadStatus started.");
		logger.debug("circularID = " + circularID + " || circularUserID = " + circularUserID + " || status = " + status + " || confirmDate = " + confirmDate + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", circularUserID);
		map.put("status", status);
		map.put("confirmDate", confirmDate);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.updateReadStatus(map);
		
		logger.debug("updateReadStatus ended.");
	}
	
	private void confirmStatus(int circularID, String memberID, int tenantID) throws Exception {
		logger.debug("confirmStatus started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || tenantID = " + tenantID);
		
		String nowDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.confirmStatus(map);
		updateReadStatus(circularID, memberID, 1, nowDate, tenantID);
		updateCircularCommentStatus(Integer.toString(circularID), memberID, 0, nowDate, tenantID);
		updateCircularShareStatus(Integer.toString(circularID), memberID, 0, nowDate, tenantID);
		
		logger.debug("confirmStatus ended.");
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
	public List<CircularListHeaderVO> getListHeader(CircularListHeaderVO headerVO) throws Exception {
		logger.debug("getUserList started.");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("listType", headerVO.getListType());
		map.put("tenantID", headerVO.getTenantID());

		logger.debug("getUserList ended.");

		return ezCircularDAO.getListHeader(map);
	}

	@Override
	public void circularReturn(String circularIdList, String folderID, String memberID, int tenantID) throws Exception {
		logger.debug("circularReturn started.");
		
		Map<String, Object> map = new HashMap<String, Object>();

		String status = "";
		String[] circularArr = circularIdList.split(";");

		// 회람문서 원래 상태값을 가져옴
		for (int i=0; i<circularArr.length; i++) {
			map.put("circularID", circularArr[i]);
			map.put("memberID", memberID);
			map.put("tenantID", tenantID);
			
			status += ezCircularDAO.getCircularStatus(map) + ";";
		}
		
		String[] statusArr = status.split(";");
		
		// 회람문서의 updateStatus 값을 변경
		for (int i=0; i<statusArr.length; i++) {
			map.put("circularID", circularArr[i]);
			map.put("status", statusArr[i]);
			map.put("memberID", memberID);
			map.put("tenantID", tenantID);
			
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
	public void commentShareUser(String circularID, String memberIDList, LoginVO userInfo, String loginCookie) throws Exception {
		logger.debug("commentShareUser started.");
		logger.debug("circularID = " + circularID + " || memberIDList = " + memberIDList);
		
		CircularListVO circularVO = getCircular(circularID, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId(), "comment");
		
		String nowDate = commonUtil.getTodayUTCTime("");
		int tenantID = userInfo.getTenantId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		map.put("nowDate", nowDate);
		
		String subject = egovMessageSource.getMessage("ezCircular.t123", userInfo.getLocale());
    	StringBuilder bodyContent = new StringBuilder("");
    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + circularVO.getTitle() + "</br>");
    	bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t164", userInfo.getLocale()) + " : " + userInfo.getDisplayName());
    	
    	InternetAddress from = new InternetAddress();
		from.setPersonal(userInfo.getDisplayName(), "UTF-8");
		from.setAddress(userInfo.getEmail());
		
		String memberIDs[] = memberIDList.split(";");
		
		for (String memberID : memberIDs) {
			map.put("memberID", memberID);
			updateCircularShareStatus(circularID, memberID, 1, nowDate, tenantID);
			
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
}