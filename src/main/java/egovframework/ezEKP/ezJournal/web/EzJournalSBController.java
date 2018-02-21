package egovframework.ezEKP.ezJournal.web;

import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

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
	
	@RequestMapping(value="/ezJournal/journalMain.do")
	public String journalMain(HttpServletRequest req, Model model) {
		logger.debug("journalMain started");

		logger.debug("journalMain ended");
		
		return "/ezJournal/journalMain";
	}
	
	/**
	 * 업무일지 왼쪽 메뉴 화면
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalLeft.do")
	public String journalLeft(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalLeft started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("tenantId", userInfo.getTenantId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/restezjournal/users/"+userInfo.getId()+"/recv-count", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			String recvCount = (String) resultBody.get("data");
			model.addAttribute("recvCount", recvCount);
			logger.debug("recvCount = ********"+recvCount);
		}
		
		param.put("companyId",userInfo.getCompanyID());
		param.put("used", "use");
		
		resultBody = commonUtil.getJsonFromRestApi("/restezjournal/types", param, request,"get",null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray typeList = (JSONArray) resultBody.get("data");
			model.addAttribute("typeList", typeList);
			logger.debug("typeList = ********"+typeList);
		}
		logger.debug("journalLeft ended");
		
		return "/ezJournal/journalLeft";
	}
	
	/**
	 * 업무일지 리스트 화면
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalListMain.do")
	public String journalListMain(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalListMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String listType = request.getParameter("listType");
		String typeId = request.getParameter("typeId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("tenantId", userInfo.getTenantId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/restezjournal/users/"+userInfo.getId()+"/author-depts", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			//셀렉트박스 부서명
			JSONArray deptList = (JSONArray) resultBody.get("data");
			model.addAttribute("deptList", deptList);
			model.addAttribute("listType",listType);
			model.addAttribute("typeId",typeId);
		}
		
		resultBody = commonUtil.getJsonFromRestApi("/restezjournal/users/"+userInfo.getId()+"/options", param, request,"get",null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			//업무일지 환경설정
			JSONObject journalEnv =  (JSONObject) resultBody.get("data");
			model.addAttribute("journalEnv", journalEnv);
		}
		logger.debug("journalListMain ended");
		
		return "/ezJournal/journalListMain";
	}
}
