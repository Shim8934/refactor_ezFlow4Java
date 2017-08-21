package egovframework.ezEKP.ezTask.web;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezTask.service.EzTaskService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.ezEKP.ezTask.vo.TaskShareVO;
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
	public String taskMain() throws Exception {
		logger.debug("taskMain started.");
		
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
		if (taskInfoVO.getHasAttach().equals("Y")) {
			if (parentID.equals("0")) {
//				getAttachList(taskID);
			} else {
//				getAttachList(parentID);
			}
		}
		
		/*var taskid = "${taskID }";
		var contentpath = "${contentPath }";
		var ownerid = "${ownerID }";
		var creatorid = "${creatorID }";
		var parentid = "${parentID }";
		var repeatcount = "${repeatCount }";
		var taskstatus = "${taskStatus }";
		var completerate = "${completeRate }";
	    var admin = "${admin }";
	    var personlist = "${personList }";
	    var shareid = "${shareID }";
	    var tasktype = "${taskType }";
	    var content = "${contentPerson }";
	    var date = "${date }";
	    var type = "${type }";
	    var personid = "${personID }";
	    var attachFileInfo = "${attachFileInfo }";
	    var optioncnt = "${optionCnt }";
	    var tempbody = "";
	    */
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("taskCommentList", taskCommentList);
		model.addAttribute("taskCommentListSize", taskCommentList == null ? "0" : taskCommentList.size());
		
		model.addAttribute("taskShareList", taskShareList);
		
		model.addAttribute("type", type);
		
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("folderPath", folderPath);
		
		logger.debug("taskRead ended.");
		
		return "/ezTask/taskRead";
	}
	
	/**
	 * 지시사항 수정화면 조회
	 */
	@RequestMapping(value = "/ezTask/taskWorkWrite.do")
	public String taskWorkWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskWorkWrite started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		
		logger.debug("taskWorkWrite ended.");
		
		return "/ezTask/taskWorkWrite";
	}
	
	/** 의견작성 Method*/
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
	public String taskSelectEntity() throws Exception {
		return "/ezTask/taskSelectEntity";
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

		if (_delayColor == null) {
			_delayColor = "#ff0000";
		}

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
		
		if (_delayColor != null) {
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
	public String taskSearch() throws Exception {
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
	@RequestMapping(value = "/ezTask/taskSave.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String taskSave(HttpServletRequest request, @RequestBody String xmlData, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("taskSave started");

		userInfo = commonUtil.userInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);

		Document doc = commonUtil.convertStringToDocument(xmlData.toString());

		String ret = ezTaskService.taskSave(doc, realPath, userInfo);

		logger.debug("ret : " + ret);
		logger.debug("taskSave ended");
		
		return ret;
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
		String newGuid = UUID.randomUUID().toString();
		
		String taskID = request.getParameter("taskID");
		TaskInfoVO taskInfoVO = null;
		List<TaskShareVO> taskShareList = null;
		
		if (taskID == null) {
			/*업무작성*/
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
		model.addAttribute("newGuid", newGuid);
		model.addAttribute("taskID", taskID);
		model.addAttribute("taskInfoVO", taskInfoVO);
		model.addAttribute("taskShareList", taskShareList);
		
		logger.debug("taskWrite ended.");
		
		return "/ezTask/taskWrite";
	}
}
