package egovframework.ezMobile.ezResource.service.impl;


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
import egovframework.ezMobile.ezResource.dao.MResourceDAO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MResourceService")
public class MResourceServiceImpl extends EgovAbstractServiceImpl implements MResourceService{
	
	private static final Logger logger = LoggerFactory.getLogger(MResourceServiceImpl.class);
	
	@Resource(name="MResourceDAO")
	private MResourceDAO mResourceDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private CommonUtil commonUtil;

	@Override
	public List<MResourceGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID, String companyID, String treeType, int tenantID) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("tenantID", tenantID);
		return mResourceDAO.getAdmSubClsTree(map);
	}
	
}

