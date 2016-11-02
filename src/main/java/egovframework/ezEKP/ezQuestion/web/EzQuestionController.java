package egovframework.ezEKP.ezQuestion.web;

import java.io.File;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPortal.service.impl.EzPortalAdminServiceImpl;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezQuestion.vo.QstAddVO;
import egovframework.ezEKP.ezQuestion.vo.QstAnswerVO;
import egovframework.ezEKP.ezQuestion.vo.QstAttachVO;
import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QstDeleteAttachUrlVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstRangeSelectVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponsePersonVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponseVO;
import egovframework.ezEKP.ezQuestion.vo.QstReuseQuestionVO;
import egovframework.ezEKP.ezQuestion.vo.QstStep1VO;
import egovframework.ezEKP.ezQuestion.vo.QstTempSaveVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 전자설문
 * @author 오픈솔루션팀 이효진, 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    이효진, 지정석    신규작성
 *
 * @see
 */

@Controller
public class EzQuestionController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EzQuestionController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;	

	@Resource(name="EzQuestionService")
	private EzQuestionService ezQuestionService;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	//TODO 2016-05-02 이효진 formatter 부분 EgovDateUtil 로 변경해야함
	/**
	 * 전자설문 설문리스트 메인 화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstList.do")
	public String qstList(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, QstListVO qstListVO) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);

		String brdID = "5", title = "", responseRange = "", postDate = "", pollEndDate = "", lang = "";
		String currPage = "1";
		int pageSize = 15;
		qstListVO.setUserID(loginVO.getId());
		
		if(request.getParameter("brdID") != null){
			brdID = request.getParameter("brdID");
		}
		if(request.getParameter("title") != null){
			title = request.getParameter("title");
		}
		if(request.getParameter("responseRange") != null){
			responseRange = request.getParameter("responseRange");
		}
		if(request.getParameter("postDate") != null){
			postDate = request.getParameter("postDate");
		}
		if(request.getParameter("pollEndDate") != null){
			pollEndDate = request.getParameter("pollEndDate");
		}
		if(request.getParameter("lang") != null){
			lang = request.getParameter("lang");
		}
		if(request.getParameter("currPage") != null){
			currPage = request.getParameter("currPage");
		}
			
		qstListVO.setBrdID(Integer.parseInt(brdID));
		qstListVO.setTitle(title);
		qstListVO.setResponseRange(responseRange);
		qstListVO.setPostDate(postDate);
		qstListVO.setPollEndDate(pollEndDate);
		qstListVO.setLang(lang);
		qstListVO.setCurrPage(Integer.parseInt(currPage));
		qstListVO.setPageSize(pageSize);
		
		String receve = "brdID=" + qstListVO.getBrdID() +
						"&title=" + commonUtil.cleanValue(qstListVO.getTitle()) +
		                "&responseRange=" + qstListVO.getResponseRange() +
		                "&postDate=" + qstListVO.getPostDate() +
		                "&pollEndDate=" + qstListVO.getPollEndDate() +
		                "&currPage=" + qstListVO.getCurrPage();
		
		qstListVO.setTotalCnt(ezQuestionService.getQstListCnt(qstListVO));
		
		if(qstListVO.getTotalPage()==0){
			qstListVO.setTotalPage((qstListVO.getTotalCnt()+qstListVO.getPageSize()-1)/qstListVO.getPageSize());
		}
		
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
	
	/**
	 * 전자설문 설문리스트 설문 정보 호출, 그에 따른 화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/pollOpen.do", produces="text/xml; charset=utf-8")
	public void pollOpen(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response, QstUserPollItemVO qstUserPollItemVO, QstUserPermissionVO qstUserPermissionVO) throws Exception{
		String receve = "brdID=" + request.getParameter("brdID") +
						"&itemNo=" + request.getParameter("itemNo") +
		                "&title=" + commonUtil.cleanValue(request.getParameter("title")) +
		                "&responseRange=" + request.getParameter("responseRange") +
		                "&postDate=" + request.getParameter("postDate") +
		                "&pollEndDate=" + request.getParameter("pollEndDate") +
		                "&currPage=" + request.getParameter("currPage");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String userID = loginVO.getId();
		/**UserPollItem*/
		qstUserPollItemVO.setBrdID(Integer.parseInt(request.getParameter("brdID")));
		qstUserPollItemVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		qstUserPollItemVO=ezQuestionService.getUserPollItem(qstUserPollItemVO);
		/** 결과값없으면 Error처리*/
		if(qstUserPollItemVO.getTitle().equals(null)){
			response.sendRedirect("/error.do"); //나중에 에러처리찾아서 주소만바꾸면됨
		}
		/**UserPermission*/
		qstUserPermissionVO.setBrdID(Integer.parseInt(request.getParameter("brdID")));
		qstUserPermissionVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
		/**ResponseCnt*/
		int responseCnt = ezQuestionService.getUserResponseCnt(qstUserPermissionVO,userID);
		/** 날짜계산*/
		boolean endPoll = false;
		Date sysDate=new Date();
		java.text.DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		
		if(formatter.parse(qstUserPollItemVO.getPollEndDate()).compareTo(sysDate)<0){
			endPoll = true;
		}
		if(qstUserPermissionVO.getEndFlg().equals('1')){
			endPoll = true;
		}
		/**UserIDAdmin*/
		boolean adminYN = false;
		String rsUserID = qstUserPollItemVO.getUserID();
		String userIDAdmin = ezQuestionService.getUserIDAdmin(Integer.parseInt(request.getParameter("brdID")));

		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");		
		
		if(endPoll == false){
			if(responseCnt <= 0){
				response.getWriter().write("<script language='javascript'>");
				response.getWriter().write("window.location.href='/ezQuestion/qstResponse.do?" + receve + "';");
				response.getWriter().write("</script>");
				response.getWriter().flush();
			}else if(qstUserPermissionVO.getPublicResultFlg().equals("1")){
				if(qstUserPermissionVO.getMultiResponseFlg().equals("1")){
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("window.open('/ezQuestion/qstMsgAdminConfirm.do?" + receve + "', '', 'height=205px,width=330px, status = no, toolbar=no, menubar=no,location=no, resizable=1');");
					response.getWriter().write("window.location.href='/ezQuestion/qstList.do?brdID=5';");
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
				
				if(userIDAdmin != null){
					if(userID == userIDAdmin){
						adminYN = true;
					}
				}
				
				if(userID.equals(rsUserID) || adminYN == true){
					if(qstUserPermissionVO.getMultiResponseFlg().equals("1")){
						response.getWriter().write("<script language='javascript'>");
						response.getWriter().write("window.open('qstMsgAdminConfirm.do?" + receve + "', '', 'height=205px,width=330px, status = no, toolbar=no, menubar=no,location=no, resizable=1');");
						response.getWriter().write("</script>");
						response.getWriter().write("window.location.href='/ezQuestion/qstList.do?brdID=5';");
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
						response.getWriter().write("window.open('qstMsgAdminConfirm.do?" + receve + "', '', 'height=205px,width=330px, status = no, toolbar=no, menubar=no,location=no, resizable=1');");
						response.getWriter().write("window.location.href='/ezQuestion/qstList.do?brdID=5';");
						response.getWriter().write("</script>");
						response.getWriter().flush();
					}else{
						response.getWriter().write("<script language='javascript'>");
						response.getWriter().write("	alert('" + egovMessageSource.getMessage("ezQuestion.t112", locale) + "');");
						response.getWriter().write(" window.location.href = '/ezQuestion/qstList.do?brdID=5'");						
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
				
				if(userIDAdmin != null){
					if(userID == userIDAdmin){
						adminYN = true;
					}
				}
				if (rsUserID.equals(userID) || adminYN == true){
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("window.location.href='/ezQuestion/qstResult.do?" + receve + "';");
					response.getWriter().write("</script>");
					response.getWriter().flush();
				}else{
					response.getWriter().write("<script language='javascript'>");
					response.getWriter().write("alert('" + egovMessageSource.getMessage("ezQuestion.t112", locale) + "');");
					response.getWriter().write("window.location.href='/ezQuestion/qstList.do?brdID=5';");
					response.getWriter().write("</script>");
					response.getWriter().flush();
				}
			}
		}
	}
	
	/**
	 * 전자설문 설문리스트 유저권한 정보 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstCallUsersPollStatus.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qstCallUsersPollStatus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, QstUserPollItemVO qstUserPollItemVO, QstUserPermissionVO qstUserPermissionVO) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brdID ="", itemNo = ""; 
		boolean endPoll = false;
		String endPollYN = "";
		String responseYN = "";
		String resultOpenYN = "";
		String multiResYN = "";
		String writeYN = "";
		String adminYN = "";
		int responseCnt = 0;
		
		if (request.getParameter("brdID") != null){
            brdID = request.getParameter("brdID");
		}
        if (request.getParameter("itemNo") != null){
            itemNo = request.getParameter("itemNo");
        }
		
		adminYN = "N";
		String userIDAdmin = ezQuestionService.getUserIDAdmin(Integer.parseInt(brdID));
		
		if(userIDAdmin != null){
			if(loginVO.getId().equals(userIDAdmin)){
				adminYN = "Y";
			}
		}
		
		if(loginVO.getRollInfo().toUpperCase().indexOf("C=1") > -1 || loginVO.getRollInfo().toUpperCase().indexOf("K=1") > -1 || loginVO.getRollInfo().toUpperCase().indexOf("I=1") > -1){ 
			adminYN = "Y";
		}
		
		qstUserPollItemVO.setBrdID(Integer.parseInt(brdID));
		qstUserPollItemVO.setItemNo(Integer.parseInt(itemNo));
		qstUserPollItemVO = ezQuestionService.getUserPollItem(qstUserPollItemVO);
		
		qstUserPermissionVO.setBrdID(Integer.parseInt(brdID));
		qstUserPermissionVO.setItemNo(Integer.parseInt(itemNo));
		qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
		
		responseCnt = ezQuestionService.getUserResponseCnt(qstUserPermissionVO,loginVO.getId());
		
		endPoll = false;
		Date sysDate=new Date();
		java.text.DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		
		if(formatter.parse(qstUserPollItemVO.getPollEndDate()).compareTo(sysDate) < 0){
			endPoll = true;
		}
		if(qstUserPermissionVO.getEndFlg().equals("1")){
			endPoll = true;
		}
		if(loginVO.getId().equals(qstUserPollItemVO.getUserID())){
			writeYN = "Y";
		}else{
			writeYN = "N";
		}
		if(endPoll == false){
			endPollYN = "N";
		}else{
			endPollYN = "Y";
		}
		if(responseCnt <=0){
			responseYN = "N";
		}else{
			responseYN = "Y";
		}
		if(qstUserPermissionVO.getPublicResultFlg().equals("1")){
			resultOpenYN = "Y";
		}else{
			resultOpenYN = "N";
		}
		if(qstUserPermissionVO.getMultiResponseFlg().equals("1")){
			multiResYN = "Y";
		}else{
			multiResYN = "N";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("endPollYN", endPollYN);
		map.put("writeYN", writeYN);
		map.put("responseYN", responseYN);
		map.put("resultOpenYN", resultOpenYN);
		map.put("multiResYN", multiResYN);
		map.put("adminYN", adminYN);
		
		return map;
	}
	
	/**
	 * 전자설문 설문리스트 진행중인 설문화면 호출 함수
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResponse.do")
	public String qstResponse(@CookieValue("loginCookie") String loginCookie, Locale locale, ModelMap model, HttpServletRequest request, QstVO qstVO) throws Exception{
		String receve = "brdID=" + request.getParameter("brdID") +
		                "&title=" + request.getParameter("title") +
		                "&responseRange=" + request.getParameter("responseRange") +
		                "&postDate=" + request.getParameter("postDate") +
		                "&pollEndDate=" + request.getParameter("pollEndDate") +
		                "&currPage=" + request.getParameter("currPage");

		qstVO.setBrdID(Integer.parseInt(request.getParameter("brdID")));
		qstVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String userID = loginVO.getId();
		boolean multiResponseOK = false;
		int responseCnt = 0;
	
		/**UserPermission*/
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		qstUserPermissionVO.setBrdID(Integer.parseInt(request.getParameter("brdID")));
		qstUserPermissionVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		qstUserPermissionVO=ezQuestionService.getUserPermission(qstUserPermissionVO);
		
		if(qstUserPermissionVO.getMultiResponseFlg().equals('1')){
			multiResponseOK = true;
		}else{
			if(ezQuestionService.getResponseDateCnt(qstUserPermissionVO,userID)!=0){
				multiResponseOK = false;
			}else{
				multiResponseOK = true;
			}
		}
		
		String userIDAdmin = ezQuestionService.getUserIDAdmin(Integer.parseInt(request.getParameter("brdID")));
		boolean adminYN = false;
		
		if(userIDAdmin != null){
			if(userID == userIDAdmin)
				adminYN = true;
		}
		
		responseCnt = ezQuestionService.resCount(request.getParameter("brdID"),request.getParameter("itemNo"));
		
		QstUserPollItemVO qstUserPollItemVO = new QstUserPollItemVO();
		qstUserPollItemVO.setBrdID(Integer.parseInt(request.getParameter("brdID")));
		qstUserPollItemVO.setItemNo(Integer.parseInt(request.getParameter("itemNo")));
		qstUserPollItemVO=ezQuestionService.getUserPollItem(qstUserPollItemVO);
		
		if(qstUserPollItemVO.getUserID() != userID){
			qstUserPollItemVO.setReadCnt(qstUserPollItemVO.getReadCnt() + 1);
			ezQuestionService.updateReadCnt(qstUserPollItemVO);
		}
		
		int readDateCnt = ezQuestionService.getReadDateItem(qstUserPollItemVO,userID);
		
		Date sysDate=new Date();
		java.text.DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		
		if(readDateCnt > 0){
			ezQuestionService.updateReadDate(qstUserPollItemVO, formatter.format(sysDate), userID);
		}else{
			ezQuestionService.insertItemRead(loginVO, qstUserPollItemVO, formatter.format(sysDate));
		}
		
		List<QstVO> questionList = ezQuestionService.getQuestionForResponse(qstVO);

		String strResult = "<SUBDATA>";
		Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
		Node data = doc.createElement("DATA");
		doc.appendChild(data);

		if(questionList != null){
			int iQueCount = 0;
			String strTagData = "";
			
			for(QstVO question : questionList){
				iQueCount++;
				Node row = doc.createElement("ROW");
				Node qst = doc.createElement("QST");
				Node brdID = doc.createElement("BRD_ID");
				Node itemNo = doc.createElement("ITEM_NO");
				Node questionNo = doc.createElement("QUESTION_NO");
				Node answerType = doc.createElement("ANSWERTYPE");
				Node answerViewType = doc.createElement("ANSWERVIEWTYPE");
				Node multiSelect = doc.createElement("MULTISELECT");
				Node quesSn = doc.createElement("QUES_SN");
				qst.appendChild(doc.createTextNode(egovMessageSource.getMessage("ezQuestion.t333", locale) + (iQueCount) + ":" + commonUtil.cleanValue(question.getQuesContent()) + getAttachList(Integer.toString(question.getQuestionNo()), "0", question.getBrdID(), question.getItemNo())));
				brdID.appendChild(doc.createTextNode(Integer.toString(question.getBrdID())));
				itemNo.appendChild(doc.createTextNode(Integer.toString(question.getItemNo())));
				questionNo.appendChild(doc.createTextNode(Integer.toString(question.getQuestionNo())));
				answerType.appendChild(doc.createTextNode(Integer.toString(question.getAnswerType())));
				answerViewType.appendChild(doc.createTextNode(Integer.toString(question.getAnswerViewType())));
				multiSelect.appendChild(doc.createTextNode(question.getMultiSelect()));
				quesSn.appendChild(doc.createTextNode(Integer.toString(question.getQuesSn())));

				row.appendChild(qst);
				row.appendChild(brdID);
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
					strTagData +=		"<textarea style=\"Width:100%;height:85;\" id=\"txt" + question.getQuestionNo() + "\" name=\"txt" + question.getQuestionNo() + "\"></textarea></td>";
                    strTagData += "</tr>";
                    Element subRow = doc.createElement("SUBROW");
                    subRow.appendChild(doc.createTextNode(strTagData));
                    row.appendChild(subRow);
                    dataSubProcess(question.getBrdID(), question.getItemNo(), question.getQuestionNo(), question.getAnswerType(), question.getMultiSelect(), row, doc);
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
					
					dataSubProcess(question.getBrdID(), question.getItemNo(), question.getQuestionNo(), question.getAnswerType(), question.getMultiSelect(), row, doc);
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
	
	/**
	 * 전자설문 설문리스트 설문조사 하나의 글에 대한 등록 실행 , 설문리스트 메인 화면 호출 함수
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResponseOk.do")
	public void qstResponseOk(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response, QstResponseVO qstResponseVO) throws Exception{        
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brdID = "5", itemNo = "", responseUserIp = "", vPermission = "", vResponseRange = "", receve = "";
		String userID = "", userName = "", email = "", deptID = "", depart = "", position = "", jikGub = "", gender = "1", age = "29";
		String userName2 = "", depart2 = "", position2 = "", jikGub2 = "";
		String tableAnswer = "";
        int eleCnt = 0;
        
        
    	eleCnt = Integer.parseInt(request.getParameter("hidEleCnt"));		
		brdID = request.getParameter("brdID");
		itemNo = request.getParameter("itemNo");
		tableAnswer = request.getParameter("tableAnswer");
		responseUserIp = request.getRemoteAddr();
		receve = request.getParameter("receve").replace("&amp;", "&");
		
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		qstUserPermissionVO.setBrdID(Integer.parseInt(brdID));
		qstUserPermissionVO.setItemNo(Integer.parseInt(itemNo));
		
		/** EZSP_GETRESPONSERANGE*/
		qstUserPermissionVO = ezQuestionService.getResponseRange(qstUserPermissionVO);
		vPermission = qstUserPermissionVO.getPublicFlg();
		vResponseRange = qstUserPermissionVO.getResponseRange();
		
		if (vPermission != "1"){
			userID = loginVO.getId();
			userName = loginVO.getDisplayName1();
			email = loginVO.getEmail();
			deptID = loginVO.getDeptID();
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
			userID = loginVO.getId();
			userName = "";
			email = "";
			deptID = "";
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
		
		if (userID.equals("")){
			response.getWriter().write("<script language='javascript'>\n");
			response.getWriter().write("	alert('" + egovMessageSource.getMessage("ezQuestion.t360",locale) + "');\n");
			response.getWriter().write("	history.back();\n");
			response.getWriter().write("</script>\n");
			response.getWriter().flush();
        }
		
		qstResponseVO.setBrdID(Integer.parseInt(brdID));
		qstResponseVO.setItemNo(Integer.parseInt(itemNo));
		qstResponseVO.setResponseUserID(userID);
		qstResponseVO.setResponseUserName(userName);
		qstResponseVO.setResponseUserName2(userName2);
		qstResponseVO.setResponseUserEmail(email);
		qstResponseVO.setResponseUserDeptID(deptID);
		qstResponseVO.setResponseUserDeptName(depart);
		qstResponseVO.setResponseUserDeptName2(depart2);
		qstResponseVO.setResponseUserPosition(position);
		qstResponseVO.setResponseUserPosition2(position2);
		qstResponseVO.setResponseUserJikgub(jikGub);
		qstResponseVO.setResponseUserJikgub2(jikGub2);
		qstResponseVO.setResponseUserGender(gender);
		qstResponseVO.setResponseUserAge(Integer.parseInt(age));
		qstResponseVO.setResponseDate(EgovDateUtil.getToday(""));
		qstResponseVO.setResponseUserIp(responseUserIp);
		/** EZSP_GETQUESTIONFORRESPONSE*/
		QstVO questionVO = new QstVO();
		questionVO.setBrdID(Integer.parseInt(brdID));
		questionVO.setItemNo(Integer.parseInt(itemNo));
		
		List<QstVO> qstVOList = ezQuestionService.getQuestionForResponse(questionVO);
		
		for(QstVO qstVO : qstVOList){
			subDataProcess(qstVO.getQuestionNo(), qstVO.getQuesContent(), qstVO.getMultiSelect(), qstVO.getAnswerType(), Integer.parseInt(brdID), Integer.parseInt(itemNo), request, qstResponseVO, response);
		}
		/** EZSP_GETRESPONSEPERSON*/
		QstResponsePersonVO qstResponsePersonVO = new QstResponsePersonVO();
		qstResponsePersonVO.setBrdID(Integer.parseInt(brdID));
		qstResponsePersonVO.setItemNo(Integer.parseInt(itemNo));
		qstResponsePersonVO.setUserID(userID);

		String selUserID="", selResponseDate="";
		
		if(ezQuestionService.getResponsePerson(qstResponsePersonVO)!=null){
			selUserID = qstResponsePersonVO.getUserID();
			selResponseDate = qstResponsePersonVO.getResponseDate();
			if(vResponseRange.equals("1")){
				if(selResponseDate==null||selResponseDate.equals("")){
					ezQuestionService.updateResponsePerson(qstResponsePersonVO);
				}
			}
		}
		
		ezQuestionService.updateResCnt(Integer.parseInt(brdID), Integer.parseInt(itemNo));

		response.getWriter().write("<script language='javascript'>");
		response.getWriter().write("window.location.href='/ezQuestion/qstList.do?" + receve + "';");
		response.getWriter().write("</script>");
		response.getWriter().flush();
	}	

	/**
	 * 전자설문 설문리스트 결과보기 화면 호출 함수
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResult.do")
	public String qstResult(@CookieValue("loginCookie") String loginCookie, Locale locale, ModelMap model, HttpServletRequest request, QstUserPollItemVO qstUserPollItemVO, QstUserPermissionVO qstUserPermissionVO) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String userID = loginVO.getId();
		String brdID="5", brdNm="", itemNo="", title="", responseRange="", postDate="", pollEndDate="", currPage="";
		String publicResultFlg = "", publicFlg = "", multiResponseFlg = "", endFlg = "";
		int readCnt=0, resCnt=0;
		int percent = 0;
		
		if(request.getParameter("brdID")!=null)
			brdID = request.getParameter("brdID");
		if(request.getParameter("brdNm")!=null)
			brdNm = request.getParameter("brdNm");
		if(request.getParameter("itemNo")!=null)
			itemNo = request.getParameter("itemNo");
		if(request.getParameter("title")!=null)
			title = request.getParameter("title");
		if(request.getParameter("responseRange")!=null)
			responseRange = request.getParameter("responseRange");
		if(request.getParameter("postDate")!=null)
			postDate = request.getParameter("postDate");
		if(request.getParameter("pollEndDate")!=null)
			pollEndDate = request.getParameter("pollEndDate");
		if(request.getParameter("currPage")!=null)
			currPage = request.getParameter("currPage");
		
		String receve = "brdID=" + request.getParameter("brdID") +
						"&itemNo=" + request.getParameter("itemNo") +
		                "&title=" + commonUtil.cleanValue(request.getParameter("title")) +
		                "&responseRange=" + request.getParameter("responseRange") +
		                "&postDate=" + request.getParameter("postDate") +
		                "&pollEndDate=" + request.getParameter("pollEndDate") +
		                "&currPage=" + request.getParameter("currPage");		
		
		/** EZSP_GETUSERIDADMIN*/
		boolean adminYN = false;
		String userIDAdmin = ezQuestionService.getUserIDAdmin(Integer.parseInt(brdID));

		if(userIDAdmin != null){
			if(userID.equals(userIDAdmin)){
				adminYN = true;
			}
		}
		/** EZSP_RESCOUNT*/
		if(ezQuestionService.resCount(brdID, itemNo) != null){
			resCnt = ezQuestionService.resCount(brdID, itemNo);
		}else{
			resCnt = 0;
		}
		
		/** EZSP_GETUSERPOLLITEM*/
		qstUserPollItemVO.setBrdID(Integer.parseInt(brdID));
		qstUserPollItemVO.setItemNo(Integer.parseInt(itemNo));
		qstUserPollItemVO = ezQuestionService.getUserPollItem(qstUserPollItemVO);
		
		/** EZSP_UPDATEREADCNT*/
		if (qstUserPollItemVO.getUserID() != userID){
            readCnt = readCnt + 1;
            ezQuestionService.updateReadCnt(qstUserPollItemVO);
		}
		/** EZSP_GETREADDATEITEMFORRESULT*/
		String readDate = ezQuestionService.getReadDateItemForResult(qstUserPollItemVO, userID);
		/** EZSP_UPDATEREADDATE*/
		
		if(readDate != null){
			ezQuestionService.updateReadDate(qstUserPollItemVO, readDate, userID);
		}else{
			ezQuestionService.insertItemRead(loginVO, qstUserPollItemVO, EgovDateUtil.getTodayTime());
		}
		
		/** EZSP_GETUSERPERMISSION*/
		qstUserPermissionVO.setBrdID(Integer.parseInt(brdID));
		qstUserPermissionVO.setItemNo(Integer.parseInt(itemNo));
		qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
		
		publicResultFlg = qstUserPermissionVO.getPublicResultFlg();
		publicFlg = qstUserPermissionVO.getPublicFlg();
		multiResponseFlg = qstUserPermissionVO.getMultiResponseFlg();
		endFlg = qstUserPermissionVO.getEndFlg();
		responseRange = qstUserPermissionVO.getResponseRange();
		
		boolean bPublic;
		
        if (publicFlg.equals("1")){
            bPublic = true;
        }else{
            bPublic = false;
        }
         
        /** ans*/
        List<QstVO> qstVOList = dataProcessMainData(brdID, itemNo);
        qstVOList = dataProcess(Integer.parseInt(brdID), Integer.parseInt(itemNo), bPublic, qstVOList, percent, locale);
        
        model.addAttribute("qstVOList",qstVOList);
        model.addAttribute("qstUserPollItemVO", qstUserPollItemVO);
        model.addAttribute("qstUserPermissionVO", qstUserPermissionVO);
		model.addAttribute("receve", receve);
		model.addAttribute("resCnt", resCnt);
		return "/ezQuestion/qstResult";
	}
	
	/**
	 * 전자설문 설문생성 STEP1화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstStep1.do")
	public String qstStep1(HttpServletRequest req,Model model)  {
		String brdID = req.getParameter("brdID");
		String brdNm = req.getParameter("brdNm");
		String brdPostterm = req.getParameter("brdPostterm");

		model.addAttribute("brdID", brdID);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdPostterm", brdPostterm);
		return "/ezQuestion/qstStep1";
	}
	
	/**
	 * 전자설문 설문생성 STEP2화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstStep2.do", method = RequestMethod.POST)
	public String qstStep2(HttpServletRequest req, QstStep1VO qstStep1VO, QstAddVO questionAddVO, ModelMap model) {
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
		if(req.getParameter("RangeXMLStr") != null) {
			pStep1DataXML.append(req.getParameter("RangeXMLStr").trim().replace("&amp;", "&").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\""));
		}
		pStep1DataXML.append("</PARAMETER>");
		
		model.addAttribute("qstStep1VO", qstStep1VO);
		model.addAttribute("questionAddVO", questionAddVO);
		model.addAttribute("pStep1DataXML", pStep1DataXML);
		return "/ezQuestion/qstStep2";
	}
	
	/**
	 * 전자설문 설문생성 설문대상 화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstRangeSelect.do")
	public String qstRangeSelect(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String itemID = "";
		String userInfoDeptCode="",serverName="",pCompanyID="";
		String strGenderACL0="",strGenderACL1="",strGenderACL2="";
		
		if(req.getParameter("brdID") != null)
			brdID = req.getParameter("brdID");
		if(req.getParameter("itemNo") != null)
			itemID = req.getParameter("itemNo");
		
		strGenderACL0 = "checked";
		strGenderACL1 = "";
		strGenderACL2 = "";
		userInfoDeptCode = loginVO.getDeptID();
		pCompanyID = loginVO.getCompanyID();
		serverName = req.getServerName();
		
		QstRangeSelectVO qstRangeSelectVO = new QstRangeSelectVO();
		qstRangeSelectVO.setBrdID(brdID);
		qstRangeSelectVO.setItemID(itemID);
		qstRangeSelectVO.setStrGenderACL0(strGenderACL0);
		qstRangeSelectVO.setStrGenderACL1(strGenderACL1);
		qstRangeSelectVO.setStrGenderACL2(strGenderACL2);
		qstRangeSelectVO.setUserInfoDeptCode(userInfoDeptCode);
		qstRangeSelectVO.setpCompanyID(pCompanyID);
		qstRangeSelectVO.setServerName(serverName);
		
		model.addAttribute("brdId",qstRangeSelectVO.getBrdID());
		model.addAttribute("itemNo",qstRangeSelectVO.getItemID());
		model.addAttribute("pCompanyID",pCompanyID);
		model.addAttribute("qstRangeSelectVO",qstRangeSelectVO);
		return "/ezQuestion/qstRangeSelect/rangeSelect";
	}
	
	/**
	 * 전자설문 설문생성 보기추가 화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstStep2QuestionAdd.do")
	public String qstStep2QuestionAdd(HttpServletRequest req,Model model, QstAddVO questionAddVO) throws Exception {
		//String brdId = "";
		//String itemId = "";
		String pMode = "";
		String pQstTitle = "", pAnswerType, pMultiSel = "";
		String pSelectOption = "";
		String pEditIndex = "";
		String pQstAnsInfo = "";
		String pQstAttach = "";
		String pDataXML = "";
		//String pNoneActiveX = "";
		
		pMode = "NEW";
		pAnswerType = "1";
		/*if(req.getParameter("brd_id") != null) {
			brdId = req.getParameter("brd_id").trim(); 
		}
		
		if(req.getParameter("item_id") != null) {
			itemId = req.getParameter("item_id").trim(); 
		}*/

		if(req.getParameter("DataXML") != null) {
			pMode = "EDIT";
			pDataXML = req.getParameter("DataXML").trim().replace("&lt;", "<").replace("&gt;", ">");
			logger.debug("pDataXML="+pDataXML);
			Document doc = commonUtil.convertStringToDocument(pDataXML);
			pQstTitle = doc.getElementsByTagName("QUESTIONCONTENT").item(0).getTextContent();
		
			//첨부
			if(doc.getElementsByTagName("ATTACH").getLength() > 0) {
				if(doc.getElementsByTagName("ATTACH").item(0).getChildNodes() != null) {
					pQstAnsInfo = doc.getElementsByTagName("ATTACH").item(0).getTextContent();
					
					XPath xpath = XPathFactory.newInstance().newXPath();
					
					NodeList nodes = (NodeList)xpath.evaluate("//ROW/ATTACH/ROW", doc, XPathConstants.NODESET);
					logger.debug("nodesLength="+nodes.getLength());
					
					int pAttachCnt = nodes.getLength();
					
					for(int i=0; i<pAttachCnt; i++) {
						if(pQstAttach != null && !pQstAttach.equals("")) {
							pQstAttach += ";";
						}
						pQstAttach += doc.getElementsByTagName("ATTACHTITLE").item(i).getTextContent();
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
						pSelectOption += "<option value=\"" +doc.getElementsByTagName("ANSWERTITLE").item(i).getTextContent() + "\" ";
						XPath xpath = XPathFactory.newInstance().newXPath();
						NodeList nodes = (NodeList)xpath.evaluate("//ROW/ANSWER["+(i+1)+"]/ATTACH", doc, XPathConstants.NODESET);
						if(nodes.getLength() > 0) {
						//if(doc.getElementsByTagName("ATTACH").getLength() > 0) {
							
							pSelectOption += "AnsInfo=\"" + nodes.item(0).getChildNodes() + "\">";
							//pSelectOption += "AnsInfo=\"" + doc.getElementsByTagName("ATTACH").item(i).getTextContent() + "\">";
						} else {
							pSelectOption += ">";
						}
						pSelectOption += String.valueOf(i + 1) + ". " + doc.getElementsByTagName("ANSWERTITLE").item(i).getTextContent() + "</option>";
					}
				}
			}
			if(req.getParameter("DataIndex") != null) {
				pEditIndex = String.valueOf(req.getParameter("DataIndex"));
			}
		}
		
		questionAddVO.setpMultiSel(pMultiSel);
		questionAddVO.setpSelectOption(pSelectOption);
		questionAddVO.setQuestionContent(pQstTitle);
		questionAddVO.setpQstAnsInfo(pQstAnsInfo);
		questionAddVO.setpQstAttach(pQstAttach);
		questionAddVO.setAnswerType(Integer.parseInt(pAnswerType));
		model.addAttribute("questionAddVO",questionAddVO);
		model.addAttribute("pEditIndex",pEditIndex);
		model.addAttribute("pMode",pMode);
		model.addAttribute("pDataXML",pDataXML);
		
		return "/ezQuestion/qstStep2QuestionAdd";
	}
	
	/**
	 * 전자설문 설문생성 아이템 시퀀스 호출 함수
	 */
	public String callGetItemSeq(String pBrdID) throws Exception {
		int get_itemNo = -1;
		
		if(ezQuestionService.getItemSeq(pBrdID).equals("")) {
			get_itemNo = 1;
		} else {
			get_itemNo = Integer.parseInt(ezQuestionService.getItemSeq(pBrdID).toString());
		}
		if(get_itemNo == -1) {
			ezQuestionService.insertItemSeq(pBrdID);
			get_itemNo = 1;
		} else {
			get_itemNo = get_itemNo+1;
			ezQuestionService.updateItemSeq(Integer.parseInt(pBrdID), get_itemNo);
		}
		
		return String.valueOf(get_itemNo);
	}
	
	/**
	 * 전자설문 설문생성 정보등록 실행 함수
	 */
	@RequestMapping(value="/ezQuestion/qstComplete.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstComplete(@RequestBody String xmlDoc ,HttpServletRequest req,@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, QstCompleteVO qstCompleteVO) throws Exception  {
		Document doc = commonUtil.convertStringToDocument(xmlDoc);
		loginVO = commonUtil.userInfo(loginCookie);
		
		String pUserID = loginVO.getId();
		String pBrdID = "";
		String vItemID = "";
		
		if(req.getParameter("pBrdID") == null) {
			pBrdID = "5";
			vItemID = callGetItemSeq(pBrdID);
		}
		
		String pRtn = SaveQuestion(pBrdID, vItemID, doc, pUserID, loginVO);
		
		if(!pRtn.equals("OK")) {
			DeleteQuestion(pBrdID, vItemID);
			pRtn = "ERROR";
		}

		String strXML = "<DATA>" + pRtn + "</DATA>";
		
		//int brdId = Integer.parseInt(pBrdID);
		//int itemNo = Integer.parseInt(vItemID);
		
		return strXML;
	}


	public String SaveQuestion(String pBrdID, String vItemID, Document doc, String pUserID, LoginVO loginVO) throws Exception {
		NodeList nList = null;
		int dataCount = 0;
		dataCount = ezQuestionService.getItemNoCnt(Integer.parseInt(pBrdID), Integer.parseInt(vItemID));
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("subject", doc.getElementsByTagName("SUBJECT").item(0).getTextContent());
		map.put("content", doc.getElementsByTagName("CONTENT").item(0).getTextContent());
		map.put("startdate", doc.getElementsByTagName("STARTDATE").item(0).getTextContent());
		map.put("enddate", doc.getElementsByTagName("ENDDATE").item(0).getTextContent());
		map.put("expiredate", doc.getElementsByTagName("EXPIREDATE").item(0).getTextContent());
		map.put("anonymity", doc.getElementsByTagName("ANONYMITY").item(0).getTextContent());
		map.put("openresult", doc.getElementsByTagName("OPENRESULT").item(0).getTextContent());
		map.put("multiresponse", doc.getElementsByTagName("MULTIRESPONSE").item(0).getTextContent());
		map.put("importance", doc.getElementsByTagName("IMPORTANT").item(0).getTextContent());
		map.put("target", doc.getElementsByTagName("TARGET").item(0).getTextContent());
		map.put("brdID", pBrdID);
		map.put("itemNo", Integer.parseInt(vItemID));
		map.put("dataCount", dataCount);
		map.put("userNm", loginVO.getDisplayName1());
		map.put("userNm2", loginVO.getDisplayName2());
		map.put("userEmail", loginVO.getEmail());
		
		ezQuestionService.stepSave(pUserID, map);
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("brdID", pBrdID);
		map2.put("itemNo", Integer.parseInt(vItemID));
		map2.put("openresult", doc.getElementsByTagName("OPENRESULT").item(0).getTextContent());
		map2.put("anonymity", doc.getElementsByTagName("ANONYMITY").item(0).getTextContent());
		map2.put("multiresponse", doc.getElementsByTagName("MULTIRESPONSE").item(0).getTextContent());
		map2.put("target", doc.getElementsByTagName("TARGET").item(0).getTextContent());
		map2.put("dataCount", dataCount);
		ezQuestionService.stepSave2(map2);
		//대상범위
		if(doc.getElementsByTagName("TARGET").item(0).getTextContent().equals("1")) {
			
			if(doc.getElementsByTagName("RANGE").item(0).getChildNodes().getLength() > 0) {
				int pDeptCnt = doc.getElementsByTagName("DEPT").item(0).getChildNodes().getLength();
				
				for(int i=0; i<pDeptCnt; i++) {
					QstCompleteVO qstCompleteVO = new QstCompleteVO();
					String deptID = doc.getElementsByTagName("DEPT").item(0).getChildNodes().item(i).getAttributes().getNamedItem("id").getTextContent();
		        	String deptNm = doc.getElementsByTagName("DEPT").item(0).getChildNodes().item(i).getAttributes().getNamedItem("nm").getTextContent();
		        	String deptNm2 = doc.getElementsByTagName("DEPT").item(0).getChildNodes().item(i).getAttributes().getNamedItem("nm2").getTextContent();
		        	qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
		        	qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
		        	qstCompleteVO.setGubunFg("0");
		        	qstCompleteVO.setGubunID(deptID);
		        	qstCompleteVO.setGubunNm(deptNm);
		        	qstCompleteVO.setGubunNm2(deptNm2);
		        	ezQuestionService.callCreateMother(qstCompleteVO);
						
					String cellList = "department";
                    String propList = "department;mail;displayname;title;description;company;title";
                    String pClass = "all";
                       
                    String sXML = ezOrganService.getDeptMemberList(deptID, cellList, propList, pClass, config.getProperty("config.primary"));
             		Document xmlDom = commonUtil.convertStringToDocument(sXML);
             			for(int j=0; j<xmlDom.getElementsByTagName("CELL").getLength(); j++) {
             				if(xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(3).getTextContent() != "") {
             					String userID = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(2).getTextContent();
             					String userNm = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(10).getTextContent();
             					String userNm2 = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(11).getTextContent();
             					String userEmail = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(4).getTextContent();
             					String deptID2 = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(3).getTextContent();
             					String deptNM = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(12).getTextContent();
             					String deptNM2 = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(13).getTextContent();
             					String userPos = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(6).getTextContent();
             					String userPos2 = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(9).getTextContent();
             					QstCompleteVO qstCompleteVO2 = new QstCompleteVO();
                             	qstCompleteVO2.setStrBrdID(Integer.parseInt(pBrdID));
                             	qstCompleteVO2.setItemNo(Integer.parseInt(vItemID));
                             	qstCompleteVO2.setUserID(userID);
                             	qstCompleteVO2.setUserNm(userNm);
                             	qstCompleteVO2.setUserNm2(userNm2);
                             	qstCompleteVO2.setUserEmail(userEmail);
                             	qstCompleteVO2.setUserDeptID(deptID2);
                             	qstCompleteVO2.setUserDeptNm(deptNM);
                             	qstCompleteVO2.setUserDeptNm2(deptNM2);
                             	qstCompleteVO2.setUserPOS(userPos);
                             	qstCompleteVO2.setUserPOS2(userPos2);
                             	ezQuestionService.callInsertPollResponsep1(qstCompleteVO2);
             				}
             			}
				}
				int pUserCnt = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().getLength();
				for(int i=0; i<pUserCnt; i++) {
					String userID = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("id").getTextContent();
		        	String userNm = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("nm").getTextContent();
		        	String userNm2 = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("nm2").getTextContent();
		        	
                	QstCompleteVO qstCompleteVO = new QstCompleteVO();
                	qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
                	qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
                	qstCompleteVO.setGubunFg("1");
                	qstCompleteVO.setGubunID(userID);
                	qstCompleteVO.setGubunNm(userNm);
                	qstCompleteVO.setGubunNm2(userNm2);
                	ezQuestionService.callCreateMother(qstCompleteVO);
                	
                	String propList = "department;mail;displayName;title;description;company";
                	String pXML = ezOrganAdminService.getPropertyList(userID, propList, config.getProperty("config.primary"));

					Document infoXML = commonUtil.convertStringToDocument(pXML);
					String userDeptId = "";
					//String userGender = "";
					//String userAge = "";
					
					if(infoXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent() == "") {
						userDeptId = "TOP";
					} else {
						userDeptId = infoXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent();
					}
					String userEmail = infoXML.getElementsByTagName("MAIL").item(0).getTextContent();
					String userPos = infoXML.getElementsByTagName("TITLE1").item(0).getTextContent();
					String userPos2 = infoXML.getElementsByTagName("TITLE2").item(0).getTextContent();
					String userDeptNm = infoXML.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
					String userDeptNm2 = infoXML.getElementsByTagName("DESCRIPTION2").item(0).getTextContent();
					/*String userJumin = "1111111111111";*/
					
					/*if(userJumin.substring(7, 1).equals("1")) {
						userGender = "1";
					} else {
						userGender = "2";
					}
					userAge = userJumin.substring(0, 2);
					
					if(userAge == "11") {
						userAge = "NULL";
					}*/
					
					QstCompleteVO qstCompleteVO3 = new QstCompleteVO();
					qstCompleteVO3.setStrBrdID(Integer.parseInt(pBrdID));
					qstCompleteVO3.setItemNo(Integer.parseInt(vItemID));
					qstCompleteVO3.setGubunID(userID);
					qstCompleteVO3.setGubunNm(userNm);
					qstCompleteVO3.setGubunNm2(userNm2);
					qstCompleteVO3.setUserEmail(userEmail);
					qstCompleteVO3.setUserDeptID(userDeptId);
					qstCompleteVO3.setUserDeptNm(userDeptNm);
					qstCompleteVO3.setUserDeptNm2(userDeptNm2);
					qstCompleteVO3.setUserPOS(userPos);
					qstCompleteVO3.setUserPOS2(userPos2);
					qstCompleteVO3.setUserGender("");
					qstCompleteVO3.setUserAge(0);
					ezQuestionService.callInsertPollResponseper(qstCompleteVO3);
				}
			}
		}
		
		int qstCnt = doc.getElementsByTagName("QUESTION").item(0).getChildNodes().getLength();
		
		for(int i=0; i<qstCnt; i++) {
			String qstSubject = doc.getElementsByTagName("QUESTIONCONTENT").item(i).getTextContent();
			String answerType = doc.getElementsByTagName("ANSWERTYPE").item(i).getTextContent();
			String multiSelect = doc.getElementsByTagName("MULTISELECT").item(i).getTextContent();
			/*String selViewStart = doc.getElementsByTagName("SELVIEWSTART").item(i).getTextContent();
			String selViewEnd = doc.getElementsByTagName("SELVIEWEND").item(i).getTextContent();*/
			
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
	//		
			if(doc.getElementsByTagName("ATTACH").getLength() > 0) {
				int qstAttachCnt = doc.getElementsByTagName("ATTACH").item(0).getChildNodes().getLength();
				for(int qa=0; qa < qstAttachCnt; qa++) {
					String attachType = doc.getElementsByTagName("TYPE").item(qa).getTextContent();
					String tmpAttachUrl = doc.getElementsByTagName("HREF").item(qa).getTextContent();
					
					if(attachType == "3" || attachType == "4" || attachType == "6" || attachType == "7") {
						
					}
					QstCompleteVO qstCompleteVO3 = new QstCompleteVO();
					qstCompleteVO3.setStrBrdID(Integer.parseInt(pBrdID));
					qstCompleteVO3.setItemNo(Integer.parseInt(vItemID));
					qstCompleteVO3.setQuesNo(v_quesNo);
					qstCompleteVO3.setAnswerNo(0);
					qstCompleteVO3.setAttachNo(qa);
					qstCompleteVO3.setAttachName(doc.getElementsByTagName("ATTACHTITLE").item(qa).getTextContent());
					qstCompleteVO3.setAttachURL(tmpAttachUrl);
					qstCompleteVO3.setAttachType(attachType);
					ezQuestionService.pollSaveAttach(qstCompleteVO3);
				}
			}
	//		
			//////////////////////
			XPath xpath = XPathFactory.newInstance().newXPath();
			NodeList nodes1 = (NodeList)xpath.evaluate("//QUESTION/ROW["+(i+1)+"]/ANSWER_ANSWER", doc, XPathConstants.NODESET);
			if(nodes1.getLength() > 0) {
				int ansAnsCnt = nodes1.getLength();
				for(int iAnsAnsCnt=0; iAnsAnsCnt < ansAnsCnt; iAnsAnsCnt++ ) {
					qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
					qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
					qstCompleteVO.setQuesNo(v_quesNo);
					qstCompleteVO.setAnswerNo(iAnsAnsCnt+1);
					qstCompleteVO.setAnswerAnswerContent(nodes1.item(iAnsAnsCnt).getChildNodes().item(0).getTextContent().replace("'", "''"));
					ezQuestionService.insertAnswerAnswerContent(qstCompleteVO);
					
				}
			}
			
				NodeList nodes = (NodeList)xpath.evaluate("//QUESTION/ROW["+(i+1)+"]/ANSWER", doc, XPathConstants.NODESET);
				if(nodes.getLength() > 0) {
					int ansCnt = nodes.getLength();
					for(int iAns=0; iAns < ansCnt; iAns++ ) {
						qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
						qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
						qstCompleteVO.setQuesNo(v_quesNo);
						qstCompleteVO.setAnswerNo(iAns+1);
						qstCompleteVO.setAnswerContent(nodes.item(iAns).getChildNodes().item(0).getTextContent().replace("'", "''"));
						ezQuestionService.insertAnswerContent(qstCompleteVO);
						
						if(doc.getElementsByTagName("ANSWER").getLength() != 0 && doc.getElementsByTagName("ATTACH").getLength() != 0) {
							nList = doc.getElementsByTagName("ANSWER");	
							
							if(nList.item(iAns).getChildNodes().item(1) != null){
								if(nList.item(iAns).getChildNodes().item(1).getNodeName().equals("ATTACH")) {
									int ansAttachCnt = nList.item(iAns).getChildNodes().item(1).getChildNodes().getLength();
									for(int aa=0; aa<ansAttachCnt; aa++) {
										String ansAttachType = nList.item(iAns).getChildNodes().item(1).getChildNodes().item(aa).getChildNodes().item(0).getTextContent();
										String ansAttachUrl = nList.item(iAns).getChildNodes().item(1).getChildNodes().item(aa).getChildNodes().item(2).getTextContent();
										if(ansAttachType == "3" || ansAttachType == "4" || ansAttachType == "6" || ansAttachType == "7") {
										}
										QstCompleteVO qstCompleteVO2 = new QstCompleteVO();
										qstCompleteVO2.setStrBrdID(Integer.parseInt(pBrdID));
										qstCompleteVO2.setItemNo(Integer.parseInt(vItemID));
										qstCompleteVO2.setQuesNo(v_quesNo);
										qstCompleteVO2.setAnswerNo(iAns+1);
										qstCompleteVO2.setAttachNo(aa+1);
										//qstCompleteVO2.setAttachName(doc.getElementsByTagName("ATTACHTITLE").item(aa).getTextContent().replace("'", "''"));
										qstCompleteVO2.setAttachName(nList.item(iAns).getChildNodes().item(1).getChildNodes().item(aa).getChildNodes().item(1).getTextContent().replace("'", "''"));
										qstCompleteVO2.setAttachURL(ansAttachUrl);
										qstCompleteVO2.setAttachType(ansAttachType);
										ezQuestionService.pollSaveAttach(qstCompleteVO2);
									}
								}
							}
						}
					}
				}
		}
		
		QstCompleteVO qstCompleteVO = new QstCompleteVO();
		qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
		qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
		ezQuestionService.updatePollItem(qstCompleteVO);
		
		return "OK";
	}
	
	/**
	 * 전자설문 설문생성 질문삭제 실행 함수
	 */
	public void DeleteQuestion(String pBrdID, String vItemID) throws Exception {
		QstCompleteVO qstCompleteVO = new QstCompleteVO();
		qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
		qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
		ezQuestionService.deleteItem(qstCompleteVO);
	}
	
	/**
	 * 전자설문 설문생성 파일첨부 화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstAttachNonActX.do")
	public String qstAttachNonActX(HttpServletRequest req, Model model) {
		String idName = "";
		String attachInfo = "";
		String attachType = "";
		String attachMode = "";
		String attachModeIndex = "";
		
		if(req.getParameter("idName") != null) {
			idName = String.valueOf(req.getParameter("idName"));
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
		
		model.addAttribute("idName", idName);
		model.addAttribute("attachInfo", attachInfo);
		model.addAttribute("attachType", attachType);
		model.addAttribute("attachMode", attachMode);
		model.addAttribute("attachModeIndex", attachModeIndex);
		
		return "/ezQuestion/qstAttachNonActX";
	}
	
	/**
	 * 전자설문 설문생성 파일첨부 실행 함수
	 */
	@RequestMapping(value="/ezQuestion/attachFileNonActX.do")
	public String attachFileNonActXDad(MultipartHttpServletRequest req,Model model) throws Exception {
		String pFilePath = "";
		String type = "";
		String mode = "";
		if(req.getParameter("QstType") != null)
			type = String.valueOf(req.getParameter("QstType"));
		if(req.getParameter("mode") != null)
			mode = String.valueOf(req.getParameter("mode"));
		String pFileName = "";
		MultipartFile file = req.getFile("cmuds");
		if(file != null) {
			pFileName = req.getFile("cmuds").getOriginalFilename();
			pFileName = pFileName.replace("+", "%2b");
			pFileName = pFileName.replace(";", "%3b");
			
			String pDirPath = config.getProperty("upload_board.UPLOADQUESTION");
			String qDirPath = commonUtil.getRealPath(req);
			File temp = new File(qDirPath);
			if(!temp.exists()) {
				temp.mkdirs();
			}
			
			String fileSize = String.valueOf(req.getFile("cmuds").getSize());
			String pFileName_Guid = UUID.randomUUID().toString();
			String newFileName = pFileName_Guid+pFileName.substring(pFileName.lastIndexOf("."));
			
			if(type == "1") {
				
			}
			
			pFilePath = pDirPath+commonUtil.separator+newFileName;
			
			writeUploadedFile(file, newFileName, qDirPath+pDirPath);
			
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
	
	/**
	 * 전자설문 설문생성 임시저장 실행 함수
	 */
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
	
	/**
	 * 전자설문 설문생성 불러오기 실행 함수
	 */
	@RequestMapping(value="/ezQuestion/formTempLoadSafari.do")
	public void formTempLoadSafari(MultipartHttpServletRequest req,Model model, HttpServletResponse resp) throws Exception {
		StringBuilder sb = new StringBuilder();
		if(req.getFile("cmuds") != null) {
			InputStreamReader myFile = new InputStreamReader(req.getFile("cmuds").getInputStream());
			int line = 0; 
			while((line = myFile.read()) != -1) {
				sb.append(String.valueOf(line));
			}
		}
	}
	
	/**
	 * 전자설문 설문생성 질문취소 실행 함수
	 */
	@RequestMapping(value="/ezQuestion/qstCancel.do")
	public void qstCancel(HttpServletRequest req, Model model, HttpServletResponse resp) throws Exception {
		
	}
	
	/**
	 * 전자설문 설문리스트 첨부파일 출력 화면 호출 함수
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstAttachView.do")
	public String attachView(Locale locale, HttpServletRequest request, ModelMap model) throws Exception{
		String href = "", type = "", title = "";
		String vBrdID = "5";
		String vItemNo = "";
		String strQuestionNo = "";
		String strAnswer = "";
		String strAttID = "";
		 
		if (request.getParameter("type") != null){
            type = request.getParameter("type");
		}
        if (request.getParameter("boardID") != null){
            vBrdID = request.getParameter("boardID");
        }
        if (request.getParameter("itemNo") != null){
            vItemNo = request.getParameter("itemNo");
        }
        if (request.getParameter("qstNo") != null){
            strQuestionNo = request.getParameter("qstNo");
        }
        if (request.getParameter("ansNo") != null){
            strAnswer = request.getParameter("ansNo");
        }
        if (request.getParameter("attID") != null){
            strAttID = request.getParameter("attID");
        }
        if (request.getParameter("href") != null){
        	href=request.getParameter("href");
        }

        QstAttachVO qstAttachVO = ezQuestionService.getAttachInfo2(vBrdID, vItemNo, strQuestionNo, strAnswer, strAttID);
        href=qstAttachVO.getAttachUrl();
        
        String fileExt = href.substring(href.lastIndexOf("."));

        qstAttachVO.setBrdID(Integer.parseInt(vBrdID));
        qstAttachVO.setItemNo(Integer.parseInt(vItemNo));
        qstAttachVO.setQuestionNo(Integer.parseInt(strQuestionNo));
        qstAttachVO.setAnswerNo(Integer.parseInt(strAnswer));
        qstAttachVO.setAttachNo(Integer.parseInt(strAttID));

        switch(type){
        case "1":
        	title = egovMessageSource.getMessage("ezQuestion.t178", locale);
        	break;
        case "2":
        	title = egovMessageSource.getMessage("ezQuestion.t179", locale);
        	break;
        case "3":
        	title = egovMessageSource.getMessage("ezQuestion.t180", locale);
        	break;
        case "4":
        	title = "URL " + egovMessageSource.getMessage("ezQuestion.t171", locale);
        	break;
        }
        
        model.addAttribute("qstAttachVO", qstAttachVO);
        model.addAttribute("title", title);
       
        return "/ezQuestion/qstAttachView";
	}
	
	/**
	 * 전자설문 설문리스트 첨부파일 호출 실행함수
	 */
	@RequestMapping(value="/ezQuestion/getPollAttachInfo.do")
	public void getPollAttachInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, QstAttachVO qstAttachVO) throws Exception{
		String pType = "";
		String pBoardID = "";
		String pItemID = "";
		String pQstNo = "";
        String pAnsNo = "";
        String pAttID = "";
        String pFileName = "";
        String pFilePath = "";
		 
        pType = request.getParameter("type");
        pBoardID = request.getParameter("boardID");
        pItemID = request.getParameter("itemID");
        pQstNo = request.getParameter("qstNo");
        pAnsNo = request.getParameter("ansNo");
        pAttID = request.getParameter("attID");
        
        if(request.getParameter("fileName") != null){
        	pFileName = request.getParameter("fileName");
        }
        
        if(pType.equals("QUESTION")){
                if (!pFileName.equals("")){
                    pFilePath = config.getProperty("upload_board.UPLOADQUESTION")+commonUtil.separator+pFileName;
                }else{
                	qstAttachVO = ezQuestionService.getAttachInfo2(pBoardID, pItemID, pQstNo, pAnsNo, pAttID);
                    pFilePath = qstAttachVO.getAttachUrl();
                    pFileName = qstAttachVO.getAttachName() + pFilePath.substring(pFilePath.lastIndexOf('.'));
                }
                if (pFilePath != null && pFilePath != ""){
                    ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
                }
        }
	}

	/**
	 * 전자설문 설문리스트 결과보기 주관식일 경우 답변보기 화면 호출 함수
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResultSubjective.do")
	public String qstResultSubjective(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap model, QstUserPermissionVO qstUserPermissionVO) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brdID = "", itemNo = "", questionNo = "", lang="";
        int pTotalCnt = 0, pTotalPage = 0, pCurrPage = 0;
        int pPageSize = 0, pageCount = 0, pBlockSize = 0;
        String publicResultFlg = "", publicFlg = "", multiResponseFlg = "";
        String pAnsType = "";
        
        if (request.getParameter("brdID") != null)
            brdID = request.getParameter("brdID");
        if (request.getParameter("itemNo") != null)
            itemNo = request.getParameter("itemNo");
        if (request.getParameter("questionNo") != null)
            questionNo = request.getParameter("questionNo");
        if (request.getParameter("pageCount") != null)
            pageCount = Integer.parseInt(request.getParameter("pageCount"));        
        if(loginVO.getLang().equals("1")){
        	lang ="";
        }else{
        	lang = loginVO.getLang();
        }
        if (request.getParameter("page") != null){
            if (request.getParameter("page") != ""){
                pCurrPage = Integer.parseInt(request.getParameter("page"));
            }else{
                pCurrPage = 1;
            }
        }else{
            pCurrPage = 1;
        }
        pPageSize = 15;
        pBlockSize = 10;

        qstUserPermissionVO.setBrdID(Integer.parseInt(brdID));
        qstUserPermissionVO.setItemNo(Integer.parseInt(itemNo));
        qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
        publicResultFlg = qstUserPermissionVO.getPublicResultFlg();
        publicFlg = qstUserPermissionVO.getPublicFlg();
        multiResponseFlg = qstUserPermissionVO.getMultiResponseFlg();

        /** EZSP_RESULTSUBJECTIVELISTCNT*/
        pTotalCnt = ezQuestionService.resultSubjectiveListCnt(Integer.parseInt(brdID), Integer.parseInt(itemNo), Integer.parseInt(questionNo), lang);
        pTotalPage = (pTotalCnt + pPageSize - 1) / pPageSize;
        
        if (pageCount == 0){
            pageCount = -1;
        }else{
            pageCount = pageCount - 1;
        }
        
        int iStart = (pCurrPage - 1) * pPageSize;
        /** EZSP_RESULTSUBJECTIVELIST*/
        List<QstResponseVO> qstResponseVOList = ezQuestionService.resultSubjectiveList(brdID, itemNo, questionNo, pTotalCnt-iStart, pPageSize, lang);
        
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
            		QstVO qstVO = ezQuestionService.getQuestionForSubjective(brdID, itemNo, questionNo);
            		pAnsType = Integer.toString(qstVO.getAnswerType());
            		
            		if(pAnsType.equals("4")){
            			List<QstAnswerVO> rtnList = dataProcessAns(Integer.parseInt(brdID), Integer.parseInt(itemNo), Integer.parseInt(questionNo));
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
            				
            				if(xmlRtnDom.getElementsByTagName("DATA/ROW/ANSWERCONTENT").getLength() > 0){
            					pAnsSubjectivity = pAnsSubjectivity + xmlRtnDom.getElementsByTagName("DATA/ROW/ANSWERCONTENT").item(k-1).getTextContent() + " ; ";
            				}else{
            					pAnsSubjectivity = pAnsSubjectivity + " ; ";
            				}
            			}
            		}
            		
            		if(pAnsSubjectivity.length() > 70){
            			String strTag = "<td style='width:100%;height:100%;word-break:break-all;white-space:normal;'><div style='height:40px;overflow-y:auto;'>" + pAnsSubjectivity + "</div></td>";
            			Node option = xmlMainDom.createElement("OPTIOIN");
            			option.appendChild(xmlMainDom.createTextNode(strTag));
            			newRow.appendChild(option);
            			targetNode.appendChild(newRow);
            		}else{
            			String strTag = "<td>" + pAnsSubjectivity + "</td>";
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
            			newDataValue = xmlMainDom.createTextNode(Integer.toString((int)field.get(qstResponseVO)).trim());
            		}
            		else{
            			newDataValue = xmlMainDom.createTextNode(((String)field.get(qstResponseVO)).trim());
            		}
            	}
            	newDataName.appendChild(newDataValue);
                newRow.appendChild(newDataName);
                newDataName = null;
                newDataValue = null;
                targetNode.appendChild(newRow);
            }
        }    

        model.addAttribute("brdID", brdID);
        model.addAttribute("itemNo", itemNo);
        model.addAttribute("questionNo", questionNo);
        model.addAttribute("pTotalPage", pTotalPage);
        model.addAttribute("pCurrPage", pCurrPage);
        model.addAttribute("pTotalCnt", pTotalCnt);
        model.addAttribute("pAnsType", pAnsType);
        model.addAttribute("publicFlg", publicFlg);
        model.addAttribute("pageCount", pageCount);
        model.addAttribute("xmlMainDom", commonUtil.convertDocumentToString(xmlMainDom));
        
		return "/ezQuestion/qstResultSubjective";
	}
	
	/**
	 * 전자설문 설문생성 삭제 화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstDeleteItemMsg.do")
	public String qstDeleteItemMsg(HttpServletRequest req,Model model)  {
		String pBrdID = "";
		String itemNo = "";
		
		pBrdID = req.getParameter("brdID");
		itemNo = req.getParameter("itemNo");

		model.addAttribute("pBrdID", pBrdID);
		model.addAttribute("itemNo", itemNo);
		return "/ezQuestion/qstDeleteItemMsg";
	}
	
	/**
	 * 전자설문 설문생성 삭제 실행 함수
	 */
	@RequestMapping(value="/ezQuestion/callDeleteItem.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstDeleteItem(HttpServletRequest req,Model model) throws Exception {
		//Document doc = commonUtil.convertRequestToDocument(req);
		
		String pBrdID = "";
		String itemNo = "";
		String strXML = "";
		try {
			if(req.getParameter("brdID") != null) {
				pBrdID = req.getParameter("brdID");
			}
			
			if(req.getParameter("itemNo") != null) {
				itemNo = req.getParameter("itemNo");
			}
			String pResult = "";
			QstCompleteVO qstComplete = new QstCompleteVO();
			qstComplete.setStrBrdID(Integer.parseInt(pBrdID));
			qstComplete.setItemNo(Integer.parseInt(itemNo));
			
			List<QstDeleteAttachUrlVO> temp = ezQuestionService.getDeleteAttachUrl(Integer.parseInt(pBrdID), Integer.parseInt(itemNo));
			for(int i=0; i<temp.size(); i++) {
				if(temp.get(i).getAttachType().equals("1") || temp.get(i).getAttachType().equals("2")) {
					pResult += temp.get(i).getAttachUrl().toString()+";";
				}
				
				if (!pResult.equals("")) {
					String qDirPath = req.getServletContext().getRealPath("");
					deleteFile(qDirPath+commonUtil.separator+pResult.split(";")[i]);
				}
			}

			ezQuestionService.deleteItem(qstComplete);
			ezQuestionService.deletePollAttach(Integer.parseInt(pBrdID), Integer.parseInt(itemNo));
			strXML = "<DATA>DELETE_OK</DATA>";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return strXML;
	}
	
	/**
	 * 전자설문 설문생성 검색 화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstSearch.do")
	public String qstSearch(HttpServletRequest req,Model model)  {
		String pBrdID = "";
		if(req.getParameter("brdID") != null) {
			pBrdID = req.getParameter("brdID");
		}
		model.addAttribute("pBrdID", pBrdID);
		return "/ezQuestion/qstSearch";
	}
	
	/**
	 * 전자설문 설문리스트 결과보기 응답자목록 화면 호출 함수
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstResponseList.do")
	public String qstResponseList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, QstUserPermissionVO qstUserPermissionVO) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String publicResultFlg = "", publicFlg = "", multiResponseFlg = "", responseRange = "";
        String brdID = "", itemNo = "", questionNo = "", responseYN = "";
        int pPageSize = 0, pBlockSize = 0, pageCount = 0, pCurrPage = 1, pTotalCnt = 0, pTotalPage = 0;
        String lang="";
        String pAnsType = "";
        
        if (request.getParameter("brdID") != null){
            brdID = request.getParameter("brdID");
        }
        if (request.getParameter("itemNo") != null){
            itemNo = request.getParameter("itemNo");
        }
        if (request.getParameter("responseYN") != null){
            responseYN = request.getParameter("responseYN");
        }
        if (request.getParameter("pageCount") != null){
        	if (request.getParameter("pageCount").equals("")){
        		pageCount = 1;
        	}else{
        		pageCount = pageCount-1;
        	}
        }
        if (request.getParameter("currPage") != null){
        	if (request.getParameter("currPage").equals("")){
        		pCurrPage = 1;
        	}else{
        		pCurrPage = Integer.parseInt(request.getParameter("currPage"));
        	}
        }
        if(loginVO.getLang().equals("1")){
        	lang ="";
        }else{
        	lang = loginVO.getLang();
        }
        	
        pPageSize = 15;
        pBlockSize = 10;

        qstUserPermissionVO.setBrdID(Integer.parseInt(brdID));
        qstUserPermissionVO.setItemNo(Integer.parseInt(itemNo));
        qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
        publicResultFlg = qstUserPermissionVO.getPublicResultFlg();
        publicFlg = qstUserPermissionVO.getPublicFlg();
        multiResponseFlg = qstUserPermissionVO.getMultiResponseFlg();
        responseRange = qstUserPermissionVO.getResponseRange();
        /** EZSP_RESPONSELISTCNT*/
        pTotalCnt = ezQuestionService.responseListCnt(brdID, itemNo, responseYN.trim(), lang);
        pTotalPage = (pTotalCnt + pPageSize - 1) / pPageSize;
        
        if (pageCount == 0){
            pageCount = -1;
        }else{
            pageCount = pageCount - 1;
        }
        /** EZSP_RESPONSELIST*/
        List<QstResponseVO> qstResponseVOList = ezQuestionService.responseList(brdID, itemNo, responseYN.trim(), pTotalCnt, pPageSize, lang);
        
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
        
        model.addAttribute("brdID", brdID);
        model.addAttribute("itemNo", itemNo);
        model.addAttribute("questionNo", questionNo);
        model.addAttribute("pTotalPage", pTotalPage);
        model.addAttribute("pCurrPage", pCurrPage);
        model.addAttribute("pTotalCnt", pTotalCnt);
        model.addAttribute("pAnsType", pAnsType);
        model.addAttribute("publicFlg", publicFlg);
        model.addAttribute("pageCount", pageCount);
        model.addAttribute("xmlMainDom", commonUtil.convertDocumentToString(xmlMainDom));
        
		return "/ezQuestion/qstResponseList";
	}
	
	/**
	 * 전자설문 설문리스트 상세분석 화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstAnalysis.do")
	public String qstAnalysis(HttpServletRequest request, ModelMap model) throws Exception{
		String pBrdID = "", pItemNo = "", pCurrPage = "", pAnswerType="";
		String pPubFlag = "";
		
	    pBrdID = request.getParameter("brdID");
        pItemNo = request.getParameter("itemNo");
        pPubFlag = request.getParameter("pubFlag");
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
			sb.append(commonUtil.cleanValue(qstVO.getQuesContent()));
			sb.append("</QUESCONTENT>");
			sb.append("<ANSWERTYPE>");
			sb.append(qstVO.getAnswerType());
			sb.append("</ANSWERTYPE>");
			sb.append("</ROW>");
			pAnswerType = Integer.toString(qstVO.getAnswerType());
		}
		sb.append("</DATA>");
		
        model.addAttribute("xmlMainDom",sb.toString());
        model.addAttribute("pBrdID",pBrdID);
        model.addAttribute("pItemNo",pItemNo);
		model.addAttribute("pPubFlag", pPubFlag);
		model.addAttribute("pCurrPage", pCurrPage);
		model.addAttribute("pAnswerType", pAnswerType);	
		
		return "/ezQuestion/qstAnalysis";
	}
	
	/**
	 * 전자설문 설문리스트 상세분석 분류항목 전체 일때 HTML Code 생성 호출 함수
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstCallAnalysisAll.do" , method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstCallAnalysisAll(Locale locale, HttpServletRequest request) throws Exception{
		String vBrdID="", vItemNo="", vQuesNo="";
		String questionNo = "", quesContent = "", multiSelect = "", answerType = "";
		int resCnt = 0, responseCnt = 0;
		
		vBrdID = request.getParameter("brdID");
    	vItemNo = request.getParameter("itemNo");
    	vQuesNo = request.getParameter("quesNo");
        
        Document resultXML =  commonUtil.convertStringToDocument("<ROWS></ROWS>");
        Node rNodes = resultXML.getFirstChild();
        
        resCnt = ezQuestionService.resCount(vBrdID, vItemNo);
        
        Node rNode = resultXML.createElement("ROW");
        rNodes.appendChild(rNode);
        
        Node node = resultXML.createElement("STYLE");
        CDATASection CDATASection = resultXML.createCDATASection("background-color:#C4D4EB;");
        rNode.appendChild(CDATASection);
        
        node = resultXML.createElement("CELL");
        rNode.appendChild(node);
        
        Node nodeData = resultXML.createElement("VALUE");
        nodeData.setTextContent(egovMessageSource.getMessage("ezQuestion.t54", locale));
        node.appendChild(nodeData);

        nodeData = resultXML.createElement("DATA1");
        nodeData.setTextContent("TOT");
        node.appendChild(nodeData);

        node = resultXML.createElement("CELL");
        rNode.appendChild(node);

        nodeData = resultXML.createElement("VALUE");
        nodeData.setTextContent(resCnt + " " + egovMessageSource.getMessage("ezQuestion.t53", locale));
        node.appendChild(nodeData);

        node = resultXML.createElement("CELL");
        rNode.appendChild(node);

        nodeData = resultXML.createElement("VALUE");
        node.appendChild(nodeData);
        
        /** EZSP_GETQUESTION*/
        List<QstVO> qstVOList = ezQuestionService.getQuestion(vBrdID, vItemNo, vQuesNo);        
        
        for(QstVO qstVO : qstVOList){
        	questionNo = Integer.toString(qstVO.getQuestionNo());
        	quesContent = commonUtil.cleanValue(qstVO.getQuesContent());
        	multiSelect = qstVO.getMultiSelect();
        	answerType = Integer.toString(qstVO.getAnswerType());
        	/** EZSP_GETRESPERSONCNT*/
        	responseCnt = ezQuestionService.getResPersonCnt(Integer.parseInt(vBrdID), Integer.parseInt(vItemNo), Integer.parseInt(questionNo));

        	rNode = resultXML.createElement("ROW");
        	rNodes.appendChild(rNode);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");

        	if (multiSelect.equals("1")){
        		CDATASection = resultXML.createCDATASection(quesContent + "[" + egovMessageSource.getMessage("ezQuestion.t55", locale));
        	}else{
        		CDATASection = resultXML.createCDATASection(quesContent);
        	}

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
        	List<QstAnswerVO> qstAnswerVOList = ezQuestionService.getAnswerCnt(Integer.parseInt(vBrdID), Integer.parseInt(vItemNo), Integer.parseInt(questionNo));
        	int ansRCnt = qstAnswerVOList.size();
        	
        	if(ansRCnt > 0){
        		/** dataAnswerProcessSP*/
        		int rCnt = 0, percent = 0, iCount = 0;
        		float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
        		
        		for(QstAnswerVO qstAnswer : qstAnswerVOList){
        			iCount ++;
        			rCnt = ezQuestionService.pollRespCnt(Integer.parseInt(vBrdID), Integer.parseInt(vItemNo), Integer.parseInt(questionNo), iCount);

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
        			CDATASection = resultXML.createCDATASection(" [" + egovMessageSource.getMessage("ezQuestion.t57", locale)+commonUtil.cleanValue(qstAnswer.getAnswerContent()));
        			nodeData.appendChild(CDATASection);
        			node.appendChild(nodeData);

        			nodeData= resultXML.createElement("DATA1");
        			nodeData.setTextContent("A");
        			node.appendChild(nodeData);

        			rNode.appendChild(node);

        			node = resultXML.createElement("CELL");

        			nodeData = resultXML.createElement("VALUE");
        			nodeData.setTextContent(rCnt + " " + egovMessageSource.getMessage("ezQuestion.t53", locale));
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t46", locale));
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t47", locale));
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t48", locale));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);

        listView.appendChild(rNodes);
        resultXML.appendChild(listView);
        
        return commonUtil.convertDocumentToString(resultXML);
	}
	
	/**
	 * 전자설문 설문리스트 상세분석 분류항목 부서 일때 HTML Code 생성 호출 함수
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstCallAnalysisDept4.do" , method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstCallAnalysisDept4(Locale locale, HttpServletRequest request) throws Exception{
		String vBrdID="", vItemNo="", vQuesNo="", sort="", sTotal = "0";
		String questionNo = "", quesContent = "", answerObjecivity ="", responseUserDeptName="", qCount="";
		int responseCnt = 0, iDataCount=0;
		float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
		String title="", answer="", qPercent="", responNum="";
		
		vBrdID = request.getParameter("brdID");
    	vItemNo = request.getParameter("itemNo");
    	vQuesNo = request.getParameter("quesNo");
    	
        if(vQuesNo.length()==0){
        	vQuesNo="0";
        }
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
        	quesContent = commonUtil.cleanValue(qstResponseVO.getQuesContent());
        	answer = commonUtil.cleanValue(qstResponseVO.getAnswer());
        	answerObjecivity = Integer.toString(qstResponseVO.getAnswerObjectivity());
        	qCount = Integer.toString(qstResponseVO.getqCount());
        	
        	title = qstResponseVO.getResponseUserDeptName();
        	
        	if(responseUserDeptName == null){
        		title = egovMessageSource.getMessage("ezQuestion.t56", locale);
        	}
        	
        	qPercent="w";
        	sort="A";
        	
        	if(responseUserDeptName == null || responseUserDeptName.toUpperCase() == "NULL"){
        		title = " [" + egovMessageSource.getMessage("ezQuestion.t57", locale) + answer;
        		qPercent = "";
        		sort="Q";
        	}
        	if(answerObjecivity.equals("0")){
        		answerObjecivity ="0";
        	}
        	if(Integer.parseInt(answerObjecivity)==0){
        		title = quesContent;
        		sTotal = qCount;
        		qPercent = "";
        	}
        	if(questionNo.equals("0")){
        		title = egovMessageSource.getMessage("ezQuestion.t54", locale);
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
        	responseCnt = ezQuestionService.getResPersonCnt(Integer.parseInt(vBrdID), Integer.parseInt(vItemNo), Integer.parseInt(questionNo));

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
        	
        	if(questionNo.equals("0")){
        		nodeData.setTextContent(responNum + egovMessageSource.getMessage("ezQuestion.t53", locale));
        	}else{
        		nodeData.setTextContent(qCount + egovMessageSource.getMessage("ezQuestion.t53", locale));
        	}
        	
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	
        	if(qPercent.equals("0%") != true){
        		nodeData.setTextContent(qPercent);
        	}
        	
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t46", locale));
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t47", locale));
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t48", locale));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);

        listView.appendChild(rNodes);
        resultXML.appendChild(listView);
        
        return commonUtil.convertDocumentToString(resultXML);
	}
	
	/**
	 * 전자설문 설문리스트 상세분석 분류항목 직위 일때 HTML Code 생성 호출 함수
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstCallAnalysisPos2.do" , method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstCallAnalysisPos2(Locale locale, HttpServletRequest request) throws Exception{
		String vBrdID="", vItemNo="", vQuesNo="", sort="", sTotal = "0";
		String questionNo = "", quesContent = "", answerObjecivity ="", responseUserPosition="", qCount="";
		int responseCnt = 0, iDataCount=0;
		float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
		String title="", answer="", qPercent="", responNum="";
		
		vBrdID = request.getParameter("brdID");
    	vItemNo = request.getParameter("itemNo");
    	vQuesNo = request.getParameter("quesNo");
    	
        if(vQuesNo.length()==0){
        	vQuesNo="0";
        }
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
        	quesContent = commonUtil.cleanValue(qstResponseVO.getQuesContent());
        	answer = commonUtil.cleanValue(qstResponseVO.getAnswer());
        	answerObjecivity = Integer.toString(qstResponseVO.getAnswerObjectivity());
        	qCount = Integer.toString(qstResponseVO.getqCount());
        	
        	
        	title = qstResponseVO.getResponseUserPosition();
        	
        	if(responseUserPosition == null){
        		title = egovMessageSource.getMessage("ezQuestion.t56", locale);
        	}
        	
        	qPercent="w";
        	sort="A";
        	
        	if(responseUserPosition == null || responseUserPosition.toUpperCase().equals("NULL")){
        		title = " [" + egovMessageSource.getMessage("ezQuestion.t57", locale) + answer;
        		qPercent = "";
        		sort="Q";
        	}
        	if(answerObjecivity.equals("0")){
        		answerObjecivity ="0";
        	}
        	if(Integer.parseInt(answerObjecivity)==0){
        		title = quesContent;
        		sTotal = qCount;
        		qPercent = "";
        	}
        	if(questionNo.equals("0")){
        		title = egovMessageSource.getMessage("ezQuestion.t54", locale);
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
        	responseCnt = ezQuestionService.getResPersonCnt(Integer.parseInt(vBrdID), Integer.parseInt(vItemNo), Integer.parseInt(questionNo));

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
        	
        	if(questionNo.equals("0")){
        		nodeData.setTextContent(responNum + egovMessageSource.getMessage("ezQuestion.t53", locale));
        	}else{
        		nodeData.setTextContent(qCount + egovMessageSource.getMessage("ezQuestion.t53", locale));
        	}
        	
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	
        	if(qPercent.equals("0%") != true){
        		nodeData.setTextContent(qPercent);
        	}
        	
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t46", locale));
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t47", locale));
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t48", locale));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);

        listView.appendChild(rNodes);
        resultXML.appendChild(listView);
        
		return commonUtil.convertDocumentToString(resultXML);
	}
	
	/**
	 * 전자설문 설문리스트 상세분석 분류항목 직급 일때 HTML Code 생성 호출 함수
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value="/ezQuestion/qstCallAnalysisJikgub2.do" , method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String qstCallAnalysisJikgub2(Locale locale, HttpServletRequest request) throws Exception{
		String vBrdID="", vItemNo="", vQuesNo="", sort="", sTotal = "0";
		String questionNo = "", quesContent = "", answerObjecivity ="", responseJikgub="", qCount="";
		int responseCnt = 0, iDataCount=0;
		float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
		String title="", answer="", qPercent="", responNum="";
		
		vBrdID = request.getParameter("brdID");
    	vItemNo = request.getParameter("itemNo");
    	vQuesNo = request.getParameter("quesNo");
    	
        if(vQuesNo.length()==0){
        	vQuesNo="0";
        }
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
        	quesContent = commonUtil.cleanValue(qstResponseVO.getQuesContent());
        	answer = commonUtil.cleanValue(qstResponseVO.getAnswer());
        	answerObjecivity = Integer.toString(qstResponseVO.getAnswerObjectivity());
        	qCount = Integer.toString(qstResponseVO.getqCount());
        	
        	
        	title = qstResponseVO.getResponseUserJikgub();
        	
        	if(responseJikgub == null){
        		title = egovMessageSource.getMessage("ezQuestion.t56", locale);
        	}
        	
        	qPercent="w";
        	sort="A";
        	
        	if(responseJikgub == null || responseJikgub.toUpperCase().equals("NULL")){
        		title = " [" + egovMessageSource.getMessage("ezQuestion.t57", locale) + answer;
        		qPercent = "";
        		sort="Q";
        	}
        	if(answerObjecivity.equals("0")){
        		answerObjecivity ="0";
        	}
        	if(Integer.parseInt(answerObjecivity)==0){
        		title = quesContent;
        		sTotal = qCount;
        		qPercent = "";
        	}
        	if(questionNo.equals("0")){
        		title = egovMessageSource.getMessage("ezQuestion.t54", locale);
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
        	responseCnt = ezQuestionService.getResPersonCnt(Integer.parseInt(vBrdID), Integer.parseInt(vItemNo), Integer.parseInt(questionNo));

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
        	
        	if(questionNo.equals("0")){
        		nodeData.setTextContent(responNum + egovMessageSource.getMessage("ezQuestion.t53", locale));
        	}else{
        		nodeData.setTextContent(qCount + egovMessageSource.getMessage("ezQuestion.t53", locale));
        	}
        	
        	node.appendChild(nodeData);

        	node = resultXML.createElement("CELL");
        	rNode.appendChild(node);

        	nodeData = resultXML.createElement("VALUE");
        	
        	if(qPercent.equals("0%") != true){
        		nodeData.setTextContent(qPercent);
        	}
        	
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t46", locale));
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t47", locale));
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
        node.setTextContent(egovMessageSource.getMessage("ezQuestion.t48", locale));
        nodeData.appendChild(node);

        node = resultXML.createElement("WIDTH");
        node.setTextContent("20");
        nodeData.appendChild(node);

        listView.appendChild(rNodes);
        resultXML.appendChild(listView);
        
		return commonUtil.convertDocumentToString(resultXML);
	}
	
	/**
	 * 전자설문 설문리스트 상세분석 분석결과 저장 실행 함수
	 */
	@RequestMapping(value = "/ezQuestion/qstResultAnalysisSave.do")
	public void qstResultAnalysisSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		String hidRType2 = "";
		
		if(request.getParameter("hidRType2") != null){
			hidRType2 = request.getParameter("hidRType2");
		}
		
		@SuppressWarnings("resource")
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet;
		Row row;
		Cell cell;
		
		String pFileName = "";
		String strDate = EgovDateUtil.getToday("-");
		String StrAnalysisDate = request.getParameter("AnalysisData").replaceAll("&nbsp;", "").trim();

		Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate);
		Node tableNode = analysisData.getElementsByTagName("table").item(0);
		Node tableHeadNode;
		Node tableBodyNode ;
//		subjective
		if(hidRType2.equals("A")){
			pFileName = strDate+"_Report.xls";
			sheet = workbook.createSheet("report");
			tableHeadNode = tableNode.getChildNodes().item(1);
			tableBodyNode = tableNode.getChildNodes().item(2);
			row = sheet.createRow(0);
			
			for(int i=0; i<tableHeadNode.getChildNodes().item(0).getChildNodes().getLength(); i++){
				cell = row.createCell(i);
				cell.setCellValue(tableHeadNode.getChildNodes().item(0).getChildNodes().item(i).getTextContent());
			}
			
			for(int i=1; i<=tableBodyNode.getChildNodes().getLength(); i++){
				row = sheet.createRow(i);
				Node tr = tableBodyNode.getChildNodes().item(i-1);
				
				for(int j=0; j<tr.getChildNodes().getLength(); j++){
					cell = row.createCell(j);
					cell.setCellValue(tr.getChildNodes().item(j).getTextContent());
				}
			}
//		table
		}else if(hidRType2.equals("T")){
			pFileName = strDate+"_Table.xls";
			sheet = workbook.createSheet("table");
			tableHeadNode = tableNode.getChildNodes().item(0);
			tableBodyNode = tableNode.getChildNodes().item(1);
			row = sheet.createRow(0);
			
			for(int i=0; i<tableHeadNode.getChildNodes().item(0).getChildNodes().getLength(); i++){
				cell = row.createCell(i);
				cell.setCellValue(tableHeadNode.getChildNodes().item(0).getChildNodes().item(i).getTextContent());
			}
			
			for(int i=1; i<=tableBodyNode.getChildNodes().getLength(); i++){
				row = sheet.createRow(i);
				Node tr = tableBodyNode.getChildNodes().item(i-1);
				
				for(int j=0; j<tr.getChildNodes().getLength(); j++){
					cell = row.createCell(j);
					cell.setCellValue(tr.getChildNodes().item(j).getTextContent());
				}
			}
//		graph
		}else{
			pFileName = strDate+"_Graph.xls";			
			sheet = workbook.createSheet("graph");
			tableBodyNode = tableNode.getChildNodes().item(0);
			
			for(int i=0; i<tableBodyNode.getChildNodes().getLength(); i++){
				row = sheet.createRow(i);
				Node tr = tableBodyNode.getChildNodes().item(i);
				
				for(int j=0; j<tr.getChildNodes().getLength(); j++){
					cell = row.createCell(j);
					cell.setCellValue(tr.getChildNodes().item(j).getTextContent());
				}
			}
		}
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		workbook.write(response.getOutputStream());
	}
	
	/**
	 * 전자설문 설문리스트 상세분석 전체결과 저장 실행 함수
	 */
	@SuppressWarnings({ "unused", "resource" })
	@RequestMapping(value = "/ezQuestion/resultTotalSave.do")
	public void resultTotalSave(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String brforeQuestionNo="", questionNo = "", qUser="", comma="";
		String answer="", answerStr="";
		String itemNo="", headerInfo="";
		int maxNum=0, sNo=0;
		String qNum = "0";
		String RID = "";
        String strData = "", strKey = "";
        
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("report");
		Row row;
		Cell cell;
		
		itemNo = request.getParameter("itemNo");
		
		if(itemNo != ""){
			row = sheet.createRow(0);
			headerInfo = ";" + egovMessageSource.getMessage("ezQuestion.t552", locale) + "\r\n";
			cell = row.createCell(0);
			cell.setCellValue(headerInfo);
            headerInfo = egovMessageSource.getMessage("ezQuestion.t553", locale);
            
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
					strKey=qstResponseVO.getResponseUserID()+","+qUser+","+qstResponseVO.getResponseUserPosition()+","+qstResponseVO.getResponseUserDeptName();
		
					if(qstResponseVO.getQuestionNo() != Integer.parseInt(qNum) || RID != qstResponseVO.getResponseUserID()){
						comma = ",";
					}else{
						comma = "- -";
					}
					
					RID = qstResponseVO.getResponseUserID();
					
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
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + "report" + ".xls\"");
		workbook.write(response.getOutputStream());
	}
	/**
	 * 전자설문 설문생성 설문대상 정보 저장 실행 함수
	 */
	@RequestMapping(value="/ezQuestion/callSaveRangeACL.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String callSaveRangeACL(@RequestBody String xmlDoc,HttpServletRequest request,Model model) throws Exception{
		Document doc = commonUtil.convertStringToDocument(xmlDoc);

		//boolean deptFlag = false;
		//String pBrdID = doc.getElementsByTagName("BRDID").item(0).getTextContent(), pItemNo = doc.getElementsByTagName("ITEMNO").item(0).getTextContent();
        String USER_DEPT_ID = "", USER_EMAIL = "", USER_POS = "", USER_DEPT_NM = "", USER_GENDER = "";

        /*int Get_ItemNo = 0;*/
        /*String strSQL = "";*/
        String GubunNm = "", GubunID = "", GubunFg = "";
        String GubunNm2 = "";
        String USER_POS2 = "", USER_DEPT_NM2 = "";
        
            
       /* if(pItemNo == "")  {
        	ezQuestionService.callGetItemSeq(Integer.parseInt(pBrdID));
         
        Get_ItemNo = ezQuestionService.callGetItemSeq(Integer.parseInt(pBrdID));
        
        if(Get_ItemNo == 0) {
        	Get_ItemNo = 1;
        	ezQuestionService.callInsertItemSeq(Integer.parseInt(pBrdID));
        } else {
        	Get_ItemNo = Get_ItemNo + 1;
        	ezQuestionService.callUpdateItemSeq(Integer.parseInt(pBrdID), Get_ItemNo);
        }
        pItemNo = String.valueOf(Get_ItemNo);
        } else {
        	ezQuestionService.callDeleteItemSeq(Integer.parseInt(pBrdID), Integer.parseInt(pItemNo));
        }*/
        
        int deptSize = doc.getElementsByTagName("DEPT").item(0).getChildNodes().getLength();

        for(int i=0; i<deptSize; i++) {
        	GubunNm = doc.getElementsByTagName("DATA").item(i).getAttributes().getNamedItem("nm").getTextContent();
        	GubunNm2 = doc.getElementsByTagName("DATA").item(i).getAttributes().getNamedItem("nm2").getTextContent();
        	GubunID = doc.getElementsByTagName("DATA").item(i).getTextContent();
        	GubunFg = "0";
        	QstCompleteVO qstCompleteVO = new QstCompleteVO();
        	qstCompleteVO.setStrBrdID(Integer.parseInt(doc.getElementsByTagName("BRDID").item(0).getTextContent()));
        	qstCompleteVO.setItemNo(Integer.parseInt(doc.getElementsByTagName("ITEMNO").item(0).getTextContent()));
        	qstCompleteVO.setGubunFg(GubunFg);
        	qstCompleteVO.setGubunID(GubunID);
        	qstCompleteVO.setGubunNm(GubunNm);
        	qstCompleteVO.setGubunNm2(GubunNm2);
        	ezQuestionService.callCreateMother(qstCompleteVO);
        }
        
        ezQuestionService.callDeletePollResponseper(Integer.parseInt(doc.getElementsByTagName("BRDID").item(0).getTextContent()), Integer.parseInt(doc.getElementsByTagName("ITEMNO").item(0).getTextContent()));
        
        int memberSize = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().getLength();
                for(int i=0; i<memberSize; i++) {
                	GubunID = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getTextContent();
                	GubunNm = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("nm").getTextContent();
                	GubunNm2 = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("nm2").getTextContent();
                	GubunFg = "1";
                	QstCompleteVO qstCompleteVO = new QstCompleteVO();
                	qstCompleteVO.setStrBrdID(Integer.parseInt(doc.getElementsByTagName("BRDID").item(0).getTextContent()));
                	qstCompleteVO.setItemNo(Integer.parseInt(doc.getElementsByTagName("ITEMNO").item(0).getTextContent()));
                	qstCompleteVO.setGubunFg(GubunFg);
                	qstCompleteVO.setGubunID(GubunID);
                	qstCompleteVO.setGubunNm(GubunNm);
                	qstCompleteVO.setGubunNm2(GubunNm2);
                	ezQuestionService.callCreateMother(qstCompleteVO);
                	
                	//String propList = "department;mail;displayname;title;description;company";
                	//OrganDeptVO pXML = ezOrganService.getPropertyList(GubunID, user.getPrimary());
                	
                	//ezOrgan 라이브러리 getPropertyList
                	//String pXML = _ezOrgan.GetPropertyList(GubunID, proplist, userinfo.primary);
                	
                	QstCompleteVO qstCompleteVO2 = new QstCompleteVO();
                	qstCompleteVO2.setStrBrdID(Integer.parseInt(doc.getElementsByTagName("BRDID").item(0).getTextContent()));
                	qstCompleteVO2.setItemNo(Integer.parseInt(doc.getElementsByTagName("ITEMNO").item(0).getTextContent()));
                	qstCompleteVO2.setGubunID(GubunID);
                	qstCompleteVO2.setGubunNm(GubunNm);
                	qstCompleteVO2.setGubunNm2(GubunNm2);
                	qstCompleteVO2.setUserEmail(USER_EMAIL);
                	qstCompleteVO2.setUserDeptID(USER_DEPT_ID);
                	qstCompleteVO2.setUserDeptNm(USER_DEPT_NM);
                	qstCompleteVO2.setUserDeptNm2(USER_DEPT_NM2);
                	qstCompleteVO2.setUserPOS(USER_POS);
                	qstCompleteVO2.setUserPOS2(USER_POS2);
                	qstCompleteVO2.setUserGender(USER_GENDER);
                	qstCompleteVO2.setUserAge(25);
                	ezQuestionService.callInsertPollResponseper(qstCompleteVO2);
                }
                
                /*if(deptFlag) {
                	String strTest;
                	String userID = "",  userNM = "" ,userEmail = "", userDeptID = "", userDeptNM = "";
                	String userPos = "", userJikgub = "", userGender = "", userAge = "";
                	String userCompany = "";
                	String userNM2 = "", userDeptNM2 = "", userPos2 = "";
                	
                	String celllist = "department";
                    String proplist = "department;mail;displayname;title;description;company;title";
                    String pclass = "all";
                	
                    for(int i=0; i<deptSize; i++) {
                    	//GetDeptMemberList
                    	//String sXml =  _ezOrgan.GetDeptMemberList(xmlData[0].ChildNodes[i].InnerText, celllist, proplist, pclass, userinfo.primary);
                    	int iCount = 0;
                    }
                }*/
                String result = "";
                String strXML = "";
               strXML = "<RESULT>";
               strXML = strXML + "<DATA>" + result + "</DATA>";
               strXML = strXML + "<ITEMNO>" + Integer.parseInt(doc.getElementsByTagName("ITEMNO").item(0).getTextContent()) + "</ITEMNO>";
               strXML = strXML + "</RESULT>";
               return strXML;
	} 
	
	/**
	 * 전자설문 설문생성 ITEM SEQ 실행 함수
	 */
	@RequestMapping(value="/ezQuestion/callGetItemSeqXML.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String callGetItemSeqXML(HttpServletRequest req, Model model) throws Exception{
		String pBrdID = "";
		if(req.getParameter("brdID") != null) {
			pBrdID = req.getParameter("brdID");
		}
        int getItemNo = 0;
        int maxNo = ezQuestionService.callGetItemSeq(Integer.parseInt(pBrdID));
        if(String.valueOf(maxNo) == "")  {
        	getItemNo = 0;
        } else {
        	getItemNo = maxNo;
        }
        if(getItemNo == 0) {
        	getItemNo = 1;
        	ezQuestionService.callInsertItemSeq(Integer.parseInt(pBrdID));
        } else {
        	getItemNo = getItemNo + 1;
        	ezQuestionService.callUpdateItemSeq(Integer.parseInt(pBrdID), getItemNo);
        }
       
        String strXML = "<RESULT>";
        strXML = strXML + "<DATA>OK</DATA>";
        strXML = strXML + "<ITEMNO>"+getItemNo+"</ITEMNO>";
        strXML = strXML + "</RESULT>";
        
        return strXML;
	}

	/**
	 * 전자설문 설문리스트 정보수정 화면 호출 함수
	 */
	@RequestMapping("/ezQuestion/qstChangePermission.do")
	public String qstChangePermission(@CookieValue("loginCookie") String loginCookie, ModelMap model,HttpServletRequest req) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		QstListVO qstListVO = new QstListVO();
		String brdID = "5";
		String itemID = "";
		String saveFlg = "";
		String title = "", responseRange = "", postDate = "", pollEndDate = "", currPage = "1";
		int pageSize=15;
		boolean resultYN = false;
		qstListVO.setUserID(loginVO.getId());
		
		if(req.getParameter("brdID") != null) 
			brdID = req.getParameter("brdID");
		if(req.getParameter("itemNo") != null) 
			itemID = req.getParameter("itemNo");
		if(req.getParameter("save") != null) 
			saveFlg = req.getParameter("save");
		if(req.getParameter("title")!=null)
			title = req.getParameter("title");
		if(req.getParameter("responseRange")!=null)
			responseRange = req.getParameter("responseRange");
		if(req.getParameter("postDate")!=null)
			postDate = req.getParameter("postDate");
		if(req.getParameter("pollEndDate")!=null)
			pollEndDate = req.getParameter("pollEndDate");
		if(req.getParameter("currPage")!=null)
			currPage = req.getParameter("currPage");
		
		if(itemID == null || itemID == "" || itemID.equals("")) {
			itemID = "0";
		}
		
		qstListVO.setBrdID(Integer.parseInt(brdID));
		qstListVO.setTitle(title);
		qstListVO.setResponseRange(responseRange);
		qstListVO.setPostDate(postDate);
		qstListVO.setPollEndDate(pollEndDate);
		qstListVO.setCurrPage(Integer.parseInt(currPage));
		qstListVO.setPageSize(pageSize);

		String receve = "brdID=" + qstListVO.getBrdID() +
                "&title=" + commonUtil.cleanValue(qstListVO.getTitle()) +
                "&responseRange=" + qstListVO.getResponseRange() +
                "&postDate=" + qstListVO.getPostDate() +
                "&pollEndDate=" + qstListVO.getPollEndDate() +
                "&currPage=" + qstListVO.getCurrPage();
		
		String curDate = EgovDateUtil.getTodayTime();
		
		QstUserPollItemVO qstUserPollItemVO = new QstUserPollItemVO();
		qstUserPollItemVO.setBrdID(Integer.parseInt(brdID));
		qstUserPollItemVO.setItemNo(Integer.parseInt(itemID));
		qstUserPollItemVO = ezQuestionService.getUserPollItem(qstUserPollItemVO);

		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		qstUserPermissionVO.setBrdID(Integer.parseInt(brdID));
		qstUserPermissionVO.setItemNo(Integer.parseInt(itemID));
		qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);
		
		/*String publicResultFlg = qstUserPermissionVO.getPublicResultFlg();
		String publicFlg = qstUserPermissionVO.getPublicFlg();
		String multiResponseFlg = qstUserPermissionVO.getMultiResponseFlg();
		String endFlg = qstUserPermissionVO.getEndFlg();
		responseRange = qstUserPermissionVO.getResponseRange();*/
		
		/*boolean bPublic;
        if (publicFlg == "1"){
            bPublic = true;
        }else{
            bPublic = false;
        }*/
        
        //권한
        //int responseNo = ezQuestionService.getQstResponse(Integer.parseInt(req.getParameter("brdId")), Integer.parseInt(req.getParameter("itemNo")));

       /* if(responseNo == 2) {
        		resultYN = true;
        } else {
        		resultYN = false;
        }*/
		SimpleDateFormat s = new SimpleDateFormat("YYYY-MM-dd");
        String pollStartDate = s.parse(qstUserPollItemVO.getPollStartDate()).toString(); 
        pollEndDate = s.parse(qstUserPollItemVO.getPollEndDate()).toString(); 
        String uploadSDate = isoUTFDate(pollStartDate).toString();
        String uploadEDate = isoUTFDate(pollEndDate).toString();
		model.addAttribute("uploadSDate", uploadSDate);
		model.addAttribute("uploadEDate", uploadEDate);
		model.addAttribute("qstUserPollItemVO", qstUserPollItemVO);
		model.addAttribute("qstListVO", qstListVO);
		model.addAttribute("qstUserPermissionVO", qstUserPermissionVO);
		model.addAttribute("receve", receve);
		model.addAttribute("resultYN", resultYN);
		model.addAttribute("saveFlg", saveFlg);
		model.addAttribute("mPostDate", curDate);
		return "/ezQuestion/qstChangePermission";
	}
	
	/**
	 * 전자설문 설문리스트 정보수정 실행 함수
	 */
	@RequestMapping("/ezQuestion/callChangePermission.do")
	public void callChangePermission(Model model,HttpServletRequest req, HttpServletResponse resp) throws Exception {
		String brdID = "5";
		String itemID = "";
		if(req.getParameter("itemNo") != null) 
		itemID = req.getParameter("itemNo");
		QstUserPollItemVO qstUserPollItemVO = new QstUserPollItemVO();
		qstUserPollItemVO.setBrdID(Integer.parseInt(brdID));
		qstUserPollItemVO.setItemNo(Integer.parseInt(itemID));
		qstUserPollItemVO.setTitle(req.getParameter("txtSubject"));
		qstUserPollItemVO.setContent(req.getParameter("txtContent"));
		qstUserPollItemVO.setPostTerm(Integer.parseInt(req.getParameter("txtExpiredate")));
		qstUserPollItemVO.setPostDate(req.getParameter("hidStartDate"));
		qstUserPollItemVO.setPollEndDate(req.getParameter("hidEndDate"));
		
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		qstUserPermissionVO.setBrdID(Integer.parseInt(brdID));
		qstUserPermissionVO.setItemNo(Integer.parseInt(itemID));
		qstUserPermissionVO.setPublicResultFlg(req.getParameter("hidopenResult"));
		qstUserPermissionVO.setPublicFlg(req.getParameter("hidanonymity"));
		qstUserPermissionVO.setMultiResponseFlg(req.getParameter("hidMultiResponse"));
		qstUserPermissionVO.setEndFlg("1");
		qstUserPermissionVO.setResponseRange(req.getParameter("hidTarget"));
		
		ezQuestionService.changePermission(qstUserPermissionVO, qstUserPollItemVO);
		
		resp.sendRedirect("/ezQuestion/qstChangePermission.do?endpoll="+qstUserPermissionVO.getEndFlg()+"&itemNo="+qstUserPermissionVO.getItemNo()+"&"+req.getParameter("Receve_str2")+"&save=OK");
	}
	
	/**
	 * 전자설문 설문리스트 즉시마감 실행 함수
	 */
	@RequestMapping("/ezQuestion/callEndPoll.do")
	public void callEndPoll(Model model,HttpServletRequest req, HttpServletResponse resp) throws Exception {
		String brdID = "5";
		String itemID = "";
		String endDate = "";
		
		if(req.getParameter("itemNo") != null) 
		itemID = req.getParameter("itemNo");

		if(req.getParameter("hidEndPoll").equals("1")){
			 endDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()).toString();
		}
		ezQuestionService.updatePollEndDate(Integer.parseInt(brdID), Integer.parseInt(itemID), endDate, req.getParameter("hidEndPoll"));
	}
	
	/**
	 * 전자설문 설문리스트 STEP1 재사용 화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstStep1ReUse.do")
	public String qstStep1ReUse(HttpServletRequest req,Model model) throws Exception {
		String brdID = "";
		String itemID = "";
		if(req.getParameter("brdID") != null) 
			brdID = req.getParameter("brdID");
		if(req.getParameter("itemID") != null)
			itemID = req.getParameter("itemID");
		String brdNm = req.getParameter("brdNm");
		String brdPostterm = req.getParameter("brdPostterm");
		//String[] pDate  = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()).split("-");
		//String curDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
		
		String startDateTime = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()).toString();
		String endDateTime = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()).toString();

		QstReuseQuestionVO qstReuseQuestionVO = new QstReuseQuestionVO();
		
		qstReuseQuestionVO =  ezQuestionService.reUseQuestionData(Integer.parseInt(brdID),Integer.parseInt(itemID));
		
		QstUserPermissionVO qstUserPermissionVO = new QstUserPermissionVO();
		qstUserPermissionVO.setBrdID(Integer.parseInt(brdID));
		qstUserPermissionVO.setItemNo(Integer.parseInt(itemID));
		qstUserPermissionVO = ezQuestionService.getUserPermission(qstUserPermissionVO);

		model.addAttribute("brdID", brdID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdPostterm", brdPostterm);
		model.addAttribute("uploadSDate", startDateTime);
		model.addAttribute("uploadEDate", endDateTime);
		model.addAttribute("qstReuseQuestionVO", qstReuseQuestionVO);
		model.addAttribute("qstUserPermissionVO", qstUserPermissionVO);
		return "/ezQuestion/qstStep1ReUse";
	}
	
	/**
	 * 전자설문 설문리스트 STEP2 재사용 화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstStep2ReUse.do")
	public String qstStep2ReUse(HttpServletRequest req,Model model, QstStep1VO qstStep1VO, QstAddVO qstAddVO) throws Exception {
		String oldItemNum = "";
		if(req.getParameter("oldItemNum") != null) {
			oldItemNum = req.getParameter("oldItemNum"); 
		}
		String itemID = "";
		if(req.getParameter("itemNo") != null) {
			itemID = req.getParameter("itemNo"); 
		}
		
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
		
		qstStep1VO.setItemNo(itemID);
		model.addAttribute("oldItemNum", Integer.parseInt(oldItemNum));
		model.addAttribute("qstStep1VO", qstStep1VO);
		model.addAttribute("qstAddVO", qstAddVO);
		model.addAttribute("pStep1DataXML", pStep1DataXML);
		return "/ezQuestion/qstStep2ReUse";
	}
	
	/**
	 * 전자설문 설문리스트 재사용 정보 불러오기 실행 함수
	 */
/*	@RequestMapping(value="/ezQuestion/callTempLoad.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callTempLoad(@RequestBody String xmlDoc,HttpServletRequest req,Model model) throws Exception {
		Document objXML = commonUtil.convertStringToDocument(xmlDoc);
		String itemId = "";
		int itemNo = 0;
		String strQstNo = "";
		String lastItemNo = "0";
		String[] arrQuestion;
		String strQuestion = "";
		String temp = "";
		if(req.getParameter("item_id") != null && req.getParameter("item_id").length() != 0) {
			itemId = req.getParameter("item_id");
			itemNo = Integer.parseInt(itemId);
		}

		ezQuestionService.questionDelete2(5, Integer.parseInt(itemId));
		
		strQuestion = objXML.getChildNodes().item(0).getTextContent().trim();
		arrQuestion = strQuestion.trim().split("\\;\\;");
		
		String[] arrLine;
		String strResult = "";
		boolean chkType = false;

		List<QstTempSaveVO> qstTempSaveVO = ezQuestionService.tempSave(5, itemNo);
		
		StringBuilder str = new StringBuilder();
		str.append("<DATA>");
		
		if(arrQuestion.length > 0) {
			str.append("<QUESTION>");
			for(int j=0; j<arrQuestion.length; j++) {
				arrLine = arrQuestion[j].trim().split("\\|\\|");
				
				if(arrLine.length < 2) {
					break;
				}
				if(strQstNo.trim() != lastItemNo.trim()) {
					strResult = strResult.replace("| " + arrLine[1], "");
					strResult = strResult + "| " + arrLine[1] + ";" + arrLine[5];
					
				}
			}

			temp = strResult;
			str.append(temp);
			str.append("</QUESTION>");
			for(int i=0; i<arrQuestion.length; i++) {
				arrLine = arrQuestion[i].trim().split("\\|\\|");

				if(arrLine.length < 2) {
					break;
				}
				strQstNo = arrLine[0];
				
				if(strQstNo.trim() != lastItemNo.trim()) {
					strResult = strResult.replace("| "+arrLine[1], "");
					strResult = strResult + "| "+arrLine[1]+";"+arrLine[5];
					
					str.append("<ROW>");
					str.append("<QUESTIONCONTENT>" + arrLine[1] + "</QUESTIONCONTENT>");
					str.append("<ANSWERTYPE>" + arrLine[2] + "</ANSWERTYPE>");
					str.append("<MULTISELECT>" + arrLine[4] + "</MULTISELECT>");
					str.append("<SELVIEWSTART>0</SELVIEWSTART>");
					str.append("<SELVIEWEND>0</SELVIEWEND>");

					QstAttachVO qstAttachVO = new QstAttachVO();
					qstAttachVO.setBrdId(5);
					qstAttachVO.setItemNo(Integer.parseInt(itemId));
					qstAttachVO.setQuestionNo(Integer.parseInt(arrLine[0]));
					
					List<QstAttachVO> qstAttach =  ezQuestionService.getAttachInfo3(qstAttachVO);
					
					if(qstAttach.size() > 0) {
						for(int k=0; k<qstAttach.size(); k++) {
							str.append("<ATTACH>");
							str.append("<ROW>");
							str.append("<TYPE>" + qstAttach.get(k).getAttachType() + "</TYPE>");
							str.append("<TITLE>" + qstAttach.get(k).getAttachName() + "</TITLE>");
							str.append("<HREF>" + qstAttach.get(k).getAttachUrl() + "</HREF>");
							str.append("</ROW>");
							str.append("</ATTACH>");
						}
					}
					
					if(arrLine[2] == "5") {
						List<String> tableAnswerValue = ezQuestionService.tableAnswerValue(5, Integer.parseInt(itemId), qstTempSaveVO.get(i).getQuestionNo());
						for(String tableAnswer : tableAnswerValue) {
							str.append("<ANSWER_ANSWER>");
							str.append("<ANSWER_TITLE>"+tableAnswer+"</ANSWER_TITLE>");
							str.append("</ANSWER_ANSWER>");
						}
					}
					ezQuestionService.questionDelete1(5, Integer.parseInt(itemId), Integer.parseInt(arrLine[0]));
					QstCompleteVO qstCompleteVO = new QstCompleteVO();
					qstCompleteVO.setQuesContent(arrLine[1]);
					qstCompleteVO.setAnswerType(Integer.parseInt(arrLine[2]));
					qstCompleteVO.setMultiSelect(arrLine[4]);
					qstCompleteVO.setStrBrdID(5);
					qstCompleteVO.setItemNo(Integer.parseInt(itemId));
					qstCompleteVO.setQuesNo(Integer.parseInt(arrLine[0]));
					qstCompleteVO.setAnswerNo(Integer.parseInt(arrLine[7]));
					qstCompleteVO.setAnswerContent(arrLine[8].replace("'", "''"));
					
					ezQuestionService.insertQuestion(qstCompleteVO);
					ezQuestionService.insertAnswerContent(qstCompleteVO);
				}
				
				for(int j=0; j<arrQuestion.length; i++) {
					str.append("<ANSWER>");
					str.append("<ANSWERTITLE>"+arrLine[8]+"</ANSWERTITLE>");
					str.append("</ANSWER>");
				}
				str.append("</ROW>");
			}
			str.append("</DATA>");
			
		}

		
		return str.toString();
	}*/
	
	@RequestMapping(value="/ezQuestion/callTempLoad.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callTempLoad(@RequestBody String xmlDoc,HttpServletRequest req,Model model) throws Exception {
		Document objXML = commonUtil.convertStringToDocument(xmlDoc);
		String itemID = "";
		int itemNo = 0;
		String strQstNo = "";
		String lastItemNo = "0";
		String[] arrQuestion;
		String strQuestion = "";
		String temp = "";
		if(req.getParameter("itemID") != null && req.getParameter("itemID").length() != 0) {
			itemID = req.getParameter("itemID");
			itemNo = Integer.parseInt(itemID);
		}

		ezQuestionService.questionDelete2(5, Integer.parseInt(itemID));
		
		strQuestion = objXML.getChildNodes().item(0).getTextContent().trim();
		arrQuestion = strQuestion.trim().split("\\;\\;");
		
		String[] arrLine;
		String strResult = "";
//		boolean chkType = false;

		List<QstTempSaveVO> qstTempSaveVO = ezQuestionService.tempSave(5, itemNo);
		
		Document resultXML = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
		Node rNodes = resultXML.createElement("DATA");
		Node node = resultXML.createElement("QUESTION");
		Node nodeData;
		rNodes.appendChild(node);
		
		if(arrQuestion.length > 0) {
			for(int i=0; i<arrQuestion.length; i++) {
				arrLine = arrQuestion[i].trim().split("\\|\\|");

				if(arrLine.length < 2) {
					break;
				}
				strQstNo = arrLine[0];
				
				if(strQstNo.trim() != lastItemNo.trim()) {
					strResult = strResult.replace("| "+arrLine[1], "");
					strResult = strResult + "| "+arrLine[1]+";"+arrLine[5];
					
					node = resultXML.createElement("ROW");
					rNodes.appendChild(node);
					
					nodeData = resultXML.createElement("CONTENT");
					node.appendChild(resultXML.createTextNode(arrLine[1]));
					
					nodeData = resultXML.createElement("ANSWERTYPE");
					node.appendChild(resultXML.createTextNode(arrLine[2]));
					
					nodeData = resultXML.createElement("MULTISELECT");
					node.appendChild(resultXML.createTextNode(arrLine[4]));
					
					nodeData = resultXML.createElement("SELVIEWSTART");
					node.appendChild(resultXML.createTextNode("0"));
					
					nodeData = resultXML.createElement("SELVIEWEND");
					node.appendChild(resultXML.createTextNode("0"));
					
					QstAttachVO qstAttachVO = new QstAttachVO();
					qstAttachVO.setBrdID(5);
					qstAttachVO.setItemNo(Integer.parseInt(itemID));
					qstAttachVO.setQuestionNo(Integer.parseInt(arrLine[0]));
					
					List<QstAttachVO> qstAttach =  ezQuestionService.getAttachInfo3(qstAttachVO);
					
					
					
					Document xmlTemp = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
					
					if(qstAttach.size() > 0) {
						for(int k=0; k<qstAttach.size(); k++) {
							String rtv = commonUtil.getQueryResult(qstAttach.get(k));
							xmlTemp = commonUtil.convertStringToDocument(rtv);		
						}
					}
					
					if(xmlTemp.getElementsByTagName("ATTACHNO").getLength() > 0) {
						nodeData = resultXML.createElement("ATTACH");
						node.appendChild(nodeData);
						for(int j = 0; j < xmlTemp.getElementsByTagName("ATTACHNO").getLength(); j++) {
							Node nodeData2 = resultXML.createElement("ROW");
							nodeData.appendChild(nodeData2);
							Node nodeData3 = resultXML.createElement("TYPE");
							nodeData2.appendChild(xmlTemp.createTextNode(xmlTemp.getElementsByTagName("ATTACHTYPE").item(j).getTextContent()));
							
							nodeData3 = resultXML.createElement("TITLE");
							nodeData2.appendChild(xmlTemp.createTextNode(xmlTemp.getElementsByTagName("ATTACHNAME").item(j).getTextContent()));
							
							nodeData3 = resultXML.createElement("HREF");
							nodeData2.appendChild(xmlTemp.createTextNode(xmlTemp.getElementsByTagName("ATTACHURL").item(j).getTextContent()));
						}
					}
					
					if(arrLine[2] == "5") {
						String tableAnswerValue = ezQuestionService.tableAnswerValue(5, Integer.parseInt(itemID), qstTempSaveVO.get(i).getQuestionNo());
						xmlTemp = null;
						xmlTemp = commonUtil.convertStringToDocument(tableAnswerValue);
						
						for(int j = 0; j < xmlTemp.getElementsByTagName("ANSWER_ANSWERCONTENT").getLength(); j++) {
							Node nodeData2 = resultXML.createElement("ANSWER_ANSWER");
							node.appendChild(nodeData2);
							
							Node nodeTitle2 = resultXML.createElement("ANSWER_TITLE");
							nodeTitle2.setTextContent(String.valueOf(xmlTemp.createTextNode(xmlTemp.getElementsByTagName("ANSWER_ANSWERCONTENT").item(j).getTextContent())));
							nodeData2.appendChild(nodeTitle2);
							
						}
					}
					ezQuestionService.questionDelete1(5, Integer.parseInt(itemID), Integer.parseInt(arrLine[0]));
					QstCompleteVO qstCompleteVO = new QstCompleteVO();
					qstCompleteVO.setQuesContent(arrLine[1]);
					qstCompleteVO.setAnswerType(Integer.parseInt(arrLine[2]));
					qstCompleteVO.setMultiSelect(arrLine[4]);
					qstCompleteVO.setStrBrdID(5);
					qstCompleteVO.setItemNo(Integer.parseInt(itemID));
					qstCompleteVO.setQuesNo(Integer.parseInt(arrLine[0]));
					qstCompleteVO.setAnswerNo(Integer.parseInt(arrLine[7]));
					qstCompleteVO.setAnswerContent(arrLine[8].replace("'", "''"));
					
					ezQuestionService.insertQuestion(qstCompleteVO);
				}	
				QstCompleteVO qstCompleteVO = new QstCompleteVO();
				qstCompleteVO.setQuesContent(arrLine[1]);
				qstCompleteVO.setAnswerType(Integer.parseInt(arrLine[2]));
				qstCompleteVO.setMultiSelect(arrLine[4]);
				qstCompleteVO.setStrBrdID(5);
				qstCompleteVO.setItemNo(Integer.parseInt(itemID));
				qstCompleteVO.setQuesNo(Integer.parseInt(arrLine[0]));
				qstCompleteVO.setAnswerNo(Integer.parseInt(arrLine[7]));
				qstCompleteVO.setAnswerContent(arrLine[8].replace("'", "''"));
				ezQuestionService.insertAnswerContent(qstCompleteVO);
					
				nodeData = resultXML.createElement("ANSWER");
				node.appendChild(nodeData);
					
				Node nodeTitle = resultXML.createElement("TITLE");
				nodeTitle.setTextContent(arrLine[8]);
				nodeData.appendChild(nodeTitle);
					
				lastItemNo = strQstNo;

			}
		}
		rNodes.getFirstChild().setTextContent(strResult);

		String returnXML = commonUtil.convertDocumentToString(resultXML);

		return returnXML;
	}
		
	
	/**
	 * 전자설문 설문생성 재사용 정보 저장 실행 함수
	 */
	@RequestMapping(value="/ezQuestion/callTempSave.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callTempSave(HttpServletRequest req,Model model) throws Exception {
		
		String itemID = "";
		int itemNo = 0;
		
		if(req.getParameter("itemID") != null && req.getParameter("itemID").length() != 0) {
			itemID = req.getParameter("itemID");

			itemNo = Integer.parseInt(itemID);
		}
		
		List<QstTempSaveVO> qstTempSaveVO = ezQuestionService.tempSave(5, itemNo);
		
		StringBuilder str = new StringBuilder();
		str.append("<DATA>");
		for(int i=0; i<qstTempSaveVO.size(); i++) {
			str.append(qstTempSaveVO.get(i).getQuestionNo());
			str.append("||");
			str.append(qstTempSaveVO.get(i).getQuesContent());
			str.append("||");
			str.append(qstTempSaveVO.get(i).getAnswerType());
			str.append("||");
			str.append("0");
			str.append("||");
			str.append(qstTempSaveVO.get(i).getMultiSelect());
			str.append("||");
			str.append(qstTempSaveVO.get(i).getQuesSN());
			str.append("||");
			str.append(qstTempSaveVO.get(i).getQuestionNo());
			str.append("||");
			str.append(qstTempSaveVO.get(i).getAnswerNo());
			str.append("||");
			str.append(qstTempSaveVO.get(i).getAnswerContent());
			str.append(";;");
		}
		str.append("</DATA>");
		return str.toString();
	}
	
	/**
	 * 전자설문 설문생성 시간변환 실행 함수
	 */
	public String isoUTFDate(String dateTimeStr) throws Exception{
        String timeSetStr = "";
        String resultStr = "";

        if (!dateTimeStr.trim().equals("")){
            if (dateTimeStr.indexOf(" ") != -1){
                if ((dateTimeStr.split(" ")[1].equals("오후") || dateTimeStr.split(" ")[1].equals(egovMessageSource.getMessage("ezBoard.t213"))) && Integer.parseInt(dateTimeStr.split(" ")[2].split(":")[0]) < 12){
                    timeSetStr = (dateTimeStr.split(" ")[2].split(":")[0]) + 12;
                    timeSetStr += ":" + dateTimeStr.split(" ")[2].split(":")[1] + ":" + dateTimeStr.split(" ")[2].split(":")[2];
                }
                else if (dateTimeStr.split(" ")[1].equals("오전") || dateTimeStr.split(" ")[1].equals(egovMessageSource.getMessage("ezBoard.t212"))){
                    if (dateTimeStr.split(" ")[2].split(":")[0].trim().length() <= 1){
                        timeSetStr = "0" + dateTimeStr.split(" ")[2].split(":")[0] + ":" + dateTimeStr.split(" ")[2].split(":")[1] + ":" + dateTimeStr.split(" ")[2].split(":")[2];
                    }
                    else if (Integer.parseInt(dateTimeStr.split(" ")[2].split(":")[0]) == 12){
                        timeSetStr = "00" + ":" + dateTimeStr.split(" ")[2].split(":")[1] + ":" + dateTimeStr.split(" ")[2].split(":")[2];
                    }
                    else{
                        timeSetStr = dateTimeStr.split(" ")[2];
                    }
                }
                else{
                    timeSetStr = dateTimeStr.split(" ")[2];
                }
                resultStr = dateTimeStr.split(" ")[0] + "T" + timeSetStr + ".000Z";
            }
            else{
                resultStr = dateTimeStr + "T00:00:00.000Z";
            }
        }
        else{
            resultStr = "";
        }
        return resultStr;
    }
	
	/**
	 * 전자설문 설문리스트 권한없을 시 에러화면 호출 함수
	 */
	@RequestMapping(value="/ezQuestion/qstMsgAdminConfirm.do")
	public String qstMsgAdminConfirm(HttpServletRequest request,ModelMap model) throws Exception{
		String receve = "brdID=" + request.getParameter("brdID") +
		                "&title=" + commonUtil.cleanValue(request.getParameter("title")) +
		                "&responseRange=" + request.getParameter("responseRange") +
		                "&postDate=" + request.getParameter("postDate") +
		                "&pollEndDate=" + request.getParameter("pollEndDate") +
		                "&currPage=" + request.getParameter("currPage")+
		                "&itemNo=" + request.getParameter("itemNo");
		
		model.addAttribute("brdID",request.getParameter("brdID"));
		model.addAttribute("title",commonUtil.cleanValue(request.getParameter("title")));
		model.addAttribute("responseRange",request.getParameter("responseRange"));
		model.addAttribute("postDate",request.getParameter("postDate"));
		model.addAttribute("pollEndDate",request.getParameter("pollEndDate"));
		model.addAttribute("currPage",request.getParameter("currPage"));
		model.addAttribute("itemNo",request.getParameter("itemNo"));		
		model.addAttribute("receve", receve);
		return "/ezQuestion/qstMsgAdminConfirm";
	}
	
	/**
	 * 전자설문 설문리스트 설문내용 HTML Code 생성 실행 함수
	 */
	public void dataSubProcess(int brdID, int itemNo, int qstNo, int answerType, String multiSelect, Node row, Document doc) throws Exception{
		Node snewRow = doc.createElement("ITEM");
        int iCount = 0;
        String strTagData = "";
        	
        List<QstAnswerVO> qstAnswerList = ezQuestionService.getAnswerCnt(brdID, itemNo, qstNo);

        if(qstAnswerList != null){
        	for(QstAnswerVO qstAnswer : qstAnswerList){
                Node itemNode = null;
        		Node iValueNode = null;
        		iCount++;
        		
        		itemNode = doc.createElement("TAG" + Integer.toString(iCount));

        		switch(answerType){
        		case 1:
        			if (multiSelect.equals("1")){
                        strTagData = "<input type=\"checkbox\" name=\"chk" + qstNo + "_" + Integer.toString(iCount) + "\" value=\"0\">" + commonUtil.cleanValue(qstAnswer.getAnswerContent());
                        strTagData += getAttachList(Integer.toString(qstNo), Integer.toString(qstAnswer.getAnswerNo()), qstAnswer.getBrdID(), qstAnswer.getItemNo());
                        iValueNode = doc.createTextNode(strTagData);
                    }else{
                    	 strTagData = "<input type=\"Radio\" name=\"rdo" + qstNo + "\" value=\"" + Integer.toString(iCount) + "\">" + commonUtil.cleanValue(qstAnswer.getAnswerContent());
                    	 strTagData += getAttachList(Integer.toString(qstNo), Integer.toString(qstAnswer.getAnswerNo()), qstAnswer.getBrdID(), qstAnswer.getItemNo());
                         iValueNode = doc.createTextNode(strTagData);
                    }
        			
        			itemNode.appendChild(iValueNode);
        			snewRow.appendChild(itemNode);
        			iValueNode = null;
        			itemNode = null;
        			break;
        			
        		case 3:
        			int rCount = 0;
					String ansContent = commonUtil.cleanValue(qstAnswer.getAnswerContent());
					
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
        			strTagData = "<input type=\"checkbox\" onclick=\"seqResponse(" + Integer.toString(iCount - 1) + ",frmResponse.chk" + qstNo + ", frmResponse.txt" + qstNo + ")\" name=\"chk" + qstNo + "\" value=\"" + qstAnswer.getAnswerNo() + "\">" + commonUtil.cleanValue(qstAnswer.getAnswerContent());
                    strTagData += getAttachList(Integer.toString(qstNo), Integer.toString(qstAnswer.getAnswerNo()), qstAnswer.getBrdID(), qstAnswer.getItemNo());
                    iValueNode = doc.createTextNode(strTagData);
                    strTagData = "";
                    itemNode.appendChild(iValueNode);
                    snewRow.appendChild(itemNode);
                    iValueNode = null;
                    itemNode = null;
                    break;
                    
        		case 5:
        			List<QstAnswerVO> qstAnswerAnswerList = ezQuestionService.getAnswerAnswerCnt(brdID, itemNo, qstNo);
        			
        			if(iCount == 1){
        				strTagData = "<tr>";
        				strTagData += "<th style=\"background-color:#f3f3f3; border:1px solid #b6b6b6; text-align:center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;\"></th>";
        				
	    				for(QstAnswerVO qstAnswerVO : qstAnswerAnswerList){
	    	    				strTagData += "<th style=\"background-color:#f3f3f3; border:1px solid #b6b6b6; text-align:center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;\">";
	    	    				strTagData += commonUtil.cleanValue(qstAnswerVO.getAnswerContent());
	    	    				strTagData += "</th>";
						}
	    				
	    				strTagData += "</tr>";
	    				strTagData += "<tr>";
	    				strTagData += "<th style=\"background-color:#f3f3f3; border:1px solid #b6b6b6; text-align:center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;\">"+commonUtil.cleanValue(qstAnswer.getAnswerContent())+"</th>";
	    				
	    				for(QstAnswerVO qstAnswerVO : qstAnswerAnswerList){
	    					strTagData += "<td style=\"border:1px solid #b6b6b6; text-align:center;\"><input type=\"radio\" name=\"radio"+qstAnswer.getAnswerNo() +"\" value=\""+ qstAnswerVO.getAnswerNo()+"\"></td>";
						}
	    				
	    				strTagData += "</tr>";
        			}else{
        				strTagData = "<tr>";
        				strTagData += "<th style=\"background-color:#f3f3f3; border:1px solid #b6b6b6; text-align:center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;\">"+commonUtil.cleanValue(qstAnswer.getAnswerContent())+"</th>";
        				
	    				for(QstAnswerVO qstAnswerVO : qstAnswerAnswerList){
	    					strTagData += "<td style=\"border:1px solid #b6b6b6; text-align:center;\"><input type=\"radio\" name=\"radio"+qstAnswer.getAnswerNo() +"\" value=\""+ qstAnswerVO.getAnswerNo()+"\"></td>";
						}
	    				
	    				strTagData += "</tr>";
        			}
        			
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
	
	/**
	 * 전자설문 설문리스트 첨부파일 목록 HTML Code 생성 실행 함수
	 */
	@SuppressWarnings("unused")
	public String getAttachList(String strQuestionNo, String strAnswer,int brdID, int itemNo) throws Exception{
		StringBuilder strResult = new StringBuilder();
        String strAttachName = "";
        String strAttachUrl = "";
        String strAttachNo = "";
        boolean bFirst = true;
        
        QstAttachVO qstAttachVO = new QstAttachVO();
        qstAttachVO.setBrdID(brdID);
        qstAttachVO.setItemNo(itemNo);
        qstAttachVO.setQuestionNo(Integer.parseInt(strQuestionNo));
        qstAttachVO.setAnswerNo(Integer.parseInt(strAnswer));
        List<QstAttachVO> qstAttachVOList = ezQuestionService.getAttachInfo(qstAttachVO);

        if(qstAttachVOList!=null){
	        for(QstAttachVO attachVO : qstAttachVOList){
	        	if (bFirst){
	        		if (strAnswer.equals("0")){
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
	            	strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open(1," + brdID + "," + itemNo + "," + strQuestionNo + "," + strAnswer + "," + strAttachNo + ")\"><img style=\"cursor:pointer\" src=\"/ezQuestion/getPollAttachInfo.do?type=QUESTION&boardID=" + brdID + "&itemID=" + itemNo + "&qstNo=" + strQuestionNo + "&ansNo=" + strAnswer + "&attID=" + strAttachNo + "\" width=\"47\" height=\"31\" align=\"absmiddle\"></td>");
	            	break;
	            	
	            case "2":
	            	strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open(2," + brdID + "," + itemNo + "," + strQuestionNo + "," + strAnswer + "," + strAttachNo + ")\"><img src=\"/images/poll/sound.gif\" width=\"19\" height=\"17\" align=\"absmiddle\">" + strAttachName + "</td>");
	            	break;
	            	
	            case "3":
	            	break;
	            	
	            case "4":
	            	break;
	            	
	            case "5":
	            	strResult.append("<td nowrap style=\"padding:5px;cursor:hand\" onclick=\"javascript:file_open(3," + brdID + "," + itemNo + "," + strQuestionNo + "," + strAnswer + "," + strAttachNo + ")\"><img src=\"/images/poll/video.gif\" width=\"21\" height=\"17\" align=\"absmiddle\">" + strAttachName + "</td>");
	            	break;
	            	
	            default:
	            	strResult.append("<td nowrap style=\"padding:5px\"><img src=\"/images/poll/link.gif\" width=\"26\" height=\"17\" align=\"absmiddle\"><a href=\"/ezQuestion/getPollAttachInfo.do?type=QUESTION&boardID=" + brdID + "&itemID=" + itemNo + "&qstNo=" + strQuestionNo + "&ansNo=" + strAnswer + "&attID=" + strAttachNo + "\" target=\"_blink\">" + strAttachName + "</a></td>");
	            	break;
	            	
	            }
	        }
        }
        
        if(!bFirst){
        	strResult.append("<td style=\"padding:5px\">&nbsp;</td></tr></table>");
        }
        
        return strResult.toString();
	}

	/**
	 * 전자설문 설문리스트 설문조사 하나의 질문에 대한 등록 실행 함수, 설문리스트 메인 화면 호출 함수
	 */
	public void subDataProcess(int questionNo, String quesContent, String multiSelect, int answerType, int brdID, int itemNo,HttpServletRequest request, QstResponseVO qstResponseVO, HttpServletResponse response) throws Exception {
		String tmp = "", receve ="";
        int ansRCnt = 0;
        String responseNo = "1", answerSubjectivity = "";
        
		if(request.getParameter("receve")!=null){
			receve  = request.getParameter("receve").replace("&amp;", "&");
		}
		
        Integer responseMaxNo = ezQuestionService.getResponseMaxNo(brdID, itemNo, questionNo);
        
        if(responseMaxNo!=null){
        	responseNo = responseMaxNo.toString();
        }else{
        	responseNo = "1";
        }
        
        qstResponseVO.setQuestionNo(questionNo);
		qstResponseVO.setResponseNo(Integer.parseInt(responseNo));
		
        if(answerType == 1){
        	/** EZSP_GETANSCNT*/
	        Integer ansCnt = ezQuestionService.getAnsCnt(brdID, itemNo, questionNo);
	        
	        if(ansCnt != null){
	        	ansRCnt = ansCnt;
	        }else{
	        	ansRCnt = 0;
	        }
			/** EZSP_INSERTRESPONSE*/
			if(multiSelect.equals("1")){
				int iNum = 0;
				
				for(int j=0; j<ansRCnt; j++){
					iNum ++;
					tmp = "chk" + questionNo + "_" + Integer.toString(iNum);

					if(request.getParameter(tmp)!=null && request.getParameter(tmp).equals("1")){
						qstResponseVO.setAnswerObjectivity(iNum);
						ezQuestionService.insertResponse(qstResponseVO);
						responseNo = Integer.toString(Integer.parseInt(responseNo)+1);
						qstResponseVO.setResponseNo(Integer.parseInt(responseNo));
					}
				}
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
        	tmp = "tableAnswer";
	        Integer ansCnt = ezQuestionService.getAnsCnt(brdID, itemNo, questionNo);

	        if(ansCnt != null){
	        	ansRCnt = ansCnt;
	        }else{
	        	ansRCnt = 0;
	        }
	        
	        String tempTableAnswer = request.getParameter(tmp);

	        /*for(; tempTableAnswerCnt < ansRCnt; tempTableAnswerCnt++){
	        	tempTableAnswer += tempTableAnswer.split(";")[tempTableAnswerCnt] + ";";
	        }*/
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
	
	/**
	 * 전자설문 설문리스트 설문에 대한 응답 정보 호출 실행 함수
	 */
	public List<QstVO> dataProcessMainData(String brdID, String itemNo) throws Exception{
		/** EZSP_GETQUESTIONFORRESPONSE*/
		QstVO qstVO = new QstVO();
		qstVO.setBrdID(Integer.parseInt(brdID));
		qstVO.setItemNo(Integer.parseInt(itemNo));

		List<QstVO> qstVOList = ezQuestionService.getQuestionForResponse(qstVO);
		return qstVOList;
	}
	
	/**
	 * 전자설문 설문리스트 설문 타입별 HTML코드 생성 실행 함수
	 */
	public List<QstVO> dataProcess(int brdID, int itemNo, boolean bPublic,List<QstVO> qstVOList, int percent, Locale locale) throws Exception{
		int iCount=0;
		String strData = "";
		
		for(QstVO qstVO : qstVOList){
			iCount++;
			int questionNo = qstVO.getQuestionNo();
			String quesContent = qstVO.getQuesContent();
			String multiSelect = qstVO.getMultiSelect();
			int answerType = qstVO.getAnswerType();
			strData = "";
			
			if(answerType == 2){
				strData = dataProcessType2(brdID, itemNo, questionNo, quesContent, multiSelect, answerType, iCount, locale);
			}else{
				List<QstAnswerVO> qstAnswerVOList = dataProcessAns(brdID, itemNo, questionNo);
				
				if(answerType == 1){
					strData = dataProcessType1(brdID, itemNo, questionNo, quesContent, multiSelect, answerType, iCount, percent, multiSelect, qstAnswerVOList, locale);
				}else if(answerType == 3){
					strData = dataProcessType3(brdID, itemNo, questionNo, quesContent, multiSelect, answerType, iCount, percent, bPublic, qstAnswerVOList, locale);
				}else if(answerType == 4){
					strData = dataProcessType4(brdID, itemNo, questionNo, quesContent, multiSelect, answerType, iCount, percent, qstAnswerVOList, locale);
				}else if(answerType == 5){
					strData = dataProcessType5(brdID, itemNo, questionNo, quesContent, multiSelect, answerType, iCount, percent, qstAnswerVOList, locale);
				}
			}
			
			qstVO.setStrData(strData);
		}
		return qstVOList;
	}
	
	/**
	 * 전자설문 설문리스트 설문 답변 정보 호출 실행 함수
	 */
	public List<QstAnswerVO> dataProcessAns(int brdID, int itemNo, int questionNo) throws Exception{
		/** EZSP_GETANSWERCNT*/
		List<QstAnswerVO> qstAnswerVOList = ezQuestionService.getAnswerCnt(brdID, itemNo, questionNo);
		return qstAnswerVOList;
	}
	
	/**
	 * 전자설문 설문리스트 응답에 참여한 사람 수 호출 실행 함수
	 */
	public int getAnswerPerson(Document xmlDoc, int iAnsCount, int TrOrder) throws Exception{
		int rtv = 0;
		
		for (int i = 0; i < xmlDoc.getElementsByTagName("ANSWER_SUBJECTIVITY").getLength(); i++){
			if (xmlDoc.getElementsByTagName("ANSWER_SUBJECTIVITY").item(i).getTextContent().split(";")[iAnsCount].equals(Integer.toString(TrOrder + 1))){
                rtv++;
            }
        }
        return rtv;
	}
	
	/**
	 * 전자설문 설문리스트 설문 타입1 HTML코드 생성 실행 함수
	 */
	public int defaultResponseCount(int brdID, int itemNo, int questionNo) throws Exception{
		return ezQuestionService.getResPersonCnt(brdID, itemNo, questionNo);
	}
	
	/**
	 * 전자설문 설문리스트 설문 응답 카운트 호출 실행 함수
	 */
	public int responseCount(int questionNo, int answerType, int iAnsCnt, int brdID, int itemNo) throws Exception{
		int iResult = 0;
		
		if(answerType == 3){
			iResult = ezQuestionService.pollRespCnt2(brdID, itemNo, questionNo, iAnsCnt);
			/** EZSP_POLLRESPCNT2*/
		}else{
			/** EZSP_POLLRESPCNT*/
			iResult = ezQuestionService.pollRespCnt(brdID, itemNo, questionNo, iAnsCnt);
		}
		
		return iResult;	
	}
	
	/**
	 * 전자설문 설문리스트 설문 타입1 HTML코드 생성 실행 함수
	 */
	@SuppressWarnings("unused")
	public String dataProcessType1(int brdID, int itemNo, int questionNo, String strContent, String strSel, int answerType, int iDataCount, int percent, String multiSelect, List<QstAnswerVO> qstAnswerVOList, Locale locale) throws Exception{
		int iAnsCount = 0, responseCnt = 0;
        int rCnt = 0;
        float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
        String strData = "";
        responseCnt = defaultResponseCount(brdID, itemNo, questionNo);

        strData += "<table class=\"question\">";
        strData += "<tr>";
        strData += "<th>" + egovMessageSource.getMessage("ezQuestion.t333", locale) + iDataCount + " : " + commonUtil.cleanValue(strContent) + "";
        
        if (multiSelect.equals("1")){
            strData += "<span class=\"subtxt\">[" + egovMessageSource.getMessage("ezQuestion.t55", locale) + "</span>";
        }
        
        strData += getAttachList(Integer.toString(questionNo), "0", brdID, itemNo);
        strData += "</th>";
        strData += "</tr>";
        strData += "</table>";
        strData += "<table class=\"ex\">";
       
        for(QstAnswerVO qstAnswerVO : qstAnswerVOList){
        	iAnsCount ++;
        	rCnt = responseCount(questionNo, answerType, iAnsCount, brdID, itemNo);
        	fRCnt = rCnt;
        	fResponseCnt = responseCnt;

			if(responseCnt <= 0){
				percent=0;
			}else{
				fPercent = fRCnt / responseCnt;
				percent = Math.round(fPercent*100);
			}
			
        	strData += "<tr>";
        	strData += "<td>" + commonUtil.cleanValue(qstAnswerVO.getAnswerContent());
            strData += getAttachList(Integer.toString(questionNo), Integer.toString(qstAnswerVO.getAnswerNo()), brdID, itemNo) + "</td>";
            strData += "<td width=\"80\" valign=\"top\" align=\"right\" nowrap>";
            strData += "" + rCnt + " ";
            strData += " " + egovMessageSource.getMessage("ezQuestion.t399", locale) + " ";
            strData += "</th>";
            strData += "<td width=\"70\" valign=\"top\" align=\"right\" nowrap>[" + Integer.toString(percent) + "%]</td>";
            strData += "<td width=\"150\" valign=\"top\">";
            
            if (percent > 0){
                strData += "<img src=\"/images/img_graph.gif\" width=\"" + percent + "\" height=\"16\" align=\"absmiddle\">";
            }
            
            strData += "</td>";
            strData += "</tr>";
        }
        
        strData += "</table>";
        strData += "<br>";

		return strData;
	}

	/**
	 * 전자설문 설문리스트 설문 타입2 HTML코드 생성 실행 함수
	 */
	public String dataProcessType2(int brdID, int itemNo, int questionNo, String strContent, String strSel, int answerType, int iDataCount, Locale locale) throws Exception{
		String strData = "";
		strData += "<table class=\"question\"><tr>";
		strData += "<th>" + egovMessageSource.getMessage("ezQuestion.t333", locale) + iDataCount + " : " + commonUtil.cleanValue(strContent) + "</th>";
		strData += "<th style=\"width:150px;text-align:right;padding:0 10px\">";
		strData += "<a class=\"imgbtn\" style=\"cursor:pointer\"><span onclick=\"fun_ResponseView(" + questionNo + ");\">" + egovMessageSource.getMessage("ezQuestion.t396", locale) + "</span></A>";
		strData += "</th></tr><tr><td colspan=2 style=\"padding:0\">";
		strData += getAttachList(Integer.toString(questionNo), "0", brdID, itemNo) + "</td>";
		strData += "</tr>";
		strData += "</table>";
		strData += "<br>";

		return strData;
	}
	
	/**
	 * 전자설문 설문리스트 설문 타입3 HTML코드 생성 실행 함수
	 */
	@SuppressWarnings("unused")
	public String dataProcessType3(int brdID, int itemNo, int questionNo, String strContent, String strSel, int answerType, int iDataCount, int percent, boolean bPublic, List<QstAnswerVO> qstAnswerVOList, Locale locale) throws Exception{
		String strData = "";
		int rCnt = 0, jCnt =0, responseCnt =0;;
		float fRCnt =0, fResponseCnt = 0, fPercent =0;
		responseCnt = defaultResponseCount(brdID, itemNo, questionNo);

		strData += "<table class=\"question\">";
        strData += "<tr>";
        strData += "<th colspan=4>" + egovMessageSource.getMessage("ezQuestion.t333", locale) + iDataCount + " : " + commonUtil.cleanValue(strContent) + "";
        
        if (strSel.equals("1")){
            strData += "<span class=\"subtxt\">[" + egovMessageSource.getMessage("ezQuestion.t55", locale) + "</span>";
        }

        strData += getAttachList(Integer.toString(questionNo), "0", brdID, itemNo);
        strData += "</th>";
        strData += "</tr>";
        
        String anscontent =commonUtil.cleanValue(qstAnswerVOList.get(0).getAnswerContent());
        String[] ArrayContent = anscontent.split("-");

        for (int i = Integer.parseInt(ArrayContent[0]); i < Integer.parseInt(ArrayContent[1]); i++){
        	jCnt++;
            rCnt = responseCount(questionNo, answerType, i, brdID, itemNo);
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
            
            if (bPublic){
                strData += "<a href=\"#\" onclick=\"User_info(\"" + questionNo + "','" + i + "\",\"3\");\"";
                strData += "" + rCnt + "";
                strData += "" + egovMessageSource.getMessage("ezQuestion.t53", locale) + "</a> " + egovMessageSource.getMessage("ezQuestion.t306", locale);
            }else{
                strData += "" + rCnt + "";
                strData += "" + egovMessageSource.getMessage("ezQuestion.t399", locale);
            }
            
            strData += "</td>";
            strData += "<td width=\"70\" align=\"right\">[" + percent + "%]</td>";
            strData += "<td width=\"150\">";
            
            if (percent > 0){
                strData += "<img src=\"/images/img_graph.gif\" width=\"" + percent + "\" height=\"16\" align=\"absmiddle\">";
            }
            
            strData += "</td>";
            strData += "</tr>";
        }
        
        strData += "</table>";
        strData += "<br>";
        
		return strData;
	}
	
	/**
	 * 전자설문 설문리스트 설문 타입4 HTML코드 생성 실행 함수
	 */
	@SuppressWarnings("unused")
	public String dataProcessType4(int brdID, int itemNo, int questionNo, String strContent, String strSel, int answerType, int iDataCount, int percent, List<QstAnswerVO> qstAnswerVOList, Locale locale) throws Exception{
		String strData = "";
		int iAnsCount = 0, responseCnt = 0;
        int rCnt = 0;
        float fRCnt = 0, fResponseCnt = 0, fPercent = 0;
        responseCnt = defaultResponseCount(brdID, itemNo, questionNo);
        
        strData += "<table class=\"question\">";
        strData += "<tr>\n";
        strData += "<th>" + egovMessageSource.getMessage("ezQuestion.t333", locale) + iDataCount + " : " + commonUtil.cleanValue(strContent) + "";
        strData += "<span class=\"subtxt\">[" + egovMessageSource.getMessage("ezQuestion.t400", locale) + "</span>";
        strData += "</th>\n";
        strData += "<th style=\"text-align:right;width:150px;padding:0 10px\">";
        strData += "<A class=\"imgbtn\" onclick=\"fun_ResponseView('" + questionNo + "');\" style=\"cursor:pointer\"><span>" + egovMessageSource.getMessage("ezQuestion.t396", locale) + "</span></A>";
        strData += "</th></tr></table>\n";

        strData += getAttachList(Integer.toString(questionNo), "0", brdID, itemNo);
        strData += "<table class=\"ex\">";
        
        for(QstAnswerVO qstAnswerVO : qstAnswerVOList){
        	iAnsCount++;
            rCnt = responseCount(questionNo, answerType, iAnsCount, brdID, itemNo);
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
            strData += "" + commonUtil.cleanValue(qstAnswerVO.getAnswerContent()) + "";
            strData += getAttachList(Integer.toString(questionNo), Integer.toString(qstAnswerVO.getAnswerNo()), brdID, itemNo) + "</td>";
            strData += "</tr>";
        }
        
        strData += "</table>";
        strData += "<br>";
        
		return strData; 
	}

	
	/**
	 * 전자설문 설문리스트 설문 타입5 HTML코드 생성 실행 함수
	 */
	public String dataProcessType5(int brdID, int itemNo, int questionNo, String strContent, String strSel, int answerType, int iDataCount, int percent, List<QstAnswerVO> qstAnswerVOList, Locale locale) throws Exception{
		String strData = "";

		/** EZSP_GETTABLEANSWER*/
		String strXmlDom = ezQuestionService.getTableAnswer(brdID, itemNo, questionNo);	
		Document xmlDom = commonUtil.convertStringToDocument(strXmlDom);
		String strXmlDoc = ezQuestionService.getResponseAnswer(brdID, itemNo, questionNo);		
		Document xmlDoc = commonUtil.convertStringToDocument(strXmlDoc);
		
		int iAnsCount = 0, responseCnt = 0;
        int rCnt = 0;
        percent = 0;
        responseCnt = xmlDoc.getElementsByTagName("ANSWER_SUBJECTIVITY").getLength();

        strData += "<table class=\"question\">";
        strData += "<tr>";
        strData += "<th>" + egovMessageSource.getMessage("ezQuestion.t333", locale) + iDataCount + " : " + commonUtil.cleanValue(strContent) + "";
        
        if (strSel.equals("1")){
            strData += "<span class=\"subtxt\">[" + egovMessageSource.getMessage("ezQuestion.t55", locale) + "</span>";
        }
        
        strData += getAttachList(Integer.toString(questionNo), "0", brdID, itemNo);
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
                		strData += "<td colspan='3' style='border:1px solid #b6b6b6;'>" + commonUtil.cleanValue(xmlDom.getElementsByTagName("ANSWER_ANSWERCONTENT").item(i - 1).getTextContent()) + "</td>";
                	}
                }
                
                strData += "</tr>\n";
        	}
        	
        	strData += "<tr style=\"text-align:center;\">";
            strData += "<td style=\"border:1px solid #b6b6b6;\">" + commonUtil.cleanValue(qstAnswerVO.getAnswerContent());
            strData += getAttachList(Integer.toString(questionNo), Integer.toString(qstAnswerVO.getAnswerNo()), brdID, itemNo) + "</td>";
            
            for (int i = 0; i < xmlDom.getElementsByTagName("ANSWER_ANSWERCONTENT").getLength(); i++){
                rCnt = getAnswerPerson(xmlDoc, iAnsCount - 1, i);
                
                if (responseCnt != 0){
                    percent = (rCnt * 100) / responseCnt;
                }
                
                strData += "<td width=\"80' valign=\"top\" align=\"right\" nowrap style=\"border:1px solid #b6b6b6; border-right:0px;\">";
                strData += "" + rCnt + "";
                strData += "" + egovMessageSource.getMessage("ezQuestion.t399", locale) + "";
                strData += "</th>";
                strData += "<td width=\"70\" valign=\"top\" align=\"right\" nowrap style=\"border:1px solid #b6b6b6; border-right:0px; border-left:0px;\">[" + percent + "%]</td>";
                strData += "<td width=\"150\" valign=\"top\" style=\"border:1px solid #b6b6b6; padding-right:10px; border-left:0px;\">";
                
                if (percent > 0){
                    strData += "<img src=\"/images/img_graph.gif\" width=\"" + percent + "%\" height=\"16\" align=\"absmiddle\">";
                }
                
                strData += "</td>";
            }
            
            strData += "</tr>";
        }
        
        strData += "</table>";
        strData += "<br>";

		return strData;
    }
	
}
