package egovframework.ezEKP.ezWebFolder.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
	@RequestMapping(value="/ezwebfolder/users/{userId}/folder-files", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getShares(@PathVariable String userId, HttpServletRequest request) {
		String companyId = request.getParameter("companyId");
		String deptId = request.getParameter("deptId");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String fileExt = request.getParameter("fileExt");
		String fileName = request.getParameter("fileName");
		String createName = request.getParameter("createName");
		String pageSize = request.getParameter("pageSize");
		String pageNum = request.getParameter("pageNum");
		String fileType = request.getParameter("fileType");
		int tenantId = Integer.parseInt(request.getParameter("tenantId"));
		String type = "GET";
		
		LOGGER.debug("userId: " + userId);
		
		JSONObject result = new JSONObject();
		
		try {
			List<FolderFileVO> shares = ezWebFolderService.getShares(companyId, deptId, userId, startDate, endDate, fileExt, fileName, createName, pageSize, pageNum, fileType, tenantId, type);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", shares);
			
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		
		}
		
		return result;
	}
	
	/*
	 * 공유 폴더 및 파일 수정
	 * 
	 * @author 강민수79
	 * @date 2018.02.21.
	 * @param tenantId
	 * @param companyId
	 * @param creatId
	 * @param folderFileId
	 * @param folderFileType
	 * @param userList
	 * @return JSONObject
	 */
	@RequestMapping(value="/ezwebfolder/folder-files/{folderFileId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateShareUser(@PathVariable String folderFileId, HttpServletRequest request) throws Exception {
		Map map = new HashMap<String,Object>();
		String companyId = request.getParameter("companyId");
		String createId = request.getParameter("createId");
		String userList = request.getParameter("userList");
		String folderFileType = request.getParameter("folderFileType");
		int tenantId = Integer.parseInt(request.getParameter("tenantId"));
		
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("companyId", companyId);
		map.put("createId", createId);
		map.put("tenantId", tenantId);
		
		JSONParser jparser = new JSONParser();
		Object obj = jparser.parse(userList);
		JSONArray jarray = (JSONArray) obj;
		
		ezWebFolderService.delShare(companyId, folderFileId, folderFileType, createId, tenantId);
		
		for (int i = 0; i < jarray.size(); i++) {
			
			JSONObject jobj = (JSONObject) jarray.get(i);
		
			ezWebFolderService.insertShare(ezWebFolderService.getShareSeq(tenantId), companyId, (String)jobj.get("userId"), (String)jobj.get("userType"), folderFileId, folderFileType, createId, tenantId);
			
		}
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}
	
	/*
	 * 즐겨찾기 대상 조회
	 * 
	 * @author 강민수79
	 * @date 2018.02.22.
	 * @param userId
	 * @param tenantId
	 * @param companyId
	 * @return JSONObject
	 */
	@RequestMapping(value="/ezwebfolder/users/{userId}/favorites", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFavoriteList(@PathVariable String userId, HttpServletRequest request) {	
		
		String companyId = request.getParameter("companyId");
		int tenantId = Integer.parseInt(request.getParameter("tenantId"));	
		
		LOGGER.debug("userId: " + userId);
		
		JSONObject result = new JSONObject();
		
		try {			
			
						
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
