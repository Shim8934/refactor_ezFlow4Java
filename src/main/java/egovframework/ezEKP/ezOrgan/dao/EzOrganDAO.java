package egovframework.ezEKP.ezOrgan.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganProxyVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzOrganDAO")
public class EzOrganDAO extends EgovAbstractDAO {
	
    private static final Logger logger = LoggerFactory.getLogger(EzOrganDAO.class);
                
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> getDeptTreeInfoForLocal(Map<String, Object> map) throws Exception{ 
        return (List<OrganDeptVO>) list("EzOrganDAO.getDeptTreeInfo", map);
    }
    
	public List<OrganDeptVO> getDeptTreeInfo(Map<String, Object> map) throws Exception{	
		return getDeptTreeInfoForLocal(map);       
	}

    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> getDeptSubTreeInfoForLocal(Map<String, Object> map) {      
        return (List<OrganDeptVO>) list("EzOrganDAO.getDeptSubTreeInfo", map);
    }
	
	public List<OrganDeptVO> getDeptSubTreeInfo(Map<String, Object> map) throws Exception {		
		return getDeptSubTreeInfoForLocal(map);       
	}
	
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> getDeptMemberListForLocal(Map<String, Object> map) throws Exception {
        String type = (String)map.get("v_CLASS");
        String deptId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getDeptMemberListForLocal started. tenantId=" + tenantId + ",deptId=" + deptId 
                + ",isPrimary=" + isPrimary + ",type=" + type);
        
        List<OrganDeptVO> deptMemberList = (List<OrganDeptVO>) list("EzOrganDAO.getDeptMemberList", map);
        
        logger.debug("getDeptMemberListForLocal ended.");
                
        return deptMemberList;
    }
	
	public List<OrganDeptVO> getDeptMemberList(Map<String, Object> map) throws Exception {
		return getDeptMemberListForLocal(map);       		
	}
		
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> getDeptMemberListPageForLocal(Map<String, Object> map) throws Exception {
        String type = (String)map.get("v_CLASS");
        String deptId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        String page = (String)map.get("v_PAGE");
        
        logger.debug("getDeptMemberListPageForLocal started. tenantId=" + tenantId + ",deptId=" + deptId 
                + ",isPrimary=" + isPrimary + ",type=" + type + ",page=" + page);
        
        List<OrganDeptVO> deptMemberList = (List<OrganDeptVO>) list("EzOrganDAO.getDeptMemberListPage", map);
        
        logger.debug("getDeptMemberListPageForLocal ended.");
        
        return deptMemberList;
    }
	
	public List<OrganDeptVO> getDeptMemberListPage(Map<String, Object> map) throws Exception {
		return getDeptMemberListPageForLocal(map);               		
	}
		
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> organSearchForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganDeptVO>) list("EzOrganDAO.organSearch", map);
    }   
	
	public List<OrganDeptVO> organSearch(Map<String, Object> map) throws Exception {		
		return organSearchForLocal(map);                       
	}	
	
	@SuppressWarnings("unchecked")
	public List<OrganProxyVO> getProxyUserInfo(Map<String, Object> map) throws Exception{
		return (List<OrganProxyVO>) list("EzOrganDAO.getProxyUserInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getBirthUserList(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzOrganDAO.getBirthUserList", map);
	}
	
    private OrganUserVO getTBLUserMasterForLocal(Map<String, Object> map) throws Exception {
        String userId = (String)map.get("v_CN");
        String deptId = (String)map.get("v_DEPTCD");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getTBLUserMasterForLocal started. tenantId=" + tenantId + ",userId=" + userId + ",deptId=" + deptId + ",isPrimary=" + isPrimary);
        
        String isAddJob = "";
        String jobId = "";
        String roleId = "";
        jobId = Optional.ofNullable((String)map.get("JOBID")).filter(str -> !str.isEmpty()).orElse("0");
        roleId = Optional.ofNullable((String)map.get("ROLEID")).filter(str -> !str.isEmpty()).orElse("0");
        isAddJob = (map.containsKey("IS_ADDJOB") && !jobId.equals("")) ? (String)map.get("IS_ADDJOB") : "";
        logger.debug("isAddJob=" + isAddJob + ", jobId=" + jobId + ", roleId=" + roleId);
        
        OrganUserVO organUserVO = (OrganUserVO) select("EzOrganDAO.getTBLUserMaster", map);
        organUserVO.setJobID(jobId);
        logger.debug("getTBLUserMasterForLocal ended.");
        
        return organUserVO;
    }
	
    // 지정된 부서에서의 사원의 상세 정보를 반환한다.(겸직 부서의 경우 겸직 부서에서의 직위를 반환한다.)
	public OrganUserVO getTBLUserMaster(Map<String, Object> map) throws Exception {
		return getTBLUserMasterForLocal(map);               
	}
	
    private OrganDeptVO getTBLDeptMasterForLocal(Map<String, Object> map) throws Exception {
        String deptId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getTBLDeptMasterForLocal started. tenantId=" + tenantId + ",deptId=" + deptId + ",isPrimary=" + isPrimary);
        
        OrganDeptVO organDeptVO = (OrganDeptVO) select("EzOrganDAO.getTBLDeptMaster", map);
        
        logger.debug("getTBLDeptMasterForLocal ended.");
        
        return organDeptVO;
    }
	
    // 부서의 상세 정보를 반환한다.
	public OrganDeptVO getTBLDeptMaster(Map<String, Object> map) throws Exception {
		return getTBLDeptMasterForLocal(map);       
	}

	private OrganDeptVO getDeptInfoForLocal(Map<String, Object> map) {
        String deptId = (String)map.get("userID");
        String isPrimary = (String)map.get("primary");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getDeptInfoForLocal started. tenantId=" + tenantId + ",deptId=" + deptId + ",isPrimary=" + isPrimary);
	    
        OrganDeptVO organDeptVO = (OrganDeptVO) select("EzOrganDAO.getDeptInfo", map);
        
        logger.debug("getDeptInfoForLocal ended.");

        return organDeptVO;
    }
	
	public OrganDeptVO getDeptInfo(Map<String, Object> map) throws Exception {
		return getDeptInfoForLocal(map);       
	}
	
    private OrganUserVO getUserInfoForLocal(Map<String, Object> map) throws Exception {
        String userId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getUserInfoForLocal started. tenantId=" + tenantId + ",userId=" + userId + ",isPrimary=" + isPrimary);
        
        OrganUserVO organUserVO = (OrganUserVO) select("EzOrganDAO.getUserInfo", map);
        
        logger.debug("getUserInfoForLocal ended.");
        
        return organUserVO;
    }
	
	public OrganUserVO getUserInfo(Map<String, Object> map) throws Exception {
		return getUserInfoForLocal(map);       
	}
		
    private String getMemberListCountForLocal(Map<String, Object> map) throws Exception {
        String deptId = (String)map.get("v_CN");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getMemberListCountForLocal started. tenantId=" + tenantId + ",deptId=" + deptId);
        
        String memberCount = (String) select("EzOrganDAO.getMemberListCount", map);
        
        logger.debug("memberCount=" + memberCount);
        logger.debug("getMemberListCountForLocal ended.");
        
        return memberCount;
    }
	
    // 특정 부서의 사원수를 겸직 사원을 포함하여 반환한다.
	public String getMemberListCount(Map<String, Object> map) throws Exception {
		return getMemberListCountForLocal(map);       
	}
	
	public int getMemberListCount2(Map<String, Object> map) throws Exception {
		return (int) select("EzOrganDAO.getMemberListCount2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getChildCompany(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzOrganDAO.getChildCompany", map);
	}
		
    private String getPropertyValueForLocal(Map<String, Object> map) throws Exception {
        String cn = (String)map.get("v_CN");
        String field = (String)map.get("v_FIELD");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getPropertyValueForLocal started. tenantId=" + tenantId + ",cn=" + cn + ",field=" + field);
        
        String propertyValue = (String) select("EzOrganDAO.getPropertyValue", map);
        
        logger.debug("propertyValue=" + propertyValue);
        logger.debug("getPropertyValueForLocal ended.");
        
        return propertyValue;
    }
	
	public String getPropertyValue(Map<String, Object> map) throws Exception {
		return getPropertyValueForLocal(map);       
	}

	public String getSIPUriList(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getSIPUriList", map);
	}
	
    private String getDeptFullPathForLocal(String deptID, int tenantID) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("deptID", deptID);
    	map.put("tenantId", tenantID);
        return (String) select("EzOrganDAO.getDeptFullPath", map);
    }
	
	public String getDeptFullPath(String deptID, int tenantID) throws Exception{
		return getDeptFullPathForLocal(deptID, tenantID);       
	}
	
	public String getEncPassword(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getEncPassword", map);
	}
	
	public String getLastLogin(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getLastLogin", map);
	}
	
	public String getLoginIP(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getLoginIP", map);
	}
	
	private int deptSubDeptCntForLocal(String deptID, int tenantId, String isOrgan, String adminOrgan) throws Exception {
        logger.debug("deptSubDeptCntForLocal started. deptID=" + deptID + ",tenantId=" + tenantId);
        
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("deptID", deptID);
    	map.put("tenantId", tenantId);
    	map.put("isOrgan", isOrgan);
		map.put("adminOrgan", adminOrgan);
    	
        int deptSubDeptCnt = (int) select("EzOrganDAO.deptSubDeptCnt", map);
        
        logger.debug("deptSubDeptCnt=" + deptSubDeptCnt);
        logger.debug("deptSubDeptCntForLocal ended.");
        
        return deptSubDeptCnt;
    }
	
	public int deptSubDeptCnt(String deptID, int tenantId, String isOrgan, String adminOrgan) throws Exception{
		return deptSubDeptCntForLocal(deptID, tenantId, isOrgan, adminOrgan);       
	}
	
    private OrganUserVO getUserAddjobInfoForLocal(Map<String, Object> map) throws Exception{
        return (OrganUserVO) select("EzOrganDAO.getUserAddjobInfo", map);
    }
	
	public OrganUserVO getUserAddjobInfo(Map<String, Object> map) throws Exception{
		return getUserAddjobInfoForLocal(map);       
	}
	
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> organSearchListPageForLocal(Map<String, Object> map) throws Exception{
        return (List<OrganDeptVO>) list("EzOrganDAO.organSearchListPage", map);
    }
    
	public List<OrganDeptVO> organSearchListPage(Map<String, Object> map) throws Exception{
		return organSearchListPageForLocal(map);                       
	}
	
    private int getSearchListCountForLocal(Map<String, Object> map) {
        return (int) select("EzOrganDAO.getSearchListCount", map);
    }
	
	public int getSearchListCount(Map<String, Object> map) throws Exception {
		return getSearchListCountForLocal(map);                       
	}
	
	public int checkRetired(Map<String, Object> map) throws Exception {
		return (int) select("EzOrganDAO.checkRetired", map);
	}
	
    private void updatePropertyForLocal(Map<String, Object> map) throws Exception{
        update("EzOrganDAO.updateProperty", map);
    }
	
	public void updateProperty(Map<String, Object> map) throws Exception{
		updatePropertyForLocal(map);                       
	}
	
	public void setProxyUserInfo(Map<String, Object> map) throws Exception{
		update("EzOrganDAO.setProxyUserInfo", map);
	}

	public void delProxyUserInfo(Map<String, Object> map) throws Exception{
		delete("EzOrganDAO.delProxyUserInfo", map);
	}
	
    private String getCNByEmailForLocal(String email, int tenantID) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("email", email);
    	map.put("tenantID", tenantID);
        return (String) select("EzOrganDAO.getCNByEmail", map);
    }
	
	public String getCNByEmail(String email, int tenantID) throws Exception{
		return getCNByEmailForLocal(email, tenantID);                       
	}
	
	public void updateProperty_U (Map<String, Object> map) throws Exception {
		update("EzOrganDAO.updateProperty_U", map);
	}
		
	public String setProxyUserInfo_S (Map<String, Object> map) throws Exception {
		return (String) select("EzOrganDAO.setProxyUserInfo_S", map);
	}
	
	public void setProxyUserInfo_I (Map<String, Object> map) throws Exception {
		insert("EzOrganDAO.setProxyUserInfo_I", map);
	}

	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getDeptReceipterIDs(Map<String, Object> map) {
		 return (List<OrganUserVO>) list("EzOrganDAO.getDeptReceipterIDs", map);
	}
	
	public String getPropertyValue_S1 (Map<String, Object> map) throws Exception {
		return (String) select("EzOrganDAO.getPropertyValue_S1", map);
	}
	
	public String getPropertyValue_S2 (Map<String, Object> map) throws Exception {
		return (String) select("EzOrganDAO.getPropertyValue_S2", map);
	}
	
	public String getPropertyValue_S3 (Map<String, Object> map) throws Exception {
		return (String) select("EzOrganDAO.getPropertyValue_S3", map);
	}
	
	public String getPropertyValue_S4 (Map<String, Object> map) throws Exception {
		return (String) select("EzOrganDAO.getPropertyValue_S4", map);
	}
	
	public String getPropertyValue_S5 (Map<String, Object> map) throws Exception {
		return (String) select("EzOrganDAO.getPropertyValue_S5", map);
	}

	public OrganProxyVO getProxyInfo(Map<String, Object> map) throws Exception {
		return (OrganProxyVO) select("EzOrganDAO.getProxyInfo", map);
	}	

    @SuppressWarnings("unchecked")
    public List<String> getAllSubDeptId(Map<String, Object> map) {      
        return (List<String>) list("EzOrganDAO.getAllSubDeptId", map);
    }
    
    public String getDeptPath(Map<String, Object> map) {      
        return (String) select("EzOrganDAO.getDeptPath", map);
    }

	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getExtension4ID(Map<String, Object> map) throws Exception {
		return (List<OrganDeptVO>) list("EzOrganDAO.getExtension4ID", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getChildrenDeptID(Map<String, Object> map) throws Exception {
		return (List<OrganDeptVO>) list("EzOrganDAO.getChildrenDeptID", map);
	}
	
	public void setListType(Map<String, Object> map) throws Exception {
		update("EzOrganDAO.setListType", map);
	}

	public String getListType(Map<String, Object> map) {
		return (String) select("EzOrganDAO.getListType", map);
	}
	
	public String getPhysicalDeliveryOfficeName(Map<String, Object> map) {
		return (String) select("EzOrganDAO.getPhysicalDeliveryOfficeName", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getSharedMailboxSearchList(Map<String, Object> map) {
		return (List<OrganUserVO>) list("EzOrganDAO.getSharedMailboxSearchList", map);
	}

	public String getDeptMasterName(Map<String, Object> map) {
		return (String) select("EzOrganDAO.getDeptMasterName", map);
	}
	
	public String getUserOrgDeptId(Map<String, Object> map) throws Exception {
		return (String) select("EzOrganDAO.getUserOrgDeptId", map);
	}

	public void updateAddJobProxy(Map<String, Object> map) throws Exception {
		update("EzOrganDAO.updateAddJobProxy", map);
	}

	public String getAddJobProxy(Map<String, Object> map) throws Exception {
		return (String) select("EzOrganDAO.getAddJobProxy", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getOrgUserInfo(Map<String, Object> map) {
		 return (List<OrganUserVO>) list("EzOrganDAO.getOrgUserInfo", map);
	}

	public String getCompanyId(String userId, int tenantId) {
		Map<String, Object> parameter = new HashMap<>();
		parameter.put("userId", userId);
		parameter.put("tenantId", tenantId);
		return (String) select("EzOrganDAO.getCompanyId", parameter);
	}

	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/사용자 별 권한 설정 옵션에 따른 권한 조회 메소드
	public String getRollInfoBasisDept(Map<String, Object> map) throws Exception {
		return (String) select("EzOrganDAO.selectPermissionBasisDept", map);
	}

	// 2023-08-09 전인하 - 특정 유저의 모든 겸직 권한 호출하는 메소드
	public List<OrganUserVO> getAllRollInfoForUserBasisDept(Map<String, Object> map) throws Exception {
		return (List<OrganUserVO>) list("EzOrganDAO.getAllRollInfoForUserBasisDept", map);
	}

	// 2023-08-28 전인하 - 전자결재 > 좌측 겸직 변경 드롭다운 > 리스트 생성 위한 겸직정보 조회
	public List<OrganUserVO> getAddJobListForEzApprDropdown(Map<String, Object> map) throws Exception {
		return (List<OrganUserVO>) list("EzOrganDAO.addJobListForEzApprDropdown", map);
	}

	public OrganUserVO getAddJobInfo(Map<String, Object> map) throws Exception {
		return (OrganUserVO) select("EzOrganDAO.getAddJobInfo", map);
	}

    @SuppressWarnings("unchecked")
    // 2023-10-31 박기범 - 모든 유저정보 조회(사간 겸직 포함)
    public List<OrganUserVO> getAllUserInfo(Map<String, Object> map) throws Exception {
        return (List<OrganUserVO>) list("EzOrganDAO.getAllUserInfo", map);
    }

	public List<OrganUserVO> getRetireUserMail(int tenantId) throws Exception {
		return (List<OrganUserVO>) list("EzOrganDAO.getRetireUserMail", tenantId);
	}

	public Map<String, Object> getUserInfoMap(Map<String, Object> map) {
		return (Map<String, Object>) select("EzOrganDAO.getUserInfoMap", map);
	}
}
