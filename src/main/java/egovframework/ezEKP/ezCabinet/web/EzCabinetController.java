package egovframework.ezEKP.ezCabinet.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCabinetController {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetRestService cabinetRestService;
	
	@RequestMapping(value = "/ezCabinet/cabinetMain.do")
	public String jspGetCabinetMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("jspGetCabinetMain started");
		logger.debug("jspGetCabinetMain ended");
		return "ezCabinet/cabinetMain";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetLeft.do")
	public String jspGetCabinetLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jspGetCabinetLeft started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, userInfo.getId()).get("code") != 0) {
			model.addAttribute("isCabinetAdmin", "0");
		}
		else {
			model.addAttribute("isCabinetAdmin", "1");
		}
		
		logger.debug("jspGetCabinetLeft ended");
		return "ezCabinet/cabinetLeft";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetGeneral.do")
	public String jspGetCabinetGeneral(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetGeneral started");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetCabinetGeneral ended");
		return "ezCabinet/cabinetGeneral";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetConfig.do")
	public String jspGetCabinetConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetConfig started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetCabinetConfig ended");
		return "ezCabinet/cabinetConfig";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetInterLocking.do")
	public String jspGetRelatedCabinetConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetRelatedCabinetConfig started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetRelatedCabinetConfig ended");
		return "ezCabinet/cabinetInterLock";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezCabinet/getCompanyTree.do")
	@ResponseBody
	public String jsonGetCompanyTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (companyId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getCompanyTree(request, userInfo.getId(), companyId);
		
		return resultObj.toString();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezCabinet/getSubNodes.do")
	@ResponseBody
	public String jsonGetSubNodes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String deptId          = request.getParameter("deptId") != null ? request.getParameter("deptId") : "";
		String level           = request.getParameter("level") != null ? request.getParameter("level") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (deptId.equals("") || level.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getDeptSubNodes(request, userInfo.getId(), deptId, level);
		
		return resultObj.toString();
	}
	
}
