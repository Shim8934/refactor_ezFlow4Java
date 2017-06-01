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
	 * 모바일 게시판 즐겨찾기게시판목록 top5 조회  (portal용)
	 */
	@RequestMapping("/mobile/ezBoard/getFavoriteList.do")
	public String getFavoriteList() throws Exception {
		logger.debug("getFavoriteList started.");
		
		logger.debug("getFavoriteList ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 전체게시판화면
	 */
	@RequestMapping("/mobile/ezBoard/totalBoardList.do")
	public String totalBoardList() throws Exception {
		logger.debug("totalBoardList started.");
		
		logger.debug("totalBoardList ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 해당게시판글목록화면
	 */
	@RequestMapping(value = "/mobile/ezBoard/boardItemList.do")
	public String boardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, BoardPropertyVO boardPropertyVO, Model model) throws Exception {
		logger.debug("boardList started.");
		
//		String boardID = request.getParameter("boardID");
		
//		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		model.addAttribute("type", "boardItemList");
		model.addAttribute("title", egovMessageSource.getMessage("ezBoard.t116", userInfo.getLocale()));
		
		logger.debug("boardList ended.");
		
		return "/mobile/ezBoard/mBoardItemList";
	}
}
