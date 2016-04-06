package egovframework.ezEKP.ezQuestion.web;

import java.io.File;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
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
import org.w3c.dom.CDATASection;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezQuestion.vo.QstAddVO;
import egovframework.ezEKP.ezQuestion.vo.QstAnswerVO;
import egovframework.ezEKP.ezQuestion.vo.QstAttachVO;
import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstRangeSelectVO;
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
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;

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
			title = request.getParameter("title");
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
		String userIdAdmin = ezQuestionService.getUserIdAdmin(Integer.parseInt(request.getParameter("brdId")));

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
				if(userIdAdmin != null){
					if(userId == userIdAdmin)
						adminYN = true;
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
				if(userIdAdmin != null){
					if(userId == userIdAdmin)
						adminYN = true;
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
	
	@RequestMapping(value="/ezQuestion/qstCallUsersPollStatus.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qstCallUsersPollStatus(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brdId ="", itemNo=""; 
		boolean endPoll = false;
		String endPollYN="";
		String responseYN="";
		String resultOpenYN="";
		String multiResYN="";
		String writeYN="";
		String adminYN="";
		int responseCnt=0;
		
		if (request.getParameter("brdId") != null)
            brdId = request.getParameter("brdId");
        if (request.getParameter("itemNo") != null)
            itemNo = request.getParameter("itemNo");
		
		
		QstUserPollItemVO qstUserPollItemVO = new QstUserPollItemVO();
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		
		adminYN = "N";
		String userIdAdmin = ezQuestionService.getUserIdAdmin(Integer.parseInt(brdId));
		if(userIdAdmin != null){
			if(loginVO.getId().equals(userIdAdmin)){
				adminYN = "Y";
			}
		}
		if(loginVO.getRollInfo().toUpperCase().indexOf("C=1") > -1 || loginVO.getRollInfo().toUpperCase().indexOf("K=1") > -1 || loginVO.getRollInfo().toUpperCase().indexOf("I=1") > -1){ 
			adminYN = "Y";
		}
		
		qstUserPollItemVO.setBrdId(Integer.parseInt(brdId));
		qstUserPollItemVO.setItemNo(Integer.parseInt(itemNo));
		qstUserPollItemVO = ezQuestionService.getUserPollItem(qstUserPollItemVO);
		
		qstUserPermissionVO.setBrdId(Integer.parseInt(brdId));
		qstUserPermissionVO.setItemNo(Integer.parseInt(itemNo));
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
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String userId = loginVO.getId();
		boolean multiResponseOK = false;
		int responseCnt = 0;
	
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
		String userIdAdmin = ezQuestionService.getUserIdAdmin(Integer.parseInt(request.getParameter("brdId")));
		boolean adminYN = false;
		if(userIdAdmin != null){
			if(userId == userIdAdmin)
				adminYN = true;
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
                         strTagData += "	<td style=\"word-break:break-all;padding:10px\">";
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

		model.addAttribute("qstUserPollItemVO", qstUserPollItemVO);
		model.addAttribute("qstUserPermissionVO", qstUserPermissionVO);
		model.addAttribute("xmlResult", commonUtil.convertDocumentToString(doc));
		model.addAttribute("receve", receve);
		
		return "/ezQuestion/qstResponse";
	}
	
	public void dataSubProcess(int brdId, int itemNo, int qstNo, int answerType, String multiSelect, Node row, Document doc) throws Exception{
		Node snewRow = doc.createElement("ITEM");
        int iCount = 0;
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
        			strTagData = "<input type=\"checkbox\" onclick=\"seqResponse(" + Integer.toString(iCount - 1) + ",frmResponse.chk" + qstNo + ", frmResponse.txt" + qstNo + ")\" name=\"chk" + qstNo + "\" value=\"" + qstAnswer.getAnswerNo() + "\">" + modifyData(qstAnswer.getAnswerContent());
                    strTagData += getAttachList(Integer.toString(qstNo), Integer.toString(qstAnswer.getAnswerNo()), qstAnswer.getBrdId(), qstAnswer.getItemNo());
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
	            	strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open(1," + brdId + "," + itemNo + "," + strQuestionNo + "," + strAnswer + "," + strAttachNo + ")\"><img style=\"cursor:pointer\" src=\"/ezQuestion/qstInterFace.do?TYPE=QUESTION&BOARDID=" + brdId + "&ITEMID=" + itemNo + "&QSTNO=" + strQuestionNo + "&ANSNO=" + strAnswer + "&ATTID=" + strAttachNo + "\" width=\"47\" height=\"31\" align=\"absmiddle\"></td>");
	            	break;
	            case "2":
	            	strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open(2," + brdId + "," + itemNo + "," + strQuestionNo + "," + strAnswer + "," + strAttachNo + ")\"><img src=\"/images/poll/sound.gif\" width=\"19\" height=\"17\" align=\"absmiddle\">" + strAttachName + "</td>");
	            	break;
	            case "3":
	            	break;
	            case "4":
	            	break;
	            case "5":
	            	strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open(3," + brdId + "," + itemNo + "," + strQuestionNo + "," + strAnswer + "," + strAttachNo + ")\"><img src=\"/images/poll/video.gif\" width=\"21\" height=\"17\" align=\"absmiddle\">" + strAttachName + "</td>");
	            	break;
	            default:
	            	strResult.append("<td nowrap style=\"padding:5px\"><img src=\"/images/poll/link.gif\" width=\"26\" height=\"17\" align=\"absmiddle\"><a href=\"/ezQuestion/qstInterFace.do?TYPE=QUESTION&BOARDID=" + brdId + "&ITEMID=" + itemNo + "&QSTNO=" + strQuestionNo + "&ANSNO=" + strAnswer + "&ATTID=" + strAttachNo + "\" target=\"_blink\">" + strAttachName + "</a></td>");
	            	break;
	            }
	        }
        }
        if(!bFirst){
        	strResult.append("<td style=\"padding:5px\">&nbsp;</td></tr></table>");
        }
        return strResult.toString();
	}
	
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResponseOk.do")
	public void qstResponseOk(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,HttpServletResponse response) throws Exception{        
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brdId = "5", itemNo = "", responseUserIp = "", vPermission = "", vResponseRange = "", receve = "";
		String userId = "", userName = "", email = "", deptId = "", depart = "", position = "", jikGub = "", gender = "1", age = "29";
		String userName2 = "", depart2 = "", position2 = "", jikGub2 = "";
		String tableAnswer = "";
        int eleCnt = 0;
        
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
			response.getWriter().write("	alert('" + egovMessageSource.getMessage("ezQuestion.t360") + "');\n");
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
        String responseNo = "1", answerSubjectivity = "";
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
	        Integer ansCnt = ezQuestionService.getAnsCnt(brdId, itemNo, questionNo);
	        if(ansCnt != null){
	        	ansRCnt = ansCnt;
	        }else{
	        	ansRCnt = 0;
	        }
			/** EZSP_INSERTRESPONSE*/
			List<String> multiQ = null;
			
			if(multiSelect == "1"){
				int iNum = 0;
				for(int j=0; j<ansRCnt; j++){
					iNum ++;
					tmp = "chk" + questionNo + "_" + Integer.toString(iNum);
					
					multiQ = new ArrayList<String>();
					multiQ.add(request.getParameter(tmp.trim()));
					
					if(multiQ.get(j) == "1"){
						qstResponseVO.setAnswerObjectivity(iNum);
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
	        Integer ansCnt = ezQuestionService.getAnsCnt(brdId, itemNo, questionNo);
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

	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResult.do")
	public String qstResult(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String userId = loginVO.getId();
		String brdId="5", brdNm="", itemNo="", title="", responseRange="", postDate="", pollEndDate="", currPage="";
		String publicResultFlg = "", publicFlg = "", multiResponseFlg = "", endFlg = "";
		int readCnt=0, resCnt=0;
		int percent = 0;
		
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
				"&itemNo=" + request.getParameter("itemNo") +
                "&title=" + new String(request.getParameter("title").getBytes("ISO-8859-1"),"UTF-8") +
                "&responseRange=" + request.getParameter("responseRange") +
                "&postDate=" + request.getParameter("postDate") +
                "&pollEndDate=" + request.getParameter("pollEndDate") +
                "&currPage=" + request.getParameter("currPage");		
		
		/** EZSP_GETUSERIDADMIN*/
		boolean adminYN = false;
		String userIdAdmin = ezQuestionService.getUserIdAdmin(Integer.parseInt(brdId));

		if(userIdAdmin != null){
			if(userId.equals(userIdAdmin)){
				adminYN = true;
			}
		}
		/** EZSP_RESCOUNT*/
		if(ezQuestionService.resCount(brdId, itemNo) != null)
			resCnt = ezQuestionService.resCount(brdId, itemNo);
		else
			resCnt = 0;
		
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
		/** EZSP_GETREADDATEITEMFORRESULT*/
		String readDate = ezQuestionService.getReadDateItemForResult(qstUserPollItemVO, userId);
		/** EZSP_UPDATEREADDATE*/
		Date sysDate=new Date();
		java.text.DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		if(readDate != null){
			ezQuestionService.updateReadDate(qstUserPollItemVO, readDate, userId);
		}else{
			ezQuestionService.insertItemRead(loginVO, qstUserPollItemVO, formatter.format(sysDate));
		}
		
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
         
        /** ans*/
        List<QstVO> qstVOList = dataProcessMainData(brdId, itemNo);
        qstVOList = dataProcess(Integer.parseInt(brdId), Integer.parseInt(itemNo), bPublic, qstVOList, percent);
        
        
        model.addAttribute("qstVOList",qstVOList);
        model.addAttribute("qstUserPollItemVO", qstUserPollItemVO);
        model.addAttribute("qstUserPermissionVO", qstUserPermissionVO);
		model.addAttribute("receve", receve);
		model.addAttribute("resCnt", resCnt);
		return "/ezQuestion/qstResult";
	}
	public List<QstVO> dataProcessMainData(String brdId, String itemNo) throws Exception{
		/** EZSP_GETQUESTIONFORRESPONSE*/
		QstVO qstVO = new QstVO();
		qstVO.setBrdId(Integer.parseInt(brdId));
		qstVO.setItemNo(Integer.parseInt(itemNo));

		List<QstVO> qstVOList = ezQuestionService.getQuestionForResponse(qstVO);
		return qstVOList;
	}
	
	public List<QstVO> dataProcess(int brdId, int itemNo, boolean bPublic,List<QstVO> qstVOList, int percent) throws Exception{
		int iCount=0;
		String strData = "";
		
		for(QstVO qstVO : qstVOList){
			iCount++;
			int questionNo = qstVO.getQuestionNo();
			String quesContent = qstVO.getQuesContent().replace("<","&lt;").replace(">", "&gt;");
			String multiSelect = qstVO.getMultiSelect();
			int answerType = qstVO.getAnswerType();
			strData = "";
			
			if(answerType == 2){
				strData = dataProcessType2(brdId, itemNo, questionNo, quesContent, multiSelect, answerType, iCount);
			}else{
				List<QstAnswerVO> qstAnswerVOList = dataProcessAns(brdId, itemNo, questionNo);
				if(answerType == 1){
					strData = dataProcessType1(brdId, itemNo, questionNo, quesContent, multiSelect, answerType, iCount, percent, multiSelect, qstAnswerVOList);
				}else if(answerType == 3){
					strData = dataProcessType3(brdId, itemNo, questionNo, quesContent, multiSelect, answerType, iCount, percent, bPublic, qstAnswerVOList);
				}else if(answerType == 4){
					strData = dataProcessType4(brdId, itemNo, questionNo, quesContent, multiSelect, answerType, iCount, percent, qstAnswerVOList);
				}else if(answerType == 5){
					strData = dataProcessType5(brdId, itemNo, questionNo, quesContent, multiSelect, answerType, iCount, percent, qstAnswerVOList);
				}
			}
			qstVO.setStrData(strData);
		}
		return qstVOList;
	}
	
	public List<QstAnswerVO> dataProcessAns(int brdId, int itemNo, int questionNo) throws Exception{
		/** EZSP_GETANSWERCNT*/
		List<QstAnswerVO> qstAnswerVOList = ezQuestionService.getAnswerCnt(brdId, itemNo, questionNo);
		return qstAnswerVOList;
	}
	
	public int getAnswerPerson(Document xmlDoc, int iAnsCount, int TrOrder) throws Exception{
		int rtv = 0;
		for (int i = 0; i < xmlDoc.getElementsByTagName("ANSWER_SUBJECTIVITY").getLength(); i++){
//			if (xmlDoc.getElementsByTagName("ANSWER_SUBJECTIVITY").item(i).InnerText.Split(';')[iAnsCount] == (TrOrder + 1){
//				rtv++;
//            }
        }
        return rtv;
	}
	
	public int defaultResponseCount(int brdId, int itemNo, int questionNo) throws Exception{
		return ezQuestionService.getResPersonCnt(brdId, itemNo, questionNo);
	}
	
	public int responseCount(int questionNo, String strContent, String strSel, int answerType, int iAnsCnt, int brdId, int itemNo) throws Exception{
		int iResult = 0;
		
		if(answerType == 3){
			iResult = ezQuestionService.pollRespCnt2(brdId, itemNo, questionNo, iAnsCnt);
			/** EZSP_POLLRESPCNT2*/
		}else{
			/** EZSP_POLLRESPCNT*/
			iResult = ezQuestionService.pollRespCnt(brdId, itemNo, questionNo, iAnsCnt);
		}
		return iResult;	
	}
	
	@SuppressWarnings("unused")
	public String dataProcessType1(int brdId, int itemNo, int questionNo, String strContent, String strSel, int answerType, int iDataCount, int percent, String multiSelect, List<QstAnswerVO> qstAnswerVOList) throws Exception{
		int iAnsCount = 0, responseCnt = 0;
        int rCnt = 0;
        float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
        String strData = "";
        responseCnt = defaultResponseCount(brdId, itemNo, questionNo);

        strData += "<table class=\"question\">";
        strData += "<tr>";
        strData += "<th>" + egovMessageSource.getMessage("ezQuestion.t333") + iDataCount + " : " + strContent + "";
        if (multiSelect == "1")
        {
            strData += "<span class=\"subtxt\">[" + egovMessageSource.getMessage("ezQuestion.t55") + "</span>";
        }
        strData += getAttachList(Integer.toString(questionNo), "0", brdId, itemNo);
        strData += "</th>";
        strData += "</tr>";
        strData += "</table>";
        strData += "<table class=\"ex\">";
       
        for(QstAnswerVO qstAnswerVO : qstAnswerVOList){
        	iAnsCount ++;
        	rCnt = responseCount(questionNo, strContent, strSel, answerType, iAnsCount, brdId, itemNo);
        	fRCnt = rCnt;
        	fResponseCnt = responseCnt;

			if(responseCnt <= 0){
				percent=0;
			}else{
				fPercent = fRCnt / responseCnt;
				percent = Math.round(fPercent*100);
			}
        	strData += "<tr>";
        	strData += "<td>" + qstAnswerVO.getAnswerContent().replace("<", "&lt;").replace(">", "&gt;");
            strData += getAttachList(Integer.toString(questionNo), Integer.toString(qstAnswerVO.getAnswerNo()), brdId, itemNo) + "</td>";
            strData += "<td width=\"80\" valign=\"top\" align=\"right\" nowrap>";
            strData += "" + rCnt + " ";
            strData += " " + egovMessageSource.getMessage("ezQuestion.t399") + " ";
            strData += "</th>";
            strData += "<td width=\"70\" valign=\"top\" align=\"right\" nowrap>[" + Integer.toString(percent) + "%]</td>";
            strData += "<td width=\"150\" valign=\"top\">";
            if (percent > 0)
                strData += "<img src=\"/images/img_graph.gif\" width=\"" + percent + "\" height=\"16\" align=\"absmiddle\">";
            strData += "</td>";
            strData += "</tr>";
        }
        strData += "</table>";
        strData += "<br>";

		return strData;
	}

	public String dataProcessType2(int brdId, int itemNo, int questionNo, String strContent, String strSel, int answerType, int iDataCount) throws Exception{
		String strData = "";
		strData += "<table class=\"question\"><tr>";
		strData += "<th>" + egovMessageSource.getMessage("ezQuestion.t333") + iDataCount + " : " + strContent + "</th>";
		strData += "<th style=\"width:150px;text-align:right;padding:0 10px\">";
		strData += "<a class=\"imgbtn\" style=\"cursor:pointer\"><span onclick=\"fun_ResponseView(" + questionNo + ");\">" + egovMessageSource.getMessage("ezQuestion.t396") + "</span></A>";
		strData += "</th></tr><tr><td colspan=2 style=\"padding:0\">";
		strData += getAttachList(Integer.toString(questionNo), "0", brdId, itemNo) + "</td>";
		strData += "</tr>";
		strData += "</table>";
		strData += "<br>";

		return strData;
	}
	
	@SuppressWarnings("unused")
	public String dataProcessType3(int brdId, int itemNo, int questionNo, String strContent, String strSel, int answerType, int iDataCount, int percent, boolean bPublic, List<QstAnswerVO> qstAnswerVOList) throws Exception{
		String strData = "";
		int rCnt = 0, jCnt =0, responseCnt =0;;
		float fRCnt =0, fResponseCnt = 0, fPercent =0;
		responseCnt = defaultResponseCount(brdId, itemNo, questionNo);

		strData += "<table class=\"question\">";
        strData += "<tr>";
        strData += "<th colspan=4>" + egovMessageSource.getMessage("ezQuestion.t333") + iDataCount + " : " + strContent + "";
        if (strSel == "1")
        {
            strData += "<span class=\"subtxt\">[" + egovMessageSource.getMessage("ezQuestion.t55") + "</span>";
        }

        strData += getAttachList(Integer.toString(questionNo), "0", brdId, itemNo);

        strData += "</th>";
        strData += "</tr>";

        
        String anscontent =qstAnswerVOList.get(0).getAnswerContent();
        String[] ArrayContent = anscontent.split("-");

        for (int i = Integer.parseInt(ArrayContent[0]); i < Integer.parseInt(ArrayContent[1]); i++)
        {
        	jCnt++;
            rCnt = responseCount(questionNo, strContent, strSel, answerType, i, brdId, itemNo);
            fRCnt = rCnt;
            fResponseCnt = responseCnt;
            if(responseCnt <= 0){
				percent=0;
			}else{
				fPercent = fRCnt / responseCnt;
				percent = Math.round(fPercent*100);
			}

            strData += "<tr>";
            strData += "<td>";
            strData += "" + jCnt + "";
            strData += "." + i + "";
            strData += "</td>";
            strData += "<td width=\"80\" align=\"right\">";
            if (bPublic)
            {
                strData += "<a href=\"#\" onclick=\"User_info(\"" + questionNo + "','" + i + "\",\"3\");\"";
                strData += "" + rCnt + "";
                strData += "" + egovMessageSource.getMessage("ezQuestion.t53") + "</a> " + egovMessageSource.getMessage("ezQuestion.t306");
            }
            else
            {
                strData += "" + rCnt + "";
                strData += "" + egovMessageSource.getMessage("ezQuestion.t399");
            }
            strData += "</td>";
            strData += "<td width=\"70\" align=\"right\">[" + percent + "%]</td>";
            strData += "<td width=\"150\">";
            if (percent > 0)
                strData += "<img src=\"/images/img_graph.gif\" width=\"" + percent + "\" height=\"16\" align=\"absmiddle\">";
            strData += "</td>";
            strData += "</tr>";
        }
        strData += "</table>";
        strData += "<br>";
        
		return strData;
	}
	
	@SuppressWarnings("unused")
	public String dataProcessType4(int brdId, int itemNo, int questionNo, String strContent, String strSel, int answerType, int iDataCount, int percent, List<QstAnswerVO> qstAnswerVOList) throws Exception{
		String strData = "";
		int iAnsCount = 0, responseCnt = 0;
        int rCnt = 0;
        float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
        responseCnt = defaultResponseCount(brdId, itemNo, questionNo);
        
        strData += "<table class=\"question\">";
        strData += "<tr>\n";
        strData += "<th>" + egovMessageSource.getMessage("ezQuestion.t333") + iDataCount + " : " + strContent + "";
        strData += "<span class=\"subtxt\">[" + egovMessageSource.getMessage("ezQuestion.t400") + "</span>";
        strData += "</th>\n";
        strData += "<th style=\"text-align:right;width:150px;padding:0 10px\">";
        strData += "<A class=\"imgbtn\" onclick=\"fun_ResponseView('" + questionNo + "');\" style=\"cursor:pointer\"><span>" + egovMessageSource.getMessage("ezQuestion.t396") + "</span></A>";
        strData += "</th></tr></table>\n";

        strData += getAttachList(Integer.toString(questionNo), "0", brdId, itemNo);
        strData += "<table class=\"ex\">";
        
        for(QstAnswerVO qstAnswerVO : qstAnswerVOList){
        	iAnsCount++;
            
            rCnt = responseCount(questionNo, strContent, strSel, answerType, iAnsCount, brdId, itemNo);
            fRCnt = rCnt;
            fResponseCnt = responseCnt;
            if(responseCnt <= 0){
				percent=0;
			}else{
				fPercent = fRCnt / responseCnt;
				percent = Math.round(fPercent*100);
			}
            strData += "<tr>";
            strData += "<td>";
            strData += "" +qstAnswerVO.getAnswerContent().replace("<", "&lt;").replace(">", "&gt;") + "";
            strData += getAttachList(Integer.toString(questionNo), Integer.toString(qstAnswerVO.getAnswerNo()), brdId, itemNo) + "</td>";
            strData += "</tr>";
        }
        strData += "</table>";
        strData += "<br>";
        
		return strData; 
	}

	public String dataProcessType5(int brdId, int itemNo, int questionNo, String strContent, String strSel, int answerType, int iDataCount, int percent, List<QstAnswerVO> qstAnswerVOList) throws Exception{
		String strData = "";
		
		/** EZSP_GETTABLEANSWER*/
		String strXmlDom = ezQuestionService.getTableAnswer(brdId, itemNo, questionNo);
		Document xmlDom = commonUtil.convertStringToDocument(strXmlDom);
		String strXmlDoc = ezQuestionService.getResponseAnswer(brdId, itemNo, questionNo);
		Document xmlDoc = commonUtil.convertStringToDocument(strXmlDoc);
		
		int iAnsCount = 0, responseCnt = 0;
        int rCnt = 0;
        percent = 0;
        
        responseCnt = xmlDoc.getElementsByTagName("ANSWER_SUBJECTIVITY").getLength();

        strData += "<table class=\"question\">";
        strData += "<tr>";
        strData += "<th>" + egovMessageSource.getMessage("ezQuestion.t333") + iDataCount + " : " + strContent + "";
        if (strSel == "1")
        {
            strData += "<span class=\"subtxt\">[" + egovMessageSource.getMessage("ezQuestion.t55") + "</span>";
        }
        strData += getAttachList(Integer.toString(questionNo), "0", brdId, itemNo);
        strData += "</th>";
        strData += "</tr>";
        strData += "</table>";
        strData += "<table class=\"ex\">";        
        for(QstAnswerVO qstAnswerVO : qstAnswerVOList){
        	iAnsCount++;
        	if(iAnsCount ==1){
        		strData += "	<tr style=\"text-align:center;\">";
                for (int i = 0; i <= xmlDom.getElementsByTagName("ANSWER_ANSWERCONTENT").getLength(); i++){
                	if (i == 0){
                		strData += "<td style=\"border:1px solid #b6b6b6;\"></td>";
                	}else{
//                		strData += "<td colspan='3' style='border:1px solid #b6b6b6;'>" + xmlDom.getElementsByTagName("ANSWER_ANSWERCONTENT").item(i - 1).InnerText.replace("<", "&lt;").replace(">", "&gt;") + "</td>";
                	}
                }
                strData += "</tr>\n";
        	}
        	strData += "<tr style=\"text-align:center;\">";
            strData += "<td style=\"border:1px solid #b6b6b6;\">" + qstAnswerVO.getAnswerContent().replace("<", "&lt;").replace(">", "&gt;");
            strData += getAttachList(Integer.toString(questionNo), Integer.toString(qstAnswerVO.getAnswerNo()), brdId, itemNo) + "</td>";
            for (int i = 0; i < xmlDom.getElementsByTagName("ANSWER_ANSWERCONTENT").getLength(); i++){
                rCnt = getAnswerPerson(xmlDoc, iAnsCount - 1, i);
                if (responseCnt != 0)
                    percent = (rCnt * 100) / responseCnt;
                strData += "<td width=\"80' valign=\"top\" align=\"right\" nowrap style=\"border:1px solid #b6b6b6; border-right:0px;\">";
                strData += "" + rCnt + "";
                strData += "" + egovMessageSource.getMessage("ezQuestion.t399") + "";
                strData += "</th>";
                strData += "<td width=\"70\" valign=\"top\" align=\"right\" nowrap style=\"border:1px solid #b6b6b6; border-right:0px; border-left:0px;\">[" + percent + "%]</td>";
                strData += "<td width=\"150\" valign=\"top\" style=\"border:1px solid #b6b6b6; padding-right:10px; border-left:0px;\">";
                if (percent > 0)
                    strData += "<img src=\"/images/img_graph.gif\" width=\"" + percent + "%\" height=\"16\" align=\"absmiddle\">";
                strData += "</td>";
            }
            strData += "</tr>";
        }
        strData += "</table>";
        strData += "<br>";

		return strData;
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
	public String qstRangeSelect(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brdId = "";
		String itemId = "";
		String strDeptACL = "", strMemberACL="",userInfoDeptCode="",serverName="",pCompanyID="";
		String strGenderACL0="",strGenderACL1="",strGenderACL2="";
		
		if(req.getParameter("brd_id") != null)
			brdId = req.getParameter("brd_id");
System.out.println("brdId"+brdId);
		if(req.getParameter("item_no") != null) {
			itemId = req.getParameter("item_no");
System.out.println("itemId"+itemId);
		}
		strGenderACL0 = "checked";
		strGenderACL1 = "";
		strGenderACL2 = "";
		userInfoDeptCode = loginVO.getDeptID();
		pCompanyID = loginVO.getCompanyID();
		serverName = req.getServerName();
		
		QstRangeSelectVO qstRangeSelectVO = new QstRangeSelectVO();
		qstRangeSelectVO.setBrdId(brdId);
		qstRangeSelectVO.setItemId(itemId);
		qstRangeSelectVO.setStrGenderACL0(strGenderACL0);
		qstRangeSelectVO.setStrGenderACL1(strGenderACL1);
		qstRangeSelectVO.setStrGenderACL2(strGenderACL2);
		qstRangeSelectVO.setUserInfoDeptCode(userInfoDeptCode);
		qstRangeSelectVO.setpCompanyID(pCompanyID);
		qstRangeSelectVO.setServerName(serverName);
		
		model.addAttribute("brdId",qstRangeSelectVO.getBrdId());
		model.addAttribute("itemNo",qstRangeSelectVO.getItemId());
		model.addAttribute("qstRangeSelectVO",qstRangeSelectVO);
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
System.out.println("pQstTitle:"+pQstTitle);			
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
		
		if(!pRtn.equals("OK")) {
			DeleteQuestion(pBrdID, vItemID);
			pRtn = "ERROR";
		}

		String strXML = "<DATA>" + pRtn + "</DATA>";
		
		int brdId = Integer.parseInt(pBrdID);
		int itemNo = Integer.parseInt(vItemID);
		
		return strXML;
	}

	public String SaveQuestion(String pBrdID, String vItemID, Document doc, String pUserID) throws Exception {
	
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
			
			if(doc.getElementsByTagName("RANGE").item(0).getChildNodes().getLength() > 0) {
				int pDeptCnt = doc.getElementsByTagName("DEPT").item(0).getChildNodes().getLength();
				
				for(int i=0; i<pDeptCnt; i++) {
					NodeList list = doc.getElementsByTagName("DEPT").item(0).getChildNodes();
					Node fstNode = list.item(i);
					
					if(fstNode.getNodeType() == Node.ELEMENT_NODE) {
						Element fstElement = (Element) fstNode;
						String deptId = fstElement.getAttributeNode("id").getValue();
						String deptNm = fstElement.getAttributeNode("nm").getValue();
						String deptNm2 = fstElement.getAttributeNode("nm2").getValue();
						QstCompleteVO qstCompleteVO = new QstCompleteVO();
						qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
						qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
						qstCompleteVO.setGubunFg("0");
						qstCompleteVO.setGubunID(deptId);
						qstCompleteVO.setGubunNm(deptNm);
						qstCompleteVO.setGubunNm2(deptNm2);
						ezQuestionService.callCreateMother(qstCompleteVO);
						
						String cellList = "department";
                        String propList = "department;mail;displayname;title;description;company;title";
                        String pClass = "all";
					}
				}
			}
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
		
		return "OK";
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
			pFilePath = "/files/upload_board/uploadQuestion/"+newFileName;
			
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
	

	@RequestMapping(value="/ezQuestion/qstTempSave.do")
	public void qstTempSave(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		StringBuilder sb = new StringBuilder();
		if(req.getParameter("TempSaveData") != null) {
			String tempData = req.getParameter("TempSaveData").toString();
			sb.append(tempData);
		} else  {
			return;
		}
		
		resp.setContentType("application/octet-stream");
		resp.setCharacterEncoding("utf-8");
		resp.setHeader("Content-Disposition", "attachment;filename=\"TempQuestion.qst\"");
		resp.setHeader("Cache-Control", "public");
		resp.getWriter().write(sb.toString());	
		resp.flushBuffer();
	}
	
	@RequestMapping(value="/ezQuestion/formTempLoadSafari.do")
	public void formTempLoadSafari(MultipartHttpServletRequest req,Model model, HttpServletResponse resp) throws Exception {
		StringBuilder sb = new StringBuilder();
		if(req.getFile("cmuds") != null) {
			InputStreamReader myFile = new InputStreamReader(req.getFile("cmuds").getInputStream());
System.out.println("!!");
			int line = 0; 
			while((line = myFile.read()) != -1) {
				sb.append(String.valueOf(line));
			}
		}
	}
	
	@RequestMapping(value="/ezQuestion/qstCancel.do")
	public void qstCancel(HttpServletRequest req, Model model, HttpServletResponse resp) throws Exception {
		StringBuilder sb = new StringBuilder();
		
	}
	
	public String getDeptMemberList(String pDeptID, String pCellList, String pPropList, String pClass, String pLangCode) {
			pLangCode = ConvertLangCode(pLangCode);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_CLASS", pClass);
			map.put("v_CN", pDeptID);
			map.put("v_LANGDATA", pLangCode);
			
		return "";
	}
	
	public String ConvertLangCode(String pLangCode) {
		if(pLangCode != "2") {
			return "1";
		} else {
			return "2";
		}
	}
	

	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstAttachView.do")
	public String attachView(HttpServletRequest request,ModelMap model) throws Exception{
		String href = "", type = "", title = "", filename = "";
		String vBrdId = "5";
		String vItemNo = "";
		String strQuestionNo = "";
		String strAnswer = "";
		String strAttID = "";
		 
		if (request.getParameter("type") != null)
            type = request.getParameter("type");
        if (request.getParameter("BOARDID") != null)
            vBrdId = request.getParameter("BOARDID");
        if (request.getParameter("ITEMID") != null)
            vItemNo = request.getParameter("ITEMID");
        if (request.getParameter("QSTNO") != null)
            strQuestionNo = request.getParameter("QSTNO");
        if (request.getParameter("ANSNO") != null)
            strAnswer = request.getParameter("ANSNO");
        if (request.getParameter("ATTID") != null)
            strAttID = request.getParameter("ATTID");
        if (request.getParameter("href") != null){
        	href=request.getParameter("href");
        }

        QstAttachVO qstAttachVO = ezQuestionService.getAttachInfo2(vBrdId, vItemNo, strQuestionNo, strAnswer, strAttID);
        href=qstAttachVO.getAttachUrl();
        filename = qstAttachVO.getAttachName();
        
        String fileExt = href.substring(href.lastIndexOf("."));
        filename += fileExt;

        qstAttachVO.setBrdId(Integer.parseInt(vBrdId));
        qstAttachVO.setItemNo(Integer.parseInt(vItemNo));
        qstAttachVO.setQuestionNo(Integer.parseInt(strQuestionNo));
        qstAttachVO.setAnswerNo(Integer.parseInt(strAnswer));
        qstAttachVO.setAttachNo(Integer.parseInt(strAttID));

        switch(type){
        case "1":
        	title = egovMessageSource.getMessage("ezQuestion.t178");
        	break;
        case "2":
        	title = egovMessageSource.getMessage("ezQuestion.t179");
        	break;
        case "3":
        	title = egovMessageSource.getMessage("ezQuestion.t180");
        	break;
        case "4":
        	title = "URL " + egovMessageSource.getMessage("ezQuestion.t171");
        	break;
        }
        
        model.addAttribute("qstAttachVO", qstAttachVO);
        model.addAttribute("title", title);
       
        return "/ezQuestion/qstAttachView";
	}
	
	@RequestMapping(value="/ezQuestion/qstInterFace.do")
	public void qstInterFace(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		String pType = "5";
		String pBoardID = "";
		String pItemID = "";
		String pQstNo = "";
        String pAnsNo = "";
        String pAttID = "";
        String pFileName = "";
        String pFilePath = "";
		 
		if (request.getParameter("TYPE") != null)
            pType = request.getParameter("TYPE");
		if (request.getParameter("FILENAME") != null)
			pFileName = request.getParameter("FILENAME");
        if (request.getParameter("BOARDID") != null)
        	pBoardID = request.getParameter("BOARDID");
        if (request.getParameter("ITEMID") != null)
        	pItemID = request.getParameter("ITEMID");
        if (request.getParameter("QSTNO") != null)
        	pQstNo = request.getParameter("QSTNO");
        if (request.getParameter("ANSNO") != null)
        	pAnsNo = request.getParameter("ANSNO");
        if (request.getParameter("ATTID") != null)
        	pAttID = request.getParameter("ATTID");
        
        if(pType.equals("QUESTION")){
                if (pFileName != "")
                    pFilePath = "/Upload_BoardSTD/Upload_Question/" + pFileName;
                else{
                    pFilePath = ezQuestionService.getAttachInfo2(pBoardID, pItemID, pQstNo, pAnsNo, pAttID).getAttachUrl();
                    pFileName = ezQuestionService.getAttachInfo2(pBoardID, pItemID, pQstNo, pAnsNo, pAttID).getAttachName() + pFilePath.substring(pFilePath.lastIndexOf('.'));
                }
                if (pFilePath != null && pFilePath != "")
                    ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
        }
	}

	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResultSubjective.do")
	public String qstResultSubjective(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap model) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brdId = "", itemNo = "", questionNo = "", lang="";
        int pTotalCnt = 0, pTotalPage = 0, pCurrPage = 0;
        int pPageSize = 0, pageCount = 0, pBlockSize = 0;
        String publicResultFlg = "", publicFlg = "", multiResponseFlg = "";
        String pAnsType = "";
        
        if (request.getParameter("brd_id") != null)
            brdId = request.getParameter("brd_id");
        if (request.getParameter("item_no") != null)
            itemNo = request.getParameter("item_no");
        if (request.getParameter("question_no") != null)
            questionNo = request.getParameter("question_no");
        if (request.getParameter("page_count") != null)
            pageCount = Integer.parseInt(request.getParameter("page_count"));        
        if(loginVO.getLang().equals("1")){
        	lang ="";
        }else
        	lang = loginVO.getLang();
        if (request.getParameter("page") != null){
            if (request.getParameter("page") != "")
                pCurrPage = Integer.parseInt(request.getParameter("page"));
            else
                pCurrPage = 1;
        }else
            pCurrPage = 1;
        pPageSize = 15;
        pBlockSize = 10;

        QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
        qstUserPermissionVO.setBrdId(Integer.parseInt(brdId));
        qstUserPermissionVO.setItemNo(Integer.parseInt(itemNo));
        qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
        publicResultFlg = qstUserPermissionVO.getPublicResultFlg();
        publicFlg = qstUserPermissionVO.getPublicFlg();
        multiResponseFlg = qstUserPermissionVO.getMultiResponseFlg();

        /** EZSP_RESULTSUBJECTIVELISTCNT*/
        pTotalCnt = ezQuestionService.resultSubjectiveListCnt(Integer.parseInt(brdId), Integer.parseInt(itemNo), Integer.parseInt(questionNo), lang);
        pTotalPage = (pTotalCnt + pPageSize - 1) / pPageSize;
        if (pageCount == 0)
            pageCount = -1;
        else
            pageCount = pageCount - 1;
        
        int iStart = (pCurrPage - 1) * pPageSize;
        /** EZSP_RESULTSUBJECTIVELIST*/
        List<QstResponseVO> qstResponseVOList = ezQuestionService.resultSubjectiveList(brdId, itemNo, questionNo, pTotalCnt-iStart, pPageSize, lang);
        
        String data = "<DATA></DATA>";
        Document xmlMainDom = commonUtil.convertStringToDocument(data);
        Document xmlRtnDom = commonUtil.convertStringToDocument(data);
        
        int iDataCount = 0;
        String pAnsSubjectivity = "";
        for(QstResponseVO qstResponseVO : qstResponseVOList){
        	Node targetNode = xmlMainDom.getFirstChild();
            Node newRow = xmlMainDom.createElement("ROW");
            Node No = xmlMainDom.createElement("NO");
            
            iDataCount++;
            int iCurrNumber = 0;
            iCurrNumber = iDataCount + (pCurrPage - 1) * pPageSize;
            
            Node ivalue = xmlMainDom.createTextNode(Integer.toString(iCurrNumber));
            No.appendChild(ivalue);
            newRow.appendChild(No);
            targetNode.appendChild(newRow);
            for(Field field : qstResponseVO.getClass().getDeclaredFields()){
            	field.setAccessible(true);
            	if(field.getName().equals("ANSWER_SUBJECTIVITY")){
            		pAnsSubjectivity = (String) field.get(qstResponseVO);
            		//////////////////////////
            		QstVO qstVO = ezQuestionService.getQuestionForSubjective(brdId, itemNo, questionNo);
            		pAnsType = Integer.toString(qstVO.getAnswerType());
            		if(pAnsType.equals("4")){
            			List<QstAnswerVO> rtnList = dataProcessAns(Integer.parseInt(brdId), Integer.parseInt(itemNo), Integer.parseInt(questionNo));
            			StringBuilder rtnXML = new StringBuilder();
            			rtnXML.append("<DATA>");
            			for(QstAnswerVO qstAnswerVO : rtnList){
            				rtnXML.append(commonUtil.getQueryResult(qstAnswerVO));
            			}
            			rtnXML.append("</DATA>");
            			
            			xmlRtnDom = commonUtil.convertStringToDocument(rtnXML.toString());
            			String[] arrayContent = pAnsSubjectivity.split(";");
            			pAnsSubjectivity = "";
            			
            			for(int j=0; j < arrayContent.length-1; j++){
            				int k = 0;
            				k = Integer.parseInt(arrayContent[j]);
            				
            				if(xmlRtnDom.getElementsByTagName("DATA/ROW/ANSWERCONTENT").getLength() > 0)
            					pAnsSubjectivity = pAnsSubjectivity + xmlRtnDom.getElementsByTagName("DATA/ROW/ANSWERCONTENT").item(k-1).getTextContent() + " ; ";
            				else
            					pAnsSubjectivity = pAnsSubjectivity + " ; ";
            			}
            		}
            		if(pAnsSubjectivity.length() > 70){
            			String strTag = "<td style='width:100%;height:100%;word-break:break-all;white-space:normal;'><div style='height:40px;overflow-y:auto;'>" + modifyData(pAnsSubjectivity) + "</div></td>";
            			Node option = xmlMainDom.createElement("OPTIOIN");
            			option.appendChild(xmlMainDom.createTextNode(strTag));
            			newRow.appendChild(option);
            			targetNode.appendChild(newRow);
            		}else{
            			String strTag = "<td>" + modifyData(pAnsSubjectivity) + "</td>";
            			Node option = xmlMainDom.createElement("OPTIOIN");
            			option.appendChild(xmlMainDom.createTextNode(strTag));
            			newRow.appendChild(option);
            			targetNode.appendChild(newRow);
            		}
            	}
            	Node newDataName = xmlMainDom.createElement(field.getName().toUpperCase());
            	Node newDataValue = null;
            	//""이라 Exception
            	if(field.get(qstResponseVO)!=null){
            		if(field.get(qstResponseVO).getClass() != String.class){
            			newDataValue = xmlMainDom.createTextNode(modifyData(Integer.toString((int)field.get(qstResponseVO))).trim());
            		}
            		else{
            			newDataValue = xmlMainDom.createTextNode(modifyData((String)field.get(qstResponseVO)).trim());
            		}
            	}
            	newDataName.appendChild(newDataValue);
                newRow.appendChild(newDataName);
                newDataName = null;
                newDataValue = null;
                targetNode.appendChild(newRow);
            }
        }        

        model.addAttribute("brd_id", brdId);
        model.addAttribute("item_no", itemNo);
        model.addAttribute("question_no", questionNo);
        model.addAttribute("pTotalPage", pTotalPage);
        model.addAttribute("pCurrPage", pCurrPage);
        model.addAttribute("pTotalCnt", pTotalCnt);
        model.addAttribute("pAnsType", pAnsType);
        model.addAttribute("public_flg", publicFlg);
        model.addAttribute("page_count", pageCount);
        model.addAttribute("xmlMainDom", commonUtil.convertDocumentToString(xmlMainDom));
        
		return "/ezQuestion/qstResultSubjective";
	}
	
	@RequestMapping(value="/ezQuestion/qstDeleteItemMsg.do")
	public String qstDeleteItemMsg(HttpServletRequest req,Model model)  {
		String pBrdID = "";
		String itemNo = "";
		
		if(req.getParameter("brd_id") != null) {
			pBrdID = req.getParameter("brd_id");
		}
		
		if(req.getParameter("item_no") != null) {
			itemNo = req.getParameter("item_no");
		}

		model.addAttribute("pBrdID", pBrdID);
		model.addAttribute("itemNo", itemNo);
		return "/ezQuestion/qstDeleteItemMsg";
	}
	
	@RequestMapping(value="/ezQuestion/callDeleteItem.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstDeleteItem(HttpServletRequest req,Model model) throws Exception {
		Document doc = commonUtil.convertRequestToDocument(req);
		
		String pBrdID = "";
		String itemNo = "";
		
		if(req.getParameter("brd_id") != null) {
			pBrdID = req.getParameter("brd_id");
		}
		
		if(req.getParameter("item_no") != null) {
			itemNo = req.getParameter("item_no");
		}
		
		ezQuestionService.deletePermission(Integer.parseInt(pBrdID), Integer.parseInt(itemNo));
		String strXML = "<DATA>DELETE_OK</DATA>";
		return strXML;
	}
	
	@RequestMapping(value="/ezQuestion/qstSearch.do")
	public String qstSearch(HttpServletRequest req,Model model)  {
		String pBrdID = "";
		if(req.getParameter("brd_id") != null) {
			pBrdID = req.getParameter("brd_id");
		}
		model.addAttribute("pBrdID", pBrdID);
		return "/ezQuestion/qstSearch";
	}
	
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResponseList.do")
	public String qstResponseList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String publicResultFlg = "", publicFlg = "", multiResponseFlg = "", responseRange = "";
        String brdId = "", itemNo = "", questionNo = "", responseYN = "";
        int pPageSize = 0, pBlockSize = 0, pageCount = 0, pCurrPage = 1, pTotalCnt = 0, pTotalPage = 0;
        String lang="";
        String pAnsType = "";
        
        if (request.getParameter("brdId") != null)
            brdId = request.getParameter("brdId");
        if (request.getParameter("itemNo") != null)
            itemNo = request.getParameter("itemNo");
        if (request.getParameter("response_YN") != null)
            responseYN = request.getParameter("response_YN");
        if (request.getParameter("page_count") != null){
        	if (request.getParameter("page_count").equals(""))
        		pageCount = 1;
        	else
        		pageCount = pageCount-1;
        }
        if (request.getParameter("currPage") != null)
        	if (request.getParameter("currPage").equals(""))
        		pCurrPage = 1;
        	else
        		pCurrPage = Integer.parseInt(request.getParameter("currPage"));
        	
        if(loginVO.getLang().equals("1")){
        	lang ="";
        }else
        	lang = loginVO.getLang();
        	
        pPageSize = 15;
        pBlockSize = 10;

        QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
        qstUserPermissionVO.setBrdId(Integer.parseInt(brdId));
        qstUserPermissionVO.setItemNo(Integer.parseInt(itemNo));
        qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
        publicResultFlg = qstUserPermissionVO.getPublicResultFlg();
        publicFlg = qstUserPermissionVO.getPublicFlg();
        multiResponseFlg = qstUserPermissionVO.getMultiResponseFlg();
        responseRange = qstUserPermissionVO.getResponseRange();
        /** EZSP_RESPONSELISTCNT*/
        pTotalCnt = ezQuestionService.responseListCnt(brdId, itemNo, responseYN.trim(), lang);
        pTotalPage = (pTotalCnt + pPageSize - 1) / pPageSize;
        if (pageCount == 0)
            pageCount = -1;
        else
            pageCount = pageCount - 1;
        /** EZSP_RESPONSELIST*/
        List<QstResponseVO> qstResponseVOList = ezQuestionService.responseList(brdId, itemNo, responseYN.trim(), pTotalCnt, pPageSize, lang);
        
        String data = "<DATA></DATA>";
        Document xmlMainDom = commonUtil.convertStringToDocument(data);
        
        int iNum = 0;
        for(QstResponseVO qstResponseVO : qstResponseVOList){
        	Node targetNode = xmlMainDom.getFirstChild();
        	targetNode.appendChild(xmlMainDom.importNode(commonUtil.convertStringToDocument(commonUtil.getQueryResult(qstResponseVO)).getFirstChild(), true));
        	Node newRow = targetNode.getChildNodes().item(iNum);
            Node No = xmlMainDom.createElement("NO");
            
            iNum++;
            int iCurrNumber = 0;
            iCurrNumber = iNum + (pCurrPage - 1) * pPageSize;
            
            Node ivalue = xmlMainDom.createTextNode(Integer.toString(iCurrNumber));
            No.appendChild(ivalue);
            newRow.appendChild(No);
            targetNode.appendChild(newRow);
        }        
        model.addAttribute("brd_id", brdId);
        model.addAttribute("item_no", itemNo);
        model.addAttribute("question_no", questionNo);
        model.addAttribute("pTotalPage", pTotalPage);
        model.addAttribute("pCurrPage", pCurrPage);
        model.addAttribute("pTotalCnt", pTotalCnt);
        model.addAttribute("pAnsType", pAnsType);
        model.addAttribute("public_flg", publicFlg);
        model.addAttribute("page_count", pageCount);
        model.addAttribute("xmlMainDom", commonUtil.convertDocumentToString(xmlMainDom));
        
		return "/ezQuestion/qstResponseList";
	}
	
	@RequestMapping(value="/ezQuestion/qstAnalysis.do")
	public String qstAnalysis(HttpServletRequest request, ModelMap model) throws Exception{
		String pBrdID = "", pItemNo = "", pCurrPage = "";
		String pPubFlag = "";
		
		if (request.getParameter("brdId") != null)
            pBrdID = request.getParameter("brdId");
        if (request.getParameter("item_no") != null)
            pItemNo = request.getParameter("item_no");
        if (request.getParameter("pubflag") != null)
            pPubFlag = request.getParameter("pubflag");
        if (request.getParameter("currPage") != null)
        	pCurrPage = request.getParameter("currPage"); 

        StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		/** EZSP_GETOBJQUESTION*/
		List<QstVO> qstVOList = ezQuestionService.getObjQuestion(pBrdID, pItemNo);
		for(QstVO qstVO : qstVOList){
			sb.append("<ROW>");
			sb.append("<QUESTION_NO>");
			sb.append(qstVO.getQuestionNo());
			sb.append("</QUESTION_NO>");
			sb.append("<QUESCONTENT>");
			sb.append(qstVO.getQuesContent());
			sb.append("</QUESCONTENT>");
			sb.append("<ANSWERTYPE>");
			sb.append(qstVO.getAnswerType());
			sb.append("</ANSWERTYPE>");
			sb.append("</ROW>");
			
		}
		sb.append("</DATA>");
		
        model.addAttribute("xmlMainDom",sb.toString());
        model.addAttribute("pBrdID",pBrdID);
        model.addAttribute("pItemNo",pItemNo);
		model.addAttribute("pPubFlag", pPubFlag);
		model.addAttribute("pCurrPage", pCurrPage);
		
		return "/ezQuestion/qstAnalysis";
	}
	
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstCallAnalysisAll.do" , method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstCallAnalysisAll(HttpServletRequest request) throws Exception{
		String vBrdId="", vItemNo="", vQuesNo="";
		String questionNo = "", quesContent = "", multiSelect = "", answerType = "";
		int resCnt = 0, responseCnt = 0;
		
		if (request.getParameter("brd_id") != null)
			vBrdId = request.getParameter("brd_id");
        if (request.getParameter("item_no") != null)
        	vItemNo = request.getParameter("item_no");
        if (request.getParameter("ques_no") != null)
        	vQuesNo = request.getParameter("ques_no");
        
        Document resultXML =  commonUtil.convertStringToDocument("<ROWS></ROWS>");
        Node rNodes = resultXML.getFirstChild();
        
        resCnt = ezQuestionService.resCount(vBrdId, vItemNo);
        
        Node rNode = resultXML.createElement("ROW");
        rNodes.appendChild(rNode);
        
        Node node = resultXML.createElement("STYLE");
        CDATASection CDATASection = resultXML.createCDATASection("background-color:#C4D4EB;");
        rNode.appendChild(CDATASection);
        
        node = resultXML.createElement("CELL");
        rNode.appendChild(node);
        
        Node nodeData = resultXML.createElement("VALUE");
        nodeData.setTextContent(egovMessageSource.getMessage("ezQuestion.t54"));
        node.appendChild(nodeData);

        nodeData = resultXML.createElement("DATA1");
        nodeData.setTextContent("TOT");
        node.appendChild(nodeData);

        node = resultXML.createElement("CELL");
        rNode.appendChild(node);

        nodeData = resultXML.createElement("VALUE");
        nodeData.setTextContent(resCnt + " " + egovMessageSource.getMessage("ezQuestion.t53"));
        node.appendChild(nodeData);

        node = resultXML.createElement("CELL");
        rNode.appendChild(node);

        nodeData = resultXML.createElement("VALUE");
        node.appendChild(nodeData);
        
        /** EZSP_GETQUESTION*/
        List<QstVO> qstVOList = ezQuestionService.getQuestion(vBrdId, vItemNo, vQuesNo);        
        for(QstVO qstVO : qstVOList){
        	questionNo = Integer.toString(qstVO.getQuestionNo());
        	quesContent = qstVO.getQuesContent();
        	multiSelect = qstVO.getMultiSelect();
        	answerType = Integer.toString(qstVO.getAnswerType());
        	/** EZSP_GETRESPERSONCNT*/
        	responseCnt = ezQuestionService.getResPersonCnt(Integer.parseInt(vBrdId), Integer.parseInt(vItemNo), Integer.parseInt(questionNo));

        	rNode = resultXML.createElement("ROW");
        	rNodes.appendChild(rNode);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");

        	if (multiSelect == "1")
        		CDATASection = resultXML.createCDATASection(quesContent + "[" + egovMessageSource.getMessage("ezQuestion.t55"));
        	else
        		CDATASection = resultXML.createCDATASection(quesContent);

        	nodeData.appendChild(CDATASection);
        	node.appendChild(nodeData);

        	nodeData = resultXML.createElement("DATA1");
        	nodeData.setTextContent("Q");
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	nodeData.setTextContent("");
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	nodeData.setTextContent("");
        	node.appendChild(nodeData);
        	/** EZSP_GETANSCNT*/
        	List<QstAnswerVO> qstAnswerVOList = ezQuestionService.getAnswerCnt(Integer.parseInt(vBrdId), Integer.parseInt(vItemNo), Integer.parseInt(questionNo));
        	int ansRCnt = qstAnswerVOList.size();
        	if(ansRCnt > 0){
        		/** dataAnswerProcessSP*/
        		int rCnt = 0, percent = 0, iCount = 0;
        		float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
        		for(QstAnswerVO qstAnswer : qstAnswerVOList){
        			iCount ++;
        			rCnt = ezQuestionService.pollRespCnt(Integer.parseInt(vBrdId), Integer.parseInt(vItemNo), Integer.parseInt(questionNo), iCount);

        			fRCnt = rCnt;
        			fResponseCnt = responseCnt;
        			if(responseCnt <= 0){
        				percent=0;
        			}else{
        				fPercent = fRCnt / responseCnt;
        				percent = Math.round(fPercent*100);
        			}
        			rNode = resultXML.createElement("ROW");

        			node = resultXML.createElement("CELL");

        			nodeData = resultXML.createElement("VALUE");
        			CDATASection = resultXML.createCDATASection("질문"+qstAnswer.getAnswerContent());
        			nodeData.appendChild(CDATASection);
        			node.appendChild(nodeData);

        			nodeData= resultXML.createElement("DATA1");
        			nodeData.setTextContent("A");
        			node.appendChild(nodeData);

        			rNode.appendChild(node);

        			node = resultXML.createElement("CELL");

        			nodeData = resultXML.createElement("VALUE");
        			nodeData.setTextContent(rCnt + " " + egovMessageSource.getMessage("ezQuestion.t53"));
        			node.appendChild(nodeData);

        			rNode.appendChild(node);

        			node = resultXML.createElement("CELL");

        			nodeData = resultXML.createElement("VALUE");
        			nodeData.setTextContent(percent+ "%");
        			node.appendChild(nodeData);

        			rNode.appendChild(node);
        			rNodes.appendChild(rNode);
        		}
        	}
        }
        Node listView = resultXML.createElement("LISTVIEWDATA");

        Node hNodes = resultXML.createElement("HEADERS");
        listView.appendChild(hNodes);

        nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t46"));
        nodeData.appendChild(node);


        node = resultXML.createElement("WIDTH");
        node.setTextContent("60");
        nodeData.appendChild(node);

        nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t47"));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);


        nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t48"));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);

        listView.appendChild(rNodes);
        resultXML.appendChild(listView);
        
        return commonUtil.convertDocumentToString(resultXML);
	}
	
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstCallAnalysisDept4.do" , method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstCallAnalysisDept4(HttpServletRequest request) throws Exception{
		String vBrdId="", vItemNo="", vQuesNo="", sort="", sTotal = "0";
		String questionNo = "", quesContent = "", answerObjecivity ="", responseUserDeptName="", qCount="";
		int responseCnt = 0, iDataCount=0;
		float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
		String title="", answer="", qPercent="", responNum="";
		
		
		if (request.getParameter("brd_id") != null)
			vBrdId = request.getParameter("brd_id");
        if (request.getParameter("item_no") != null)
        	vItemNo = request.getParameter("item_no");
        if (request.getParameter("ques_no") != null)
        	vQuesNo = request.getParameter("ques_no");
        if(vQuesNo.length()==0)
        	vQuesNo="0";
        /** EZSP_ANALYSISCOUNT*/
        responNum = ezQuestionService.analysisCount(vItemNo,vQuesNo);

        Document resultXML =  commonUtil.convertStringToDocument("<ROWS></ROWS>");
        Node rNodes = resultXML.getFirstChild();
        Node rNode = resultXML.createElement("ROW");
        
        /** EZSP_POLLGETSEARCH*/
        List<QstResponseVO> responseVOList = ezQuestionService.gwPollGetSearch(vItemNo, vQuesNo);
        for(QstResponseVO qstResponseVO : responseVOList){
        	iDataCount++;
        	questionNo = Integer.toString(qstResponseVO.getQuestionNo());
        	responseUserDeptName = qstResponseVO.getResponseUserDeptName();
        	quesContent = qstResponseVO.getQuesContent();
        	answer = qstResponseVO.getAnswer();
        	answerObjecivity = Integer.toString(qstResponseVO.getAnswerObjectivity());
        	qCount = Integer.toString(qstResponseVO.getqCount());
        	
        	title = qstResponseVO.getResponseUserDeptName();
        	if(responseUserDeptName == null){
        		title = egovMessageSource.getMessage("ezQuestion.t56");
        	}
        	qPercent="w";
        	sort="A";
        	if(responseUserDeptName == null || responseUserDeptName.toUpperCase() == "NULL"){
        		title = " [" + egovMessageSource.getMessage("ezQuestion.t57") + answer;
        		qPercent = "";
        		sort="Q";
        	}
        	if(answerObjecivity.equals("0"))
        		answerObjecivity ="0";
        	if(Integer.parseInt(answerObjecivity)==0){
        		title = quesContent;
        		sTotal = qCount;
        		qPercent = "";
        	}
        	if(questionNo.equals("0")){
        		title = egovMessageSource.getMessage("ezQuestion.t54");
        		qPercent = "";
        	}
        	fRCnt = Integer.parseInt(qCount);
			fResponseCnt = Integer.parseInt(sTotal);
			if(fResponseCnt == 0){
				fPercent = fRCnt;
			}else{
				fPercent = fRCnt/fResponseCnt;
			}
			qPercent = Math.round(fPercent*100) + "%";
        	/** EZSP_GETRESPERSONCNT*/
        	responseCnt = ezQuestionService.getResPersonCnt(Integer.parseInt(vBrdId), Integer.parseInt(vItemNo), Integer.parseInt(questionNo));

        	rNode = resultXML.createElement("ROW");
        	rNodes.appendChild(rNode);

        	Node node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	Node nodeData = resultXML.createElement("VALUE");
        	nodeData.setTextContent(title);
        	node.appendChild(nodeData);

        	nodeData = resultXML.createElement("DATA1");
        	nodeData.setTextContent(sort);
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	if(questionNo.equals("0"))
        		nodeData.setTextContent(responNum + egovMessageSource.getMessage("ezQuestion.t53"));
        	else
        		nodeData.setTextContent(qCount + egovMessageSource.getMessage("ezQuestion.t53"));
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	if(qPercent.equals("0%") != true)
        		nodeData.setTextContent(qPercent);
        	node.appendChild(nodeData);
        }
        Node listView = resultXML.createElement("LISTVIEWDATA");

        Node hNodes = resultXML.createElement("HEADERS");
        listView.appendChild(hNodes);

        Node nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        Node node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t46"));
        nodeData.appendChild(node);


        node = resultXML.createElement("WIDTH");
        node.setTextContent("60");
        nodeData.appendChild(node);

        nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t47"));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);


        nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t48"));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);

        listView.appendChild(rNodes);
        resultXML.appendChild(listView);
        
        return commonUtil.convertDocumentToString(resultXML);
	}
	
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstCallAnalysisPos2.do" , method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstCallAnalysisPos2(HttpServletRequest request) throws Exception{
		String vBrdId="", vItemNo="", vQuesNo="", sort="", sTotal = "0";
		String questionNo = "", quesContent = "", answerObjecivity ="", responseUserPosition="", qCount="";
		int responseCnt = 0, iDataCount=0;
		float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
		String title="", answer="", qPercent="", responNum="";
		
		
		if (request.getParameter("brd_id") != null)
			vBrdId = request.getParameter("brd_id");
        if (request.getParameter("item_no") != null)
        	vItemNo = request.getParameter("item_no");
        if (request.getParameter("ques_no") != null)
        	vQuesNo = request.getParameter("ques_no");
        if(vQuesNo.length()==0)
        	vQuesNo="0";
        /** EZSP_ANALYSISCOUNT*/
        responNum = ezQuestionService.analysisCount(vItemNo,vQuesNo);

        Document resultXML =  commonUtil.convertStringToDocument("<ROWS></ROWS>");
        Node rNodes = resultXML.getFirstChild();
        Node rNode = resultXML.createElement("ROW");
        
        /** EZSP_GWPOLLPOSITIONSEARCH*/
        List<QstResponseVO> responseVOList = ezQuestionService.gwPollPositionSearch(vItemNo, vQuesNo);
        for(QstResponseVO qstResponseVO : responseVOList){
        	iDataCount++;
        	questionNo = Integer.toString(qstResponseVO.getQuestionNo());
        	responseUserPosition = qstResponseVO.getResponseUserPosition();
        	quesContent = qstResponseVO.getQuesContent();
        	answer = qstResponseVO.getAnswer();
        	answerObjecivity = Integer.toString(qstResponseVO.getAnswerObjectivity());
        	qCount = Integer.toString(qstResponseVO.getqCount());
        	
        	
        	title = qstResponseVO.getResponseUserPosition();
        	if(responseUserPosition == null){
        		title = egovMessageSource.getMessage("ezQuestion.t56");
        	}
        	qPercent="w";
        	sort="A";
        	if(responseUserPosition == null || responseUserPosition.toUpperCase() == "NULL"){
        		title = " [" + egovMessageSource.getMessage("ezQuestion.t57") + answer;
        		qPercent = "";
        		sort="Q";
        	}
        	if(answerObjecivity.equals("0"))
        		answerObjecivity ="0";
        	if(Integer.parseInt(answerObjecivity)==0){
        		title = quesContent;
        		sTotal = qCount;
        		qPercent = "";
        	}
        	if(questionNo.equals("0")){
        		title = egovMessageSource.getMessage("ezQuestion.t54");
        		qPercent = "";
        	}
        	fRCnt = Integer.parseInt(qCount);
			fResponseCnt = Integer.parseInt(sTotal);
			if(fResponseCnt == 0){
				fPercent = fRCnt;
			}else{
				fPercent = fRCnt/fResponseCnt;
			}
			qPercent = Math.round(fPercent*100) + "%";
        	/** EZSP_GETRESPERSONCNT*/
        	responseCnt = ezQuestionService.getResPersonCnt(Integer.parseInt(vBrdId), Integer.parseInt(vItemNo), Integer.parseInt(questionNo));

        	rNode = resultXML.createElement("ROW");
        	rNodes.appendChild(rNode);

        	Node node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	Node nodeData = resultXML.createElement("VALUE");
        	nodeData.setTextContent(title);
        	node.appendChild(nodeData);

        	nodeData = resultXML.createElement("DATA1");
        	nodeData.setTextContent(sort);
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	if(questionNo.equals("0"))
        		nodeData.setTextContent(responNum + egovMessageSource.getMessage("ezQuestion.t53"));
        	else
        		nodeData.setTextContent(qCount + egovMessageSource.getMessage("ezQuestion.t53"));
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	if(qPercent.equals("0%") != true)
        		nodeData.setTextContent(qPercent);
        	node.appendChild(nodeData);
        }
        Node listView = resultXML.createElement("LISTVIEWDATA");

        Node hNodes = resultXML.createElement("HEADERS");
        listView.appendChild(hNodes);

        Node nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        Node node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t46"));
        nodeData.appendChild(node);


        node = resultXML.createElement("WIDTH");
        node.setTextContent("60");
        nodeData.appendChild(node);

        nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t47"));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);


        nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t48"));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);

        listView.appendChild(rNodes);
        resultXML.appendChild(listView);
        
		return commonUtil.convertDocumentToString(resultXML);
	}
	
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstCallAnalysisJikgub2.do" , method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstCallAnalysisJikgub2(HttpServletRequest request) throws Exception{
		String vBrdId="", vItemNo="", vQuesNo="", sort="", sTotal = "0";
		String questionNo = "", quesContent = "", answerObjecivity ="", responseJikgub="", qCount="";
		int responseCnt = 0, iDataCount=0;
		float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
		String title="", answer="", qPercent="", responNum="";
		
		
		if (request.getParameter("brd_id") != null)
			vBrdId = request.getParameter("brd_id");
        if (request.getParameter("item_no") != null)
        	vItemNo = request.getParameter("item_no");
        if (request.getParameter("ques_no") != null)
        	vQuesNo = request.getParameter("ques_no");
        if(vQuesNo.length()==0)
        	vQuesNo="0";
        /** EZSP_ANALYSISCOUNT*/
        responNum = ezQuestionService.analysisCount(vItemNo,vQuesNo);

        Document resultXML =  commonUtil.convertStringToDocument("<ROWS></ROWS>");
        Node rNodes = resultXML.getFirstChild();
        Node rNode = resultXML.createElement("ROW");
        
        /** EZSP_GWPOLLJIKGUBSEARCH*/
        List<QstResponseVO> responseVOList = ezQuestionService.gwPollJikgubSearch(vItemNo, vQuesNo);
        for(QstResponseVO qstResponseVO : responseVOList){
        	iDataCount++;
        	questionNo = Integer.toString(qstResponseVO.getQuestionNo());
        	responseJikgub = qstResponseVO.getResponseUserJikgub();
        	quesContent = qstResponseVO.getQuesContent();
        	answer = qstResponseVO.getAnswer();
        	answerObjecivity = Integer.toString(qstResponseVO.getAnswerObjectivity());
        	qCount = Integer.toString(qstResponseVO.getqCount());
        	
        	
        	title = qstResponseVO.getResponseUserJikgub();
        	if(responseJikgub == null){
        		title = egovMessageSource.getMessage("ezQuestion.t56");
        	}
        	qPercent="w";
        	sort="A";
        	if(responseJikgub == null || responseJikgub.toUpperCase() == "NULL"){
        		title = " [" + egovMessageSource.getMessage("ezQuestion.t57") + answer;
        		qPercent = "";
        		sort="Q";
        	}
        	if(answerObjecivity.equals("0"))
        		answerObjecivity ="0";
        	if(Integer.parseInt(answerObjecivity)==0){
        		title = quesContent;
        		sTotal = qCount;
        		qPercent = "";
        	}
        	if(questionNo.equals("0")){
        		title = egovMessageSource.getMessage("ezQuestion.t54");
        		qPercent = "";
        	}
        	fRCnt = Integer.parseInt(qCount);
			fResponseCnt = Integer.parseInt(sTotal);
			if(fResponseCnt == 0){
				fPercent = fRCnt;
			}else{
				fPercent = fRCnt/fResponseCnt;
			}
			qPercent = Math.round(fPercent*100) + "%";
        	/** EZSP_GETRESPERSONCNT*/
        	responseCnt = ezQuestionService.getResPersonCnt(Integer.parseInt(vBrdId), Integer.parseInt(vItemNo), Integer.parseInt(questionNo));

        	rNode = resultXML.createElement("ROW");
        	rNodes.appendChild(rNode);

        	Node node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	Node nodeData = resultXML.createElement("VALUE");
        	nodeData.setTextContent(title);
        	node.appendChild(nodeData);

        	nodeData = resultXML.createElement("DATA1");
        	nodeData.setTextContent(sort);
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	if(questionNo.equals("0"))
        		nodeData.setTextContent(responNum + egovMessageSource.getMessage("ezQuestion.t53"));
        	else
        		nodeData.setTextContent(qCount + egovMessageSource.getMessage("ezQuestion.t53"));
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	if(qPercent.equals("0%") != true)
        		nodeData.setTextContent(qPercent);
        	node.appendChild(nodeData);
        }
        Node listView = resultXML.createElement("LISTVIEWDATA");

        Node hNodes = resultXML.createElement("HEADERS");
        listView.appendChild(hNodes);

        Node nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        Node node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t46"));
        nodeData.appendChild(node);


        node = resultXML.createElement("WIDTH");
        node.setTextContent("60");
        nodeData.appendChild(node);

        nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t47"));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);


        nodeData = resultXML.createElement("HEADER");
        hNodes.appendChild(nodeData);

        node = resultXML.createElement("STYLE");
        node.setTextContent("background-color:#C4D4EB;");
        nodeData.appendChild(node);

        node = resultXML.createElement("NAME");
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t48"));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);

        listView.appendChild(rNodes);
        resultXML.appendChild(listView);
        
		return commonUtil.convertDocumentToString(resultXML);
	}
	
	@SuppressWarnings({ "unused", "resource" })
	@RequestMapping(value = "/ezQuestion/resultTotalSave.do")
	public void resultTotalSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brforeQuestionNo="", questionNo = "", qUser="", comma="";
		String answer="", answerStr="";
		String itemNo="", headerInfo="";
		int maxNum=0, sNo=0;
		String qNum = "0";
		String Rid = "";
        String strData = "", strKey = "";
        
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("report");
		Row row;
		Cell cell;
		
		if(request.getParameter("item_no") != null){
			itemNo = request.getParameter("item_no");
		}
		
		if(itemNo != ""){
			row = sheet.createRow(0);
			headerInfo = ";" + egovMessageSource.getMessage("ezQuestion.t552") + "\r\n";
			cell = row.createCell(0);
			cell.setCellValue(headerInfo);
            headerInfo = egovMessageSource.getMessage("ezQuestion.t553");
            
			/** EZSP_GETQUESTIONNOCNT*/
            String strMaxNum = ezQuestionService.getQuestionNoCnt(itemNo);
            if(strMaxNum==null){
            	maxNum = 0;
            }else{
            	maxNum = Integer.parseInt(strMaxNum);
            }
			
			if(maxNum != 0){
				for(int i=1; i<maxNum+1; i++){
					headerInfo = headerInfo + "," + i;
				}
				headerInfo = headerInfo + "\r\n";
				
				List<QstResponseVO> qstResponseVOList = ezQuestionService.getRespersonForResultTotalSave(Integer.parseInt(itemNo));
				
				Hashtable<String, Object> tbl = new Hashtable<String, Object>();
				
				for(QstResponseVO qstResponseVO : qstResponseVOList){
					brforeQuestionNo = Integer.toString(qstResponseVO.getQuestionNo()); 
					answer="";
					questionNo="";
					qUser=qstResponseVO.getResponseUserName();
					strKey=qstResponseVO.getResponseUserId()+","+qUser+","+qstResponseVO.getResponseUserPosition()+","+qstResponseVO.getResponseUserDeptName();
		
					if(qstResponseVO.getQuestionNo() != Integer.parseInt(qNum) || Rid != qstResponseVO.getResponseUserId()){
						comma = ",";
					}else{
						comma = "- -";
					}
					Rid = qstResponseVO.getResponseUserId();
					if (qstResponseVO.getAnswerObjectivity() == 0){
						answer = comma + qstResponseVO.getAnswerSubjectivity().replace("," , "，");
						answer = answer.replace(";", "；");
						answer = answer.replace("\"", " &quout;");
						answer = answer.replace("\n", " ");
						answer = answer.replace("\r", " ");
					}else{
						answer = comma + qstResponseVO.getAnswerObjectivity();
					}
					if(tbl.isEmpty()){
						strData = answer;
						tbl.put(strKey, strData);
					}else{
						if(tbl.get(strKey) == null){
							strData = answer;
							tbl.put(strKey,  strData);
						}else{
							strData = (String) tbl.get(strKey);
							strData = strData + answer;
							tbl.remove(strKey);
							tbl.put(strKey, strData);
						}
					}
					qNum = Integer.toString(qstResponseVO.getQuestionNo());
				}
				String[] header = headerInfo.split(",");
				row = sheet.createRow(1);
				for(int i=0; i<header.length; i++){
					cell = row.createCell(i);
					cell.setCellValue(header[i]);
				}
				if(qUser != ""){
					for(String key : tbl.keySet()){
						sNo=sNo+1;
						answerStr = answerStr + sNo + "," + key + tbl.get(key) + "\r\n";
						row = sheet.createRow(sNo+1);
						cell = row.createCell(0);
						cell.setCellValue(sNo);
						int i =1;
						for(String keySplit : key.split(",")){
							cell = row.createCell(i);
							cell.setCellValue(keySplit);
							i++;
						}
						for(String valueSplit : ((String)tbl.get(key)).substring(1).split(",")){
							cell = row.createCell(i);
							cell.setCellValue(valueSplit);
							i++;
						}
					}
				}else{
					for(String key : tbl.keySet()){
						sNo=sNo+1;
						answerStr = answerStr + sNo + ",,,," + tbl.get(key) + "\r\n";
						row = sheet.createRow(sNo+1);
						cell = row.createCell(0);
						cell.setCellValue(sNo);
						int i =1;
						for(String keySplit : key.split(",")){
							cell = row.createCell(i);
							cell.setCellValue(keySplit);
							i++;
						}
						for(String valueSplit : ((String)tbl.get(key)).substring(1).split(",")){
							cell = row.createCell(i);
							cell.setCellValue(valueSplit);
							i++;
						}
					}
				}
				tbl.clear();
				tbl = null;
			}
		}
		response.setHeader("Content-Disposition", "attachment; filename=\"" + "report" + ".xls\"");
		workbook.write(response.getOutputStream());
	}
}
