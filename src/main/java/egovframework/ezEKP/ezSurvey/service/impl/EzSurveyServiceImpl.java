package egovframework.ezEKP.ezSurvey.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezSurvey.dao.EzSurveyDAO;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzSurveyServiceImpl extends EgovFileMngUtil implements EzSurveyService {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzSurveyDAO")
	private EzSurveyDAO ezSurveyDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Override
	public List<SimpleDeptVO> getAllSubDepts(String companyId, int level, String primary, int tenantId) throws Exception {
		List<SimpleDeptVO> deptList = getAllSimpleSubDepts(companyId, level, primary, tenantId);
		return deptList;
	}
	
	@Override
	public String getDeptPath(String deptId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("tenantId",   tenantId);
		return ezSurveyDAO.getDeptPath(map);
	}
	
	@Override
	public SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getSimpleCompany(map);
	}
	
	@Override
	public void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level) throws Exception {
		if (sDept.getHasSub().equals("1")) {
			List<SimpleDeptVO> listSubSimpleDepts = getAllSimpleSubDepts(sDept.getDeptId(), level, primary, tenantId);
			sDept.setSubDepts(listSubSimpleDepts);
			
			for (SimpleDeptVO subDept: listSubSimpleDepts) {
				if (order < path.length && subDept.getDeptId().equals(path[order])) {
					getAllDepts(subDept, path, primary, tenantId, order + 1, level + 1);
				}
			}
		}
	}
	
	private List<SimpleDeptVO> getAllSimpleSubDepts(String deptId, int level, String primary, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getAllSimpleSubDepts(map);
	}
	
	@Override
	public int getTotalDeptMembers(String deptId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptId",   deptId);
		map.put("tenantId", tenantId);
		
		return ezSurveyDAO.getTotalDeptMembers(map);
	}
	
	@Override
	public List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int startPoint, int listCount, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getDeptMemberList(map);
	}
	
	@Override
	public int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("srchOption", sqlQuery);
		map.put("srchValue",  srchValue);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getTotalSearchMembers(map);
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
		
		return ezSurveyDAO.getSearchMemberList(map);
	}
	
	
}