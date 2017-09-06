package egovframework.ezMobile.ezOrgan.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezMobile.ezOrgan.dao.MOrganDAO;
import egovframework.ezMobile.ezOrgan.service.MOrganService;
import egovframework.ezMobile.ezOrgan.vo.MPersonListVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("MOrganService")
public class MOrganServiceImpl implements MOrganService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MOrganServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "MOrganDAO")
	private MOrganDAO mOrganDAO;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Override
	public List<MPersonListVO> getPersonList(String companyID, int tenantID, String pSearchText, String rowNum) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText);
		map.put("rowNum", rowNum);
		map.put("listSize", 30);
		return mOrganDAO.getPersonList(map);
	}

	@Override
	public int getPersonListCount(String companyID, int tenantID, String pSearchText) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText);
		return mOrganDAO.getPersonListCount(map);
	}

	@Override
	public MPersonListVO getPersonInfo(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		return mOrganDAO.getPersonInfo(map);
	}
	
	
}
