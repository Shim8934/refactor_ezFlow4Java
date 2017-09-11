package egovframework.ezMobile.ezCommon.web;

import java.io.File;
import java.io.FileNotFoundException;
import java.nio.file.Files;
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

import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.let.utl.fcc.service.CommonUtil;

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
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	@RequestMapping(value = "/mobile/ezcommon/filedown", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mFileDown(HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezcommon/filedown] started.");
		
		String filePath = request.getParameter("filePath");
		LOGGER.debug("filePath = " + filePath);
		String realPath = request.getServletContext().getRealPath("");
		
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
				
				JSONObject data = new JSONObject();
				
				data.put("bytes", bytes);
				data.put("fileSize", fSize);
				
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
}
