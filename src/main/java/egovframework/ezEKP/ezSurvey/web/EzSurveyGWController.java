package egovframework.ezEKP.ezSurvey.web;

import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@RestController
public class EzSurveyGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzSurveyService surveyService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@RequestMapping(value="/rest/ezsurvey/company-tree/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyTree(HttpServletRequest request) {
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String deptId     = request.getParameter("deptId")    != null ? request.getParameter("deptId")    : "";
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		JSONObject result = new JSONObject();
		
		if (userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		logger.debug("Company Id: " + companyId + " || serverName: " + serverName + " || User Id: " + userId);
		
		try {
			LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName);
			String primary        = userInfo.getPrimary();
			int tenantId          = userInfo.getTenantId();
			deptId                = deptId.equals("")    ? userInfo.getDeptID()    : deptId;
			companyId             = companyId.equals("") ? userInfo.getCompanyID() : companyId;
			SimpleDeptVO sCompany = new SimpleDeptVO();
			
			if (deptId.equals("")) {
				List<SimpleDeptVO> deptList = surveyService.getAllSubDepts(companyId, 1, primary, tenantId);
				sCompany.setSubDepts(deptList);
			}
			else {
				String deptPath  = surveyService.getDeptPath(deptId, tenantId);
				String[] path    = deptPath.split(",");
				sCompany         = surveyService.getSimpleCompany(companyId, 0, primary, tenantId);
				
				surveyService.getAllDepts(sCompany, path, primary, tenantId, 1, 1);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("tree", sCompany);
			result.put("node", deptId);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/sub-tree/{deptid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSubTree(@PathVariable(value="deptid") String deptId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name")                  : "";
		int level         = request.getParameter("level")  != null ? Integer.parseInt(request.getParameter("level")) : -1;
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId")                  : "";
		JSONObject result = new JSONObject();
		
		logger.debug("deptId: " + deptId + " || level: " + level + " || serverName: " + serverName + " || User Id: " + userId);
		
		if (deptId.equals("") || serverName.equals("") || level == -1 || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo            = commonUtil.getUserForGw(userId, serverName);
			List<SimpleDeptVO> subDepts = surveyService.getAllSubDepts(deptId, level + 1, userInfo.getPrimary(), userInfo.getTenantId());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("subNodes", subDepts);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
}
