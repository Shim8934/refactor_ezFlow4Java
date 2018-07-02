package egovframework.ezEKP.ezPMS.web;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Base64.Decoder;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.BoardViewerVO;
import egovframework.ezEKP.ezPMS.vo.CommentVO;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzPMSGWController3 {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSGWController3.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name="EzPMSService")
	private EzPMSService ezPMSService;
	
	@Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addBoard(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards] started");
		
		JSONObject result = new JSONObject();
		
		try {
			String realPath = commonUtil.getRealPath(request);
			
			ezPMSService.addBoard(jsonParam, realPath);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject modifyBoard(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/boards] started");
		
		JSONObject result = new JSONObject();
		
		try {
			String realPath = commonUtil.getRealPath(request);
			
			// 메인 화면에서 게시물을 다른 작업으로 이동 시, 여러 개를 선택할 수 있다. 그 때만 itemIds가 넘어옴
			if(jsonParam.get("itemIds") != null) {
				ezPMSService.moveBoard(jsonParam);
			} else {
				ezPMSService.modifyBoard(jsonParam, realPath);
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/boards] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards", method = RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteBoard(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/boards] started");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			ezPMSService.deleteBoard(info.getTenantId(), jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/boards] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/list/{projectId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBoardList(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list/" + projectId +"/users/" + userId + "] started");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			String uploadPathName = "uploadFile";
			
			Long groupId = 0L;
			Long taskId = 0L;
			
			if(request.getParameter("groupId")!= null && !request.getParameter("groupId").equals("")) {
				groupId = Long.parseLong(request.getParameter("groupId"));	
			} 
			
			if(request.getParameter("taskId")!= null && !request.getParameter("taskId").equals("") && !request.getParameter("taskId").equals("null")) {
				taskId = Long.parseLong(request.getParameter("taskId"));	
			}
			
			int startRow = Integer.parseInt(request.getParameter("startRow"));
			int listCnt = Integer.parseInt(request.getParameter("limit"));
			String position = request.getParameter("position");
			String orderWhat = request.getParameter("orderWhat");
			String orderHow = request.getParameter("orderHow");
			String searchByTaskName = request.getParameter("searchByTaskName");
			String searchByUser = request.getParameter("searchByUser");
			String searchByStartDate = request.getParameter("searchByStartDate");
			String searchByEndDate = request.getParameter("searchByEndDate");
			String searchByTitle = request.getParameter("searchByTitle");
			String searchByOverview = request.getParameter("searchByOverview");
			String searchByContent = request.getParameter("searchByContent");
			String searchOrNot = request.getParameter("searchOrNot");
			
			if (searchByTaskName != null  && !searchByTaskName.equals("")) {
				searchByTaskName = searchByTaskName.replace("\\","\\\\");
				searchByTaskName = searchByTaskName.replace("%", "\\%");
				searchByTaskName = searchByTaskName.replace("_", "\\_");
			}
			
			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\","\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
			}
			
			if (searchByTitle != null && !searchByTitle.equals("")) {
				searchByTitle = searchByTitle.replace("\\","\\\\");
				searchByTitle = searchByTitle.replace("%", "\\%");
				searchByTitle = searchByTitle.replace("_", "\\_");
			}
			
			if (searchByOverview != null && !searchByOverview.equals("")) {
				searchByOverview = searchByOverview.replace("\\","\\\\");
				searchByOverview = searchByOverview.replace("%", "\\%");
				searchByOverview = searchByOverview.replace("_", "\\_");
			}
			
			if (searchByContent != null && !searchByContent.equals("")) {
				searchByContent = searchByContent.replace("\\","\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
			}
			
			int noticeCNT = ezPMSService.getBoardNoticeListCount(tenantId, Long.parseLong(projectId), groupId, taskId);
			List<ProjectBoardVO> boardList = null;
			
			// 프로젝트 개요/게시판 검색 시에는 공지사항을 제외한 게시물만 출력
			if((position != null && position.equals("overview")) || searchOrNot.equals("true")) {
				boardList = ezPMSService.getBoardList(tenantId, Long.parseLong(projectId), groupId, taskId, userId, 
						   startRow, listCnt, lang, position, orderWhat, orderHow,
						   searchByTaskName, searchByUser, searchByStartDate, searchByEndDate, 
						   searchByTitle, searchByOverview, searchByContent);
			} else if(position != null && (position.equals("tab") || position.equals("boardMain"))){
				
				if(noticeCNT > startRow) {
					boardList = ezPMSService.getBoardNoticeList(tenantId, Long.parseLong(projectId), groupId, taskId, startRow, listCnt, lang);
					
					boardList.forEach(boardVO -> boardVO.setNotice(true));
					
					if(noticeCNT < startRow + listCnt) {
						listCnt = (startRow + listCnt) - noticeCNT;
						startRow = 0;
						boardList.addAll(ezPMSService.getBoardList(tenantId, Long.parseLong(projectId), groupId, taskId, userId, 
																		   startRow, listCnt, lang, position, orderWhat, orderHow,
																		   searchByTaskName, searchByUser, searchByStartDate, searchByEndDate, 
																		   searchByTitle, searchByOverview, searchByContent));
					}
				} else {
					startRow = startRow - noticeCNT;
					boardList = ezPMSService.getBoardList(tenantId, Long.parseLong(projectId), groupId, taskId, userId, 
														   startRow, listCnt, lang, position, orderWhat, orderHow,
														   searchByTaskName, searchByUser, searchByStartDate, searchByEndDate, 
														   searchByTitle, searchByOverview, searchByContent);
				}
			}
			
			
			String imageFileType = "PNG,JPEG,BMP,GIF,JPG";
			
			for (int i = 0; i < boardList.size(); i++) {
				int fileCount = boardList.get(i).getFileCNT();
				if (fileCount > 0) {
					String filePath = "";
					
					List<Map<String, Object>> filePathList = ezPMSService.getFilePath(boardList.get(i).getItemId(), info.getTenantId());
					
					for (int j = 0; j < filePathList.size(); j++) {
						String fileName = filePathList.get(j).get("fileName").toString();
						
						if (fileName.indexOf(".") != -1) {
							fileName = fileName.substring(fileName.indexOf(".") + 1, fileName.length()).toUpperCase();
							
							if (imageFileType.contains(fileName)) {
								filePath = filePathList.get(j).get("filePath").toString().substring(1);
								String realPath = commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId())+ commonUtil.separator + uploadPathName + commonUtil.separator +  filePath;
								
								boardList.get(i).setImageFilePath("/ezCommon/downloadAttach.do?filePath=" + realPath);
							}
						}
					}
				}
			}
			
			String taskName = "";
			
			if(taskId != 0) {
				ProjectTaskVO taskVO = ezPMSService.getTaskDetails(taskId, tenantId, lang);
				taskName = taskVO.getTaskName();
			} else if(groupId != 0){
				ProjectGroupVO groupVO = ezPMSService.getGroupDetails(groupId, tenantId, Long.parseLong(projectId));
				taskName = groupVO.getGroupName();
			}
			
			LOGGER.debug("taskName : " + taskName);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", boardList);		
			result.put("taskName", taskName);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list/" + projectId +"/users/" + userId + "] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/list-count/{projectId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBoardListCount(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list-count/" + projectId + "/users/" +  userId+ "] started");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			Long groupId = 0L;
			Long taskId = 0L;
			
			if(request.getParameter("groupId")!=null && !request.getParameter("groupId").equals("")) {
				groupId = Long.parseLong(request.getParameter("groupId"));	
			} 
			
			if(request.getParameter("taskId")!=null && !request.getParameter("taskId").equals("")) {
				taskId = Long.parseLong(request.getParameter("taskId"));	
			}
			
			String searchByTaskName = request.getParameter("searchByTaskName");
			String searchByUser = request.getParameter("searchByUser");
			String searchByStartDate = request.getParameter("searchByStartDate");
			String searchByEndDate = request.getParameter("searchByEndDate");
			String searchByTitle = request.getParameter("searchByTitle");
			String searchByOverview = request.getParameter("searchByOverview");
			String searchByContent = request.getParameter("searchByContent");
			
			if (searchByTaskName != null  && !searchByTaskName.equals("")) {
				searchByTaskName = searchByTaskName.replace("\\","\\\\");
				searchByTaskName = searchByTaskName.replace("%", "\\%");
				searchByTaskName = searchByTaskName.replace("_", "\\_");
			}
			
			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\","\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
			}
			
			if (searchByTitle != null && !searchByTitle.equals("")) {
				searchByTitle = searchByTitle.replace("\\","\\\\");
				searchByTitle = searchByTitle.replace("%", "\\%");
				searchByTitle = searchByTitle.replace("_", "\\_");
			}
			
			if (searchByOverview != null && !searchByOverview.equals("")) {
				searchByOverview = searchByOverview.replace("\\","\\\\");
				searchByOverview = searchByOverview.replace("%", "\\%");
				searchByOverview = searchByOverview.replace("_", "\\_");
			}
			
			if (searchByContent != null && !searchByContent.equals("")) {
				searchByContent = searchByContent.replace("\\","\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
			}
			
			int noticeCount = ezPMSService.getBoardNoticeListCount(tenantId, Long.parseLong(projectId), groupId, taskId);
			int boardCount = ezPMSService.getBoardListCount(tenantId, Long.parseLong(projectId), groupId, taskId,
															searchByTaskName, searchByUser, searchByStartDate, searchByEndDate, 
															searchByTitle, searchByOverview, searchByContent);
			int totalCount = noticeCount + boardCount;
			
			result.put("data", boardCount + "");
			result.put("data2", totalCount + "");	// JSON으로 넘기면 숫자가 Long으로 바뀌는데 Long에서 int로 cast할 때의 오류를 피하기 위해서 String으로 바꾼 후에 파싱한다
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list-count/" + projectId + "/users/" +  userId+ "] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezPMS/attachfiles", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject uploadFile(HttpServletRequest request, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/attachfiles] started");
		
		JSONObject result = new JSONObject();
		
		JSONParser jp = new JSONParser();
		jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
		
		String uploadPathName = "uploadFile";
		String tempUploadPathName = "tempUploadFile";
		
		try {
			JSONArray fileArray = new JSONArray();
			String userId = "";
			int cnt = 0;
			int maxSize = 0;
			
			if (jsonParam.get("fileArray") != null) {
				fileArray = (JSONArray) jsonParam.get("fileArray");
			}	
			
			if (jsonParam.get("cnt") != null) {
				cnt =  ((Long) jsonParam.get("cnt")).intValue();
			}	
			
			if (jsonParam.get("maxSize") != null) {
				maxSize =  ((Long) jsonParam.get("maxSize")).intValue();
			}	
			
			if (jsonParam.get("userId") != null) {
				userId = (String) jsonParam.get("userId");
			}
			
			LOGGER.debug("####cnt:" + cnt + ", maxSize:" + maxSize + ", userId:" + userId);
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String realPath = commonUtil.getRealPath(request);
			String[] pFileName = new String[cnt];
			Long[] fileSize = new Long[cnt];
			String[] fileLocation = new String[cnt];
			String[] resultUpload = new String[cnt];
			String[] sGUID = new String[cnt];
			String[] pUploadSN = new String[cnt];

			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", info.getTenantId());
			
			for (int i = 0; i < cnt; i++) {
	            resultUpload[i] = "false";
	            sGUID[i] = UUID.randomUUID().toString();
	            pUploadSN[i] = "{" + sGUID[i] + "}";
	        }
		
			if (useExtension == null) {
				useExtension = "";
			}
			
			if (((JSONObject)fileArray.get(0)).get("originalFilename") != null && StringUtils.isNotBlank((String) ((JSONObject)fileArray.get(0)).get("originalFilename"))) {
				String _pFileName = "";
				
				for (int i = 0; i < cnt; i++) {
	                _pFileName = (String) ((JSONObject)fileArray.get(i)).get("originalFilename");
	                
	                // 폴더패스를 제외한 파일명을 구한다.
	                if (_pFileName.indexOf(commonUtil.separator) > 0) {
	                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
	                }
	                
	                pFileName[i] = _pFileName;
	            }
	        }
			
			String pDirPath = commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId());
	        pDirPath = realPath + pDirPath;
	        
	        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
	        	pDirPath = pDirPath + commonUtil.separator;
	        }
	        
	        File file = new File(pDirPath + uploadPathName);
	        File tempFile = new File(pDirPath + tempUploadPathName);

	        if (!file.exists()) {
	        	file.mkdirs();
	        }
	        
	        if (!tempFile.exists()) {
	        	tempFile.mkdir();
	        }
	        
	        for (int i = 0; i < cnt; i++) {
	        	fileSize[i] = (Long) ((JSONObject)fileArray.get(i)).get("fileSize");
	        	String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
	        	String newFileName = pUploadSN[i] + "." + extend;
        		
	        	// maxsize를 넘어가는 파일은 저장하지 않는다.
	            if (fileSize[i] > maxSize && maxSize != 0) {
	                resultUpload[i] = "overflow";
	            } else {
	            	// 허용하는 확장자가 아닌경우 저장하지 않는다.
                    if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1 && !useExtension.equals("*")) {
                        resultUpload[i] = "denied";
                    } else {
                        String pAttachPath = pDirPath + tempUploadPathName + commonUtil.separator;
                        
                        // 업로드된 파일 데이터를 파일로 저장한다.
                        uploadFile((String)((JSONObject)fileArray.get(i)).get("bytes"), newFileName, pAttachPath);
                        
                        fileLocation[i] = commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId()) + commonUtil.separator + tempUploadPathName + commonUtil.separator + pUploadSN[i];
                        resultUpload[i] = "true";
                    }
	            }
	        }

	        List<JSONObject> filelist = new ArrayList<JSONObject>();
	        
	        for (int i = 0; i < cnt; i++) {
	        	JSONObject fileInfo = new JSONObject();
	        	fileInfo.put("pUploadSN", pUploadSN[i]);
	        	fileInfo.put("pFileName", pFileName[i]);
	        	fileInfo.put("fileSize", fileSize[i]);
	        	fileInfo.put("fileLocation", fileLocation[i]);
	        	fileInfo.put("resultUpload", resultUpload[i]);
	        	filelist.add(i, fileInfo);
	        }
	        result.put("data", filelist);
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 0);
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/attachfiles] ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezPMS/attachfiles", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteFile(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/attachfiles] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId());
			String filePath = request.getParameter("filePath");
			String fileList = request.getParameter("fileList");
			
			LOGGER.debug("pDirPath : " + pDirPath + " | fileList : " + fileList);
			
			if (fileList.length() != 0) {
				String[] data = fileList.split("/"); 
				
				for (int i = 0; i < data.length; i++) {
					String sGUID = data[i].split(":")[0];
					String fileName = data[i].split(":")[1];
					String extension = fileName.substring(fileName.lastIndexOf(".") + 1);
					LOGGER.debug("sGUID:" + sGUID + ",fileName:" + fileName);
					
					File file = new File(pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID + "." + extension);
					
					file.delete();
				}			
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			e.printStackTrace();
		}
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/attachfiles] ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezPMS/attachfiles", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject downloadFile(HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/attachfiles] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			String realPath = commonUtil.getRealPath(request);
			String uploadFilePath = commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId());
			String filePath = request.getParameter("filePath");
			realPath += uploadFilePath + commonUtil.separator + "uploadFile" + filePath;
			
			LOGGER.debug("filePath on download : " + realPath);
			
			File file = new File(realPath);
			
			if(!file.exists() || !file.isFile()) {
				throw new FileNotFoundException(realPath);
			}
			
			int fileSize = (int) file.length();
			
			if(fileSize > 0) {
				byte[] bytes = Files.readAllBytes(Paths.get(realPath));
				
				JSONObject data = new JSONObject();
				
				data.put("bytes", bytes);
				data.put("fileSize", fileSize + "");
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", data);
			}
		} catch (FileNotFoundException e){
			result.put("status", "fileNotFound");
			result.put("code", 1);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/attachfiles] ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/{itemId}", method = RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getBoardDetail(@PathVariable int itemId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			Long projectId = Long.parseLong(request.getParameter("projectId"));
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			param.put("itemId", itemId);
			param.put("lang", lang);
			
			Enumeration<String> parameterNames = request.getParameterNames();
			
			while(parameterNames.hasMoreElements()) {
				String parameterName = parameterNames.nextElement();
				param.put(parameterName, request.getParameter(parameterName));
			}
			
			ProjectBoardVO boardVO = ezPMSService.getBoardDetail(info.getTenantId(), param);
			
			int authority = ezPMSService.getUserProjectRole(userId, info.getTenantId(), projectId, request.getParameter("deptId"));
			
			result.put("authority", authority);
			result.put("data", boardVO);	
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			e.printStackTrace();
		}
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "] ended.");
		return result;
	}
	
	
	
	/**
     * 첨부파일을 서버에 저장한다.
     *
     * @param file
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
	public void uploadFile(String byteArray, String newName, String storedFilePath) throws Exception {
		LOGGER.debug("ezPMS uploadFile started.");
		
		OutputStream bos = null;
		String storedFilePathReal = (storedFilePath == null ? "" : storedFilePath);
		
		try {
		    File cFile = new File(storedFilePathReal);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(storedFilePathReal + File.separator + newName);
		    LOGGER.debug("###" + storedFilePathReal + File.separator + newName + "###");
		    Decoder decoder = Base64.getDecoder();

		    bos.write(decoder.decode(byteArray));
		} catch (FileNotFoundException fnfe) {
			LOGGER.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			LOGGER.debug("ioe: {}", ioe);
		} catch (Exception e) {
			LOGGER.debug("e: {}", e);
		} finally {
			
		    if (bos != null) {
		    	
				try {
				    bos.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
		LOGGER.debug("ezPMS uploadFile ended.");
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/{itemId}/viewer-count", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBoardViewerCount(@PathVariable String itemId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "/viewer-count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			int viewerCount= ezPMSService.getBoardViewerCount(info.getTenantId(), itemId, userId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", viewerCount + "");
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "/viewer-count] ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/{itemId}/viewers", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBoardViewerList(@PathVariable String itemId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "/viewers] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			param.put("lang", lang);
			param.put("itemId", itemId);
			
			Enumeration<String> parameterNames = request.getParameterNames();
			
			while(parameterNames.hasMoreElements()) {
				String parameterName = parameterNames.nextElement();
				param.put(parameterName, request.getParameter(parameterName));
			}
			
			List<BoardViewerVO> viewerList = ezPMSService.getBoardViewerList(info.getTenantId(), param);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", viewerList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "/viewers] ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/comments/list/{projectId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCommentList(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/comments/list/" + projectId +"/users/" + userId + "] started");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
	
			String searchByUser = request.getParameter("searchByUser");
			String searchByContent = request.getParameter("searchByContent");
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			param.put("lang", lang);
			param.put("tenantId", tenantId);
			
			Enumeration<String> parameterNames = request.getParameterNames();
			
			while(parameterNames.hasMoreElements()) {
				String parameterName = parameterNames.nextElement();
				param.put(parameterName, request.getParameter(parameterName));
			}
			
			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\","\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
				param.put("searchByUser", searchByUser);
			}
			
			if (searchByContent != null && !searchByContent.equals("")) {
				searchByContent = searchByContent.replace("\\","\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
				param.put("searchByContent", searchByContent);
			}

			List<CommentVO> commentList = ezPMSService.getCommentList(param); 
			
			String taskName = "";
			String taskId = request.getParameter("taskId");
			String groupId = request.getParameter("groupId");
			
			LOGGER.debug("taskId : " + taskId + ", groupId : " + groupId);
			
			if(taskId != null && groupId != null) {
				
				if(!taskId.equals("") && !taskId.equals("0")) {
					ProjectTaskVO taskVO = ezPMSService.getTaskDetails(Long.parseLong(taskId), tenantId, lang);
					taskName = taskVO.getTaskName();
				} else if(!groupId.equals("") && !groupId.equals("0")) {
					ProjectGroupVO groupVO = ezPMSService.getGroupDetails(Long.parseLong(groupId), tenantId, Long.parseLong(projectId));
					taskName = groupVO.getGroupName();
				}
				
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", commentList);
			result.put("taskName", taskName);	
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/comments/list/" + projectId +"/users/" + userId + "] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/comments/list-count/{projectId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCommentListCount(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/comments/list-count/" + projectId + "/users/" +  userId+ "] started");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
	
			String searchByUser = request.getParameter("searchByUser");
			String searchByContent = request.getParameter("searchByContent");
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			param.put("tenantId", info.getTenantId());
			
			Enumeration<String> parameterNames = request.getParameterNames();
			
			while(parameterNames.hasMoreElements()) {
				String parameterName = parameterNames.nextElement();
				param.put(parameterName, request.getParameter(parameterName));
			}
			
			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\","\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
				param.put("searchByUser", searchByUser);
			}
			
			if (searchByContent != null && !searchByContent.equals("")) {
				searchByContent = searchByContent.replace("\\","\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
				param.put("searchByContent", searchByContent);
			}
			
			int totalCount = ezPMSService.getCommentListCount(param);
			
			result.put("data", totalCount + "");	// JSON으로 넘기면 숫자가 Long으로 바뀌는데 Long에서 int로 cast할 때의 오류를 피하기 위해서 String으로 바꾼 후에 파싱한다
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/comments/list-count/" + projectId + "/users/" +  userId+ "] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/comments", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addComment(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/comments] started");
		
		JSONObject result = new JSONObject();
		
		try {
			ezPMSService.addComment(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/comments] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/comments", method = RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteComment(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/comments] started");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			ezPMSService.deleteComment(info.getTenantId(), jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/comments] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/comments", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject modifyComment(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/comments] started");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			jsonParam.put("tenantId", info.getTenantId());
			ezPMSService.modifyComment(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/comments] ended");
		return result;
	}
	
	// tbl_tenant_config에서 SysParam을 가져오는 함수. 사실 이 패키지가 아닌 ezSystem에 있어야할 듯
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/sysParams/{userId}", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject getSysParam(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/sysParams/" + userId + "] started");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<SysParamVO> configList = ezSystemAdminService.getSysParam(info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", configList);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/sysParams/" + userId + "] ended");
		
		return result;
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/checkIfHasReplies", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject checkIfBoardHasReplies(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards/checkIfHasReplies] started");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.remove("userId"));
			jsonParam.put("tenantId", info.getTenantId());
			
			boolean ifBoardHasReplies = ezPMSService.checkIfBoardHasReplies(jsonParam);
					
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", ifBoardHasReplies);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards/checkIfHasReplies] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/checkIfExistPreTaskRel/{pretaskId}", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject checkIfPreTaskRelExist(HttpServletRequest request, @RequestBody JSONObject jsonParam, @PathVariable int pretaskId) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/tasks/checkIfExistPreTaskRel/" + pretaskId + "] started");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.remove("userId"));
			jsonParam.put("tenantId", info.getTenantId());
			
			boolean ifExistPreTaskRel = ezPMSService.checkIfPreTaskRelExist(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", ifExistPreTaskRel);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/tasks/checkIfExistPreTaskRel/" + pretaskId + "] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/preTasks/{preTaskId}", method = RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deletePreTaskRel(@PathVariable long taskId, @PathVariable int preTaskId, @RequestBody JSONObject jsonParam, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/tasks/" + taskId + "/pretasks/" + preTaskId + "] started");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.remove("userId"));
			jsonParam.put("tenantId", info.getTenantId());
			
			ezPMSService.deletePreTaskRelInTask(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/tasks/" + taskId + "/pretasks/" + preTaskId + "] ended");	
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/rest/ezPMS/tasks/multiple-tasks/users/{userId}", method = RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateAllTasksDate(@PathVariable String userId, @RequestBody JSONObject jsonParam, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/multiple-tasks/users/" + userId + "] started");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			List<LinkedHashMap> taskSchedules = (List<LinkedHashMap>) jsonParam.get("allTasks");
			List<LinkedHashMap> groupSchedules = (List<LinkedHashMap>) jsonParam.get("allGroups");
			Long projectId = Long.parseLong((String)jsonParam.get("projectId"));
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("tenantId", info.getTenantId());
			map.put("projectId", projectId);
			map.put("taskSchedules", taskSchedules);
			
			ezPMSService.updateAllTaskDatesInPrj(map);
			
			map.remove("taskSchedules");
			map.put("groupSchedules", groupSchedules);
			
			ezPMSService.updateAllGroupDatesInPrj(map);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/multiple-tasks/users/" + userId + "] ended");
		return result;
	}
}
