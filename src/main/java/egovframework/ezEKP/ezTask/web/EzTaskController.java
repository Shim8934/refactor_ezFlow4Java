package egovframework.ezEKP.ezTask.web;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezTask.service.EzTaskService;
import egovframework.ezEKP.ezTask.vo.TaskAttachVO;
import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskConfigVO;
import egovframework.ezEKP.ezTask.vo.TaskGeneralVO;
import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.ezEKP.ezTask.vo.TaskShareVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 사용자 - ToDo 
 * @author 오픈솔루션팀 이효진, 정수현
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.08.11	이효진			신규작성
 *    2017.08.11	정수현			신규작성
 *
 * @see
 */

@Controller
public class EzTaskController extends EgovFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzTaskController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EzCommonService ezCommonService;

	@Autowired
	private EzTaskService ezTaskService;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	/**
	 * 업무관리 메인화면
	 */
	@RequestMapping(value="/ezTask/taskMain.do", method = RequestMethod.GET)
	public String taskMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskMain started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userID = userInfo.getId();
		int tenantID = userInfo.getTenantId();
		
		String useTodoMemo = ezCommonService.getTenantConfig("UseTodoMemo", tenantID);
		String taskFlag = request.getParameter("taskFlag") == null ? "normal" : request.getParameter("taskFlag");
				
		TaskConfigVO configVO = ezTaskService.getOriginColor(userID, tenantID);
		TaskGeneralVO taskGeneralVO = ezTaskService.getTaskGeneral(userInfo.getId(), userInfo.getTenantId());

		if (configVO == null) {
			ezTaskService.taskSaveConfig(userInfo.getId(), "#FF1B1B", "#8DFF1B", "", "", userInfo.getTenantId());
			configVO = ezTaskService.getOriginColor(userID, tenantID);
		}

		if (taskGeneralVO == null) {
			ezTaskService.taskSaveGeneral(userInfo.getId(), 10, "taskprog", userInfo.getTenantId());
			taskGeneralVO = ezTaskService.getTaskGeneral(userInfo.getId(), userInfo.getTenantId());
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("delayColor", configVO.getDelayColor());
		model.addAttribute("completeColor", configVO.getCompleteColor());
		model.addAttribute("useTodoMemo", useTodoMemo);
		model.addAttribute("taskGeneralVO", taskGeneralVO);
		model.addAttribute("taskFlag", taskFlag);

		logger.debug("taskMain ended.");

		return "/ezTask/taskMain";
	}

	/**
	 * 업무상세화면 조회
	 */
	@RequestMapping(value = "/ezTask/taskRead.do", method = RequestMethod.GET)
	public String taskRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskRead started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userID = userInfo.getId();
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();	
		String companyID = userInfo.getCompanyID();
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", tenantID);
		String useTodoMemo = ezCommonService.getTenantConfig("UseTodoMemo", tenantID);
		String folderPath = commonUtil.getUploadPath("upload_task.ROOT", tenantID) + commonUtil.separator + "uploadFile";
		
		String taskID = request.getParameter("taskID");		
		String date = request.getParameter("date"); //클릭한 날짜
		String type = (request.getParameter("type") == null ? "" : request.getParameter("type"));
		String dateList = "";
		String completeRateList = "";
		String statusList = "";	
		String repeatCntList = "";
		String mode = (request.getParameter("mode") == null ? "" : request.getParameter("mode"));
		Map<String, Integer> result = new LinkedHashMap<String, Integer>();

		//업무정보 조회
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID, companyID);

		//의견목록 조회
		List<TaskCommentVO> taskCommentList = null;
		if (taskInfoVO.getHasComment().equals("Y")) {			
			taskCommentList = ezTaskService.getCommentList(taskID, offset, primary, tenantID);
		}
		
		//업무공유자목록조회
		List<TaskShareVO> taskShareList = null;
		if (taskInfoVO.getHasShare().equals("Y")) {
			taskShareList = ezTaskService.getShareList(taskID, primary, tenantID);
		}
		
		//task첨부파일목록조회
		String taskAttachList = null;
		if (taskInfoVO.getHasAttach().equals("Y")) {
			taskAttachList = ezTaskService.getAttachListStr(taskID, folderPath, "1", tenantID);
		}
		
		//taskWork첨부파일목록조회
		String taskWorkAttachList = null;
		if (taskInfoVO.getPersonAttach().equals("Y")) {
			taskWorkAttachList  = ezTaskService.getAttachListStr(taskID, folderPath, "2", tenantID);
		}
		
		//baonk added
		if (taskInfoVO.getTaskType().equals("4") || taskInfoVO.getTaskType().equals("5") || taskInfoVO.getTaskType().equals("6")) {			
			SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String endDate = "";	
			
			if (mode.equals("")) {
				//Get user today time
				String[] offsetArr = offset.split("\\|");				
				nsdf.setTimeZone(TimeZone.getTimeZone("GMT" + offsetArr[1]));
			    String utcTime = nsdf.format(new Date());	    		    
				String todayText = utcTime + " 00:00:00";
				Date today = sdf.parse(todayText); 
		        Calendar calendar1 = Calendar.getInstance();  
		        calendar1.setTime(today); 
		        
				if (taskInfoVO.getTotalRep() != -1) {
					endDate = taskInfoVO.getEndDate();
					Date taskEndDate = sdf.parse(endDate); 
			        Calendar calendar2 = Calendar.getInstance();  
			        calendar2.setTime(taskEndDate);         
			        
			        if (calendar1.compareTo(calendar2) >= 0) {	        	
			        	result = ezTaskService.getRepTaskInfo(endDate.substring(0, 10), taskID, offset, primary, tenantID, taskInfoVO, companyID);
			        	date = endDate.substring(0, 10);
			        } else {		        	
			        	result = ezTaskService.getRepTaskInfo(utcTime, taskID, offset, primary, tenantID, taskInfoVO, companyID);
			        	int resultCount = 0;
			        	for (String d: result.keySet()) {	        	
			        		resultCount++;
			        		Date dDate = sdf.parse(d + " 00:00:00"); 
			    	        Calendar calendar3 = Calendar.getInstance();  
			    	        calendar3.setTime(dDate); 
			    	        
			    	        if (calendar3.compareTo(calendar1) >= 0) {		    	        	
			    	        	date = d;
			    	        	break;
			    	        }
			    	        
			    	        if (resultCount == result.keySet().size()) {
			    	        	date = d;
			    	        	break;
			    	        }
			        	}
			        }		        		        
				} else {				
					result = ezTaskService.getRepTaskInfo(utcTime, taskID, offset, primary, tenantID, taskInfoVO, companyID);
					int resultCount = 0;
		        	for (String d: result.keySet()) {
		        		Date dDate = sdf.parse(d + " 00:00:00"); 
		    	        Calendar calendar3 = Calendar.getInstance();  
		    	        calendar3.setTime(dDate); 
		    	        
		    	        if (calendar3.compareTo(calendar1) >= 0) {
		    	        	date = d;
		    	        	break;
		    	        }
		    	        
		    	        if (resultCount == result.keySet().size()) {
		    	        	date = d;
		    	        	break;
		    	        }
		        	}
				}					        
			}
			else {
				//In search mode
				result = ezTaskService.getRepTaskInfo(date, taskID, offset, primary, tenantID, taskInfoVO, companyID);
			}
			
			for (Map.Entry<String, Integer> entry : result.entrySet()) {
	            String key = entry.getKey();
	            Integer value = entry.getValue();	
	            
	            //logger.debug("Value: " + value + " || Key: " + key);
	            
				dateList += key + ",";
				/*2018-05-18 구해안 1일 클릭시 전달 말일로 넘어가는 버그, UTC -> 현재날짜로 수정*/
				/*String convertDate = commonUtil.getDateStringInUTC(key + " 00:00:00", userInfo.getOffset(), true);*/
				String convertDate = key + " 00:00:00";
				int comRate = ezTaskService.selectCompletionOfRepTask(taskID, convertDate, tenantID);
				completeRateList += Integer.toString(comRate) + ",";
				
				int status = ezTaskService.getStatusOfRepTask(taskID, convertDate, tenantID);
				statusList += Integer.toString(status) + ",";
				repeatCntList += value + ",";
	        }
			
			dateList = dateList.substring(0, dateList.length() - 1);
			completeRateList = completeRateList.substring(0, completeRateList.length() - 1);
			statusList = statusList.substring(0, statusList.length() - 1);
			repeatCntList = repeatCntList.substring(0, repeatCntList.length() - 1);
			
			String realStartDate = date + " 00:00:00";
			String realDate = commonUtil.getDateStringInUTC(realStartDate, userInfo.getOffset(), true);
			int status = ezTaskService.getStatusOfRepTask(taskID, realDate, tenantID);
			taskInfoVO.setTaskStatus(status);
			int completionPercentage = ezTaskService.selectCompletionOfRepTask(taskID, realDate, tenantID);
			taskInfoVO.setCompleteRate(completionPercentage);			
			taskInfoVO.setRepeatCount(result.get(date));	        			
		}	
		//end

		TaskConfigVO configVO = ezTaskService.getOriginColor(userID, tenantID);

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("taskShareList", taskShareList);
		model.addAttribute("taskAttachList", taskAttachList);
		model.addAttribute("taskWorkAttachList", taskWorkAttachList);
		model.addAttribute("taskCommentList", taskCommentList);
		model.addAttribute("taskCommentListSize", taskCommentList == null ? "0" : taskCommentList.size());
		model.addAttribute("type", type);
		model.addAttribute("delayColor", configVO.getDelayColor());
		model.addAttribute("completeColor", configVO.getCompleteColor());
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useTodoMemo", useTodoMemo);
		model.addAttribute("repeatCount", taskInfoVO.getRepeatCount());
		model.addAttribute("date", date);
		model.addAttribute("repetition", taskInfoVO.getRepetition());
		model.addAttribute("dateList", dateList);	
		model.addAttribute("completeRateList", completeRateList);
		model.addAttribute("statusList", statusList);	
		model.addAttribute("repeatCntList", repeatCntList);
		
		return "/ezTask/taskRead";
	}
	
	/**
	 *  업무상세화면 의견목록 조회
	 */
	@RequestMapping(value = "/ezTask/getTaskCommentList.do", method = RequestMethod.GET)
	public String getTaskCommentList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getTaskCommentList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String taskID = request.getParameter("taskID");
		
		List<TaskCommentVO> taskCommentList = ezTaskService.getCommentList(taskID, userInfo.getOffset(), userInfo.getPrimary(), userInfo.getTenantId());
		
		model.addAttribute("taskCommentList", taskCommentList);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("getTaskCommentList ended.");
		
		return "json";
	}
	
	/**
	 * 업무상세화면 조회 Json
	 */
	/*@RequestMapping(value = "/ezTask/taskReadJson.do")
	public String taskReadJson(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskRead started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userID = userInfo.getId();
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();	
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", tenantID);
		String useTodoMemo = ezCommonService.getTenantConfig("UseTodoMemo", tenantID);
		String folderPath = commonUtil.getUploadPath("upload_task.ROOT", tenantID) + commonUtil.separator + "uploadFile";
		
		String taskID = request.getParameter("taskID");		
		String date = request.getParameter("date");
		String type = (request.getParameter("type") == null ? "" : request.getParameter("type"));
		String dateList = "";
		String completeRateList = "";
		String statusList = "";
		String orderNumber = "";		

		//업무정보 조회
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID);

		//의견목록 조회
		List<TaskCommentVO> taskCommentList = null;
		if (taskInfoVO.getHasComment().equals("Y")) {			
			taskCommentList = ezTaskService.getCommentList(taskID, offset, primary, tenantID);
		}
		
		//업무공유자목록조회
		List<TaskShareVO> taskShareList = null;
		if (taskInfoVO.getHasShare().equals("Y")) {
			taskShareList = ezTaskService.getShareList(taskID, primary, tenantID);
		}
		
		//task첨부파일목록조회
		String taskAttachList = null;
		if (taskInfoVO.getHasAttach().equals("Y")) {
			taskAttachList = ezTaskService.getAttachListStr(taskID, folderPath, "1", tenantID);
		}
		
		//taskWork첨부파일목록조회
		String taskWorkAttachList = null;
		if (taskInfoVO.getPersonAttach().equals("Y")) {
			taskWorkAttachList  = ezTaskService.getAttachListStr(taskID, folderPath, "2", tenantID);
		}
		
		//baonk added
		if (taskInfoVO.getTaskType().equals("4") || taskInfoVO.getTaskType().equals("5") || taskInfoVO.getTaskType().equals("6")) {			
			SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
			Date startDate = nsdf.parse(date); 
	        Calendar calendar = Calendar.getInstance();  
	        calendar.setTime(startDate); 
	        
	        calendar.add(Calendar.MONTH, 1);  
	        calendar.set(Calendar.DAY_OF_MONTH, 1);  
	        calendar.add(Calendar.DATE, -1); 
	        String lastDayOfMonth = nsdf.format(calendar.getTime()) + " 23:59:59"; 
	        
	        calendar.set(Calendar.DAY_OF_MONTH, 1);
	        String firstDayOfMonth = nsdf.format(calendar.getTime()) + " 00:00:00";       	              
			
	        Map<String, Integer> result = ezTaskService.getDatesOfRepTask(taskID, offset, primary, lastDayOfMonth, firstDayOfMonth, date, tenantID);
			
			while (result.size() == 0) {
				//Move to next month
				calendar.add(Calendar.MONTH, 1);
				date = nsdf.format(calendar.getTime());
				firstDayOfMonth = date + " 00:00:00"; 				
				calendar.add(Calendar.MONTH, 1); 
		        calendar.set(Calendar.DAY_OF_MONTH, 1);  
		        calendar.add(Calendar.DATE, -1); 
		        lastDayOfMonth = nsdf.format(calendar.getTime()) + " 23:59:59"; 		        
		        result = ezTaskService.getDatesOfRepTask(taskID, offset, primary, lastDayOfMonth, firstDayOfMonth, date, tenantID);
				calendar.set(Calendar.DAY_OF_MONTH, 1);
			}			
			
			if (!result.contains(date)) {			
				date = result.get(0);
			}			
			
			for (String test : result) {				
				dateList += test + ",";
				String covertDate = commonUtil.getDateStringInUTC(test + " 00:00:00", userInfo.getOffset(), true);
				int comRate = ezTaskService.selectCompletionOfRepTask(taskID, covertDate, tenantID);
				completeRateList += Integer.toString(comRate) + ",";
				
				int status = ezTaskService.getStatusOfRepTask(taskID, covertDate, tenantID);
				statusList += Integer.toString(status) + ",";
			}
			
			dateList = dateList.substring(0, dateList.length() - 1);
			completeRateList = completeRateList.substring(0, completeRateList.length() - 1);
			statusList = statusList.substring(0, statusList.length() - 1);
			
			String realStartDate = date + " 00:00:00";
			String realDate = commonUtil.getDateStringInUTC(realStartDate, userInfo.getOffset(), true);
			int status = ezTaskService.getStatusOfRepTask(taskID, realDate, tenantID);
			taskInfoVO.setTaskStatus(status);
			int completionPercentage = ezTaskService.selectCompletionOfRepTask(taskID, realDate, tenantID);
			taskInfoVO.setCompleteRate(completionPercentage);			
			taskInfoVO.setRepeatCount(Integer.parseInt(orderNumber));

			
		}	
		//end

		TaskConfigVO configVO = ezTaskService.getOriginColor(userID, tenantID);

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("taskShareList", taskShareList);
		model.addAttribute("taskAttachList", taskAttachList);
		model.addAttribute("taskWorkAttachList", taskWorkAttachList);
		model.addAttribute("taskCommentList", taskCommentList);
		model.addAttribute("taskCommentListSize", taskCommentList == null ? "0" : taskCommentList.size());
		model.addAttribute("type", type);
		model.addAttribute("delayColor", configVO.getDelayColor());
		model.addAttribute("completeColor", configVO.getCompleteColor());
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useTodoMemo", useTodoMemo);
		model.addAttribute("repeatCount", taskInfoVO.getRepeatCount());
		model.addAttribute("date", date);
		model.addAttribute("repetition", taskInfoVO.getRepetition());
		model.addAttribute("dateList", dateList);	
		model.addAttribute("completeRateList", completeRateList);
		model.addAttribute("statusList", statusList);
		
		logger.debug("model in taskReadJson: " + model);		
		
		return "json";
	}*/
	
	@RequestMapping(value = "/ezTask/getRepTaskDateList.do", method = RequestMethod.GET)
	public String getRepTaskDateList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getRepTaskDateList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		String companyID = userInfo.getCompanyID();
		List<String> rateList = new ArrayList<String>();
		List<String> statusList = new ArrayList<String>();
		List<String> repeatCntList = new ArrayList<String>();
		List<String> dateList = new ArrayList<String>();
		
		String taskID = request.getParameter("taskID");
		String date = request.getParameter("currentDate");		
		
		SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = nsdf.parse(date); 
        Calendar calendar = Calendar.getInstance();  
        calendar.setTime(startDate); 
        
        calendar.add(Calendar.MONTH, 1);  
        calendar.set(Calendar.DAY_OF_MONTH, 1);  
        calendar.add(Calendar.DATE, -1); 
        String lastDayOfMonth = nsdf.format(calendar.getTime()) + " 23:59:59"; 
        
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        String firstDayOfMonth = nsdf.format(calendar.getTime()) + " 00:00:00";  
		
        Map<String, Integer> result = ezTaskService.getDatesOfRepTask(taskID, offset, primary, lastDayOfMonth, firstDayOfMonth, "", tenantID, companyID);
        
        for (Map.Entry<String, Integer> entry : result.entrySet()) {
            String key = entry.getKey();
            Integer value = entry.getValue();
            
            String covertDate = key + " 00:00:00";
			int comRate = ezTaskService.selectCompletionOfRepTask(taskID, covertDate, tenantID);
			rateList.add(Integer.toString(comRate));
			int status = ezTaskService.getStatusOfRepTask(taskID, covertDate, tenantID);			
			statusList.add(Integer.toString(status));
			repeatCntList.add(Integer.toString(value));
			dateList.add(key);
        }
		
		model.addAttribute("statusList", statusList);
		model.addAttribute("rateList", rateList);
		model.addAttribute("dateList", dateList);		
		model.addAttribute("repeatCntList", repeatCntList);
		
		logger.debug("getRepTaskDateList ended.");
		
		return "json";
	}	
	
	/**
	 * 업무작성 저장 Method
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezTask/taskSave.do", method = RequestMethod.POST)
	public String taskSave(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskSave started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();	
		String companyID = userInfo.getCompanyID();
		
		String realPath = commonUtil.getRealPath(request);
		String uploadTaskPath = commonUtil.getUploadPath("upload_task.ROOT", tenantID);
		String content = param.get("content").toString();
		String fileList = param.get("fileList").toString();
		String fileName = param.get("fileName").toString();
		String fileSize = param.get("fileSize").toString();
		
		TaskInfoVO taskInfoVO = new TaskInfoVO();
		taskInfoVO.setTaskID(param.get("taskID").toString());
		taskInfoVO.setCreatorID(userInfo.getId());
		taskInfoVO.setCreatorName(userInfo.getDisplayName1());
		taskInfoVO.setCreatorName2(userInfo.getDisplayName2());
		taskInfoVO.setCreatorDeptName(userInfo.getDeptName1());
		taskInfoVO.setCreatorDeptName2(userInfo.getDeptName2());
		taskInfoVO.setCreatorEmail(userInfo.getEmail());
		taskInfoVO.setPersonID(param.get("personID").toString());
		taskInfoVO.setPersonName(param.get("personName").toString());
		taskInfoVO.setPersonName2(param.get("personName2").toString());
		taskInfoVO.setPersonDeptName(param.get("personDeptName").toString());
		taskInfoVO.setPersonDeptName2(param.get("personDeptName2").toString());
		taskInfoVO.setPersonEmail(param.get("personEmail").toString());
		taskInfoVO.setHasShare(param.get("hasShare").toString());
		taskInfoVO.setTaskType(param.get("taskType").toString());
		taskInfoVO.setImportance(Integer.parseInt(param.get("importance").toString()));
		taskInfoVO.setStartDate(param.get("startDate").toString());
		taskInfoVO.setEndDate(param.get("endDate").toString());
		taskInfoVO.setTitle(param.get("title").toString());
		taskInfoVO.setHasAttach(param.get("hasAttach").toString());
		
		String contentPath = param.get("contentPath").toString();
		contentPath = commonUtil.detectPathTraversal(contentPath);
		contentPath = commonUtil.stripScriptTags(contentPath);
		
		taskInfoVO.setContentPath(contentPath);
		taskInfoVO.setMemo(param.get("memo").toString());
		taskInfoVO.setRepetition((param.get("repetition").toString()));
		
		//baonk added
		if (taskInfoVO.getTaskType().equals("4") || taskInfoVO.getTaskType().equals("5") || taskInfoVO.getTaskType().equals("6")) {
			ezTaskService.setRepTaskInfo(taskInfoVO);
		}		
		//end		
		
		List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("shareList");
		List<TaskShareVO> shareList = new ArrayList<TaskShareVO>();
		
		for (Map<String, Object> map : list) {
			TaskShareVO shareVO = new TaskShareVO();
			logger.debug("sharerID = " + map.get("sharerID").toString());
			logger.debug("sharerName = " + map.get("sharerName").toString());
			logger.debug("sharerName2 = " + map.get("sharerName2").toString());
			logger.debug("sharerDeptName = " + map.get("sharerDeptName").toString());
			logger.debug("sharerDeptName2 = " + map.get("sharerDeptName2").toString());
			logger.debug("sharerEmail = " + map.get("sharerEmail").toString());
			shareVO.setSharerID(map.get("sharerID").toString());
			shareVO.setSharerName(map.get("sharerName").toString());
			shareVO.setSharerName2(map.get("sharerName2").toString() != null ? map.get("sharerName2").toString() : "");
			shareVO.setSharerDeptName(map.get("sharerDeptName").toString());
			shareVO.setSharerDeptName2(map.get("sharerDeptName2").toString() != null ? map.get("sharerDeptName2").toString() : "");
			shareVO.setSharerEmail(map.get("sharerEmail").toString());
			shareList.add(shareVO);
		}
		
		taskInfoVO.setShareList(shareList);
		
		ezTaskService.taskSave(taskInfoVO, realPath, uploadTaskPath, content, fileList, fileName, fileSize, userInfo.getOffset(), tenantID, companyID);

		logger.debug("taskSave ended");
		
		return "json";
	}
	
	
	/**
	 * 진행사항 수정화면 조회
	 */
	@RequestMapping(value = "/ezTask/taskWorkWrite.do", method = RequestMethod.GET)
	public String taskWorkWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskWorkWrite started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		
		String taskID = request.getParameter("taskID");
		
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, userInfo.getOffset(), userInfo.getPrimary(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		//첨부파일목록조회
		StringBuilder strAttach = new StringBuilder();
		if (taskInfoVO.getPersonAttach().equals("Y")) {
			List<TaskAttachVO> taskWorkAttachList = ezTaskService.getAttachList(taskID, realPath, "2", tenantID);
			
			strAttach.append("<ROOT><NODES>");
	    	
			for (TaskAttachVO vo : taskWorkAttachList) {
				String filePath = vo.getFilePath().substring(vo.getTaskID().length() + 2);
				
				strAttach.append("<DATA><![CDATA[" + filePath + "]]></DATA>");
				strAttach.append("<DATA2><![CDATA[" + vo.getFileName() + "]]></DATA2>");
				strAttach.append("<DATA3><![CDATA[" + vo.getFileSize() + "]]></DATA3>");
				strAttach.append("<DATA4><![CDATA[OK]]></DATA4>");
	        }
			
			strAttach.append("</NODES></ROOT>");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("taskWorkAttachList", strAttach);
		
		logger.debug("taskWorkWrite ended.");
		
		return "/ezTask/taskWorkWrite";
	}
	
	/**
	 * 진행사항 수정 Method
	 */
	@RequestMapping(value = "/ezTask/taskWorkSave.do", method = RequestMethod.POST)
	public String taskWorkSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskWorkSave started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		String realPath = commonUtil.getRealPath(request);
		String uploadTaskPath = commonUtil.getUploadPath("upload_task.ROOT", tenantID);
		String taskID = request.getParameter("taskID");
		String content = request.getParameter("content");
		String attachList = request.getParameter("attachList");
		String fileName = request.getParameter("fileName");
		String fileSize = request.getParameter("fileSize");
		String personAttach = request.getParameter("personAttach");
		String contentPath = request.getParameter("contentPath");
		contentPath = commonUtil.detectPathTraversal(contentPath);
		contentPath = commonUtil.stripScriptTags(contentPath);
		
		String personContentPath = ezTaskService.taskWorkSave(taskID, content, attachList, fileName, fileSize, personAttach, contentPath, realPath, uploadTaskPath, tenantID);
		
		logger.debug("taskWorkSave ended.");
		
		model.addAttribute("personContentPath", personContentPath);
		
		return "json";
	}
	
	/**
	 * 진행상태 수정 Method
	 */
	@RequestMapping(value = "/ezTask/updateTaskStatus.do", method = RequestMethod.POST)
	public String updateTaskStatus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskUpdateInstance started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String taskID = request.getParameter("taskID");
		String taskStatus = request.getParameter("taskStatus");
		String completeRate = request.getParameter("completeRate");
		String repeateCount = request.getParameter("repeatCount");
		String tasktype = request.getParameter("tasktype");
		String realDate = request.getParameter("realDate");
		
		logger.debug("RepeatCount: " + repeateCount + "|| taskType: " + tasktype + "|| realDate: " + realDate + " || Task status: " + taskStatus);
		
		ezTaskService.updateTaskStatus(taskID, taskStatus, tasktype, repeateCount, realDate, completeRate, userInfo.getTenantId());
		
		logger.debug("updateTaskStatus ended.");
		
		return "json";
	}
	
	/**
	 * 의견작성 Method
	 */
	@RequestMapping(value = "/ezTask/taskSaveComment.do", method = RequestMethod.POST)
	public String taskSaveComment(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskSaveComment started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		String taskID = commonUtil.stripScriptTags(request.getParameter("taskID"));
		String textComment = commonUtil.stripScriptTags(request.getParameter("textComment"));
		
		int result = ezTaskService.insertComment(taskID, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), textComment, tenantID);
		
		model.addAttribute("result", result);
		
		logger.debug("taskSaveComment ended.");
		
		return "json";
	}
	
	/** 
	 * 의견삭제 Method
	 */
	@RequestMapping(value = "/ezTask/taskDeleteComment.do", method = RequestMethod.POST)
	public String taskDeleteComment(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskDeleteComment started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		String taskID = request.getParameter("taskID");
		String commentID = request.getParameter("commentID");
		
		ezTaskService.deleteComment(taskID, commentID, tenantID);
		
		logger.debug("taskDeleteComment ended.");
		
		return "json";
	}

	/**
	 * 조직도화면조회
	 */
	@RequestMapping(value = "/ezTask/taskSelectEntity.do", method = RequestMethod.GET)
	public String taskSelectEntity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskSelectEntity started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Locale locale = userInfo.getLocale();
		String type = request.getParameter("type");
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		model.addAttribute("type", type);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("title", type.equals("1") ? egovMessageSource.getMessage("ezTask.t2005", locale) : egovMessageSource.getMessage("ezTask.t157", locale));
		model.addAttribute("primaryLang", primaryLang);
		
		logger.debug("taskSelectEntity ended.");
		
		return "/ezTask/taskSelectEntity";
	}
	
	/**
	 * 진행상태 수정화면 조회
	 */
	@RequestMapping(value = "/ezTask/taskStatus.do", method = RequestMethod.GET)
	public String taskStatus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskStatus started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		int repeatCnt = 0;		
		String startDate = request.getParameter("startDate");
		String date = request.getParameter("date");
		String realStartDate = date + "" + startDate.substring(10, 19);		

		/*2018-05-18 구해안 1일 클릭시 전달 말일로 넘어가는 버그, UTC -> 현재날짜로 수정, realStartDate값을 realDate key값에 넣음*/
		/*String realDate = commonUtil.getDateStringInUTC(realStartDate, userInfo.getOffset(), true);*/	
		
		if (request.getParameter("repeatCount") != null || !request.getParameter("repeatCount").equals("")) {
			repeatCnt = Integer.parseInt(request.getParameter("repeatCount"));
		}
		
		if (repeatCnt != 0) {
			model.addAttribute("repeatCount", repeatCnt);
		}
		
		String taskID = request.getParameter("taskID");		
		
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, userInfo.getOffset(), userInfo.getPrimary(), tenantID, userInfo.getCompanyID());
		TaskConfigVO configVO = ezTaskService.getOriginColor(userInfo.getId(), tenantID);
		
		//baonk added		
		if (taskInfoVO.getTaskType().equals("4") || taskInfoVO.getTaskType().equals("5") || taskInfoVO.getTaskType().equals("6")) {
			int status = ezTaskService.getStatusOfRepTask(taskInfoVO.getTaskID(), realStartDate, tenantID);
			taskInfoVO.setTaskStatus(status);			
			int completionPercentage = ezTaskService.selectCompletionOfRepTask(taskInfoVO.getTaskID(), realStartDate, tenantID);				
			taskInfoVO.setCompleteRate(completionPercentage);
		}
		//end

		model.addAttribute("realDate", realStartDate);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("delayColor", configVO.getDelayColor());
		model.addAttribute("completeColor", configVO.getCompleteColor());
		
		logger.debug("taskStatus ended.");
		
		return "/ezTask/taskStatus";
	}
	
	/**
	 * 첨부파일 다운로드
	 */
	@RequestMapping(value = "/ezTask/downloadAttach.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadAttach(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadAttach started.");

		String filePath = commonUtil.detectPathTraversal(request.getParameter("filePath"));
		String fileName = commonUtil.detectPathTraversal(request.getParameter("fileName"));
		String realPath = commonUtil.detectPathTraversal(commonUtil.getRealPath(request));

		if (fileName == null || fileName.equals("")) {
			fileName = filePath;
		}

		String fullFilePath = realPath + filePath;

		logger.debug("fullFilePath : " + fullFilePath + " | fileName : " + fileName);

		downFile(request, response, fullFilePath, fileName);

		logger.debug("downloadAttach ended.");
	}
	
	/**
	 * taskWork 첨부파일 목록조회
	 */
	@RequestMapping(value = "/ezTask/getTaskAttachList.do", method = RequestMethod.GET)
	public String getTaskAttachList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getTaskAttachList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		
		String folderPath = commonUtil.getUploadPath("upload_task.ROOT", tenantID) + commonUtil.separator + "uploadFile";
		
		String taskID = request.getParameter("taskID");
		
		//업무정보 조회
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID, userInfo.getCompanyID());
		
		//taskWork첨부파일목록조회
		String taskAttachList = null;
		if (taskInfoVO.getHasAttach().equals("Y")) {
			taskAttachList  = ezTaskService.getAttachListStr(taskID, folderPath, "1", tenantID);
		}
		
		model.addAttribute("hasTaskAttach", taskInfoVO.getHasAttach());
		model.addAttribute("taskAttachList", taskAttachList);
		
		logger.debug("getTaskAttachList ended.");
		
		return "json";
	}
	
	/**
	 * taskWork 첨부파일 목록조회
	 */
	@RequestMapping(value = "/ezTask/getTaskWorkAttachList.do", method = RequestMethod.GET)
	public String getTaskWorkAttachList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getTaskWorkAttachList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		
		String folderPath = commonUtil.getUploadPath("upload_task.ROOT", tenantID) + commonUtil.separator + "uploadFile";
		
		String taskID = request.getParameter("taskID");
		
		//업무정보 조회
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID, userInfo.getCompanyID());
		
		//taskWork첨부파일목록조회
		String taskWorkAttachList = null;
		if (taskInfoVO.getPersonAttach().equals("Y")) {
			taskWorkAttachList  = ezTaskService.getAttachListStr(taskID, folderPath, "2", tenantID);
		}
		
		model.addAttribute("hasTaskWorkAttach", taskInfoVO.getPersonAttach());
		model.addAttribute("taskWorkAttachList", taskWorkAttachList);
		
		logger.debug("getTaskWorkAttachList ended.");
		
		return "json";
	}
	
	/**
	 * 업무관리 환경설정
	 */
	@RequestMapping(value = "/ezTask/taskConfig.do", method = RequestMethod.GET)
	public String taskConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskConfig started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		TaskConfigVO configVO = ezTaskService.getOriginColor(userInfo.getId(), userInfo.getTenantId());

		logger.debug("delayColor : " + configVO.getDelayColor() + " | completeColor : " + configVO.getCompleteColor() + " | originColor : " + configVO.getOriginColor() + " | originColor2 : " + configVO.getOriginColor2());

		model.addAttribute("delayColor", configVO.getDelayColor());
		model.addAttribute("completeColor", configVO.getCompleteColor());
		model.addAttribute("originColor", configVO.getOriginColor());
		model.addAttribute("originColor2", configVO.getOriginColor2());

		TaskGeneralVO taskGeneralVO = ezTaskService.getTaskGeneral(userInfo.getId(), userInfo.getTenantId());

		model.addAttribute("taskGeneralVO", taskGeneralVO);
		
		logger.debug("taskConfig ended.");
		
		return "/ezTask/taskConfig";
	}
	
	/**
	 * 색상선택 화면 호출
	 */
	@RequestMapping(value = "/ezTask/taskManyColor.do", method = RequestMethod.GET)
	public String taskManyColor() throws Exception {
		logger.debug("taskManyColor started.");
		
		logger.debug("taskManyColor ended.");
		
		return "/ezTask/taskManyColor";
	}

	/**
	 * 업무관리 색상 저장
	 */
	@RequestMapping(value = "/ezTask/taskSaveConfig.do", method = RequestMethod.POST)
	public String taskSaveConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("taskSaveConfig started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String delayColor = commonUtil.stripScriptTags(request.getParameter("delayColor"));
		String completeColor = commonUtil.stripScriptTags(request.getParameter("completeColor"));
		String originColor = commonUtil.stripScriptTags(request.getParameter("originColor"));
		String originColor2 = commonUtil.stripScriptTags(request.getParameter("originColor2"));
		
		int listCount = Integer.parseInt(request.getParameter("listCount"));
		String selectTaskStatus = request.getParameter("selectTaskStatus");
		selectTaskStatus = commonUtil.stripScriptTags(selectTaskStatus);
		
		TaskConfigVO configVO = ezTaskService.getOriginColor(userInfo.getId(), userInfo.getTenantId());

		logger.debug("originDelayColor : " + configVO.getDelayColor() + " | originCompleteColor : " + configVO.getCompleteColor());
		
		if (configVO != null) {
			ezTaskService.taskUpdateConfig(userInfo.getId(), delayColor, completeColor, originColor, originColor2, userInfo.getTenantId());
		}
		
		ezTaskService.updateTaskGeneral(userInfo.getId(), listCount, selectTaskStatus, userInfo.getTenantId());
		
		logger.debug("taskSaveConfig ended.");

		return "json";
	}

	/**
	 * 업무관리 검색
	 */
	@RequestMapping(value = "/ezTask/taskSearch.do", method = RequestMethod.GET)
	public String taskSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("taskSearch started.");

		userInfo = commonUtil.userInfo(loginCookie);

		String userID = userInfo.getId();
		int tenantID = userInfo.getTenantId();
		
		String useTodoMemo = ezCommonService.getTenantConfig("UseTodoMemo", tenantID);

		TaskConfigVO configVO = ezTaskService.getOriginColor(userID, tenantID);

		model.addAttribute("userInfo",userInfo);
		model.addAttribute("delayColor", configVO.getDelayColor());
		model.addAttribute("completeColor", configVO.getCompleteColor());
		model.addAttribute("useTodoMemo", useTodoMemo);

		logger.debug("taskSearch ended.");

		return "/ezTask/taskSearch";
	}

	/**
	 * draganddrop 호출 Method
	 */
	@RequestMapping(value = "/ezTask/dragAndDrop.do", method = RequestMethod.GET)
	public String dragAndDrop(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("dragAndDrop started.");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo",userInfo);

		logger.debug("dragAndDrop ended.");
		
		return "/ezTask/taskDragAndDrop";
	}
	
	/**
	 * 첨부파일 업로드
	 */
	@RequestMapping(value = "/ezTask/uploadItemAttach.do", produces = "text/plain; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String uploadItemAttach(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception{
		logger.debug("uploadItemAttach started");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload"); 
		int cnt = multiFile.size();
		
		String realPath = commonUtil.getRealPath(request);
		String[] pFileName = new String[cnt];
		String[] extend = new String[cnt];
        
        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", loginSimpleVO.getTenantId());

        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {
            for (int i = 0; i < cnt; i++) {
                String _pFileName = multiFile.get(i).getOriginalFilename();
                if (_pFileName.indexOf(commonUtil.separator) > 0) {
                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
                }
                pFileName[i] = _pFileName;
                
                if (pFileName[i].lastIndexOf(".") > -1) {
					extend[i] = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
				} else {
					extend[i] = "";
				}
            }
        }
        
        String pDirPath = commonUtil.getUploadPath("upload_task.ROOT", loginSimpleVO.getTenantId());

        pDirPath = realPath + pDirPath;
        
        logger.debug("pDirPath : " + pDirPath);
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        
        pDirPath = commonUtil.detectPathTraversal(pDirPath);
        
        File file = new File(pDirPath + "uploadFile");
        File tempFile = new File(pDirPath + "tempUploadFile");

        if (!file.exists()) {
        	file.mkdirs();
        }
        
        if (!tempFile.exists()) {
        	tempFile.mkdirs();
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {
            pFileName[i] = pFileName[i].replace("%2b", "+").replace("%3b", ";");
            
            String newFileName = "{" + UUID.randomUUID().toString() + "}";

			// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
            if ((extend[i].isEmpty() || useExtension.toLowerCase().indexOf(extend[i].toLowerCase()) == -1) && !useExtension.equals("*")) {           	
				strXML.append("<DATA><![CDATA[" + newFileName + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[" + pFileName[i] + "]]></DATA2>");
				strXML.append("<DATA3><![CDATA[" + multiFile.get(i).getSize() + "]]></DATA3>");
				strXML.append("<DATA4><![CDATA[denied]]></DATA4>");
            } else {
            	writeUploadedFile(multiFile.get(i), newFileName, pDirPath + "tempUploadFile");
            	
				strXML.append("<DATA><![CDATA[" + newFileName + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[" + pFileName[i] + "]]></DATA2>");
				strXML.append("<DATA3><![CDATA[" + multiFile.get(i).getSize() + "]]></DATA3>");
				strXML.append("<DATA4><![CDATA[OK]]></DATA4>");
            }
        }
        strXML.append("</NODES></ROOT>");
        
        logger.debug("uploadItemAttach ended");
        
        return strXML.toString();
    }

	/**
	 * 닫기 클릭시 임시첨부파일 삭제
	 */
	@RequestMapping(value = "/ezTask/tempUploadFileDelete.do", method = RequestMethod.POST)
	public String tempUploadFileDelete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		logger.debug("tempUploadFileDelete started");

		String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_task.ROOT", loginSimpleVO.getTenantId());
		String fileList = request.getParameter("fileList");
		String filePath = "tempUploadFile";
		
		logger.debug("fileList : " + fileList);

		if (fileList.length() != 0) {
			String[] data = fileList.split(","); 
			int dataLength = data.length;

			for (int i=0; i<dataLength; i++) {
				String sGUID = data[i];
				String fileDir = pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID;
				fileDir = commonUtil.detectPathTraversal(fileDir);
				
				File file = new File(fileDir);

				logger.debug("Delete FileList : " + file);

				file.delete();
			}			
		}

        logger.debug("tempUploadFileDelete ended");
        
        return "json";
    }

	/**
	 * 업무작성, 수정화면조회 조회
	 */
	@RequestMapping(value = "/ezTask/taskWrite.do", method = RequestMethod.GET)
	public String taskWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskWrite started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		String mode = "";
		
		if(request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useTodoMemo = ezCommonService.getTenantConfig("UseTodoMemo", tenantID);
		String realPath = commonUtil.detectPathTraversal(commonUtil.getRealPath(request));
		String flag = request.getParameter("flag") == null ? "" : request.getParameter("flag");
		
		String taskID = request.getParameter("taskID");
		TaskInfoVO taskInfoVO = null;
		List<TaskShareVO> taskShareList = null;
		List<TaskAttachVO> taskAttachList = null;
		StringBuilder strAttach = new StringBuilder();
		StringBuilder strShare = new StringBuilder();
		String startDate = "";
		String endDate = "";
		
		if (taskID == null) {
			/*업무작성*/
			taskID = "";

			String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false);
			startDate = nowDate.substring(0, 10) + " 00:00:00";
			endDate = nowDate.substring(0, 10) + " 23:59:59";
		} else {
			/*업무수정*/
			taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID, userInfo.getCompanyID());
			
			taskInfoVO.setMemo(taskInfoVO.getMemo().replace("<br>", "\n"));
			//업무공유자목록조회
			if (taskInfoVO.getHasShare().equals("Y")) {
				taskShareList = ezTaskService.getShareList(taskID, primary, tenantID);
				
				StringBuilder strShareName = new StringBuilder();
				StringBuilder strShareName1 = new StringBuilder();
				StringBuilder strShareName2 = new StringBuilder();
				StringBuilder strShareID = new StringBuilder();
				StringBuilder strShareDeptName = new StringBuilder();
				StringBuilder strShareDeptName2 = new StringBuilder();
				StringBuilder strShareEmail = new StringBuilder();
				
				for (TaskShareVO vo : taskShareList) {
					strShareName.append(vo.getSharerName() + ";");
					strShareName1.append(vo.getSharerName1() + ";");
					strShareName2.append(vo.getSharerName2() + ";");
					strShareID.append(vo.getSharerID() + ";");
					strShareDeptName.append(vo.getSharerDeptName() + ";");
					strShareDeptName2.append(vo.getSharerDeptName2() + ";");
					strShareEmail.append(vo.getSharerEmail() + ";");
                }
				
				strShare.append(strShareName.toString() + "||" + strShareName1.toString() + "||" + strShareName2.toString() + "||" + strShareID.toString() + "||" + strShareDeptName.toString() + "||" + strShareDeptName2 + "||" + strShareEmail.toString());
			}
			
			//첨부파일목록조회
			if (taskInfoVO.getHasAttach().equals("Y")) {
				taskAttachList = ezTaskService.getAttachList(taskID, realPath, "1", tenantID);
				
				strAttach.append("<ROOT><NODES>");
            	
				for (TaskAttachVO vo : taskAttachList) {
					strAttach.append("<DATA><![CDATA[" + vo.getFilePath().substring(vo.getTaskID().length() + 2) + "]]></DATA>");
					strAttach.append("<DATA2><![CDATA[" + vo.getFileName() + "]]></DATA2>");
					strAttach.append("<DATA3><![CDATA[" + vo.getFileSize() + "]]></DATA3>");
					strAttach.append("<DATA4><![CDATA[OK]]></DATA4>");
                }
				
				strAttach.append("</NODES></ROOT>");
			}
		}
		
		model.addAttribute("mode", mode);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useTodoMemo", useTodoMemo);
		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("taskShareList", taskShareList);
		model.addAttribute("taskShareListStr", strShare.toString());
		model.addAttribute("taskAttachList", strAttach.toString());
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("flag", flag);
		
		logger.debug("taskWrite ended.");
		
		return "/ezTask/taskWrite";
	}
	
	/**
     * 지시화면 목록 조회
     */
    @RequestMapping(value = "/ezTask/taskGetList.do", produces = "text/xml; charset=utf-8", method = RequestMethod.GET)
    @ResponseBody
    public String taskGetList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
    	logger.debug("taskGetList started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	String userID = userInfo.getId();
    	String primary = userInfo.getPrimary();
    	String offset = userInfo.getOffset();
    	int tenantID = userInfo.getTenantId();
    	String companyID = userInfo.getCompanyID();
    	
    	String type = request.getParameter("type");
    	String filter = request.getParameter("filter");
    	String chkValue = request.getParameter("chkValue");
    	String searchClass = request.getParameter("searchClass");
    	String taskStatusCount = request.getParameter("taskStatusCount");
    	String startDate = request.getParameter("startDate");
    	String endDate = request.getParameter("endDate");
    	String useDate = request.getParameter("useDate");
    	String pSelectTab = "";
    	
    	if(useDate == null || startDate == null) {
    		return "";
    	}
    	
    	if (request.getParameter("pSelectTab") != null) {
    		pSelectTab = request.getParameter("pSelectTab");
    	}
    	
    	// 검색 시 날짜사용 안하면 최근 3개월이내 검색
		if (useDate.equals("false")) {
			String utcTime = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date now = sdf.parse(utcTime);

			Calendar cal = Calendar.getInstance();
			cal.setTime(now);

			cal.add(Calendar.MONTH, -3);
			startDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, false).substring(0, 10);

			cal.setTime(now);
			cal.add(Calendar.MONTH, 3);
			endDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, false).substring(0, 10);    			
		}
		
		logger.debug("startDate: " +  startDate + "endDate: " +  endDate + "taskStatusCount: " +  taskStatusCount + "|| pSelectTab: " + pSelectTab + "|| Type: " + type);
		
    	List<TaskInfoVO> list = ezTaskService.getTaskList(userID, startDate, endDate, offset, type, filter, chkValue, searchClass, taskStatusCount, primary, pSelectTab, tenantID, companyID);   	
    	String cnt = ezTaskService.getTaskCount(userID, offset, type, filter, chkValue, primary, taskStatusCount, pSelectTab, tenantID, companyID);

    	logger.debug("cnt : " + cnt + " | listSize : " + list.size());

    	StringBuffer resultXML = new StringBuffer();
    	
    	resultXML.append("<DATA>");
    	
    	for (TaskInfoVO vo : list) {    		
    		//Baonk added			
    	
			if (pSelectTab.equals("taskrepetition")) { 				
				if (vo.getTotalRep() == -1) {
					vo.setEndDate("");
				}   				
			}
			
			/* 2021-09-03 홍승비 - 반복업무의 경우 진행상태 정보 테이블(TBL_TASKINSTANCESTATUS)에 저장되는 시작일의 시간 단위는 반드시 00:00:00이다. */
			if (pSelectTab.equals("") && (vo.getTaskType().equals("4") || vo.getTaskType().equals("5") || vo.getTaskType().equals("6"))) { // 일반업무 반복(4), 지시업무 반복(5), 협조업무 반복 (6)
				//Set percentage and status
				String realDate = vo.getStartDate(); // 진행상태 테이블에 저장된 그대로 사용 (시간단위 00:00:00)
				int status = ezTaskService.getStatusOfRepTask(vo.getTaskID(), realDate, tenantID);
				vo.setTaskStatus(status);				
    			int completionPercentage = ezTaskService.selectCompletionOfRepTask(vo.getTaskID(), realDate, tenantID);
    			//2021-09-28 남학선 해당로직이 서비스에서 반복업무 완료율을 가져오는 로직과 겹쳐서 덮어씌우는 문제가 생김 일단 분기를 만들되 필요하면 지우거나 수정
    			if(vo.getCompleteRate() == 0){
					vo.setCompleteRate(completionPercentage);
				}
			}
    		//end
    		
    		resultXML.append("<ROW>");
    		
    		resultXML.append("<TASKID>" + vo.getTaskID() + "</TASKID>");
    		resultXML.append("<CREATORID>" + vo.getCreatorID() + "</CREATORID>");
    		resultXML.append("<CREATORNAME>" + vo.getCreatorName() + "</CREATORNAME>");
    		resultXML.append("<CREATORNAME2>" + vo.getCreatorName2() + "</CREATORNAME2>");
    		resultXML.append("<TASKSTATUS>" + vo.getTaskStatus() + "</TASKSTATUS>");
    		resultXML.append("<COMPLETERATE>" + vo.getCompleteRate() + "</COMPLETERATE>");
    		resultXML.append("<IMPORTANCE>" + vo.getImportance() + "</IMPORTANCE>");
    		resultXML.append("<STARTDATE>" + vo.getStartDate() + "</STARTDATE>");
    		resultXML.append("<ENDDATE>" + vo.getEndDate() + "</ENDDATE>");
    		resultXML.append("<TITLE>" + commonUtil.cleanValue(vo.getTitle()) + "</TITLE>");
    		resultXML.append("<HASATTACH>" + vo.getHasAttach() + "</HASATTACH>");

    		List<TaskCommentVO> taskCommentList = null;
    		int commentLength = 0;

    		if (vo.getHasComment().equals("Y")) {
    			taskCommentList = ezTaskService.getCommentList(vo.getTaskID(), offset, primary, tenantID);
				commentLength = taskCommentList.size();
    		}

    		resultXML.append("<HASCOMMENT>" + commentLength + "</HASCOMMENT>");
    		resultXML.append("<PERSONID>" + vo.getPersonID() + "</PERSONID>");
    		resultXML.append("<PERSONNAME>" + vo.getPersonName() + "</PERSONNAME>");
    		resultXML.append("<PERSONNAME2>" + vo.getPersonName2() + "</PERSONNAME2>");
    		resultXML.append("<TASKTYPE>" + vo.getTaskType() + "</TASKTYPE>");
    		resultXML.append("<MEMO>" + commonUtil.cleanValue(vo.getMemo()) + "</MEMO>");
    		resultXML.append("<REPETITION>" + vo.getRepetition() + "</REPETITION>");
    		resultXML.append("<REPEATCOUNT>" + vo.getRepeatCount() + "</REPEATCOUNT>");
 		
    		resultXML.append("</ROW>");
    	}

    	resultXML.append("<CNT>" + cnt.split(",")[0] + "</CNT>");
    	resultXML.append("<CNT2>" + cnt.split(",")[1]+ "</CNT2>");
    	resultXML.append("<CNT3>" + cnt.split(",")[2]+ "</CNT3>");
    	resultXML.append("<ALLCNT>" + cnt.split(",")[3]+ "</ALLCNT>");

    	resultXML.append("</DATA>");

    	logger.debug("taskGetList ended.");
    	//logger.debug(resultXML.toString());

    	return resultXML.toString();
    }   
    
    @RequestMapping(value = "/ezTask/taskRepGetList.do", produces = "text/xml; charset=utf-8", method = RequestMethod.GET)
    @ResponseBody
    public String taskGetRepList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
    	logger.debug("taskGetRepList started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);    	
    	String primary = userInfo.getPrimary();
    	String offset = userInfo.getOffset();
    	int tenantID = userInfo.getTenantId();    	
    	String companyID = userInfo.getCompanyID();

    	String date = request.getParameter("currentDate");
    	String taskID = request.getParameter("taskID");
		
    	TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID, companyID);
    	taskInfoVO.setStartDate(date + " 00:00:00");
    	taskInfoVO.setEndDate(date + " 23:59:59");		
    	
		String realStartDate = date + " 00:00:00";
				
		int status = ezTaskService.getStatusOfRepTask(taskID, realStartDate, tenantID);
		taskInfoVO.setTaskStatus(status);
		int completionPercentage = ezTaskService.selectCompletionOfRepTask(taskID, realStartDate, tenantID);
		taskInfoVO.setCompleteRate(completionPercentage);    
		
		Map<String, Integer> result = ezTaskService.getRepTaskInfo(date, taskID, offset, primary, tenantID, taskInfoVO, companyID);
		taskInfoVO.setRepeatCount(result.get(date));		
		
		if (taskInfoVO.getPersonContentPath() == null) {
			taskInfoVO.setPersonContentPath("");
		} else {
			String personContentPath = taskInfoVO.getPersonContentPath();
			personContentPath = commonUtil.detectPathTraversal(personContentPath);
			personContentPath = commonUtil.stripScriptTags(personContentPath);
			
			taskInfoVO.setPersonContentPath(personContentPath);
		}
    	
		if (taskInfoVO.getContentPath() != null) {
			String contentPath = taskInfoVO.getContentPath();
			contentPath = commonUtil.detectPathTraversal(contentPath);
			contentPath = commonUtil.stripScriptTags(contentPath);
			
			taskInfoVO.setContentPath(contentPath);
		}
		
    	StringBuffer resultXML = new StringBuffer();
    	
    	resultXML.append("<DATA>"); 
    	
		resultXML.append("<ROW>");
		
		resultXML.append("<TASKID>" + taskInfoVO.getTaskID() + "</TASKID>");
		resultXML.append("<CREATORID>" + taskInfoVO.getCreatorID() + "</CREATORID>");
		resultXML.append("<CREATORNAME>" + taskInfoVO.getCreatorName() + "</CREATORNAME>");
		resultXML.append("<CREATORNAME2>" + taskInfoVO.getCreatorName2() + "</CREATORNAME2>");
		resultXML.append("<TASKSTATUS>" + taskInfoVO.getTaskStatus() + "</TASKSTATUS>");
		resultXML.append("<COMPLETERATE>" + taskInfoVO.getCompleteRate() + "</COMPLETERATE>");
		resultXML.append("<IMPORTANCE>" + taskInfoVO.getImportance() + "</IMPORTANCE>");
		resultXML.append("<STARTDATE>" + taskInfoVO.getStartDate() + "</STARTDATE>");
		resultXML.append("<ENDDATE>" + taskInfoVO.getEndDate() + "</ENDDATE>");
		resultXML.append("<TITLE>" + commonUtil.cleanValue(taskInfoVO.getTitle()) + "</TITLE>");
		resultXML.append("<HASATTACH>" + taskInfoVO.getHasAttach() + "</HASATTACH>");
		resultXML.append("<CONTENTPATH>" + taskInfoVO.getContentPath() + "</CONTENTPATH>");
		resultXML.append("<PERSONALCONTENTPATH>" + taskInfoVO.getPersonContentPath() + "</PERSONALCONTENTPATH>");
		

		List<TaskCommentVO> taskCommentList = null;
		int commentLength = 0;

		if (taskInfoVO.getHasComment().equals("Y")) {			
			taskCommentList = ezTaskService.getCommentList(taskInfoVO.getTaskID(), offset, primary, tenantID);
			commentLength = taskCommentList.size();
		}

		resultXML.append("<HASCOMMENT>" + commentLength + "</HASCOMMENT>");
		resultXML.append("<PERSONID>" + taskInfoVO.getPersonID() + "</PERSONID>");
		resultXML.append("<PERSONNAME>" + taskInfoVO.getPersonName() + "</PERSONNAME>");
		resultXML.append("<PERSONNAME2>" + taskInfoVO.getPersonName2() + "</PERSONNAME2>");
		resultXML.append("<TASKTYPE>" + taskInfoVO.getTaskType() + "</TASKTYPE>");
		resultXML.append("<MEMO>" + commonUtil.cleanValue(taskInfoVO.getMemo()) + "</MEMO>");
		resultXML.append("<REPETITION>" + taskInfoVO.getRepetition() + "</REPETITION>");
		resultXML.append("<REPEATCOUNT>" + taskInfoVO.getRepeatCount() + "</REPEATCOUNT>");
	
		resultXML.append("</ROW>");
    	

    	resultXML.append("</DATA>");

    	logger.debug("taskGetRepList ended.");
    	//logger.debug(resultXML.toString());

    	return resultXML.toString();
    }	
    
    /**
	 * 업무 삭제 Method
	 */
	@RequestMapping(value = "/ezTask/taskDelete.do", method = RequestMethod.POST)
	public String taskDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskDelete started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		String taskIDList = request.getParameter("taskIDList");

		String realPath = commonUtil.detectPathTraversal(commonUtil.getRealPath(request));

		String pDirPath = commonUtil.getUploadPath("upload_task.ROOT", userInfo.getTenantId());
        pDirPath = realPath + pDirPath;

        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }

        ezTaskService.taskDelete(taskIDList, pDirPath, offset, primary, userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());

		logger.debug("taskDelete ended.");

		return "json";
	}
	
	/**
	 * 조직도 부서 호출
	 */
	@RequestMapping(value = "/ezTask/taskCheckName2.do", method = RequestMethod.GET)
	public String taskCheckName2() throws Exception {
		logger.debug("taskCheckName2 started.");

		logger.debug("taskCheckName2 ended.");

		return "/ezTask/taskCheckName2";
	}

	/**
	 * 업무관리 기본설정
	 */
	@RequestMapping(value = "/ezTask/taskGeneral.do", method = RequestMethod.GET)
	public String taskGeneral(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("taskGeneral started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		TaskGeneralVO taskGeneralVO = ezTaskService.getTaskGeneral(userInfo.getId(), userInfo.getTenantId());

		model.addAttribute("taskGeneralVO", taskGeneralVO);

		logger.debug("taskGeneral ended.");

		return "/ezTask/taskGeneral";
	}
	
	/**
	 * 업무관리 기본설정 저장
	 */
	@RequestMapping(value = "/ezTask/taskSaveGeneral.do", method = RequestMethod.POST)
	public String taskSaveGeneral(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskSaveGeneral started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int listCount = Integer.parseInt(request.getParameter("listCount"));
		String selectTaskStatus = request.getParameter("selectTaskStatus");
		selectTaskStatus = commonUtil.stripScriptTags(selectTaskStatus);
		
		ezTaskService.updateTaskGeneral(userInfo.getId(), listCount, selectTaskStatus, userInfo.getTenantId());

		logger.debug("taskSaveGeneral ended.");

		return "json";
	}
	
	/**
	 * 업무관리 기본설정 저장
	 */
	@RequestMapping(value = "/ezTask/taskRepetition.do", method = RequestMethod.GET)
	public String taskRepetition(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskRepetition started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userInfo", userInfo);

		logger.debug("taskRepetition ended.");

		return "/ezTask/taskRepetition";
	}
	
	/**
	 * 업무관리 반복일정 선택 후 삭제 시 팝업 
	 */	
	@RequestMapping(value="/ezTask/taskDeleteConfirm.do", method = RequestMethod.GET)	
	public String taskDeleteConfirm() throws Exception {
		logger.debug("taskDeleteConfirm started.");
		
		logger.debug("taskDeleteConfirm ended.");
		
		return "/ezTask/taskDeleteConfirm";
	}
	
	/**
	 * 업무관리 반복일정 해당일정만 삭제
	 */	
	@RequestMapping(value="/ezTask/taskOnceDelete.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public void taskOnceDelete(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		logger.debug("taskOnceDelete started.");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String taskID = request.getParameter("taskID");
		String repeatCount = request.getParameter("repeatCount");
		String taskStatus = request.getParameter("taskStatus");
		String completeRate = request.getParameter("completeRate");
		String selectDate = request.getParameter("selectDate");
		String startDate = request.getParameter("startDate");		
		String realStartDate = selectDate + "" + startDate.substring(10, 19);		

		String realDate = commonUtil.getDateStringInUTC(realStartDate, loginSimpleVO.getOffset(), true);
		
		//Baonk added
		ezTaskService.updateNumberOfTotalReps(taskID, loginSimpleVO.getTenantId());
		//end

		//일정데이터 삭제
		ezTaskService.insertTaskRepeDel(taskID, repeatCount, taskStatus, completeRate, realDate, loginSimpleVO.getTenantId());
		
		logger.debug("taskOnceDelete ended.");
	}
	
	/**
	 * 2018-08-13 김보미
	 * 업무관리 업무보기 인쇄 화면
	 */
	@RequestMapping(value = "/ezTask/taskReadPrint.do", method = RequestMethod.GET)
	public String taskReadPrint(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskRead started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userID = userInfo.getId();
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		String companyID = userInfo.getCompanyID();
		
		String useTodoMemo = ezCommonService.getTenantConfig("UseTodoMemo", tenantID);
		String folderPath = commonUtil.getUploadPath("upload_task.ROOT", tenantID) + commonUtil.separator + "uploadFile";
		
		String taskID = commonUtil.stripScriptTags(request.getParameter("taskID"));		
		String date = commonUtil.stripScriptTags(request.getParameter("date"));
		String selectedDate = commonUtil.stripScriptTags(request.getParameter("date"));
		String calDate = commonUtil.stripScriptTags(request.getParameter("calDate"));
		String type = (request.getParameter("type") == null ? "" : commonUtil.stripScriptTags(request.getParameter("type")));
		String dateList = "";
		String completeRateList = "";
		String statusList = "";	
		String repeatCntList = "";
		Map<String, Integer> result = new LinkedHashMap<String, Integer>();

		//업무정보 조회
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID, userInfo.getCompanyID());

		//의견목록 조회
		List<TaskCommentVO> taskCommentList = null;
		if (taskInfoVO.getHasComment().equals("Y")) {			
			taskCommentList = ezTaskService.getCommentList(taskID, offset, primary, tenantID);
		}
		
		//업무공유자목록조회
		List<TaskShareVO> taskShareList = null;
		if (taskInfoVO.getHasShare().equals("Y")) {
			taskShareList = ezTaskService.getShareList(taskID, primary, tenantID);
		}
		
		//task첨부파일목록조회
		String taskAttachList = null;
		if (taskInfoVO.getHasAttach().equals("Y")) {
			taskAttachList = ezTaskService.getAttachListStr(taskID, folderPath, "1", tenantID);
		}
		
		//taskWork첨부파일목록조회
		String taskWorkAttachList = null;
		if (taskInfoVO.getPersonAttach().equals("Y")) {
			taskWorkAttachList  = ezTaskService.getAttachListStr(taskID, folderPath, "2", tenantID);
		}
		
		if (taskInfoVO.getTaskType().equals("4") || taskInfoVO.getTaskType().equals("5") || taskInfoVO.getTaskType().equals("6")) {
			SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String endDate = "";	
			
			String[] offsetArr = offset.split("\\|");				
			nsdf.setTimeZone(TimeZone.getTimeZone("GMT" + offsetArr[1]));
			String dayText = calDate + " 00:00:00";
			Date day = sdf.parse(dayText); 
	        Calendar calendar1 = Calendar.getInstance();  
	        calendar1.setTime(day); 
	        
			if (taskInfoVO.getTotalRep() != -1) {
				endDate = taskInfoVO.getEndDate();
				Date taskEndDate = sdf.parse(endDate); 
		        Calendar calendar2 = Calendar.getInstance();  
		        calendar2.setTime(taskEndDate);         
		        
		        if (calendar1.compareTo(calendar2) >= 0) {
		        	result = ezTaskService.getRepTaskInfo(endDate.substring(0, 10), taskID, offset, primary, tenantID, taskInfoVO, companyID);
		        	date = endDate.substring(0, 10);
		        }
		        else {		        	
		        	result = ezTaskService.getRepTaskInfo(calDate, taskID, offset, primary, tenantID, taskInfoVO, companyID);
		        	
		        	for (String d: result.keySet()) {	        			        		
		        		Date dDate = sdf.parse(d + " 00:00:00"); 
		    	        Calendar calendar3 = Calendar.getInstance();  
		    	        calendar3.setTime(dDate); 
		    	        
		    	        if (calendar3.compareTo(calendar1) >= 0) {		    	        	
		    	        	date = d;
		    	        	break;
		    	        }
		        	}
		        }		        		        
			}
			else {				
				result = ezTaskService.getRepTaskInfo(calDate, taskID, offset, primary, tenantID, taskInfoVO, companyID);
				
	        	for (String d: result.keySet()) {
	        		Date dDate = sdf.parse(d + " 00:00:00"); 
	    	        Calendar calendar3 = Calendar.getInstance();  
	    	        calendar3.setTime(dDate); 
	    	        
	    	        if (calendar3.compareTo(calendar1) >= 0) {
	    	        	date = d;
	    	        	break;
	    	        }
	        	}
			}					        
			
			for (Map.Entry<String, Integer> entry : result.entrySet()) {
	            String key = entry.getKey();
	            Integer value = entry.getValue();	
	            
				dateList += key + ",";
				String convertDate = key + " 00:00:00";
				int comRate = ezTaskService.selectCompletionOfRepTask(taskID, convertDate, tenantID);
				completeRateList += Integer.toString(comRate) + ",";
				
				int status = ezTaskService.getStatusOfRepTask(taskID, convertDate, tenantID);
				statusList += Integer.toString(status) + ",";
				repeatCntList += value + ",";
	        }
			
			dateList = dateList.substring(0, dateList.length() - 1);
			completeRateList = completeRateList.substring(0, completeRateList.length() - 1);
			statusList = statusList.substring(0, statusList.length() - 1);
			repeatCntList = repeatCntList.substring(0, repeatCntList.length() - 1);
			
			String realStartDate = date + " 00:00:00";
			String realDate = commonUtil.getDateStringInUTC(realStartDate, userInfo.getOffset(), true);
			int status = ezTaskService.getStatusOfRepTask(taskID, realDate, tenantID);
			taskInfoVO.setTaskStatus(status);
			int completionPercentage = ezTaskService.selectCompletionOfRepTask(taskID, realDate, tenantID);
			taskInfoVO.setCompleteRate(completionPercentage);			
			taskInfoVO.setRepeatCount(result.get(date));	        			
		}	
		//end

		TaskConfigVO configVO = ezTaskService.getOriginColor(userID, tenantID);

		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("taskShareList", taskShareList);
		model.addAttribute("taskAttachList", taskAttachList);
		model.addAttribute("taskWorkAttachList", taskWorkAttachList);
		model.addAttribute("taskCommentList", taskCommentList);
		model.addAttribute("taskCommentListSize", taskCommentList == null ? "0" : taskCommentList.size());
		model.addAttribute("type", type);
		model.addAttribute("delayColor", configVO.getDelayColor());
		model.addAttribute("completeColor", configVO.getCompleteColor());
		model.addAttribute("useTodoMemo", useTodoMemo);
		model.addAttribute("repeatCount", taskInfoVO.getRepeatCount());
		model.addAttribute("date", date);
		model.addAttribute("selectedDate", selectedDate);
		model.addAttribute("repetition", taskInfoVO.getRepetition());
		model.addAttribute("dateList", dateList);	
		model.addAttribute("completeRateList", completeRateList);
		model.addAttribute("statusList", statusList);	
		model.addAttribute("repeatCntList", repeatCntList);
		
		return "/ezTask/taskReadPrint";
	}
	
	/** 2019.01.30 유은정 - schedule left와 task left 분리*/
	@RequestMapping(value = "/ezTask/taskLeft.do", method = RequestMethod.GET)
	public String taskLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		logger.debug("taskLeft started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userID = userInfo.getId();
		int tenantID = userInfo.getTenantId();
		TaskGeneralVO taskGeneralVO = ezTaskService.getTaskGeneral(userID, tenantID);

		if (taskGeneralVO == null) {
			ezTaskService.taskSaveGeneral(userID, 10, "taskprog", tenantID);
			taskGeneralVO = ezTaskService.getTaskGeneral(userID, tenantID);
		}
		
		String defaultView = taskGeneralVO.getSelectTaskStatus();

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("taskGeneralVO", taskGeneralVO);
		model.addAttribute("defaultView", defaultView);
		
		logger.debug("taskLeft ended");
		return "/ezTask/taskLeft";
	}
	
	@RequestMapping(value = "/ezTask/taskIndex.do", method = RequestMethod.GET)
	public String taskIndex(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		logger.debug("taskIndex started");

		String leftFrameWidth = "220";
		int width = 0;

		if (request.getParameter("__wwidth") != null) {
			String widthParam = request.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}

		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("taskIndex ended");
		return "/ezTask/taskIndex";
	}
	
}
