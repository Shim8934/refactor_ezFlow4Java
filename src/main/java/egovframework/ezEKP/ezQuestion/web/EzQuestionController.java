package egovframework.ezEKP.ezQuestion.web;

import java.io.File;
import java.io.StringWriter;
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
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezQuestion.vo.QstAddVO;
import egovframework.ezEKP.ezQuestion.vo.QstAnswerVO;
import egovframework.ezEKP.ezQuestion.vo.QstAttachVO;
import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponsePersonVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponseVO;
import egovframework.ezEKP.ezQuestion.vo.QstStep1VO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzQuestionController extends EgovFileMngUtil {
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
	public String qstList(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		QstListVO qstListVO = new QstListVO();
		String brdId="5",title="",responseRange="",postDate="",pollEndDate="",lang="";
		String currPage="1";
		int pageSize=15;
		qstListVO.setUserId(loginVO.getId());
		
		if(request.getParameter("brdId")!=null)
			brdId = request.getParameter("brdId");
		if(request.getParameter("title")!=null)
			title = new String(request.getParameter("title").getBytes("ISO-8859-1"),"UTF-8");
		if(request.getParameter("responseRange")!=null)
			responseRange = request.getParameter("responseRange");
		if(request.getParameter("postDate")!=null)
			postDate = request.getParameter("postDate");
		if(request.getParameter("pollEndDate")!=null)
			pollEndDate = request.getParameter("pollEndDate");
		if(request.getParameter("lang")!=null)
			lang = request.getParameter("lang");
		if(request.getParameter("currPage")!=null)
			currPage = request.getParameter("currPage");
		
		qstListVO.setBrdId(Integer.parseInt(brdId));
		qstListVO.setTitle(title);
		qstListVO.setResponseRange(responseRange);
		qstListVO.setPostDate(postDate);
		qstListVO.setPollEndDate(pollEndDate);
		qstListVO.setLang(lang);
		qstListVO.setCurrPage(Integer.parseInt(currPage));
		qstListVO.setPageSize(pageSize);
		
		String receve = "brdId=" + qstListVO.getBrdId() +
                "&title=" + new String(qstListVO.getTitle()) +
                "&responseRange=" + qstListVO.getResponseRange() +
                "&postDate=" + qstListVO.getPostDate() +
                "&pollEndDate=" + qstListVO.getPollEndDate() +
                "&currPage=" + qstListVO.getCurrPage();
		
		qstListVO.setTotalCnt(ezQuestionService.getQstListCnt(qstListVO));
		if(qstListVO.getTotalPage()==0)
			qstListVO.setTotalPage((qstListVO.getTotalCnt()+qstListVO.getPageSize()-1)/qstListVO.getPageSize());
		List<QstListVO> list = ezQuestionService.getQstList(qstListVO);		
		StringBuilder strbuilder;
		for(QstListVO qst : list){
			if(qst.getReceve()==null){
				strbuilder = new StringBuilder();
				strbuilder.append(receve);
				strbuilder.append("&itemNo="+qst.getItemNo());
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
		model.addAttribute("receve", receve);
		
		return "/ezQuestion/qstList";
	}
	
	@RequestMapping(value="/ezQuestion/pollOpen.do")
	public void pollOpen(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,HttpServletResponse response) throws Exception{
		String receve = "brdId=" + request.getParameter("brdId") +
                "&itemNo=" + request.getParameter("itemNo") +
                "&title=" + new String(request.getParameter("title").getBytes("ISO-8859-1"),"UTF-8") +
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
		List<String> userIdAdminList = ezQuestionService.getUserIdAdmin(Integer.parseInt(request.getParameter("brdId")));
		if(userIdAdminList != null){
			for(String userIdAdmin : userIdAdminList){
				if(loginVO.getId().equals(userIdAdmin)){
					adminYN = "Y";
				}
			}
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
		String receve = "brdId=" + request.getParameter("brdId") +
                "&title=" + new String(request.getParameter("title").getBytes("ISO-8859-1"),"UTF-8") +
                "&responseRange=" + request.getParameter("responseRange") +
                "&postDate=" + request.getParameter("postDate") +
                "&pollEndDate=" + request.getParameter("pollEndDate") +
                "&currPage=" + request.getParameter("currPage");

		QstVO qstVO = new QstVO();
		qstVO.setBrdId(Integer.parseInt(request.getParameter("brdId")));
		qstVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		
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

		String strResult = "<SUBDATA>";
		Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
		Node data = doc.createElement("DATA");
		doc.appendChild(data);

		if(questionList != null){
			int iQueCount = 0;
			String strTagData = "";
			for(QstVO question : questionList){
				Node row = doc.createElement("ROW");
				Node qst = doc.createElement("QST");
				Node brdId = doc.createElement("BRD_ID");
				Node itemNo = doc.createElement("ITEM_NO");
				Node questionNo = doc.createElement("QUESTION_NO");
				Node answerType = doc.createElement("ANSWERTYPE");
				Node answerViewType = doc.createElement("ANSWERVIEWTYPE");
				Node multiSelect = doc.createElement("MULTISELECT");
				Node quesSn = doc.createElement("QUES_SN");

				qst.appendChild(doc.createTextNode(egovMessageSource.getMessage("ezQuestion.t333") + (iQueCount+1) + ":" + modifyData(question.getQuesContent()) + getAttachList(Integer.toString(question.getQuestionNo()), "0", question.getBrdId(), question.getItemNo())));
				brdId.appendChild(doc.createTextNode(Integer.toString(question.getBrdId())));
				itemNo.appendChild(doc.createTextNode(Integer.toString(question.getItemNo())));
				questionNo.appendChild(doc.createTextNode(Integer.toString(question.getQuestionNo())));
				answerType.appendChild(doc.createTextNode(Integer.toString(question.getAnswerType())));
				answerViewType.appendChild(doc.createTextNode(Integer.toString(question.getAnswerViewType())));
				multiSelect.appendChild(doc.createTextNode(question.getMultiSelect()));
				quesSn.appendChild(doc.createTextNode(Integer.toString(question.getQuesSn())));

				row.appendChild(qst);
				row.appendChild(brdId);
				row.appendChild(itemNo);
				row.appendChild(questionNo);
				row.appendChild(answerType);
				row.appendChild(answerViewType);
				row.appendChild(multiSelect);
				row.appendChild(quesSn);
				data.appendChild(row);
				if(question.getAnswerType() == 2){
					strTagData = "<tr>";
					strTagData +=	"<td style=\"word-break:break-all;padding:10px;\">";
                    strTagData +=		"<textarea style=\"Width:100%;height:85;\" id=\"txt" + question.getQuestionNo() + "\" name=\"txt" + question.getQuestionNo() + "\"></textarea></td>";
                    strTagData += "</tr>";
                    Element subRow = doc.createElement("SUBROW");
                    subRow.appendChild(doc.createTextNode(strTagData));
                    row.appendChild(subRow);
				}else if(question.getAnswerType() == 5){
                    strTagData = "<tr>";
                    strTagData += "	<td style=\"word-break:break-all;padding:10px;\">";
                    strTagData += "";
                    strTagData += "</tr>";
				}else{
					if(question.getAnswerType() == 4){
						 strTagData = "<tr>";
                         strTagData += "	<td style='word-break:break-all;padding:10px'>";
                         strTagData += "		<input type=\"text\" maxlength=\"500\" READONLY style=\"Width:760\" id=\"txt" + question.getQuestionNo() + "\" name=\"txt" + question.getQuestionNo() + "\"></td>";
                         strTagData += "</tr>";
                         Element subRow = doc.createElement("SUBROW");
                         subRow.appendChild(doc.createTextNode(strTagData));
                         row.appendChild(subRow);
					}else{
						Element subRow = doc.createElement("SUBROW");
	                    subRow.appendChild(doc.createTextNode(""));
	                    row.appendChild(subRow);
					}
					dataSubProcess(question.getBrdId(), question.getItemNo(), question.getQuestionNo(), question.getAnswerType(), question.getMultiSelect(), row, doc);
				}
				strResult += "</SUBDATA>";
			}
		}
		/** XML to String */
		DOMSource domSource = new DOMSource(doc);
		StringWriter writer = new StringWriter();
		StreamResult result = new StreamResult(writer);
		TransformerFactory tf = TransformerFactory.newInstance();
		Transformer transformer = tf.newTransformer();
		transformer.transform(domSource, result);
System.out.println(writer.toString());
		model.addAttribute("qstUserPollItemVO", qstUserPollItemVO);
		model.addAttribute("qstUserPermissionVO", qstUserPermissionVO);
		model.addAttribute("xmlResult", writer.toString());
		model.addAttribute("receve", receve);
		
		return "/ezQuestion/qstResponse";
	}
	
	@SuppressWarnings("unused")
	public void dataSubProcess(int brdId, int itemNo, int qstNo, int answerType, String multiSelect, Node row, Document doc) throws Exception{
		Node snewRow = doc.createElement("ITEM");
        int iCount = 0, iAddCount = 0;
        if (answerType == 5){
        	List<QstAnswerVO> qstAnswerAnswerList = ezQuestionService.getAnswerAnswerCnt(brdId, itemNo, qstNo);
        	if(qstAnswerAnswerList != null){
        		//결과 받아서 XMl로 변환 -> 표형식 생성안되서 나중에 
        	}
        }
        List<QstAnswerVO> qstAnswerList = ezQuestionService.getAnswerCnt(brdId, itemNo, qstNo);
        if(qstAnswerList != null){
        	for(QstAnswerVO qstAnswer : qstAnswerList){
        		Node itemNode = null;
        		Node iValueNode = null;
        		String strTagData = "";
        		iCount++;
        		
        		if(answerType !=  5){
        			itemNode = doc.createElement("TAG" + Integer.toString(iCount));
        		}else{
        			itemNode = doc.createElement("TAG");
        		}
        		switch(answerType){
        		case 1:
        			if (multiSelect.equals("1")){
                        strTagData = "<input type=\"checkbox\" name=\"chk" + qstNo + "_" + Integer.toString(iCount) + "\" value=\"0\">" + modifyData(qstAnswer.getAnswerContent());
                        strTagData += getAttachList(Integer.toString(qstNo), Integer.toString(qstAnswer.getAnswerNo()), qstAnswer.getBrdId(), qstAnswer.getItemNo());
                        iValueNode = doc.createTextNode(strTagData);
                    }else{
                    	 strTagData = "<input type=\"Radio\" name=\"rdo" + qstNo + "\" value=\"" + Integer.toString(iCount) + "\">" + modifyData(qstAnswer.getAnswerContent());
                    	 strTagData += getAttachList(Integer.toString(qstNo), Integer.toString(qstAnswer.getAnswerNo()), qstAnswer.getBrdId(), qstAnswer.getItemNo());
                         iValueNode = doc.createTextNode(strTagData);
                    }
        			itemNode.appendChild(iValueNode);
        			snewRow.appendChild(itemNode);
        			iValueNode = null;
        			itemNode = null;
        			break;
        		case 3:
        			int rCount = 0;
					String ansContent = modifyData(qstAnswer.getAnswerContent());
					
					String[] ArryContent = ansContent.split("-");
					rCount = Integer.parseInt(ArryContent[1]) - Integer.parseInt(ArryContent[0]);
					strTagData = "<select name='sel " + qstNo + "'>";
					for (int j = 0; j < rCount; j++){
					    strTagData += "<option>" + Integer.toString(j) + "</option>";
					}
					strTagData += "</select>";
					iValueNode = doc.createTextNode(strTagData);
					itemNode.appendChild(iValueNode);
					snewRow.appendChild(itemNode);
					iValueNode = null;
					itemNode = null;
					break;
        		case 4:
        			strTagData = "<input type=\"checkbox\" onclick=\"seqResponse(" + Integer.toString(iCount - 1) + ",\"frmResponse.chk" + qstNo + "\", \"frmResponse.txt" + qstNo + "\")\" name=\"chk" + qstNo + "\" value=\"" + qstAnswer.getQuestionNo() + "\">" + modifyData(qstAnswer.getAnswerContent());
                    strTagData += getAttachList(Integer.toString(qstNo), Integer.toString(qstAnswer.getAnswerNo()), qstAnswer.getBrdId(), qstAnswer.getItemNo());
                    String strEtcTag = "";
                    iValueNode = doc.createTextNode(strTagData);
                    strTagData = "";
                    itemNode.appendChild(iValueNode);
                    snewRow.appendChild(itemNode);
                    iValueNode = null;
                    itemNode = null;
                    break;
        		case 5:
        			strTagData =  modifyData(qstAnswer.getAnswerContent());
                    iValueNode = doc.createTextNode(strTagData);
                    itemNode.appendChild(iValueNode);
                    snewRow.appendChild(itemNode);
                    iValueNode = null;
                    itemNode = null;
                    break;
        		}
        	}
        	Node attr = doc.createAttribute("count");
        	attr.setNodeValue(Integer.toString(iCount));
        	row.appendChild(snewRow);
        	snewRow = null;
        }
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
	            	strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open(\"1\",\"" + brdId + "\",\"" + itemNo + "\",\"" + strQuestionNo + "\",\"" + strAnswer + "\",\"" + strAttachNo + "\")\"><img style=\"cursor:pointer\" src=\"/myoffice/Common/ezCommon_InterFace.aspx?TYPE=QUESTION&BOARDID=" + brdId + "&ITEMID=" + itemNo + "&QSTNO=" + strQuestionNo + "&ANSNO=" + strAnswer + "&ATTID=" + strAttachNo + "\" width=\"47\" height=\"31\" align=\"absmiddle\"></td>");
	            	break;
	            case "2":
	            	strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open(\"2\",\"" + brdId + "\",\"" + itemNo + "\",\"" + strQuestionNo + "\",\"" + strAnswer + "\",\"" + strAttachNo + "\")\"><img src=\"/images/poll/sound.gif\" width=\"19\" height=\"17\" align=\"absmiddle\">" + strAttachName + "</td>");
	            	break;
	            case "3":
	            	break;
	            case "4":
	            	break;
	            case "5":
	            	strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open(\"3\",\"" + brdId + "\",\"" + itemNo + "\",\"" + strQuestionNo + "\",\"" + strAnswer + "\",\"" + strAttachNo + "\")\"><img src=\"/images/poll/video.gif\" width=\"21\" height=\"17\" align=\"absmiddle\">" + strAttachName + "</td>");
	            	break;
	            default:
	            	strResult.append("<td nowrap style=\"padding:5px\"><img src=\"/images/poll/link.gif\" width=\"26\" height=\"17\" align=\"absmiddle\"><a href=\"/myoffice/Common/ezCommon_InterFace.aspx?TYPE=QUESTION&BOARDID=" + brdId + "&ITEMID=" + itemNo + "&QSTNO=" + strQuestionNo + "&ANSNO=" + strAnswer + "&ATTID=" + strAttachNo + "\" target=\"_blink\">" + strAttachName + "</a></td>");
	            	break;
	            }
	        }
        }
        if(!bFirst){
        	strResult.append("<td style=\"padding:5px\">&nbsp;</td></tr></table>");
        }
        return strResult.toString();
	}
	
	@RequestMapping(value="/ezQuestion/qstResponseOk.do")
	public void qstResponseOk(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,HttpServletResponse response) throws Exception{        
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brdId = "5", itemNo = "", responseUserIp = "", vPermission = "", vResponseRange = "", receve = "", currPage = "1";
		String userId = "", userName = "", email = "", deptId = "", depart = "", position = "", jikGub = "", gender = "1", age = "29";
		String userName2 = "", depart2 = "", position2 = "", jikGub2 = "";
		String tableAnswer = "";
        int eleCnt = 0;
        int tempTableAnswerCnt = 0;
        
        if(request.getParameter("hidEleCnt")!=null);
        	eleCnt = Integer.parseInt(request.getParameter("hidEleCnt"));
		if(request.getParameter("brdId")!=null)
			brdId = request.getParameter("brdId");
		if(request.getParameter("itemNo")!=null)
			itemNo = request.getParameter("itemNo");
		if(request.getParameter("tableAnswer")!=null)
			tableAnswer = request.getParameter("tableAnswer");
		responseUserIp = request.getRemoteAddr();
		if(request.getParameter("receve")!=null)
			receve = request.getParameter("receve").replace("&amp;", "&");
		
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		qstUserPermissionVO.setBrdId(Integer.parseInt(brdId));
		qstUserPermissionVO.setItemNo(Integer.parseInt(itemNo));
		
		/** EZSP_GETRESPONSERANGE*/
		qstUserPermissionVO = ezQuestionService.getResponseRange(qstUserPermissionVO);
		vPermission = qstUserPermissionVO.getPublicFlg();
		vResponseRange = qstUserPermissionVO.getResponseRange();
		
		if (vPermission != "1"){
			userId = loginVO.getId();
			userName = loginVO.getDisplayName1();
			email = loginVO.getEmail();
			deptId = loginVO.getDeptID();
			depart = loginVO.getDeptName1();
			position = loginVO.getTitle1();
			jikGub = "";
			gender = "1";
			age = "29";
			userName2 = loginVO.getDisplayName2();
			depart2 = loginVO.getDeptName2();
			position2 = loginVO.getTitle2();
			jikGub2 = "";
		}else{
			userId = loginVO.getId();
			userName = "";
			email = "";
			deptId = "";
			depart = "";
			position = "";
			jikGub = "";
			gender = "";
			age = "";
			userName2 = "";
			depart2 = "";
			position2 = "";
			jikGub2 = "";
		}

		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		if (userId == ""){
			response.getWriter().write("<script language='javascript'>\n");
			response.getWriter().write("	alert('" + egovMessageSource.getMessage("t360") + "');\n");
			response.getWriter().write("	history.back();\n");
			response.getWriter().write("</script>\n");
			response.getWriter().flush();
        }
		QstResponseVO qstResponseVO = new QstResponseVO();
		qstResponseVO.setBrdId(Integer.parseInt(brdId));
		qstResponseVO.setItemNo(Integer.parseInt(itemNo));
		qstResponseVO.setResponseUserId(userId);
		qstResponseVO.setResponseUserName(userName);
		qstResponseVO.setResponseUserName2(userName2);
		qstResponseVO.setResponseUserEmail(email);
		qstResponseVO.setResponseUserDeptId(deptId);
		qstResponseVO.setResponseUserDeptName(depart);
		qstResponseVO.setResponseUserDeptName2(depart2);
		qstResponseVO.setResponseUserPosition(position);
		qstResponseVO.setResponseUserPosition2(position2);
		qstResponseVO.setResponseUserJikgub(jikGub);
		qstResponseVO.setResponseUserJikgub2(jikGub2);
		qstResponseVO.setResponseUserGender(gender);
		qstResponseVO.setResponseUserAge(Integer.parseInt(age));
		qstResponseVO.setResponseDate(EgovDateUtil.getToday());
		qstResponseVO.setResponseUserIp(responseUserIp);
		/** EZSP_GETQUESTIONFORRESPONSE*/
		String question_no = "", quescontent = "", multiselect = "", answertype = "";
		QstVO questionVO = new QstVO();
		questionVO.setBrdId(Integer.parseInt(brdId));
		questionVO.setItemNo(Integer.parseInt(itemNo));
		
		List<QstVO> qstVOList = ezQuestionService.getQuestionForResponse(questionVO);
		for(QstVO qstVO : qstVOList){
			subDataProcess(qstVO.getQuestionNo(), qstVO.getQuesContent(), qstVO.getMultiSelect(), qstVO.getAnswerType(), Integer.parseInt(brdId), Integer.parseInt(itemNo), request, qstResponseVO, response);
		}
		/** EZSP_GETRESPONSEPERSON*/
		QstResponsePersonVO qstResponsePersonVO = new QstResponsePersonVO();
		qstResponsePersonVO.setBrdId(Integer.parseInt(brdId));
		qstResponsePersonVO.setItemNo(Integer.parseInt(itemNo));
		qstResponsePersonVO.setUserId(userId);

		String selUserId="", selResponseDate="";
		if(ezQuestionService.getResponsePerson(qstResponsePersonVO)!=null){
			selUserId = qstResponsePersonVO.getUserId();
			selResponseDate = qstResponsePersonVO.getResponseDate();
			
			if(vResponseRange == "1"){
				if(selResponseDate==""){
					ezQuestionService.updateResponsePerson(qstResponsePersonVO);
				}
			}
		}
		ezQuestionService.updateResCnt(Integer.parseInt(brdId), Integer.parseInt(itemNo));

		response.getWriter().write("<script language='javascript'>");
		response.getWriter().write("window.location.href='/ezQuestion/qstList.do?" + receve + "';");
		response.getWriter().write("</script>");
		response.getWriter().flush();
	}
	
	public void subDataProcess(int questionNo, String quesContent, String multiSelect, int answerType, int brdId, int itemNo,HttpServletRequest request, QstResponseVO qstResponseVO, HttpServletResponse response) throws Exception {
		String tmp = "", receve ="";
        int ansRCnt = 0, tempTableAnswerCnt = 0;
        String responseNo = "1", strResponseInsert = "", answerSubjectivity = "";
		if(request.getParameter("receve")!=null)
			receve  = request.getParameter("receve").replace("&amp;", "&");
        
        Integer responseMaxNo = ezQuestionService.getResponseMaxNo(brdId, itemNo, questionNo);
        if(responseMaxNo!=null){
        	responseNo = responseMaxNo.toString();
        }else{
        	responseNo = "1";
        }
        
        qstResponseVO.setQuestionNo(questionNo);
		qstResponseVO.setResponseNo(Integer.parseInt(responseNo));
        if(answerType == 1){
        	/** EZSP_GETANSCNT*/
	        QstAnswerVO answerVO = new QstAnswerVO();
	        answerVO.setBrdId(brdId);
	        answerVO.setItemNo(itemNo);
	        answerVO.setQuestionNo(questionNo);
	        Integer ansCnt = ezQuestionService.getAnsCnt(answerVO);
	        if(ansCnt != null){
	        	ansRCnt = ansCnt;
	        }else{
	        	ansRCnt = 0;
	        }
			/** EZSP_INSERTRESPONSE*/
			List<String> multiQ = null;
			
			if(multiSelect == "1"){
				int iDataCount = 0;
				String strData = "";
				for(int j=0; j<ansRCnt; j++){
					iDataCount ++;
					tmp = "chk" + questionNo + "_" + Integer.toString(iDataCount);
					
					multiQ = new ArrayList<String>();
					multiQ.add(request.getParameter(tmp.trim()));
					
					if(multiQ.get(j) == "1"){
						qstResponseVO.setAnswerObjectivity(iDataCount);
						ezQuestionService.insertResponse(qstResponseVO);
						responseNo = Integer.toString(Integer.parseInt(responseNo)+1); 
					}
				}
				multiQ.clear();
				multiQ = null;
			}else{
				tmp = "rdo" + questionNo;
				String SingleQ = request.getParameter(tmp);
				qstResponseVO.setAnswerObjectivity(Integer.parseInt(SingleQ));
				ezQuestionService.insertResponse(qstResponseVO);
			}
        }else if(answerType == 2){
        	/** EZSP_INSERTRESPONSE2*/
        	tmp = "txt" + questionNo;
        	answerSubjectivity = request.getParameter(tmp).trim();
        	qstResponseVO.setAnswerSubjectivity(answerSubjectivity);
        	ezQuestionService.insertResponse2(qstResponseVO);    	
        }else if(answerType == 4){
        	/** EZSP_INSERTRESPONSE2*/
        	tmp = "txt" + questionNo;
        	answerSubjectivity = request.getParameter(tmp);
        	qstResponseVO.setAnswerSubjectivity(answerSubjectivity);
        	ezQuestionService.insertResponse2(qstResponseVO);
        }else if(answerType == 5){
        	 /** EZSP_GETANSCNT*/
	        QstAnswerVO answerVO = new QstAnswerVO();
	        answerVO.setBrdId(brdId);
	        answerVO.setItemNo(itemNo);
	        answerVO.setQuestionNo(questionNo);
	        Integer ansCnt = ezQuestionService.getAnsCnt(answerVO);
	        if(ansCnt != null){
	        	ansRCnt = ansCnt;
	        }else{
	        	ansRCnt = 0;
	        }
	        String tempTableAnswer = "";
	        for(; tempTableAnswerCnt < ansRCnt; tempTableAnswerCnt++){
	        	tempTableAnswer += tempTableAnswer.split(";");
	        }
	        qstResponseVO.setAnswerSubjectivity(tempTableAnswer);
	        ezQuestionService.insertResponse2(qstResponseVO);
        }else{
        	tmp = "sel" + questionNo;
        	String answerViewSelect = request.getParameter(tmp);
        	qstResponseVO.setAnswerObjectivity(Integer.parseInt(answerViewSelect));
        	ezQuestionService.insertResponse(qstResponseVO);
        }
        response.getWriter().write("<script language='javascript'>\n");
        response.getWriter().write("window.location.href = '/ezQuestion/qstList.do?" + receve + "'\n");
        response.getWriter().write("</script>\n");
        response.getWriter().flush();
	}

	@RequestMapping(value="/ezQuestion/qstResult.do")
	public String qstResult(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String userId = loginVO.getId();
		String brdId="5", brdNm="", itemNo="", title="", responseRange="", postDate="", pollEndDate="", currPage="";
		String strItemRead = "", StrReadInsert = "", StrPermission = "", publicResultFlg = "", publicFlg = "", multiResponseFlg = "", endFlg = "";
		int readCnt=0, resCnt=0;
		int iCount = 0, ResponseCnt = 0, percent = 0;
		boolean bDisplay=false;
		
		if(request.getParameter("brdId")!=null)
			brdId = request.getParameter("brdId");
		if(request.getParameter("brdNm")!=null)
			brdNm = request.getParameter("brdNm");
		if(request.getParameter("itemNo")!=null)
			itemNo = request.getParameter("itemNo");
		if(request.getParameter("title")!=null)
			title = new String(request.getParameter("title").getBytes("ISO-8859-1"),"UTF-8");
		if(request.getParameter("responseRange")!=null)
			responseRange = request.getParameter("responseRange");
		if(request.getParameter("postDate")!=null)
			postDate = request.getParameter("postDate");
		if(request.getParameter("pollEndDate")!=null)
			pollEndDate = request.getParameter("pollEndDate");
		if(request.getParameter("currPage")!=null)
			currPage = request.getParameter("currPage");
		
		String receve = "brdId=" + request.getParameter("brdId") +
				"%itemNo=" + request.getParameter("itemNo") +
                "&title=" + new String(request.getParameter("title").getBytes("ISO-8859-1"),"UTF-8") +
                "&responseRange=" + request.getParameter("responseRange") +
                "&postDate=" + request.getParameter("postDate") +
                "&pollEndDate=" + request.getParameter("pollEndDate") +
                "&currPage=" + request.getParameter("currPage");
		
		/** EZSP_GETUSERIDADMIN*/
		boolean adminYN = false;
		List<String> userIdAdminList = ezQuestionService.getUserIdAdmin(Integer.parseInt(request.getParameter("brdId")));
		if(userIdAdminList != null){
			for(String userIdAdmin : userIdAdminList){
				if(userId.equals(userIdAdmin)){
					adminYN = true;
				}
			}
		}
		/** EZSP_RESCOUNT*/
		resCnt = ezQuestionService.resCount(brdId, itemNo);
		
		/** EZSP_GETUSERPOLLITEM*/
		QstUserPollItemVO qstUserPollItemVO = new QstUserPollItemVO();
		qstUserPollItemVO.setBrdId(Integer.parseInt(brdId));
		qstUserPollItemVO.setItemNo(Integer.parseInt(itemNo));
		qstUserPollItemVO = ezQuestionService.getUserPollItem(qstUserPollItemVO);
		
		/** EZSP_UPDATEREADCNT*/
		if (qstUserPollItemVO.getUserId() != userId){
            readCnt = readCnt + 1;
            ezQuestionService.updateReadCnt(qstUserPollItemVO);
		}
		/*
		*//** EZSP_GETREADDATEITEMFORRESULT*//*
		String readDate = ezQuestionService.getReadDateItemForResult(qstUserPollItemVO, userId);
		*//** EZSP_UPDATEREADDATE*//*
		if(readDate != null){
			ezQuestionService.updateReadDate(qstUserPollItemVO, readDate, userId);
		}else{
			ezQuestionService.insertItemRead(loginVO, qstUserPollItemVO, readDate);
		}
		*/
		/** EZSP_GETUSERPERMISSION*/
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		qstUserPermissionVO.setBrdId(Integer.parseInt(brdId));
		qstUserPermissionVO.setItemNo(Integer.parseInt(itemNo));
		qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
		
		publicResultFlg = qstUserPermissionVO.getPublicResultFlg();
		publicFlg = qstUserPermissionVO.getPublicFlg();
		multiResponseFlg = qstUserPermissionVO.getMultiResponseFlg();
		endFlg = qstUserPermissionVO.getEndFlg();
		responseRange = qstUserPermissionVO.getResponseRange();
		
		 boolean bPublic;
         if (publicFlg == "1"){
             bPublic = true;
         }else{
             bPublic = false;
         }
         
//         dataProcessMainData(brdId, itemNo);
//         dataProcess(bPublic);
         
         
         
		model.addAttribute("receve", receve);
		return "/ezQuestion/qstResult";
	}
	public void dataprocessMainData(String brdId, String itemNo){
		/** EZSP_GETQUESTIONFORRESPONSE*/
		QstVO qstVO = new QstVO();
		qstVO.setBrdId(Integer.parseInt(brdId));
		qstVO.setItemNo(Integer.parseInt(itemNo));
		/** db.Fill(ds, "QST");*/
//		List<QstVO> qstVOList = ezQuestionService.getQuestionForResponse(qstVO);
		
		
	}
	
	public void DataProcess(boolean bPublic){
		
	}
	
	public void dataProcessAns(String strNo){
		
	}
	
	public int getAnswerPerson(Document xmlDoc, int iAnsCount, int TrOrder){
		return 0;
	}
	
	public int defaultResponseCount(String strNo, String strContent, String strSel, String strType){
		return 0;
	}
	
	public int responseCount(String strNo, String strContent, String strSel, String strType, int iAnsCnt){
		return 0;	
	}
	
	public String strAnsSQL(){
		return "";
	}
	
	public void dataProcessType1(String strNo, String strContent, String strSel, String strType, int iDataCount, int ipercent){
		
	}

	public void dataProcessType2(String strNo, String strContent, String strSel, String strType, int iDataCount, int ipercent){
		
	}
	
	public void dataProcessType3(String strNo, String strContent, String strSel, String strType, int iDataCount, int ipercent, boolean bPublic){
	
	}
	
	public void dataProcessType4(String strNo, String strContent, String strSel, String strType, int iDataCount, int ipercent){
		 
	}

	public void dataProcessType5(String strNo, String strContent, String strSel, String strType, int iDataCount, int ipercent){
		
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
		pStep1DataXML.append("<ANONYMITY>" + req.getParameter("hidAnonymity")+"</ANONYMITY>");
		pStep1DataXML.append("<OPENRESULT>" + req.getParameter("hidOpenResult")+"</OPENRESULT>");
		pStep1DataXML.append("<MULTIRESPONSE>" + req.getParameter("hidMultiResponse")+"</MULTIRESPONSE>");
		pStep1DataXML.append("<IMPORTANT>" + req.getParameter("importance")+"</IMPORTANT>");
		pStep1DataXML.append("<TARGET>" + req.getParameter("hidTarget")+"</TARGET>");
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
	public String qstStep2QuestionAdd(HttpServletRequest req,Model model, QstAddVO questionAddVO) throws Exception {
		String brdId = "";
		String itemId = "";
		String pMode = "";
		String pQstTitle = "", pAnswerType, pMultiSel = "";
		String pSelectOption = "";
		String pEditIndex;
		String pQstAnsInfo = "";
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

		if(req.getParameter("DataXML") != null) {
			pMode = "EDIT";
			pDataXML = req.getParameter("DataXML").trim().replace("&lt;", "<").replace("&gt;", ">");
			Document doc = commonUtil.convertStringToDocument(pDataXML);
System.out.println(doc.getElementsByTagName("ANSWERTYPE").item(0).getTextContent());
			pQstTitle = doc.getElementsByTagName("QUESTIONCONTENT").item(0).getTextContent();
			
			//첨부
			if(doc.getElementsByTagName("ATTACH").getLength() > 0) {
				if(doc.getElementsByTagName("ATTACH").item(0).getChildNodes() != null) {
					pQstAnsInfo = doc.getElementsByTagName("ATTACH").item(0).getTextContent();
					
					int pAttachCnt = doc.getElementsByTagName("ROW").getLength();
					for(int i=0; i<pAttachCnt; i++) {
						if(pQstAttach != "") {
							pQstAttach += ";";
						}
						pQstAttach += doc.getElementsByTagName("TITLE").item(i).getTextContent();
					}
				}
			}
			pAnswerType = doc.getElementsByTagName("ANSWERTYPE").item(0).getTextContent();
			
			if(doc.getElementsByTagName("MULTISELECT").item(0).getTextContent().equals("1")) {
				pMultiSel = "true";
			} else {
				pMultiSel = "false";
			}
			if(!pAnswerType.equals("2")) {
				if(doc.getElementsByTagName("ANSWER") != null) {
					int pCnt = doc.getElementsByTagName("ANSWER").getLength();
					
					for(int i=0; i<pCnt; i++) {
						pSelectOption += "<option value=\"" +doc.getElementsByTagName("TITLE").item(0).getTextContent() + "\" ";
						if(doc.getElementsByTagName("ATTACH").getLength() > 0) {
							pSelectOption += "AnsInfo=\"" + doc.getElementsByTagName("ATTACH").item(0).getTextContent() + "\">";
						} else {
							pSelectOption += ">";
						}
						pSelectOption += String.valueOf(i + 1) + ". " + doc.getElementsByTagName("TITLE").item(0).getTextContent() + "</option>";
					}
				}
			}
			if(req.getParameter("DataIndex") != null) {
				pEditIndex = String.valueOf(req.getParameter("dataIndex"));
			}
		}
		
		questionAddVO.setpMultiSel(pMultiSel);
		questionAddVO.setpSelectOption(pSelectOption);
		questionAddVO.setQuestionContent(pQstTitle);
		questionAddVO.setpQstAnsInfo(pQstAnsInfo);
		questionAddVO.setpQstAttach(pQstAttach);
		model.addAttribute("questionAddVO",questionAddVO);
		
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
			
			if(doc.getElementsByTagName("ATTACH").getLength() > 0) {
				int qstAttachCnt = doc.getElementsByTagName("ATTACH").item(0).getChildNodes().getLength();
				for(int qa=0; qa < qstAttachCnt; qa++) {
					String attachType = doc.getElementsByTagName("TYPE").item(qa).getTextContent();
					String tmpAttachUrl = doc.getElementsByTagName("HREF").item(qa).getTextContent();
					
					if(attachType == "3" || attachType == "4" || attachType == "6" || attachType == "7") {
						
					}
					qstCompleteVO.setAnswerNo(0);
					qstCompleteVO.setAttachNo(qa);
					qstCompleteVO.setAttachName(doc.getElementsByTagName("TITLE").item(qa).getTextContent());
					qstCompleteVO.setAttachURL(tmpAttachUrl);
					qstCompleteVO.setAttachType(attachType);
					ezQuestionService.pollSaveAttach(qstCompleteVO);
				}
			}
			
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
	
	@RequestMapping(value="/ezQuestion/qstAttachNonActX.do")
	public String qstAttachNonActX(HttpServletRequest req, Model model) {
		String idName = "";
		String attachInfo = "";
		String attachType = "";
		String attachMode = "";
		String attachModeIndex = "";
		
		if(req.getParameter("id_name") != null) {
			idName = String.valueOf(req.getParameter("id_name"));
		}
		
		if(req.getParameter("m_AttachInfo") != null) {
			attachInfo = String.valueOf(req.getParameter("m_AttachInfo"));
		}
		
		if(req.getParameter("m_AttachType") != null) {
			attachType = String.valueOf(req.getParameter("m_AttachType"));
		}
		
		if(req.getParameter("m_AttachMode") != null) {
			attachMode = String.valueOf(req.getParameter("m_AttachMode"));
		}
		
		if(req.getParameter("m_AttachModIndex") != null) {
			attachModeIndex = String.valueOf(req.getParameter("m_AttachModIndex"));
		}
System.out.println("idName:"+idName);		
		model.addAttribute("idName", idName);
		model.addAttribute("attachInfo", attachInfo);
		model.addAttribute("attachType", attachType);
		model.addAttribute("attachMode", attachMode);
		model.addAttribute("attachModeIndex", attachModeIndex);
		
		return "/ezQuestion/qstAttachNonActX";
	}
	
	@RequestMapping(value="/ezQuestion/attachFileNonActX.do")
	public String attachFileNonActXDad(MultipartHttpServletRequest req,Model model) throws Exception {
		String pFilePath = "";
		String type = "";
		String mode = "";
		if(req.getParameter("QstType") != null) {
			type = String.valueOf(req.getParameter("QstType"));
		} 
		if(req.getParameter("mode") != null) {
			type = String.valueOf(req.getParameter("mode"));
		}
		String pFileName = "";
		MultipartFile file = req.getFile("cmuds");
		if(file != null) {
			pFileName = req.getFile("cmuds").getOriginalFilename();
			pFileName = pFileName.replace("+", "%2b");
			pFileName = pFileName.replace(";", "%3b");
			
			String pDirPath = config.getProperty("upload_board.UPLOADQUESTION");
			String qDirPath = req.getServletContext().getRealPath("");

			File temp = new File(qDirPath);
			if(!temp.exists()) {
				temp.mkdirs();
			}
			
			String fileSize = String.valueOf(req.getFile("cmuds").getSize());
			String newFileName = pFileName;
			
			if(type == "1") {
				
			}
			pFilePath = "/Upload_BoardSTD/Upload_Question/"+newFileName;
			
			writeUploadedFile(file, pFileName, qDirPath+pDirPath);
			
			model.addAttribute("pFilePath", pFilePath);
			model.addAttribute("type", type);
			model.addAttribute("mode", mode);
			model.addAttribute("pFileName", pFileName);
			model.addAttribute("pDirPath", pDirPath);
			model.addAttribute("qDirPath", qDirPath);
			model.addAttribute("fileSize", fileSize);
			
		}
		return "/ezQuestion/qstAttachFile";
	}
	
}
