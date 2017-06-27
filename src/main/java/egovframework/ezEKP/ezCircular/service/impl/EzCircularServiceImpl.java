package egovframework.ezEKP.ezCircular.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzCircularService")
public class EzCircularServiceImpl implements EzCircularService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzCircularServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzCircularDAO")
	private EzCircularDAO ezCircularDAO;
	
	@Override
	public CircularConfigVO getCircularList_Config(String memberId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_MEMBERID", memberId);
		map.put("v_TENANTID", tenantId);
		
		CircularConfigVO vo = ezCircularDAO.getCircularList_Config(map);
		
		if (vo == null) {
			vo = new CircularConfigVO();
			vo.setListCnt(10);
			vo.setIsPreview(0);
			vo.setPreviewListValue("50");
			vo.setPreviewContentValue("50");
		}
		
		return vo;
	}

	@Override
	public void setCircularList_Config(CircularConfigVO circularConfigVO) throws Exception {
		String memberId = circularConfigVO.getMemberID();
		int tenantId = circularConfigVO.getTenantID();
		
		CircularConfigVO circularListConfig = getCircularList_Config(memberId, tenantId);
				
		if (circularListConfig != null) {		
			ezCircularDAO.setCircularList_Config_U(circularConfigVO);
		} else {
			ezCircularDAO.setCircularList_Config_I(circularConfigVO);
		}
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
		
		CircularConfigVO circularListConfig = getCircularList_Config(userID, tenantID);
		
		if (circularListConfig != null) {
			ezCircularDAO.setCircularList_Config2_U(map);
		} else {
			ezCircularDAO.setCircularList_Config2_I(map);
		}
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
	public List<CircularListVO> getCircularList(String memberID, int startRow, int endRow, int tenantID, String offset) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantID", tenantID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		return ezCircularDAO.getCircularList(map);
	}

	@Override
	public void insertCircular(int circularID, String title, int importance,int option, String content, int hasFile, int status, String memberID, String memberName, String memberName2, String regDate, String endDate, int tenantID, int receiverLength, String[] receiverID, int updateStatus, int circularUserId, String[] receiverName, String fileList, String[] receiverName2, String realPath) throws Exception {
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
		map.put("memberID", memberID);
		map.put("memberName", memberName);
		map.put("memberName2", memberName2);
		map.put("regDate", regDate);
		map.put("endDate", endDate);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.insertCircular(map);
		
		//가장 최근에 사용한 autoIncrement값 가져옴
		int lastID = ezCircularDAO.getLastID();
		
		for (int i=0; i<receiverLength; i++) {
			insertCircularUser(circularUserId, lastID, receiverID[i].trim(), receiverName[i].trim(), receiverName2[i].trim(), status, "", updateStatus, tenantID);
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
				
//				String uploadFilePath = realPath + commonUtil.getUploadPath("upload_circular.ROOT", tenantID) + commonUtil.separator + "uploadFile";

//				filePath = uploadFilePath + commonUtil.separator + filePath;
		
				attachMap.put("circularID", lastID);
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", filePath);
				attachMap.put("tenantID", tenantID);
				
				ezCircularDAO.insertCircularAttach(attachMap);
			}
		}
		
		logger.debug("insertCircular ended.");
	}

	@Override
	public void insertCircularUser(int circularUserID, int circularID, String memberID, String memberName, String memberName2, int status, String confirmDate, int updateStatus, int tenantID) throws Exception {
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
	}

	@Override
	public CircularListVO getCircular(String circularID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("circularId", circularID);
		map.put("tenantId", tenantID);
		
		return ezCircularDAO.getCircular(map);
	}

	@Override
	public void modifyCircular(String title, int importance, int option, int circularID, int tenantID, int receiverLength, String[] receiverID, int updateStatus, int circularUserId, String memberName, String memberName2, int status, String confirmDate, String content, String fileList, String[] receiverName, String[] receiverName2) throws Exception {
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
		
		List<CircularListVO> list = getCircularUserList(circularID, "circularUserID", "", tenantID);
		
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
	public int getCircularListCount(String memberID, int tenantID) throws Exception {
		logger.debug("getCircularListCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		int result = ezCircularDAO.getCircularListCount(map);
		
		logger.debug("getCircularListCount ended. result = " + result);
		
		return result;
	}

	@Override
	public void confirmStatus(int circularID, String memberID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String confirmDate = commonUtil.getTodayUTCTime("");
		
		int firstValue = getConfirmStatusFirst(circularID, tenantID);
		//status업데이트되는부분 임시 주석
		updateReadStatus(circularID, memberID, 1, tenantID);
		updateStatusUser(firstValue, circularID, confirmDate, tenantID);
		
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		int folderCheck = ezCircularDAO.confirmFolderCheck(map);
		
		//0 문서함에 없고 완료문서함이 있는것, else 문서함에 저장된 문서
		logger.debug("folderCheck = " + folderCheck);
		map.put("updateStatus", folderCheck == 0 ? 1 : 3);
		
		ezCircularDAO.confirmStatus(map);
	}

	@Override
	public int getConfirmStatusFirst(int circularID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getConfirmStatusFirst(map);
	}

	@Override
	public int getConfirmStatusSecond(int circularID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getConfirmStatusSecond(map);
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
	public void updateStatusUser(int status, int circularID, String confirmDate, int tenantID) throws Exception {
		logger.debug("updateStatusUser started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", status);
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		map.put("confirmDate", confirmDate);
		
		logger.debug("confirmDate = " + confirmDate);
		logger.debug("updateStatusUser ended.");
		
		ezCircularDAO.updateStatusUser(map);
	}

	@Override
	public void set_circularDeptSave(CircularDeptVO circularDeptVO, String[] memberListStr) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
				
		ezCircularDAO.set_circularDeptSave(circularDeptVO);
		
		int tenantId = circularDeptVO.getTenantID();
		int circularBMId = ezCircularDAO.getCircularBMId(); // CircularBMId 값 가져옴
		
		for (int i=0; i<memberListStr.length; i++) {
			String memberStr = memberListStr[i].trim();
			
			map.put("v_CIRCULARBMID", circularBMId);
			map.put("v_MEMBERID", memberStr);
			map.put("v_TENANTID", tenantId);			
			
			ezCircularDAO.set_circularMemberList(map);
		}
	}

	@Override
	public String getcircularDeptList(CircularDeptVO circularDeptVO, LoginVO userInfo) throws Exception {
		List<CircularDeptVO> list = ezCircularDAO.getcircularDeptList(circularDeptVO);
		
		StringBuilder sb = new StringBuilder("<DATA>");
		
		for (int i=0; i<list.size(); i++) {
			list.get(i).setRegDate(commonUtil.getDateStringInUTC(list.get(i).getRegDate(), userInfo.getOffset(), false));
			CircularDeptVO vo = list.get(i);
			sb.append(commonUtil.getQueryResult(vo));
		}
		sb.append("</DATA>");
		
		return sb.toString();
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
	public void update_circularDept(CircularDeptVO circularDeptVO, String[] memberListStr, int circularBMId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		ezCircularDAO.update_circularDept(circularDeptVO);
		
		int tenantId = circularDeptVO.getTenantID();
		
		map.put("v_CIRCULARBMID", circularBMId);
		map.put("v_TENANTID", tenantId);
		
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
	public List<CircularListVO> getCircularUserList(int circularID, String searchType, String searchValue, int tenantID) throws Exception {
		logger.debug("getCircularUserList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);
		
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
	public List<CircularListVO> getSearchCircularList(String memberID, int startRow, int endRow, int tenantId, String keyword, int circularType, int folderID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantID", tenantId);
		map.put("searchKeyword", keyword);
		map.put("circularType", circularType);
		map.put("folderID", folderID);
		
		return ezCircularDAO.getSearchCircularList(map);
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
		Map<String, Object> map = new HashMap<String, Object>();
		
		for (int i=0; i<circularIDList.length; i++) {
			int circularID = Integer.parseInt(circularIDList[i]);
			
			map.put("circularID", circularID);
			map.put("memberID", memberID);
			map.put("tenantID", tenantID);
			
			String confirmDate = commonUtil.getTodayUTCTime("");
			
			int firstValue = getConfirmStatusFirst(circularID, tenantID);
			int checkUpdateStatus = checkUpdateStatus(circularID, memberID, tenantID);
			
			logger.debug("checkUpdateStatus : " + checkUpdateStatus);
			
			if (checkUpdateStatus != 1) {
				updateStatusUser(firstValue, circularID, confirmDate, tenantID);
			}
			
			ezCircularDAO.confirmStatus(map);			
		}
	}

	@Override
	public List<CircularListVO> getCircularCompleteList(String memberID, int startRow, int endRow, int tenantID, String offset) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getCircularCompleteList(map);
	}

	@Override
	public int getCircularCompleteListCount(String memberID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getCircularCompleteListCount(map);
	}

	@Override
	public int getCircularTempListCount(String memberID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("tenantId", tenantID);
		
		return ezCircularDAO.getCircularTempListCount(map);
	}

	@Override
	public List<CircularListVO> getCircularTempList(String memberID, int startRow, int endRow, String offset, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getCircularTempList(map);
	}

	@Override
	public int getMyCircularListCount(String memberID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("tenantId", tenantID);
		
		return ezCircularDAO.getMyCircularListCount(map);
	}

	@Override
	public List<CircularListVO> getMyCircularList(String memberID, int startRow, int endRow, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantID);
		
		return ezCircularDAO.getMyCircularList(map);
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
		
		for (int i=0; i<circularIDList.length; i++) {
			map.put("circularID", circularIDList[i]);
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
	public int getCircularTDListCount(String memberId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberId);
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getCircularTDListCount(map);
	}

	@Override
	public List<CircularListVO> getCircularTDList(String memberId, int startRow, int endRow, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberId);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getCircularTDList(map);
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
	public void moveCircular(String folderId, String circularIdList, String memberId, String updateStatus, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String[] circularIdArr = circularIdList.split(";");
		
		if (updateStatus.equals("3")) {
			for (int i=0; i<circularIdArr.length; i++) {
				map.put("folderId", folderId);
				map.put("circularId", circularIdArr[i]);
				map.put("memberId", memberId);
				map.put("updateStatus", updateStatus);
				map.put("tenantId", tenantId);
				
				ezCircularDAO.moveCircular(map);
				ezCircularDAO.moveCircular2(map);
			}
		} else {
			for (int i=0; i<circularIdArr.length; i++) {
				map.put("folderId", folderId);
				map.put("circularId", circularIdArr[i]);
				map.put("memberId", memberId);
				map.put("updateStatus", updateStatus);
				map.put("tenantId", tenantId);
				
				ezCircularDAO.moveCircular(map);
				ezCircularDAO.moveCircular3(map);
			}
		}
	}

	@Override
	public int getFolderCircularListCount(int folderId, String memberId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("folderId", folderId);
		map.put("memberId", memberId);
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getFolderCircularListCount(map);
	}

	@Override
	public List<CircularListVO> getFolderCircularList(int folderId, String memberId, int startRow, int endRow, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("folderId", folderId);
		map.put("memberId", memberId);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantId);
		
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
	public String getItemXML(String pcircularId, String pmemberId, String offset, int tenantId) throws Exception {
		StringBuilder sb = new StringBuilder();
		
		if (pcircularId != null) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("circularId", pcircularId);
			map.put("tenantId", tenantId);
			
			CircularListVO itemInfo = ezCircularDAO.getCircular(map);
			
			sb.append("<NODES>");
			sb.append("<NODE>");
			sb.append("<CircularId>" + itemInfo.getCircularID() + "</CircularId>");
			sb.append("<Importance>" + itemInfo.getImportance() + "</Importance>");
			sb.append("<HasFile>" + itemInfo.getHasFile() + "</HasFile>");
			sb.append("<Status>" + itemInfo.getStatus() + "</Status>");
			sb.append("<Title>" + itemInfo.getTitle() + "</Title>");
			sb.append("<MemberId>" + itemInfo.getMemberID() + "</MemberId>");
			sb.append("<RegDate>" + commonUtil.getDateStringInUTC(itemInfo.getRegDate(), offset, false) + "</RegDate>");
			sb.append("<Option>" + itemInfo.getOption() + "</Option>");
			sb.append("<Content>" + commonUtil.cleanValue(itemInfo.getContent()) + "</Content>");
			sb.append("</NODE>");
			sb.append("</NODES>");
		} else {
			sb.append("<NODES>");
			sb.append("</NODES>");
		}

		return sb.toString();
	}

	@Override
	public List<CircularCommentVO> getCircularComment(CircularCommentVO vo, String searchType, String searchValue, String offset, int tenantID) throws Exception {
		logger.debug("getCircularComment started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", vo.getCircularID());
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", vo.getTenantID());
		
		List<CircularCommentVO> list = ezCircularDAO.getCircularComment(map);
		
		logger.debug("getCircularComment ended. listSize=" + list.size());
		
		return list;
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
		map.put("memberName", userInfo.getDisplayName());
		map.put("memberName2", userInfo.getDisplayName2());
		map.put("status", 0);// 0공개, 1비공개
		map.put("nowDate", nowDate);
		map.put("tenantID", userInfo.getTenantId());
		
		updateCircularUser(vo.getCircularID(), vo.getCircularUserID(), nowDate, userInfo.getTenantId());
		ezCircularDAO.insertComment(map);
		
		logger.debug("editCircularComment ended.");
	}

	@Override
	public CircularAttachVO getAttachInfo(String circularFileID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("circularFileID", circularFileID);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getAttachInfo(map);
	}
	
	private void updateCircularUser(String circularID, String memberID, String nowDate, int tenantID) throws Exception {
		logger.debug("updateCircularUser started.");
		logger.debug("circularID = " + circularID + " || memberID = " + memberID + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		//4 일때 댓글 -> 확인완료는 그대로 두고, 신규에서 위에 출력
		map.put("updateStatus", 4);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
				
		ezCircularDAO.updateCircularUser(map);
		
		logger.debug("updateCircularUser ended.");
	}

	@Override
	public String getUpdateStatus(String circularIdList, String memberID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String rtnValue = "";
		String[] circularIdArr = circularIdList.split(";");
		
		for (int i=0; i<circularIdArr.length; i++) {
			map.put("circularID", circularIdArr[i]);
			map.put("memberID", memberID);
			map.put("tenantID", tenantID);
			
			rtnValue += ezCircularDAO.getUpdateStatus(map) + ";";
		}
		
		return rtnValue;
	}

	@Override
	public List<CircularListVO> getSearchAllCircularList(String memberID, int startRow, int endRow, int tenantID, String keyword, int filterVal, String startDate, String endDate) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantID", tenantID);
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
	public void updateReadStatus(int circularID, String circularUserID, int status, int tenantID) throws Exception {
		logger.debug("readComment started.");
		logger.debug("circularID = " + circularID + " || circularUserID = " + circularUserID + " || status = " + status + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", circularUserID);
		map.put("status", status);
		map.put("tenantID", tenantID);
		
		ezCircularDAO.updateReadStatus(map);
		
		logger.debug("readComment ended.");
	}

	@Override
	public int getSearchCircularListCount(String memberID, int tenantID, String keyword, int circularType, int folderID) throws Exception {
		logger.debug("getCircularListCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		map.put("searchKeyword", keyword);
		map.put("circularType", circularType);
		map.put("folderID", folderID);
		
		int result = 0;
		
		result = ezCircularDAO.getSearchCircularListCount(map);

		logger.debug("getCircularListCount ended. result = " + result);

		return result;
	}

	@Override
	public List<CircularCommentVO> getCircularCommentUserList(String circularID, String circularUserID, int tenantID, String type) throws Exception {
		logger.debug("getCircularUserList started.");
		logger.debug("circularID = " + circularID + " || circularUserID = " + circularUserID + " || type = " + type + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("memberID", circularUserID);
		map.put("tenantID", tenantID);
		map.put("type", type);
		
		List<CircularCommentVO> list = ezCircularDAO.getCircularCommentUserList(map);
		
		logger.debug("getCircularUserList ended. listSize = " + list.size());
		
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
	
	
}