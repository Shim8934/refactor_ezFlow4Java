package egovframework.ezEKP.ezPMS.web;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.net.URI;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectPagination;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPMSController3 {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSController3.class);
	
	public static final int BUFF_SIZE = 2048;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties config;
	
	@RequestMapping(value="/ezPMS/getBoardMain.do")
	public String getBoardMain(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS getBoardMain started");		
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("onlyGroup", onlyGroup);
		param.put("location", "board");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/projects/" + projectId + "/users/" + userInfo.getId() + "/role", null, request, "get", null);
		
		if(status.equals("ok")) {
			Long userRole = (Long) resultBody.get("data");
			model.addAttribute("userRole", userRole);
		}
		
		model.addAttribute("projectId", projectId);
		
		LOGGER.debug("ezPMS getBoardMain ended");
		
		return "/ezPMS/pmsBoardMain";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/goAddBoard.do")
	public String goAddBoard(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {		
		LOGGER.debug("ezPMS goAddBoard started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String writerName = userInfo.getDisplayName();
		String writerDeptName = userInfo.getDeptName();
		String mode = request.getParameter("mode");
		String projectId = request.getParameter("projectId");
		String groupId   = request.getParameter("groupId");
		String taskId 	 = request.getParameter("taskId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/sysParams/" + userId, param, request, "post", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray configList = (JSONArray) resultBody.get("data");
			
			for(Object configVO : configList) {
				JSONObject configItem = (JSONObject) configVO;
				
				if(configItem.get("name").equals("MailAttachLimit")) {
					model.addAttribute("attachLimit", configItem.get("value"));
				}
			}
		}
		
		param.put("userId", userId);
		param.put("projectId", projectId);
		
		if(!taskId.equals("null") && taskId != null && !taskId.equals("")) {
			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/users/" + userId, param, request, "get", null);
			
			if(status.equals("ok")) {
				JSONObject taskVO = (JSONObject) resultBody.get("data");
				model.addAttribute("taskName", taskVO.get("taskName"));
				model.addAttribute("projectName", taskVO.get("projectName"));
			}
		} else {
			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/groups/" + groupId + "/users/" + userId, param, request, "get", null);
			
			if(status.equals("ok")) {
				JSONObject groupVO = (JSONObject) resultBody.get("data");
				model.addAttribute("taskName", groupVO.get("groupName"));
				model.addAttribute("projectName", groupVO.get("projectName"));
			}
		}
		
				
		if(mode.equals("modify")) {
			String itemId = request.getParameter("itemId");
		
			param.put("itemId", itemId);
			
			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId, param, request, "get", null);
			status = resultBody.get("status").toString();
			
			if(status.equals("ok")) {
				JSONObject board = (JSONObject) resultBody.get("data");
				model.addAttribute("board", board);
				model.addAttribute("writeContent", board.get("writeContent").toString().replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " "));
				JSONArray fileList = (JSONArray) board.get("fileList");
				
				if (fileList != null && fileList.size() > 0) {
					
					for (int i = 0; i < fileList.size(); i++) {
						JSONObject file = (JSONObject) fileList.get(i);
						file.put("pFileName", file.get("fileName"));
						String filePath = file.get("filePath").toString();
						filePath = filePath.substring(filePath.indexOf("{"), filePath.indexOf("}") + 1);
						file.put("pUploadSN", filePath);
						file.put("resultUpload", "true");
						fileList.set(i, file);
					}
					
					model.addAttribute("fileList", URLEncoder.encode(fileList.toString(), "UTF-8").replaceAll("\\+", "%20"));
				}
			}
		} else if(mode.equals("reply")) {
			String itemId = request.getParameter("itemId");
			
			param.put("itemId", itemId);
			
			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId, param, request, "get", null);
			status = resultBody.get("status").toString();
			
			if(status.equals("ok")) {
				JSONObject board = (JSONObject) resultBody.get("data");
				model.addAttribute("board", board);
				model.addAttribute("writeContent", board.get("writeContent").toString().replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " "));
			}
		}
		
		model.addAttribute("writerId", userId);
		model.addAttribute("writerName", writerName);
		model.addAttribute("writerDeptName", writerDeptName);
		
		Enumeration<String> parameterNames = request.getParameterNames();
		
		while(parameterNames.hasMoreElements()) {
			String parameterName = parameterNames.nextElement();
			model.addAttribute(parameterName, request.getParameter(parameterName));
		}
		
		LOGGER.debug("ezPMS goAddBoard ended");
		
		return "/ezPMS/pmsAddBoard";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/addBoard.do")
	public String addBoard(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie") String loginCookie) throws Exception {		
		LOGGER.debug("ezPMS addBoard started");
		
		LOGGER.debug("groupId : " + jsonParam.get("groupId") + ", taskId : " + jsonParam.get("taskId"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String mode = (String) jsonParam.get("mode");
		
		jsonParam.put("tenantId", userInfo.getTenantId());
		
		Map<String, Object> param = null;
		JSONObject resultBody = null;
		
		if(mode.equals("modify")) {
			jsonParam.put("writeUpdateDate", today);		
			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards", param, request, "put", jsonParam);
		} else {
			jsonParam.put("writeDate", today);
			jsonParam.put("writerName", userInfo.getDisplayName());
			jsonParam.put("writerName2", userInfo.getDisplayName2());
			jsonParam.put("writerDeptname", userInfo.getDeptName());
			jsonParam.put("writerDeptname2", userInfo.getDeptName2());
			jsonParam.put("writerPosition", userInfo.getTitle());
			jsonParam.put("writerPosition2", userInfo.getTitle2());
			
			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards", param, request, "post", jsonParam);
		}
		
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("data", mode); // mode(new/modify)에 따라 currentPage = 1로 reset할지의 여부를 결정하기 위함
		}
		
		LOGGER.debug("ezPMS addBoard ended");
		
		return "json";
	}
	
	@RequestMapping(value = "/ezPMS/goMoveBoards.do")
	public String goMoveBoards(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {		
		LOGGER.debug("ezPMS goMoveBoards started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("onlyGroup", onlyGroup);
		param.put("location", "board");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}

		LOGGER.debug("ezPMS goMoveBoards ended");
		
		return "/ezPMS/pmsMoveBoards";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/moveBoards.do")
	public String moveBoards(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS moveBoards started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Map<String, Object> param = null;
		jsonParam.put("userId", userInfo.getId());
		jsonParam.put("deptId", userInfo.getDeptID());
		jsonParam.put("tenantId", userInfo.getTenantId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards", param, request, "put", jsonParam);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("data", "success");
		}
		
		LOGGER.debug("ezPMS moveBoards ended");
		
		return "json";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/deleteBoard.do")
	public String deleteBoard(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS deleteBoard started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Map<String, Object> param = null;
		jsonParam.put("userId", userInfo.getId());
		jsonParam.put("deptId", userInfo.getDeptID());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards", param, request, "delete", jsonParam);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("data", "success");
		}
		
		LOGGER.debug("ezPMS deleteBoard ended");
		
		return "json";
	}
	
	@RequestMapping(value="/ezPMS/getTaskSelectionTree.do")
	public String getTaskSelectionTree(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {		
		LOGGER.debug("ezPMS getTaskSelectionTree started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("onlyGroup", onlyGroup);
		param.put("location", "board");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}
				
		LOGGER.debug("ezPMS getTaskSelectionTree ended");
		
		return "/ezPMS/pmsTaskSelectionTree";
	}
	
	@RequestMapping(value="/ezPMS/getBoardList.do")
	public String getBoardList(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) throws Exception {	
		LOGGER.debug("ezPMS getBoardList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int boardCount = 0;
		int totalCount = 0;
		int listCnt = (int) param.get("limit");
		int countPage = 10;
		int currentPage = (int) param.get("currentPage");
		int projectId = (int) param.get("projectId");
		
		// 새 글 여부를 판단하기 위해서 하루 이전의 시간을 계산해서 넘김
		String todayStr = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar yesterday = Calendar.getInstance();
		yesterday.setTime(sdf.parse(todayStr));
		yesterday.add(Calendar.DATE, -1);
		
		// 검색 조건에 지정된 날짜 + 1을 검색 조건으로 재지정(searchByEndDate + 1 0시 이전 글 검색)	
		String endDate = (String) param.get("searchByEndDate");
		
		if(endDate != null) {
			
			if(!endDate.equals("")) {
				SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
				Calendar searchByEndDate = Calendar.getInstance();
				searchByEndDate.setTime(sdf2.parse((String) param.get("searchByEndDate")));
				searchByEndDate.add(Calendar.DATE, 1);
				param.put("searchByEndDate", sdf2.format(searchByEndDate.getTime()));
			}
		}
		
		
		model.addAttribute("yesterday", sdf.format(yesterday.getTime()));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/list-count/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			boardCount = Integer.parseInt((String) resultBody.get("data1"));
			totalCount = Integer.parseInt((String) resultBody.get("data2"));
			model.addAttribute("boardCount", boardCount);
			model.addAttribute("totalCount", totalCount);
		}
		
		
		ProjectPagination paging = new ProjectPagination(totalCount, listCnt, countPage, currentPage);
		model.addAttribute("paging", paging);
		
		int startRow = paging.getStartCount() > 0 ? paging.getStartCount() : 0;
		
		param.put("startRow", startRow);
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray boardList = (JSONArray) resultBody.get("data");
			String taskName = (String) resultBody.get("taskName");
			model.addAttribute("data", boardList);
			model.addAttribute("taskName", taskName);
		} 
		
		
		LOGGER.debug("ezPMS getBoardList ended");
		
		return "/ezPMS/pmsBoardList";
	}
	
	@RequestMapping(value = "/ezPMS/dragAndDrop.do")
	public String projectDragAndDrop(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("ezPMS projectDragAndDrop started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String attachFileNameMaxLength = commonUtil.getTenantConfigRest("attachFileNameMaxLength", userInfo.getId(), request);
			
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		String mode = "";
		String projectId = "";
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("projectId") != null && !request.getParameter("projectId").equals("")) {
			projectId = request.getParameter("projectId");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("mode", mode);
		model.addAttribute("projectId", projectId);
		LOGGER.debug("ezPMS projectDragAndDrop ended");
		
		return "/ezPMS/pmsDragAndDrop";
	}
	
	@SuppressWarnings({"unchecked", "rawtypes"})
	@ResponseBody
	@RequestMapping(value = "/ezPMS/uploadProjectAttach.do", produces = "text/plain; charset=utf-8")
	public String uploadProjectAttach(MultipartHttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("ezPMS uploadProjectAttach started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.projectGWServerURL");
		String url = gwServerUrl + "/rest/ezPMS/attachfiles";
		
		URI uri = URI.create(url);
		
		List<MultipartFile> files = request.getFiles("fileToUpload"); 
		int cnt = files.size();
		int maxSize = 0;
		LOGGER.debug("###files : " + files + ", cnt: " + cnt);
		
		Long[] fileSize = new Long[cnt];        
        String[] resultUpload = new String[cnt];
        String[] sGUID = new String[cnt];
        String[] pUploadSN = new String[cnt];
        maxSize = Integer.parseInt(request.getParameter("maxSize"));
        JSONObject jsonObject = new JSONObject();
        JSONArray jsonArray = new JSONArray();
        
        String mode = "";
		String projectId = "";
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("projectId") != null && !request.getParameter("projectId").equals("")) {
			projectId = request.getParameter("projectId");		
		}

		LOGGER.debug("mode : " + mode + " | projectId : " + projectId);
		
		for (int i = 0; i < cnt; i++) {
            resultUpload[i] = "false";
            sGUID[i] = UUID.randomUUID().toString();
            pUploadSN[i] = "{" + sGUID[i] + "}";
        }
        
        HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		if (StringUtils.isNotEmpty(files.get(0).getOriginalFilename()) && StringUtils.isNotBlank(files.get(0).getOriginalFilename()) && cnt > 0) {   
			
            for (int i = 0; i < cnt; i++) {
            	JSONObject fileJson = new JSONObject();
            	
            	byte[] bytes = files.get(i).getBytes();
            	fileSize[i] = files.get(i).getSize();
                String originalFilename = files.get(i).getOriginalFilename();
                fileJson.put("bytes", bytes);
                fileJson.put("fileSize", fileSize[i]);
                fileJson.put("originalFilename", originalFilename);
                
                jsonArray.add(fileJson);
            }
        }
		
        jsonObject.put("fileArray", jsonArray);
		jsonObject.put("cnt", cnt);
		jsonObject.put("maxSize", maxSize);
		jsonObject.put("userId",userInfo.getId());
        
		HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers);
		
        RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(uri, HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
	
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		Object data = "";
		
		if (status.equals("ok")) {
			data = resultBody.get("data");
			model.addAttribute("data", data.toString());
		}

		LOGGER.debug("status: " + status);
        LOGGER.debug("uploadProjectAttach ended");
        
        return data.toString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezPMS/uploadFileDelete.do")
	public String uploadFileDelete(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("ezPMS uploadFileDelete started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String fileList = request.getParameter("fileList");
		
		String filePath = "";
		
		LOGGER.debug("fileList : " + fileList);

		filePath = "tempUploadFile";
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("filePath", filePath);
		param.put("fileList", fileList);
		
		String restUrl = "/rest/ezPMS/attachfiles";
		JSONObject resultBody = commonUtil.getJsonFromRestApi(restUrl, param, request, "delete", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			LOGGER.debug("status : " + status);
		}

		LOGGER.debug("ezPMS uploadFileDelete ended");
        
        return status;
	}
	
	@RequestMapping(value = "/ezPMS/downloadFile.do")
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("ezPMS downloadFile started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("filePath", filePath);
		
		JSONObject result = commonUtil.getJsonFromRestApi("/rest/ezPMS/attachfiles", param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject data = (JSONObject) result.get("data");
			String bytes = (String) data.get("bytes");
			int fileSize = Integer.parseInt((String)data.get("fileSize"));
			
			String mimetype = "application/octet-stream";
		    byte[] tempBytes = Base64.getDecoder().decode(bytes);
		    
		    fileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), fileName);
		    
		    try(InputStream is = new ByteArrayInputStream(tempBytes)) {
		    	response.setBufferSize(BUFF_SIZE);
		    	response.setContentType(mimetype);
		    	response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
		    	response.setContentLength(fileSize);
		    	
		    	FileCopyUtils.copy(is, response.getOutputStream());
		    	
		    	response.getOutputStream().flush();
		    	response.getOutputStream().close();
		    } catch (Exception e) {
		    	LOGGER.debug("ezPMS downloadFile error");
		    }	    
		} else if(status.equals("fileNotFound")) {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			
			StringBuffer sb = new StringBuffer();
			sb.append("<script type='text/javascript'>");
			sb.append("alert('파일을 찾을 수 없습니다');");
			sb.append("history.go(-1);");
			sb.append("</script>");
			
			response.getWriter().println(sb.toString());
			response.getWriter().close();
			
		}	
		
		LOGGER.debug("ezPMS downloadFile ended");
	}
	
	@RequestMapping(value = "/ezPMS/getBoardDetail.do")
	public String getBoardDetail(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS getBoardDetail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String itemId = request.getParameter("itemId");
		String userId = userInfo.getId();
		String deptId = userInfo.getDeptID();
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", userId);
		param.put("userName", userInfo.getDisplayName());
		param.put("userName2", userInfo.getDisplayName2());
		param.put("userDeptName", userInfo.getDeptName());
		param.put("userDeptName2", userInfo.getDeptName2());
		param.put("projectId", projectId);
		param.put("deptId", deptId);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONObject board = (JSONObject) resultBody.get("data");
			model.addAttribute("board", board);
			Long authority = (Long) resultBody.get("authority");
			model.addAttribute("authority", authority);
		}
		
		model.addAttribute("userId", userId);
		
		LOGGER.debug("ezPMS getBoardDetail ended");
		
		return "/ezPMS/pmsBoardDetail";
	}
	
	@RequestMapping(value = "/ezPMS/getBoardViewerList.do")
	public String getBoardViewerList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS getBoardViewerList started");
		
		int totalCount = 0;
		int currentPage = 1;
		int listCnt = 10;
		int countPage = 10;
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String itemId = request.getParameter("itemId");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId + "/viewer-count", param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			totalCount = Integer.parseInt((String) resultBody.get("data"));
		}
		
		LOGGER.debug("totalCount : " + totalCount);
		
		String currentPageStr = request.getParameter("currentPage");
		
		if(currentPageStr != null && !currentPageStr.equals("")) {
			currentPage = Integer.parseInt(currentPageStr);
		}
		
		ProjectPagination paging = new ProjectPagination(totalCount, listCnt, countPage, currentPage);
		model.addAttribute("paging", paging);
		
		param.put("startRow", paging.getStartCount());
		param.put("limit", listCnt);
		
		if(totalCount > 0) {
			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId + "/viewers/", param, request, "get", null);
			status = resultBody.get("status").toString();
			
			if(status.equals("ok")) {
				JSONArray viewerList = (JSONArray) resultBody.get("data");
				model.addAttribute("viewerList", viewerList);
			} 
		}
		
		LOGGER.debug("ezPMS getBoardViewerList ended");
		
		return "/ezPMS/pmsBoardViewerList";
	}
	
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/ezPMS/boardDetailJSON.do")
	public JSONObject getboardJSON(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS getboardJSON started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("projectId", request.getParameter("projectId"));
		
		String itemId = request.getParameter("itemId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		JSONObject board = null;
		
		if (status.equals("ok")) {			
			board = (JSONObject) resultBody.get("data");
			String boardContent = ((String) board.get("writeContent")).replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " ");
			board.put("boardContent", boardContent);
		}
		
		LOGGER.debug("ezPMS getboardJSON ended");
		
		return board;
	}
	
	/**
	 * 프로젝트 의견 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/getCommentMain.do")
	public String getCommentMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getCommentMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("onlyGroup", onlyGroup);
		param.put("location", "comment");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}
		
		model.addAttribute("projectId", projectId);
		
		LOGGER.debug("ezPMS getCommentMain ended");		
		return "ezPMS/pmsCommentMain";
	}
	
	@RequestMapping(value="/ezPMS/getCommentList.do")
	public String getCommentList(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) throws Exception {	
		LOGGER.debug("ezPMS getCommentList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int totalCount = 0;
		int listCnt = (int) param.get("limit");
		int countPage = 10;
		int currentPage = (int) param.get("currentPage");
		String projectId = (String) param.get("projectId");
	
		// 검색 조건에 지정된 날짜 + 1을 검색 조건으로 재지정(searchByEndDate + 1 0시 이전 글 검색)	
		String endDate = (String) param.get("searchByEndDate");
		
		if(endDate != null) {
			
			if(!endDate.equals("")) {
				SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
				Calendar searchByEndDate = Calendar.getInstance();
				searchByEndDate.setTime(sdf2.parse((String) param.get("searchByEndDate")));
				searchByEndDate.add(Calendar.DATE, 1);
				param.put("searchByEndDate", sdf2.format(searchByEndDate.getTime()));
			}
		}
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/comments/list-count/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			totalCount = Integer.parseInt((String) resultBody.get("data"));
			model.addAttribute("totalCount", totalCount);
		}
		
		
		ProjectPagination paging = new ProjectPagination(totalCount, listCnt, countPage, currentPage);
		model.addAttribute("paging", paging);
		
		int startRow = paging.getStartCount() > 0 ? paging.getStartCount() : 0;
		param.put("startRow", startRow);
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/comments/list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray commentList = (JSONArray) resultBody.get("data");
			String taskName = (String) resultBody.get("taskName");
			model.addAttribute("data", commentList);
			model.addAttribute("taskName", taskName);
		} 
		
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/projects/" + projectId + "/users/" + userInfo.getId() + "/role", null, request, "get", null);
		
		if(status.equals("ok")) {
			Long userRole = (Long) resultBody.get("data");
			model.addAttribute("userRole", userRole);
		}
		
		LOGGER.debug("ezPMS getCommentList ended");
		
		return "/ezPMS/pmsCommentList";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/addComment.do")
	public String addComment(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie") String loginCookie) throws Exception {		
		LOGGER.debug("ezPMS addComment started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		Map<String, Object> param = null;
		
		jsonParam.put("tenantId", userInfo.getTenantId());
		jsonParam.put("updateDate", today);
		jsonParam.put("writerId", userInfo.getId());
		jsonParam.put("writeDate", today);
		jsonParam.put("writerName", userInfo.getDisplayName());
		jsonParam.put("writerName2", userInfo.getDisplayName2());
		jsonParam.put("writerDeptName", userInfo.getDeptName());
		jsonParam.put("writerDeptName2", userInfo.getDeptName2());
	
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/comments", param, request, "post", jsonParam);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("data", "success"); // mode(new/modify)에 따라 currentPage = 1로 reset할지의 여부를 결정하기 위함
		}
		
		LOGGER.debug("ezPMS addComment ended");
		
		return "json";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/deleteComment.do")
	public String deleteComment(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS deleteComment started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Map<String, Object> param = null;
		jsonParam.put("userId", userInfo.getId());
		jsonParam.put("deptId", userInfo.getDeptID());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/comments", param, request, "delete", jsonParam);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("data", "success");
		}
		
		LOGGER.debug("ezPMS deleteComment ended");
		
		return "json";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/modifyComment.do")
	public String modifyComment(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS modifyComment started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Map<String, Object> param = null;
		jsonParam.put("userId", userInfo.getId());
		jsonParam.put("deptId", userInfo.getDeptID());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/comments", param, request, "put", jsonParam);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("data", "success");
		}
		
		LOGGER.debug("ezPMS modifyComment ended");
		
		return "json";
	}
	
	@RequestMapping(value = "/ezPMS/getCommentListTab.do")
	public String getCommentListTab(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("ezPMS getCommentListTab started");
		
		String projectId = request.getParameter("projectId");
		String groupId = request.getParameter("groupId");
		String taskId = request.getParameter("taskId");
		
		model.addAttribute("projectId", projectId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("taskId", taskId);
		
		LOGGER.debug("ezPMS getCommentListTab ended");		
		return "ezPMS/pmsCommentListTab";
	}
	
	@RequestMapping(value = "/ezPMS/goPreTaskSelectionTree.do")
	public String goPreTaskSelectionTree(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS goPreTaskSelectionTree started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("onlyGroup", onlyGroup);
		param.put("location", "");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}
		
		LOGGER.debug("ezPMS goPreTaskSelectionTree ended");
		return "/ezPMS/pmsPreTaskSelectionTree";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/checkIfBoardHasReplies.do")
	public String checkIfBoardHasReplies(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS checkIfHasReplies started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		jsonParam.put("userId", userInfo.getId());
		
//		List<String> itemIds = (List<String>) jsonParam.get("itemIds");
//		LOGGER.debug("itemIds : " + itemIds);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/checkIfHasReplies", null, request, "post", jsonParam);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			boolean ifBoardHasReplies = (boolean) resultBody.get("data");
			model.addAttribute("data", ifBoardHasReplies);
		}
		
		LOGGER.debug("ezPMS checkIfHasReplies ended");
		return "json";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/checkIfExistPreTaskRel.do")
	public String checkIfExistPreTaskRel(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS checkIfExistPreTaskRel started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		jsonParam.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/checkIfExistPreTaskRel/" + jsonParam.get("pretaskId"), null, request, "post", jsonParam);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			boolean ifExistPreTaskRel = (boolean) resultBody.get("data");
			model.addAttribute("data", ifExistPreTaskRel);
		}
		
		LOGGER.debug("ezPMS checkIfExistPreTaskRel ended");
		return "json";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/deletePretaskRel.do")
	public String deletePretaskRel(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS deletePretaskRel started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		jsonParam.put("userId", userInfo.getId());
		
		String url = "/rest/ezPMS/tasks/" + jsonParam.get("taskId") + "/preTasks/" + jsonParam.get("pretaskId");
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, null, request, "delete", jsonParam);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("data", "success");
		}
		
		LOGGER.debug("ezPMS deletePretaskRel ended");
		return "json";
	}
	
	@RequestMapping(value = "/ezPMS/updateAllTasksDate.do")
	public String updateAllTasksDate(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS updateAllTasksDate started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String url = "/rest/ezPMS/tasks/multiple-tasks/users/" + userInfo.getId();
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, null, request, "put", jsonParam);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("data", "success");
		}
		
		LOGGER.debug("ezPMS updateAllTasksDate ended");
		return "json";
	}
}
