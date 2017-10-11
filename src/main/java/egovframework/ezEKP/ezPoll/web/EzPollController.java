package egovframework.ezEKP.ezPoll.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.util.HSSFColor.BROWN;
import org.codehaus.jackson.map.ObjectMapper;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
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
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollCommentVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionStatusVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezPoll.vo.PollUserAnswerVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

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
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private SimpMessagingTemplate template;
	
	@RequestMapping(value="/ezPoll/pollCreate.do")
	public String questionCreate(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		logger.debug("Start Poll Controller!");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String mode = "";
		int qstId = -1;
		String content = "";
		String [] filePath = null;
		ObjectMapper om = new ObjectMapper();
		List<PollAnswerVO> listOptions = null;
		StringBuffer strXML = new StringBuffer();
		StringBuffer strXMLRange = new StringBuffer();
		strXMLRange.append("<RANGE>"); 
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		if (request.getParameter("qstId") != null) {
			qstId = Integer.parseInt(request.getParameter("qstId"));
		} 
		
		if (!mode.equals("") && qstId != -1){
			//Get question
			try {				
				PollQuestionVO pollQuestionVO = ezPollService.getQuestionByIdAndTenantId(qstId, loginVO.getTenantId());
				if (pollQuestionVO.getFilePath() != null && !pollQuestionVO.getFilePath().equals("")) {
					filePath = pollQuestionVO.getFilePath().split(";");
				}				
				content = pollQuestionVO.getContent();
				
		        //Process attached files
		        if (filePath != null) {
		        	strXML.append("<ROOT><NODES>");
			        for (int i = 0; i < filePath.length; i++) {
			        	//logger.debug("FilePath " + (i + 1) + " is: " + filePath[i]);
						strXML.append("<DATA><![CDATA[" + filePath[i] + "]]></DATA>");
						strXML.append("<DATA2><![CDATA[]]></DATA2>");
						strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
			        }
			        strXML.append("</NODES></ROOT>");
			        logger.debug("BAONK CHECK STRXML: " + strXML.toString());
		        }
		        
		        //Process target
		        List<String> departIdList = ezPollService.getListOfUserIdForQst(qstId, loginVO.getTenantId(), "dept");
		        List<String> userIdList = ezPollService.getListOfUserIdForQst(qstId, loginVO.getTenantId(), "user");
		        //List<OrganDeptVO> organList = new ArrayList<OrganDeptVO>();
		        if (departIdList.size() > 0) {
		        	strXMLRange.append("<DEPT>"); 
			        for (String deptID : departIdList){
			        	OrganDeptVO organDeptVO = ezOrganService.getDeptInfo(deptID, loginVO.getPrimary(), loginVO.getTenantId());
			        	//organList.add(organDeptVO);
			        	strXMLRange.append("<DATA id=\"" + commonUtil.cleanValue(organDeptVO.getCn()) + "\" nm=\"" + commonUtil.cleanValue(organDeptVO.getDisplayName()) + 
			        			"\" nm2=\"" + commonUtil.cleanValue(organDeptVO.getDisplayName2()) + "\">" + commonUtil.cleanValue(organDeptVO.getCn()) + "</DATA>");
			        }
			        strXMLRange.append("</DEPT>"); 
		        }
		        if (userIdList.size() > 0) {
		        	strXMLRange.append("<MEMBER>"); 
		        	for (String userID : userIdList){
		        		LoginVO user = loginService.selectReceiver(userID, loginVO.getTenantId());
		        		strXMLRange.append("<DATA id=\"" + commonUtil.cleanValue(user.getId()) + "\" nm=\"" + commonUtil.cleanValue(user.getDisplayName1()) + 
			        			"\" nm2=\"" + commonUtil.cleanValue(user.getDeptName1()) + "\">" + commonUtil.cleanValue(user.getId()) + "</DATA>");
		        	}
		        	strXMLRange.append("</MEMBER>");
		        }
		        
				model.addAttribute("question", pollQuestionVO);
			}
			catch (Exception e) {
				e.printStackTrace();
			}		
		
			//Get list of Options		
			listOptions = ezPollService.getListOptionsOfQst(qstId, loginVO.getTenantId());					
		}		
		strXMLRange.append("</RANGE>"); 		
		
		//logger.debug("User information: UserId = "  + loginVO.getId() + ", TenantID = " + loginVO.getTenantId() + ", Locale = " + loginVO.getLocale());
		model.addAttribute("optList", om.writeValueAsString(listOptions));
		model.addAttribute("mode", mode);
		model.addAttribute("content", content);
		model.addAttribute("filePath", strXML.toString());
		model.addAttribute("targetPath", strXMLRange.toString());
		//return "/ezQuestion/qstList";
		return "/ezPoll/createPoll";
	}

	@RequestMapping(value="/ezPoll/pollList.do")
	public String getQuestion(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, RedirectAttributes redirectAttributes) throws Exception {
		logger.debug("Start /ezPoll/pollList.do!");
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);		
		String userID = loginVO.getId();
		int  currPage = 1;
		int pageSize = 15;
		int totalPages = 0;
		String brdID = "6";
		String searchStr = "";
		String hideQstList = "";
		int seeAll = 0;	
		int[] checkingArray = new int[2];
		checkingArray[0] = 0;
		checkingArray[1] = 0;
		int adminPrivilege = -1;
		String qstId = "";
		
		if(request.getParameter("qstId") != null){			
			qstId = request.getParameter("qstId");
		}
		
		logger.debug("CHECK QSTID: " + qstId);
		
		if (!qstId.equals("")) {
			logger.debug("Run here!");
			redirectAttributes.addAttribute("qstId", qstId);
			return "redirect:/ezPoll/pollVote.do";
		}
		
		List<Integer> listOfModifyingQst = new ArrayList<Integer>();
		ObjectMapper om = new ObjectMapper();
		
		if (loginVO.getRollInfo().indexOf("c=1") == -1 && loginVO.getRollInfo().indexOf("k=1") == -1) {
			//Normal user
			adminPrivilege = 0;
		}
		else {
			//Admin privilege user
			adminPrivilege = 1;
		}	
		
		if(request.getParameter("see") != null){
			seeAll = Integer.parseInt(request.getParameter("see"));
		}
		
		if(request.getParameter("hide") != null){
			hideQstList = request.getParameter("hide");
		}
		
		if(request.getParameter("search") != null){
			searchStr = request.getParameter("search");
		}
		
		if(request.getParameter("currPage") != null){
			currPage = Integer.parseInt(request.getParameter("currPage"));
		}
		
		if(request.getParameter("brdID") != null){
			brdID = request.getParameter("brdID");
		}		
		
		//Save hidden Questions to database
		if(!hideQstList.equals("")){
			saveHiddenQuestion(hideQstList, loginVO);
		}
		
		//Get List of Question for user
		Set<PollQuestionVO> setOfQuestions = new HashSet<PollQuestionVO>();
		//getAllQuestionForUser(loginVO, setOfQuestions, searchStr); comment to test
		ezPollService.getAllQuestionForUser(loginVO, setOfQuestions, searchStr);
		List<Integer> listHiddenQuestionIds = ezPollService.getHiddenQuestionIds(userID, loginVO.getTenantId());
		
		//Set Status for each question
		setStatusForQuestions(setOfQuestions, listHiddenQuestionIds, loginVO, checkingArray, seeAll);
		
		//Sort listQuestions by question id
		List<PollQuestionVO> listTotalQuestions = new ArrayList<PollQuestionVO>(setOfQuestions);
		
		Collections.sort(listTotalQuestions, (PollQuestionVO qst1, PollQuestionVO qst2) ->{
	        return Integer.valueOf(qst1.getQstId()).compareTo(qst2.getQstId());
		});
		
		int totalQuestions = listTotalQuestions.size();
		totalPages = (totalQuestions + pageSize - 1)/pageSize;
		
		if (totalPages == 0 || totalPages == 1){
			model.addAttribute("list", listTotalQuestions);
		}
		else {
			if(currPage < totalPages){				
				int startPoint = (currPage - 1)*pageSize;
				int endPoint = currPage*pageSize;
				List<PollQuestionVO> listRenderQuestions = listTotalQuestions.subList(startPoint, endPoint);	
				model.addAttribute("list", listRenderQuestions);
			}
			else{
				int startPoint = (currPage - 1)*pageSize;
				int endPoint = totalQuestions;
				List<PollQuestionVO> listRenderQuestions = listTotalQuestions.subList(startPoint, endPoint);
				model.addAttribute("list", listRenderQuestions);
			}			
		}	
		//Get list of modifying qst
		for (PollQuestionVO pollQstVO : listTotalQuestions) {
			if (pollQstVO.getIsMofifying() == 1) {
				try {
					String modifyingUser = ezPollService.getModifyingUser(loginVO.getTenantId(), pollQstVO.getQstId());
					if (!loginVO.getId().equals(modifyingUser)) {
						listOfModifyingQst.add(pollQstVO.getQstId());
					}
				}
				catch (Exception e) {
					e.printStackTrace();
				}				
			}
		}
		
		model.addAttribute("listOfModifyingQst", om.writeValueAsString(listOfModifyingQst));
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currPage", currPage);
		model.addAttribute("totalQuestions", totalQuestions);
		model.addAttribute("brdID", brdID);
		model.addAttribute("userID", loginVO.getId());
		model.addAttribute("tenantID", loginVO.getTenantId());
		model.addAttribute("strSearch", searchStr);		
		model.addAttribute("seeCheck", seeAll);
		model.addAttribute("deleteBttn", checkingArray[0]);
		model.addAttribute("hideBttn", checkingArray[1]);
		model.addAttribute("adminPrivilege", adminPrivilege);
		return "/ezPoll/questionList";
		
		//return "hello";
	}

	@RequestMapping(value="/ezPoll/pollComplete.do", method = RequestMethod.POST)
	public String qstComplete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, PollAnswerVO pollAnswerVO, PollQuestionVO pollQuestionVO, ModelMap model) throws Exception {		
		logger.debug("Question Complete is running!");	
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantID = loginVO.getTenantId();
		String userID = loginVO.getId();
		
		String numberOfOptions = req.getParameter("numberOfOptions");		
		String qstTitle = commonUtil.cleanValue(req.getParameter("qst_title"));
		//String qstContent = commonUtil.cleanValue(req.getParameter("hidContent"));
		String qstContent = req.getParameter("hidContent");		
		String filePath = req.getParameter("hidFilePath");
		int secretVote = Integer.parseInt(req.getParameter("hidSecreteVote"));
		String endDate = req.getParameter("hidEndDate");
		String startDate = req.getParameter("hidStartDate");
		int numberOfMultiSelect = Integer.parseInt(req.getParameter("multiSelectNumber"));
		String range = req.getParameter("RangeXMLStr");		
		int resultFirst = Integer.parseInt(req.getParameter("hidResultFirst"));
		String qstModifyInfo = req.getParameter("hidModifyInfo");
		logger.debug("Question Title: " + qstTitle + ", Question Content: " + qstContent + ", Multi-Select number: " + numberOfMultiSelect + ", SecretVote: " + secretVote + ", Number of Options: " + numberOfOptions + ", End Date: " + endDate +", Start Date: " + startDate);
		
		List<String> listOptions = new ArrayList<String>();
		for (int i = 1; i <= Integer.parseInt(numberOfOptions); i++){
			String option = req.getParameter("option" + Integer.toString(i));
			if (option != null && !option.equals("")){
				listOptions.add(option);
			}
		}
		for(String option : listOptions){
			logger.debug(option + "\n");
		}
		//logger.debug("BAONK____RangeXMLStr: " + range);
		
		//save Question
		pollQuestionVO.setTitle(qstTitle);
		
		if(qstContent != null && !qstContent.equals("")){
			pollQuestionVO.setContent(qstContent);
		}		
		
		if(filePath != null && !filePath.equals("")){
			pollQuestionVO.setFilePath(filePath);
		}	
		pollQuestionVO.setTenantId(tenantID);		
		
		if (range == null || range.equals("")) {
			pollQuestionVO.setTarget(0);			
		}
		else {
			pollQuestionVO.setTarget(1);
		}
		
		pollQuestionVO.setCreator(userID);
		pollQuestionVO.setCreatorName(loginVO.getDisplayName());
		pollQuestionVO.setEndDate(endDate);
		pollQuestionVO.setStartDate(startDate);
		pollQuestionVO.setSecretVote(secretVote);
		pollQuestionVO.setResultFirst(resultFirst);
		pollQuestionVO.setMultiSelect(numberOfMultiSelect);
		
		if (!qstModifyInfo.equals("")) {
			pollQuestionVO.setQstId(Integer.parseInt(qstModifyInfo));
			
			//delete all information related to question
			try {
				ezPollService.deleteQuestions(pollQuestionVO.getQstId(), loginVO.getTenantId());		
				ezPollService.deleteUserAndAnswer(pollQuestionVO.getQstId(), loginVO.getTenantId());		
				ezPollService.deleteQuestionRelated(pollQuestionVO.getQstId(), loginVO.getTenantId());	
				ezPollService.deleteAnswers(pollQuestionVO.getQstId(), loginVO.getTenantId());	
				ezPollService.deleteUserAndQuestion(pollQuestionVO.getQstId(), loginVO.getTenantId());
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
		else {
			int currentMaxQstID = 0;
			currentMaxQstID = getQuestionSeq(tenantID);		
			pollQuestionVO.setQstId(currentMaxQstID);
		}
		
		SaveQuestion(pollQuestionVO, range, loginVO);

		//save Answers
		pollAnswerVO.setQstId(pollQuestionVO.getQstId());
		pollAnswerVO.setTenantId(tenantID);
		pollAnswerVO.setVotesNumber(0);
		for (int i = 0; i < listOptions.size(); i++){
			pollAnswerVO.setContent(listOptions.get(i));
			pollAnswerVO.setAnsId(i + 1);
			ezPollService.insertOption(pollAnswerVO);
		}
		//List<LoginVO> list = loginService.selectAllReceivers(userID, tenantID);
		
		
		return "forward:/ezPoll/pollList.do";
	}
	
	@RequestMapping(value="/ezPoll/pollVote.do")
	public String qstVote(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, PollAnswerVO pollAnswerVO, PollQuestionVO pollQuestionVO, ModelMap model) throws Exception {
		logger.debug("Question Vote is running!");			
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantId = loginVO.getTenantId();
		int qstId =	Integer.parseInt(request.getParameter("qstId"));
		int totalUsers = 0;		
		int totalVotes = 0;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		int compareEnd = 0;
		int numberOfVotedUsers = 0;
		int totalSeenUsers = 0;
		String timeRemain = "";
		int numOfFile = 0;
		ObjectMapper om = new ObjectMapper();
		int adminPrivilege = -1;
		int numberOfCmt = -1;
		
		if (loginVO.getRollInfo().indexOf("c=1") == -1 && loginVO.getRollInfo().indexOf("k=1") == -1) {
			//Normal user
			adminPrivilege = 0;
		}
		else {
			//Admin privilege user
			adminPrivilege = 1;
		}
		
		// Get all related users for this question
		Set<LoginVO> setOfUserIds = new HashSet<LoginVO>();
		getAllUserForQuestion(loginVO, qstId, setOfUserIds);
		List<LoginVO> listofTotalUsers = new ArrayList<LoginVO>(setOfUserIds);
		totalUsers = listofTotalUsers.size();	
		
		//Check if user has the vote privilege
		if (listofTotalUsers.contains(loginVO)) {
			model.addAttribute("hasVotePrivilege", 1);
		}
		else {
			model.addAttribute("hasVotePrivilege", 0);
		}
		
		//Get all seen users
		List<String> listOfCurrentSeenUsers = ezPollService.getNumberOfSeenUsers(qstId, tenantId);
		totalSeenUsers = listOfCurrentSeenUsers.size();
		
		if(listofTotalUsers.contains(loginVO)){
			if (!listOfCurrentSeenUsers.contains(loginVO.getId())){
				//update Seen Number 
				PollQuestionStatusVO pollQstStatusVO = new PollQuestionStatusVO();
				pollQstStatusVO.setUserId(loginVO.getId());
				pollQstStatusVO.setTenantId(loginVO.getTenantId());
				pollQstStatusVO.setQustId(qstId);	
				ezPollService.insertSeenQuestion(pollQstStatusVO);
				totalSeenUsers = totalSeenUsers + 1;
				getUpdateSeenRequests(totalSeenUsers, qstId, loginVO.getTenantId());
			}
		}		
		
		//Get question
		pollQuestionVO = ezPollService.getQuestionByIdAndTenantId(qstId, tenantId);
		//endDate = formatter.parse(commonUtil.getDateStringInUTC(pollQuestionVO.getEndDate(), loginVO.getOffset(), false));
		Date endDate = formatter.parse(pollQuestionVO.getEndDate());
		Date nowTime = new Date();
		compareEnd = endDate.compareTo(nowTime);
		
		if (compareEnd > 0) {
			pollQuestionVO.setStatus(1);
			DateTime endDate_ = new DateTime(endDate);
			DateTime toDay_   = new DateTime(nowTime);
			int diffInDays  = Days.daysBetween(toDay_, endDate_).getDays();		
			
			if (diffInDays != 0) {
				timeRemain = Integer.toString(diffInDays) + "일 남았습니다.";				
			}
			else {
				int diffInHours  = endDate_.getHourOfDay() - toDay_.getHourOfDay();
				//logger.debug("Hours remain: " + diffInHours );
				if (diffInHours != 0) {
					timeRemain = Integer.toString(diffInHours) + "시 남았습니다.";
				}
				else {
					int diffInMinutes = endDate_.getMinuteOfHour() - toDay_.getMinuteOfHour();
					//logger.debug("Minutes remain: " + diffInMinutes );
					if (diffInMinutes != 0) {
						timeRemain = Integer.toString(diffInMinutes) + "분 남았습니다.";
					}
					else {
						int diffInSeconds = endDate_.getSecondOfMinute() - toDay_.getSecondOfMinute();
						//logger.debug("Seconds remain: " + diffInSeconds);
						timeRemain = Integer.toString(diffInSeconds) + "초 남았습니다.";
					}										
				}	
			}

		}else{
			pollQuestionVO.setStatus(0);
		}
		
		//Vote user and answer
		List<Integer> listSelectedOptionsOfUser = new ArrayList<Integer>();
		List<PollUserAnswerVO> listOfPollUserAndAnswer = ezPollService.getPollUserAndAnswer(qstId, tenantId);
		totalVotes = listOfPollUserAndAnswer.size();
		
		//Get list of Voted users
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

		String[] files = null;
		
		if(pollQuestionVO.getFilePath() != null){
			files = pollQuestionVO.getFilePath().split(";");
		}
		
		if(files != null && files.length != 0){			
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
		
		//Get list of Options		
		List<PollAnswerVO> listOptions = ezPollService.getListOptionsOfQst(qstId, tenantId);	
		
		//Sort list of Options by votes
		Collections.sort(listOptions, (PollAnswerVO answer1, PollAnswerVO answer2) ->{
	        return Integer.valueOf(answer2.getVotesNumber()).compareTo(answer1.getVotesNumber());
		});
		
		//Get list of comments for question
		List<PollCommentVO> listComments = ezPollService.getListCmtOfQst(qstId, tenantId);
		//Sort list of comments
		Collections.sort(listComments, (PollCommentVO cmt1, PollCommentVO cmt2) ->{
	        return Integer.valueOf(cmt1.getCmtId()).compareTo(cmt2.getCmtId());
		});
		
		if (listComments.isEmpty()) {
			numberOfCmt = 0;
		}
		else {
			numberOfCmt = listComments.get((listComments.size() - 1)).getCmtId();
		}		
		
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
		model.addAttribute("numberOfUnvotedUsers", totalUsers - numberOfVotedUsers);
		model.addAttribute("question", pollQuestionVO);
		model.addAttribute("curentUser", loginVO.getId());
		model.addAttribute("curentUserName", loginVO.getDisplayName());
		logger.debug("Question Vote finishes!");
		return "/ezPoll/questionVote";
	}		
	
	public void getUpdateSeenRequests(int totalSeenUpdated, int qstId, int tenantId) throws Exception{	
		String result = "{\"updatedNumber\":\"" + Integer.toString(totalSeenUpdated) + "\"}";
		JSONParser parser = new JSONParser(); 
		JSONObject json = (JSONObject) parser.parse(result);
		this.template.convertAndSend("/reply/getSeenUpdateForQst" + qstId + "+" + tenantId, json); 
		//this.template.convertAndSend("/reply/getSeenUpdate", new Message(Integer.toString(totalSeenUpdated))); 	
	}
	
	@RequestMapping(value="/ezPoll/downloadAttach.do")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginSimpleVO loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String folderPath = request.getParameter("folderPath");
		String fileName = request.getParameter("filename");
		File file = null;
		
		if (folderPath == null || fileName == null) {
			logger.debug("downloadAttach illegal arguments.");
			return;
		}
		
        // get absolute path of the application       
        String realPath = request.getServletContext().getRealPath("");
        String pDirPath = commonUtil.getUploadPath("upload_schedule.ROOT", loginSimpleVO.getTenantId());
        pDirPath = realPath + pDirPath;
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
       
        String fullPath = pDirPath + "uploadFile" + commonUtil.separator + folderPath;    
        file = new File(fullPath);
		if (file == null || !file.exists()) {
			fullPath = realPath + folderPath;
			file = new File(fullPath);
			if (file == null || !file.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
				return;
			}				
		}
		FileInputStream inputStream = null;
		OutputStream outStream = null;
		try {
			inputStream = new FileInputStream(file);
	        
	        // get MIME type of the file
	        String mimeType = request.getServletContext().getMimeType(fullPath);
	        if (mimeType == null) {
	            // set to binary type if MIME mapping not found
	            mimeType = "application/octet-stream";
	        }
	        logger.debug("MIME type: " + mimeType);	 
	        	
	        fileName = URLEncoder.encode(fileName, "UTF-8");
	        fileName = fileName.replace("+", " ");	        
	        String browserType = request.getHeader("User-Agent");
	        
	        // set content attributes and header for the response
	        response.setContentType(mimeType);
	        response.setContentLength((int) file.length());
	        response.setCharacterEncoding("UTF-8");       	    	        
	                             
	        if (browserType.contains("Firefox")) {	
	        	fileName = fileName.replace(" ", "%20");	
	            response.setHeader("Content-Disposition","attachment; filename*=UTF-8''" + fileName );
	        }  
	        else {
	        	response.setHeader("Content-Disposition","attachment; filename=" + "'" + fileName + "'");
	        }

	        // get output stream of the response
	        outStream = response.getOutputStream();
	 
	        byte[] buffer = new byte[4096];
	        int bytesRead = -1;
	 
	        // write bytes read from the input stream into the output stream
	        while ((bytesRead = inputStream.read(buffer)) != -1) {
	            outStream.write(buffer, 0, bytesRead);
	        }
	 
	        inputStream.close();
	        outStream.close();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		finally {
			if (inputStream != null) {
				try { inputStream.close(); } catch (IOException e1) {}
			}
			if (outStream != null) {
				try { outStream.flush(); } catch (IOException e1) {}
				try { outStream.close(); } catch (IOException e1) {}
			}
		}     
	}
	
	@RequestMapping(value="/ezPoll/confirmDeleteQuestion.do")
	public String confirmDeleteQuestion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, PollQuestionVO pollQuestionVO, ModelMap model) throws Exception {
		logger.debug("Confirm Delete Question is running!");				
		String listQstIds = "";
		String listQstContent = "";
		List<String> listQuestionIDs = new ArrayList<String>();
		List<String> listQuestionContents = new ArrayList<String>();
		
		if(request.getParameter("listQst") != null){
			listQstIds = request.getParameter("listQst");
		}
		
		if(request.getParameter("listQstContent") != null){
			listQstContent = request.getParameter("listQstContent");
		}
		String [] questionIDs = listQstIds.split(",");
		String [] questionContents = listQstContent.split(",");		
		
		for (int i = 0; i < questionIDs.length; i++) {
			listQuestionIDs.add(questionIDs[i]);
			listQuestionContents.add(questionContents[i]);
		}
		
		model.addAttribute("listQuestionIDs", listQuestionIDs);
		model.addAttribute("listQuestionContents", listQuestionContents);
		model.addAttribute("numberOfQst", listQuestionIDs.size());
		model.addAttribute("listQstIds", listQstIds);

		logger.debug("Confirm Delete Question end!");
		return "/ezPoll/confirmDeleteQst";
	}	
	
	@RequestMapping(value="/ezPoll/addComment.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addComment(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String strXML = "";
		String cmtTime = "";
		String attachFilePath = "";
		String fileName = "";
		String filePath = "";
		String txtContent = "";
		String fileType = "";		
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
		
		if (qstId == -1 || cmtId == -1 || cmtTime.equals("") ) {
			strXML = "<DATA>FAIL</DATA>";
			return strXML;
		}
		
		PollCommentVO pollCmtVO = new PollCommentVO();
		pollCmtVO.setCmtId(cmtId); // Need to test here
		pollCmtVO.setQstId(qstId);		
		pollCmtVO.setTenantId(loginVO.getTenantId());
		pollCmtVO.setUserId(loginVO.getId());		
		pollCmtVO.setCmtTime(cmtTime);		
		pollCmtVO.setTextContent(txtContent);
		logger.debug("File Type = " + fileType);
		
		if (fileType.equals("sticker")) {	
			attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/images/"));
			pollCmtVO.setImageAttach(attachFilePath);
			pollCmtVO.setFileAttach("");
			pollCmtVO.setFileName("");
			pollCmtVO.setFilePath("");			
		}
		else if (fileType.equals("file")) {
			pollCmtVO.setImageAttach("");			
			if (fileName.equals("")){
				attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/files/"));
				pollCmtVO.setFileAttach(attachFilePath);
				pollCmtVO.setFileName("");
				pollCmtVO.setFilePath("");
			}
			else {
				attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/images/"));
				pollCmtVO.setFileAttach(attachFilePath);
				pollCmtVO.setFileName(fileName);
				pollCmtVO.setFilePath(filePath);
			}		
		}
		else {
			pollCmtVO.setImageAttach("");
			pollCmtVO.setFileAttach("");
			pollCmtVO.setFileName("");
			pollCmtVO.setFilePath("");
		}
		
		//Save comment to database 
		try {
			//Insert into comment table
			ezPollService.insertCmt(pollCmtVO);
			
			//Inform all waiting users
			String result = "{\"cmId\":\"" + cmtId  + "\", \"userId\":\"" + loginVO.getId() + "\", \"attachFilePath\":\"" + attachFilePath+ "\""
					+ ", \"fileType\":\"" + fileType + "\", \"fileName\":\"" + fileName + "\", \"filePath\":\"" + filePath + "\", \"txtContent\":\"" + txtContent + "\","
					+ " \"cmtTime\":\"" + cmtTime + "\"}";
			JSONParser parser = new JSONParser(); 
			JSONObject json = (JSONObject) parser.parse(result);
			this.template.convertAndSend("/reply/addCmtForQst" + qstId + "+" + loginVO.getTenantId(), json);
			
			//Update comment user in question related table
			strXML = "<DATA>OK</DATA>";
		}
		catch (Exception e) {			
			e.printStackTrace();
			strXML = "<DATA>FAIL</DATA>";
		}
		return strXML;
	}
	
	@RequestMapping(value="/ezPoll/editComment.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String editComment(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String strXML = "";		
		String attachFilePath = "";
		String fileName = "";
		String filePath = "";
		String txtContent = "";
		String fileType = "";		
		int cmtId = -1;		
		int qstId = -1;
		
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
		
		if (qstId == -1 || cmtId == -1) {
			strXML = "<DATA>FAIL</DATA>";
			return strXML;
		}
		
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
		}
		else if (fileType.equals("file")) {
			pollCmtVO.setImageAttach("");			
			if (fileName.equals("")){				
				attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/files/"));
				pollCmtVO.setFileAttach(attachFilePath);
				pollCmtVO.setFileName("");
				pollCmtVO.setFilePath("");
			}
			else {
				attachFilePath = attachFilePath.substring(attachFilePath.indexOf("/images/"));
				pollCmtVO.setFileAttach(attachFilePath);
				pollCmtVO.setFileName(fileName);
				pollCmtVO.setFilePath(filePath);
			}		
		}
		else {
			pollCmtVO.setImageAttach("");
			pollCmtVO.setFileAttach("");
			pollCmtVO.setFileName("");
			pollCmtVO.setFilePath("");
		}
		
		//Update comment in database 
		try {
			//Update in comment table
			ezPollService.updateCmt(pollCmtVO);
			
			//Inform all waiting users
			String result = "{\"cmId\":\"" + cmtId  + "\", \"userId\":\"" + loginVO.getId() + "\", \"attachFilePath\":\"" + attachFilePath+ "\""
					+ ", \"fileType\":\"" + fileType + "\", \"fileName\":\"" + fileName + "\", \"filePath\":\"" + filePath + "\", \"txtContent\":\"" + txtContent + "\"}";
			JSONParser parser = new JSONParser(); 
			JSONObject json = (JSONObject) parser.parse(result);
			this.template.convertAndSend("/reply/editCmtForQst" + qstId + "+" + loginVO.getTenantId(), json);
			
			//Update comment user in question related table
			strXML = "<DATA>OK</DATA>";
		}
		catch (Exception e) {			
			e.printStackTrace();
			strXML = "<DATA>FAIL</DATA>";
		}
		
		return strXML;
	}
	
	@RequestMapping(value="/ezPoll/deleteComment.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteComment(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
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
		
		//Delete comment in database 
		try {
			//Insert into comment table
			ezPollService.deleteSpecificCmt(cmtId, qstId, loginVO.getTenantId());
			
			//Inform all waiting users
			String result = "{\"cmId\":\"" + cmtId  + "\", \"userId\":\"" + loginVO.getId() + "\"}";
			JSONParser parser = new JSONParser(); 
			JSONObject json = (JSONObject) parser.parse(result);
			this.template.convertAndSend("/reply/deleteCmtInQst" + qstId + "+" + loginVO.getTenantId(), json);
			
			//Update comment user in question related table
			strXML = "<DATA>OK</DATA>";
		}
		catch (Exception e) {			
			e.printStackTrace();
			strXML = "<DATA>FAIL</DATA>";
		}
		
		return strXML;
	}	
	
	@RequestMapping(value="/ezPoll/undoModifyVote.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String undoModifyVote(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String strXML = "";
		int qstId = -1;
		if (request.getParameter("questionId") != null) {
			qstId = Integer.parseInt(request.getParameter("questionId"));
		}
		
		if (qstId == -1) {
			strXML = "<DATA>FAIL</DATA>";
			return strXML;
		}
		
		//Update current vote modifying status
		try {
			ezPollService.updateModifyingQuestion(qstId, loginVO.getTenantId(), 0);
			// Get all related users for this question
			Set<LoginVO> setOfUserIds = new HashSet<LoginVO>();
			getAllUserForQuestion(loginVO, qstId, setOfUserIds);
			List<LoginVO> listofTotalUsers = new ArrayList<LoginVO>(setOfUserIds);
			PollQuestionStatusVO pollQstStatusVO = new PollQuestionStatusVO();
			pollQstStatusVO.setUserId(loginVO.getId());
			pollQstStatusVO.setTenantId(loginVO.getTenantId());
			pollQstStatusVO.setQustId(qstId);
			if (listofTotalUsers.contains(loginVO)) {
				ezPollService.updateModifyingQuestionRelatedStatus(pollQstStatusVO);
			}
			else {
				ezPollService.deleteModifyingQuestionRelatedStatus(pollQstStatusVO);
			}
			strXML = "<DATA>OK</DATA>";
		} 
		catch (Exception e) {
			strXML = "<DATA>FAIL</DATA>";
			e.printStackTrace();
		}
		
		return strXML;
	}
	
	@RequestMapping(value="/ezPoll/deleteQuestion.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteQuestion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, PollQuestionVO pollQuestionVO, ModelMap model) throws Exception {
		logger.debug("Delete Question is running!");			
		LoginVO loginVO = commonUtil.userInfo(loginCookie);					
		String listQstIds = "";
		String strXML = "";
		
		if(request.getParameter("listQst") != null){
			listQstIds = request.getParameter("listQst");
		}		
		
		strXML = questionDelete(listQstIds, loginVO);		

		logger.debug("Delete Question finishes!");		
		return strXML;
		//return "forward:/ezPoll/pollList.do";
	}
	
	@RequestMapping(value = "/ezPoll/uploadCmtFile.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadCmtFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception{
		logger.debug("------------------- uploadCommentFile start ----------------");
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload");
		
		String realPath = request.getServletContext().getRealPath("");
		String pFileName = "";
        Long fileSize = 0L;        
        //String resultUpload = "";
        String sGUID = "";
        String pUploadSN = "";      
               
        //resultUpload = "false";
        sGUID = UUID.randomUUID().toString();
        pUploadSN = "{" + sGUID + "}";
       
        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {        	      
            String _pFileName = multiFile.get(0).getOriginalFilename();
            if (_pFileName.indexOf(commonUtil.separator) > 0) {
                _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
            }
           pFileName = _pFileName;           
        }       
        
        pFileName = pFileName.replace("+", "%2b");
        pFileName = pFileName.replace(";", "%3b");       
        
        String extension = pFileName.substring(pFileName.lastIndexOf(".") + 1);
        if (extension.toLowerCase().equals("jpg") || extension.toLowerCase().equals("png") || extension.toLowerCase().equals("bmp")) {
    		String pDirPath = commonUtil.separator + "files" + commonUtil.separator + "commentImages" + commonUtil.separator;
    		pDirPath = realPath + pDirPath;
            File file = new File(pDirPath);
            
            if (!file.exists()) {
            	file.mkdir();        
            }
            
            String newFileName = pUploadSN + "." + extension;  
            fileSize = multiFile.get(0).getSize();
            StringBuffer strXML = new StringBuffer();
            strXML.append("<ROOT><NODES>");
            writeUploadedFile(multiFile.get(0), newFileName, pDirPath);
			strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName + "/" + fileSize + "]]></DATA>");
			strXML.append("<DATA2><![CDATA[]]></DATA2>");
			strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
			strXML.append("</NODES></ROOT>");
			return strXML.toString();
        }        	
        else {
        	return "ERROR";
        }     
	}
	
	@RequestMapping(value = "/ezPoll/uploadFile.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception{
		
		logger.debug("============ uploadFile started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload"); 
		int cnt = multiFile.size();
		
		String realPath = request.getServletContext().getRealPath("");
		String[] pFileName = new String[cnt];
        Long[] fileSize = new Long[cnt];        
        String[] resultUpload = new String[cnt];
        String[] sGUID = new String[cnt];
        String[] pUploadSN = new String[cnt];
        
        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", loginSimpleVO.getTenantId());

        for (int i = 0; i < cnt; i++) {
            resultUpload[i] = "false";
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

        for (int i = 0; i < cnt; i++) {
            pFileName[i] = pFileName[i].replace("+", "%2b");
            pFileName[i] = pFileName[i].replace(";", "%3b");
        }           
        
        String pDirPath = commonUtil.getUploadPath("upload_schedule.ROOT", loginSimpleVO.getTenantId());

        pDirPath = realPath + pDirPath;
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        
        File file = new File(pDirPath + "uploadFile");

        if (!file.exists()) {
        	file.mkdir();        
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {        	
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            String newFileName = pUploadSN[i] + "." + extend;
            
            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1 && !useExtension.equals("*")) {           	
				strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[]]></DATA2>");
				strXML.append("<DATA3><![CDATA[denied]]></DATA3>");
            } else {
				writeUploadedFile(multiFile.get(i), newFileName, pDirPath + "uploadFile");
				strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[]]></DATA2>");
				strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
            }
        }
        strXML.append("</NODES></ROOT>");
        //logger.debug("BAONK_DEBUG StrXML:" + strXML.toString());
        logger.debug("============ uploadFile ended ============");
        
        return strXML.toString();
    }
	
	@RequestMapping(value="/ezPoll/adjustJoinedUsers.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String adjustJoinedUsersNumber(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req) throws Exception {
		logger.debug("Adjust Joined Users is running!");			
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
		if (flag.equals("1")){
			//Get String of time now
			Date date = new Date();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			String dateNow = formatter.format(date);
			
			//Get all of users who voted
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
				String result = "{\"result\":\"ADD\"}";		
				JSONParser parser = new JSONParser(); 
				JSONObject json = (JSONObject) parser.parse(result);
				this.template.convertAndSend("/reply/updateUnVotedUsersForQst" + qstId + "+" + loginVO.getTenantId(), json);
			}
			
			//Add entry
			PollUserAnswerVO pollUserAnswer = new PollUserAnswerVO();
			pollUserAnswer.setAnsId(optId);
			pollUserAnswer.setQstId(qstId);
			pollUserAnswer.setUserId(loginVO.getId());
			pollUserAnswer.setTenantId(loginVO.getTenantId());
			pollUserAnswer.setUserName(loginVO.getDisplayName());
			pollUserAnswer.setVoteDate(dateNow);
			strXML = addUserAndAnswer(pollUserAnswer);		
		}
		else {						
			//Delete entry
			PollUserAnswerVO pollUserAnswer = new PollUserAnswerVO();
			pollUserAnswer.setAnsId(optId);
			pollUserAnswer.setQstId(qstId);
			pollUserAnswer.setUserId(loginVO.getId());
			pollUserAnswer.setTenantId(loginVO.getTenantId());
			pollUserAnswer.setUserName(loginVO.getDisplayName());
			strXML = removeUserAndAnswer(pollUserAnswer);
			
			//Get all of users who voted
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
				String result = "{\"result\":\"REMOVE\"}";		
				JSONParser parser = new JSONParser(); 
				JSONObject json = (JSONObject) parser.parse(result);
				this.template.convertAndSend("/reply/updateUnVotedUsersForQst" + qstId + "+" + loginVO.getTenantId(), json);
			}
			
		}
		
		logger.debug("Adjust Joined Users is ended!");	
		return strXML;
	}
	
	@RequestMapping(value="/ezPoll/deleteCmtFile.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteCmtFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, LoginSimpleVO loginSimpleVO) throws Exception {
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String fileName = "";
		String strXML = "";
		if (req.getParameter("fileToDelete") != null) {
			fileName = req.getParameter("fileToDelete").split("/")[0];
		}
		
		String realPath = req.getServletContext().getRealPath("");
		String pDirPath = commonUtil.separator + "files" + commonUtil.separator + "commentImages" + commonUtil.separator;
		String absoluteFilePath = realPath + pDirPath +  fileName;
		
		try {
			File file = new File(absoluteFilePath);
			if(!file.exists()){
				logger.debug("Wrong folder path!");
				return "<DATA>DELETE_FAIL</DATA>";
			}
			file.delete();	
			strXML = "<DATA>DELETE_OK</DATA>";
		}
		catch (Exception e) {
			strXML = "<DATA>DELETE_FAIL</DATA>";
	         e.printStackTrace();
	      }
		return strXML;
	}

	@RequestMapping(value="/ezPoll/deleteFile.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, LoginSimpleVO loginSimpleVO) throws Exception {
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String fileName = "";
		String strXML = "";
		
		if (req.getParameter("fileToDelete") != null) {
			fileName = req.getParameter("fileToDelete").split("/")[0];
		}		
		
		String realPath = req.getServletContext().getRealPath("");
		String pDirPath = commonUtil.getUploadPath("upload_schedule.ROOT", loginSimpleVO.getTenantId());
		pDirPath = realPath + pDirPath;
		
		if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
		String absoluteFilePath = pDirPath + "uploadFile/" + fileName;
		
		try {
			File file = new File(absoluteFilePath);
			if(!file.exists()){
				logger.debug("Wrong folder path!");
				return "<DATA>DELETE_FAIL</DATA>";
			}
			file.delete();	
			strXML = "<DATA>DELETE_OK</DATA>";
		}
		catch (Exception e) {
			strXML = "<DATA>DELETE_FAIL</DATA>";
	         e.printStackTrace();
	      }
		return strXML;
	}
			
	@RequestMapping(value = "/ezPoll/showVotedUsersInfo.do")
	public String showVotedUsersInfo(@CookieValue("loginCookie")String loginCookie, Locale locale,HttpServletRequest request, ModelMap model) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantId = loginVO.getTenantId();
		int qstId = -1;
		int optId = -1;
		//int numberOfVotedUsers = 0;
		int totalVotes = 0;
		int totalVotesForOption = 0;
		String content = "";
		
		if (request.getParameter("qstId") != null && request.getParameter("optId") != null) {
			qstId =	Integer.parseInt(request.getParameter("qstId"));
			optId =	Integer.parseInt(request.getParameter("optId"));
		}
		
		logger.debug("Value of qstId: " + qstId + ", option id: " + optId);
		
		//Vote user and answer		
		List<PollUserAnswerVO> listOfPollUserAndAnswer = ezPollService.getPollUserAndAnswer(qstId, tenantId);	
		List<PollUserAnswerVO> listOfVotedUsersForAnswer = ezPollService.getListVotedUsersForAnswer(optId, qstId, tenantId);
		PollAnswerVO pollAnswer = ezPollService.getAnswerByIdAndQstId(optId, qstId, tenantId);
		totalVotes = listOfPollUserAndAnswer.size();
		totalVotesForOption = listOfVotedUsersForAnswer.size();
		content = pollAnswer.getContent();

		model.addAttribute("totalVotes", totalVotes);
		model.addAttribute("totalVotesForOption", totalVotesForOption);
		model.addAttribute("content", content);
		model.addAttribute("listOfVotedUsers", listOfVotedUsersForAnswer);
		return "/ezPoll/showVotedUsers";
	}
	
	@RequestMapping(value = "/ezPoll/showUnJoinedUsersInfo.do")
	public String showUnJoinedUsersInfo(@CookieValue("loginCookie")String loginCookie, Locale locale,HttpServletRequest request, ModelMap model) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantId = loginVO.getTenantId();
		int qstId = -1;
		int numberOfUnVotedUsers = 0;
		
		if (request.getParameter("qstId") != null) {
			qstId =	Integer.parseInt(request.getParameter("qstId"));			
		}
		
		//Get all of users for questions
		Set<LoginVO> setOfUserIds = new HashSet<LoginVO>();
		getAllUserForQuestion(loginVO, qstId, setOfUserIds);
		List<LoginVO> listOfUnvotedUsers = new ArrayList<LoginVO>(setOfUserIds);		
		
		//Get all of users who voted
		List<PollUserAnswerVO> listOfPollUserAndAnswer = ezPollService.getPollUserAndAnswer(qstId, tenantId);
		
		//Get list of Voted users
		List<String> listOfAnsweredUsers = new ArrayList<String>();
		
		for (PollUserAnswerVO pollUserAndAnswer : listOfPollUserAndAnswer) {
			if (!listOfAnsweredUsers.contains(pollUserAndAnswer.getUserId())) {
				listOfAnsweredUsers.add(pollUserAndAnswer.getUserId());
			}
		}		
		
		Iterator<LoginVO> iterator = listOfUnvotedUsers.iterator();
		while(iterator.hasNext()){
			LoginVO user = iterator.next();
			if (listOfAnsweredUsers.contains(user.getId())) {
				iterator.remove();	
			}					
		}
		
		listOfUnvotedUsers.removeAll(listOfAnsweredUsers);
		numberOfUnVotedUsers = listOfUnvotedUsers.size();
		
		model.addAttribute("numberOfUnVotedUsers", numberOfUnVotedUsers);
		model.addAttribute("listOfUnvotedUsers", listOfUnvotedUsers);
		return "/ezPoll/showNotJoinedUsers";
	}
	
	@MessageMapping("/editVote") 
	public void editVote(JSONObject message) throws org.json.simple.parser.ParseException {
		logger.debug("Runing in EDIT VOTE !");		
		int qstId = Integer.parseInt((String) message.get("question"));
		int tenantId = Integer.parseInt((String)message.get("tenant"));		
		String userId = (String)message.get("user");
		
		logger.debug("Question id is: " + qstId +", TenantId: " + tenantId + ", UserId: " + userId);	
		
		//Update current vote modifying status
		try {
			ezPollService.updateModifyingQuestion(qstId, tenantId, 1);
			PollQuestionStatusVO pollQstStatusVO = new PollQuestionStatusVO();
			pollQstStatusVO.setUserId(userId);
			pollQstStatusVO.setTenantId(tenantId);
			pollQstStatusVO.setQustId(qstId);
			ezPollService.insertModifyingQuestion(pollQstStatusVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//Inform all waiting users
		String result = "{\"result\":\"CHANGED\", \"userId\":\"" + userId + "\"}";
		JSONParser parser = new JSONParser(); 
		JSONObject json = (JSONObject) parser.parse(result);
		this.template.convertAndSend("/reply/editQst" + qstId + "+" + tenantId, json);
	}
		
	@MessageMapping("/finish")
	public void finishVote(JSONObject message) throws org.json.simple.parser.ParseException {
		logger.debug("message is: " + message);		
		int qstId = Integer.parseInt((String) message.get("question"));
		int tenantId = Integer.parseInt((String)message.get("tenant"));
		logger.debug("Question id is: " + qstId +", TenantId: " + tenantId);	
		
		//Close the vote by update the end date		
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String dateNow = formatter.format(date);
		
		try {
			ezPollService.updateEndDateForQst(qstId, tenantId, dateNow);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//Write result to inform all joining users
		String result = "{\"result\":\"OK\"}";		
		JSONParser parser = new JSONParser(); 
		JSONObject json = (JSONObject) parser.parse(result);
		this.template.convertAndSend("/reply/finishVoteForQst" + qstId + "+" + tenantId, json);
	}
	
	@RequestMapping(value = "/ezPoll/showSeenUserInfo.do")
	public String showSeenUsersInfo(@CookieValue("loginCookie")String loginCookie, Locale locale,HttpServletRequest request, ModelMap model) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantId = loginVO.getTenantId();
		int qstId =	Integer.parseInt(request.getParameter("qstId"));
	
		// Get all related users for this question
		Set<LoginVO> setOfUserIds = new HashSet<LoginVO>();
		getAllUserForQuestion(loginVO, qstId, setOfUserIds);

		List<LoginVO> listofUnseenUsers = new ArrayList<LoginVO>(setOfUserIds);
		List<LoginVO> listofSeenUsers = new ArrayList<LoginVO>();
		
		//Get all of seenUser
		List<String> listOfSeenUsers = ezPollService.getNumberOfSeenUsers(qstId, tenantId);
		
		for(String _userID : listOfSeenUsers){
			LoginVO user = loginService.selectReceiver(_userID, tenantId);
			listofSeenUsers.add(user);
		}
		
		int numberOfSeenUsers = listofSeenUsers.size();
		listofUnseenUsers.removeAll(listofSeenUsers);
		int numberOfUnseenUsers = listofUnseenUsers.size();
		
		model.addAttribute("listOfSeenUsers", listofSeenUsers);
		model.addAttribute("listOfUnSeenUsers", listofUnseenUsers);
		model.addAttribute("numberOfSeenUsers", numberOfSeenUsers);
		model.addAttribute("numberOfUnseenUsers", numberOfUnseenUsers);
		return "/ezPoll/showSeenUserInfo";
	}
		
	private String addUserAndAnswer(PollUserAnswerVO pollUserAnswer) {
		String strXML = "";
		try {
			ezPollService.addAnswerAndUser(pollUserAnswer);
			ezPollService.updateNumberOfVotesForAnswer(pollUserAnswer, 1);
			getUpdateVotes(pollUserAnswer.getAnsId(), pollUserAnswer.getQstId(), pollUserAnswer.getUserId(), pollUserAnswer.getUserName(), 1, pollUserAnswer.getTenantId());
			strXML = "<RESULT>ADD_OK</RESULT>";
		}
		catch (Exception e){
			strXML = "<RESULT>ADD_FAIL</RESULT>";
			e.printStackTrace();
		}
		return strXML;
	}
	
	private String removeUserAndAnswer(PollUserAnswerVO pollUserAnswer) {
		String strXML = "";
		try {
			ezPollService.removeAnswerAndUser(pollUserAnswer);	
			ezPollService.updateNumberOfVotesForAnswer(pollUserAnswer, -1);
			getUpdateVotes(pollUserAnswer.getAnsId(), pollUserAnswer.getQstId(), pollUserAnswer.getUserId(), pollUserAnswer.getUserName(), 0, pollUserAnswer.getTenantId());
			strXML = "<RESULT>REMOVE_OK</RESULT>";
		}
		catch (Exception e){
			strXML = "<RESULT>REMOVE_FAIL</RESULT>";
			e.printStackTrace();
		}
		return strXML;
	}
	
	public void getUpdateVotes(int optId, int qstId, String userId, String userName, int mode, int tenantId) throws Exception{	
		String result = "{\"optionId\":\"" + Integer.toString(optId) + "\", \"mode\":\"" + Integer.toString(mode) + "\", \"userId\":\"" + userId + "\",\"userName\":\"" + userName + "\"}";
		JSONParser parser = new JSONParser(); 
		JSONObject json = (JSONObject) parser.parse(result);
		this.template.convertAndSend("/reply/getResultUpdateForQst" + qstId + "+" + tenantId, json); 
	}
	
	public int getQuestionSeq(int tenantID) throws Exception {
		logger.debug("getQuestionSeq started");
		
		int currentMaxQstID = -1;		
		
		if (ezPollService.getQuestionSeq(tenantID).equals("")) {
			currentMaxQstID = 1;
		} else {
			currentMaxQstID = Integer.parseInt(ezPollService.getQuestionSeq(tenantID).toString());			
		}
		
		if (currentMaxQstID == -1) {
			currentMaxQstID = 1;
		}
		else {
			currentMaxQstID += 1;
		}
		logger.debug("getQuestionSeq ended");
		return currentMaxQstID;
	}	
	
	public String SaveQuestion(PollQuestionVO pollQuestionVO, String StrXmlRange, LoginVO loginVO) throws Exception {
		logger.debug("SaveQuestion Start");		
		ezPollService.insertQuestion(pollQuestionVO);

		if (pollQuestionVO.getTarget() == 0) {	
			pollQuestionVO.setReceiverType("company");
			pollQuestionVO.setUserId(loginVO.getCompanyID());
			//ezPollService.insertQuestion(pollQuestionVO);
			ezPollService.insertQustReceivers(pollQuestionVO);
			//deptID = loginVO.getCompanyID();
		}
		else {	
			Document doc = commonUtil.convertStringToDocument(StrXmlRange);
			int pDeptCnt = doc.getElementsByTagName("DEPT").item(0).getChildNodes().getLength();	
			
			for (int j = 0; j < pDeptCnt; j++) {
				String deptID = doc.getElementsByTagName("DEPT").item(0).getChildNodes().item(j).getAttributes().getNamedItem("id").getTextContent();
				pollQuestionVO.setUserId(deptID);
				pollQuestionVO.setReceiverType("dept");
				ezPollService.insertQustReceivers(pollQuestionVO);
			}	
		
			int pUserCnt = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().getLength();
			
			for (int i = 0; i < pUserCnt; i++) {
				String userID = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("id").getTextContent();
				pollQuestionVO.setUserId(userID);
				pollQuestionVO.setReceiverType("user");
				ezPollService.insertQustReceivers(pollQuestionVO);
			}
		}
		
		logger.debug("SaveQuestion End");
		return "OK";
	}

	private void getAllMemberOfDept(List<LoginVO> list, String deptId, int tenantID) throws Exception{		
		List<LoginVO> list1 = loginService.selectAllReceivers(deptId, tenantID);
		
		if (list1 != null && list1.size() > 0) {
			list.addAll(list1);
		}		
		//Get all member of subDept
		List<String> subDeptIdList = ezOrganService.getAllSubDeptId(deptId, tenantID);
		
		if (subDeptIdList != null && subDeptIdList.size() > 0) {
			for (String subDeptId : subDeptIdList){				
				getAllMemberOfDept(list, subDeptId, tenantID);
			}
		}		
	}
	
/*	private void getAllQuestionForUser(LoginVO loginvo, Set<PollQuestionVO> set, String searchStr) throws Exception {
		List<PollQuestionVO> listOfQuestion = new ArrayList<PollQuestionVO>();
		int tenantID = loginvo.getTenantId();
		//Check if user has admin privilege
		if (loginvo.getRollInfo().indexOf("c=1") == -1 && loginvo.getRollInfo().indexOf("k=1") == -1) {
			//Normal user
			String companyID = loginvo.getCompanyID();
			String deptID = loginvo.getDeptID();
			String userID = loginvo.getId();
			
			try {
				String depPath = ezOrganService.getDeptPath(deptID, tenantID);
				listOfQuestion = ezPollService.getQuestionsTest(userID, depPath, companyID, tenantID, searchStr);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			set.addAll(listOfQuestion);
			
			//Get all question that this user is creator
			List<PollQuestionVO> listOfQuestion2 = new ArrayList<PollQuestionVO>();
			listOfQuestion2 = ezPollService.getOwnQuestions(userID, tenantID, searchStr);		
			set.addAll(listOfQuestion2);
		}
		else {
			//Get all question for admin privilege user
			try {
				listOfQuestion = ezPollService.getAllQuestions(tenantID, searchStr);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			set.addAll(listOfQuestion);
		}	
	}*/

	private void setStatusForQuestions(Set<PollQuestionVO> setOfQuestions, List<Integer> listHiddenQuestionIds, LoginVO loginVO, int[] checkingArray, int seeAll) throws ParseException{
		String userID = loginVO.getId();
		//String userID = "abc1";
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		Date endDate;
		Date sysDate = new Date();
		int compareEnd;
		if(seeAll == 1){
			for(PollQuestionVO pollQstVO: setOfQuestions){
				if (listHiddenQuestionIds.contains(pollQstVO.getQstId())){
					pollQstVO.setIsHidden(1);
				}
				else{
					pollQstVO.setIsHidden(0);
				}			
				//endDate = formatter.parse(commonUtil.getDateStringInUTC(pollQstVO.getEndDate(), loginVO.getOffset(), false));
				endDate = formatter.parse(pollQstVO.getEndDate());
				compareEnd = endDate.compareTo(sysDate);
				if(compareEnd > 0){
					pollQstVO.setStatus(1);
				}else{
					pollQstVO.setStatus(0);
				}
				//Checking Array
				if(userID.equals(pollQstVO.getCreator())){
					checkingArray[0] = 1;
				}
				else{
					checkingArray[1] = 1;
				}
			}
		}
		else{
			Iterator<PollQuestionVO> iterator = setOfQuestions.iterator();
			while(iterator.hasNext()){
				PollQuestionVO pollQstVO = iterator.next();
				if (listHiddenQuestionIds.contains(pollQstVO.getQstId())){
					iterator.remove();				
				}
				else {
					//endDate = formatter.parse(commonUtil.getDateStringInUTC(pollQstVO.getEndDate(), loginVO.getOffset(), false));
					endDate = formatter.parse(pollQstVO.getEndDate());
					compareEnd = endDate.compareTo(sysDate);
					if (compareEnd > 0) {
						pollQstVO.setStatus(1);
					} 
					else {
						pollQstVO.setStatus(0);
					}
					
					pollQstVO.setIsHidden(0);
					
					//Checking Array
					if (userID.equals(pollQstVO.getCreator())) {
						checkingArray[0] = 1;
					}
					else {
						checkingArray[1] = 1;
					}
				}
			}
		}
	}
	
	private void saveHiddenQuestion(String hideQstList, LoginVO loginVO) throws Exception{
		String userID = loginVO.getId();
		//String userID = "abc1";
		String[] hiddenQstIds = hideQstList.split(",");
		for(int i = 0; i < hiddenQstIds.length; i++){
			PollQuestionStatusVO pollQstStatusVO = new PollQuestionStatusVO();
			pollQstStatusVO.setUserId(userID);
			pollQstStatusVO.setTenantId(loginVO.getTenantId());
			pollQstStatusVO.setQustId(Integer.parseInt(hiddenQstIds[i]));
			//pollQstStatusVO.setHide(1);
			ezPollService.insertHiddenQuestion(pollQstStatusVO);
		}
	}
	
	private void getAllUserForQuestion(LoginVO loginVO, int questionID, Set<LoginVO> set) throws Exception{
		//Check if this question is for all members
		int target = ezPollService.checkTargetOfQst(questionID, loginVO.getTenantId());
		List<LoginVO> list = new ArrayList<LoginVO>();
		if(target == 0){
			list = loginService.selectAllMemberOfCompany(loginVO.getCompanyID(), loginVO.getTenantId());
		}
		else{
			List<String> departIdList = ezPollService.getListOfUserIdForQst(questionID, loginVO.getTenantId(), "dept");
			for(String deptId : departIdList){
				//logger.debug("CHECK THE RETURN LIST NAME: " + deptId);
				getAllMemberOfDept(list, deptId, loginVO.getTenantId());
				//logger.debug("BAONK__TEST  The Size of List : "  + list.size());
			}
			
			List<String> userIdList = ezPollService.getListOfUserIdForQst(questionID, loginVO.getTenantId(), "user");	
			for(String _userID : userIdList){
				//logger.debug("CHECK THE LIST USER NAME: " + _userID);
				LoginVO user = loginService.selectReceiver(_userID, loginVO.getTenantId());
				list.add(user);
			}
		}	
		set.addAll(list);
	}
	
	private String questionDelete(String listQstIds, LoginVO loginVO) throws Exception{		
		//Delete in table Question
		String strXML = "";
		
		String [] qstIdArray = listQstIds.split(",");
		try{
			for (int i = 0; i < qstIdArray.length; i++) {
				int qstId = Integer.parseInt(qstIdArray[i]);
				logger.debug("QstID to delete: " + qstId);
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
		catch (Exception e){
			logger.debug("Run in Exception!");
			strXML = "<DATA>DELETE_FAIL</DATA>";
			e.printStackTrace();
		}		
		return strXML;
	}
	
	private String getFileSize(int fileSize){
		String fileSize_ = "";
        if (fileSize / 1024 / 1024 >= 1) {
        	fileSize_ = String.format("%.2f", (double)(fileSize / 1024 / 1024 * 10) / 10);
        	fileSize_ = fileSize_ + "MB";
        }
        else if (fileSize / 1024 >= 1) {
        	fileSize_ = String.format("%.2f", (double)(fileSize / 1024));
        	fileSize_ = fileSize_ + "KB";
        }
        else {
        	fileSize_ = fileSize + "B";
        }
        return fileSize_;
	}

}
