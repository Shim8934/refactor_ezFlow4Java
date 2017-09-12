package egovframework.ezEKP.ezTask.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.ibm.icu.text.SimpleDateFormat;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezTask.service.EzTaskService;
import egovframework.ezEKP.ezTask.vo.TaskAttachVO;
import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskConfigVO;
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

	/* 이효진*/

	/**
	 * 업무관리 메인화면
	 */
	@RequestMapping(value="/ezTask/taskMain.do")
	public String taskMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskMain started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userID = userInfo.getId();
		int tenantID = userInfo.getTenantId();
		
		String useTodoMemo = ezCommonService.getTenantConfig("UseTodoMemo", tenantID);

		TaskConfigVO configVO = ezTaskService.getOriginColor(userID, tenantID);

		if (configVO == null) {
			ezTaskService.taskSaveConfig(userInfo.getId(), "#ff0000", "#00ff00", userInfo.getTenantId());
			configVO = ezTaskService.getOriginColor(userID, tenantID);
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("delayColor", configVO.getDelayColor());
		model.addAttribute("completeColor", configVO.getCompleteColor());
		model.addAttribute("useTodoMemo", useTodoMemo);

		logger.debug("taskMain ended.");

		return "/ezTask/taskMain";
	}

	/**
	 * 업무상세화면 조회
	 */
	@RequestMapping(value = "/ezTask/taskRead.do")
	public String taskRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
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
		String type = (request.getParameter("type") == null ? "" : request.getParameter("type"));

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
			taskShareList = ezTaskService.getShareList(taskID, offset, primary, tenantID);
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
		
		logger.debug("taskRead ended.");
		
		return "/ezTask/taskRead";
	}
	
	/**
	 *  업무상세화면 의견목록 조회
	 */
	@RequestMapping(value = "/ezTask/getTaskCommentList.do")
	public String getTaskCommentList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getTaskCommentList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String taskID = request.getParameter("taskID");
		
		List<TaskCommentVO> taskCommentList = ezTaskService.getCommentList(taskID, userInfo.getOffset(), userInfo.getPrimary(), userInfo.getTenantId());
		
		model.addAttribute("taskCommentList", taskCommentList);
		
		logger.debug("getTaskCommentList ended.");
		
		return "json";
	}
	
	/**
	 * 업무작성 저장 Method
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezTask/taskSave.do")
	public String taskSave(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskSave started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
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
		taskInfoVO.setContentPath(param.get("contentPath").toString());
		taskInfoVO.setMemo(param.get("memo").toString());
		
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
		
		ezTaskService.taskSave(taskInfoVO, realPath, uploadTaskPath, content, fileList, fileName, fileSize, userInfo.getOffset(), tenantID);

		logger.debug("taskSave ended");
		
		return "json";
	}
	
	
	/**
	 * 진행사항 수정화면 조회
	 */
	@RequestMapping(value = "/ezTask/taskWorkWrite.do")
	public String taskWorkWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskWorkWrite started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		
		String taskID = request.getParameter("taskID");
		
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, userInfo.getOffset(), userInfo.getPrimary(), userInfo.getTenantId());
		
		//첨부파일목록조회
		StringBuilder strAttach = new StringBuilder();
		if (taskInfoVO.getPersonAttach().equals("Y")) {
			List<TaskAttachVO> taskWorkAttachList = ezTaskService.getAttachList(taskID, realPath, "2", tenantID);
			
			strAttach.append("<ROOT><NODES>");
	    	
			for (TaskAttachVO vo : taskWorkAttachList) {
				strAttach.append("<DATA><![CDATA[" + vo.getFilePath().substring(vo.getTaskID().length() + 2) + "]]></DATA>");
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
	@RequestMapping(value = "/ezTask/taskWorkSave.do")
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
		
		String personContentPath = ezTaskService.taskWorkSave(taskID, content, attachList, fileName, fileSize, personAttach, contentPath, realPath, uploadTaskPath, tenantID);
		
		logger.debug("taskWorkSave ended.");
		
		model.addAttribute("personContentPath", personContentPath);
		
		return "json";
	}
	
	/**
	 * 진행상태 수정 Method
	 */
	@RequestMapping(value = "/ezTask/updateTaskStatus.do")
	public String updateTaskStatus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskUpdateInstance started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String taskID = request.getParameter("taskID");
		String taskStatus = request.getParameter("taskStatus");
		String completeRate = request.getParameter("completeRate");
		
		ezTaskService.updateTaskStatus(taskID, taskStatus, completeRate, userInfo.getTenantId());
		
		logger.debug("updateTaskStatus ended.");
		
		return "json";
	}
	
	/**
	 * 의견작성 Method
	 */
	@RequestMapping(value = "/ezTask/taskSaveComment.do")
	public String taskSaveComment(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskSaveComment started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		String taskID = request.getParameter("taskID");
		String textComment = request.getParameter("textComment");
		
		int result = ezTaskService.insertComment(taskID, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), textComment, tenantID);
		
		model.addAttribute("result", result);
		
		logger.debug("taskSaveComment ended.");
		
		return "json";
	}
	
	/** 의견삭제 Method*/
	@RequestMapping(value = "/ezTask/taskDeleteComment.do")
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
	@RequestMapping(value = "/ezTask/taskSelectEntity.do")
	public String taskSelectEntity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskSelectEntity started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Locale locale = userInfo.getLocale();
		String type = request.getParameter("type");
		
		model.addAttribute("type", type);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("title", type.equals("1") ? egovMessageSource.getMessage("ezTask.t2005", locale) : egovMessageSource.getMessage("ezTask.t157", locale));
		
		logger.debug("taskSelectEntity ended.");
		
		return "/ezTask/taskSelectEntity";
	}
	
	/**
	 * 진행상태 수정화면 조회
	 */
	@RequestMapping(value = "/ezTask/taskStatus.do")
	public String taskStatus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskStatus started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		String taskID = request.getParameter("taskID");
		
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, userInfo.getOffset(), userInfo.getPrimary(), tenantID);
		TaskConfigVO configVO = ezTaskService.getOriginColor(userInfo.getId(), tenantID);
		
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
	@RequestMapping(value = "/ezTask/downloadAttach.do")
	public void downloadAttach(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadAttach started.");

		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
		String realPath = commonUtil.getRealPath(request);

		if (fileName == null || fileName.equals("")) {
			fileName = filePath;
		}

		String fullFilePath = realPath + filePath;

		logger.debug("fullFilePath : " + fullFilePath + " | fileName : " + fileName);

		downFile(request, response, fullFilePath, fileName);

		logger.debug("downloadAttach ended.");
	}
	
	/**
	 * 첨부파일 목록조회
	 */
	@RequestMapping(value = "/ezTask/getTaskWorkAttachList.do")
	public String getAttachList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getAttachList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		
		String folderPath = commonUtil.getUploadPath("upload_task.ROOT", tenantID) + commonUtil.separator + "uploadFile";
		
		String taskID = request.getParameter("taskID");
		
		//업무정보 조회
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID);
		
		//taskWork첨부파일목록조회
		String taskWorkAttachList = null;
		if (taskInfoVO.getPersonAttach().equals("Y")) {
			taskWorkAttachList  = ezTaskService.getAttachListStr(taskID, folderPath, "2", tenantID);
		}
		
		model.addAttribute("hasTaskWorkAttach", taskInfoVO.getPersonAttach());
		model.addAttribute("taskWorkAttachList", taskWorkAttachList);
		
		logger.debug("getAttachList ended.");
		
		return "json";
	}
	
	/* 정수현*/
	
	/**
	 * 업무관리 환경설정
	 */
	@RequestMapping(value = "/ezTask/taskConfig.do")
	public String taskConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskConfig started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		TaskConfigVO configVO = ezTaskService.getOriginColor(userInfo.getId(), userInfo.getTenantId());

		logger.debug("delayColor : " + configVO.getDelayColor() + " | completeColor : " + configVO.getCompleteColor());

		model.addAttribute("delayColor", configVO.getDelayColor());
		model.addAttribute("completeColor", configVO.getCompleteColor());

		logger.debug("taskConfig ended.");

		return "/ezTask/taskConfig";
	}
	
	/**
	 * 색상선택 화면 호출
	 */
	@RequestMapping(value = "/ezTask/taskManyColor.do")
	public String taskManyColor() throws Exception {
		logger.debug("taskManyColor started.");
		
		logger.debug("taskManyColor ended.");
		
		return "/ezTask/taskManyColor";
	}

	/**
	 * 업무관리 색상 저장
	 */
	@RequestMapping(value = "/ezTask/taskSaveConfig.do")
	public String taskSaveConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("taskSaveConfig started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String delayColor = request.getParameter("delayColor");
		String completeColor = request.getParameter("completeColor");

		TaskConfigVO configVO = ezTaskService.getOriginColor(userInfo.getId(), userInfo.getTenantId());

		logger.debug("originDelayColor : " + configVO.getDelayColor() + " | originCompleteColor : " + configVO.getCompleteColor());
		
		if (configVO != null) {
			ezTaskService.taskUpdateConfig(userInfo.getId(), delayColor, completeColor, userInfo.getTenantId());
		}

		logger.debug("taskSaveConfig ended.");

		return "json";
	}

	/**
	 * 업무관리 검색
	 */
	@RequestMapping(value = "/ezTask/taskSearch.do")
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
	@RequestMapping(value = "/ezTask/dragAndDrop.do")
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
	@RequestMapping(value = "/ezTask/uploadItemAttach.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadItemAttach(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception{
		logger.debug("uploadItemAttach started");
		
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

        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {        	
            for (int i = 0; i < cnt; i++) {
                String _pFileName = multiFile.get(i).getOriginalFilename();
                if (_pFileName.indexOf(commonUtil.separator) > 0) {
                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
                }
                pFileName[i] = _pFileName;
            }
        }
        
        String pDirPath = commonUtil.getUploadPath("upload_task.ROOT", loginSimpleVO.getTenantId());

        pDirPath = realPath + pDirPath;
        
        logger.debug("pDirPath : " + pDirPath);
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }

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
        	resultUpload[i] = "false";
            sGUID[i] = UUID.randomUUID().toString();
            pUploadSN[i] = "{" + sGUID[i] + "}";
            
            pFileName[i] = pFileName[i].replace("%2b", "+");
            pFileName[i] = pFileName[i].replace("%3b", ";");
            
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            String newFileName = pUploadSN[i];

            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1 && !useExtension.equals("*")) {           	
				strXML.append("<DATA><![CDATA[" + newFileName + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[" + pFileName[i] + "]]></DATA2>");
				strXML.append("<DATA3><![CDATA[" + fileSize[i] + "]]></DATA3>");
				strXML.append("<DATA4><![CDATA[denied]]></DATA4>");
            } else {
            	writeUploadedFile(multiFile.get(i), newFileName, pDirPath + "tempUploadFile");
            	
				strXML.append("<DATA><![CDATA[" + newFileName + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[" + pFileName[i] + "]]></DATA2>");
				strXML.append("<DATA3><![CDATA[" + fileSize[i] + "]]></DATA3>");
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
	@RequestMapping(value = "/ezTask/tempUploadFileDelete.do")
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

				File file = new File(pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID);

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
	@RequestMapping(value = "/ezTask/taskWrite.do")
	public String taskWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskWrite started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useTodoMemo = ezCommonService.getTenantConfig("UseTodoMemo", tenantID);
		String realPath = commonUtil.getRealPath(request);
		
		String taskID = request.getParameter("taskID");
		TaskInfoVO taskInfoVO = null;
		List<TaskShareVO> taskShareList = null;
		List<TaskAttachVO> taskAttachList = null;
		StringBuilder strAttach = new StringBuilder();
		StringBuilder strShare = new StringBuilder();
		
		if (taskID == null) {
			/*업무작성*/
			taskID = "";
		} else {
			/*업무수정*/
			taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID);
			
			taskInfoVO.setMemo(taskInfoVO.getMemo().replace("<br>", "\n"));
			//업무공유자목록조회
			if (taskInfoVO.getHasShare().equals("Y")) {
				taskShareList = ezTaskService.getShareList(taskID, offset, primary, tenantID);
				
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
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useTodoMemo", useTodoMemo);
		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("taskShareList", taskShareList);
		model.addAttribute("taskShareListStr", strShare.toString());
		model.addAttribute("taskAttachList", strAttach.toString());
		
		logger.debug("taskWrite ended.");
		
		return "/ezTask/taskWrite";
	}
	
	/**
     * 지시화면 목록 조회
     * 
     */
    @RequestMapping(value = "/ezTask/taskGetList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String taskGetList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
    	logger.debug("taskGetList started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	String userID = userInfo.getId();
    	String primary = userInfo.getPrimary();
    	String offset = userInfo.getOffset();
    	int tenantID = userInfo.getTenantId();
    	
    	String type = request.getParameter("type");
    	String filter = request.getParameter("filter");
    	String chkValue = request.getParameter("chkValue");
    	String searchClass = request.getParameter("searchClass");
    	String taskStatusCount = request.getParameter("taskStatusCount");
    	String startDate = request.getParameter("startDate");
    	String endDate = request.getParameter("endDate");
    	String useDate = "";

    	if (startDate != null || !startDate.equals("")) {
    		useDate = request.getParameter("useDate");
    	}

    	// 검색 시 날짜사용 안하면 최근 3개월이내 검색
    	if (useDate != null) {
    		if (!useDate.equals("true")) {
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
    	}

    	List<TaskInfoVO> list = ezTaskService.getTaskList(userID, startDate, endDate, offset, type, filter, chkValue, searchClass, taskStatusCount, tenantID);
    	String cnt = ezTaskService.getTaskCount(userID, offset, type, filter, chkValue, tenantID);

    	logger.debug("cnt : " + cnt + " | listSize : " + list.size());

    	StringBuffer resultXML = new StringBuffer();
    	
    	resultXML.append("<DATA>");
    	
    	for (TaskInfoVO vo : list) {
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
    		
    		resultXML.append("</ROW>");
    	}

    	resultXML.append("<CNT>" + cnt.split(",")[0] + "</CNT>");
    	resultXML.append("<CNT2>" + cnt.split(",")[1]+ "</CNT2>");

    	resultXML.append("</DATA>");

    	logger.debug("taskGetList ended.");

    	return resultXML.toString();
    }
    
    /**
	 * 업무 삭제 Method
	 */
	@RequestMapping(value = "/ezTask/taskDelete.do")
	public String taskDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskDelete started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		String taskIDList = request.getParameter("taskIDList");

		String pDirPath = "";
		String realPath = request.getServletContext().getRealPath("");

		pDirPath = commonUtil.getUploadPath("upload_task.ROOT", userInfo.getTenantId());
        pDirPath = realPath + pDirPath;

        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }

        ezTaskService.taskDelete(taskIDList, pDirPath, offset, primary, userInfo.getId(), userInfo.getTenantId());

		logger.debug("taskDelete ended.");

		return "json";
	}
	
	/**
	 * 조직도 부서 호출
	 */
	@RequestMapping(value = "/ezTask/taskCheckName2.do")
	public String taskCheckName2() throws Exception {
		logger.debug("taskCheckName2 started.");

		logger.debug("taskCheckName2 ended.");

		return "/ezTask/taskCheckName2";
	}
}
