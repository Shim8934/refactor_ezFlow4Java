package egovframework.ezEKP.ezCircular.service.impl;

import java.util.ArrayList;
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
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularFolderVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.ezEKP.ezCircular.vo.CircularDeptVO;
import egovframework.ezEKP.ezCircular.vo.CircularMemberVO;
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
		
		return ezCircularDAO.getCircularList_Config(map);
	}

	@Override
	public void setCircularList_Config(CircularConfigVO circularConfigVO) throws Exception {
		String memberId = circularConfigVO.getMemberId();
		int tenantId = circularConfigVO.getTenantId();
		
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
	public List<CircularListVO> getCircularList(String memberID, int startRow, int endRow, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getCircularList(map);
	}
	
	@Override
	public List<HashMap<String, Object>> getCircularMapList(String memberID, int startRow, int endRow, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getCircularMapList(map);
	}
	
	@Override
	public List<HashMap<String, Object>> getSearchCircularMapList(String memberID, int startRow, int endRow, int tenantId,String keyword) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantId);
		map.put("searchKeyword", keyword);
		
		return ezCircularDAO.getSearchCircularMapList(map);
	}
	
	@Override
	public CircularConfigVO getPersonalCount(LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_MEMBERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		
		CircularConfigVO circularConfigVO = ezCircularDAO.getCircularList_Config(map);
		
		if (circularConfigVO == null) {
			circularConfigVO = new CircularConfigVO();
			circularConfigVO.setIsMailReceive(0);
			circularConfigVO.setListCnt(10);
			circularConfigVO.setIsPreview(0);
			circularConfigVO.setPreviewListValue("50");
			circularConfigVO.setPreviewContentValue("50");
		}
		
		return circularConfigVO;
	}

	@Override
	public void insertCircular(int circularID, String title, int importance,int option, String content, int hasFile, int status, String memberID, String memberName, String memberName2, String regDate, String endDate, int tenantID, int receiverLength, String[] receiverID, int updateStatus, int circularUserId, String[] receiverName, String fileList, String[] receiverName2) throws Exception {
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
				
				String uploadFilePath = commonUtil.separator + "uploadFile";
				
				filePath = uploadFilePath + commonUtil.separator + filePath;
				
				attachMap.put("circularID", lastID);
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", filePath);
				attachMap.put("tenantID", tenantID);
				
				ezCircularDAO.insertCircularAttach(attachMap);
			}
		}
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
		
		List<CircularListVO> list = getCircularUserList(circularID, tenantID);
		
		logger.debug("@@receiverLength : " + receiverLength);
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
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("tenantId", tenantID);
		
		return ezCircularDAO.getCircularListCount(map);
	}

	@Override
	public void confirmStatus(int circularID, String memberID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("circularID", circularID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		
		String confirmDate = commonUtil.getTodayUTCTime("");
		
		int firstValue = getConfirmStatusFirst(circularID, tenantID);
		//status업데이트되는부분 임시 주석
		//ezCircularService.updateStatus(firstValue, circularListVO.getCircularId(), userInfo.getTenantId());
		int checkUpdateStatus = checkUpdateStatus(circularID, memberID, tenantID);
		
		logger.debug("checkUpdateStatus : " + checkUpdateStatus);
		
		if (checkUpdateStatus != 1) {
			updateStatusUser(firstValue, circularID, confirmDate, tenantID);
		}
		
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
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("status", status);
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		map.put("confirmDate", confirmDate);
		
		ezCircularDAO.updateStatusUser(map);
	}

	@Override
	public void set_circularDeptSave(CircularDeptVO circularDeptVO, String[] memberListStr) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
				
		ezCircularDAO.set_circularDeptSave(circularDeptVO);
		
		int tenantId = circularDeptVO.getTenantId();
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
		
		int tenantId = circularDeptVO.getTenantId();
		
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
	public List<CircularListVO> getCircularUserList(int circularID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		
		return ezCircularDAO.getCircularUserList(map);
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
	public List<CircularListVO> getSearchCircularList(String memberID, int startRow, int endRow, int tenantId, String keyword) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantId);
		map.put("searchKeyword", keyword);
		
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
	public List<HashMap<String, Object>> getCircularCompleteMapList(String memberID, int startRow, int endRow, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getCircularCompleteMapList(map);
	}

	@Override
	public List<CircularListVO> getCircularCompleteList(String memberID, int startRow, int endRow, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getCircularCompleteList(map);
	}

	@Override
	public int getCircularCompleteListCount(String memberID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("tenantId", tenantID);
		
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
	public List<CircularListVO> getCircularTempList(String memberID, int startRow, int endRow, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getCircularTempList(map);
	}

	@Override
	public List<HashMap<String, Object>> getCircularTempMapList(String memberID, int startRow, int endRow, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantId);
		
		return ezCircularDAO.getCircularTempMapList(map);
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
	public List<HashMap<String, Object>> getMyCircularMapList(String memberID, int startRow, int endRow, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberId", memberID);
		map.put("limit", startRow-1);
		map.put("rowCount", endRow-(startRow-1));
		map.put("tenantId", tenantID);
		
		return ezCircularDAO.getMyCircularMapList(map);
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
}
