package egovframework.ezEKP.ezTask.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
	/* 이효진*/
	
	/**
	 * 업무관리 메인화면
	 */
	@RequestMapping(value="/ezTask/taskMain.do")
	public String taskMain() throws Exception {
		return "/ezTask/taskMain";
	}
	
	/**
	 * 업무작성화면 조회
	 */
	@RequestMapping(value = "/ezTask/taskWrite.do")
	public String taskWrite() throws Exception {
		return "/ezTask/taskWrite";
	}
	
	/*@RequestMapping(value = "/ezTask/taskSearch.do")
	public String taskSearch() throws Exception {
		return "/ezTask/taskSearch";
	}
	
	@RequestMapping(value = "/ezTask/taskSearch.do")
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

	/**
	 * 업무관리 검색
	 */
	@RequestMapping(value = "/ezTask/taskSelectAttendant.do")
	public String taskSelectAttendant() throws Exception {
		return "/ezTask/taskSelectAttendant";
	}

}
