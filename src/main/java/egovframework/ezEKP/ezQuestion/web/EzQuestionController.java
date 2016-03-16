package egovframework.ezEKP.ezQuestion.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezQuestion.vo.QstStep1VO;
import egovframework.ezEKP.ezQuestion.vo.QstAddVO;
import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzQuestionController {
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;

	@Resource(name="EzQuestionService")
	private EzQuestionService ezQuestionService;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@RequestMapping(value="/ezQuestion/qstList.do")
	public String qstList(@CookieValue("loginCookie") String loginCookie, ModelMap model, QstListVO qstListVO, HttpServletRequest request) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		/** 전달받지 않은 인자 초기화 */
		qstListVO.setUserId(loginVO.getId());
		if(qstListVO.getBrdId()==0)
			qstListVO.setBrdId(5);
		else
			qstListVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		if(qstListVO.getTitle()==null)
			qstListVO.setTitle("");
		if(qstListVO.getResponseRange()==null)
			qstListVO.setResponseRange("");
		if(qstListVO.getPostDate()==null)
			qstListVO.setPostDate("");
		if(qstListVO.getPollEndDate()==null)
			qstListVO.setPollEndDate("");
		if(qstListVO.getLang()==null)
			qstListVO.setLang("");
		if(qstListVO.getPageSize()==0)
			qstListVO.setPageSize(15);
		if(qstListVO.getCurrPage()==0)
			qstListVO.setCurrPage(1);
		
		qstListVO.setTotalCnt(ezQuestionService.getQstListCnt(qstListVO));
		
		if(qstListVO.getTotalPage()==0)
			qstListVO.setTotalPage((qstListVO.getTotalCnt()+qstListVO.getPageSize()-1)/qstListVO.getPageSize());

		List<QstListVO> list = ezQuestionService.getQstList(qstListVO);		
		
		StringBuffer strbuffer;
		
		for(QstListVO qst : list){
			if(qst.getReceve()==null){
				strbuffer = new StringBuffer();
				strbuffer.append("brdId="+qst.getBrdId());
				strbuffer.append("&title="+qst.getTitle());
				strbuffer.append("&responseRange="+qst.getResponseRange());
				strbuffer.append("&postDate="+qst.getPostDate());
				strbuffer.append("&pollEndDate="+qst.getPollEndDate());
				strbuffer.append("&currPage="+qstListVO.getCurrPage());
				
				qst.setReceve(strbuffer.toString());
			}
		}
		
		/** 설문기간에 따른 Title 처리*/
		java.text.DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		Date startDate;
		Date endDate;
		Date sysDate;
		sysDate = new Date();
		int compareStart, compareEnd;
		
		for(QstListVO qst : list){
			startDate=formatter.parse(qst.getPostDate());
			endDate=formatter.parse(qst.getPollEndDate());
			compareStart = startDate.compareTo(sysDate);
			compareEnd = endDate.compareTo(sysDate);
			strbuffer = new StringBuffer();
			if(compareStart <= 0 && compareEnd >= 0){
				strbuffer.append("[진행중] ");
				strbuffer.append(qst.getTitle()); 
				qst.setTitle(strbuffer.toString());
			}else{
				strbuffer.append("[완료] ");
				strbuffer.append(qst.getTitle());
				qst.setTitle(strbuffer.toString());
			}				
		}
		
		model.addAttribute("qstListVO", qstListVO);
		model.addAttribute("list", list);
		
		return "/ezQuestion/qstList";
	}
	
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/pollOpen.do")
	public void pollOpen(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,HttpServletResponse response) throws Exception{
		String receve = "brdId=" + request.getParameter("brdId") +
                "&itemNo=" + request.getParameter("itemNo") +
                "&title=" + request.getParameter("title") +
                "&responseRange=" + request.getParameter("responseRange") +
                "&postDate=" + request.getParameter("postDate") +
                "&pollEndDate=" + request.getParameter("pollEndDate") +
                "&currPage=" + request.getParameter("currPage");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String userId = loginVO.getId();
		/**UserPollItem*/
		QstUserPollItemVO qstUserPollItemVO = new QstUserPollItemVO();
		qstUserPollItemVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		qstUserPollItemVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		qstUserPollItemVO=ezQuestionService.getUserPollItem(qstUserPollItemVO);
		/** 결과값없으면 Error처리*/
		if(qstUserPollItemVO.getTitle().equals(null))
			response.sendRedirect("/error.do"); //나중에 에러처리찾아서 주소만바꾸면됨
		/** 설문기간에 따른 Title처리*/
		java.text.DateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		Date startDate1;
		Date endDate1;
		Date sysDate1;
		sysDate1 = new Date();
		int compareStart, compareEnd;
		String strData;
		
		startDate1=formatter1.parse(qstUserPollItemVO.getPostDate());
		endDate1=formatter1.parse(qstUserPollItemVO.getPollEndDate());
		compareStart = startDate1.compareTo(sysDate1);
		compareEnd = endDate1.compareTo(sysDate1);
		StringBuffer strbuffer = new StringBuffer();
		if(compareStart <= 0 && compareEnd >= 0){
			strbuffer.append("[진행중] ");
			strbuffer.append(qstUserPollItemVO.getTitle()); 
			strData = strbuffer.toString();
		}else{
			strbuffer.append("[완료] ");
			strbuffer.append(qstUserPollItemVO.getTitle());
			strData = strbuffer.toString();
		}
		
		/**UserPermission*/
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		qstUserPermissionVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		qstUserPermissionVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		
		qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
		
		/**ResponseCnt*/
		qstUserPermissionVO.setUserId(userId);
		int responseCnt = ezQuestionService.getUserResponseCnt(qstUserPermissionVO);
		/** 날짜계산*/
		boolean endPoll = false;
		Date sysDate=new Date();
		java.text.DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		if(formatter.parse(qstUserPollItemVO.getPollEndDate()).compareTo(sysDate)<0)
			endPoll = true;
		if(qstUserPermissionVO.getEndFlg().equals('1'))
			endPoll = true;
		
		/**UserIdAdmin*/
		boolean adminYN = false;
		String rsUserId = qstUserPollItemVO.getUserId();
		List<String> userIdAdminList = ezQuestionService.getUserIdAdmin(request.getParameter("brdId"));
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		if(endPoll == false){
			if(responseCnt <= 0){
				response.getWriter().write("<script language='javascript'>");
				response.getWriter().write("window.location.href='/ezQuestion/qstResponse.do?" + receve + "'");
				response.getWriter().write("</script>");
				response.getWriter().flush();
			}
			else if(qstUserPermissionVO.getPublicResultFlg().equals("1")){
				if(qstUserPermissionVO.getMultiResponseFlg().equals("1")){
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("window.open('/ezQuestion/msgAdminConfirm.do?" + receve + "', '', 'height=205px,width=330px, status = no, toolbar=no, menubar=no,location=no, resizable=1');");
					response.getWriter().write("	window.location.href='/ezQuestion/qstList.do?brdId=5';");
					response.getWriter().write("</script>");
					response.getWriter().flush();
				}else{
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("	window.location.href='/ezQuestion/qstResult.do?" + receve + "';");
					response.getWriter().write("</script>");
					response.getWriter().flush();
				}
			}else{
				adminYN = false;
				if(userIdAdminList != null){
					for(String userIdAdmin : userIdAdminList){
						if(userId == userIdAdmin)
							adminYN = true;
					}
				}
				if(userId == rsUserId || adminYN == true){
					if(qstUserPermissionVO.getMultiResponseFlg().equals("1")){
						response.getWriter().write("<script language='javascript'>");
						response.getWriter().write("window.open('msgAdminConfirm.do?" + receve + "', '', 'height=205px,width=330px, status = no, toolbar=no, menubar=no,location=no, resizable=1');");
						response.getWriter().write("</script>");
						response.getWriter().write("	window.location.href='/ezQuestion/qstList.do?brdId=5';");
						response.getWriter().write("</script>");
						response.getWriter().flush();
					}else{
						response.getWriter().write("<script language='javascript'>");
						response.getWriter().write("	window.location.href='/ezQuestion/qstResult.do?" + receve + "';");
						response.getWriter().write("</script>");
						response.getWriter().flush();
					}
				}else{
					if(qstUserPermissionVO.getMultiResponseFlg().equals("1")){
						response.getWriter().write("<script language='javascript'>");
						response.getWriter().write("window.open('msgAdminConfirm.do?" + receve + "', '', 'height=205px,width=330px, status = no, toolbar=no, menubar=no,location=no, resizable=1');");
						response.getWriter().write("	window.location.href='/ezQuestion/qstList.do?brdId=5';");
						response.getWriter().write("</script>");
						response.getWriter().flush();
					}else{
						response.getWriter().write("<script language='javascript'>");
						response.getWriter().write("	alert('" + egovMessageSource.getMessage("ezQuestion.t112") + "');");
						response.getWriter().write(" window.location.href = '/ezQuestion/qstList.do?brdId=5'");						
						response.getWriter().write("</script>");
						response.getWriter().flush();
					}
				}
			}
		}else{
			if (qstUserPermissionVO.getPublicResultFlg().equals("1")){
				response.getWriter().write("<script language='javascript'>");
				response.getWriter().write("	window.location.href='/ezQuestion/qstResult.do?" + receve + "';");
				response.getWriter().write("</script>");
				response.getWriter().flush();
			}else{
				adminYN = false;
				if(userIdAdminList != null){
					for(String userIdAdmin : userIdAdminList){
						if(userId == userIdAdmin)
							adminYN = true;
					}
				}
				if (rsUserId == userId || adminYN == true){
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("	window.location.href='/ezQuestion/qstResult.do?" + receve + "';");
					response.getWriter().write("</script>");
					response.getWriter().flush();
				}else{
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("	alert('" + egovMessageSource.getMessage("ezQuestion.t112") + "');");
					response.getWriter().write("	window.location.href='/ezQuestion/qstList.do?brdId=5';");
					response.getWriter().write("</script>");
					response.getWriter().flush();
				}
			}
		}
	}
	
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResponseCross.do")
	public String qstResponseCross(@CookieValue("loginCookie") String loginCookie, ModelMap model,HttpServletRequest request) throws Exception{
		QstVO qstVO = new QstVO();
		qstVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		qstVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		
		
/*		model.addAttribute("brdId",request.getParameter("brdId"));
		model.addAttribute("itemNo",request.getParameter("itemNo"));
		model.addAttribute("title",request.getParameter("title"));
		model.addAttribute("responseRange",request.getParameter("responseRange"));
		model.addAttribute("postDate",request.getParameter("postDate"));
		model.addAttribute("pollEndDate",request.getParameter("pollEndDate"));
		model.addAttribute("currPage",request.getParameter("currPage")); */
		List<Integer> arrAnswer = new ArrayList<Integer>();
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String userId = loginVO.getId();
		boolean multiResponseOK = false;
		int responseCnt = 0;
		int readCnt = 0;
		
		/**UserPermission*/
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		qstUserPermissionVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		qstUserPermissionVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		qstUserPermissionVO=ezQuestionService.getUserPermission(qstUserPermissionVO);
		if(qstUserPermissionVO.getMultiResponseFlg().equals(1)){
			multiResponseOK = true;
		}else{
		/** ResponseDateCnt*/
//			qstUserPermissionVO 대신 나중에 view 로 던질 VO 삽입
			if(ezQuestionService.getResponseDateCnt(qstUserPermissionVO)!=0){
				multiResponseOK = false;
			}else{
				multiResponseOK = true;
			}
		}
		/** UserIdAdmin*/
		List<String> userIdAdminList = ezQuestionService.getUserIdAdmin(request.getParameter("brdId"));
		boolean adminYN = false;
		if(userIdAdminList != null){
			for(String userIdAdmin : userIdAdminList){
				if(userId == userIdAdmin)
					adminYN = true;
			}
		}
		/** ResCount*/
		responseCnt = ezQuestionService.resCount(request.getParameter("brdId"));
		/** UserPollItem*/
		QstUserPollItemVO qstUserPollItemVO = new QstUserPollItemVO();
		qstUserPollItemVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		qstUserPollItemVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		qstUserPollItemVO=ezQuestionService.getUserPollItem(qstUserPollItemVO);
		
		if(qstUserPollItemVO.getUserId() != userId){
			qstUserPollItemVO.setReadCnt(qstUserPollItemVO.getReadCnt() + 1);
			/** updateReadCnt*/
			ezQuestionService.updateReadCnt(qstUserPollItemVO);
		}
		/** ReadDateItem*/
		int readDateCnt = ezQuestionService.getReadDateItem();
		if(readDateCnt != 0){
			if(readDateCnt > 0){
//				sysdate, brdId, itemNo, userId
				/** updateReadDate*/
				ezQuestionService.updateReadDate(qstUserPollItemVO);
			}else{
//				sysdate, displayName1,2,deptId,deptName1,2,title1,2
				/** insertItemRead*/
//				ezQuestionService.insertItemRead();
			}
		}
//		xml
		/** QuestionForResponse*/
		List<QstVO> questionList = ezQuestionService.getQuestionForResponse(qstVO);
		
		if(questionList != null){
			int iQueCount = 0;
			for(QstVO question : questionList){
				iQueCount++;
				arrAnswer.add(question.getAnswerType());
				/** xml에 질문하나씩 넣는건데  */
			}
		}
		
		/** AnswerCnt*/
		/** AttachInfo*/
		
		/** 날짜계산*/
		boolean endPoll = false;
		Date sysDate=new Date();
		java.text.DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		if(formatter.parse(qstUserPollItemVO.getPollEndDate()).compareTo(sysDate)<0)
			endPoll = true;
		if(qstUserPermissionVO.getEndFlg().equals('1'))
			endPoll = true;
		
		return "/ezQuestion/qstResponse";
	}
	
	@RequestMapping(value="/ezQuestion/qstResult.do")
	public String qstResult(ModelMap model, HttpServletRequest request) throws Exception{
		/*model.addAttribute("brdId",request.getParameter("brdId"));
		model.addAttribute("itemNo",request.getParameter("itemNo"));
		model.addAttribute("title",request.getParameter("title"));
		model.addAttribute("responseRange",request.getParameter("responseRange"));
		model.addAttribute("postDate",request.getParameter("postDate"));
		model.addAttribute("pollEndDate",request.getParameter("pollEndDate"));
		model.addAttribute("currPage",request.getParameter("currPage"));*/
	
		return "/ezQuestion/qstResult";
	}

	@RequestMapping(value="/ezQuestion/qstStep1.do")
	public String qstStep1(HttpServletRequest req,Model model)  {
		String brdId = req.getParameter("brd_ID");
		String brdNm = req.getParameter("brd_nm");
		String brdPostterm = req.getParameter("brd_postterm");

		model.addAttribute("brdId", brdId);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdPostterm", brdPostterm);

		return "/ezQuestion/qstStep1";
	}

	@RequestMapping(value="/ezQuestion/qstStep2.do", method = RequestMethod.POST)
	public String qstStep2(HttpServletRequest req, QstStep1VO ezQuestionVO, QstAddVO questionAddVO, ModelMap model) {
		StringBuilder pStep1DataXML = new StringBuilder();
		pStep1DataXML.append("<PARAMETER>");
		pStep1DataXML.append("<SUBJECT><![CDATA[" + req.getParameter("txtSubject") + "]]></SUBJECT>");
		pStep1DataXML.append("<CONTENT><![CDATA[" + req.getParameter("txtContent") + "]]></CONTENT>");
		pStep1DataXML.append("<STARTDATE>" + req.getParameter("hidStartDate")+"</STARTDATE>");
		pStep1DataXML.append("<ENDDATE>" + req.getParameter("hidEndDate")+"</ENDDATE>");
		pStep1DataXML.append("<EXPIREDATE>" + req.getParameter("txtExpiredate")+"</EXPIREDATE>");
		pStep1DataXML.append("<ANONYMITY>" + req.getParameter("setAnonymity")+"</ANONYMITY>");
		pStep1DataXML.append("<OPENRESULT>" + req.getParameter("setOpenResult")+"</OPENRESULT>");
		pStep1DataXML.append("<MULTIRESPONSE>" + req.getParameter("setMultiResponse")+"</MULTIRESPONSE>");
		pStep1DataXML.append("<IMPORTANT>" + req.getParameter("importance")+"</IMPORTANT>");
		pStep1DataXML.append("<TARGET>" + req.getParameter("setTarget")+"</TARGET>");
		pStep1DataXML.append("</PARAMETER>");
System.out.println("answerType@@@@@@@:"+req.getParameter("answerType"));
System.out.println("answerType@@@@@@@:"+req.getParameter("multiSelect"));
System.out.println("answerType@@@@@@@:"+req.getParameter("selViewStart"));
System.out.println("answerType@@@@@@@:"+req.getParameter("selViewEnd"));
System.out.println("answerType@@@@@@@:"+req.getParameter("itemNo"));
System.out.println("answerType@@@@@@@:"+req.getParameter("txtQuestion"));
System.out.println("title@@@@@@@:"+questionAddVO.getTitle());
		
		model.addAttribute("getTitle", questionAddVO.getTitle());
		model.addAttribute("ezQuestionVO", ezQuestionVO);
		model.addAttribute("questionAddVO", questionAddVO);
		model.addAttribute("pStep1DataXML", pStep1DataXML);
		return "/ezQuestion/qstStep2";
	}

	@RequestMapping(value="/ezQuestion/qstRangeSelect.do")
	public String qstRangeSelect()  {

		return "/ezQuestion/qstRangeSelect/rangeSelect";
	}

	@RequestMapping(value="/ezQuestion/qstStep2QuestionAdd.do")
	public String qstStep2QuestionAdd(HttpServletRequest req,Model model, QstAddVO questionAddVO)  {
		String brdId = "";
		String itemId = "";
		String pMode = "";
		String pQstTitle, pAnswerType, pMultiSel;
		String pSelectOption = "";
		String pEditIndex;
		List<String> pQstAnsInfo;
		String pQstAttach = "";
		String pDataXML = "";
		String pNoneActiveX = "";

		pMode = "NEW";
		pAnswerType = "1";
		if(req.getParameter("brd_id") != null) {
			brdId = req.getParameter("brd_id").trim(); 
		}
		
		if(req.getParameter("item_id") != null) {
			itemId = req.getParameter("item_id").trim(); 
		}
		if (questionAddVO != null) {
			pMode = "EDIT";
			pQstTitle = questionAddVO.getQuestionContent();
System.out.println("pQstTitle:"+pQstTitle);
			/*if(questionAddVO.getAttach().size() > 0) {
				if(questionAddVO.getAttach().toString() != "") {
					pQstAnsInfo = questionAddVO.getAttach();
					
					int pAttachCnt = questionAddVO.getAttach().size();
					for (int i=0; i< pAttachCnt; i++) {
						if(pQstAnsInfo.equals("")) {
							pQstAttach += ";";
						}
						pQstAttach += questionAddVO.getTitle();
					}
				}
			}*/
			pAnswerType = String.valueOf(questionAddVO.getAnswerType());
			questionAddVO.setMultiSelect("1");
			if(questionAddVO.getMultiSelect().equals("1")) {
				pMultiSel = "true";
			} else {
				pMultiSel = "false";
			}
			if(!pAnswerType.equals("2")) {
				/*if(questionAddVO.getAnswer().size() != 0) {
					int pCnt = questionAddVO.getAnswer().size();
					
					for (int i=0; i<pCnt; i++) {
						pSelectOption += "<option value=\"" + questionAddVO.getTitle() + "\" ";
						if(questionAddVO.getAttach().size() > 0) {
							pSelectOption += "AnsInfo=\"" + questionAddVO.getAttach().get(0).toString() + "\">";
						} else {
							pSelectOption += ">";
						}
						pSelectOption += String.valueOf(i+1) + "." + questionAddVO.getTitle() + "</option>";
					}
				}*/
			}
			if(req.getParameter("dataIndex") != null) {
				pEditIndex = String.valueOf(req.getParameter("dataIndex"));
			}
		}
		
		itemId = req.getParameter("item_id");
		model.addAttribute("item_id",itemId);
		model.addAttribute("questionAddVO",questionAddVO);
		model.addAttribute("pEditIndex",req.getParameter("pEditIndex"));
		model.addAttribute("pMode",req.getParameter("pMode"));
		model.addAttribute("pMultiSel",req.getParameter("pMultiSel"));
		model.addAttribute("pDataXml",req.getParameter("pDataXml"));
		model.addAttribute("pNoneActiveX",req.getParameter("pNoneActiveX"));
		model.addAttribute("pQstTitle",req.getParameter("txtContent"));
		model.addAttribute("pAnswerType",req.getParameter("pAnswerType"));
		model.addAttribute("pMultiSel",req.getParameter("pMultiSel"));
		model.addAttribute("pSelectOption",req.getParameter("pSelectOption"));

		return "/ezQuestion/qstStep2QuestionAdd";
	}
	
	public String callGetItemSeq(String pBrdID) throws Exception {
		int get_itemNo = -1;
		if(ezQuestionService.getItemSeq(pBrdID) == "") {
			get_itemNo = 1;
		} else {
			get_itemNo = Integer.parseInt(ezQuestionService.getItemSeq(pBrdID).toString());
		}
		if(get_itemNo == -1) {
			ezQuestionService.insertItemSeq(pBrdID);
			get_itemNo = 1;
		} else {
			get_itemNo = get_itemNo + 1;
			ezQuestionService.updateItemSeq(Integer.parseInt(pBrdID), get_itemNo);
		}
		
		return String.valueOf(get_itemNo);
	}

	@RequestMapping(value="/ezQuestion/qstComplete.do", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> qstCompleteCross(HttpServletRequest req,@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, QstCompleteVO qstCompleteVO) throws Exception  {
		loginVO = commonUtil.userInfo(loginCookie);
		String pUserID = loginVO.getId();
		
		String pBrdID = "";
		String vItemID = "";
		if(req.getParameter("pBrdID") == null) {
			pBrdID = "5";
			vItemID = callGetItemSeq(pBrdID);
		}
		
		int dataCount = 0;
		int brdId = Integer.parseInt(pBrdID);
		int itemNo = Integer.parseInt(vItemID);

		dataCount = ezQuestionService.getItemNoCnt(brdId, itemNo);

		Map<String, Object> map = new HashMap<String, Object>();
		String subject = req.getParameter("parameter[subject]");
		String content = req.getParameter("parameter[content]");
		String startdate = req.getParameter("parameter[startdate]");
		String enddate = req.getParameter("parameter[enddate]");
		String expiredate = req.getParameter("parameter[expiredate]");
		String anonymity = req.getParameter("parameter[anonymity]");
		String openresult = req.getParameter("parameter[openresult]");
		String multiresponse = req.getParameter("parameter[multiresponse]");
		String importance = req.getParameter("parameter[importance]");
		String target = req.getParameter("parameter[target]");
		
		map.put("subject", subject);
		map.put("content", content);
		map.put("startdate", startdate);
		map.put("enddate", enddate);
		map.put("expiredate", expiredate);
		map.put("anonymity", anonymity);
		map.put("openresult", openresult);
		map.put("multiresponse", multiresponse);
		map.put("importance", importance);
		map.put("target", target);
		map.put("brdId", brdId);
		map.put("itemNo", itemNo);
		map.put("itemId", vItemID);
		map.put("dataCount", dataCount);
		
		ezQuestionService.stepSave(pUserID, map); 
		
		ezQuestionService.stepSave2(map);
		
		
		//대상범위
		if (target.equals("1")) {
			
		}
		
		//int qstCnt =  
		
		int v_quesNo = 1;

		v_quesNo = ezQuestionService.getQuestionNo(brdId, itemNo);
		
		if(v_quesNo == 0) {
			v_quesNo = 1;
		} else {
			v_quesNo = v_quesNo + 1;
		}
		
		//ezQuestionService.insertQuestion(qstCompleteVO); 
		
		
	
		
		return map;
		
	}
}
