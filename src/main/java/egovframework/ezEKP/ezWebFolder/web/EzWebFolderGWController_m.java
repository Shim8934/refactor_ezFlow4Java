package egovframework.ezEKP.ezWebFolder.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.vo.FolderFileVO;

@SuppressWarnings("unchecked")
@RestController
public class EzWebFolderGWController_m {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderGWController_m.class);
	
	@Resource(name = "EzWebFolderService_m")
	private EzWebFolderService_m ezWebFolderService;
	
	/*
	 * 공유 폴더 및 파일 조회
	 * 
	 * @author 강민수79
	 * @date 2018.02.05.
	 * @param userId
	 * @param tenantId
	 * @param companyId
	 * @param startDate
	 * @param endDate
	 * @param extendName
	 * @param fileName
	 * @param createName
	 * @return JSONObject
	 */
	@RequestMapping(value="/ezwebfolder/users/{userId}/folder-files", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getShares(@PathVariable String userId, HttpServletRequest request) {	
		
		LOGGER.debug("userId: " + userId);
		
		JSONObject result = new JSONObject();
		
		try {			
			
			List<FolderFileVO> shares = ezWebFolderService.getShares();
									
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", shares);
			
		} 
		catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		
		}
		
		return result;
	}
	
}
