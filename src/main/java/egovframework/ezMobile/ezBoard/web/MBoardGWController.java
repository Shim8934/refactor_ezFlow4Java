package egovframework.ezMobile.ezBoard.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class MBoardGWController {
	private static final Logger logger = LoggerFactory.getLogger(MBoardController.class);
	
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
	
	@Resource(name = "MBoardService")
	private MBoardService mBoardService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시판 리스트
	 */
	@RequestMapping(value="/ezboard/{type}/boards/{boardId}/list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public List<MBoardItemVO> getBoardItemList(@PathVariable String type, @PathVariable String boardId, @RequestParam(value="loginCookie", required=false) String loginCookie) throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/list] started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
System.out.println(type);
System.out.println(boardId);
		MBoardInfoVO boardInfo = new MBoardInfoVO();
		boardInfo.setBoardID(boardId);
		List<MBoardItemVO> list = mBoardService.getBoardItemList(boardInfo, userInfo); 
		//List<MBoardItemVO> list = null;		

		logger.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/list] ended.");
		return list;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시판 리스트 카운트
	 */
	@RequestMapping(value="/ezboard/{type}/boards/{boardId}/list-count", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void getBoardItemListCount() throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/list-count] started.");
				
		logger.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/list-count] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 섬네일게시판 리스트
	 */
	@RequestMapping(value="/ezboard/thumbnail/boards/{boardId}/list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void getThumbBoardList() throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/thumbnail/boards/{boardId}/list] started.");
				
		logger.debug("MOBILE G/W BOARD [GET /ezboard/thumbnail/boards/{boardId}/list] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 섬네일게시판 리스트 카운트
	 */
	@RequestMapping(value="/ezboard/thumbnail/boards/{boardId}/list-count", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void getThumbBoardListCount() throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/thumbnail/boards/{boardId}/list-count] started.");
				
		logger.debug("MOBILE G/W BOARD [GET /ezboard/thumbnail/boards/{boardId}/list-count] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 즐겨찾기에 등록된 게시판 폴더 리스트
	 */
	@RequestMapping(value="/ezboard/favorite-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void getFavoriteList() throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/favorite-list/users/{userId}] started.");
				
		logger.debug("MOBILE G/W BOARD [GET /ezboard/favorite-list/users/{userId}] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시물 상세정보
	 */
	@RequestMapping(value="/ezboard/{type}/boards/{boardId}/contents/{contentId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void boardDetail() throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/contents/{contentId}] started.");
				
		logger.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/contents/{contentId}] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시물 등록
	 */
	@RequestMapping(value="/ezboard/boards/{boardId}/contents", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void insertBoard() throws Exception {		
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/contents] started.");
				
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/contents] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시물 수정
	 */
	@RequestMapping(value="/ezboard/boards/{boardId}/contents/{contentId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void updateBoard() throws Exception {		
		logger.debug("MOBILE G/W BOARD [PUT /ezboard/boards/{boardId}/contents] started.");
				
		logger.debug("MOBILE G/W BOARD [PUT /ezboard/boards/{boardId}/contents] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시물 삭제
	 */
	@RequestMapping(value="/ezboard/boards/{boardId}/contents/{contentId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public void deleteBoard() throws Exception {		
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/contents] started.");
				
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/contents] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 좌측메뉴 리스트
	 */
	@RequestMapping(value="/ezboard/folder-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void getLeftMenu() throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/folder-list] started.");
				
		logger.debug("MOBILE G/W BOARD [GET /ezboard/folder-list] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 즐겨찾기 설정
	 */
	@RequestMapping(value="/ezboard/boards/{boardId}/favorite", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void insertFavorite() throws Exception {		
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/favorite] started.");
				
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/favorite] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 즐겨찾기 해제
	 */
	@RequestMapping(value="/ezboard/boards/{boardId}/favorite", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public void deleteFavorite() throws Exception {		
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/favorite] started.");
				
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/favorite] ended.");
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시물 첨부파일 리스트
	 */
	@RequestMapping(value="/ezboard/boards/{boardId}/contents/{contentId}/attach-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void getAttachList() throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/boards/{boardId}/contents/{contentId}/attach-list] started.");
				
		logger.debug("MOBILE G/W BOARD [GET /ezboard/boards/{boardId}/contents/{contentId}/attach-list] ended.");
	}
}
