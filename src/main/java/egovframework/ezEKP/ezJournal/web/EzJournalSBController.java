package egovframework.ezEKP.ezJournal.web;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezJournal.vo.JournalPagination;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzJournalSBController {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalSBController.class);
	
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
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+userInfo.getId()+"/recv-count", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			String recvCount = (String) resultBody.get("data");
			model.addAttribute("recvCount", recvCount);
			logger.debug("recvCount = ********"+recvCount);
		}
		
		param.put("companyId",userInfo.getCompanyID());
		param.put("userId",userInfo.getId());
		param.put("used", "use");
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/types", param, request,"get",null);
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
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+userInfo.getId()+"/author-depts", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			//셀렉트박스 부서명
			JSONArray deptList = (JSONArray) resultBody.get("data");
			model.addAttribute("deptList", deptList);
			model.addAttribute("listType",listType);
			model.addAttribute("typeId",typeId);
		}
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+userInfo.getId()+"/options", param, request,"get",null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			//업무일지 환경설정
			JSONObject journalEnv =  (JSONObject) resultBody.get("data");
			logger.debug("journalEnv : " + journalEnv);
			model.addAttribute("journalEnv", journalEnv);
		}
		logger.debug("journalListMain ended");
		
		return "/ezJournal/journalListMain";
	}
	
	/**
	 * 업무일지 리스트의 양식 리스트 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalListMainFormList.do")
	@ResponseBody
	public JSONArray journalListMainFormList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalListMainFormList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String typeId = request.getParameter("typeId");
		String deptId = "";
		if (request.getParameter("deptId")!=null) {
			deptId = request.getParameter("deptId");
		}else{
			deptId = userInfo.getDeptID();
		}
		String companyId = userInfo.getCompanyID();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("deptId",deptId);
		param.put("companyId",companyId);
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/types/"+typeId+"/forms", param, request,"get",null);
		String status = resultBody.get("status").toString();
		JSONArray formList=null;
		if (status.equals("ok")) {			
			formList = (JSONArray) resultBody.get("data");
		}
		
		logger.debug("journalListMainFormList ended");
		
		return formList;
	}
	
	/**
	 * 업무일지 리스트 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value="/ezJournal/journalList.do")
	public String journalList(@RequestBody JSONObject jsonParam, HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		Map<String, Object> param = null;
		try {
			param = new ObjectMapper().readValue(jsonParam.toJSONString(), Map.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		String listType =(String) param.get("listType");
		int listCnt = Integer.parseInt(param.get("listCnt").toString());
		int currentPage = (int) param.remove("currentPage");
		
		param.put("companyId", userInfo.getCompanyID());
		param.put("userId", userInfo.getId());
		switch (listType) {
		case "department":
			break;
		case "mine":
			param.remove("deptId");
			param.put("journalWriter", userInfo.getId());
			break;
		case "recv":
			param.remove("typeId");
			param.remove("deptId");
			param.put("recvUser", userInfo.getId());
			break;
		case "temp":
			param.remove("typeId");
			param.remove("deptId");
			param.put("status", "temp");
			break;
		default:
			break;
		}
		
		Iterator tarKeyIter = new HashSet(param.keySet()).iterator();
		while (tarKeyIter.hasNext()) {
		    Object key = (Object)tarKeyIter.next();
		    if (param.get(key)==null || param.get(key).equals("")) {
		    	param.remove(key);
		    	logger.debug("remove : "+key);
		    }
		}
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals-count", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		int totalCount =0;
		if (status.equals("ok")) {			
			totalCount = Integer.parseInt((String) resultBody.get("data"));
		}
		
		JournalPagination paging = new JournalPagination(totalCount,listCnt,10,currentPage);
		model.addAttribute("paging",paging);
		
		param.put("startCount", paging.getStartCount());
		if (param.get("orderNum")==null || param.get("orderNum").equals("")) {
			param.put("orderNum", 3);
		}
		if (param.get("orderHow")==null || param.get("orderHow").equals("")) {
			param.put("orderHow", "desc");
		}
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals", param, request,"get",null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray journalList =  (JSONArray) resultBody.get("data");
			logger.debug(journalList.toJSONString());
			for (int i = 0; i < journalList.size(); i++) {
				JSONObject journal = (JSONObject) journalList.get(i);
				String journalDate = (String) journal.get("journalDate");
				journalDate = commonUtil.getDateStringInUTC(journalDate, userInfo.getOffset(), false);
				journal.put("journalDate", journalDate);
			}
			model.addAttribute("journalList", journalList);
			model.addAttribute("listType",listType);
		}
		logger.debug("journalList ended");
		
		return "/ezJournal/journalList";
	}
	
	/**
	 * 업무일지 환경설정 저장
	 * @param param
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/saveJournalEnv.do")
	@ResponseBody
	public JSONObject saveJournalEnv(@RequestParam Map<String,Object> param,HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("saveJournalEnv started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+userInfo.getId()+"/options", param, request,"post",null);
		
		logger.debug("saveJournalEnv ended");
		
		return resultBody;
	}
	
	/**
	 * 업무일지 상세내용 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezJournal/journalDetail.do")
	public String getJournalDetail(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("getJournalDetail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String viewDate ="";
		try {
			viewDate = commonUtil.getTodayUTCTime("");
		} catch (Exception e) {
			e.printStackTrace();
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("viewDate", viewDate);
		
		String journalId = request.getParameter("journalId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId, param, request,"get",null);
		
		String status = resultBody.get("status").toString();
		
		JSONObject journal = null;
		if (status.equals("ok")) {			
			journal = (JSONObject) resultBody.get("data");
			String journalDate = (String) journal.get("journalDate");
			journalDate = commonUtil.getDateStringInUTC(journalDate, userInfo.getOffset(), false);
			journal.put("journalDate", journalDate);
			model.addAttribute("journal",journal);
		}
		
		logger.debug("getJournalDetail ended");
		
		return "/ezJournal/journalDetail";
	}
		
		/**
		 * 업무일지 미리보기 내용 가져오기
		 * @param request
		 * @param model
		 * @param loginCookie
		 * @return
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping(value="/ezJournal/journalPreview.do")
		public String getJournalPreview(HttpServletRequest request,Model model, @CookieValue("loginCookie") String loginCookie) {
			logger.debug("getJournalPreview started");
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("userId", userInfo.getId());
			try {
				param.put("viewDate",commonUtil.getTodayUTCTime(""));
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			String journalId = request.getParameter("journalId");
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId, param, request,"get",null);
			
			String status = resultBody.get("status").toString();
			
			JSONObject journal = null;
			if (status.equals("ok")) {			
				journal = (JSONObject) resultBody.get("data");
				String journalDate = (String) journal.get("journalDate");
				journalDate = commonUtil.getDateStringInUTC(journalDate, userInfo.getOffset(), false);
				journal.put("journalDate", journalDate);
				model.addAttribute("journal",journal);
			}
			
			logger.debug("getJournalPreview ended");
			
			return "/ezJournal/journalPreviewContent";
	}
		
	/**
	 * 읽지않은 수신일지 갯수 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/leftRecvCount.do")
	@ResponseBody
	public String leftRecvCount(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("leftRecvCount started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+userInfo.getId()+"/recv-count", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		String recvCount="";
		if (status.equals("ok")) {			
			recvCount= (String) resultBody.get("data");
			logger.debug("recvCount = ********"+recvCount);
		}
		logger.debug("leftRecvCount ended");
		
		return recvCount;
	}
}
