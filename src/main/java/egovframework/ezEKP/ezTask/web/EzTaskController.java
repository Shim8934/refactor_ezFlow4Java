package egovframework.ezEKP.ezTask.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezTask.service.EzTaskService;
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
public class EzTaskController {
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
	 * 업무작성화면 조회
	 */
	@RequestMapping(value = "/ezTask/taskWrite.do")
	public String taskWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskWrite started.");
		
		logger.debug("taskWrite ended.");
		
		return "/ezTask/taskWrite";
	}
	
	/**
	 * 업무상세화면 조회
	 */
	@RequestMapping(value = "/ezTask/taskRead.do")
	public String taskRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("taskRead started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		String taskID = request.getParameter("taskID");
		String type = (request.getParameter("type") == null ? "" : request.getParameter("type"));
		
		//업무정보 조회
		TaskInfoVO taskInfoVO = ezTaskService.getTaskInfo(taskID, userInfo.getOffset(), userInfo.getPrimary(), userInfo.getTenantId());
		
		String parentID = taskInfoVO.getParentID();
		
		//의견목록 조회
		List<TaskCommentVO> taskCommentList = null;
		if (taskInfoVO.getHasComment().equals("Y")) {
			if (parentID.equals("0")) {
				taskCommentList = ezTaskService.getCommentList(parentID, userInfo.getOffset(), userInfo.getPrimary(), userInfo.getTenantId());
			} else {
				taskCommentList = ezTaskService.getCommentList(taskID, userInfo.getOffset(), userInfo.getPrimary(), userInfo.getTenantId());
			}
		}
		
		//업무공유자목록조회
		List<TaskShareVO> taskShareList = null;
		if (taskInfoVO.getHasShare().equals("Y")) {
			if (parentID.equals("0")) {
				taskShareList = ezTaskService.getShareList(parentID, userInfo.getOffset(), userInfo.getPrimary(), userInfo.getTenantId());
			} else {
				taskShareList = ezTaskService.getShareList(taskID, userInfo.getOffset(), userInfo.getPrimary(), userInfo.getTenantId());
			}
		}
		
		//첨부파일목록조회
		if (taskInfoVO.getHasAttach().equals("Y")) {
			if (parentID.equals("0")) {
//				getAttachList(parentID);
			} else {
//				getAttachList(taskID);
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
		model.addAttribute("taskShareList", taskShareList);
		
		model.addAttribute("type", type);
		
		model.addAttribute("useEditor", useEditor);
		
		logger.debug("taskRead ended.");
		
		return "/ezTask/taskRead";
	}
	
	/*@RequestMapping(value = "/ezTask/taskSearch.do")
	public String taskSearch() throws Exception {
		return "/ezTask/taskSearch";
	}
	
	@RequestMapping(value = "/ezTask/taskSearch.do")
	public String taskSearch() throws Exception {
		return "/ezTask/taskSearch";
	}*/
	
	
	
	
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
	 * 업무작성 조직도 호출
	 */
	@RequestMapping(value = "/ezTask/taskSelectAttendant.do")
	public String taskSelectAttendant() throws Exception {
		return "/ezTask/taskSelectAttendant";
	}

}
