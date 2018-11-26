package egovframework.ezEKP.ezSurvey.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface EzSurveyRestService {
	//Company Tree and users information
	public JSONObject getCompanyTree(HttpServletRequest request, String userId, String companyId) throws Exception;
	public JSONObject getDeptSubNodes(HttpServletRequest request, String id, String deptId, String level) throws Exception;
	public JSONObject getDeptMembers(HttpServletRequest request, String id, String deptId, String currentPage) throws Exception;
	public JSONObject getUserListType(HttpServletRequest request, String id) throws Exception;
	public JSONObject getSearchMember(HttpServletRequest request, String id, String srchOption, String srchValue, String currentPage) throws Exception;
	
	//User upload/download/delete attach file
	public JSONObject uploadAttachFile(MultipartHttpServletRequest request, String userId, List<MultipartFile> multiFiles) throws Exception;
	public JSONObject deleteAttachFile(HttpServletRequest request, String userId, String filePath) throws Exception;
	public void downloadAttachFile(HttpServletRequest request, HttpServletResponse response, String userId, String filePath, String fileName) throws Exception;
}
