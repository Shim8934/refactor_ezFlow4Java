package egovframework.ezEKP.ezSurvey.service;

import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;

public interface EzSurveyRestService {
	public JSONObject getCompanyTree(HttpServletRequest request, String userId, String companyId) throws Exception;
	public JSONObject getDeptSubNodes(HttpServletRequest request, String id, String deptId, String level) throws Exception;
}
