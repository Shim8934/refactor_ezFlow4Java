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
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezTask.service.EzTaskService;
import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskFileVO;
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
		
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		Date curretnTime = new Date();
//
//		String initDate = sdf.format(curretnTime);

		//delayColor
		String delayColor = ezTaskService.getDelayColor(userID, tenantID);

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("delayColor", delayColor);
//		model.addAttribute("initDate", initDate);

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
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String folderPath = commonUtil.getRealPath(request) + commonUtil.separator + commonUtil.getUploadPath("upload_task.ROOT", tenantID) + commonUtil.separator;
		
		String taskID = request.getParameter("taskID");
		String type = (request.getParameter("type") == null ? "" : request.getParameter("type"));

		//업무정보 조회
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID);
		
		String parentID = taskInfoVO.getParentID();
		
		//의견목록 조회
		List<TaskCommentVO> taskCommentList = null;
		if (taskInfoVO.getHasComment().equals("Y")) {
			if (parentID.equals("0")) {
				taskCommentList = ezTaskService.getCommentList(taskID, offset, primary, tenantID);
			} else {
				taskCommentList = ezTaskService.getCommentList(parentID, offset, primary, tenantID);
			}
		}
		
		//업무공유자목록조회
		List<TaskShareVO> taskShareList = null;
		if (taskInfoVO.getHasShare().equals("Y")) {
			if (parentID.equals("0")) {
				taskShareList = ezTaskService.getShareList(taskID, offset, primary, tenantID);
			} else {
				taskShareList = ezTaskService.getShareList(parentID, offset, primary, tenantID);
			}
		}
		
		//첨부파일목록조회
		List<TaskFileVO> taskFileList = null;
		if (taskInfoVO.getHasAttach().equals("Y")) {
			if (parentID.equals("0")) {
				taskFileList = ezTaskService.getAttachList(taskID);
			} else {
				taskFileList = ezTaskService.getAttachList(parentID);
			}
		}
		
		//delayColor
		String delayColor = ezTaskService.getDelayColor(userID, tenantID);
		
		/*
	    var personlist = "${personList }";
	    var content = "${contentPerson }";
	    var date = "${date }";
	    var attachFileInfo = "${attachFileInfo }";
	    var optioncnt = "${optionCnt }";
	    var tempbody = "";
	    */
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("taskShareList", taskShareList);
		/*model.addAttribute("taskAttachList", taskAttachList);*/
		model.addAttribute("taskCommentList", taskCommentList);
		model.addAttribute("taskCommentListSize", taskCommentList == null ? "0" : taskCommentList.size());
		
		
		model.addAttribute("type", type);
		model.addAttribute("delayColor", delayColor);
		
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("folderPath", folderPath);
		
		logger.debug("taskRead ended.");
		
		return "/ezTask/taskRead";
	}
	
	/**
	 * 지시사항 수정 Method
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezTask/taskSave.do")
	public String taskSave1(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskSave1 started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		String realPath = commonUtil.getRealPath(request);
		String uploadTaskPath = commonUtil.getUploadPath("upload_task.ROOT", tenantID);
		String content = param.get("content").toString();
		String fileList = param.get("fileList").toString();
		
		TaskInfoVO taskInfoVO = new TaskInfoVO();
		taskInfoVO.setTaskID(param.get("taskID").toString());
		taskInfoVO.setOwnerID(param.get("ownerID").toString());
		taskInfoVO.setCreatorID(param.get("creatorID").toString());
		taskInfoVO.setCreatorName(param.get("creatorName").toString());
		taskInfoVO.setCreatorName2(param.get("creatorName2").toString());
		taskInfoVO.setPersonID(param.get("personID").toString());
		taskInfoVO.setPersonName(param.get("personName").toString());
		taskInfoVO.setPersonName2(param.get("personName2").toString());
		taskInfoVO.setPersonDeptName(param.get("personDeptName").toString());
		taskInfoVO.setPersonDeptName2(param.get("personDeptName2").toString());
		taskInfoVO.setHasShare(param.get("hasShare").toString());
		taskInfoVO.setTaskType(param.get("taskType").toString());
		taskInfoVO.setTaskStatus(Integer.parseInt(param.get("taskStatus").toString()));
		taskInfoVO.setCompleteRate(Integer.parseInt(param.get("completeRate").toString()));
		taskInfoVO.setImportance(Integer.parseInt(param.get("importance").toString()));
		taskInfoVO.setStartDate(param.get("startDate").toString());
		taskInfoVO.setEndDate(param.get("endDate").toString());
		taskInfoVO.setTitle(param.get("title").toString());
		taskInfoVO.setHasAttach(param.get("hasAttach").toString());
		taskInfoVO.setContentPath(param.get("contentPath").toString());
		
		List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("shareList");
		List<TaskShareVO> shareList = new ArrayList<TaskShareVO>();
		
		for (Map<String, Object> map : list) {
			TaskShareVO shareVO = new TaskShareVO();
			logger.debug("sharerID = " + map.get("sharerID").toString());
			logger.debug("sharerName = " + map.get("sharerName").toString());
			logger.debug("sharerName2 = " + map.get("sharerName2").toString());
			logger.debug("sharerDeptName = " + map.get("sharerDeptName").toString());
			logger.debug("sharerDeptName2 = " + map.get("sharerDeptName2").toString());
			shareVO.setSharerID(map.get("sharerID").toString());
			shareVO.setSharerName(map.get("sharerName").toString());
			shareVO.setSharerName2(map.get("sharerName2").toString() != null ? map.get("sharerName2").toString() : "");
			shareVO.setSharerDeptName(map.get("sharerDeptName").toString());
			shareVO.setSharerDeptName2(map.get("sharerDeptName2").toString() != null ? map.get("sharerDeptName2").toString() : "");
			shareList.add(shareVO);
		}
		
		taskInfoVO.setShareList(shareList);
		
		ezTaskService.taskSave(taskInfoVO, realPath, uploadTaskPath, content, fileList, userInfo.getOffset(), tenantID);

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
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		String taskID = request.getParameter("taskID");
		
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, userInfo.getOffset(), userInfo.getPrimary(), userInfo.getTenantId());
		
		//첨부파일목록조회
		if (taskInfoVO.getHasAttach().equals("Y")) {
//			getAttachList(taskID);
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		
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
		String contentPath = request.getParameter("contentPath");
		
		ezTaskService.taskWorkSave(taskID, content, attachList, contentPath, realPath, uploadTaskPath, tenantID);
		
		logger.debug("taskWorkSave ended.");
		
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
		
		List<TaskCommentVO> taskCommentList = ezTaskService.getCommentList(taskID, userInfo.getOffset(), userInfo.getPrimary(), tenantID);
		
		model.addAttribute("result", result);
		model.addAttribute("taskCommentList", taskCommentList);
		
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
		
		List<TaskCommentVO> taskCommentList = ezTaskService.getCommentList(taskID, userInfo.getOffset(), userInfo.getPrimary(), tenantID);
		
		model.addAttribute("taskCommentList", taskCommentList);
		
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
		String delayColor = ezTaskService.getDelayColor(userInfo.getId(), tenantID);
		
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("delayColor", delayColor);
		
		logger.debug("taskStatus ended.");
		
		return "/ezTask/taskStatus";
	}
	
	/**
	 * 첨부파일 다운로드
	 */
	@RequestMapping(value = "/ezTask/downloadAttach.do")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadAttach started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
		String realPath = commonUtil.getRealPath(request);
		String uploadFilePath = commonUtil.getUploadPath("upload_task.ROOT", userInfo.getTenantId());
		
		if (fileName == null || fileName.equals("")) {
			fileName = filePath; 
		}
		
		String fullFilePath = realPath + uploadFilePath + filePath;

		downFile(request, response, fullFilePath, fileName);
		
		logger.debug("downloadAttach ended.");
	}
	
	/* 정수현*/
	
	/**
	 * 업무관리 환경설정
	 */
	@RequestMapping(value = "/ezTask/taskConfig.do")
	public String taskConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskConfig started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String _delayColor = ezTaskService.getDelayColor(userInfo.getId(), userInfo.getTenantId());

		model.addAttribute("_delayColor", _delayColor);

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
		int autoDelete = 0;

		String _delayColor = ezTaskService.getDelayColor(userInfo.getId(), userInfo.getTenantId());
		
		if (!_delayColor.equals("#FF0000")) {
			ezTaskService.taskUpdateConfig(userInfo.getId(), delayColor, autoDelete, userInfo.getTenantId());
		} else {
			ezTaskService.taskSaveConfig(userInfo.getId(), delayColor, autoDelete, userInfo.getTenantId());
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

		//delayColor
		String delayColor = ezTaskService.getDelayColor(userID, tenantID);

		model.addAttribute("userInfo",userInfo);
		model.addAttribute("delayColor", delayColor);

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
            pFileName[i] = pFileName[i].replace("%2b", "+");
            pFileName[i] = pFileName[i].replace("%3b", ";");
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
        	file.mkdir();
        }
        
        if (!tempFile.exists()) {
        	tempFile.mkdir();
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {        	
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            String newFileName = pUploadSN[i];

            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1 && !useExtension.equals("*")) {           	
				strXML.append("<DATA><![CDATA[" + newFileName + ";" + pFileName[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[" + pFileName[i] + "]]></DATA2>");
				strXML.append("<DATA3><![CDATA[" + fileSize[i] + "]]></DATA3>");
				strXML.append("<DATA4><![CDATA[]]></DATA4>");
				strXML.append("<DATA5><![CDATA[denied]]></DATA5>");
            } else {
            	writeUploadedFile(multiFile.get(i), newFileName + ";" + pFileName[i], pDirPath + "tempUploadFile");
            	
				strXML.append("<DATA><![CDATA[" + newFileName + ";" + pFileName[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[" + pFileName[i] + "]]></DATA2>");
				strXML.append("<DATA3><![CDATA[" + fileSize[i] + "]]></DATA3>");
				strXML.append("<DATA4><![CDATA[]]></DATA4>");
				strXML.append("<DATA5><![CDATA[OK]]></DATA5>");
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
		String filePath = "";
		
		logger.debug("fileList : " + fileList);

		filePath = "tempUploadFile";

		if (fileList.length() != 0) {
			String[] data = fileList.split(","); 
			
			for (int i=0; i<data.length; i++) {
				String sGUID = data[i].split(";")[0];
				String fileName = data[i].split(";")[1];
				
				File file = new File(pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID + ";" + fileName);
				
				file.delete();
			}			
		}

        logger.debug("tempUploadFileDelete ended");
        
        return "json";
    }

	/**
	 * 업무등록 실행
	 */
	/*@RequestMapping(value = "/ezTask/taskSave.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String taskSave(HttpServletRequest request, @RequestBody String xmlData, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("taskSave started");

		userInfo = commonUtil.userInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		String newGuid = UUID.randomUUID().toString();

		Document doc = commonUtil.convertStringToDocument(xmlData.toString());

		String ret = ezTaskService.taskSave(doc, realPath, userInfo, newGuid);

		logger.debug("ret : " + ret);
		logger.debug("taskSave ended");
		
		return ret;
	}*/

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
		
		String taskID = request.getParameter("taskID");
		TaskInfoVO taskInfoVO = null;
		List<TaskShareVO> taskShareList = null;
		
		if (taskID == null) {
			/*업무작성*/
			taskID = "";
		} else {
			/*업무수정*/
			
			taskInfoVO = ezTaskService.getTaskInfo(taskID, offset, primary, tenantID);
			
			//업무공유자목록조회
			
			if (taskInfoVO.getHasShare().equals("Y")) {
				taskShareList = ezTaskService.getShareList(taskID, offset, primary, tenantID);
			}
			
			//첨부파일목록조회
			if (taskInfoVO.getHasAttach().equals("Y")) {
//				getAttachList(taskID);
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("taskShareList", taskShareList);
		
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

    	String offset = userInfo.getOffset();
    	String app = request.getParameter("app");
    	String type = request.getParameter("type");
    	String filter = request.getParameter("filter");
    	String chkValue = request.getParameter("chkValue");
    	String searchClass = request.getParameter("searchClass");
    	String startDate = "";
    	String endDate = "";

    	if (!startDate.equals("") || startDate != null) {
    		startDate = request.getParameter("startDate");
        	endDate = request.getParameter("endDate");
    	}

    	List<TaskInfoVO> list = ezTaskService.taskGetList(userInfo.getId(), startDate, endDate, offset, app, type, filter, chkValue, searchClass, userInfo.getTenantId());
    	String cnt = ezTaskService.getTaskCount(userInfo.getId(), startDate, endDate, offset, type, filter, chkValue, searchClass, userInfo.getTenantId());

    	logger.debug("cnt : " + cnt + " | listSize : " + list.size());

    	StringBuffer resultXML = new StringBuffer();
    	
    	resultXML.append("<DATA>");
    	
    	for (int i = 0; i < list.size(); i++) {
    		resultXML.append("<ROW>");
    		
    		resultXML.append("<TASKID>" + list.get(i).getTaskID() + "</TASKID>");
    		resultXML.append("<PARENTID>" + list.get(i).getParentID() + "</PARENTID>");
    		resultXML.append("<OWNERID>" + list.get(i).getOwnerID() + "</OWNERID>");
    		resultXML.append("<CREATORID>" + list.get(i).getCreatorID() + "</CREATORID>");
    		resultXML.append("<CREATORNAME>" + list.get(i).getCreatorName() + "</CREATORNAME>");
    		resultXML.append("<CREATORNAME2>" + list.get(i).getCreatorName2() + "</CREATORNAME2>");
    		resultXML.append("<TASKSTATUS>" + list.get(i).getTaskStatus() + "</TASKSTATUS>");
    		resultXML.append("<COMPLETERATE>" + list.get(i).getCompleteRate() + "</COMPLETERATE>");
    		resultXML.append("<COMPLETEDATE>" + list.get(i).getCompleteDate() + "</COMPLETEDATE>");
    		resultXML.append("<IMPORTANCE>" + list.get(i).getImportance() + "</IMPORTANCE>");
    		resultXML.append("<STARTDATE>" + list.get(i).getStartDate() + "</STARTDATE>");
    		resultXML.append("<ENDDATE>" + list.get(i).getEndDate() + "</ENDDATE>");
    		resultXML.append("<TITLE>" + list.get(i).getTitle() + "</TITLE>");
    		resultXML.append("<HASATTACH>" + list.get(i).getHasAttach() + "</HASATTACH>");
    		resultXML.append("<HASCOMMENT>" + list.get(i).getHasComment() + "</HASCOMMENT>");
    		resultXML.append("<PERSONID>" + list.get(i).getPersonID() + "</PERSONID>");
    		resultXML.append("<PERSONNAME>" + list.get(i).getPersonName() + "</PERSONNAME>");
    		resultXML.append("<PERSONNAME2>" + list.get(i).getPersonName2() + "</PERSONNAME2>");
    		resultXML.append("<TASKTYPE>" + list.get(i).getTaskType() + "</TASKTYPE>");
    		resultXML.append("<TASKPERSONID>" + list.get(i).getTaskPersonID() + "</TASKPERSONID>");
    		resultXML.append("<TASKPERSONNAME>" + list.get(i).getTaskPersonName() + "</TASKPERSONNAME>");
    		resultXML.append("<TASKPERSONNAME2>" + list.get(i).getTaskPersonName2() + "</TASKPERSONNAME2>");
    		
    		resultXML.append("</ROW>");
    		
    		if (list.get(i).getTaskType().equals("1")) {
    			
    		}
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
}
