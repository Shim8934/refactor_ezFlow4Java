package egovframework.ezEKP.ezResource.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezResource.dao.EzResourceAdminDAO;
import egovframework.ezEKP.ezResource.service.EzResourceAdminService;
import egovframework.ezEKP.ezResource.vo.ResGetClsAclListVO;
import egovframework.ezEKP.ezResource.vo.ResGetSubClsListVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzResourceAdminService")
public class EzResourceAdminServiceImpl implements EzResourceAdminService {

	@Resource(name="EzResourceAdminDAO")
	private EzResourceAdminDAO ezResourceAdminDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<ResGetSubClsListVO> getSubClsList(String parentID, String companyID, String userID, String deptPath) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_UserID", userID);
		map.put("v_P_DeptPath", deptPath);
		return ezResourceAdminDAO.getSubClsList(map);
	}

	@Override
	public List<ResGetSubClsListVO> getAdmSubClsList(String parentID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		return ezResourceAdminDAO.getAdmSubClsList(map);
	}

	@Override
	public List<ResGetClsAclListVO> getClsAclList(String brdID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_CompanyID", companyID);
		return ezResourceAdminDAO.getClsAclList(map);
	}

	@Override
	public int delResAcll(String resID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_RESID", resID);
		map.put("v_P_COMPANYID", companyID);
		return ezResourceAdminDAO.delResAcll(map);
	}

	@Override
	public void addClsData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall,String brdNm,
			String brdExplain, String accessNoty, String companyID, String brdNm2, String isCompany) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ClassGB", classGB);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_Brd_Explain", brdExplain);
		map.put("v_P_AccessNoty", accessNoty);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("v_P_IS_COMPANY", isCompany);
		ezResourceAdminDAO.addClsData(map);
	}

	@Override
	public void saveACL(String resID, String deptYn, String sdaYn, String memberNam, String memberID, String accessLvl, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ResID", resID);
		map.put("v_P_Dept_YN", deptYn);
		map.put("v_P_SDA_YN", sdaYn);
		map.put("v_P_Member_nam", memberNam);
		map.put("v_P_Member_ID", memberID);
		map.put("v_P_Access_lvl", accessLvl);
		map.put("v_P_CompanyID", companyID);
		ezResourceAdminDAO.saveACL(map);
	}

	@Override
	public void modifyClsData(String brdID, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, 
			String brdExplain, String accessNoty, String companyID, String brdNm2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_Brd_Explain", brdExplain);
		map.put("v_P_AccessNoty", accessNoty);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Brd_NM2", brdNm2);
		ezResourceAdminDAO.modifyClsData(map);
	}

	@Override
	public void chgClsOrder(String sourceID, String targetID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_SourceID", sourceID);
		map.put("v_P_TargetID", targetID);
		map.put("v_P_CompanyID", companyID);
		ezResourceAdminDAO.chgClsOrder(map);
	}

	@Override
	public void moveCls(String sourceID, String parentID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_SourceID", sourceID);
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		ezResourceAdminDAO.moveCls(map);
	}

	@Override
	public void delClsData(String brdID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_CompanyID", companyID);
		ezResourceAdminDAO.delClsData(map);
	}
	
	public boolean addClsData(String xmlStr) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		try {
			String classGB = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(0).getTextContent().trim();
			String deptID = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(1).getTextContent().trim();
			String deptNm = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(2).getTextContent().trim();
			String ownerID = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(3).getTextContent().trim();
			String ownerNm = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(4).getTextContent().trim();
			String ownerPos = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(5).getTextContent().trim();
			String ownerCall = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(6).getTextContent().trim();
			String brdNm = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(7).getTextContent().trim();
			String brdExplain = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(8).getTextContent().trim();
			String accessNoty = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(9).getTextContent().trim();
			String companyID = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(10).getTextContent().trim();
			String brdNm2 = xmlRes.getElementsByTagName("DATA").item(0).getChildNodes().item(11).getTextContent().trim();
			String isCompany = "";
			
			if (xmlRes.getElementsByTagName("ISCOMPANY").getLength() > 0) {
				isCompany = xmlRes.getElementsByTagName("ISCOMPANY").item(0).getTextContent();
			}
			
			addClsData(classGB, deptID, deptNm, ownerID, ownerNm, ownerPos, ownerCall, brdNm, brdExplain, accessNoty, companyID, brdNm2, isCompany);
			return true;
			
		} catch (Exception e) {
			return false;
		}
	}
}
