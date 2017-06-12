package egovframework.ezMobile.ezBoard.web;

import java.util.Properties;

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
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class MEzBoardController {
	private static final Logger logger = LoggerFactory.getLogger(MEzBoardController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	/**
	 * 모바일 게시판 즐겨찾기게시판목록 조회
	 * 타입에 따라
	 * 1. 포탈일땐 환경설정값 참조해서 환경설정갯수만큼만 조회 + more
	 * 2. 분류별 목록보기에서는 전체 목록조회
	 * 
	 * 호출 <- 포탈, 메뉴바
	 */
	@RequestMapping("/mobile/ezBoard/getFavoriteList.do")
	public String getFavoriteList() throws Exception {
		logger.debug("getFavoriteList started.");
		
		logger.debug("getFavoriteList ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 게시판그룹목록 조회
	 * 
	 * getBoardTree 참조  (권한체크)
	 * 호출 <- 포탈, 메뉴바
	 */
	@RequestMapping("/mobile/ezBoard/getBoardGroupList.do")
	public String getBoardGroupList() throws Exception {
		logger.debug("getBoardGroupList started.");
		
		logger.debug("getBoardGroupList ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 게시판그룹목록 조회
	 * 타입에따라
	 * 1. 포탈일땐 환경설정값 참조해서 환경설정갯수만큼만 조회 + more
	 * 2. 분류별 목록보기에서는 전체 목록조회
	 * getBoardTree 참조  (권한체크, dept표시)
	 * 호출 <- 포탈, 분류별하위게시판목록
	 */
	@RequestMapping("/mobile/ezBoard/getBoardList.do")
	public String getBoardList() throws Exception {
		logger.debug("getBoardList started.");
		
		logger.debug("getBoardList ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 해당게시판글목록화면
	 * 타입에따라
	 * 게시판종류별로 (일반, 그룹, 익명, 포토, 썸네일, Q&A)
	 */
	@RequestMapping(value = "/mobile/ezBoard/getBoardItemList.do")
	public String boardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, BoardPropertyVO boardPropertyVO, Model model) throws Exception {
		logger.debug("getBoardList started.");
		
//		String boardID = request.getParameter("boardID");
		
//		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		model.addAttribute("type", "boardItemList");
		model.addAttribute("title", egovMessageSource.getMessage("ezBoard.t116", userInfo.getLocale()));
		
		logger.debug("getBoardList ended.");
		
		return "/mobile/ezBoard/mBoardItemList";
	}
	
	/**
	 * 모바일 게시판 해당게시판 정보조회
	 * 상위 게시판 및 그룹 조회
	 */
	@RequestMapping(value = "/mobile/ezBoard/getBoardInfo.do")
	public String getBoardInfo() throws Exception {
		logger.debug("getBoardInfo started.");
		
		logger.debug("getBoardInfo ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 글 상세화면조회
	 */
	@RequestMapping(value = "/mobile/ezBoard/getBoardItem.do")
	public String getBoardItem() throws Exception {
		logger.debug("getBoardItem started.");
		
		logger.debug("getBoardItem ended.");
		
		return "/mobile/ezBoard/mBoardItem";
	}
	
	/**
	 * 모바일 게시판 글 쓰기/수정화면조회
	 * 타입에따라
	 * 1.쓰기
	 * 2.수정
	 */
	@RequestMapping(value = "/mobile/ezBoard/editBoardItem.do")
	public String editBoardItem() throws Exception {
		logger.debug("editBoardItem started.");
		
		logger.debug("editBoardItem ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 글 쓰기/수정 저장
	 */
	@RequestMapping(value = "/mobile/ezBoard/saveBoardItem.do")
	public String saveBoardItem() throws Exception {
		logger.debug("saveBoardItem started.");
		
		/*if (boardID != null) {
			수정저장
		} else {
			쓰기저장
			
			쓰기 저장 success 에서 알림메일 전송
		}*/
		
		logger.debug("saveBoardItem ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 글 삭제
	 */
	@RequestMapping(value = "/mobile/ezBoard/deleteBoardItem.do")
	public String deleteBoardItem() throws Exception {
		logger.debug("deleteBoardItem started.");
		
		logger.debug("deleteBoardItem ended.");
		
		return "";
	}
}
