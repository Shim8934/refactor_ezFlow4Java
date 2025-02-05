package egovframework.ezEKP.ezPoll.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.w3c.dom.Document;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardPollConfigVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollCommentVO;
import egovframework.ezEKP.ezPoll.vo.PollFilePathVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionStatusVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezPoll.vo.PollUserAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPollController extends EgovFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzPollController.class);	
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzPollService")
	private EzPollService ezPollService;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzNotificationService ezNotificationService;
	
	@Autowired
	private SimpMessagingTemplate template;
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	@RequestMapping(value="/ezPoll/pollCreate.do", method = RequestMethod.GET)
	public String questionCreate(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpSession session) throws Exception {
		logger.debug("question create is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String mode = "";
		int qstId = -1;
		String content = "";
		String listOfTarget = "";
		String [] filePath = null;
		ObjectMapper om = new ObjectMapper();
		List<PollAnswerVO> listOptions = null;
		StringBuilder listOfTargetBld = new StringBuilder();
		StringBuilder strXML = new StringBuilder();
		StringBuilder strXMLRange = new StringBuilder();
		strXMLRange.append("<RANGE>"); 
		String params = (request.getParameter("params") != null) ? request.getParameter("params") : "";
		String searchStr = (request.getParameter("search") != null) ? request.getParameter("search") : "";
		String searchN = (request.getParameter("searchN") != null) ? request.getParameter("searchN") : "";
		String startTime = "";
		String endTime = "";
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("qstId") != null) {
			qstId = Integer.parseInt(request.getParameter("qstId"));
		} 
		
		if (!mode.equals("") && qstId != -1) {
			String qstParams = Integer.toString(qstId);
			session.setAttribute("modifying_question", qstParams);
			//Get question
			try {
				PollQuestionVO pollQuestionVO = ezPollService.getQuestionByIdAndTenantId(qstId, loginVO.getTenantId());
				
				/* 2020-02-07 홍승비 - 투표 수정 시 기존 첨부파일 구분자를 변경 (; -> \\|) */
				if (pollQuestionVO.getFilePath() != null && !pollQuestionVO.getFilePath().equals("")) {
					filePath = pollQuestionVO.getFilePath().split("\\|");
				}
				
				content = pollQuestionVO.getContent();
				
		        //Process attached files
		        if (filePath != null) {
		        	strXML.append("<ROOT><NODES>");
		        	
			        for (int i = 0; i < filePath.length; i++) {			        	
						strXML.append("<DATA><![CDATA[" + filePath[i] + "]]></DATA>");
						strXML.append("<DATA2><![CDATA[]]></DATA2>");
						strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
			        }
			        
			        strXML.append("</NODES></ROOT>");			       
		        }
		        
		        //Process target
		        List<String> departIdList = ezPollService.getListOfUserIdForQst(qstId, loginVO.getTenantId(), "dept");
		        List<PollUserVO> userList = ezPollService.getListOfUserForQst(qstId, loginVO.getTenantId(), "user");			        
		        
		        if (departIdList.size() > 0) {
		        	strXMLRange.append("<DEPT>"); 
		        	
			        for (String deptID : departIdList) {
			        	OrganDeptVO organDeptVO = ezOrganService.getDeptInfo(deptID, loginVO.getPrimary(), loginVO.getTenantId());			        	
			        	strXMLRange.append("<DATA id=\"" + commonUtil.cleanValue(organDeptVO.getCn()) + "\" nm=\"" + commonUtil.cleanValue(organDeptVO.getDisplayName()) + 
			        			"\" nm2=\"" + commonUtil.cleanValue(organDeptVO.getDisplayName2()) + "\">" + commonUtil.cleanValue(organDeptVO.getCn()) + "</DATA>");
			        	
			        	if (loginVO.getPrimary().equals("1")) {
			        		listOfTargetBld.append(organDeptVO.getDisplayName1() + ",");
			        	}
			        	else {
			        		listOfTargetBld.append(organDeptVO.getDisplayName2() + ",");
			        	}
			        }
			        
			        strXMLRange.append("</DEPT>"); 
		        }
		        
		        if (userList.size() > 0) {
		        	strXMLRange.append("<MEMBER>"); 
		        	
		        	for (PollUserVO user : userList) {
		        		LoginVO userVo = loginService.selectReceiver(user.getUserId(), loginVO.getTenantId());
		        		strXMLRange.append("<DATA id=\"" + commonUtil.cleanValue(userVo.getId()) + "\" nm=\"" + commonUtil.cleanValue(userVo.getDisplayName1()) + 
			        			"\" nm2=\"" + commonUtil.cleanValue(userVo.getDeptName1()) + "\" deptid=\"" + commonUtil.cleanValue(user.getDeptId()) + "\">"
		        				+ commonUtil.cleanValue(userVo.getId()) + "</DATA>");
		        		
			        	if (loginVO.getPrimary().equals("1")) {
			        		listOfTargetBld.append(userVo.getDisplayName1() + ",");
			        	}
			        	else {
			        		listOfTargetBld.append(userVo.getDisplayName2() + ",");
			        	}
		        	}
		        	
		        	strXMLRange.append("</MEMBER>");
		        }
		        
		        listOfTarget = listOfTargetBld.toString();
		        
		        if (listOfTarget.endsWith(",")) {
		        	listOfTarget = listOfTarget.substring(0, listOfTarget.length() - 1);
		        }
		        
				model.addAttribute("question", pollQuestionVO);
			}
			catch (Exception e) {
				logger.error(e.getMessage(), e);
			}		
		
			//Get list of options		
			listOptions = ezPollService.getListOptionsOfQst(qstId, loginVO.getTenantId());		
			
			model.addAttribute("hasConfig", 0);
		}
		else {
			BoardPollConfigVO boardPollConfigVO = ezBoardService.getPollConfig(loginVO.getId(), loginVO.getTenantId());
			
			if (boardPollConfigVO == null) {
				model.addAttribute("hasConfig", 0);
			}
			else {
				model.addAttribute("hasConfig", 1);
				
				//Process time
				startTime = boardPollConfigVO.getDefaultStartTime();
				endTime = boardPollConfigVO.getDefaultEndTime();
				
				//Process target
		        String[] departIdList = null;
		        String targetDepts = boardPollConfigVO.getTargetDepts();
		        if(targetDepts != null){
		        	departIdList = targetDepts.split(",");
		        }
		        
		        String[] userIdList = null;
		        String targetUsers = boardPollConfigVO.getTargetUsers();
		        if(targetUsers != null){
		        	userIdList = targetUsers.split(",");
		        }
		        
		        if (targetDepts != null && !departIdList[0].equals("")) {
		        	strXMLRange.append("<DEPT>"); 
		        	
			        for (String deptID : departIdList) {
			        	OrganDeptVO organDeptVO = ezOrganService.getDeptInfo(deptID, loginVO.getPrimary(), loginVO.getTenantId());			        	
			        	strXMLRange.append("<DATA id=\"" + commonUtil.cleanValue(organDeptVO.getCn()) + "\" nm=\"" + commonUtil.cleanValue(organDeptVO.getDisplayName()) + 
			        			"\" nm2=\"" + commonUtil.cleanValue(organDeptVO.getDisplayName2()) + "\">" + commonUtil.cleanValue(organDeptVO.getCn()) + "</DATA>");
			        	
			        	if (loginVO.getPrimary().equals("1")) {
			        		listOfTargetBld.append(organDeptVO.getDisplayName1() + ",");
			        	}
			        	else {
			        		listOfTargetBld.append(organDeptVO.getDisplayName2() + ",");
			        	}
			        	
			        }
			        
			        strXMLRange.append("</DEPT>"); 
		        }
		        
		        if (targetUsers != null && !userIdList[0].equals("")) {
		        	strXMLRange.append("<MEMBER>"); 
		        	
		        	for (String userID : userIdList) {
		        		//개인 대상 특정할 경우 겸직 처리하기 위해 수정. 2018-11-27 홍대표.
		        		String deptID = "";
		        		String tmpUserID = userID;
		        		if(userID.indexOf("|") != -1) {
		        			userID = tmpUserID.split("\\|")[0];
		        			deptID = tmpUserID.split("\\|")[1];
		        		}
		        		LoginVO user = loginService.selectReceiver(userID, loginVO.getTenantId());
		        		strXMLRange.append("<DATA id=\"" + commonUtil.cleanValue(user.getId()) + "\" nm=\"" + commonUtil.cleanValue(user.getDisplayName1())
			        			+ "\" nm2=\"" + commonUtil.cleanValue(user.getDeptName1()) + "\" deptid=\"" + commonUtil.cleanValue(deptID) + "\">"
		        				+ commonUtil.cleanValue(user.getId()) + "</DATA>");
		        		
			        	if (loginVO.getPrimary().equals("1")) {
			        		listOfTargetBld.append(user.getDisplayName1() + ",");
			        	}
			        	else {
			        		listOfTargetBld.append(user.getDisplayName2() + ",");
			        	}
		        	}
		        	
		        	strXMLRange.append("</MEMBER>");
		        }
		        
		        listOfTarget = listOfTargetBld.toString();
		        
		        if (listOfTarget.endsWith(",")) {
		        	listOfTarget = listOfTarget.substring(0, listOfTarget.length() - 1);
		        }
			}
			
		}
		
		strXMLRange.append("</RANGE>");
		
		model.addAttribute("optList", om.writeValueAsString(listOptions));
		model.addAttribute("mode", mode);
		model.addAttribute("content", content);
		model.addAttribute("filePath", strXML.toString());
		model.addAttribute("targetPath", strXMLRange.toString());
		model.addAttribute("params", params);
		model.addAttribute("searchStr", searchStr);
		model.addAttribute("searchN", searchN);	
		model.addAttribute("listOfTarget", listOfTarget);
		model.addAttribute("configStartTime", startTime);
		model.addAttribute("configEndTime", endTime);
		model.addAttribute("tenantId", loginVO.getTenantId());
		
		logger.debug("question create finishes!");
		return "/ezPoll/createPoll";
	}
	
	/**
	 * 투표 메인 화면 호출 함수
	 */
	@RequestMapping(value="/ezPoll/pollMain.do", method = RequestMethod.GET)
	public String qstMain(HttpServletRequest request, ModelMap model) throws Exception{
		logger.debug("pollMain Start");
		String qstId = request.getParameter("qstId");
		String leftFrameWidth = "220";
		int width = 0;
		
		if (qstId != null) {
			qstId = commonUtil.detectPathTraversal(qstId);
			qstId = commonUtil.stripScriptTags(qstId);
		}

		if (request.getParameter("__wwidth") != null) {
			String widthParam = request.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}
		
		model.addAttribute("qstId", qstId);
		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("pollMain End");
		return "/ezPoll/pollMain";
	}
	
	/**
	 * 투표 레프트 메뉴 화면 호출 함수
	 */
	@RequestMapping(value="/ezPoll/pollLeft.do", method = RequestMethod.GET)
	public String qstLeft(HttpServletRequest request, ModelMap model) throws Exception{
		logger.debug("pollLeft Start");
		String qstId = request.getParameter("qstId");
		
		if (qstId != null) {
			qstId = commonUtil.detectPathTraversal(qstId);
			qstId = commonUtil.stripScriptTags(qstId);
		}
		
		model.addAttribute("qstId", qstId);
		
		logger.debug("pollLeft End");
		return "/ezPoll/pollLeft";
	}
	
	/**
	 * 투표 환경설정 메뉴 화면 호출 함수
	 */
	@RequestMapping(value="/ezPoll/pollConfig.do", method = RequestMethod.GET)
	public String getConfig() throws Exception{
		logger.debug("pollConfig Start");
		
		logger.debug("pollConfig End");
		return "/ezPoll/pollConfig";
	}

	@RequestMapping(value="/ezPoll/pollList.do", method = RequestMethod.GET)
	public String getQuestion(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, RedirectAttributes redirectAttributes, HttpSession session) throws Exception {
		logger.debug("get question is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String userID = loginVO.getId();
		String companyID = loginVO.getCompanyID();
		int currPage = 1;
		int pageSize = 15;
		int totalPages = 0;
		String brdID = "6";
		String searchStr = "";
		String hideQstList = "";
		int seeAll = 0;	
		int checkingArray = 0;
		int adminPrivilege = -1;
		String qstId = "";
		String pollType = (request.getParameter("pollType") != null) ? request.getParameter("pollType") : "2";
		boolean creatorResultFlag = request.getParameter("resultFirst") != null && request.getParameter("status") != null;
		String gotoList = (request.getParameter("gotoList") != null ? request.getParameter("gotoList") : "0");
		String params = (request.getParameter("params") != null ? request.getParameter("params") : "");
		
		if (request.getParameter("qstId") != null) {			
			qstId = request.getParameter("qstId");
		}
		
		if (!qstId.equals("") && gotoList.equals("0")) {
			redirectAttributes.addAttribute("qstId", qstId);
			return "redirect:/ezPoll/pollVote.do";
		}
		
		//목록버튼 눌렀을 때 해당 페이지로 이동시켜주기 위함.
		if(gotoList.equals("1") && !params.equals("")){
			String[] paramsArr = params.split(",");
			currPage = Integer.parseInt(paramsArr[0]);
			pollType = paramsArr[4];
		}
		
		String mode = (request.getParameter("mode") != null) ? request.getParameter("mode") : "";
		String mode1 = (request.getParameter("mode1") != null) ? request.getParameter("mode1") : mode;
		String listQst = (request.getParameter("listQst") != null) ? request.getParameter("listQst") : "";
		
		//현재 listQst에 값을 넣어주는 메소드를 호출 하는 부분이 없어 타지 않는 조건문임 2018-06-05 홍대표
		if (!listQst.equals("")) {
			String [] questionIDs = listQst.split(",");			
			
			for (int i = 0; i < questionIDs.length; i++) {
				//Unhide each question
				ezPollService.unhideQuestion(questionIDs[i], userID, loginVO.getTenantId());								
			}
		}
		
		List<PollQuestionVO> listOfModifyingQst = new ArrayList<PollQuestionVO>();		
		
		//사용자의 권한을 체크함.
		if (loginVO.getRollInfo().indexOf("c=1") == -1 && loginVO.getRollInfo().indexOf("k=1") == -1) {
			//Normal user
			adminPrivilege = 0;
		}
		else {
			//Admin privilege user
			adminPrivilege = 1;
		}	
		
		if (request.getParameter("see") != null) {
			seeAll = Integer.parseInt(request.getParameter("see"));
		}
		
		if (request.getParameter("hide") != null) {
			hideQstList = request.getParameter("hide");
		}
		
		if (request.getParameter("search") != null) {
			searchStr = request.getParameter("search");
		}		
		
		String searchStr1 = (request.getParameter("searchN") != null) ? request.getParameter("searchN"): searchStr;
		
		if (request.getParameter("currPage") != null) {
			currPage = Integer.parseInt(request.getParameter("currPage"));
		}
		else {
			if (request.getParameter("paging") != null) {
				currPage = Integer.parseInt(request.getParameter("paging"));
			}
		}
		
		if (request.getParameter("brdID") != null) {
			brdID = request.getParameter("brdID");
		}
		
		if(creatorResultFlag){
			model.addAttribute("resultFirst", 2);
		}
		
		//Save hidden questions to database
		//현재 listQst에 값을 넣어주는 메소드를 호출 하는 부분이 없어 타지 않는 조건문임 2018-06-05 홍대표
		if (!hideQstList.equals("")) {
			saveHiddenQuestion(hideQstList, loginVO);
		}
		
		//Get list of questions for this user
		Set<PollQuestionVO> setOfQuestions = new HashSet<PollQuestionVO>();	
		ezPollService.getAllQuestionForUser(loginVO, setOfQuestions, searchStr, mode);
		List<Integer> listHiddenQuestionIds = ezPollService.getHiddenQuestionIds(userID, loginVO.getTenantId(), companyID);
		
		//Set status for each question
		checkingArray = setStatusForQuestions(setOfQuestions, listHiddenQuestionIds, loginVO, checkingArray, seeAll);
		List<PollQuestionVO> listTotalQuestions = new ArrayList<PollQuestionVO>(setOfQuestions);
		
		//Get list of modifying questions		
		String modifyingQst = ((String)session.getAttribute("modifying_question") != null) ? (String)session.getAttribute("modifying_question") : "";					
		
		for (PollQuestionVO pollQstVO : listTotalQuestions) {
			if (pollQstVO.getIsModifying() == 1) {
				if (modifyingQst.equals("")) {
					listOfModifyingQst.add(pollQstVO);
				}
				else {
					try {
						String modifyingUser = ezPollService.getModifyingUser(loginVO.getTenantId(), pollQstVO.getQstId());
						if (loginVO.getId().equals(modifyingUser)) {
							/*if (modifyingQst == pollQstVO.getQstId() && modifyingSession.equals(session.getId())) {*/
							if(Integer.parseInt(modifyingQst) == pollQstVO.getQstId()) {
								PollQuestionStatusVO pollQstStatusVO = new PollQuestionStatusVO();
								pollQstStatusVO.setUserId(loginVO.getId());
								pollQstStatusVO.setTenantId(loginVO.getTenantId());
								pollQstStatusVO.setQustId(pollQstVO.getQstId());
								
								ezPollService.updateModifyingQuestion(pollQstVO.getQstId(), loginVO.getTenantId(), 0);
								ezPollService.updateModifyingQuestionRelatedStatus(pollQstStatusVO);
								
								session.removeAttribute("modifying_question");								
							}
							else {
								listOfModifyingQst.add(pollQstVO);
							}
						}
						else {
							listOfModifyingQst.add(pollQstVO);
						}
					}
					catch (Exception e) {
						logger.error(e.getMessage(), e);
					}	
				}										
			}
		}
		
		//Remove all modifying questions
		listTotalQuestions.removeAll(listOfModifyingQst);
		
		//Process question list based on pollType
		if (!pollType.equals("1")) {
			Iterator<PollQuestionVO> iterator = listTotalQuestions.iterator();
			
			if (pollType.equals("2")) {
				while (iterator.hasNext()) {
					PollQuestionVO question = iterator.next();
					
					if (question.getStatus() != 1) { //20180109
						iterator.remove();	
					}
				}
			}
			//대기 상황일 경우도 필터하도록 처리 pollType => 0,1:전체, 2:진행, 3완료, 4:대기
			else if(pollType.equals("4")) {
				while (iterator.hasNext()){
					PollQuestionVO question = iterator.next();
					
					if(question.getStatus() != 2){
						iterator.remove();	
					}	
				}
			}
			else {
				while (iterator.hasNext()) {
					PollQuestionVO question = iterator.next();
					
					if (question.getStatus() != 0) {
						iterator.remove();
					}
				}
			}			
		}		
		
		//Sort list of questions by question id				
		Collections.sort(listTotalQuestions, (PollQuestionVO qst1, PollQuestionVO qst2) -> {
	        return Integer.valueOf(qst2.getQstId()).compareTo(qst1.getQstId());
		});		
		
		int totalQuestions = listTotalQuestions.size();
		totalPages = (totalQuestions + pageSize - 1)/pageSize;
		
		if (totalPages == 0 || totalPages == 1) {
			model.addAttribute("list", listTotalQuestions);
		}
		else {
			if (currPage < totalPages) {				
				int startPoint = Math.multiplyExact(Math.subtractExact(currPage, 1), pageSize);
				int endPoint = Math.multiplyExact(currPage, pageSize);
				List<PollQuestionVO> listRenderQuestions = listTotalQuestions.subList(startPoint, endPoint);	
				model.addAttribute("list", listRenderQuestions);
			}
			else {
				if (currPage > totalPages) {
					currPage = totalPages;
				}
				int startPoint = Math.multiplyExact(Math.subtractExact(currPage, 1), pageSize);
				int endPoint = totalQuestions;
				List<PollQuestionVO> listRenderQuestions = listTotalQuestions.subList(startPoint, endPoint);
				model.addAttribute("list", listRenderQuestions);
			}			
		}
				
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currPage", currPage);
		model.addAttribute("totalQuestions", totalQuestions);
		model.addAttribute("brdID", brdID);
		model.addAttribute("userID", loginVO.getId());
		model.addAttribute("tenantID", loginVO.getTenantId());
		model.addAttribute("strSearch", searchStr);		
		model.addAttribute("strSearch1", searchStr1);	
		model.addAttribute("mode", mode);
		model.addAttribute("mode1", mode1);
		model.addAttribute("seeCheck", seeAll);
		model.addAttribute("deleteBttn", checkingArray);		
		model.addAttribute("adminPrivilege", adminPrivilege);
		model.addAttribute("primary", loginVO.getPrimary());
		model.addAttribute("pollType", pollType);
		model.addAttribute("gotoList", gotoList);
		
		
		logger.debug("get question finishes!");
		return "/ezPoll/questionList";
	}

	@RequestMapping(value="/ezPoll/pollComplete.do", method = RequestMethod.POST)
	public String qstComplete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, PollAnswerVO pollAnswerVO, PollQuestionVO pollQuestionVO, ModelMap model, HttpServletResponse response) throws Exception {		
		logger.debug("Question complete is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantID = loginVO.getTenantId();
		String userID = loginVO.getId();
		String companyID = loginVO.getCompanyID();
		String numberOfOptions = req.getParameter("numberOfOptions");
		// String qstTitle = commonUtil.cleanValue(req.getParameter("qst_title"));
		String qstTitle = req.getParameter("qst_title");
		String qstContent = commonUtil.stripScriptTags(req.getParameter("hidContent"));
		String filePath = req.getParameter("hidFilePath");
		int secretVote = Integer.parseInt(req.getParameter("hidSecreteVote"));
		String endDate = req.getParameter("hidEndDate");
		String startDate = req.getParameter("hidStartDate");
		String createDate = req.getParameter("hidCreateDate"); // 20180109
		int numberOfMultiSelect = Integer.parseInt(req.getParameter("multiSelectNumber"));
		String range = req.getParameter("RangeXMLStr");
		int resultFirst = Integer.parseInt(req.getParameter("hidResultFirst"));
		String qstModifyInfo = req.getParameter("hidModifyInfo");
		int setDate = Integer.parseInt(req.getParameter("hidSetDate"));
		int isSorting = Integer.parseInt(req.getParameter("hidIsSorting"));
		int isSelOnlyOnce = Integer.parseInt(req.getParameter("hidIsSelOnlyOnce"));
		String OptImgFilePath = req.getParameter("hidOptImgFilePath");
		int sendPostNotice = Integer.parseInt(req.getParameter("hidSendPostNotice"));
		int openToAll = Integer.parseInt(req.getParameter("hidOpenToAll"));
		String[] OptRowArr = OptImgFilePath.split("\\|");
		String orgContent = "";

		Map<String, String> filePathMap = new HashMap<String, String>();
		if (!OptRowArr[0].equals("")) {
			for (int i = 0; i < OptRowArr.length; i++) {
				String mapVal = OptRowArr[i].split("\\//")[0];
				String mapKey = OptRowArr[i].split("\\//")[1];
				filePathMap.put(mapKey, mapVal);
			}
		}

		// Get list of options for this question
		List<String> listOptions = new ArrayList<String>();

		for (int i = 1; i <= Integer.parseInt(numberOfOptions); i++) {
			String optName = "option" + Integer.toString(i);
			String option = req.getParameter(optName);

/*			 if (option != null && !option.equals("")) { listOptions.add(option); } */

			if (option != null && option.equals(filePathMap.get(optName))) {
				listOptions.add("");
			} else if (option != null && !option.equals("")) {
				listOptions.add(option);
			} else {
				listOptions.add(null);
			}
		}

		// Set PollQuestionVO fields
		pollQuestionVO.setTitle(qstTitle);

		if (qstContent != null && !qstContent.equals("")) {
			pollQuestionVO.setContent(qstContent);
		}

		if (filePath != null && !filePath.equals("")) {
			pollQuestionVO.setFilePath(filePath);
		}

		pollQuestionVO.setTenantId(tenantID);

		if (range == null || range.equals("") || range.equals("<RANGE></RANGE>")) {
			pollQuestionVO.setTarget(0);
		} else {
			pollQuestionVO.setTarget(1);
		}

		// Set PollQuestionVO fields
		pollQuestionVO.setCreator(userID);
		pollQuestionVO.setCreatorName1(loginVO.getDisplayName1());
		pollQuestionVO.setCreatorName2(loginVO.getDisplayName2());
		pollQuestionVO.setCreatorDept(loginVO.getDeptID());
		pollQuestionVO.setCreateDate(createDate); // 20180109
		pollQuestionVO.setEndDate(endDate);
		pollQuestionVO.setStartDate(startDate);
		pollQuestionVO.setSecretVote(secretVote);
		pollQuestionVO.setResultFirst(resultFirst);
		pollQuestionVO.setMultiSelect(numberOfMultiSelect);
		pollQuestionVO.setSetDate(setDate);
		pollQuestionVO.setIsSorting(isSorting);
		pollQuestionVO.setIsSelOnlyOnce(isSelOnlyOnce);
		pollQuestionVO.setSendPostNotice(sendPostNotice);
		pollQuestionVO.setOpenToAll(openToAll);
		pollQuestionVO.setCompanyId(companyID);

		if (!qstModifyInfo.equals("")) {
			pollQuestionVO.setQstId(Integer.parseInt(qstModifyInfo));
			// 수정할 경우 다 지우고 다시 넣기 때문에 미리 본 내용을 담아둔다.
			orgContent = ezPollService.getContent(pollQuestionVO.getQstId(), tenantID);
			// Delete all information related to this question
			try {
				ezPollService.deleteQuestions(pollQuestionVO.getQstId(), loginVO.getTenantId());
				ezPollService.deleteUserAndAnswer(pollQuestionVO.getQstId(), loginVO.getTenantId());
				ezPollService.deleteQuestionRelated(pollQuestionVO.getQstId(), loginVO.getTenantId());
				ezPollService.deleteAnswers(pollQuestionVO.getQstId(), loginVO.getTenantId());
				ezPollService.deleteUserAndQuestion(pollQuestionVO.getQstId(), loginVO.getTenantId());
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		} else {
			int currentMaxQstID = 0;
			currentMaxQstID = getQuestionSeq(tenantID);
			pollQuestionVO.setQstId(currentMaxQstID);
		}

		// DB에 들어갈 content의 img path를 upload_vote 아래로 바꿔준다
		PollFilePathVO pollFilePathVO = changeImgPathInContent(req, pollQuestionVO.getQstId(), qstContent, tenantID, "uploadFile");
		pollQuestionVO.setContent(pollFilePathVO.getContent());

		// Insert question in database
		saveQuestion(pollQuestionVO, range, loginVO);
		// 2023-08-18 장혜연 - 본 내용이 있을 경우 수정된 내용의 이미지 파일을 비교하여 삭제한다.
		if (!"".equals(orgContent) && orgContent != null) {
			deleteContentImages(req, orgContent, qstContent);
		}
		// 2023-08-18 장혜연 - 본 댓글에 첨부파일이 있을 경우 삭제한다.
		copyUploadImages(req, pollFilePathVO.getCopyFilePathList(), pollFilePathVO.getTargetDirFullPath());
		// Insert answers/options in database
		pollAnswerVO.setQstId(pollQuestionVO.getQstId());
		pollAnswerVO.setTenantId(tenantID);
		pollAnswerVO.setVotesNumber(0);

		for (int i = 0; i < listOptions.size(); i++) {
			if (listOptions.get(i) != null) {
				pollAnswerVO.setContent(listOptions.get(i));
				pollAnswerVO.setAnsId(i + 1);
				if (filePathMap.containsKey("option" + (i + 1))) {
					pollAnswerVO.setFilePath(filePathMap.get("option" + (i + 1)));
				} else {
					pollAnswerVO.setFilePath(null);
				}
				ezPollService.insertOption(pollAnswerVO);
			}
		}
		
		Set<LoginVO> setOfUserIds = new HashSet<LoginVO>();
		ezPollService.getAllUserForQuestion(loginVO, pollQuestionVO.getQstId(), setOfUserIds);
		
		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
		
		for (LoginVO user : setOfUserIds) {
			Map<String, Object> recipientMap = new HashMap<String, Object>();
			recipientMap.put("userType", "PERSON");
			recipientMap.put("companyId", loginVO.getCompanyID());
			recipientMap.put("cn", user.getId());
			notiRecipientList.add(recipientMap);
		}
		
		if (notiRecipientList != null && notiRecipientList.size() > 0) {
			String linkUrl = "/ezPoll/pollVote.do?brdId=6&qstId=" + pollAnswerVO.getQstId();
			String linkUrlMobile = "";
			ezNotificationService.sendNoti(req, loginVO.getId(), loginVO.getDisplayName(), notiRecipientList, "POLL", "NEW", pollQuestionVO.getTitle(), "popup", "900", "750", linkUrl, linkUrlMobile, "");
		}
		
    	// Send posting notification mail
    	// 메일 발송 체크되어 있고, 투표 등록이나 재사용일 경우 => true
    	
		if (sendPostNotice == 1 && qstModifyInfo.equals("")) {
			ezPollService.sendPostNotiMail(loginVO, loginCookie, pollQuestionVO);
		}

		logger.debug("Question complete finishes!");
		return "redirect:/ezPoll/pollList.do";
	}

	@RequestMapping(value="/ezPoll/pollVote.do", method = RequestMethod.GET)
	public String qstVote(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, PollQuestionVO pollQuestionVO, HttpSession session, RedirectAttributes redirectAttributes, ModelMap model) throws Exception {
		logger.debug("question vote is running!");			
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantId = loginVO.getTenantId();
		String companyID =	loginVO.getCompanyID();
		String deptID =	loginVO.getDeptID();
		int qstId =	Integer.parseInt(request.getParameter("qstId"));
		String brdId = request.getParameter("brdId") != null ? request.getParameter("brdId") : "";
		int totalVotes = 0;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		int compareEnd = 0;
		int compareStart = 0;
		int numberOfVotedUsers = 0;
		int totalSeenUsers = 0;
		String timeRemain = "";
		int numOfFile = 0;
		ObjectMapper om = new ObjectMapper();
		int adminPrivilege = -1;
		int numberOfCmt = -1;
		String[] files = null;
		String userPhoto = "";
		String params = (request.getParameter("params") != null) ? request.getParameter("params") : ""; // currentPage, checkSeeAll, radioBttn, mode1, pollType
		String searchStr = (request.getParameter("search") != null) ? request.getParameter("search") : "";
		String searchN = (request.getParameter("searchN") != null) ? request.getParameter("searchN") : "";
		int resultFirst = 0; //0:투표 종료 후 결과보기, 1:투표 종료 전 결과보기, 2:작성자만 결과보기.
		
		if (loginVO.getRollInfo().indexOf("c=1") == -1 && loginVO.getRollInfo().indexOf("k=1") == -1) {
			//Normal user
			adminPrivilege = 0;
		}
		else {
			//Admin privilege user
			adminPrivilege = 1;
		}		
		
		//Get question
		pollQuestionVO = ezPollService.getQuestionByIdAndTenantId(qstId, tenantId);
		
		if (pollQuestionVO == null) {
			model.addAttribute("messageContent", egovMessageSource.getMessage("ezMain.delete.hth01", loginVO.getLocale()));
			return "/common/error";
		}
		
		if (pollQuestionVO.getIsModifying() == 1) {
			String modifyingUser = ezPollService.getModifyingUser(tenantId, qstId);
			if (loginVO.getId().equals(modifyingUser)) {
				return "redirect:/ezPoll/pollCreate.do?qstId=" + qstId + "&mode=modify" + "&params=" + params + "&search=" + searchStr + "&searchN=" + searchN;
			} else {
				return "redirect:/ezPoll/pollList.do";
			}
		}

		if (pollQuestionVO == null) {		
			redirectAttributes.addAttribute("brdID", 6);
			return "redirect:/ezPoll/pollList.do";
		}	
		
		Date endDate = formatter.parse(pollQuestionVO.getEndDate());
		Date startDate = formatter.parse(pollQuestionVO.getStartDate()); //20180109
		Date nowTime = new Date();
		compareEnd = endDate.compareTo(nowTime);
		compareStart = startDate.compareTo(nowTime); //20180109
		
		if (compareEnd > 0) {
			if (compareStart > 0) {
				pollQuestionVO.setStatus(2); // reserve poll
			}
			else {
				pollQuestionVO.setStatus(1); // processing poll
				DateTime endDate_ = new DateTime(endDate);
				DateTime toDay_   = new DateTime(nowTime);
				int diffInDays  = Days.daysBetween(toDay_, endDate_).getDays();		
				
				if (diffInDays != 0) {
					timeRemain = Integer.toString(diffInDays) + egovMessageSource.getMessage("ezPoll.t118", loginVO.getLocale());				
				}
				else {
					int diffInHours  = endDate_.getHourOfDay() - toDay_.getHourOfDay();
					
					if (diffInHours != 0) {
						timeRemain = Integer.toString(diffInHours) + egovMessageSource.getMessage("ezPoll.t119", loginVO.getLocale());
					}
					else {
						int diffInMinutes = endDate_.getMinuteOfHour() - toDay_.getMinuteOfHour();
						
						if (diffInMinutes != 0) {
							timeRemain = Integer.toString(diffInMinutes) + egovMessageSource.getMessage("ezPoll.t120", loginVO.getLocale());
						}
						else {
							int diffInSeconds = endDate_.getSecondOfMinute() - toDay_.getSecondOfMinute();						
							timeRemain = Integer.toString(diffInSeconds) + egovMessageSource.getMessage("ezPoll.t121", loginVO.getLocale());
						}										
					}	
				}
			}	
		}
		else {
			pollQuestionVO.setStatus(0);
		}
		
		//게시자만 결과 보기 판별 2018-04-16 홍대표
		resultFirst = pollQuestionVO.getResultFirst();
		if(resultFirst == 2 && !pollQuestionVO.getCreator().equals(loginVO.getId()) && pollQuestionVO.getStatus() == 0){
			String pollType = params.split(",")[4];
			redirectAttributes.addAttribute("brdID", 6);
			redirectAttributes.addAttribute("resultFirst", resultFirst);
			redirectAttributes.addAttribute("status", pollQuestionVO.getStatus());
			redirectAttributes.addAttribute("pollType", pollType);
			return "redirect:/ezPoll/pollList.do";
		}
		
		//Set creator Image
		String creatorImagePath = ezOrganService.getPropertyValue(pollQuestionVO.getCreator(), "extensionAttribute2", pollQuestionVO.getTenantId());
		
		if (creatorImagePath != null && !creatorImagePath.equals("")) {
			String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", pollQuestionVO.getTenantId())+ commonUtil.separator + creatorImagePath;
			String fullPath = request.getServletContext().getRealPath(realPath);
			
			if (checkExist(fullPath)) {
				pollQuestionVO.setCreatorImage("/ezCommon/downloadAttach.do?filePath=" + realPath);
			}
			else {
				pollQuestionVO.setCreatorImage("/images/poll/default_pic_vote.gif");
			}
		} 
		else {
			pollQuestionVO.setCreatorImage("/images/poll/default_pic_vote.gif");
		}
		
		//해당 투표 대상자 전체 인원을 얻어옴. 2018-06-04 홍대표
		List<LoginVO> listofTotalUsers = ezPollService.getAllUsersInfoForQstM(tenantId, qstId, companyID);
		
		//Check if user has the vote privilege
		if (listofTotalUsers.contains(loginVO)) {
			model.addAttribute("hasVotePrivilege", 1);
		}
		else {
			model.addAttribute("hasVotePrivilege", 0);
		}
		
		//Get all seen users
		List<LoginVO> listOfCurrentSeenUsers = ezPollService.getInfoOfSeenUsers(tenantId, qstId, companyID);
		totalSeenUsers = listOfCurrentSeenUsers.size();
		
		//해당 투표 대상자 중 사용자가 포함되어 있는 기존 열람 유저 리스트에 없으면 추가해준다.
		if (listofTotalUsers.contains(loginVO)) {
			if (!listOfCurrentSeenUsers.contains(loginVO)) {
				//Update seen users number 
				PollQuestionStatusVO pollQstStatusVO = new PollQuestionStatusVO();
				pollQstStatusVO.setUserId(loginVO.getId());
				pollQstStatusVO.setTenantId(loginVO.getTenantId());
				pollQstStatusVO.setQustId(qstId);	
				pollQstStatusVO.setDeptId(deptID);
				ezPollService.insertSeenQuestion(pollQstStatusVO, companyID);
				totalSeenUsers = totalSeenUsers + 1;
				getUpdateSeenRequests(totalSeenUsers, qstId, loginVO.getTenantId());
			}
		}
		
		//Get user and his/her answers
		List<Integer> listSelectedOptionsOfUser = new ArrayList<Integer>();
		List<PollUserAnswerVO> listOfPollUserAndAnswer = ezPollService.getPollUserAndAnswer(qstId, tenantId);
		totalVotes = listOfPollUserAndAnswer.size();
		
		//퇴사자가 있을 경우 정확한 미참여자 수를 구하기 위해 추가.
		List<LoginVO> listOfUnvotedUsers = listofTotalUsers;
		
		Iterator<LoginVO> iterator = listOfUnvotedUsers.iterator();
		
		while (iterator.hasNext()) {
			LoginVO user = iterator.next();
			
			for(int i = 0; i < listOfPollUserAndAnswer.size(); i++){
				if (listOfPollUserAndAnswer.get(i).getUserId().equals(user.getId())) {
					iterator.remove();
					break; //다중 투표 시 이미 제거한 상태에서 또 제거하게 되면 에러가 발생하게 되어 추가.
				}
			}
		}
		
		//Get list of voted users
		List<String> listOfAnsweredUsers = new ArrayList<String>();
		for (PollUserAnswerVO pollUserAndAnswer : listOfPollUserAndAnswer) {
			if (!listOfAnsweredUsers.contains(pollUserAndAnswer.getUserId())) {
				listOfAnsweredUsers.add(pollUserAndAnswer.getUserId());
			}
			
			if (pollUserAndAnswer.getUserId().equals(loginVO.getId())) {
				listSelectedOptionsOfUser.add(pollUserAndAnswer.getAnsId());
			}
		}
		
		numberOfVotedUsers = listOfAnsweredUsers.size();		
		
		//Check if user has voted
		if (listSelectedOptionsOfUser.size() > 0) {
			model.addAttribute("hasVoted", 1);
		}
		else {
			model.addAttribute("hasVoted", 0);
		}
		
		if (pollQuestionVO.getFilePath() != null) {
			files = pollQuestionVO.getFilePath().split("\\|");
		}
		
		if (files != null && files.length != 0) {			
			List<String> fileNames = new ArrayList<String>();
			List<String> fileSizes = new ArrayList<String>();
			List<String> filePaths = new ArrayList<String>();
			int totalSize = 0;			
			numOfFile = files.length;
			
			for (int i = 0; i < files.length; i++) {
				String[] file_fields = files[i].split("/");
				String fileSize_ = getFileSize(Integer.parseInt(file_fields[2]));	            
				filePaths.add(file_fields[0]);
				fileNames.add(file_fields[1]);
				fileSizes.add(fileSize_);	
				totalSize += Integer.parseInt(file_fields[2]);
			}			
			
			String totalFilesSize = getFileSize(totalSize);  
			model.addAttribute("fileNames", fileNames);
			model.addAttribute("fileSizes", fileSizes);
			model.addAttribute("filePaths", filePaths);
			model.addAttribute("totalFilesSize", totalFilesSize);
		}
		
		//Get list of options/answers		
		List<PollAnswerVO> listOptions = ezPollService.getListOptionsOfQst(qstId, tenantId);	
		
		//Sort list of options/answers by number of votes
		if(pollQuestionVO.getIsSorting()==1){
			Collections.sort(listOptions, (PollAnswerVO answer1, PollAnswerVO answer2) -> {
		        return Integer.valueOf(answer2.getVotesNumber()).compareTo(answer1.getVotesNumber());
			});
		}
		
		//Get list of comments for this question
		List<PollCommentVO> listComments = ezPollService.getListCmtOfQst(qstId, tenantId);
		
		//Sort list of comments by comment id
		Collections.sort(listComments, (PollCommentVO cmt1, PollCommentVO cmt2) -> {
//	        return Integer.valueOf(cmt1.getCmtId()).compareTo(cmt2.getCmtId());
	        return Integer.valueOf(cmt2.getCmtId()).compareTo(cmt1.getCmtId());
		});
		
		//Set image for each commented user
		for (PollCommentVO commentVO: listComments) {
			String imagePath = ezOrganService.getPropertyValue(commentVO.getUserId(), "extensionAttribute2", commentVO.getTenantId());
			
			if (imagePath != null && !imagePath.equals("")) {
				String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", commentVO.getTenantId())+ commonUtil.separator + imagePath;
				String fullPath = request.getServletContext().getRealPath(realPath);
				
				if (checkExist(fullPath)) {
					commentVO.setUserImage("/ezCommon/downloadAttach.do?filePath=" + realPath);
				}
				else {
					commentVO.setUserImage("/images/poll/default_pic_vote.gif");
				}
			} 
			else {
				commentVO.setUserImage("/images/poll/default_pic_vote.gif");
			}
		}
		
		if (listComments.isEmpty()) {
			numberOfCmt = 0;
		}
		else {
//			numberOfCmt = listComments.get((listComments.size() - 1)).getCmtId();
			numberOfCmt = listComments.get(0).getCmtId();
		}		
		
		//User image
		String result = loginVO.getUserFileUrl();
		
		if (result != null && !result.equals("")) {
			String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", loginVO.getTenantId())+ commonUtil.separator + result;
			String fullPath = request.getServletContext().getRealPath(realPath);
			
			if (checkExist(fullPath)) {
				userPhoto = "/ezCommon/downloadAttach.do?filePath=" + realPath;
			}
			else {
				userPhoto = "/images/poll/default_pic_vote.gif";
			}
		} 
		else {
			userPhoto = "/images/poll/default_pic_vote.gif";
		}
		
		//Get creator department
		//2018-07-10 홍대표 - 작성자 겸직 처리하려고 수정함.
		LoginVO paramVO = new LoginVO();
		paramVO.setId(pollQuestionVO.getCreator());
		paramVO.setDeptID(pollQuestionVO.getCreatorDept());
		paramVO.setDn("NOPASSWORD");
		paramVO.setTenantId(tenantId);
		LoginVO pollCreator = loginService.selectUser(paramVO);
//		LoginVO pollCreator = loginService.selectReceiver(pollQuestionVO.getCreator(), tenantId);
		
		if(pollCreator != null){
			if (loginVO.getPrimary().equals("1")) {
				model.addAttribute("creatorDept", pollCreator.getDeptName1());
			}
			else {
				model.addAttribute("creatorDept", pollCreator.getDeptName2());
			}
			model.addAttribute("creatorDeptId", pollCreator.getDeptID());
		}
		
		if(!brdId.equals("")){
			model.addAttribute("brdId", Integer.parseInt(brdId));
		}
		
//		deptID = ezPollService.getAddJobDept(tenantId, qstId, loginVO.getId(), deptID);
		
		model.addAttribute("listComments", listComments);
		model.addAttribute("numberOfCmt", numberOfCmt);
		model.addAttribute("listSelectedOptions", om.writeValueAsString(listSelectedOptionsOfUser));
		model.addAttribute("totalVotes", totalVotes);
		model.addAttribute("listOptions", listOptions);
		model.addAttribute("numberOfOptions", listOptions.size());
		model.addAttribute("numOfFile", numOfFile);
		model.addAttribute("timeRemain", timeRemain);
		model.addAttribute("seenUsers", totalSeenUsers);
		model.addAttribute("listOfUserAnswer", om.writeValueAsString(listOfPollUserAndAnswer));
		model.addAttribute("votedUsers", numberOfVotedUsers);
		model.addAttribute("adminPrivilege", adminPrivilege);		
		model.addAttribute("numberOfUnvotedUsers", listOfUnvotedUsers.size());
		model.addAttribute("question", pollQuestionVO);
		model.addAttribute("curentUser", loginVO.getId());
		model.addAttribute("curentUserName", loginVO.getDisplayName());	
		model.addAttribute("userPhoto", userPhoto);		
		model.addAttribute("primary", loginVO.getPrimary());
		model.addAttribute("sessionID", egovFileScrty.encryptAES(session.getId()));		
		model.addAttribute("params", params);
		model.addAttribute("searchStr", searchStr);
		model.addAttribute("searchN", searchN);		
		model.addAttribute("deptId", deptID);		
		
		
		logger.debug("Question vote finishes!");		
		return "/ezPoll/questionVote";
	}	
	
	@RequestMapping(value="/ezPoll/checkPoll.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkPoll(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("check poll is running!");			
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantId = loginVO.getTenantId();
		int qstId =	Integer.parseInt(request.getParameter("qstId"));
		String data = "";
		
		//Get question
		PollQuestionVO pollQuestionVO = ezPollService.getQuestionByIdAndTenantId(qstId, tenantId);

		if (pollQuestionVO.getIsModifying() == 0) {
			data = "{\"result\":\"Normal\"}";
		}
		else {
			String modifyingUser = ezPollService.getModifyingUser(tenantId, qstId);
			if (loginVO.getId().equals(modifyingUser)) {
				data = "{\"result\":\"Normal\"}";
			} else {
				data = "{\"result\":\"Abnormal\"}";
			}
		}
		
		logger.debug("check poll finishes!");	
		return data;		
	}	

	@RequestMapping(value="/ezPoll/downloadAttach.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Download attach is running!");	
		LoginSimpleVO loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String folderPath = request.getParameter("folderPath");
		String fileName = request.getParameter("filename");
		File file = null;		
		logger.debug("FileName: " + fileName + ", folderPath: " + folderPath);
		
		if (folderPath == null || fileName == null || folderPath.equals("") || fileName.equals("")) {
			logger.debug("downloadAttach illegal arguments!");
			return;
		}
		
        //Get absolute path of the application       
        String realPath = request.getServletContext().getRealPath("");
        String pDirPath = commonUtil.getUploadPath("upload_vote.ROOT", loginSimpleVO.getTenantId());
        pDirPath = realPath + pDirPath;
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
       
        String fullPath = pDirPath + "uploadFile" + commonUtil.separator + commonUtil.detectPathTraversal(folderPath);
        file = new File(fullPath);
        
		if (file == null || !file.exists()) {
			fullPath = realPath + commonUtil.detectPathTraversal(folderPath);
			file = new File(fullPath);
			
			if (file == null || !file.exists()) {
				logger.debug("Folder not found. folderPath=" + folderPath);
				return;
			}				
		}
		
		downFile(request, response, fullPath, fileName);		

		logger.debug("Download attach finishes!");	
	}
	
	@RequestMapping(value="/ezPoll/confirmDeleteQuestion.do", method = RequestMethod.GET)
	public String confirmDeleteQuestion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap model) throws Exception {
		logger.debug("Confirm delete question is running!");				
		String listQstIds = "";
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		//String listQstContent = "";
		List<String> listQuestionIDs = new ArrayList<String>();
		List<String> listQuestionContents = new ArrayList<String>();
		
		if (request.getParameter("listQst") != null) {
			listQstIds = request.getParameter("listQst");
		}
		
		/*if (request.getParameter("listQstContent") != null) {
			listQstContent = request.getParameter("listQstContent");
		}*/
		
		String [] questionIDs = listQstIds.split(",");
		//String [] questionContents = listQstContent.split(",");		
		
		for (int i = 0; i < questionIDs.length; i++) {
			listQuestionIDs.add(questionIDs[i]);
			PollQuestionVO questionVO = ezPollService.getQuestionByIdAndTenantId(Integer.parseInt(questionIDs[i]), loginVO.getTenantId());
			listQuestionContents.add(questionVO.getTitle());
		}
		
		model.addAttribute("listQuestionIDs", listQuestionIDs);
		model.addAttribute("listQuestionContents", listQuestionContents);
		model.addAttribute("numberOfQst", listQuestionIDs.size());
		model.addAttribute("listQstIds", listQstIds);
		
		logger.debug("Confirm delete question finishes!");
		return "/ezPoll/confirmDeleteQst";
	}	

	@RequestMapping(value="/ezPoll/addComment.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addComment(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {
		logger.debug("Add comment is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String strXML = "";
		String cmtTime = "";
		String attachFilePath = "";
		String fileName = "";
		String filePath = "";
		String txtContent = "";
		String fileType = "";
		String targetDirFullPath = "";
		List<Map<String, String>> copyFilePathList = new ArrayList<>();
		int qstId = -1;
		int cmtId = -1;

		qstId = Integer.parseInt(request.getParameter("qstId"));
		cmtId = Integer.parseInt(request.getParameter("cmtId"));
		cmtTime = request.getParameter("cmtTime");

		if (request.getParameter("cmtAttach") != null) {
			attachFilePath = request.getParameter("cmtAttach");
		}

		if (request.getParameter("fileType") != null) {
			fileType = request.getParameter("fileType");
		}

		if (request.getParameter("fileName") != null) {
			fileName = request.getParameter("fileName");
		}

		if (request.getParameter("filePath") != null) {
			filePath = request.getParameter("filePath");
		}

		if (request.getParameter("cmtTxt") != null) {
			txtContent = request.getParameter("cmtTxt");
		}

		if (qstId == -1 || cmtId == -1 || cmtTime.equals("")) {
			strXML = "<DATA>FAIL</DATA>";
			return strXML;
		}

		// Set PollCommentVO fields
		PollCommentVO pollCmtVO = new PollCommentVO();
		pollCmtVO.setCmtId(cmtId);
		pollCmtVO.setQstId(qstId);
		pollCmtVO.setTenantId(loginVO.getTenantId());
		pollCmtVO.setUserId(loginVO.getId());
		pollCmtVO.setUserName1(loginVO.getDisplayName1());
		pollCmtVO.setUserName2(loginVO.getDisplayName2());
		pollCmtVO.setCmtTime(cmtTime);
		pollCmtVO.setTextContent(txtContent);
		pollCmtVO.setDeptId(loginVO.getDeptID());
		pollCmtVO.setCompanyId(loginVO.getCompanyID());

		logger.debug("attachFilePath: " + attachFilePath);

		if (fileType.equals("sticker")) {
			attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/images/"));
			pollCmtVO.setImageAttach(attachFilePath);
			pollCmtVO.setFileAttach("");
			pollCmtVO.setFileName("");
			pollCmtVO.setFilePath("");
		} else if (fileType.equals("file")) {
			pollCmtVO.setImageAttach("");
			if (fileName.equals("")) {
				attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/fileroot/"));
				//fielpath를 upload_common/ -> upload_vote/ 로 이동 
				PollFilePathVO pollFilePathVO = changeImgPathInContent(request, qstId, attachFilePath,pollCmtVO.getTenantId(), "commentImages");
				targetDirFullPath = pollFilePathVO.getTargetDirFullPath();
				copyFilePathList = pollFilePathVO.getCopyFilePathList();
				pollCmtVO.setFileAttach(pollFilePathVO.getContent());
				pollCmtVO.setFileName("");
				pollCmtVO.setFilePath("");
			} else {
				attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/images/"));
				pollCmtVO.setFileAttach(attachFilePath);
				pollCmtVO.setFileName(fileName);
				pollCmtVO.setFilePath(filePath);
			}
		} else {
			pollCmtVO.setImageAttach("");
			pollCmtVO.setFileAttach("");
			pollCmtVO.setFileName("");
			pollCmtVO.setFilePath("");
		}

		// Add userImage
		String imagePath = ezOrganService.getPropertyValue(pollCmtVO.getUserId(), "extensionAttribute2",
				pollCmtVO.getTenantId());

		if (imagePath != null && !imagePath.equals("")) {
			String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", pollCmtVO.getTenantId())
					+ commonUtil.separator + imagePath;
			String fullPath = request.getServletContext().getRealPath(realPath);

			if (checkExist(fullPath)) {
				pollCmtVO.setUserImage("/ezCommon/downloadAttach.do?filePath=" + realPath);
			} else {
				pollCmtVO.setUserImage("/images/poll/default_pic_vote.gif");
			}
		} else {
			pollCmtVO.setUserImage("/images/poll/default_pic_vote.gif");
		}

		// Process comment
		try {
			// Insert into comment table
			ezPollService.insertCmt(pollCmtVO);
			// 2023-08-18 장혜연 - 이미지일 경우 upload_vote 폴더로 복사를한다.
			if (!"".equals(targetDirFullPath)) {
				copyUploadImages(request, copyFilePathList, targetDirFullPath);
			}

			String deptId = ezPollService.getQuestionRelatedDept(loginVO.getTenantId(), qstId, loginVO.getId(),
					loginVO.getDeptID());

			// Inform all waiting users
			String result = "{\"cmId\":\"" + cmtId + "\", \"userId\":\"" + loginVO.getId() + "\", \"userName1\":\""
					+ pollCmtVO.getUserName1() + "\", \"userName2\":\"" + pollCmtVO.getUserName2()
					+ "\", \"attachFilePath\":\"" + attachFilePath + "\"" + ", \"fileType\":\"" + fileType
					+ "\", \"fileName\":\"" + fileName + "\", \"filePath\":\"" + filePath + "\", \"txtContent\":\""
					+ txtContent.replaceAll("\"", "\\\\\"") + "\"," + " \"cmtTime\":\"" + cmtTime
					+ "\", \"userPhoto\":\"" + pollCmtVO.getUserImage() + "\", \"sessionid\":\""
					+ egovFileScrty.encryptAES(session.getId()) + "\", \"deptId\":\"" + deptId + "\"}";
			JSONParser parser = new JSONParser();

			JSONObject json = (JSONObject) parser.parse(result);
			this.template.convertAndSend("/reply/addCmtForQst" + qstId + "+" + loginVO.getTenantId(), json);

			// Set return string
			strXML = "<DATA>OK</DATA>";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			strXML = "<DATA>FAIL</DATA>";
		}

		logger.debug("Add comment finishes!");
		return strXML;
	}

	@RequestMapping(value="/ezPoll/editComment.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String editComment(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {
		logger.debug("Edit comment is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String strXML = "";
		String attachFilePath = "";
		String fileName = "";
		String filePath = "";
		String txtContent = "";
		String fileType = "";
		String targetDirFullPath = "";
		int cmtId = -1;
		int qstId = -1;
		List<Map<String, String>> copyFilePathList = new ArrayList<>();
		PollCommentVO pollCommentVO = new PollCommentVO();

		qstId = Integer.parseInt(request.getParameter("qstId"));
		cmtId = Integer.parseInt(request.getParameter("cmtId"));

		if (request.getParameter("cmtAttach") != null) {
			attachFilePath = request.getParameter("cmtAttach");
		}

		if (request.getParameter("fileType") != null) {
			fileType = request.getParameter("fileType");
		}

		if (request.getParameter("fileName") != null) {
			fileName = request.getParameter("fileName");
		}

		if (request.getParameter("filePath") != null) {
			filePath = request.getParameter("filePath");
		}		

		if (request.getParameter("cmtTxt") != null) {
			txtContent = request.getParameter("cmtTxt");
		}

		logger.debug("cmtAttach: " + attachFilePath + " || fileType: " + fileType + " || fileName: " + fileName
				+ " || filePath: " + filePath + " || txtContent: " + txtContent);

		if (qstId == -1 || cmtId == -1) {
			strXML = "<DATA>FAIL</DATA>";
			return strXML;
		}

		// Set PollCommentVO fields
		PollCommentVO pollCmtVO = new PollCommentVO();
		pollCmtVO.setCmtId(cmtId);
		pollCmtVO.setQstId(qstId);
		pollCmtVO.setTenantId(loginVO.getTenantId());
		pollCmtVO.setTextContent(txtContent);

		if (fileType.equals("sticker")) {
			attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/images/"));
			pollCmtVO.setImageAttach(attachFilePath);
			pollCmtVO.setFileAttach("");
			pollCmtVO.setFileName("");
			pollCmtVO.setFilePath("");
		} else if (fileType.equals("file")) {
			pollCmtVO.setImageAttach("");

			if (fileName.equals("")) {
				attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/fileroot/"));
				pollCmtVO.setFileAttach(attachFilePath);
				pollCmtVO.setFileName("");
				pollCmtVO.setFilePath("");
			} else {
				attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/images/"));
				pollCmtVO.setFileAttach(attachFilePath);
				pollCmtVO.setFileName(fileName);
				pollCmtVO.setFilePath(filePath);
			}
		}
		else if (fileType.equals("images")) {
			attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/fileroot/"));
			// fielpath를 upload_common/ -> upload_vote/ 로 이동
			PollFilePathVO pollFilePathVO = changeImgPathInContent(request, qstId, attachFilePath, pollCmtVO.getTenantId(), "commentImages");
			targetDirFullPath = pollFilePathVO.getTargetDirFullPath();
			copyFilePathList = pollFilePathVO.getCopyFilePathList();
			pollCmtVO.setFileAttach(pollFilePathVO.getContent());
			pollCmtVO.setImageAttach("");
			pollCmtVO.setFileName("");
			pollCmtVO.setFilePath("");
		} else {
			pollCmtVO.setImageAttach("");
			pollCmtVO.setFileAttach("");
			pollCmtVO.setFileName("");
			pollCmtVO.setFilePath("");
		}
		// 2023-08-18 장혜연 - 본 댓글의 첨부파일 경로를 가져온다.
		pollCommentVO = ezPollService.getCmtFileType(cmtId, qstId, pollCmtVO.getTenantId());
		pollCommentVO.setModFilePath(filePath);
		// Process comment
		try {
			// Update in comment table
			ezPollService.updateCmt(pollCmtVO);
			// 2023-08-18 장혜연 - 본 댓글에 첨부파일이 있을 경우 삭제한다.
			deleteCmtImage(request, pollCommentVO);
			// 2023-08-18 장혜연 - 이미지일 경우 upload_vote 폴더로 복사를한다.
			if (!"".equals(targetDirFullPath)) {
				copyUploadImages(request, copyFilePathList, targetDirFullPath);
			}

			// Inform all waiting users
			String result = "{\"cmId\":\"" + cmtId + "\", \"userId\":\"" + loginVO.getId() + "\", \"attachFilePath\":\""
					+ attachFilePath + "\"" + ", \"fileType\":\"" + fileType + "\", \"fileName\":\"" + fileName
					+ "\", \"filePath\":\"" + filePath + "\", \"txtContent\":\"" + txtContent.replaceAll("\"", "\\\\\"")
					+ "\", \"sessionid\":\"" + egovFileScrty.encryptAES(session.getId()) + "\"}";
			JSONParser parser = new JSONParser();
			JSONObject json = (JSONObject) parser.parse(result);
			this.template.convertAndSend("/reply/editCmtForQst" + qstId + "+" + loginVO.getTenantId(), json);

			// Set return string
			strXML = "<DATA>OK</DATA>";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			strXML = "<DATA>FAIL</DATA>";
		}

		logger.debug("Edit comment finishes!");
		return strXML;
	}
	
	@RequestMapping(value="/ezPoll/deleteComment.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteComment(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {
		logger.debug("Delete comment is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String strXML = "";
		int cmtId = -1;
		int qstId = -1;

		qstId = Integer.parseInt(request.getParameter("qstId"));
		cmtId = Integer.parseInt(request.getParameter("cmtId"));

		if (qstId == -1 || cmtId == -1) {
			strXML = "<DATA>FAIL</DATA>";
			return strXML;
		}
		// 댓글 삭제 하기 전에 삭제해줄 file path를 가져온다
		PollCommentVO pollCmtVO = ezPollService.getCmtFileType(cmtId, qstId, loginVO.getTenantId());

		//Process comment
		try {
			//Delete entry in comment table
			ezPollService.deleteSpecificCmt(cmtId, qstId, loginVO.getTenantId());

			//지워줄 파일이 있을경우 삭제를 실행한다
			deleteCmtImage(request, pollCmtVO);

			//Inform all waiting users
			String result = "{\"cmId\":\"" + cmtId  + "\", \"userId\":\"" + loginVO.getId() + "\", \"sessionid\":\"" + egovFileScrty.encryptAES(session.getId()) + "\"}";
			JSONParser parser = new JSONParser();
			JSONObject json = (JSONObject) parser.parse(result);
			this.template.convertAndSend("/reply/deleteCmtInQst" + qstId + "+" + loginVO.getTenantId(), json);

			//Set return string
			strXML = "<DATA>OK</DATA>";
		}
		catch (Exception e) {			
			logger.error(e.getMessage(), e);
			strXML = "<DATA>FAIL</DATA>";
		}

		logger.debug("Delete comment finishes!");
		return strXML;
	}

	@RequestMapping(value="/ezPoll/undoModifyVote.do", method = RequestMethod.POST)
	@ResponseBody
	public void undoModifyVote(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Undo modify vote is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		//String strXML = "";
		int qstId = -1;
		
		if (request.getParameter("questionId") != null) {
			qstId = Integer.parseInt(request.getParameter("questionId"));
		}
		/*
		if (qstId == -1) {
			strXML = "<DATA>FAIL</DATA>";
			return strXML;			
		}
		*/
		//Update current vote modifying status
		try {
			//Set PollQuestionStatusVO fields
			PollQuestionStatusVO pollQstStatusVO = new PollQuestionStatusVO();
			pollQstStatusVO.setUserId(loginVO.getId());
			pollQstStatusVO.setTenantId(loginVO.getTenantId());
			pollQstStatusVO.setQustId(qstId);
			
			ezPollService.updateModifyingQuestion(qstId, loginVO.getTenantId(), 0);
			ezPollService.updateModifyingQuestionRelatedStatus(pollQstStatusVO);
			
/*			//Get all related users for this question
			Set<LoginVO> setOfUserIds = new HashSet<LoginVO>();
			getAllUserForQuestion(loginVO, qstId, setOfUserIds);
			List<LoginVO> listofTotalUsers = new ArrayList<LoginVO>(setOfUserIds);
			
			//Set PollQuestionStatusVO fields
			PollQuestionStatusVO pollQstStatusVO = new PollQuestionStatusVO();
			pollQstStatusVO.setUserId(loginVO.getId());
			pollQstStatusVO.setTenantId(loginVO.getTenantId());
			pollQstStatusVO.setQustId(qstId);
			
			if (listofTotalUsers.contains(loginVO)) {
				ezPollService.updateModifyingQuestionRelatedStatus(pollQstStatusVO);
			}
			else {
				ezPollService.deleteModifyingQuestionRelatedStatus(pollQstStatusVO);
			}*/
			
			//strXML = "<DATA>OK</DATA>";
		} 
		catch (Exception e) {
			//strXML = "<DATA>FAIL</DATA>";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("Undo modify vote finishes!");
		//return strXML;
	}
	
	@RequestMapping(value="/ezPoll/deleteQuestion.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteQuestion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap model, HttpServletResponse response) throws Exception {
		logger.debug("Delete question is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);					
		String listQstIds = "";
		String strXML = "";
		String realPath = request.getServletContext().getRealPath("");
		String pDirPath = commonUtil.getUploadPath("upload_vote.ROOT", loginVO.getTenantId());
		pDirPath = realPath + pDirPath;
		
		if (request.getParameter("listQst") != null) {
			listQstIds = request.getParameter("listQst");
		}		
		
		strXML = questionDelete(listQstIds, loginVO, pDirPath, realPath);		

		logger.debug("Delete question finishes!");		
		return strXML;		
	}
	
	@RequestMapping(value = "/ezPoll/uploadCmtFile.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadCmtFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletResponse response) throws Exception {
		logger.debug("upload comment file is running!");
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload");		
		String realPath = request.getServletContext().getRealPath("");
		String pFileName = "";
        Long fileSize = 0L;             
        String sGUID = "";
        String pUploadSN = "";      

        sGUID = UUID.randomUUID().toString();
        pUploadSN = sGUID;
       
        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {        	      
            String _pFileName = multiFile.get(0).getOriginalFilename();
            
            if (_pFileName.indexOf(commonUtil.separator) > 0) {
                _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
            }
            
            pFileName = _pFileName;           
        }       
        
/*        pFileName = pFileName.replace("+", "%2b");
        pFileName = pFileName.replace(";", "%3b"); */      
        
        String extension = pFileName.substring(pFileName.lastIndexOf(".") + 1);
        
        if (extension.toLowerCase().equals("jpg") || extension.toLowerCase().equals("png") || extension.toLowerCase().equals("bmp")) {
    		String pDirPath = commonUtil.getUploadPath("upload_common.ROOT", loginSimpleVO.getTenantId());
    		pDirPath = realPath + pDirPath;
    		
            if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
            	pDirPath = pDirPath + commonUtil.separator;
            }
    		
            File file = new File(pDirPath + "commentImages");
            
            if (!file.exists()) {
            	file.mkdirs();        
            }
            
            String newFileName = pUploadSN + "." + extension;  
            fileSize = multiFile.get(0).getSize();
            StringBuffer strXML = new StringBuffer();
            strXML.append("<ROOT><NODES>");
            writeUploadedFile(multiFile.get(0), newFileName, pDirPath + "commentImages");
			strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName + "/" + fileSize + "]]></DATA>");
			strXML.append("<DATA2><![CDATA[]]></DATA2>");
			strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
			strXML.append("</NODES></ROOT>");
			
			logger.debug("upload comment file finishes!");
			return strXML.toString();
        }        	
        else {
        	logger.debug("upload comment file finishes!");
        	return "ERROR";
        }
	}
	
	@RequestMapping(value = "/ezPoll/uploadFile.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletResponse response) throws Exception {		
		logger.debug("Upload file is running!");		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload"); 
		int cnt = multiFile.size();
		
		String realPath = request.getServletContext().getRealPath("");
		String[] pFileName = new String[cnt];
        Long[] fileSize = new Long[cnt];
        String[] sGUID = new String[cnt];
        String[] pUploadSN = new String[cnt];
        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", loginSimpleVO.getTenantId());

        for (int i = 0; i < cnt; i++) {
            sGUID[i] = UUID.randomUUID().toString();
            pUploadSN[i] = "{" + sGUID[i] + "}";
        }

        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {        	
            for (int i = 0; i < cnt; i++) {
                String _pFileName = multiFile.get(i).getOriginalFilename();
                
                if (_pFileName.indexOf(commonUtil.separator) > 0) {
                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
                }
                
                pFileName[i] = _pFileName;
            }
        }

/*        for (int i = 0; i < cnt; i++) {
            pFileName[i] = pFileName[i].replace("+", "%2b");
            pFileName[i] = pFileName[i].replace(";", "%3b");
        }    */       
        
        String pDirPath = commonUtil.getUploadPath("upload_vote.ROOT", loginSimpleVO.getTenantId());
        pDirPath = realPath + pDirPath;
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        
        File file = new File(pDirPath + "uploadFile");

        if (!file.exists()) {
        	file.mkdirs();        
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {        	
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            String newFileName = pUploadSN[i] + "." + extend;
            
			// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
            if ((extend.isEmpty() || useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1) && !useExtension.equals("*")) {           	
				strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[]]></DATA2>");
				strXML.append("<DATA3><![CDATA[denied]]></DATA3>");
            } 
            else {
				writeUploadedFile(multiFile.get(i), newFileName, pDirPath + "uploadFile");
				strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[]]></DATA2>");
				strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
            }
        }
        strXML.append("</NODES></ROOT>");
       
        logger.debug("Upload file finishes!");
        return strXML.toString();
    }
	
	@RequestMapping(value = "/ezPoll/uploadOptFile.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadOptFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletResponse response) throws Exception {
		logger.debug("upload comment file is running!");
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFile = request.getFiles("fileToUpload");
		String realPath = request.getServletContext().getRealPath("");
		String pFileName = "";
        Long fileSize = 0L;
        String sGUID = "";
        String pUploadSN = "";

        sGUID = UUID.randomUUID().toString();
        pUploadSN = sGUID;
       
        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {        	      
            String _pFileName = multiFile.get(0).getOriginalFilename();
            
            if (_pFileName.indexOf(commonUtil.separator) > 0) {
                _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
            }
            
            pFileName = _pFileName;           
        }       
        
/*        pFileName = pFileName.replace("+", "%2b");
        pFileName = pFileName.replace(";", "%3b"); */      
        
        String extension = pFileName.substring(pFileName.lastIndexOf(".") + 1);
        
        if (extension.toLowerCase().equals("jpg") || extension.toLowerCase().equals("png") || extension.toLowerCase().equals("bmp")) {
    		String pDirPath = commonUtil.getUploadPath("upload_common.ROOT", loginSimpleVO.getTenantId());    		
    		pDirPath = realPath + pDirPath;
    		
            if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
            	pDirPath = pDirPath + commonUtil.separator;
            }
    		
            File file = new File(pDirPath + "optImages");
            
            if (!file.exists()) {
            	file.mkdirs();        
            }
            
            String newFileName = pUploadSN + "." + extension;  
            fileSize = multiFile.get(0).getSize();
            StringBuffer strXML = new StringBuffer();
            strXML.append("<ROOT><NODES>");
            writeUploadedFile(multiFile.get(0), newFileName, pDirPath + "optImages");
			strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName + "/" + fileSize + "]]></DATA>");
			strXML.append("<DATA2><![CDATA[]]></DATA2>");
			strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
			strXML.append("</NODES></ROOT>");
			
			logger.debug("upload comment file finishes!");
			return strXML.toString();
        }        	
        else {
        	logger.debug("upload comment file finishes!");
        	return "ERROR";
        }         
	}
	
	@RequestMapping(value="/ezPoll/adjustJoinedUsers.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String adjustJoinedUsersNumber(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, HttpSession session, HttpServletResponse response) throws Exception {
		logger.debug("Adjust joined users is running!");			
		LoginVO loginVO = commonUtil.userInfo(loginCookie);	
		String strXML = "";
		int qstId = 0;
		int optId = 0;
		String flag = "";
		
		if (req.getParameter("questId") != null) {
			qstId = Integer.parseInt(req.getParameter("questId"));
		}
		
		if (req.getParameter("optionId") != null) {
			optId = Integer.parseInt(req.getParameter("optionId"));
		}
		
		if (req.getParameter("flag") != null) {
			flag = req.getParameter("flag");
		}
		
		PollUserAnswerVO pollUserAnswerCheck = ezPollService.getSpecificPollUserAndAnswer(optId, qstId, loginVO.getId(), loginVO.getTenantId()); //20180108 baonk added
		
		if (flag.equals("1")) {
			//20180108 baonk added
			if (pollUserAnswerCheck != null) {				
				strXML = "<RESULT>ADD_OK</RESULT>";
				return strXML;
			}
			//end
			
			//Get string of time now
			Date date = new Date();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String dateNow = formatter.format(date);
			
			//Get all of voted users
			List<PollUserAnswerVO> listOfPollUserAndAnswer = ezPollService.getPollUserAndAnswer(qstId, loginVO.getTenantId());
			
			int check = -1;
			
			for (PollUserAnswerVO pollUserAndAnswer : listOfPollUserAndAnswer) {
				if (pollUserAndAnswer.getUserId().equals(loginVO.getId())) {
					check = 0;
					break;
				}
			}
			
			if (check == -1) {
				//Update number of unVoted users
				String result = "{\"result\":\"ADD\", \"userId\":\"" + loginVO.getId() + "\", \"sessionid\":\"" + egovFileScrty.encryptAES(session.getId()) + "\"}";
				JSONParser parser = new JSONParser(); 
				JSONObject json = (JSONObject) parser.parse(result);
				this.template.convertAndSend("/reply/updateUnVotedUsersForQst" + qstId + "+" + loginVO.getTenantId(), json);
			}
			
			//Add PollUserAnswerVO fields
			PollUserAnswerVO pollUserAnswer = new PollUserAnswerVO();
			pollUserAnswer.setAnsId(optId);
			pollUserAnswer.setQstId(qstId);
			pollUserAnswer.setUserId(loginVO.getId());
			pollUserAnswer.setTenantId(loginVO.getTenantId());
			pollUserAnswer.setUserName1(loginVO.getDisplayName1());
			pollUserAnswer.setUserName2(loginVO.getDisplayName2());
			pollUserAnswer.setVoteDate(dateNow);
			strXML = addUserAndAnswer(pollUserAnswer, egovFileScrty.encryptAES(session.getId()));		
		}
		else {
			//20180108 baonk added
			if (pollUserAnswerCheck == null) {
				strXML = "<RESULT>REMOVE_OK</RESULT>";
				return strXML;
			}
			//end
			
			//Delete entry in database
			PollUserAnswerVO pollUserAnswer = new PollUserAnswerVO();
			pollUserAnswer.setAnsId(optId);
			pollUserAnswer.setQstId(qstId);
			pollUserAnswer.setUserId(loginVO.getId());
			pollUserAnswer.setTenantId(loginVO.getTenantId());
			pollUserAnswer.setUserName1(loginVO.getDisplayName1());
			pollUserAnswer.setUserName2(loginVO.getDisplayName2());
			strXML = removeUserAndAnswer(pollUserAnswer, egovFileScrty.encryptAES(session.getId()));
			
			//Get all of voted users
			List<PollUserAnswerVO> listOfPollUserAndAnswer = ezPollService.getPollUserAndAnswer(qstId, loginVO.getTenantId());
			
			int check = -1;
			
			for (PollUserAnswerVO pollUserAndAnswer : listOfPollUserAndAnswer) {
				if (pollUserAndAnswer.getUserId().equals(loginVO.getId())) {
					check = 0;
					break;
				}
			}
			
			if (check == -1) {
				//Update the number of not voted yet users
				String result = "{\"result\":\"REMOVE\", \"userId\":\"" + loginVO.getId() + "\", \"sessionid\":\"" + egovFileScrty.encryptAES(session.getId()) + "\"}";		
				JSONParser parser = new JSONParser(); 
				JSONObject json = (JSONObject) parser.parse(result);
				this.template.convertAndSend("/reply/updateUnVotedUsersForQst" + qstId + "+" + loginVO.getTenantId(), json);
			}			
		}
		
		logger.debug("Adjust joined users finishes!");	
		return strXML;
	}
	
	@RequestMapping(value="/ezPoll/deleteCmtFile.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteCmtFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, HttpServletResponse response) throws Exception {
		logger.debug("Delete comment file is running!");
		String fileName = "";
		String strXML = "";
		
		if (req.getParameter("fileToDelete") != null) {
			fileName = req.getParameter("fileToDelete").split("/")[0];
		}
		
		String realPath = req.getServletContext().getRealPath("");
		String pDirPath = commonUtil.separator + "files" + commonUtil.separator + "commentImages" + commonUtil.separator;
		
		try {
			String absoluteFilePath = realPath + pDirPath + commonUtil.detectPathTraversal(fileName);
			File file = new File(absoluteFilePath);
			
			if (!file.exists()) {
				logger.debug("Wrong folder path!");
				return "<DATA>DELETE_FAIL</DATA>";
			}
			
			file.delete();	
			strXML = "<DATA>DELETE_OK</DATA>";
		}
		catch (Exception e) {
			strXML = "<DATA>DELETE_FAIL</DATA>";
	        logger.error(e.getMessage(), e);
	    }
		
		logger.debug("Delete comment file finishes!");
		return strXML;
	}
	
	@RequestMapping(value="/ezPoll/deleteOptPrevFile.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteOptPrevFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, LoginSimpleVO loginSimpleVO, HttpServletResponse response) throws Exception {
		logger.debug("Delete prevFile is running!");
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String fileName = "";
		String optImgPrevArrStr = "";
		String[] optImgPrevArr = new String[]{};
		String strXML = "";
		int checkUsingFile = 0;
		
		if (req.getParameter("optImgPrevArr") != null && !req.getParameter("optImgPrevArr").equals("")) {
			optImgPrevArrStr = req.getParameter("optImgPrevArr");
			optImgPrevArr = optImgPrevArrStr.split(",");
		}		
		
		String realPath = req.getServletContext().getRealPath("");
		String pDirPath = commonUtil.getUploadPath("upload_vote.ROOT", loginSimpleVO.getTenantId());
		pDirPath = realPath + pDirPath;
		
		if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
		
		for(int i = 0; i < optImgPrevArr.length; i++){
			//사용중인 파일 체크해서 삭제 목록에서 건너 뜀.
			checkUsingFile = ezPollService.checkUsingFile(loginSimpleVO.getTenantId(), optImgPrevArr[i]);
			if(checkUsingFile >= 1){
				continue;
			}
			
			fileName = optImgPrevArr[i].split("/")[0];
			
			try {
				String absoluteFilePath = pDirPath + "uploadFile/" + commonUtil.detectPathTraversal(fileName);
				File file = new File(absoluteFilePath);
				
				if (!file.exists()) {
					logger.debug("Wrong folder path!");
					return "<DATA>DELETE_FAIL</DATA>";
				}
				
				file.delete();	
				strXML = "<DATA>DELETE_OK</DATA>";
			}
			catch (Exception e) {
				strXML = "<DATA>DELETE_FAIL</DATA>";
		        logger.error(e.getMessage(), e);
		    }
		}
		
		logger.debug("Delete prevFile finishes!");
		return strXML;
	}

	@RequestMapping(value="/ezPoll/deleteFile.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, LoginSimpleVO loginSimpleVO, HttpServletResponse response) throws Exception {
		logger.debug("Delete file is running!");
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String fileName = "";
		String strXML = "";
		
		if (req.getParameter("fileToDelete") != null) {
			fileName = req.getParameter("fileToDelete").split("/")[0];
		}		
		
		String realPath = req.getServletContext().getRealPath("");
		String pDirPath = commonUtil.getUploadPath("upload_vote.ROOT", loginSimpleVO.getTenantId());
		pDirPath = realPath + pDirPath;
		
		if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
		
		String absoluteFilePath = pDirPath + "uploadFile/" + commonUtil.detectPathTraversal(fileName);
		
		try {
			File file = new File(absoluteFilePath);
			
			if (!file.exists()) {
				logger.debug("Wrong folder path!");
				return "<DATA>DELETE_FAIL</DATA>";
			}
			
			file.delete();	
			strXML = "<DATA>DELETE_OK</DATA>";
		}
		catch (Exception e) {
			strXML = "<DATA>DELETE_FAIL</DATA>";
	        logger.error(e.getMessage(), e);
	    }
		
		logger.debug("Delete file finishes!");
		return strXML;
	}
			
	@RequestMapping(value = "/ezPoll/showVotedUsersInfo.do", method = RequestMethod.GET)
	public String showVotedUsersInfo(@CookieValue("loginCookie")String loginCookie, Locale locale,HttpServletRequest request, ModelMap model) throws Exception {
		logger.debug("Show voted user info is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantId = loginVO.getTenantId();
		int qstId = -1;
		int optId = -1;		
		int totalVotes = 0;
		int totalVotesForOption = 0;
		String content = "";
		
		if (request.getParameter("qstId") != null && request.getParameter("optId") != null) {
			qstId =	Integer.parseInt(request.getParameter("qstId"));
			optId =	Integer.parseInt(request.getParameter("optId"));
		}
		
		//Get list of users and their answers	
		List<PollUserAnswerVO> listOfPollUserAndAnswer = ezPollService.getPollUserAndAnswer(qstId, tenantId);	
		List<PollUserAnswerVO> listOfVotedUsersForAnswer = ezPollService.getListVotedUsersForAnswer(optId, qstId, tenantId);
		PollAnswerVO pollAnswer = ezPollService.getAnswerByIdAndQstId(optId, qstId, tenantId);
		totalVotes = listOfPollUserAndAnswer.size();
		totalVotesForOption = listOfVotedUsersForAnswer.size();
		content = pollAnswer.getContent();
		
		//Set image for each commented user
		for (PollUserAnswerVO userAnswer: listOfVotedUsersForAnswer) {
			String imagePath = ezOrganService.getPropertyValue(userAnswer.getUserId(), "extensionAttribute2", userAnswer.getTenantId());
			
			if (imagePath != null && !imagePath.equals("")) {
				String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", userAnswer.getTenantId())+ commonUtil.separator + imagePath;
				String fullPath = request.getServletContext().getRealPath(realPath);
				
				if (checkExist(fullPath)) {
					userAnswer.setUserImage("/ezCommon/downloadAttach.do?filePath=" + realPath);
				}
				else {
					userAnswer.setUserImage("/images/poll/default_pic_vote.gif");
				}
			} 
			else {
				userAnswer.setUserImage("/images/poll/default_pic_vote.gif");
			}
			
			//Add user's phone
			LoginVO user = loginService.selectReceiver(userAnswer.getUserId(), tenantId);
			if(user != null){
				userAnswer.setPhone(user.getPhone());
			}
		}

		model.addAttribute("totalVotes", totalVotes);
		model.addAttribute("totalVotesForOption", totalVotesForOption);
		model.addAttribute("content", content);
		model.addAttribute("listOfVotedUsers", listOfVotedUsersForAnswer);
		model.addAttribute("primaryLang", loginVO.getPrimary());
		model.addAttribute("qstID", qstId);
		model.addAttribute("optID", optId);
		
		logger.debug("Show voted user info finishes!");
		return "/ezPoll/showVotedUsers";
	}
	
	@RequestMapping(value = "/ezPoll/showUnJoinedUsersInfo.do", method = RequestMethod.GET)
	public String showUnJoinedUsersInfo(@CookieValue("loginCookie")String loginCookie, Locale locale,HttpServletRequest request, ModelMap model) throws Exception {
		logger.debug("Show un joined user info is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String companyID = loginVO.getCompanyID();
		int tenantId = loginVO.getTenantId();
		int qstId = -1;
		int numberOfUnVotedUsers = 0;
		
		if (request.getParameter("qstId") != null) {
			qstId =	Integer.parseInt(request.getParameter("qstId"));
		}
		
		//Get all users for this question
		//해당 투표 대상자 전체 인원을 얻어옴. 2018-06-04 홍대표
		List<LoginVO> listofTotalUsers = ezPollService.getAllUsersInfoForQstM(tenantId, qstId, companyID);
		List<LoginVO> listOfUnvotedUsers = new ArrayList<LoginVO>(listofTotalUsers);		
		
		//Get list of users and their answers
		List<PollUserAnswerVO> listOfPollUserAndAnswer = ezPollService.getPollUserAndAnswer(qstId, tenantId);
		
		//Get list of voted users
		List<String> listOfAnsweredUsers = new ArrayList<String>();
		
		for (PollUserAnswerVO pollUserAndAnswer : listOfPollUserAndAnswer) {
			if (!listOfAnsweredUsers.contains(pollUserAndAnswer.getUserId())) {
				listOfAnsweredUsers.add(pollUserAndAnswer.getUserId());
			}
		}		
		
		Iterator<LoginVO> iterator = listOfUnvotedUsers.iterator();
		
		while (iterator.hasNext()) {
			LoginVO user = iterator.next();
			
			if (listOfAnsweredUsers.contains(user.getId())) {
				iterator.remove();	
			}
			else {
				String userImagePath = user.getUserFileUrl();
				
				if (userImagePath != null && !userImagePath.equals("")) {
					String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", user.getTenantId())+ commonUtil.separator + userImagePath;
					String fullPath = request.getServletContext().getRealPath(realPath);
					
					if (checkExist(fullPath)) {
						user.setUserFileUrl("/ezCommon/downloadAttach.do?filePath=" + realPath);
					}
					else {
						user.setUserFileUrl("/images/poll/default_pic_vote2.png");
					}
				} 
				else {
					user.setUserFileUrl("/images/poll/default_pic_vote2.png");
				}
			}
		}		
		
		numberOfUnVotedUsers = listOfUnvotedUsers.size();
		
		model.addAttribute("numberOfUnVotedUsers", numberOfUnVotedUsers);
		model.addAttribute("listOfUnvotedUsers", listOfUnvotedUsers);
		model.addAttribute("qstID", qstId);		
		model.addAttribute("primaryLang", loginVO.getPrimary());
		
		logger.debug("Show un joined user info finishes!");
		return "/ezPoll/showNotJoinedUsers";
	}
	
	@MessageMapping("/editVote") 
	public void editVote(JSONObject message) throws org.json.simple.parser.ParseException {
		logger.debug("Edit vote is running!");		
		String loginCookie = (String) message.get("loginCookie");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int qstId = Integer.parseInt((String) message.get("question"));
		int tenantId = Integer.parseInt((String)message.get("tenant"));	
		String companyID = loginVO.getCompanyID();
		String sessionId = (String)message.get("sessionid");
		String userId = (String)message.get("user");
		
		//Update current modifying vote status
		try {
			ezPollService.updateModifyingQuestion(qstId, tenantId, 1);
			PollQuestionStatusVO pollQstStatusVO = new PollQuestionStatusVO();
			pollQstStatusVO.setUserId(userId);
			pollQstStatusVO.setTenantId(tenantId);
			pollQstStatusVO.setQustId(qstId);
			ezPollService.insertModifyingQuestion(pollQstStatusVO, companyID);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		//Inform all waiting users
		String result = "{\"result\":\"CHANGED\", \"userId\":\"" + userId + "\", \"sessionid\":\"" + sessionId + "\"}";
		JSONParser parser = new JSONParser(); 
		JSONObject json = (JSONObject) parser.parse(result);
		this.template.convertAndSend("/reply/editQst" + qstId + "+" + tenantId, json);		
		logger.debug("Edit vote finishes!");	
	}
		
	@MessageMapping("/finish")
	public void finishVote(JSONObject message) throws org.json.simple.parser.ParseException {
		logger.debug("Finish vote is running!");		
		int qstId = Integer.parseInt((String) message.get("question"));
		int tenantId = Integer.parseInt((String)message.get("tenant"));	
		
		//Close the vote by update the end date		
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String dateNow = formatter.format(date);
		
		try {
			ezPollService.updateEndDateForQst(qstId, tenantId, dateNow);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		//Inform all subscriber users
		String result = "{\"result\":\"OK\"}";		
		JSONParser parser = new JSONParser(); 
		JSONObject json = (JSONObject) parser.parse(result);
		this.template.convertAndSend("/reply/finishVoteForQst" + qstId + "+" + tenantId, json);
		logger.debug("Finish vote finishes!");
	}
	
	@RequestMapping(value = "/ezPoll/showSeenUserInfo.do", method = RequestMethod.GET)
	public String showSeenUsersInfo(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, ModelMap model) throws Exception {
		logger.debug("Show seen users info is running!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantId = loginVO.getTenantId();
		String companyID = loginVO.getCompanyID();
		int qstId =	Integer.parseInt(request.getParameter("qstId"));
	
		//Get all related users for this question
		//해당 투표 대상자 전체 인원을 얻어옴. 2018-06-04 홍대표
		List<LoginVO> listofUnseenUsers = ezPollService.getAllUsersInfoForQstM(tenantId, qstId, companyID);
		List<LoginVO> listofSeenUsers = ezPollService.getInfoOfSeenUsers(tenantId, qstId, companyID);
		
		int numberOfSeenUsers = listofSeenUsers.size();
		listofUnseenUsers.removeAll(listofSeenUsers);
		
		for (LoginVO user : listofSeenUsers) {
			String userImagePath = user.getUserFileUrl();
			
			if (userImagePath != null && !userImagePath.equals("")) {				
				String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", user.getTenantId())+ commonUtil.separator + userImagePath;
				String fullPath = request.getServletContext().getRealPath(realPath);
				
				if (checkExist(fullPath)) {
					user.setUserFileUrl("/ezCommon/downloadAttach.do?filePath=" + realPath);
				}
				else {
					user.setUserFileUrl("/images/poll/default_pic_vote2.png");
				}
			} 
			else {
				user.setUserFileUrl("/images/poll/default_pic_vote2.png");
			}
		}
		
		int numberOfUnseenUsers = listofUnseenUsers.size();
		
		//Add user image
		for (LoginVO user : listofUnseenUsers) {
			String userImagePath = user.getUserFileUrl();
			
			if (userImagePath != null && !userImagePath.equals("")) {				
				String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", user.getTenantId())+ commonUtil.separator + userImagePath;
				String fullPath = request.getServletContext().getRealPath(realPath);
				
				if (checkExist(fullPath)) {
					user.setUserFileUrl("/ezCommon/downloadAttach.do?filePath=" + realPath);
				}
				else {
					user.setUserFileUrl("/images/poll/default_pic_vote2.png");
				}
			} 
			else {
				user.setUserFileUrl("/images/poll/default_pic_vote2.png");
			}
		}
		
		//Sort list of seen users
		if (!listofSeenUsers.isEmpty()) {
			if (loginVO.getPrimary().equals("1")) {
				Collections.sort(listofSeenUsers, (LoginVO user1, LoginVO user2) -> {
			        return user1.getDisplayName1().compareTo(user2.getDisplayName1());		        
				});
			}
			else {
				Collections.sort(listofSeenUsers, (LoginVO user1, LoginVO user2) -> {
			        return user1.getDisplayName2().compareTo(user2.getDisplayName2());		        
				});
			}
		}
		
		//Sort list of unseen users
		if (!listofUnseenUsers.isEmpty()) {
			if (loginVO.getPrimary().equals("1")) {
				Collections.sort(listofUnseenUsers, (LoginVO user1, LoginVO user2) -> {
			        return user1.getDisplayName1().compareTo(user2.getDisplayName1());		        
				});
			}
			else {
				Collections.sort(listofUnseenUsers, (LoginVO user1, LoginVO user2) -> {
			        return user1.getDisplayName2().compareTo(user2.getDisplayName2());		        
				});
			}
		}
		
		model.addAttribute("listOfSeenUsers", listofSeenUsers);
		model.addAttribute("listOfUnSeenUsers", listofUnseenUsers);
		model.addAttribute("numberOfSeenUsers", numberOfSeenUsers);
		model.addAttribute("numberOfUnseenUsers", numberOfUnseenUsers);
		model.addAttribute("primaryLang", loginVO.getPrimary());
		model.addAttribute("qstID", qstId);
		
		logger.debug("Show seen users info finishes!");
		return "/ezPoll/showSeenUserInfo";
	}
	
	@RequestMapping(value="/ezPoll/qstRangeSelect.do", method = RequestMethod.GET)
	public String qstRangeSelect(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		logger.debug("qstRangeSelect started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userInfoDeptCode="";				
		String pCompanyID="";
		String brdID = "";
		String itemID = "";
		
		if (req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		
		if (req.getParameter("itemNo") != null) {
			itemID = req.getParameter("itemNo");
		}

		userInfoDeptCode = userInfo.getDeptID();
		pCompanyID = userInfo.getCompanyID();
		
		String langData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());		
		
		model.addAttribute("brdID", brdID);
		model.addAttribute("itemNo", itemID);
		model.addAttribute("pCompanyID", pCompanyID);
		model.addAttribute("userInfoDeptCode", userInfoDeptCode);
		model.addAttribute("langData", langData);
		model.addAttribute("primary", userInfo.getPrimary());
		
		logger.debug("qstRangeSelect ended");
		return "/ezPoll/rangeSelect";
	}
	
	/**
	 * 메일 쓰기화면 호출 함수
	 * : /ezEmail/mailWrite.do 로 통합함.
	 */
	
	private String addUserAndAnswer(PollUserAnswerVO pollUserAnswer, String sessionId) {
		String strXML = "";
		
		try {
			ezPollService.addAnswerAndUser(pollUserAnswer);
			ezPollService.updateNumberOfVotesForAnswer(pollUserAnswer, 1);
			getUpdateVotes(pollUserAnswer, 1, sessionId);
			strXML = "<RESULT>ADD_OK</RESULT>";
		}
		catch (Exception e) {
			strXML = "<RESULT>ADD_FAIL</RESULT>";
			logger.error(e.getMessage(), e);
		}
		
		return strXML;
	}
	
	private String removeUserAndAnswer(PollUserAnswerVO pollUserAnswer, String sessionId) {
		String strXML = "";
		
		try {
			ezPollService.removeAnswerAndUser(pollUserAnswer);	
			ezPollService.updateNumberOfVotesForAnswer(pollUserAnswer, -1);
			getUpdateVotes(pollUserAnswer, 0, sessionId);
			strXML = "<RESULT>REMOVE_OK</RESULT>";
		}
		catch (Exception e) {
			strXML = "<RESULT>REMOVE_FAIL</RESULT>";
			logger.error(e.getMessage(), e);
		}
		
		return strXML;
	}
	
	private void getUpdateVotes(PollUserAnswerVO pollUserAnswer, int mode, String sessionId) throws Exception {		
		int optId = pollUserAnswer.getAnsId();
		int qstId = pollUserAnswer.getQstId();
		String userId = pollUserAnswer.getUserId();
		String userName1 = pollUserAnswer.getUserName1();
		String userName2 = pollUserAnswer.getUserName2();
		int tenantId = pollUserAnswer.getTenantId();
		
		String result = "{\"optionId\":\"" + Integer.toString(optId) + "\", \"mode\":\"" + Integer.toString(mode) + "\", \"userId\":\"" + userId + "\",\"userName1\":\"" + userName1 + "\",\"userName2\":\"" + userName2 + "\",\"sessionid\":\"" + sessionId + "\"}";
		JSONParser parser = new JSONParser(); 
		JSONObject json = (JSONObject) parser.parse(result);
		this.template.convertAndSend("/reply/getResultUpdateForQst" + qstId + "+" + tenantId, json); 
	}
	
	private int getQuestionSeq(int tenantID) throws Exception {		
		int currentMaxQstID = -1;		
		
		if (ezPollService.getQuestionSeq(tenantID).equals("")) {
			currentMaxQstID = 1;
		} 
		else {
			currentMaxQstID = Integer.parseInt(ezPollService.getQuestionSeq(tenantID).toString());			
		}
		
		if (currentMaxQstID == -1) {
			currentMaxQstID = 1;
		}
		else {
			currentMaxQstID += 1;
		}

		return currentMaxQstID;
	}	
	
	private String saveQuestion(PollQuestionVO pollQuestionVO, String StrXmlRange, LoginVO loginVO) throws Exception {
		logger.debug("Save question is running!");		
		ezPollService.insertQuestion(pollQuestionVO);

		if (pollQuestionVO.getTarget() == 0) {	
			pollQuestionVO.setReceiverType("company");
			pollQuestionVO.setUserId(loginVO.getCompanyID());			
			ezPollService.insertQustReceivers(pollQuestionVO);
		}
		else {	
			Document doc = commonUtil.convertStringToDocument(StrXmlRange);
			int pDeptCnt = 0;
			int pUserCnt = 0;
			
			if (doc.getElementsByTagName("DEPT").item(0) != null) {
				pDeptCnt = doc.getElementsByTagName("DEPT").item(0).getChildNodes().getLength();
			}				
			
			for (int j = 0; j < pDeptCnt; j++) {
				String deptID = doc.getElementsByTagName("DEPT").item(0).getChildNodes().item(j).getAttributes().getNamedItem("id").getTextContent();
				pollQuestionVO.setUserId(deptID);
				pollQuestionVO.setReceiverType("dept");
				ezPollService.insertQustReceivers(pollQuestionVO);
			}	
			
			if (doc.getElementsByTagName("MEMBER").item(0) != null) {				
				pUserCnt = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().getLength();
			}				
			
			for (int i = 0; i < pUserCnt; i++) {
				String userID = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("id").getTextContent();
				String deptID = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("deptid").getTextContent();
				if(deptID.equals("")){
					LoginVO user = loginService.selectReceiver(userID, loginVO.getTenantId());
					deptID = user.getDeptID();
				}
				pollQuestionVO.setUserId(userID);
				pollQuestionVO.setUserDeptId(deptID);
				pollQuestionVO.setReceiverType("user");
				ezPollService.insertQustReceivers(pollQuestionVO);
			}
		}
//		ezPollService.insertQstUsers(pollQuestionVO);
		
		logger.debug("Save question finishes");
		return "OK";
	}

	private void getAllMemberOfDept(List<LoginVO> list, String deptId, int tenantID) throws Exception {		
		List<LoginVO> list1 = loginService.selectAllReceivers(deptId, tenantID);
		
		if (list1 != null && list1.size() > 0) {
			list.addAll(list1);
		}		
		
		//Get all member of sub department
		List<String> subDeptIdList = ezOrganService.getAllSubDeptId(deptId, tenantID);
		
		if (subDeptIdList != null && subDeptIdList.size() > 0) {
			for (String subDeptId : subDeptIdList) {				
				getAllMemberOfDept(list, subDeptId, tenantID);
			}
		}		
	}

	private int setStatusForQuestions(Set<PollQuestionVO> setOfQuestions, List<Integer> listHiddenQuestionIds, LoginVO loginVO, int checkingArray, int seeAll) throws ParseException {
		String userID = loginVO.getId();		
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date endDate;
		Date startDate; //20180109
		Date sysDate = new Date();
		int compareEnd;
		int compareStart; //20180109
		
		if (seeAll == 1) {
			for (PollQuestionVO pollQstVO: setOfQuestions) {
				if (listHiddenQuestionIds.contains(pollQstVO.getQstId())) {
					pollQstVO.setIsHidden(1);
				}
				else {
					pollQstVO.setIsHidden(0);
				}			
				
				endDate = formatter.parse(pollQstVO.getEndDate());				
				compareEnd = endDate.compareTo(sysDate); 
				startDate = formatter.parse(pollQstVO.getStartDate()); //20180109
				compareStart = startDate.compareTo(sysDate); //20180109
				
				if (compareEnd > 0) {
					if (compareStart > 0) {
						pollQstVO.setStatus(2); // reserve poll
					}
					else {
						pollQstVO.setStatus(1); // ssing pollproce
					}					
				}
				else {
					pollQstVO.setStatus(0); // ended poll
				}
				
				//Checking Array
				if (userID.equals(pollQstVO.getCreator())) {
					checkingArray = 1;
				}
			}
		}
		else {
			Iterator<PollQuestionVO> iterator = setOfQuestions.iterator();
			
			while (iterator.hasNext()) {
				PollQuestionVO pollQstVO = iterator.next();
				
				if (listHiddenQuestionIds.contains(pollQstVO.getQstId())){
					iterator.remove();				
				}
				else {					
					endDate = formatter.parse(pollQstVO.getEndDate());
					compareEnd = endDate.compareTo(sysDate);
					startDate = formatter.parse(pollQstVO.getStartDate()); //20180109
					compareStart = startDate.compareTo(sysDate); //20180109
					
					if (compareEnd > 0) {
						if (compareStart > 0) {
							pollQstVO.setStatus(2); // reserve poll
						}
						else {
							pollQstVO.setStatus(1); // processing poll
						}	
					} 
					else {
						pollQstVO.setStatus(0);
					}
					
					pollQstVO.setIsHidden(0);
					
					//Checking Array
					if (userID.equals(pollQstVO.getCreator())) {
						checkingArray = 1;
					}
				}
			}
		}
		return checkingArray;
	}
	
	private void saveHiddenQuestion(String hideQstList, LoginVO loginVO) throws Exception {
		String userID = loginVO.getId();		
		String[] hiddenQstIds = hideQstList.split(",");
		
		for (int i = 0; i < hiddenQstIds.length; i++) {
			PollQuestionStatusVO pollQstStatusVO = new PollQuestionStatusVO();
			pollQstStatusVO.setUserId(userID);
			pollQstStatusVO.setTenantId(loginVO.getTenantId());
			pollQstStatusVO.setQustId(Integer.parseInt(hiddenQstIds[i]));			
			ezPollService.insertHiddenQuestion(pollQstStatusVO);
		}
	}
	
	private String questionDelete(String listQstIds, LoginVO loginVO, String pDirPath, String realPath) throws Exception {			
		String strXML = "";
		String [] qstIdArray = listQstIds.split(",");
		try {
			for (int i = 0; i < qstIdArray.length; i++) {
				int qstId = Integer.parseInt(qstIdArray[i]);
				
				//Delete files relate to qstId
				ezPollService.deleteAllFilesByQstId(loginVO.getTenantId(), qstId, pDirPath, realPath);
				
				//Delete in table Question
				ezPollService.deleteQuestions(qstId, loginVO.getTenantId());
				
				//Delete in table User and Answer
				ezPollService.deleteUserAndAnswer(qstId, loginVO.getTenantId());
				
				//Delete in table Question Related
				ezPollService.deleteQuestionRelated(qstId, loginVO.getTenantId());
				
				//Delete in table Answer
				ezPollService.deleteAnswers(qstId, loginVO.getTenantId());
				
				//Delete in table User and Answer
				ezPollService.deleteUserAndQuestion(qstId, loginVO.getTenantId());
				
				//Delete in table Comment
				ezPollService.deleteCommentOfQst(qstId, loginVO.getTenantId());
				
//				//Delete in table users
//				ezPollService.deleteUsersForQst(loginVO.getTenantId(), qstId);
				
				//Inform waiting users
				String result = "{\"result\":\"DELETED\", \"userId\":\"" + loginVO.getId() + "\"}";
				String result2 = "{\"result\":\"DELETED\"}";
				JSONParser parser = new JSONParser(); 
				JSONObject json = (JSONObject) parser.parse(result);
				JSONObject json2 = (JSONObject) parser.parse(result2);
				this.template.convertAndSend("/reply/deleteQst" + qstId + "+" + loginVO.getTenantId(), json);
				this.template.convertAndSend("/reply/qstDeleteForTenant" + loginVO.getTenantId(), json2);
			}
			
			strXML = "<DATA>DELETE_OK</DATA>";
		}
		catch (Exception e) {
			logger.debug("Exception in delete question function!");
			strXML = "<DATA>DELETE_FAIL</DATA>";
			logger.error(e.getMessage(), e);
		}		
		
		return strXML;
	}	
	
	private void getUpdateSeenRequests(int totalSeenUpdated, int qstId, int tenantId) throws Exception {	
		String result = "{\"updatedNumber\":\"" + Integer.toString(totalSeenUpdated) + "\"}";
		JSONParser parser = new JSONParser(); 
		JSONObject json = (JSONObject) parser.parse(result);
		this.template.convertAndSend("/reply/getSeenUpdateForQst" + qstId + "+" + tenantId, json); 			
	}	
	
	private boolean checkExist(String filePath) throws Exception {
		String checkFilePath = commonUtil.detectPathTraversal(filePath);
		File f = new File(checkFilePath);
		
		if (f.exists() && !f.isDirectory()) { 
		    return true;
		}
		else {
			return false;
		}
	}
	
	private String getFileSize(int fileSize) {
		String fileSize_ = "";
		
        if (fileSize / 1024 / 1024 >= 1) {
        	fileSize_ = String.format("%.2f", ((double)fileSize / 1024 / 1024 * 10) / 10);
        	fileSize_ = fileSize_ + "MB";
        }
        else if (fileSize / 1024 >= 1) {
        	fileSize_ = String.format("%.2f", ((double)fileSize / 1024));
        	fileSize_ = fileSize_ + "KB";
        }
        else {
        	fileSize_ = fileSize + "B";
        }
        
        return fileSize_;
	}
	
	@RequestMapping(value="/ezPoll/updateEndDateForQst.do", method = RequestMethod.POST)
	public String updateEndDateForQst(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, ModelMap model, HttpServletResponse response) throws Exception {		
		logger.debug("Updating question end-date is running!");		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantID = loginVO.getTenantId();
		int qstId = Integer.parseInt(req.getParameter("qstId"));
		String endDate = req.getParameter("endDate");
		
		ezPollService.updateEndDateForQst(qstId, tenantID, endDate);
		
		logger.debug("Updating question end-date finishes!");
		return "redirect:/ezPoll/pollList.do";
	}

	/**
	 * 2023-08-18 장혜연 -댓글 이미지, 에디터 이미지 파일 경로를 upload_common -> upload_vote 로 변경한다.
	 * @param request
	 * @param qstId
	 * @param content
	 * @param tenantId
	 * @param folderName
	 * @return
	 * @throws Exception
	 */
	public PollFilePathVO changeImgPathInContent (HttpServletRequest request, int qstId, String content, int tenantId, String folderName) throws Exception{
		String realPath = request.getServletContext().getRealPath("");
		String targetDirPath = commonUtil.getUploadPath("upload_vote.ROOT", tenantId) + commonUtil.separator + folderName;
		String targetDirFullPath = realPath + targetDirPath ;
		String targetContent = "";
		List<Map<String, String>> copyFilePathList = new ArrayList<>();
		
		// 댓글 이미지일 경우
		if (folderName.equals("commentImages")) {
			Map<String, String> copyMap = new HashMap<>();
			String fileName = content.substring(content.lastIndexOf('/') + 1);

			copyMap.put("sourcePath", request.getServletContext().getRealPath(content));
			copyMap.put("targetPath", targetDirFullPath + commonUtil.separator + fileName);
			logger.debug("comment sourcePath : {} ", request.getServletContext().getRealPath(content));
			logger.debug("comment targetPath : {} ", targetDirFullPath + commonUtil.separator + fileName);
			copyFilePathList.add(copyMap);
			targetContent = targetDirPath + commonUtil.separator + fileName;
			logger.debug("targetContent : {}", targetContent);
		}
		// 에디터 이미지일 경우 (uploadFile)
		else {
			org.jsoup.nodes.Document document = Jsoup.parse(content);
			Elements elements = document.getElementsByTag("img");

			// 에디터 본문 내부에 이미지가 존재하는 경우, 해당 이미지의 파일경로 변경
			if (!elements.isEmpty()) {
				for (org.jsoup.nodes.Element element : elements) {
					Map<String, String> copyMap = new HashMap<>();
					String fileName = element.attr("src").substring(element.attr("src").lastIndexOf('/') + 1);

					copyMap.put("sourcePath", request.getServletContext().getRealPath(element.attr("src")));
					copyMap.put("targetPath", targetDirFullPath + commonUtil.separator + fileName);

					element.attr("src", targetDirPath + commonUtil.separator + fileName);
					copyFilePathList.add(copyMap);
				}
			}
			
			/* 2024-12-11 홍승비 - 투표 > 에디터 본문 내부에 이미지가 없는 경우, 내용(content)을 저장하지 못하는 오류 분기 수정 */
			Elements body = document.body().children();
			targetContent = body.toString();
		}
		
		// path를 바꿔준 최종 내용, 파일을 복사하기 위해 필요한 source와 target Path를 반환
		PollFilePathVO pollFilePathVO = new PollFilePathVO(targetContent, copyFilePathList, targetDirFullPath);
		return pollFilePathVO;
	}

	/**
	 * 2023-08-18 장혜연 - 투표 게시물을 업로드 할 경우 common_upload -> common_vote 폴더에 복사 한다.
	 * @param request
	 * @param copyImgList
	 * @param targetDirfullPath
	 * @throws Exception
	 */
	public void copyUploadImages(HttpServletRequest request, List<Map<String, String>> copyImgList, String targetDirfullPath) throws Exception {
		File folder = new File(targetDirfullPath);
		// 폴더가 있는지 확인 후 존재하지 않으면 생성
		if (!folder.exists()) {
			folder.mkdirs();
		}

		for (int i = 0; i < copyImgList.size(); i++) {
			// 이미 존재하는 이미지들은 복사를 실행하지 않는다.(수정 시 이미지를 추가 한 경우)
			if (copyImgList.get(i).get("sourcePath").contains("upload_vote")) {
				continue;
			}

			try (FileInputStream inputStream = new FileInputStream(commonUtil.detectPathTraversal(copyImgList.get(i).get("sourcePath")));
				FileOutputStream outputStream = new FileOutputStream(commonUtil.detectPathTraversal(copyImgList.get(i).get("targetPath")));) {
				byte[] buffer = new byte[1024];
				int bytesRead;

				while ((bytesRead = inputStream.read(buffer)) != -1) {
					outputStream.write(buffer, 0, bytesRead);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 2023-08-18 장혜연 - 에디터 수정 시 본 내용과 비교하여 삭제 해준다
	 * @param request
	 * @param orgContent
	 * @param modContent
	 * @throws Exception
	 */
	public void deleteContentImages(HttpServletRequest request, String orgContent,  String modContent) throws Exception {
		// 본 img 태그의 요소들을 가져온다.
		org.jsoup.nodes.Document orgDocument = Jsoup.parse(orgContent);
		Elements orgElements = orgDocument.getElementsByTag("img");
		// 수정된  img 태그의 요소들을 가져온다.
		org.jsoup.nodes.Document modDocument = Jsoup.parse(modContent);
		Elements modElements = modDocument.getElementsByTag("img");

		if (!orgElements.isEmpty()) {
			// 수정된 내용에 이미지 파일이 없을 경우 본 내용의 이미지 파일을 모두 삭제한다.
			if (modElements.isEmpty()) {
				for (org.jsoup.nodes.Element orgElement : orgElements) {
					File file = new File(request.getServletContext().getRealPath(orgElement.attr("src")));
					file.delete();
				}
			}
			// 본 내용의 이미지 파일이 수정된 내용의 이미지 파일과 같을 경우 그대로 두고 다를경우 삭제한다.
			for (org.jsoup.nodes.Element orgElement : orgElements) {
				boolean isDelete = true;
				for (org.jsoup.nodes.Element modElement : modElements) {
					if (orgElement.attr("src").equals(modElement.attr("src"))) {
						isDelete = false;
						break;
					}
				}
				if (isDelete) {
					File file = new File(request.getServletContext().getRealPath(orgElement.attr("src")));
					file.delete();
				}
			}
		}
	}

	/**
	 * 2023-08-18 장혜연 - 댓글 수정 시 본 댓글에 파일이 첨부되어 있는 경우 삭제한다
	 * @param request
	 * @param pollCmtVO
	 * @throws Exception
	 */
	public void deleteCmtImage(HttpServletRequest request, PollCommentVO pollCmtVO) throws Exception {
		String cmtImg = pollCmtVO.getFileAttach();
		if (!("".equals(cmtImg) || cmtImg == null)) {
			// 파일이 이미지인 경우
			if (cmtImg.contains("commentImages")) {
				File file = new File(request.getServletContext().getRealPath(cmtImg));
				file.delete();
			} else {
				String cmtFile = pollCmtVO.getFilePath();
				// 이미지가 아닐경우 본 댓글의 첨부파일과 수정한 첨부파일이 동일하지 않으면 삭제한다.
				if (!cmtFile.equals(pollCmtVO.getModFilePath())) {
					String cmpFilePath = commonUtil.getUploadPath("upload_vote.ROOT", pollCmtVO.getTenantId())
							+ commonUtil.separator + "uploadFile" + commonUtil.separator + commonUtil.detectPathTraversal(cmtFile);

					File file = new File(request.getServletContext().getRealPath(cmpFilePath));
					file.delete();
				}
			}
		}
	}
}
