package egovframework.ezEKP.ezPMS.web;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Properties;
import java.util.UUID;
import java.util.Base64.Decoder;

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

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSGWController2.class);
	
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
	public JSONObject addBoard(HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards] started");
		
		JSONObject result = new JSONObject();
		
		try {
			ProjectBoardVO projectBoardVO = new ProjectBoardVO();
			projectBoardVO.setTenantId(Integer.parseInt(request.getParameter("tenantId")));
			projectBoardVO.setWriterId(request.getParameter("writerId"));
			projectBoardVO.setWriteDate(request.getParameter("writeDate"));
			projectBoardVO.setWriterName(request.getParameter("writerName"));
			projectBoardVO.setWriterName2(request.getParameter("writerName2"));
			projectBoardVO.setWriterDeptName(request.getParameter("writerDeptname"));
			projectBoardVO.setWriterDeptName2(request.getParameter("writerDeptname2"));
			projectBoardVO.setTitle(request.getParameter("title"));
			projectBoardVO.setWriteContent(request.getParameter("writeContent"));
			projectBoardVO.setWriteType(Integer.parseInt(request.getParameter("writeType")));
			projectBoardVO.setReadCount(0);
			projectBoardVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
			if(!request.getParameter("taskId").equals("null")) {
				projectBoardVO.setTaskId(Long.parseLong(request.getParameter("taskId")));
			}
			projectBoardVO.setWriterPosition(request.getParameter("writerPosition"));
			projectBoardVO.setWriterPosition2(request.getParameter("writerPosition2"));
			projectBoardVO.setWriteOverview(request.getParameter("writeOverview"));
			
			ezPMSService.addBoard(projectBoardVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/list/{projectId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBoardList(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list] started");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
	
			Long groupId = -1L;
			Long taskId = -1L;
			if(!request.getParameter("groupId").equals("null")) {
				groupId = Long.parseLong(request.getParameter("groupId"));
			} 
			if(!request.getParameter("taskId").equals("null")) {
				taskId = Long.parseLong(request.getParameter("taskId"));
			}
			int startRow = Integer.parseInt(request.getParameter("startRow"));
			int limit = Integer.parseInt(request.getParameter("limit"));
			
			List<ProjectBoardVO> boardList = ezPMSService.getBoardList(info.getTenantId(), Long.parseLong(projectId), groupId, taskId, startRow, limit);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", boardList);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/list-count/{projectId}/users/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBoardListCount(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list-count] started");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			Long groupId = -1L;
			Long taskId = -1L;
			if(!request.getParameter("groupId").equals("null")) {
				groupId = Long.parseLong(request.getParameter("groupId"));
			} 
			if(!request.getParameter("taskId").equals("null")) {
				taskId = Long.parseLong(request.getParameter("taskId"));
			}
			
			int totalCount = ezPMSService.getBoardListCount(info.getTenantId(), Long.parseLong(projectId), groupId, taskId);
			
			result.put("data", totalCount + "");
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list-count] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezPMS/attachfiles", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject uploadFile(HttpServletRequest request, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/attachfiles] started");
		
		JSONObject result = new JSONObject();
		
		JSONParser jp = new JSONParser();
		jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
		
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
	        
	        File file = new File(pDirPath + "uploadFile");

	        if (!file.exists()) {
	        	file.mkdirs();
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
                        String pAttachPath = pDirPath + "uploadFile" + commonUtil.separator;
                        
                        // 업로드된 파일 데이터를 파일로 저장한다.
                        uploadFile((String)((JSONObject)fileArray.get(i)).get("bytes"), newFileName, pAttachPath);
                        
                        fileLocation[i] = commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId()) + commonUtil.separator + "uploadFile" + commonUtil.separator + pUploadSN[i];
                        resultUpload[i] = "true";
                    }
	            }
	        }

	        ArrayList<JSONObject> filelist = new ArrayList<JSONObject>();
	        
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
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/attachfiles] ended.");
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
