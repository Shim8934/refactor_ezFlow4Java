package egovframework.ezEKP.ezQuestion.web;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezQuestion.vo.EzQuestionVO;
import egovframework.let.user.login.service.LoginService;
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
	
	@RequestMapping(value="/ezQuestion/poll/qstList.do")
	public String qstList(){
		return "/ezQuestion/poll/qstList";
	}
	
	@RequestMapping(value="/ezQuestion/poll/qstStep1.do")
	public String qstStep1(HttpServletRequest req,Model model)  {
		String brdId = req.getParameter("brd_ID");
		String brdNm = req.getParameter("brd_nm");
		String brdPostterm = req.getParameter("brd_postterm");
System.out.println(brdNm);		
		model.addAttribute("brdId", brdId);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdPostterm", brdPostterm);
		
		return "/ezQuestion/poll/qstStep1";
	}
	
	@RequestMapping(value="/ezQuestion/poll/qstStep2.do")
	public String qstStep2(HttpServletRequest req, EzQuestionVO ezQuestionVO, Model model) {
		/*String txtExpiredate = req.getParameter("txtExpiredate");
		String setAnonymity = req.getParameter("set_anonymity");
		String hidanonymity = req.getParameter("hidanonymity");
		String hidopenResult = req.getParameter("hidopenResult");
		String hidMultiResponse = req.getParameter("hidMultiResponse");
		String hidTarget = req.getParameter("hidTarget");
		String brd_id = req.getParameter("brd_id");
		String brd_nm = req.getParameter("brd_nm");
		String brd_postterm = req.getParameter("brd_postterm");
		String item_no = req.getParameter("item_no");
		String hidStartDate = req.getParameter("hidStartDate");
		String hidEndDate = req.getParameter("hidEndDate");
		String select_YN = req.getParameter("select_YN");
		String RangeXMLStr = req.getParameter("RangeXMLStr");
		String set_MultiResponse = req.getParameter("set_MultiResponse");
		String set_openResult = req.getParameter("set_openResult");
		String importance = req.getParameter("importance");
		String set_Target = req.getParameter("set_Target");
		String txtSubject = req.getParameter("txtSubject");
		String txtContent = req.getParameter("txtContent");*/
		model.addAttribute("txtExpiredate", ezQuestionVO.getTxtExpiredate());
		model.addAttribute("set_anonymity", req.getParameter("set_anonymity"));
		model.addAttribute("hidanonymity", req.getParameter("hidanonymity"));
		model.addAttribute("hidopenResult", req.getParameter("hidopenResult"));
		model.addAttribute("hidMultiResponse", req.getParameter("hidMultiResponse"));
		model.addAttribute("hidTarget", req.getParameter("hidTarget"));
		model.addAttribute("brd_id", req.getParameter("brd_id"));
		model.addAttribute("brd_nm", req.getParameter("brd_nm"));
		model.addAttribute("brd_postterm", req.getParameter("brd_postterm"));
		model.addAttribute("item_no", req.getParameter("item_no"));
		model.addAttribute("hidStartDate", req.getParameter("hidStartDate"));
		model.addAttribute("hidEndDate", req.getParameter("hidEndDate"));
		model.addAttribute("select_YN", req.getParameter("select_YN"));
		model.addAttribute("RangeXMLStr", req.getParameter("RangeXMLStr"));
		model.addAttribute("set_MultiResponse", req.getParameter("set_MultiResponse"));
		model.addAttribute("set_openResult", req.getParameter("set_openResult"));
		model.addAttribute("importance", req.getParameter("importance"));
		model.addAttribute("set_Target", req.getParameter("set_Target"));
		model.addAttribute("txtSubject", req.getParameter("txtSubject"));
		model.addAttribute("txtContent", req.getParameter("txtContent"));
		model.addAttribute("item_id", req.getParameter("item_id"));
		
System.out.println(req.getParameter("item_id"));		
		return "/ezQuestion/poll/qstStep2";
	}
	
	@RequestMapping(value="/ezQuestion/poll/qstRangeSelect.do")
	public String qstRangeSelect()  {
		
		return "/ezQuestion/poll/qstRangeSelect/rangeSelect";
	}
	
	@RequestMapping(value="/ezQuestion/poll/qstStep2QuestionAdd.do")
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
System.out.println(pMode);
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
		
		return "/ezQuestion/poll/qstStep2QuestionAdd";
	}
	
	@RequestMapping(value="/ezQuestion/qstComplete.do", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> qstCompleteCross(HttpServletRequest req)  {
System.out.println("!!");
		String pBrdID = "";
		String vItemID = "";
		if(req.getParameter("pBrdID") == null) {
			pBrdID = "5";
			vItemID = "";
		}
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
		
System.out.println(subject);		
		map.put("subject", subject);
		map.put("content", content);

		return map;
	}
}
