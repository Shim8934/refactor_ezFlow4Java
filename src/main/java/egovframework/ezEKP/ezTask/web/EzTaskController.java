package egovframework.ezEKP.ezTask.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.web.EzEmailAdminController;

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
	private static final Logger logger = LoggerFactory.getLogger(EzEmailAdminController.class);
	
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
	
	@RequestMapping(value = "/ezTask/taskRead.do")
	public String taskRead() throws Exception {
		logger.debug("taskRead started.");
		
		
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
	public String taskConfig() throws Exception {
		return "/ezTask/taskConfig";
	}

	/**
	 * 업무관리 검색
	 */
	@RequestMapping(value = "/ezTask/taskSearch.do")
	public String taskSearch() throws Exception {
		return "/ezTask/taskSearch";
	}
}
