package egovframework.ezEKP.ezQuestion.web;

import java.text.SimpleDateFormat;
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
import egovframework.ezEKP.ezQuestion.vo.EzQuestionVO;
import egovframework.ezEKP.ezQuestion.vo.QuestionListVO;
import egovframework.ezEKP.ezQuestion.vo.UserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.UserPollItemVO;
import egovframework.ezEKP.ezQuestion.vo.StepSaveVO;
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
	public String qstList(@CookieValue("userID") String userID,LoginVO loginVO,ModelMap model,QuestionListVO questionListVO,HttpServletRequest request) throws Exception{
		loginVO = commonUtil.userInfo(userID);
		/** 전달받지 않은 인자 초기화 */
		questionListVO.setUserId(loginVO.getId());
		if(questionListVO.getBrdId()==0)
			questionListVO.setBrdId(Integer.parseInt(request.getParameter("brd_ID")));
		if(questionListVO.getTitle()==null)
			questionListVO.setTitle("");
		if(questionListVO.getResponseRange()==null)
			questionListVO.setResponseRange("");
		if(questionListVO.getPostDate()==null)
			questionListVO.setPostDate("");
		if(questionListVO.getPollEndDate()==null)
			questionListVO.setPollEndDate("");
		if(questionListVO.getLang()==null)
			questionListVO.setLang("");
		if(questionListVO.getPageSize()==0)
			questionListVO.setPageSize(15);
		if(questionListVO.getCurrPage()==0)
			questionListVO.setCurrPage(1);
		
		questionListVO.setTotalCnt(ezQuestionService.getQstListCnt(questionListVO));
		
		if(questionListVO.getTotalPage()==0)
			questionListVO.setTotalPage((questionListVO.getTotalCnt()+questionListVO.getPageSize()-1)/questionListVO.getPageSize());

		List<QuestionListVO> list = ezQuestionService.getQstList(questionListVO);		
		
		StringBuffer strbuffer;
		
		for(QuestionListVO qst : list){
			if(qst.getReceve()==null){
				strbuffer = new StringBuffer();
				strbuffer.append("brdId="+qst.getBrdId());
				strbuffer.append("&title="+qst.getTitle());
				strbuffer.append("&responseRange="+qst.getResponseRange());
				strbuffer.append("&postDate="+qst.getPostDate());
				strbuffer.append("&pollEndDate="+qst.getPollEndDate());
				strbuffer.append("&CurrPage="+questionListVO.getCurrPage());
				
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
		
		for(QuestionListVO qst : list){
			startDate=formatter.parse(qst.getPostDate());
			endDate=formatter.parse(qst.getPollEndDate());
			compareStart = startDate.compareTo(sysDate);
			compareEnd = endDate.compareTo(sysDate);
			strbuffer = new StringBuffer();
			if(compareStart <= 0 && compareEnd >= 0){
				strbuffer.append("[진행중] ");
				strbuffer.append(qst.getTitle()); 
				qst.setTitle(strbuffer.toString());
			}
			else{
				strbuffer.append("[완료] ");
				strbuffer.append(qst.getTitle());
				qst.setTitle(strbuffer.toString());
			}				
		}
		
		model.addAttribute("questionListVO", questionListVO);
		model.addAttribute("list", list);
		
		return "/ezQuestion/qstList";
	}
	
	@RequestMapping(value="/ezQuestion/pollOpen.do")
	public String pollOpen(@CookieValue("userID") String userID,LoginVO loginVO, ModelMap model,HttpServletRequest request) throws Exception{
		loginVO = commonUtil.userInfo(userID);
		UserPollItemVO userPollItemVO = new UserPollItemVO();
		userPollItemVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		userPollItemVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		/** 결과값없으면 Error처리*/
		if(ezQuestionService.getUserPollItem(userPollItemVO).getTitle().equals(null))
			return "redirect:/error.do"; //나중에 에러처리찾아서 주소만바꾸면됨
		UserPermissionVO userPermissionVO = new UserPermissionVO();
		userPermissionVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		userPermissionVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		userPermissionVO.setUserId(loginVO.getId());
		
		System.out.println(ezQuestionService.getUserResponseCnt(userPermissionVO));
	
//		ezQuestionService.getUserResponseCnt();
//		ezQuestionService.getUserIdAdmin();
		model.addAttribute(request.getParameter("CurrPage"));
		model.addAttribute("userPermission", ezQuestionService.getUserPermission(userPermissionVO));
		model.addAttribute("userPollItemVO", ezQuestionService.getUserPollItem(userPollItemVO));
		
		return "redirect:/ezQuestion/qstResult.do";
	}

	@RequestMapping(value="/ezQuestion/qstStep1.do")
	public String qstStep1(HttpServletRequest req,Model model)  {
		String brdId = req.getParameter("brd_ID");
		String brdNm = req.getParameter("brd_nm");
		String brdPostterm = req.getParameter("brd_postterm");
		System.out.println(brdNm);		
		model.addAttribute("brdId", brdId);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdPostterm", brdPostterm);

		return "/ezQuestion/qstStep1";
	}

	@RequestMapping(value="/ezQuestion/qstStep2.do")
	public String qstStep2(HttpServletRequest req, EzQuestionVO ezQuestionVO, Model model) {
		
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

		model.addAttribute("ezQuestionVO", ezQuestionVO);
		model.addAttribute("pStep1DataXML", pStep1DataXML);
		return "/ezQuestion/qstStep2";
	}

	@RequestMapping(value="/ezQuestion/qstRangeSelect.do")
	public String qstRangeSelect()  {

		return "/ezQuestion/qstRangeSelect/rangeSelect";
	}

	@RequestMapping(value="/ezQuestion/qstStep2QuestionAdd.do")
	public String qstStep2QuestionAdd(HttpServletRequest req,Model model)  {
		String brdId = "";
		String itemId = "";
		String pMode = "";
		String pQstTitle, pAnswerType, pMultiSel;
		String pSelectOption;
		String pEditIndex;
		String pQstAnsInfo;
		String pQstAttach = "";
		String pDataXML = "";
		String pNoneActiveX = "";

		pMode = "NEW";
		pAnswerType = "1";
		brdId = req.getParameter("brd_id"); 
		itemId = req.getParameter("item_id");
		model.addAttribute("item_id",itemId);
		model.addAttribute("pEditIndex",req.getParameter("pEditIndex"));
		model.addAttribute("pMode",req.getParameter("pMode"));
		model.addAttribute("pMultiSel",req.getParameter("pMultiSel"));
		model.addAttribute("pDataXml",req.getParameter("pDataXml"));
		model.addAttribute("pNoneActiveX",req.getParameter("pNoneActiveX"));
		model.addAttribute("pQstTitle",req.getParameter("pQstTitle"));
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
	public @ResponseBody Map<String, Object> qstCompleteCross(HttpServletRequest req,@CookieValue("userID") String userID, LoginVO loginVO,ModelMap model) throws Exception  {
		/*File file = new File(req.getParameter("xmlDoc"));
		DocumentBuilderFactory docBuildFact = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuild = docBuildFact.newDocumentBuilder();
		org.w3c.dom.Document doc = docBuild.parse(file);
		doc.getDocumentElement().normalize();*/
		loginVO.setId(userID);
		loginVO = commonUtil.userInfo(userID);
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
		String questionContent = req.getParameter("parameter[question][row][content]");
		
		map.put("subject", subject);
		map.put("content", content);
		map.put("startdate", startdate);
		map.put("enddate", enddate);
		map.put("expiredate", expiredate);
		map.put("anonymity", anonymity);
System.out.println(anonymity+"!!!!!!!");
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
		return map;
		
	}
}
