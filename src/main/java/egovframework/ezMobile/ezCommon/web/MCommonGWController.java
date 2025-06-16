package egovframework.ezMobile.ezCommon.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.let.utl.fcc.service.EzFAL;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KlibUtil;
import egovframework.let.utl.fcc.service.MimeTypes;

/** 
 * @Description [Controller] 모바일GW - 공통
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.09.02    황윤진         신규작성
 *
 * @see
 */

@RestController
public class MCommonGWController {
	private static final Logger logger = LoggerFactory.getLogger(MCommonGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private KlibUtil klibUtil;

	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezcommon/filedown", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mFileDown(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezcommon/filedown] started.");
		
		String filePath = request.getParameter("filePath");
		filePath = filePath == null ? "" : URLDecoder.decode(filePath, StandardCharsets.UTF_8.name());
		logger.debug("filePath = " + filePath);
		String fileName = (request.getParameter("fileName") == null) ? "" : request.getParameter("fileName");
		fileName = fileName == null ? "" : URLDecoder.decode(fileName, StandardCharsets.UTF_8.name());
		logger.debug("fileName = " + fileName);
		String realPath = commonUtil.getRealPath(request);
		
		filePath = realPath + filePath;

		JSONObject result = new JSONObject();
		
		try {
			EzFAL.EzFile file = new EzFAL.EzFile(filePath);
			
			if (!file.exists()) {
			    throw new FileNotFoundException(filePath);
			}
		
			if (!file.isFile()) {
			    throw new FileNotFoundException(filePath);
			}
			
			int fSize = (int)file.length();
			
			if (fSize > 0) {
				byte[] bytes = commonUtil.readBytesFromFile(Paths.get(filePath));
				
				if (filePath.endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
					bytes = klibUtil.decrypt(bytes);
				}
				
				String fileType = MimeTypes.getContentType(bytes, fileName);
				
				if (fileType == null || fileType.equalsIgnoreCase("")) {
					fileType = "application/octet-stream";
				}

				JSONObject data = new JSONObject();
				
				data.put("bytes", bytes);
				data.put("fileSize", fSize);
				data.put("fileType", fileType);
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", data);
			}
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			logger.error(e.getMessage(), e);
			
			return result;
		}
		
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezcommon/filedown] ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezcommon/getTenantConfigWithServerName", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getTenantConfigWithServerName(HttpServletRequest request) throws Exception {
		logger.debug("MCommonGWController getTenantConfigWithServerName started");
		
		String serverName = request.getHeader("x-user-host");
		int tenantId = loginService.getTenantId(serverName);
		String tenantConfig = request.getParameter("tenantConfig");		
		
		logger.debug("serverName=" + serverName + ",tenantId=" + tenantId + ",tenantConfig=" + tenantConfig);
						
		String config = ezCommonService.getTenantConfig(tenantConfig, tenantId);
		
		JSONObject result = new JSONObject();
		
		result.put("status", "ok");
		result.put("code", 0);
		result.put("data", config);

		logger.debug("MCommonGWController getTenantConfigWithServerName ended");
		
		return result;
	}
	
	 /**
	 * 2019-05-09 홍승비 - 모바일 G/W 테넌트 컨피그 받아오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezcommon/tenantconfigs/{tenantconfig:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")    
    public JSONObject getTenantConfigMobileGW(HttpServletRequest request) throws Exception {
    	logger.debug("MOBILE G/W COMMON [GET /mobile/ezcommon/tenantconfigs/{tenantconfig}] getTenantConfigMobileGW started");
    	
    	JSONObject result = new JSONObject();
    	
    	try {
			int tenantID = Integer.parseInt(request.getParameter("tenantID"));
			String tenantConfig = request.getParameter("tenantConfig");
			String resultTC = ezCommonService.getTenantConfig(tenantConfig, tenantID);
			
			if (resultTC != null) {
				logger.debug("resultTC : " + resultTC);
			} else {
				resultTC = "";
			}
			
			result.put("status", "ok");			
			result.put("resultTC", resultTC);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
		}
		logger.debug("MOBILE G/W COMMON [GET /mobile/ezcommon/tenantconfigs/{tenantconfig}] getTenantConfigMobileGW ended.");
    	return result;
    }
	
	// 20190829 김수아 : tenantConfig 가져오기
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezcommon/getTenantConfig", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getTenantConfig(HttpServletRequest request) throws Exception {
		logger.debug("MCommonGWController getTenantConfig Start");
		
		int tenantId = Integer.parseInt(request.getParameter("tenantID"));
		String tenantConfig = request.getParameter("tenantConfig");
		logger.debug("tenantID=" + tenantId + ", tenantConfig=" + tenantConfig);
		
		String config = ezCommonService.getTenantConfig(tenantConfig, tenantId);
		config = config == null ? "" : config;
		logger.debug("config=" + config);
		
		JSONObject result = new JSONObject();
		result.put("status", "ok");
		result.put("code", 0);
		result.put("data", config);

		logger.debug("MCommonGWController getTenantConfig End");
		return result;
	}
	
	// 20201211 조진호 : KLIB를 사용하는 경우, 통합검색 업체를 포함한 타 기간계 시스템에서 그룹웨어의 전자결재 문서의 파일을 필요로 할 때 복호화하여 파일을 전달하는 API 목적으로 개발
	@RequestMapping(value = "/mobile/ezcommon/decryptFiledown", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	@ResponseBody
	public void mFileDown_decrypt(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezcommon/decryptFiledown] started.");

		String filePath = request.getParameter("filePath");
		logger.debug("filePath = " + filePath);
		String fileName = (request.getParameter("fileName") == null) ? "" : request.getParameter("fileName");
		logger.debug("fileName = " + fileName);
		String realPath = commonUtil.getRealPath(request);

		filePath = realPath + filePath;

		try {
			EzFAL.EzFile file = new EzFAL.EzFile(filePath);

			if (!file.exists()) {
				throw new FileNotFoundException(filePath);
			}

			if (!file.isFile()) {
				throw new FileNotFoundException(filePath);
			}

			int fSize = (int) file.length();

			if (fSize > 0) {
				byte[] bytes = commonUtil.readBytesFromFile(Paths.get(filePath));

				if (filePath.endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
					bytes = klibUtil.decrypt(bytes);
				}

				try (ByteArrayInputStream in = new ByteArrayInputStream(bytes)) {
					String mimetype = "application/octet-stream";

					String nfcFilename = commonUtil.normalizeFileName(fileName);

					response.setBufferSize(2048);
					response.setContentType(mimetype);
					response.setHeader("Content-Disposition", "attachment; filename=\"" + nfcFilename + "\"");
					response.setHeader("Content-Length", Long.toString(fSize));
					FileCopyUtils.copy(in, response.getOutputStream());
				} catch (Exception ex) {
					logger.error(ex.getMessage(), ex);
				}

				response.getOutputStream().flush();
				response.getOutputStream().close();

			}
		} catch (Exception e) {
			logger.debug("e.message=" + e.getMessage());
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezcommon/decryptFiledown] ended.");

	}
	
	
}
