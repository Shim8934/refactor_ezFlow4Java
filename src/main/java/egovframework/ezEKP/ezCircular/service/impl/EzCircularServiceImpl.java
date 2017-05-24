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
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
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
		
		return ezCircularDAO.getCircularList_Config(map);
	}

	@Override
	public void setCircularList_Config(CircularConfigVO circularConfigVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String memberId = circularConfigVO.getMemberId();
		int tenantId = circularConfigVO.getTenantId();
		
		map.put("v_MEMBERID", memberId);
		map.put("v_TENANTID", tenantId);
		
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
	public void insertCircular(int circularID, String title, int importance,int option, String content, int hasFile, int status, String memberID, String memberName, String memberName2, String regDate, String endDate, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
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
	public void modifyCircular(String title, int importance, int option, int circularID,int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("title", title);
		map.put("importance", importance);
		map.put("option", option);
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		ezCircularDAO.modifyCircular(map);
	}

	@Override
	public void deleteCircular(int circularID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("circularID", circularID);
		map.put("tenantID", tenantID);
		ezCircularDAO.deleteCircular(map);
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
	
	
}
