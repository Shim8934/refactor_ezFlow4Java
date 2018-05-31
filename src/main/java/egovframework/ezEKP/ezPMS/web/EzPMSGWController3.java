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
import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
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
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
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
			int limit = Integer.parseInt(request.getParameter("limit"));
			
			List<ProjectBoardVO> boardList = ezPMSService.getBoardList(info.getTenantId(), Long.parseLong(projectId), groupId, taskId, userId, startRow, limit, lang);
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
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", boardList);		
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
			
			Long groupId = 0L;
			Long taskId = 0L;
			
			if(request.getParameter("groupId")!=null && !request.getParameter("groupId").equals("")) {
				groupId = Long.parseLong(request.getParameter("groupId"));	
			} 
			
			if(request.getParameter("taskId")!=null && !request.getParameter("taskId").equals("")) {
				taskId = Long.parseLong(request.getParameter("taskId"));	
			}
			
			int totalCount = ezPMSService.getBoardListCount(info.getTenantId(), Long.parseLong(projectId), groupId, taskId);
			
			result.put("data", totalCount + "");	// JSON으로 넘기면 숫자가 Long으로 바뀌는데 Long에서 int로 cast할 때의 오류를 피하기 위해서 String으로 바꾼 후에 파싱한다
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
}
