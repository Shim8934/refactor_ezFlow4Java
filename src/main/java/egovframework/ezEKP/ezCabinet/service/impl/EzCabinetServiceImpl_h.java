package egovframework.ezEKP.ezCabinet.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetDAO_h;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_h;
import egovframework.ezEKP.ezCabinet.vo.CabinetShareVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzCabinetServiceImpl_h implements EzCabinetService_h{
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetServiceImpl_h.class);

	@Resource(name = "EzCabinetDAO_h")
	private EzCabinetDAO_h ezCabinetDAO_h;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int startPoint, int listCount, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO_h.getDeptMemberList(map);
	}
	
	@Override
	public List<SimpleUserVO> getShareUserList(String cabinetId, String userId, String sqlQuery, String searchValue, String primary, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cabinetId",   cabinetId);
		map.put("userId",      userId);
		map.put("sqlQuery",    sqlQuery);
		map.put("searchValue", searchValue);
		map.put("primary",     primary);
		map.put("tenantId",    tenantId);
		
		return ezCabinetDAO_h.getShareUserList(map);
	}
	
	@Override
	public int getTotalDeptMembers(String deptId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptId",   deptId);
		map.put("tenantId", tenantId);
		
		return ezCabinetDAO_h.getTotalDeptMembers(map);
	}

	@Override
	public List<SimpleUserVO> getSearchMemberList(String primary, int startPoint, int listCount, String srchOption, String srchValue, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		map.put("srchOption", srchOption);
		map.put("srchValue",  srchValue);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO_h.getSearchMemberList(map);
	}

	@Override
	public int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("srchOption", sqlQuery);
		map.put("srchValue",  srchValue);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO_h.getTotalSearchMembers(map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public synchronized JSONObject saveShareUserList(JSONArray listUsers, String cabinetId, LoginVO userInfo) throws Exception {
		JSONObject result = new JSONObject();
		String userId     = userInfo.getId();
		int tenantId      = userInfo.getTenantId();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cabinetId",   cabinetId);
		map.put("userId",      userId);
		map.put("tenantId",    tenantId);
		
		//Delete all current shared users
		ezCabinetDAO_h.updateShareList(map);
		
		//Add new shared users
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		String companyId           = userInfo.getCompanyID();
		String primary             = userInfo.getPrimary();
		
		map.put("userName1", userInfo.getDisplayName1());
		map.put("userName2", userInfo.getDisplayName2());
		map.put("company",   companyId);
		map.put("shareDate", timeUTC);
		
		int shareId = ezCabinetDAO_h.getMaximumShareId(map) + 1;
		
		for (int i = 0; i < listUsers.size(); i++, shareId++) {
			JSONObject sharedInfo = (JSONObject)listUsers.get(i);
			String sharedId  = (String)sharedInfo.get("userId");
			String userType  = (String)sharedInfo.get("userType");
			String sharePerm = (String)sharedInfo.get("permis");
			String subPerm   = (String)sharedInfo.get("subPerm");
			
			switch(userType) {
				case "user": 
					LoginVO login = new LoginVO();
					login.setId(sharedId);
					login.setDn("NOPASSWORD");
					login.setTenantId(tenantId);
					LoginVO user = loginService.selectUser(login);
					
					if (user == null) {
						result.put("status", "error");
						result.put("code", 4);
						return result;
					}
					
					map.put("shareType", 2);
					break;
				case "dept":
					OrganDeptVO dept = ezOrganService.getDeptInfo(companyId, primary, tenantId);
					if (dept == null) {
						result.put("status", "error");
						result.put("code", 4);
						return result;
					}
					
					map.put("shareType", 1);
					break;
				case "comp": 
					OrganDeptVO company = ezOrganService.getDeptInfo(companyId, primary, tenantId);
					if (company == null) {
						result.put("status", "error");
						result.put("code", 4);
						return result;
					}
					
					map.put("shareType", 0);
					break;
				default:
						result.put("status", "error");
						result.put("code", 4);
						return result;
			}
			
			map.put("sharedId",        sharedId);
			map.put("permission",      Integer.parseInt(sharePerm));
			map.put("childPermission", Integer.parseInt(subPerm));
			map.put("shareId",         shareId);
			ezCabinetDAO_h.saveShareUserList(map);
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	
	
}
