package egovframework.ezEKP.ezQuestion.web;

import java.io.StringReader;
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
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezQuestion.vo.QstAddVO;
import egovframework.ezEKP.ezQuestion.vo.QstAttachVO;
import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstStep1VO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
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
		
		StringBuilder strbuilder;
		
		for(QstListVO qst : list){
			if(qst.getReceve()==null){
				strbuilder = new StringBuilder();
				strbuilder.append("brdId="+qst.getBrdId());
				strbuilder.append("&title="+qst.getTitle());
				strbuilder.append("&responseRange="+qst.getResponseRange());
				strbuilder.append("&postDate="+qst.getPostDate());
				strbuilder.append("&pollEndDate="+qst.getPollEndDate());
				strbuilder.append("&currPage="+qstListVO.getCurrPage());
				
				qst.setReceve(strbuilder.toString());
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
			strbuilder = new StringBuilder();
			if(compareStart <= 0 && compareEnd >= 0){
				strbuilder.append("[진행중] ");
				strbuilder.append(qst.getTitle()); 
				qst.setTitle(strbuilder.toString());
			}else{
				strbuilder.append("[완료] ");
				strbuilder.append(qst.getTitle());
				qst.setTitle(strbuilder.toString());
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
		
		/**UserPermission*/
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		qstUserPermissionVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		qstUserPermissionVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		
		qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
		
		/**ResponseCnt*/
		int responseCnt = ezQuestionService.getUserResponseCnt(qstUserPermissionVO,userId);
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
		List<String> userIdAdminList = ezQuestionService.getUserIdAdmin(Integer.parseInt(request.getParameter("brdId")));
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		if(endPoll == false){
			if(responseCnt <= 0){
				response.getWriter().write("<script language='javascript'>");
				response.getWriter().write("window.location.href='/ezQuestion/qstResponse.do?" + receve + "';");
				response.getWriter().write("</script>");
				response.getWriter().flush();
			}
			else if(qstUserPermissionVO.getPublicResultFlg().equals("1")){
				if(qstUserPermissionVO.getMultiResponseFlg().equals("1")){
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("window.open('/ezQuestion/msgAdminConfirm.do?" + receve + "', '', 'height=205px,width=330px, status = no, toolbar=no, menubar=no,location=no, resizable=1');");
					response.getWriter().write("window.location.href='/ezQuestion/qstList.do?brdId=5';");
					response.getWriter().write("</script>");
					response.getWriter().flush();
				}else{
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("window.location.href='/ezQuestion/qstResult.do?" + receve + "';");
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
				if(userId.equals(rsUserId) || adminYN == true){
					if(qstUserPermissionVO.getMultiResponseFlg().equals("1")){
						response.getWriter().write("<script language='javascript'>");
						response.getWriter().write("window.open('msgAdminConfirm.do?" + receve + "', '', 'height=205px,width=330px, status = no, toolbar=no, menubar=no,location=no, resizable=1');");
						response.getWriter().write("</script>");
						response.getWriter().write("window.location.href='/ezQuestion/qstList.do?brdId=5';");
						response.getWriter().write("</script>");
						response.getWriter().flush();
					}else{
						response.getWriter().write("<script language='javascript'>");
						response.getWriter().write("window.location.href='/ezQuestion/qstResult.do?" + receve + "';");
						response.getWriter().write("</script>");
						response.getWriter().flush();
					}
				}else{
					if(qstUserPermissionVO.getMultiResponseFlg().equals("1")){
						response.getWriter().write("<script language='javascript'>");
						response.getWriter().write("window.open('msgAdminConfirm.do?" + receve + "', '', 'height=205px,width=330px, status = no, toolbar=no, menubar=no,location=no, resizable=1');");
						response.getWriter().write("window.location.href='/ezQuestion/qstList.do?brdId=5';");
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
				response.getWriter().write("window.location.href='/ezQuestion/qstResult.do?" + receve + "';");
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
				if (rsUserId.equals(userId) || adminYN == true){
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("window.location.href='/ezQuestion/qstResult.do?" + receve + "';");
					response.getWriter().write("</script>");
					response.getWriter().flush();
				}else{
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("alert('" + egovMessageSource.getMessage("ezQuestion.t112") + "');");
					response.getWriter().write("window.location.href='/ezQuestion/qstList.do?brdId=5';");
					response.getWriter().write("</script>");
					response.getWriter().flush();
				}
			}
		}
	}
	
	@RequestMapping(value="/ezQuestion/qstCallUsersPollStatus.do")
	@ResponseBody
	public Map<String, Object> qstCallUsersPollStatus(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		boolean endPoll = false;
		String endPollYN="";
		String responseYN="";
		String resultOpenYN="";
		String multiResYN="";
		String writeYN="";
		String adminYN="";
		int responseCnt=0;
		QstUserPollItemVO qstUserPollItemVO = new QstUserPollItemVO();
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		
		adminYN = "N";

		if(loginVO.getId().equals(ezQuestionService.getUserIdAdmin(Integer.parseInt(request.getParameter("brdId"))))){
			adminYN = "Y";
		}
		
		if(loginVO.getRollInfo().toUpperCase().indexOf("C=1") > -1 || loginVO.getRollInfo().toUpperCase().indexOf("K=1") > -1 || loginVO.getRollInfo().toUpperCase().indexOf("I=1") > -1){ 
			adminYN = "Y";
		}
		
		qstUserPollItemVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		qstUserPollItemVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		qstUserPollItemVO = ezQuestionService.getUserPollItem(qstUserPollItemVO);
		
		qstUserPermissionVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		qstUserPermissionVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
		
		responseCnt = ezQuestionService.getUserResponseCnt(qstUserPermissionVO,loginVO.getId());
		
		endPoll = false;
		Date sysDate=new Date();
		java.text.DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		
		if(formatter.parse(qstUserPollItemVO.getPollEndDate()).compareTo(sysDate) < 0)
			endPoll = true;
		if(qstUserPermissionVO.getEndFlg().equals("1"))
			endPoll = true;
		if(loginVO.getId().equals(qstUserPollItemVO.getUserId()))
			writeYN = "Y";
		else
			writeYN = "N";
		if(endPoll == false)
			endPollYN ="N";
		else
			endPollYN = "Y";
		if(responseCnt <=0)
			responseYN = "N";
		else
			responseYN ="Y";
		if(qstUserPermissionVO.getPublicResultFlg().equals("1"))
			resultOpenYN = "Y";
		else
			resultOpenYN = "N";
		if(qstUserPermissionVO.getMultiResponseFlg().equals("1"))
			multiResYN = "Y";
		else
			multiResYN = "N";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("endPollYN", endPollYN);
		map.put("writeYN", writeYN);
		map.put("responseYN", responseYN);
		map.put("resultOpenYN", resultOpenYN);
		map.put("multiResYN", multiResYN);
		map.put("adminYN", adminYN);
		
		return map;
	}
	
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResponse.do")
	public String qstResponse(@CookieValue("loginCookie") String loginCookie, ModelMap model,HttpServletRequest request) throws Exception{
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
		if(qstUserPermissionVO.getMultiResponseFlg().equals('1')){
			multiResponseOK = true;
		}else{
		/** ResponseDateCnt*/
//			qstUserPermissionVO 대신 나중에 view 로 던질 VO 삽입
			if(ezQuestionService.getResponseDateCnt(qstUserPermissionVO,userId)!=0){
				multiResponseOK = false;
			}else{
				multiResponseOK = true;
			}
		}
		/** UserIdAdmin*/
		List<String> userIdAdminList = ezQuestionService.getUserIdAdmin(Integer.parseInt(request.getParameter("brdId")));
		boolean adminYN = false;
		if(userIdAdminList != null){
			for(String userIdAdmin : userIdAdminList){
				if(userId == userIdAdmin)
					adminYN = true;
			}
		}
		/** ResCount*/
		responseCnt = ezQuestionService.resCount(request.getParameter("brdId"),request.getParameter("itemNo"));
		/** UserPollItem*/
		QstUserPollItemVO qstUserPollItemVO = new QstUserPollItemVO();
		qstUserPollItemVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		qstUserPollItemVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		qstUserPollItemVO=ezQuestionService.getUserPollItem(qstUserPollItemVO);
		
		/** updateReadCnt*/
		if(qstUserPollItemVO.getUserId() != userId){
			qstUserPollItemVO.setReadCnt(qstUserPollItemVO.getReadCnt() + 1);
			ezQuestionService.updateReadCnt(qstUserPollItemVO);
		}
		/** ReadDateItem*/
		int readDateCnt = ezQuestionService.getReadDateItem(qstUserPollItemVO,userId);
		/** updateReadDate*/
		Date sysDate=new Date();
		java.text.DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		if(readDateCnt > 0){
			ezQuestionService.updateReadDate(qstUserPollItemVO, formatter.format(sysDate), userId);
		/** insertItemRead*/
		}else{
			ezQuestionService.insertItemRead(loginVO, qstUserPollItemVO, formatter.format(sysDate));
		}
		
		/** QuestionForResponse*/
		List<QstVO> questionList = ezQuestionService.getQuestionForResponse(qstVO);

		Document doc = null;
		String strXML ="";
		if(questionList != null){
			int iQueCount = 0;
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			for(QstVO question : questionList){
				iQueCount++;
				arrAnswer.add(question.getAnswerType());
				sb.append("<ROW>");
				sb.append("<QST>");
				sb.append(egovMessageSource.getMessage("ezQuestion.t333"));
				sb.append(iQueCount + ":");
				sb.append(modifyData(question.getQuesContent()));
				sb.append(getAttachList(Integer.toString(question.getQuestionNo()), "0", question.getBrdId(), question.getItemNo()));
				sb.append("</QST>");
				sb.append("<BRD_ID>");
				sb.append(question.getBrdId());
				sb.append("</BRD_ID>");
				sb.append("<ITEM_NO>");
				sb.append(question.getItemNo());
				sb.append("</ITEM_NO>");
				sb.append("<QUESTION_NO>");
				sb.append(question.getQuestionNo());
				sb.append("</QUESTION_NO>");
				sb.append("<ANSWERTYPE>");
				sb.append(question.getAnswerType());
				sb.append("</ANSWERTYPE>");
				sb.append("<ANSWERVIEWTYPE>");
				sb.append(question.getAnswerViewType());
				sb.append("</ANSWERVIEWTYPE>");
				sb.append("<MULTISELECT>");
				sb.append(question.getMultiSelect());
				sb.append("</MULTISELECT>");
				sb.append("<QUES_SN>");
				sb.append(question.getQuesSn());
				sb.append("</QUES_SN>");
				sb.append("</ROW>");
			}
			sb.append("</DATA>");
			strXML = sb.toString();
System.out.println(strXML);
		}
		
		/** AnswerCnt*/
		
		/** AttachInfo*/
		
		/** 날짜계산*/
		boolean endPoll = false;
		if(formatter.parse(qstUserPollItemVO.getPollEndDate()).compareTo(sysDate)<0)
			endPoll = true;
		if(qstUserPermissionVO.getEndFlg().equals('1'))
			endPoll = true;
	 
		model.addAttribute("qstUserPollItemVO", qstUserPollItemVO);
		model.addAttribute("qstUserPermissionVO", qstUserPermissionVO);
		model.addAttribute("strXML",strXML);
		
		return "/ezQuestion/qstResponse";
	}
	
	public String modifyData(String strData) throws Exception{
		String strResult = "";
		strResult = strData.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
		       
		return strResult;
	}
	
	@SuppressWarnings("unused")
	public String getAttachList(String strQuestionNo, String strAnswer,int brdId, int itemNo) throws Exception{
		StringBuilder strResult = new StringBuilder();
        String strAttachName = "";
        String strAttachUrl = "";
        /** 쓰는곳이 업는 거 같음*/
        String strSAttachUrl = "";
        String strAttachNo = "";
        boolean bFirst = true;
        
        QstAttachVO qstAttachVO = new QstAttachVO();
        qstAttachVO.setBrdId(brdId);
        qstAttachVO.setItemNo(itemNo);
        qstAttachVO.setQuestionNo(Integer.parseInt(strQuestionNo));
        qstAttachVO.setAnswerNo(Integer.parseInt(strAnswer));
        List<QstAttachVO> qstAttachVOList = ezQuestionService.getAttachInfo(qstAttachVO);
        
        if(qstAttachVOList!=null){
	        for(QstAttachVO attachVO : qstAttachVOList){
	        	if (bFirst){
	        		if (strAnswer == "0"){
	        			strResult.append("</th></tr><tr><td bgcolor=\"#e4f1f9\" class=\"subtxt\" style=\"word-break:break-all;padding:5px\">");
	        			strResult.append("<table><tr>");
	        		}else{
	        			strResult.append("<br><table><tr>");
	        		}
	        		bFirst = false;
	        	}
	        	strAttachName = attachVO.getAttachName();
	        	strAttachUrl = attachVO.getAttachUrl();
	            strAttachNo = Integer.toString(attachVO.getAttachNo());
	
	            switch (attachVO.getAttachType()){
	            	case "1":
	            		strSAttachUrl = strAttachUrl.replace("/Upload_BoardSTD/Upload_Question/", "/Upload_BoardSTD/Upload_Question/");
	            		strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open('1','" + brdId + "','" + itemNo + "','" + strQuestionNo + "','" + strAnswer + "','" + strAttachNo + "')\"><img style='cursor:pointer' src=\"/myoffice/Common/ezCommon_InterFace.aspx?TYPE=QUESTION&BOARDID=" + brdId + "&ITEMID=" + itemNo + "&QSTNO=" + strQuestionNo + "&ANSNO=" + strAnswer + "&ATTID=" + strAttachNo + "\" width='47' height='31' align='absmiddle'></td>");
	                    break;
	            	case "2":
	            		strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open('2','" + brdId + "','" + itemNo + "','" + strQuestionNo + "','" + strAnswer + "','" + strAttachNo + "')\"><img src=\"/images/poll/sound.gif\" width=\"19\" height=\"17\" align=\"absmiddle\">" + strAttachName + "</td>");
	                    break;
	                case "3":
	                	break;
	                case "4":
	                	break;
	                case "5":
	                	strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open('3','" + brdId + "','" + itemNo + "','" + strQuestionNo + "','" + strAnswer + "','" + strAttachNo + "')\"><img src=\"/images/poll/video.gif\" width=\"21\" height=\"17\" align=\"absmiddle\">" + strAttachName + "</td>");
	                	break;
	                default:
	                	strResult.append("<td nowrap style=\"padding:5px\"><img src=\"/images/poll/link.gif\" width=\"26\" height=\"17\" align=\"absmiddle\"><a href=\"/myoffice/Common/ezCommon_InterFace.aspx?TYPE=QUESTION&BOARDID=" + brdId + "&ITEMID=" + itemNo + "&QSTNO=" + strQuestionNo + "&ANSNO=" + strAnswer + "&ATTID=" + strAttachNo + "\" target='_blink'>" + strAttachName + "</a></td>");
	                    break;
	            }
	        }
        }
        if(!bFirst){
        	strResult.append("<td style=\"padding:5px\">&nbsp;</td></tr></table>");
        }
        return strResult.toString();
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
	
	@RequestMapping(value="/ezQuestion/qstComplete.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstCompleteCross(@RequestBody String xmlDoc ,HttpServletRequest req,@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, QstCompleteVO qstCompleteVO) throws Exception  {
		Document doc = commonUtil.convertStringToDocument(xmlDoc);
		loginVO = commonUtil.userInfo(loginCookie);

		String pUserID = loginVO.getId();
		String pBrdID = "";
		String vItemID = "";
		
		if(req.getParameter("pBrdID") == null) {
			pBrdID = "5";
			vItemID = callGetItemSeq(pBrdID);
		}
		
		String pRtn = SaveQuestion(pBrdID, vItemID, doc, pUserID);
		
		/*if(!pRtn.equals("OK")) {
			DeleteQuestion(pBrdID, vItemID);
			pRtn = "ERROR";
		}*/

		String strXML = "<DATA>" + pRtn + "</DATA>";
		
		int brdId = Integer.parseInt(pBrdID);
		int itemNo = Integer.parseInt(vItemID);
		
		return strXML;
	}


	public String SaveQuestion(String pBrdID, String vItemID, Document doc, String pUserID) throws Exception {
		String pResult = "";
		
		int dataCount = 0;
		dataCount = ezQuestionService.getItemNoCnt(Integer.parseInt(pBrdID), Integer.parseInt(vItemID));
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("subject", doc.getElementsByTagName("SUBJECT").item(0).getTextContent());
		map.put("content", doc.getElementsByTagName("CONTENT").item(0).getTextContent());
		map.put("startdate", doc.getElementsByTagName("STARTDATE").item(0).getTextContent());
		map.put("enddate", doc.getElementsByTagName("ENDDATE").item(0).getTextContent());
		map.put("expiredate", doc.getElementsByTagName("EXPIREDATE").item(0).getTextContent());
		map.put("anonymity", doc.getElementsByTagName("ANONYMITY").item(0).getTextContent());
		map.put("openresult", doc.getElementsByTagName("EXPIREDATE").item(0).getTextContent());
		map.put("multiresponse", doc.getElementsByTagName("MULTIRESPONSE").item(0).getTextContent());
		map.put("importance", doc.getElementsByTagName("IMPORTANT").item(0).getTextContent());
		map.put("target", doc.getElementsByTagName("TARGET").item(0).getTextContent());
		map.put("brdId", pBrdID);
		map.put("itemNo", Integer.parseInt(vItemID));
		map.put("dataCount", dataCount);
		
		ezQuestionService.stepSave(pUserID, map);
		
		ezQuestionService.stepSave2(map);
		//대상범위
		if(doc.getElementsByTagName("TARGET").item(0).getTextContent().equals("1")) {
			
		}
		
		int qstCnt = doc.getElementsByTagName("QUESTION").item(0).getChildNodes().getLength();
		
		for(int i=0; i<qstCnt; i++) {
			
			String qstSubject = doc.getElementsByTagName("QUESTIONCONTENT").item(i).getTextContent();
			String answerType = doc.getElementsByTagName("ANSWERTYPE").item(i).getTextContent();
			String multiSelect = doc.getElementsByTagName("MULTISELECT").item(i).getTextContent();
			String selViewStart = doc.getElementsByTagName("SELVIEWSTART").item(i).getTextContent();
			String selViewEnd = doc.getElementsByTagName("SELVIEWEND").item(i).getTextContent();
			
			int v_quesNo = 1;

			v_quesNo = ezQuestionService.getQuestionNo(Integer.parseInt(pBrdID), Integer.parseInt(vItemID));
		
			if(v_quesNo == 0) {
				v_quesNo = 1;
			} else {
				v_quesNo = v_quesNo + 1;
			}
			
			QstCompleteVO qstCompleteVO = new QstCompleteVO();
			qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
			qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
			qstCompleteVO.setQuesNo(v_quesNo);
			qstCompleteVO.setQuesContent(qstSubject);
			qstCompleteVO.setAnswerType(Integer.parseInt(answerType));
			qstCompleteVO.setMultiSelect(multiSelect);
			ezQuestionService.insertQuestion(qstCompleteVO);
			
			if(doc.getElementsByTagName("ANSWER").item(0).getChildNodes().getLength() > 0) {
				int ansCnt = doc.getElementsByTagName("ANSWER").getLength();
				for(int iAns=0; iAns < ansCnt; iAns++ ) {
					qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
					qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
					qstCompleteVO.setQuesNo(v_quesNo);
					qstCompleteVO.setAnswerNo(iAns+1);
					qstCompleteVO.setAnswerContent(doc.getElementsByTagName("TITLE").item(iAns).getTextContent().replace("'", "''"));
					ezQuestionService.insertAnswerContent(qstCompleteVO);
				}
			}
		}
		
		QstCompleteVO qstCompleteVO = new QstCompleteVO();
		qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
		qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
		ezQuestionService.updatePollItem(qstCompleteVO);
		
		return pResult;
	}
	

	public void DeleteQuestion(String pBrdID, String vItemID) throws Exception {
		QstCompleteVO qstCompleteVO = new QstCompleteVO();
		qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
		qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
		ezQuestionService.deleteItem(qstCompleteVO);
	}
}
