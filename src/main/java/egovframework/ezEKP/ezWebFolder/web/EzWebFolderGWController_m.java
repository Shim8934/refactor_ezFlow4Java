package egovframework.ezEKP.ezWebFolder.web;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderFileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@RestController
public class EzWebFolderGWController_m {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderGWController_m.class);
	
	@Resource(name = "EzWebFolderService_m")
	private EzWebFolderService_m ezWebFolderService;
	
	@Autowired
	private EzWebFolderService ezWebFolderService2;
	
	@Autowired
	private MOptionService mOptionService ;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private CommonUtil commonUtil;
	
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
	
	@RequestMapping(value="/rest/ezwebfolder/{userId}/getTrashCanList", method=RequestMethod.GET, produces ="application/json;charset=utf-8")
	public JSONObject getTrashCanList (@PathVariable String userId, HttpServletRequest request)  {
		String offset = request.getParameter("offset");
		int tenantId = request.getParameter("tenantId") !=null ? Integer.parseInt(request.getParameter("tenantId")) : 0;
		
		LOGGER.debug("getTrashCanList Started.");
		LOGGER.debug("userId=" + userId + ",offset=" + offset + ",tenantId=" + tenantId);

		JSONObject result = new JSONObject();

		try {
			List<TrashCanVO> trashCanList = null;
			JSONObject trashCanResult = ezWebFolderService.getTrashCanList(userId, offset, tenantId);
			int fileCnt = 0;
			int folderCnt = 0;
			
			if (trashCanResult != null) {
				trashCanList = (List<TrashCanVO>) trashCanResult.get("trashCanList");
				fileCnt = (int) trashCanResult.get("fileCnt");
				folderCnt = (int) trashCanResult.get("folderCnt");
			}
			
			String trashCanPath = "";
			
			if (trashCanList != null) {
				for (TrashCanVO trashCan : trashCanList) {
					trashCanPath = trashCan.getTrashCanPath().substring(1);
					trashCanPath = getFolderPath(trashCanPath.split("\\|"), offset, tenantId);
					
					// is folder
					if ("folder".equalsIgnoreCase(trashCan.getTrashCanExt())) {
						// cut end slash
						trashCanPath = trashCanPath.substring(0, trashCanPath.length() - 1);
					} else {
						trashCanPath += trashCan.getTrashCanName();
					}
					
					trashCan.setTrashCanPath(trashCanPath);
				}
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", trashCanList);
			result.put("fileCnt", fileCnt);
			result.put("folderCnt", folderCnt);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("result=" + result);
		LOGGER.debug("getTrashCanList ended.");
		return result;
	}
	
	private String getFolderPath(String[] paths, String offset, int tenantId) throws Exception {
		StringBuilder result = new StringBuilder("/");
		
		for (String path : paths) {
			FolderVO parentFolder = ezWebFolderService2.getFolderByFolderId(path, offset, tenantId);
			result.append(parentFolder.getFolderName1()).append("/");
		}

		return result.toString();
	}
	
	@RequestMapping(value = "/rest/ezwebfolder/file-permanent-delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject filePermanetDelete(Locale locale, HttpServletRequest request) {
		String offset       = request.getParameter("offset")   != null ? request.getParameter("offset")   : "";
		String listFileId   = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String userId       = request.getParameter("userId")       != null ? request.getParameter("userId")   	  : "";
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String lang         = request.getParameter("lang")     != null ? request.getParameter("lang")     : "";
		
		LOGGER.debug("filePermanetDelete Started.");
		LOGGER.debug("offset=" + offset + ",listFileId=" + listFileId + ",userId=" + userId + ",serverName=" + serverName + ",lang=" + lang);
		
		String[] fileIDList = listFileId.split(",");
		String realPath = request.getServletContext().getRealPath("");
		JSONObject result   = new JSONObject();
		
		if (fileIDList.length == 0 || serverName.equals("") || offset.equals("") || userId.equals("") || lang.equals("")) {
			LOGGER.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			ezWebFolderService.permanetDeleteSelectedFiles(fileIDList, userInfo, realPath);
			
			result.put("status", "ok");
			result.put("code", "0");
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
			result.put("status", "error");
			result.put("code", "1");
		}
		
		LOGGER.debug("filePermanetDelete ended");
		return result;
	}
}
