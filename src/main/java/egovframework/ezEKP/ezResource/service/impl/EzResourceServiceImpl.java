package egovframework.ezEKP.ezResource.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezResource.dao.EzResourceDAO;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;

@Service("EzResourceService")
public class EzResourceServiceImpl implements EzResourceService{
	@Resource(name="EzResourceDAO")
	private EzResourceDAO ezResourceDAO;
	
	@Override
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID,String companyID, String treeType) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		return ezResourceDAO.getAdmSubClsTree(map);
	}

	@Override
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("v_P_USERID", pUserID);
		map.put("v_PCOMID", comID);
		map.put("v_PDEPTID", deptID);
		map.put("v_PUSERID", userID);
		return ezResourceDAO.getSubClsTree(map);
	}
	
	@Override
	public ResGetAdminFlagVO getAdminFlag(String companyID, String resID,String memberID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("resID", resID);
		map.put("memberID", memberID);
		return ezResourceDAO.getAdminFlag(map);
	}

	@Override
	public List<ResGetItemListVO> getBrdMainList(String brdID,String companyID, String lang) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_BRD_ID", brdID);
		map.put("v_COMPANY", companyID);
		map.put("v_LANG", lang);
		return ezResourceDAO.getBrdMainList(map);
	}
	
	
}
