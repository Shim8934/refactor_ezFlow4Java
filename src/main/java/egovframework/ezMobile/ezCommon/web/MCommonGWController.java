package egovframework.ezMobile.ezCommon.web;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezMobile.ezOption.service.MOptionService;
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
	private static final Logger LOGGER = LoggerFactory.getLogger(MCommonGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Autowired
	private KlibUtil klibUtil;

	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@RequestMapping(value = "/mobile/ezcommon/filedown", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mFileDown(HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezcommon/filedown] started.");
		
		String filePath = request.getParameter("filePath");
		LOGGER.debug("filePath = " + filePath);
		String fileName = (request.getParameter("fileName") == null) ? "" : request.getParameter("fileName");
		LOGGER.debug("fileName = " + fileName);
		String realPath = commonUtil.getRealPath(request);
		
		filePath = realPath + filePath;

		JSONObject result = new JSONObject();
		
		try {
			File file = new File(filePath);
			
			if (!file.exists()) {
			    throw new FileNotFoundException(filePath);
			}
		
			if (!file.isFile()) {
			    throw new FileNotFoundException(filePath);
			}
			
			int fSize = (int)file.length();
			
			if (fSize > 0) {
				byte[] bytes = Files.readAllBytes(Paths.get(filePath));
				
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
			
			return result;
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezcommon/filedown] ended.");
		
		return result;
	}
	
	 /**
	 * 2019-05-09 홍승비 - 모바일 G/W 테넌트 컨피그 받아오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezcommon/tenantconfigs/{tenantconfig}", method= RequestMethod.GET, produces="application/json;charset=utf-8")    
    public JSONObject getTenantConfigMobileGW(HttpServletRequest request) throws Exception {
    	LOGGER.debug("MOBILE G/W COMMON [GET /mobile/ezcommon/tenantconfigs/{tenantconfig}] getTenantConfigMobileGW started");
    	
    	JSONObject result = new JSONObject();
    	
    	try {
			int tenantID = Integer.parseInt(request.getParameter("tenantID"));
			String tenantConfig = request.getParameter("tenantConfig");
			String resultTC = ezCommonService.getTenantConfig(tenantConfig, tenantID);
			
			if (resultTC != null) {
				LOGGER.debug("resultTC : " + resultTC);
			} else {
				resultTC = "";
			}
			
			result.put("status", "ok");			
			result.put("resultTC", resultTC);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
		}
		LOGGER.debug("MOBILE G/W COMMON [GET /mobile/ezcommon/tenantconfigs/{tenantconfig}] getTenantConfigMobileGW ended.");
    	return result;
    }
	
}
