package egovframework.ezEKP.ezJournal.web;

import java.util.HashMap;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.bouncycastle.crypto.macs.HMac;
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
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzJournalSBController {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 관리자 일지함 관리
	 */
	@RequestMapping(value = "/admin/ezJournal/formType.do")
	public String formTypeManage(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {
		logger.debug("formType started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, String> param = new HashMap<String, String>();
		param.put("userId", userInfo.getId());
		param.put("tenantId", userInfo.getTenantId()+"");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/ezjournal/companies", param, request);
		String status = resultBody.get("status").toString();
				
		if (status.equals("ok")) {			
			JSONArray compList = (JSONArray) resultBody.get("data");
			
			model.addAttribute("compList", compList);
		}
		
		param.clear();
		
		String companyId =null;
		if (request.getParameter("companyId") != null) {
			companyId = request.getParameter("companyId");
		} else{
			companyId = userInfo.getCompanyID();
		}
		
		param.put("companyId",companyId );
		param.put("tenantId", userInfo.getTenantId()+"");
		
		resultBody = commonUtil.getJsonFromRestApi("/ezjournal/types", param, request);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {		
			JSONArray typeList = (JSONArray) resultBody.get("data");
			model.addAttribute("typeList", typeList);
		}
		
		logger.debug("formType ended");
		return "admin/ezJournal/formType";
	}
}
