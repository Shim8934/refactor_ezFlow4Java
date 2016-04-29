package egovframework.ezEKP.ezResource.service.impl;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Date;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezResource.dao.EzResourceDAO;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepDateTimesVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListTermVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListVO;

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

	@Override
	public List<ResGetScheduleListVO> getScheduleList(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERNAME", writerName);
		map.put("v_WRITERDEPT", writerDept);
		return ezResourceDAO.getScheduleList(map);
	}

	@Override
	public List<ResGetScheduleListMainVO> getScheduleListMain(String ownerID, String companyID, String startDate, String endDate) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pStartDate", startDate);
		map.put("v_pEndDate", endDate);
		return ezResourceDAO.getScheduleListMain(map);
	}

	@Override
	public List<ResGetScheduleListVO> getScheduleListRepetiti(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERNAME", writerName);
		map.put("v_WRITERDEPT", writerDept);
		return ezResourceDAO.getScheduleListRepetiti(map);
	}

	@Override
	public List<ResGetScheduleListMainVO> getScheduleListRepetitim( String ownerID, String companyID, String startDate) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		return ezResourceDAO.getScheduleListRepetitim(map);
	}

	@Override
	public ResGetRepDateTimesVO getRepDateTimes(String ownerID, String companyID, int num) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pNum", num);
		return ezResourceDAO.getRepDateTimes(map);
	}

	@Override
	public ResGetScheduleListTermVO getScheduleListTerm(int num, String companyID, String ownerID, String startDate, String endDate, String writerName, String writerDept) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PNUM", num);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_POWNERID", ownerID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERNAME", writerName);
		map.put("v_WRITERDEPT", writerDept);
		return ezResourceDAO.getScheduleListTerm(map);
	}
}
