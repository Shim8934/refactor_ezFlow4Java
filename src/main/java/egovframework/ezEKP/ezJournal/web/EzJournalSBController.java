package egovframework.ezEKP.ezJournal.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
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
import egovframework.ezEKP.ezEmail.service.EzEmailService;
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
	
	@Resource(name="EzEmailService")
	private EzEmailService ezEmailService;
	
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
	@RequestMapping(value="/ezJournal/getFormList.do")
	@ResponseBody
	public JSONArray journalListMainFormList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalListMainFormList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String deptId = "";
		if (request.getParameter("deptId")!=null) {
			deptId = request.getParameter("deptId");
		}
		String typeId = request.getParameter("typeId");
		if (typeId == null || typeId.equals("")) {
			typeId = "basic";
		}
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("deptId",deptId);
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
			param.put("journalWriter", userInfo.getId());
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
			model.addAttribute("totalCount",totalCount);
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
			String journalContent = ((String) journal.get("journalContent")).replaceAll("'","\"");
			journal.put("journalContent", journalContent);
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
	
	/**
	 * 업무일지 댓글화면 불러오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalReply.do")
	public String journalReply(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalReply started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId+"/replies", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		JSONArray replyList = null;
		if (status.equals("ok")) {			
			replyList=  (JSONArray) resultBody.get("data");
			for (Object reply : replyList) {
				JSONObject JOReply = (JSONObject)reply;
				String replyDate = (String) JOReply.get("replyDate");
				replyDate = commonUtil.getDateStringInUTC(replyDate, userInfo.getOffset(), false);
				JOReply.put("replyDate", replyDate);
			}
			model.addAttribute("replyList",replyList);
			model.addAttribute("journalId",journalId);
		}
		logger.debug("journalReply ended");
		
		return "/ezJournal/journalReplyList";
	}
	
	/**
	 * 업무일지 댓글 저장하기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/saveJournalReply.do")
	@ResponseBody
	public String saveJournalReply(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("saveJournalReply started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		String replyContent = request.getParameter("replyContent");
		String replyDate=null;
		try {
			replyDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("replyContent", replyContent);
		param.put("replyDate", replyDate);
		param.put("loginCookie", loginCookie);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId+"/replies", param, request,"post",null);
		String journalWriter = (String) resultBody.get("data");
		logger.debug("saveJournalReply ended");
		
		return journalWriter;
	}
	
	/**
	 * 업무일지 댓글 삭제하기
	 * @param request
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/removeJournalReply.do")
	@ResponseBody
	public String removeJournalReply(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("saveJournalReply started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		String replyId = request.getParameter("replyId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId+"/replies/"+replyId, param, request,"delete",null);
		String status = resultBody.get("status").toString();
		
		logger.debug("saveJournalReply ended");
		
		return status;
	}
	
	/**
	 * 업무일지 조회자 리스트
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/JournalViewerList.do")
	public String getJournalViewerList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("getJournalViewerList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId+"/viewer-count", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		String currentPageStr = request.getParameter("currentPage");
		if (currentPageStr==null || currentPageStr.equals("")) {
			currentPageStr = "1";
		}
		int currentPage = Integer.parseInt(currentPageStr);
		int totalCount =0;
		if (status.equals("ok")) {			
			totalCount = Integer.parseInt((String) resultBody.get("data"));
		}
		int listCnt = 10;
		JournalPagination paging = new JournalPagination(totalCount,listCnt,10,currentPage);
		model.addAttribute("paging",paging);
		
		param.put("startCount", paging.getStartCount());
		param.put("listCnt", listCnt);
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId+"/viewer", param, request,"get",null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray viewerList=  (JSONArray) resultBody.get("data");
			
			for (Object viewer : viewerList) {
				JSONObject JOViewer = (JSONObject)viewer;
				String viewDate = (String) JOViewer.get("date");
				viewDate = commonUtil.getDateStringInUTC(viewDate, userInfo.getOffset(), false);
				JOViewer.put("date", viewDate);
			}
			
			model.addAttribute("viewerList",viewerList);
		}
		
		logger.debug("getJournalViewerList ended");
		
		return "/ezJournal/journalViewerList";
	}
	
	/**
	 * 업무일지 수신자 리스트
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/JournalReceiverList.do")
	public String getJournalReveiberList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("getJournalViewerList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		String typeId = request.getParameter("typeId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/types/"+typeId+"/journals/"+journalId+"/receivers-count", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		String currentPageStr = request.getParameter("currentPage");
		if (currentPageStr==null || currentPageStr.equals("")) {
			currentPageStr = "1";
		}
		int currentPage = Integer.parseInt(currentPageStr);
		int totalCount =0;
		if (status.equals("ok")) {			
			totalCount = Integer.parseInt((String) resultBody.get("data"));
		}
		int listCnt = 10;
		JournalPagination paging = new JournalPagination(totalCount,listCnt,10,currentPage);
		model.addAttribute("paging",paging);
		
		param.put("startCount", paging.getStartCount());
		param.put("listCnt", listCnt);
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/types/"+typeId+"/journals/"+journalId+"/receivers", param, request,"get",null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray viewerList=  (JSONArray) resultBody.get("data");
			
			for (Object viewer : viewerList) {
				JSONObject JOViewer = (JSONObject)viewer;
				String viewDate = (String) JOViewer.get("date");
				viewDate = commonUtil.getDateStringInUTC(viewDate, userInfo.getOffset(), false);
				JOViewer.put("date", viewDate);
			}
			
			model.addAttribute("viewerList",viewerList);
		}
		
		logger.debug("getJournalViewerList ended");
		
		return "/ezJournal/journalReceiverList";
	}
	
	/**
	 * 다른일지 가져오기 리스트
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/otherJournalList.do")
	public String getOtherJournalList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("getOtherJournalList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String formId = request.getParameter("formId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("journalWriter", userInfo.getId());
		param.put("userId", userInfo.getId());
		param.put("formId",formId);
		param.put("companyId",userInfo.getCompanyID());
		param.put("startCount",1);
		param.put("listCnt",10);
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray journalList=  (JSONArray) resultBody.get("data");
			for (Object journalObject : journalList) {
				JSONObject journal = (JSONObject)journalObject;
				String journalDate = (String) journal.get("journalDate");
				journalDate = commonUtil.getDateStringInUTC(journalDate, userInfo.getOffset(), false);
				journal.put("journalDate", journalDate);
			}
			model.addAttribute("journalList",journalList);
		}
		
		logger.debug("getOtherJournalList ended");
		
		return "/ezJournal/otherJournalList";
	}
	
	/**
	 * 선택된 다른일지 내용 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/getOtherJournalContent.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getOtherJournal(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("getOtherJournal started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalId = request.getParameter("journalId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journals/"+journalId, param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		String result = "";
		
		if (status.equals("ok")) {			
			JSONObject journal=  (JSONObject) resultBody.get("data");
			String journalContent = (String) journal.get("journalContent");
			
			Document journalDoc = Jsoup.parseBodyFragment(journalContent);
//			Element journalBody = journalDoc.body();
//			
//			Element thisElem = journalBody.getElementById("thisJournal");
//			Element nextElem = journalBody.getElementById("nextJournal");
//			String nextContent = nextElem.html();
//			
//			thisElem.html(nextContent);
//			nextElem.html("");
			
			result = journalDoc.toString();
		}
		
		logger.debug("getOtherJournal ended");
		
		return result;
	}
	
	/**
	 * 업무일지 상세내용 JSON 가져오기
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/ezJournal/journalDetailJSON.do")
	public JSONObject getJournalJSON(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("getJournalJSON started");
		
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
		}
		
		logger.debug("getJournalJSON ended");
		
		return journal;
	}
	
	/**
	 * 일지 조회정보 입력
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/journalViewCheck.do")
	@ResponseBody
	public String journalViewCheck(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("journalViewCheck started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String viewDate ="";
		try {
			viewDate = commonUtil.getTodayUTCTime("");
		} catch (Exception e) {
			e.printStackTrace();
		}
		Map<String, Object> param = new HashMap<String, Object>();
		
		String journalIdList = request.getParameter("journalIdList");
		String userId = userInfo.getId();
				
		param.put("userId", userId);
		param.put("viewDate", viewDate);
		param.put("journalIdList", journalIdList);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/viewers/"+userId, param, request,"put",null);
		
		String status = resultBody.get("status").toString();
		
		logger.debug("journalViewCheck ended");
		
		return status;
	}
	
	/**
	 * 일지작성자에게 댓글알림
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezJournal/sendJournalReplyMail.do")
	public String sendJournalReplyMail(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("sendJournalReplyMail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String replyContent = request.getParameter("replyContent");
		String journalTitle = request.getParameter("journalTitle");
		String journalWriter = request.getParameter("journalWriter");
		String journalId = request.getParameter("journalId");
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+journalWriter+"/options", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONObject journalEnv = (JSONObject) resultBody.get("data");
			
			String replyAlert = (String) journalEnv.get("replyAlert");
			
			if (replyAlert.equals("Y")) {
				try {
				InternetAddress[] toArr = new InternetAddress[1];
				toArr[0] = new InternetAddress((String) journalEnv.get("mail"));
				toArr[0].setPersonal((String) journalEnv.get("name"));
				
				String subject = egovMessageSource.getMessage("ezJournal.t151")+journalTitle;
				
				String content = "<p>"+egovMessageSource.getMessage("ezJournal.t152")+"</p>";
				content += "<p></p>";
				content += "<a href='#' onclick='journalMailLink("+journalId+");'>"+journalTitle+"</a>";
				content += "<p>"+egovMessageSource.getMessage("ezJournal.t153")+userInfo.getDisplayName()+"</p>";
				content += "<p>"+egovMessageSource.getMessage("ezJournal.t154")+journalTitle+"</p>";
				content += "<p>"+replyContent+"</p>";
//				content += "<a href='#' onclick='window.open(\"/ezJournal/journalDetail.do?journalId=\""+journalId+", \"journalDetail\",\"width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1\");return false;' target='_blank'>"+journalTitle+"</a>";
//				content += "<p onclick='window.open(\'/ezJournal/journalDetail.do?journalId=\'"+journalId+", \'journalDetail\',\'width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1\');return false;' target='_blank'>"+journalTitle+"</p>";

				
				InternetAddress from = new InternetAddress(userInfo.getEmail());
				from.setPersonal(userInfo.getDisplayName());
				ezEmailService.sendMail(loginCookie , from, toArr, null, null, subject, content, false);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		logger.debug("sendJournalReplyMail ended");
		
		return status;
	}
	
	/**
	 * 수신자에게 알림메일
	 * @param request
	 * @param model
	 * @param loginCookie
	 */
	@RequestMapping(value="/ezJournal/sendJournalRecvMail.do")
	public void sendJournalRecvMail(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		logger.debug("sendJournalRecvMail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String journalTitle = request.getParameter("journalTitle");
		String recvIds = request.getParameter("recvIds");
		String journalId = request.getParameter("journalId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		String userId = userInfo.getId();
		param.put("userId", userId);
		
		ArrayList<InternetAddress> toArrList = new ArrayList<InternetAddress>(); 
		if (recvIds != null && !recvIds.equals("")) {
			String[] receiverID = recvIds.split(",");
			
			for (int i = 0; i < receiverID.length; i++) {
				String recvId = receiverID[i];
				
				JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+recvId+"/options", param, request,"get",null);
				String status = resultBody.get("status").toString();
				
				if (status.equals("ok")) {			
					JSONObject journalEnv = (JSONObject) resultBody.get("data");
					
					String recvAlert = (String) journalEnv.get("recvAlert");
					
					if (recvAlert.equals("Y")) {
						try {
							InternetAddress recvMail = new InternetAddress();
							recvMail.setAddress((String) journalEnv.get("mail"));
							recvMail.setPersonal((String) journalEnv.get("name"));
							toArrList.add(recvMail);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
			try {
				InternetAddress[] toArr = new InternetAddress[toArrList.size()];
				for (int i = 0; i < toArrList.size(); i++) {
					toArr[i] = toArrList.get(i);
				}
				
				String subject = egovMessageSource.getMessage("ezJournal.t155")+journalTitle;
				
				String content = "<p>"+egovMessageSource.getMessage("ezJournal.t156")+"</p>";
				content += "<p></p>";
				content += "<a href='#' onclick='journalMailLink("+journalId+");'>"+journalTitle+"</a>";
				content += "<p>"+egovMessageSource.getMessage("ezJournal.t157")+userInfo.getDisplayName()+"</p>";
				content += "<p>"+egovMessageSource.getMessage("ezJournal.t154")+journalTitle+"</p>";
				
				InternetAddress from;
				from = new InternetAddress(userInfo.getEmail());
				from.setPersonal(userInfo.getDisplayName());
				ezEmailService.sendMail(loginCookie , from, toArr, null, null, subject, content, false);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		logger.debug("sendJournalRecvMail ended");
	}
}
