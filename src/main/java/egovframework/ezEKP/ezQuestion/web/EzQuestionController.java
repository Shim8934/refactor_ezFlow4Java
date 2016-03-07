package egovframework.ezEKP.ezQuestion.web;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.swing.text.Document;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
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

	@RequestMapping(value="/ezQuestion/poll/qstList.do")
	public String qstList(@CookieValue("userID") String userID,LoginVO loginVO,ModelMap model,QuestionListVO questionListVO,HttpServletRequest request, HttpServletResponse response) throws Exception{
		loginVO = commonUtil.userInfo(userID);
		questionListVO.setUserId(loginVO.getId());
		questionListVO.setBrdId(5);
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

		questionListVO.setTotalCnt(ezQuestionService.getQstListCnt(questionListVO));
		model.addAttribute("questionListVO", questionListVO);
		System.out.println(questionListVO.getTotalCnt());
		
		return "/ezQuestion/qstList";
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

		return "/ezQuestion/qstStep2QuestionAdd";
	}

	@RequestMapping(value="/ezQuestion/qstComplete.do", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> qstCompleteCross(HttpServletRequest req) throws Exception  {
		
			
			
		File file = new File(req.getParameter("xmlDoc"));
		DocumentBuilderFactory docBuildFact = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuild = docBuildFact.newDocumentBuilder();
		org.w3c.dom.Document doc = docBuild.parse(file);
		doc.getDocumentElement().normalize();
		
System.out.println(doc.getDocumentElement().getNodeName());
		
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
