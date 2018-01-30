package egovframework.ezEKP.ezWebFolder.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;

@SuppressWarnings("unchecked")
@RestController
public class EzWebFolderGWController extends EgovFileMngUtil {
	@Resource(name = "EzWebFolderAdminService")
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderGWController.class);
	
	@RequestMapping(value="/webfolderadmin/basicstorage/id/{companyid}/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBasicStorage(@PathVariable String companyid, HttpServletRequest request) {	
		int tenantId = Integer.parseInt(request.getParameter("tenantId"));
		
		logger.debug("CompanyId: " + companyid + " || tenantId: " + tenantId);
		
		JSONObject result = new JSONObject();
		
		try {			
			WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyid, tenantId);						
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", webfolderConfig);
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/basicstorage/{newValue}/comp", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject changeBasicStorage(@PathVariable String newValue, HttpServletRequest request) {	
		int tenantId         = Integer.parseInt(request.getParameter("tenantId"));
		String uploadLimit   = request.getParameter("uploadLimit");
		String companyId     = request.getParameter("companyId");
		logger.debug("New Value: " + newValue + " || tenantId: " + tenantId);	
		JSONObject result = new JSONObject();
		
		try {			
			ezWebFolderAdminService.saveConfig(newValue,  uploadLimit, companyId, tenantId);	
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
}
