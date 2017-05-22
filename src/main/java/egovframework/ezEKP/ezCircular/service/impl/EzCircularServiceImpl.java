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
	public List<CircularListVO> getCircularList(String memberID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberId", memberID);
		map.put("tenantId", tenantId);
		return ezCircularDAO.getCircularList(map);
	}
	
	
}
