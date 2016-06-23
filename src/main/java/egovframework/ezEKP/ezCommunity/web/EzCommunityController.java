package egovframework.ezEKP.ezCommunity.web;

import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.web.EzCommonController;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemReadVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCCategoryVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubGuestVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollManagerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollQuestionVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollResponseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityOneLineReplyVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 커뮤니티
 * @author 오픈솔루션팀 이효진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.19    이효진    신규작성
 *
 * @see
 */

@Controller
public class EzCommunityController extends EgovFileMngUtil{
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties globals;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="EzCommunityService")
	private EzCommunityService ezCommunityService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzCommonController ezCommonController;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value="/ezCommunity/communityMain.do")
	public String  main() {
		return "/ezCommunity/communityMain";
	}
	
	/**
	 * 왼쪽 메뉴화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/communityLeftCommunity.do")
	public String communityLeftCommunity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = "", codeName = "";
		
        if (request.getParameter("communityCD") != null) {
            code = request.getParameter("communityCD");
        }
        if (request.getParameter("communityName") != null) {
            codeName = request.getParameter("communityName");
        }
		
		ezCommunityService.communityLeftCommunity(userInfo, request, model, code);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("code", code);
		model.addAttribute("codeName", codeName);
		model.addAttribute("lang",userInfo.getLang());
		
		return "/ezCommunity/communityLeftCommunity";
	}

	/**
	 * 커뮤니티목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getLeftCommunity.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getLeftCommunity(@CookieValue("loginCookie")String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

        return ezCommunityService.getLeftCommunity(userInfo);
	}
	
	/**
	 * 알림마당목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getLeftBoardList.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getLeftBoardList() throws Exception {
		return ezCommunityService.getLeftBoardList();
	}
	
	/**
	 * 커뮤니티 로고 출력함수(ezCommon_Interface)
	 */
	@RequestMapping(value="/ezCommunity/getCommunityThumInfo.do")
	public void getCommunityThumInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String pType = request.getParameter("type");
		String pFileName = request.getParameter("fileName");
		String pFilePath = "", pBoardID = "";
		
		if (request.getParameter("boardID") != null) {
			pBoardID = request.getParameter("boardID");
		}

		if (pType.toUpperCase().equals("COMMUNITYLOGO")) {
			pFilePath = ezCommunityService.getCommunityThumInfo(pBoardID, pFileName, "LOGO");
			
	        if (pFilePath != null && !pFilePath.equals("")) {
	            ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
	        }
		}
		
		if (pType.toUpperCase().equals("COMMUNITYTHUM")) {
			pFilePath = ezCommunityService.getCommunityThumInfo(pBoardID, pFileName, "COMMUNITYTHUM");
			
	        if (pFilePath != null && !pFilePath.equals("")) {
	            ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
	        }
		}
	}

	/**
	 * 커뮤니티만들기 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commMake.do")
	public String commMake(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary="", langSecondary="", userInfoDisplayName = "";
		
		langPrimary = config.getProperty("config.lang_Primary"+userInfo.getLang());
		langSecondary = config.getProperty("config.lang_Secondary"+userInfo.getLang());
		
		if (userInfo.getLang().equals("2")) {
			userInfoDisplayName = userInfo.getDisplayName2();
		} else {
			userInfoDisplayName = userInfo.getDisplayName1();
		}

		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("userInfoDisplayName", userInfoDisplayName);
//		model.addAttribute("flag", flag);		
		model.addAttribute("idSpanValue", ezCommunityService.getCategory("", "", ""));
		
		return "/ezCommunity/communityCommMake";
	}
	
	/**
	 * 커뮤니티만들기 싱청 함수
	 */
	@RequestMapping(value = "/ezCommunity/commMakeOk.do", method = RequestMethod.POST)
	@ResponseBody
	public void commMakeOk(@CookieValue("loginCookie")String loginCookie, CommunityClubVO clubVO, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezCommunityService.commMakeOk(userInfo, clubVO, request, response);
	}
	
	/**
	 * 게시판Tree 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getSubBoards.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getSubBoards(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		
		return ezCommunityService.getSubBoard(userInfo, request);
	}
	
	/**
	 * 관리자권한 확인 함수
	 */
	@RequestMapping(value = "/ezCommunity/goAdminOk.do")
	@ResponseBody
	public String goAdminOk(@RequestBody String data, HttpServletRequest request, CommunityClubVO communityClubVO) throws Exception {
		return ezCommunityService.goAdminOk(data, request, communityClubVO);
	}
	
	/**
	 * 커뮤니티 권한 및 승인여부 확인 함수
	 */
	@RequestMapping(value = "/ezCommunity/checkCommHome.do")
	public String checkCommHome(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		ezCommunityService.checkCommHome(userInfo, model, request);
		
		return "/ezCommunity/communityCheckCommHome";
	}
	
	/**
	 * 커뮤니티팝업화면 출력 함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/popupCommHome.do")
	public String popupCommHome(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String codeName = request.getParameter("codeName");
		
		// 20100119 보안처리 관련 추가작업(권한체크)
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
		
		String strVisit = ezCommunityService.commHomeGet1(userInfo.getId(), code);
		
		if (strVisit == null || !strVisit.substring(0, 10).equals(EgovDateUtil.getToday("-"))) {
			ezCommunityService.updateLastDate(EgovDateUtil.getTodayTime(), code, userInfo.getId());
		}
		
		ezCommunityService.popupCommHome(userInfo, model, request, response);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("code", code);
		model.addAttribute("codeName", codeName);
		
		return "/ezCommunity/communityPopupCommHome";
	}
	
	/**
	 * 커뮤니티 메인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/commHomeInfo.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String commHomeInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		
		return ezCommunityService.commHomeInfo(userInfo, code);
	}
	
	/** 
	 * 커뮤니티 메인 오른쪽화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/commHomeBoardInfo.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String commHomeBoardInfo(HttpServletRequest request) throws Exception {
		return ezCommunityService.commHomeBoardInfo(request);
	}
	
	/**
	 * 커뮤니티 게시판 목록화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemList.do")
	public String boardItemList(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String pBoardID = request.getParameter("boardID");
		String pBoardName = request.getParameter("boardName");
		String userLevel = "";
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		CommunityBoardListVO boardList = ezCommunityService.boardItemListGet1(pBoardID, userInfo.getId());
		ezCommunityService.boardItemList(userInfo, model, request, response, boardInfo, boardList);
		
		if (boardList == null) {
			userLevel = "0";
		} else {
			if (boardList.getPermit().equals("0")) {
				userLevel = "9";
			} else {
				userLevel = boardList.getPermit();
			}
		}
		
		model.addAttribute("code", code);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pBoardName", pBoardName);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("lang", commonUtil.getMultiData(userInfo.getLang()));
		
		return "/ezCommunity/communityBoardItemList";
	}
	
	/**
	 * 커뮤니티 검색화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/searchBoardItem.do")
	public String searchBoardItem(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String orgBoardParameters = request.getParameter("orgBoardParameters");
		String code = request.getParameter("code");
		
		int pPage = 1, totalPage = 1, totalCount = 0;
		String title = "", writerName = "", abstracts = "", searchStart = "", searchEnd = "", pSortBy = "";
		String strXML="";
		
		if (request.getParameter("page") != null) {
			pPage = Integer.parseInt(request.getParameter("page"));
		}
		if (request.getParameter("title") != null) {
			title = request.getParameter("title");
		}
		if (request.getParameter("writerName") != null) {
			writerName = request.getParameter("writerName");
		}
		if (request.getParameter("abstract") != null) {
			abstracts = request.getParameter("abstract");
		}
		if (request.getParameter("searchStart") != null) {
			searchStart = request.getParameter("searchStart");
		}
		if (request.getParameter("searchEnd") != null) {
			searchEnd = request.getParameter("searchEnd");
		}
		if (request.getParameter("pSortBy") != null) {
			pSortBy = request.getParameter("pSortBy");
		}

		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		// 20100119 보안처리 관련 추가작업(권한체크)
        ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
        
        int pStartRow = (pPage - 1) * boardInfo.getSs_SearchBoard_MaxRows() + 1;
        int pEndRow = pPage * boardInfo.getSs_SearchBoard_MaxRows();
        String startDateTime = "";
        String endDateTime = "";

        if (!searchStart.equals("")) {
        	startDateTime = searchStart.split(" ")[0];
        	endDateTime = searchEnd.split(" ")[0];
        }

        if (!title.equals("") || !writerName.equals("") || !abstracts.equals("") || !searchStart.equals("")) {
        	totalCount = Integer.parseInt(ezCommunityService.searchItemCount(userInfo.getId(), boardID, title, writerName, abstracts, startDateTime, endDateTime));
            strXML = ezCommunityService.searchItemXML(userInfo.getId(), boardID, title, writerName, abstracts, searchStart, searchEnd, pStartRow, pEndRow, commonUtil.getMultiData(userInfo.getLang()));
            
            if (totalCount > 0) {
				if (totalCount > boardInfo.getSs_SearchBoard_MaxRows()) {
					if(totalCount % boardInfo.getSs_SearchBoard_MaxRows() > 0) {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows() + 1;
					} else {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows();
					}
				} else {
					totalPage = 1;
				}
			} else {
				totalPage = 1;
			}
        }

        model.addAttribute("userInfo", userInfo);
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("orgBoardParameters", orgBoardParameters);
        model.addAttribute("startDateTime", startDateTime);
        model.addAttribute("endDateTime", endDateTime);
        model.addAttribute("pSortBy", pSortBy);
        model.addAttribute("strXML", strXML);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("title", title);
        model.addAttribute("writerName", writerName);
        model.addAttribute("abstract", abstracts);
        
		return "/ezCommunity/communitySearchBoardItem";
	}
	
	/**
	 * 게시물 읽음표시 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/setRead.do", method = RequestMethod.POST)
	@ResponseBody
	public String setRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String itemIDList = request.getParameter("itemIDList");

		return ezCommunityService.setAsRead(userInfo, boardID, itemIDList);
	}
	
	/**
	 * 게시물 답변 여부 체크 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/checkIfHasReply.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkIfHasReply (HttpServletRequest request) throws Exception {
		String itemList = request.getParameter("itemList");
		
		return ezCommunityService.checkIfHasReply(itemList);
	}
	
	/**
	 * 게시물 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/deleteItem.do", method = RequestMethod.POST)
	public void deleteItem(HttpServletRequest request) throws Exception {
		String itemList = request.getParameter("itemList");
		
		ezCommunityService.deleteItem(itemList);
	}
	
	/**
	 * 게시물 등록/수정/답변 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/newBoardItem.do")
	public String newBoardItem(@CookieValue("loginCookie") String loginCookie, ModelMap model, CommunityBoardItemVO item, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String pMode = request.getParameter("mode");
		
		String pItemID = "", pReservedItem = "", pUrl = "", pDocID = "", expireDays = "";
		String hasAttach = "NO";
		String uploadFilePath = config.getProperty("upload_community.ROOT") + commonUtil.separator;
		String userInfoApprovalG = config.getProperty("config.UserInfo_ApprovalG");
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		if (request.getParameter("itemID") != null) {
			pItemID = request.getParameter("itemID");
		}
		if (request.getParameter("reservedItem") != null) {
			pReservedItem = request.getParameter("reservedItem");
		}
		if (request.getParameter("url") != null) {
			pUrl = request.getParameter("url");
		}
		if (request.getParameter("docID") != null) {
			pDocID = request.getParameter("docID");
		}
		
		ezCommunityService.communityConnCHK(userInfo.getId(), "", pBoardID, userInfo.getRollInfo(), 1, response);
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		
		ezCommunityService.newBoardItem(item, boardInfo, userInfo, pItemID, pBoardID, pUrl, pMode, expireDays, hasAttach, model);
		
		model.addAttribute("editor", config.getProperty("config.EDITOR"));
		model.addAttribute("pUploadFilePath", uploadFilePath);
		model.addAttribute("userInfoApprovalG", userInfoApprovalG);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("pDocID", pDocID);
		model.addAttribute("strNow", EgovDateUtil.getTodayTime());
		model.addAttribute("pUrl", pUrl);
		model.addAttribute("pMode", pMode);
		model.addAttribute("hasAttach", hasAttach);
		
		
		return "/ezCommunity/communityNewBoardItem";
	}
	
	/**
	 * 게시판 쓰기/수정/답변 실행함수
	 */
	@Transactional(propagation=Propagation.NESTED)
	@RequestMapping(value = "/ezCommunity/saveItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveItem (@RequestBody String xmlStr, CommunityBoardItemVO item, HttpServletRequest request) throws Exception {
		Document xmlData = commonUtil.convertStringToDocument(xmlStr);
		String pMode = request.getParameter("mode");

		String ret = ezCommunityService.newItem(xmlData, pMode, request.getServletContext().getRealPath(""));
		
		return ret;
	}
	
	/**
	 * 게시판 파일업로드 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/upload.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String upload(MultipartHttpServletRequest request, HttpServletResponse response) throws Exception { 
		return ezCommunityService.upload(request, response);
	}
	
	/**
	 * 게시판 읽기 화면호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemView.do")
	public String boardItemView(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReservedItem = "";
		String useEditor = config.getProperty("config.EDITOR");
		String oneLineReplyFlag = config.getProperty("config.ONELINE_REPLY_ENABLE");
        String adjacentItemsEnableFlag = config.getProperty("config.ADJACENT_ITEMS_ENABLE");
        String useKMS = config.getProperty("config.Use_ezKMS");
        String publicModulus = egovFileScrty.getPbm();
        String publicExponent = "10001";
        
		String pItemID = request.getParameter("itemID");
		String pBoardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		String showAdjacent = request.getParameter("showAdjacent");
		
		if (showAdjacent == null) {
			showAdjacent = config.getProperty("config.ADJACENT_ITEMS_ENABLE");
		}
		if (request.getParameter("pReservedItem") != null) {
			pReservedItem = request.getParameter("pReservedItem");
		}
		
		ezCommunityService.communityConnCHK(userInfo.getId(), "", pBoardID, userInfo.getRollInfo(), 1, response);
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		CommunityBoardItemVO item = ezCommunityService.getItemXML(pBoardID, pItemID);
		ezCommunityService.setAsRead(userInfo, pBoardID, pItemID);		
		ezCommunityService.boardItemView(userInfo, boardInfo, item, pItemID, pBoardID, showAdjacent, adjacentItemsEnableFlag, model);

		model.addAttribute("itemID", pItemID);
		model.addAttribute("boardID", pBoardID);
		model.addAttribute("code", code);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("oneLineReplyFlag", oneLineReplyFlag);
		model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
		model.addAttribute("useKMS", useKMS);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strUserLang", commonUtil.getMultiData(userInfo.getLang()));
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("ch_CommunityAdmin", userInfo.getRollInfo().indexOf("t=1"));
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		
		return "/ezCommunity/communityBoardItemView";
	}
	
	/**
	 * 암호확인화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/checkPassword.do")
	public String checkPassword(ModelMap model, HttpServletRequest request) throws Exception {
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		String pItemID = request.getParameter("itemID");
		
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("itemID", pItemID);
		
		return "/ezCommunity/communityCheckPassword";
	}
	
	/**
	 * 암호확인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/confirmPassword.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String confirmPassword(HttpServletRequest request) throws Exception {
		String itemID = request.getParameter("itemID");
		String newPassword = request.getParameter("newPassword");
		
		return ezCommunityService.confirmPassword(itemID, newPassword);
	}
	
	/**
	 * 한줄답변 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/readOneLineReply.do", method = RequestMethod.POST)
	public String readOneLineReply(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String pItemID = request.getParameter("itemID");
		
		List<CommunityOneLineReplyVO> oneLineReplyList = ezCommunityService.readOneLineReply(commonUtil.getMultiData(userInfo.getLang()), pBoardID, pItemID);
		
		model.addAttribute("oneLineReplyList", oneLineReplyList);
		
		return "json";
	}
	
	/**
	 * 한줄답변 등록 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveOneLineReply.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void saveOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDoc = commonUtil.convertStringToDocument(request.getParameter("strXML"));
		
		ezCommunityService.saveOneLineReply(xmlDoc, userInfo);
	}
	
	/**
	 * 한줄답변 삭제시 작성자본인확인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/checkOneLineOwner.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String checkOneLineOwner(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReplyID = request.getParameter("replyID");
		
		return ezCommunityService.checkOneLineOwner(pReplyID, userInfo.getId());
	}
	
	/**
	 * 한줄답변 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/deleteOneLineReply.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String deleteOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReplyID = request.getParameter("replyID");
		String gubun = request.getParameter("gubun");
		
		return ezCommunityService.deleteOneLineReply(userInfo.getId(), pReplyID, gubun);
	}
	
	/**
	 * 익명게시판일때 checkReplyPassword
	 */
	@RequestMapping(value = "/ezCommunity/checkReplyPassword.do")
	public String checkReplyPassword(ModelMap model, HttpServletRequest request) throws Exception {
		String publicModulus = egovFileScrty.getPbm();
		String pItemID = request.getParameter("itemID");
		String pReplyID = request.getParameter("replyID");
		
		String password = ezCommunityService.checkReplyPassword(pItemID, pReplyID);
		
		model.addAttribute("password", password);
		model.addAttribute("publicModulus", publicModulus);
		
		return "/ezCommunity/communitycheckReplyPassword";
	}
	
	/**
	 * 게시판 첨부파일 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getItemAttachments.do", method = RequestMethod.POST)
	@ResponseBody
	public String getItemAttachments(HttpServletRequest request) throws Exception {
		String itemID = request.getParameter("itemID");
		
		String strXML = ezCommunityService.getItemAttachmentXML(itemID);
		
		if (strXML.substring(0, 5).equals("ERROR")) {
			strXML = "<RESULT>" + strXML + "</RESULT>";
		}
		
		return strXML;
	}
	
	/**
	 * 게시판 예약게시목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardReservedItemList.do")
	public String boardReservedItemList(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pSortBy = "";
		int pPage = 1, totalPage = 1;
		
		String pOrgBoardParameters = request.getParameter("orgBoardParameters");
		
		if (request.getParameter("page") != null) {
			pPage = Integer.parseInt(request.getParameter("page"));
		}
		if (request.getParameter("sortBy") != null) {
			pSortBy = request.getParameter("sortBy");
		}
		
		String boardName = egovMessageSource.getMessage("ezCommunity.t91", new Locale(globals.getProperty("Globals.language")));
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, "");
		
		boardInfo.setSs_Board_MaxRows(10);
		
		int pStartRow =  (pPage - 1) * boardInfo.getSs_Board_MaxRows() + 1;
		int pEndRow = pPage * boardInfo.getSs_Board_MaxRows();

		String strXML = ezCommunityService.getReservedItemListXML(userInfo.getId(), pStartRow, pEndRow, pSortBy, userInfo.getLang());
		int totalCount = ezCommunityService.getReservedItemListCount(userInfo.getId());
		
		if (totalCount > 0) {
			if (totalCount > boardInfo.getSs_Board_MaxRows()) {
				if(totalCount % boardInfo.getSs_Board_MaxRows() > 0) {
					totalPage = totalCount / boardInfo.getSs_Board_MaxRows() + 1;
				} else {
					totalPage = totalCount / boardInfo.getSs_Board_MaxRows();
				}
			} else {
				totalPage = 1;
			}
		} else {
			totalPage = 1;
		}
		
		model.addAttribute("pOrgBoardParameters", pOrgBoardParameters);
		model.addAttribute("boardName", boardName);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("pPage", pPage);
		model.addAttribute("pSortBy", pSortBy);
		model.addAttribute("strXML", strXML);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		
		return "/ezCommunity/communityBoardReservedItemList";
	}
	
	/**
	 * 게시판 첨부파일 다운로드 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/getCommunityAttachInfo.do")
	public void getCommunityAttachInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String pFileName = request.getParameter("fileName");
		String pFilePath = request.getParameter("filePath");
		
		ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
	}
	
	/**
	 * 게시판 조회자정보 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/itemReadList.do")
	public String itemReadList(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pBoardID = request.getParameter("boardID");
		String pItemID = request.getParameter("itemID");
		
		List<CommunityBoardItemReadVO> readList = ezCommunityService.getReaderList(pBoardID, pItemID);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("readList", readList);
		
		return "/ezCommunity/communityItemReadList";
	}
	
	/**
	 * 게시글 미리보기 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemPreview.do")
	public String boardItemPreView(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useIE11Browser = "";
		String gubun = request.getParameter("gubun");
		String useEditor = config.getProperty("config.EDITOR");
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && config.getProperty("config.IE11EDITOR").equals("CK")) {
                useIE11Browser = "CK";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("gubun", gubun);
		model.addAttribute("strNow", EgovDateUtil.getTodayTime());
		model.addAttribute("Use_Editor", useEditor);
		model.addAttribute("Use_IE11Browser", useIE11Browser);
		
		return "/ezCommunity/communityBoardItemPreview";
	}
	
	/**
	 * 게시판 복사화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/copyBoardItem.do")
	public String copyBoardItem(ModelMap model, HttpServletRequest request) {
		String pItemIDList = request.getParameter("itemIDList");
		String pBoardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		
		model.addAttribute("itemIDList", pItemIDList);
		model.addAttribute("boardID", pBoardID);
		model.addAttribute("code", code);
		return "/ezCommunity/communityCopyBoardItem";
	}
	
	/**
	 * 게시판 복사 권한 검사
	 */
	@RequestMapping(value = "/ezCommunity/getACL.do", method = RequestMethod.POST)
	public String getACL(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		CommunityBoardPropertyVO boardInfo;
		
		if(request.getParameter("comID") != null) {
			String pComID = request.getParameter("comID");
			String strACLXML = ezCommunityService.getACL(userInfo.getId(), pComID);
			
			model.addAttribute("WRITE", strACLXML);
		} else if (request.getParameter("boardID") != null) {
			String pBoardID = request.getParameter("boardID");
			String userDeptPath = userInfo.getDeptPathCode();
			
			for(String pAccessID : userDeptPath.split(",")) {
				boardInfo = ezCommunityService.brdGetACL(pBoardID, pAccessID);
				
				if (boardInfo != null) {
					model.addAttribute("boardInfo", boardInfo);
					break;
				}
			}
		}
		
		return "json";
	}
	
	/**
	 * 게시판 복사 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/copyItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	public String copyItem(ModelMap model, HttpServletRequest request) throws Exception {
		String pOrgItemIDList = request.getParameter("orgItemIDList");
		String pOrgBoardID = request.getParameter("orgBoardID");
		String pDestItemIDList = request.getParameter("destItemIDList");
		String pDestBoardID = request.getParameter("destBoardID");
		String realPath = request.getServletContext().getRealPath("");
		String ret = "";
		
		int i = 0;
		for(String pOrgItemID : pOrgItemIDList.split(";")) {
			ret = ezCommunityService.copyItem(pOrgItemID, pOrgBoardID, pDestItemIDList.split(";")[i], pDestBoardID, realPath);
		}
		
		model.addAttribute("ret", "<RESULT>" + ret + "</RESULT>");
		
		return "json";
	}
	
	/**
	 * 복사시 일반/포토/익명 게시판 검사 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/checkIfAnonyBoard.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	public String checkIfAnonyBoard(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String ret = "";
		String pBoardID = request.getParameter("boardID");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		
		if (boardInfo.getGubun().equals("2") || !boardInfo.getUrl().trim().equals("") || boardInfo.getGubun().equals("3")) {
			ret = "anonyboard";
		} else {
			ret = "normalboard";
		}
		
		model.addAttribute("result", ret);
		
		return "json";
	}
	
	/**
	 * 알림마당 목록화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsList.do")
	public String bbsList(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, ModelMap model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String bName = "c_Board", sRadio = "", type = "", userLevel = "", code = "", keyword = "";
		String pKeyword = "", titleName = "";
		int curPage = 0, totalPage = 0, nowBlock = 0, myChoice = 0 , keywordCount = 0;
		int prevPage = 0, nextPage = 0 , totalBlock = 0, goPage = 0;
		int comNoPerPage = 17;
		
//		request.setCharacterEncoding("UTF-8");
		
		bName = request.getParameter("bName").toLowerCase();
		
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		if (request.getParameter("type") != null) {
			type = request.getParameter("type");
		}
		if (request.getParameter("userLevel") != null) {
			userLevel = request.getParameter("userLevel");
		}
		if (request.getParameter("code") != null) {
			code = request.getParameter("code");
		}
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
			pKeyword = new String(keyword.getBytes("ISO-8859-1"), "UTF-8");
		}
		if (request.getParameter("goToPage") != null) {
			curPage = Integer.parseInt(request.getParameter("goToPage"));
		}
		if (request.getParameter("block") != null && !request.getParameter("block").equals("")) {
			nowBlock = Integer.parseInt(request.getParameter("block"));
		}
		
		if (!code.equals("")) {
			titleName = ezCommunityService.getBoardTitleName(bName, code);
		}

		keywordCount = ezCommunityService.getBBSListGet1(bName, commonUtil.getMultiData(userInfo.getLang()), pKeyword, sRadio);
		totalPage = keywordCount / comNoPerPage;
		
		if (keywordCount % comNoPerPage != 0) {
			totalPage = totalPage + 1;
		}
		
		curPage = Math.min(curPage, totalPage);
		List<CommunityCBoardVO> cBoardList = ezCommunityService.getBBSListGet2(bName, commonUtil.getMultiData(userInfo.getLang()), pKeyword, sRadio);
		
		String strHTML = ezCommunityService.bbsList(userInfo, cBoardList, code, curPage, bName, comNoPerPage);

		model.addAttribute("idSpanVal", strHTML);
		model.addAttribute("keyword", keyword);
		model.addAttribute("curPage", curPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("titleName", titleName);
		model.addAttribute("bName", bName);
		model.addAttribute("block", nowBlock);
		model.addAttribute("rollInfo", userInfo.getRollInfo());
		model.addAttribute("code", code);
		
		return "/ezCommunity/communityBbsList";
	}
	
	/**
	 * 알림마당 읽기 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsViewNew.do")
	public String bbsNewViewNew(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String keyword = "", sRadio = "", pagec = "1";
		String strTitle = "", strWriteName = "", strWriterID = "";
		int myStep = 0, myLevel = 0, grsRef = 0, readNo = 0, grsNo = 0;	
		String previousItemID = "", nextItemID = "";
		String strWriteDate = "";
		int nowBlock = 0;
	
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String bName = request.getParameter("bName").toLowerCase();
		String mode = request.getParameter("mode");
		String no = request.getParameter("no");
		
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
		}
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		if (request.getParameter("block") != null && !request.getParameter("block").equals("")) {
			nowBlock = Integer.parseInt(request.getParameter("block"));
		}
		if (request.getParameter("pagec") != null) {
			pagec = request.getParameter("pagec");
		}
		
		int adminCheck = ezCommunityService.bbsAdminCheck(userInfo.getId(), userInfo.getRollInfo());
		String fileName = ezCommunityService.bbsEditGet1(bName, no);
		CommunityCBoardVO cBoardGet1 = ezCommunityService.bbsViewNewGet1(bName, no);
		
		if (cBoardGet1 != null) {
			strTitle = cBoardGet1.getTitle().trim().replaceAll("&quot;", "'").replaceAll("&dquot;", "\"");
			
			if (!bName.equals("c_clubnotice") && !bName.equals("c_notice")) {
				myStep = cBoardGet1.getStep();
				myLevel = cBoardGet1.getRe_Level();
				grsRef = cBoardGet1.getRef(); 
			}
			
			readNo = cBoardGet1.getReadNum();
			strWriteDate = cBoardGet1.getWriteDay().trim();
			
			if (commonUtil.getMultiData(userInfo.getLang()).equals("2")) {
				strWriteName = cBoardGet1.getUserName2();
			} else {
				strWriteName = cBoardGet1.getUserName();
			}
			
			strWriterID = cBoardGet1.getId().toLowerCase().trim();
			grsNo = cBoardGet1.getNo();
			
		} else {
			response.encodeRedirectURL("/error.do");
		}
		
		String previousTitle = egovMessageSource.getMessage("ezCommunity.t191");
		String nextTitle = egovMessageSource.getMessage("ezCommunity.t193");
		
		List<CommunityCBoardVO> cBoardList = ezCommunityService.bbsViewNewGet2(bName);
		
		for (int i = 0; i < cBoardList.size(); i++) {
			if (cBoardList.get(i).getNo() == grsNo) {
				if (i >= 1) {
					previousItemID = Integer.toString(cBoardList.get(i-1).getNo());
					previousTitle = cBoardList.get(i-1).getTitle();
				}
			}
		}
		
		for (int i = 0; i < cBoardList.size(); i++) {
			if (cBoardList.get(i).getNo() == grsNo) {
				if (i < cBoardList.size()-1) {
					nextItemID = Integer.toString(cBoardList.get(i+1).getNo());
					nextTitle = cBoardList.get(i+1).getTitle();
				}
			}
		} 
        
		model.addAttribute("bName", bName);
		model.addAttribute("mode", mode);
		model.addAttribute("no", no);
		model.addAttribute("nowBlock", nowBlock);
		model.addAttribute("strTitle", strTitle);
		model.addAttribute("myStep", myStep);
		model.addAttribute("myLevel", myLevel);
		model.addAttribute("grsRef", grsRef);
		model.addAttribute("readNo", readNo);
		model.addAttribute("grsNo", grsNo);
		model.addAttribute("pagec", pagec);		
		model.addAttribute("strWriteDate", strWriteDate);
		model.addAttribute("strWriteName", strWriteName);
		model.addAttribute("strWriterID", strWriterID);
		model.addAttribute("previousTitle", previousTitle);
		model.addAttribute("nextTitle", nextTitle);
		model.addAttribute("nextItemID", nextItemID);
		model.addAttribute("previousItemID", previousItemID);
		model.addAttribute("userInfo", userInfo);
		
		return "/ezCommunity/communityBbsViewNew";
	}
	
	/**
	 * 알림마당 쓰기/수정 화면 호출함수 
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsEditNew.do")
	public String bbsEditNew(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception{
		String code = "", sRadio = "", keyword = "", cID = "", no = "", fileName = "", title = "", grsUserName = "", attachFiles = "", writeFakerName = "";
		int pagec = 0, block = 0;
		String step = "", level = "", ref = "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String mode = request.getParameter("mode");
		String bName = request.getParameter("bName");
		
		if (request.getParameter("code") != null) {
			code = request.getParameter("code");
		}
		
		if (mode.equals("edit")) {
			sRadio = request.getParameter("sRadio");
			keyword = request.getParameter("keyword");
			no = request.getParameter("no");
			pagec = Integer.parseInt(request.getParameter("pagec"));
			block = Integer.parseInt(request.getParameter("block"));
		} else {
			step = request.getParameter("step");
			level = request.getParameter("level");
			ref = request.getParameter("ref");
			
			if (request.getParameter("no") != null) {
				no = request.getParameter("no");
			}
			if (request.getParameter("pagec") != null) {
				pagec = Integer.parseInt(request.getParameter("pagec"));
			}
		}
		
		//TODO 2016-04-27 이효진 사용하는곳 없음
		/*if (!code.equals("")){
			String titleName = ezCommunityService.getBoardTitleName(bName, code);
		}
		
		int adminCheck = ezCommunityService.bbsAdminCheck(userInfo.getId(), userInfo.getRollInfo());*/
		String serverName = request.getServerName();
		CommunityCBoardVO cBoardVO = null;
		
		if (!no.equals("")) { //  수정(mode :  "edit")  또는 답변(mode :  "write")

			fileName = ezCommunityService.bbsEditGet1(bName, no);
			cBoardVO = ezCommunityService.bbsEditNew(bName, no, commonUtil.getMultiData(userInfo.getLang()));
			
			 if (!no.equals("")) { // 수정(mode : "edit") 답변 (mode : "write")
				 if (userInfo.getLang().equals("2")) {
					 grsUserName = userInfo.getDisplayName2();
				 } else {
					 grsUserName = userInfo.getDisplayName1();
				 }
			 } else {
				 if (commonUtil.getMultiData(userInfo.getLang()).equals("2")) {
					 grsUserName = cBoardVO.getUserName2();
				 } else {
					 grsUserName = cBoardVO.getUserName();
				 }
			 }
			 
			 if (commonUtil.getMultiData(userInfo.getLang()).equals("2")) {
				 writeFakerName = cBoardVO.getUserName2();
			 } else {
				 writeFakerName = cBoardVO.getUserName();
			 }
		} else { // 쓰기(mode :  "write")
			if (userInfo.getLang().equals("2")) {
				grsUserName = userInfo.getDisplayName2();
			} else {
				grsUserName = userInfo.getDisplayName1();
			}
		}
		
		model.addAttribute("mode", mode);
		model.addAttribute("no", no);
		model.addAttribute("pagec", pagec);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("keyword", keyword);
		model.addAttribute("block", block);
		model.addAttribute("code", code);
		model.addAttribute("bName", bName);
		model.addAttribute("grsUserName", grsUserName);
		model.addAttribute("writerFakerName", writeFakerName);
		model.addAttribute("fileName", fileName);
		model.addAttribute("userInfoUserNM1", userInfo.getDisplayName1());
		model.addAttribute("userInfoUserNM2", userInfo.getDisplayName2());
		model.addAttribute("userInfoUserID", userInfo.getId());
		model.addAttribute("serverName", serverName);
		model.addAttribute("cBoard", cBoardVO);
		model.addAttribute("step", step);
		model.addAttribute("level", level);
		model.addAttribute("gref", ref);
		
		return "/ezCommunity/communityBbsEditNew";
	}
	
	/**
	 * 알림마당 쓰기/수정 실행함수 
	 */
	@RequestMapping(value = "/ezCommunity/bbsEditOk.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String bbsEditOk(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		return ezCommunityService.bbsEditOk(userInfo, request);
	}
	
	/**
	 * ckeditor 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/ckEditor.do")
	public String ckEditor(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		String pMode = "";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if(request.getParameter("DraftFlag") != null){
			pMode = request.getParameter("DraftFlag");
		}

		model.addAttribute("userInfo",userInfo);
		model.addAttribute("pMode", pMode);
		
		return "/ezCommunity/CKEditor";
	}
	
	/**
	 * mht파일 read 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/getCommunityContentInfo.do", method = RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public String getCommunityContentInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String type = request.getParameter("type");
		String itemID = request.getParameter("itemID");
		String realPath = request.getServletContext().getRealPath("");
		String uploadModule = config.getProperty("config.LocalPath");
		String strUrl = ezCommonService.getContentInfo(type, itemID);
		String filePath = "";
		String m_strMHT = "";

		if (type.equals("COMMUNITYNOTI")) {
			filePath = config.getProperty("upload_community.MAINBOARD") +commonUtil.separator; 
		} else {
			filePath = "";
		}

		try{
			m_strMHT = ezCommonController.loadMHTFile(realPath + filePath + strUrl);
		}catch(Exception e){
			m_strMHT = "";
		}
		
        String strHTML = ezCommonController.startMHT2HTML(realPath + uploadModule + commonUtil.separator, m_strMHT, realPath + uploadModule + commonUtil.separator);

        
        if (strHTML.trim().length() > 0) {
        	return strHTML;
        } else {
        	return "<HTML><HEAD><TITLE></TITLE><META content=\"text/html; charset=utf-8\" http-equiv=Content-Type><META name=GENERATOR content=\"MSHTML 8.00.7601.17622\"></HEAD><STYLE title=ezform_style_1>P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; *font-size:x-small; } </STYLE><BODY></BODY></HTML>";
        }
	}
	
	/**
	 * 알림마당 Delete 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/bbsDelOk.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String bbsDelOk(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = "";
		
		String itemNo = request.getParameter("itemNo");
		String goToPage = request.getParameter("goToPage");
		String bName = request.getParameter("bName");

		
		int adminCheck = ezCommunityService.bbsAdminCheck(userInfo.getId(), userInfo.getRollInfo());
		CommunityCBoardVO board = ezCommunityService.bbsDelOkGet(bName, itemNo, code);
		
		if (board.getId().trim().equals(userInfo.getId()) || adminCheck == 1 || userInfo.getRollInfo().indexOf("t=1") > -1 || userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
			return ezCommunityService.bbsDelOk(userInfo, request, board, itemNo, goToPage, bName, adminCheck);
		} else {
			return "ERROR";
		}
	}
	
	/**
	 * 방명록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/guestOne.do")
	public String guestOne(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "", keyword = "", sRadio = "";
		int totalPage = 0, curPage = 0, nowBlock = 0, comNoPerPage = 5;
		
		String code = request.getParameter("code");
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
		}
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio").toUpperCase();
		}
		if (request.getParameter("gotoPage") != null) {
			curPage = Integer.parseInt(request.getParameter("gotoPage"));
		} else {
			curPage = 1;
		}
		if (request.getParameter("block") != null) {
			nowBlock = Integer.parseInt(request.getParameter("block"));
		}
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
		
		int keywordCount = Integer.parseInt(ezCommunityService.guestOneGet1(sRadio, keyword, code, commonUtil.getMultiData(userInfo.getLang())));
		totalPage = keywordCount / comNoPerPage;

        if ((totalPage * comNoPerPage) != keywordCount && (keywordCount % comNoPerPage) != 0) {
            totalPage = totalPage + 1;
        }
        
        String strXML = ezCommunityService.guestOne(userInfo, sRadio, keyword, code, comNoPerPage, curPage);
        
		model.addAttribute("code", code);
		model.addAttribute("mode", mode);
		model.addAttribute("keyword", keyword);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("curPage", curPage);
		model.addAttribute("nowBlock", nowBlock);
		model.addAttribute("totalPage", totalPage);	
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("lang", commonUtil.getMultiData(userInfo.getLang()));
		model.addAttribute("strXML" , strXML);
		model.addAttribute("disable" , false);
		
		return "/ezCommunity/communityGuestOne";
	}
	
	/**
	 * 방명록 수정화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/guestEdit.do")
	public String guestEdit(@CookieValue("loginCookie") String loginCookie, CommunityCClubGuestVO item, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String no = request.getParameter("no");

		boolean bIsMyContent = false;
		
		item.setId(userInfo.getId());
		item.setUserName(userInfo.getDisplayName1());
		item.setUserName2(userInfo.getDisplayName2());
		
		if (mode.equals("edit")) {
			item = ezCommunityService.guestEditGet(code, commonUtil.getMultiData(userInfo.getLang()), no, userInfo.getId());
			
			if (item != null) {
				bIsMyContent = true;
			}
		}
		
		model.addAttribute("code", code);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("mode", mode);
		model.addAttribute("no", no);
		model.addAttribute("item", item);
		model.addAttribute("bIsMyContent", bIsMyContent);
		
		return "/ezCommunity/communityGuestEdit";
	}
	
	/**
	 * 방명록 쓰기/수정/삭제 실행함수 
	 */
	@RequestMapping(value = "/ezCommunity/guestEditOk.do")
	public String guestEditOk(@CookieValue("loginCookie") String loginCookie, ModelMap model, CommunityCClubGuestVO item, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean bIsMyContent = false;
		String[] cNo = request.getParameterValues("c_no");
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String memo = request.getParameter("memo");
		
		bIsMyContent = ezCommunityService.guestEditOk(userInfo, item, code, mode, memo, cNo, bIsMyContent);
		
		model.addAttribute("mode", mode);
		model.addAttribute("code", code);
		model.addAttribute("bIsMyContent", bIsMyContent);
		
		return "/ezCommunity/communityGuestEditOk";
	}

	/**
	 * 설문조사 목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollMain.do")
	public String pollMain(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int guest = 0;
		boolean disable = false;
		
		String code = request.getParameter("code");
		String userLevel = request.getParameter("userLevel");
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
		userLevel = ezCommunityService.pollMainGet1(userInfo.getId(), code);
		
		if (userLevel == null) {
			userLevel = "0";
		}
		
		String strXML = ezCommunityService.pollMain(userInfo, code);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("guest", guest);
		model.addAttribute("code", code);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("disable", disable);
		model.addAttribute("strXML", strXML);
		model.addAttribute("chCommunityAdmin", userInfo.getRollInfo().indexOf("t=1"));
		
		return "/ezCommunity/communityPollMain";
	}
	
	/**
	 * 설문조사 등록 화면1 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAdd.do")
	public String pollAdd(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pState = "", pSubject = "", pStartDate = "", pEndDate = "", pSelType = "", pSelRes1 = "", pSelRes2 = "", expireDays = "-1";
		
		String code = request.getParameter("code");
		
		if (request.getParameter("state") != null) {
			pState = request.getParameter("state");
		}
		
		if (pState.equals("PREV")) {
			if (request.getParameter("subject") != null) {
				pSubject = request.getParameter("subject");
			}
			
			if (request.getParameter("startDate") != null){
				pStartDate = request.getParameter("startDate");
			}
			
			if (request.getParameter("endDate") != null) {
				pEndDate = request.getParameter("endDate");
			}
			
			if (request.getParameter("selType") != null) {
				pSelType = request.getParameter("selType");
			}
			
			if (request.getParameter("selRes1") != null) {
				pSelRes1 = request.getParameter("selRes1");
			}
			
			if (request.getParameter("selRes2") != null) {
				pSelRes2 = request.getParameter("selRes2");
			}
		} else {
			pStartDate = EgovDateUtil.getToday("-");
			pEndDate = EgovDateUtil.getToday("-");
		}
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response);
		
		model.addAttribute("code", code);
		model.addAttribute("expireDays", expireDays);
		model.addAttribute("pState", pState);
		model.addAttribute("pSelType", pSelType);
		model.addAttribute("pSelRes1", pSelRes1);
		model.addAttribute("pSelRes2", pSelRes2);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("startDate", pStartDate);
		model.addAttribute("endDate", pEndDate);
		model.addAttribute("pSubject", pSubject);
		
		return "/ezCommunity/communityPollAdd";
	}
	
	/**
	 * 설문조사 등록 화면2 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAddOk.do")
	public String pollAddOk (ModelMap model, HttpServletRequest request) throws Exception {
		String selRes = "", answerViewType = "", selRes1="0";
		int sel = 0, answerCount = 0, selectedNo = 0;
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String startDate = request.getParameter("startPollYear") + "-" + request.getParameter("startPollMonth") + "-" + request.getParameter("startPollDay");
		String endDate = request.getParameter("endPollYear") + "-" + request.getParameter("endPollMonth") + "-" + request.getParameter("endPollDay");
		String subject = request.getParameter("pollSubject");
		String selType = request.getParameter("selType");
		String selRes2 = request.getParameter("selRes2");
		
		if (request.getParameter("selRes1") != null) {
			selRes1 = request.getParameter("selRes1");
		}
		
		if (subject != null) {
			if (selRes1.equals("0")) {
				selRes = selRes2;
				answerViewType = "0";
				sel = 1;
			} else {
				selRes = selRes1;
				answerViewType = selRes;
				sel = 0;
			}
		}
		
		String strXML = ezCommunityService.pollAddOk(sel, selType, selRes, selectedNo, answerCount, model);
		
		model.addAttribute("mode", mode);
		model.addAttribute("code", code);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("selRes", selRes);
		model.addAttribute("sel", sel);
		model.addAttribute("selType", selType);
		model.addAttribute("selJU", 0);
		model.addAttribute("answerViewType", answerViewType);
		model.addAttribute("subject", subject);
		model.addAttribute("idSpanValue", strXML);
		
		return "/ezCommunity/communityPollAddOk";
	}
	
	/**
	 * 설문조사 등록 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAddOkGo.do", method=RequestMethod.POST)
	public void pollAddOkGo(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezCommunityService.pollAddGo(userInfo, request, response);
	}
	
	/**
	 * 설문조사 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/pollDelete.do")
	public void pollDelete(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezCommunityService.pollDelete(userInfo, request, response);
	}
	
	/**
	 * 설문조사 읽기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollRes.do")
	public String poll(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String pollManagerID = request.getParameter("pollManagerID");
		String pollState = request.getParameter("pollState");
		
		String userLevel = ezCommunityService.pollResGet1(userInfo.getId(), code);
		
		if (userLevel == null) {
			userLevel = "0";
		}
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response);
		ezCommunityService.pollRes(userInfo, model, pollManagerID, pollState, response);
		
		model.addAttribute("code", code);
		model.addAttribute("pollState", pollState);
		
		return "/ezCommunity/communityPollRes";
	}
	
	/**
	 * 설문조사 응답 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/pollResOk.do", method = RequestMethod.POST)
	public void pollResOk(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String answerType = request.getParameter("answerType_1");
		String answerETC = request.getParameter("answerETC");
		String pollSelect = request.getParameter("pollSelect_1");
		String answerCount = request.getParameter("answerCount_1");
		String isSave = request.getParameter("isSave");
		String questionID = request.getParameter("questionID_1");
		
		ezCommunityService.pollResOk(userInfo, code, questionID, pollSelect, answerETC, isSave, answerType, answerCount, response);
	}
	
	/**
	 * 설문조사 날짜변경화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollEdit.do")
	public String pollEdit(ModelMap model,HttpServletRequest request) throws Exception {
		String pClubNo = request.getParameter("pClubNo");
		String managerID = request.getParameter("managerID");
		
		CommunityCPollManagerVO managerVO = ezCommunityService.pollEditGet1(managerID);
		
		String pStartDate = managerVO.getPollStartDate().split(" ")[0];
		String pEndDate = managerVO.getPollEndDate().split(" ")[0];
		
		CommunityCPollQuestionVO questionVO = ezCommunityService.pollEditGet2(managerID);
		
		model.addAttribute("pClubNo", pClubNo);
		model.addAttribute("managerID", managerID);
		model.addAttribute("managerVO", managerVO);
		model.addAttribute("pStartDate", pStartDate);
		model.addAttribute("pEndDate", pEndDate);
		model.addAttribute("questionVO", questionVO);
		
		return "/ezCommunity/communityPollEdit";
	}
	
	/**
	 * 설문조사 날짜변경 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/pollEditOk.do")
	public void pollEditOk(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String pClubNo = request.getParameter("pClubNo");
		String managerID = request.getParameter("managerID");
		String subject = request.getParameter("pollSubject");
		String startDate = request.getParameter("startPollYear") + "-" + request.getParameter("startPollMonth") + "-" + request.getParameter("startPollDay");
		String endDate = request.getParameter("endPollYear") + "-" + request.getParameter("endPollMonth") + "-" + request.getParameter("endPollDay");
		
		ezCommunityService.pollEditOk(pClubNo, subject, startDate, endDate, managerID, response);
	}
	
	/**
	 * 설문조사 답변 응답보기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollETCView.do")
	public String pollETCView(ModelMap model, HttpServletRequest request) throws Exception {
		String questionID = request.getParameter("questionID");
		String etc = request.getParameter("etc");
		
		String etcTotal = ezCommunityService.pollETCViewGet(questionID);
		
		if (etcTotal == null) {
			etcTotal = "0";
		}
		
		model.addAttribute("questionID", questionID);
		model.addAttribute("etc", etc);
		model.addAttribute("ETCTotal", etcTotal);
		
		return "/ezCommunity/communityPollETCView";
	}
	
	/**
	 * 설문조사 응답 테이블 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollETCTable.do")
	public String pollETCTable(ModelMap model, HttpServletRequest request) throws Exception {
		String questionID = request.getParameter("questionID");
		String etc = request.getParameter("etc");
		
		List<CommunityCPollResponseVO> responseList = ezCommunityService.pollETCTableGet(questionID);
		
		model.addAttribute("questionID", questionID);
		model.addAttribute("etc", etc);
		model.addAttribute("responseList", responseList);
		
		return "/ezCommunity/communityPollETCTable";
	}
	
	/**
	 * 회원목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commViewMember.do")
	public String commViewMember(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String keyword = "", sRadio = "", block = "";
		int curPage = 1;
		
		String code = request.getParameter("code");
		
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
		}
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		if (request.getParameter("goToPage") != null) {
			curPage = Integer.parseInt(request.getParameter("goToPage"));
		}
		if (request.getParameter("block") != null) {
			block = request.getParameter("block");
		}
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response);
		String keywordCount = ezCommunityService.commViewMemberGet2(code, commonUtil.getMultiData(userInfo.getLang()), keyword, sRadio);
		
		int comNoPerPage = 10;
        int totalPage = Integer.parseInt(keywordCount) / comNoPerPage;

        if ((totalPage * comNoPerPage) != Integer.parseInt(keywordCount) && (Integer.parseInt(keywordCount) % comNoPerPage) != 0){
        	totalPage = totalPage + 1;
        }
        
		String strSysopID = ezCommunityService.adminMemberListGet2(code).trim();
		String strXML = ezCommunityService.commViewMember(userInfo, code, strSysopID, keyword, sRadio, comNoPerPage, curPage);
		
		model.addAttribute("curPage", curPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("code", code);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("keyword", keyword);
		model.addAttribute("nowBlock", block);
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("strSysopID", strSysopID);
		model.addAttribute("strXML", strXML);
		
		return "/ezCommunity/communityCommViewMember";
	}
	
	/**
	 * 회원탈퇴 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commOut.do")
	public String commOut(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		CommunityClubVO club = ezCommunityService.aspCommInfoGet1(code);
		CommunityMemberInfoVO member = ezCommunityService.commOutGet(club.getC_SysopID().trim(), club.getCompanyID(), commonUtil.getMultiData(userInfo.getLang()));
		
		String sysopName = member.getUserName();
		
		if (sysopName.equals("")) {
			sysopName = egovMessageSource.getMessage("ezCommunity.t398", new Locale(globals.getProperty("Globals.language")));
		}
		
		if(commonUtil.getMultiData(userInfo.getLang()).equals("2")) {
			club.setC_ClubName(club.getC_ClubName2());
		}
		
		String strCategoryPrint = ezCommunityService.categoryPrint(club.getC_Cate_A().trim(), club.getC_Cate_B().trim(), club.getC_Cate_C().trim());
	
		model.addAttribute("code", code);
		model.addAttribute("club", club);
		model.addAttribute("sysopName", sysopName);
		model.addAttribute("str_category_print", strCategoryPrint);
		
		return "/ezCommunity/communityCommOut";
	}
	
	/**
	 * 회원탈퇴 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/commOutOk.do")
	@ResponseBody
	public String commOutOk(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData, HttpServletRequest request) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDoc = commonUtil.convertStringToDocument(xmlData);
		
		String code = xmlDoc.getElementsByTagName("CODE").item(0).getTextContent();
		String reason = xmlDoc.getElementsByTagName("REASON").item(0).getTextContent();
		
		String retValue = ezCommunityService.commOutOk(userInfo, code, reason);
		
		return retValue;
	}
	
	/**
	 * 관리메뉴 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/admin/index.do")
	public String adminIndex(HttpServletRequest request, ModelMap model) {
		String flag = "", num = "";
		String code = request.getParameter("code");
		
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		if (request.getParameter("num") != null) {
			num = request.getParameter("num");
		}
		
		model.addAttribute("code", code);
		model.addAttribute("flag", flag);
		model.addAttribute("num", num);
		
		return "/ezCommunity/communityAdminIndex";
	}
	
	/**
	 * 관리메뉴 왼쪽화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminLeft.do")
	public String adminLeft(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String num = "", pExcludeBoardID = " ", flag = "", clickBoard = "", boardID = "";
		String pRootBoardID = "TOP", pSubFlag = "0";
		int pSelectBy = 0, pMode = 0;
		
		String code = request.getParameter("code");
		
		if (request.getParameter("num") != null) {
			num = request.getParameter("num");
		}
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		if (request.getParameter("clickBoard ") != null) {
			clickBoard  = request.getParameter("clickBoard ");
		}
		if (request.getParameter("boardID ") != null) {
			boardID  = request.getParameter("boardID ");
		}
		
		CommunityClubVO club = ezCommunityService.adminLeftGet(code);
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		
		String boardGroupAdmin_FG = ezCommunityService.checkIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		
//		if (boardGroupAdmin_FG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1)
		if (boardGroupAdmin_FG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1) {
			pMode = 0;
		} else {
			pMode = 1;
		}

		String retXML = ezCommunityService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, code, commonUtil.getMultiData(userInfo.getLang()));
		
		if (retXML.substring(0, 5).toUpperCase().equals("ERROR")){
            retXML = "<RESULT>ERROR</RESULT>";
		}
		
		model.addAttribute("code", code);
		model.addAttribute("num", num);
		model.addAttribute("clickBoard", clickBoard);
		model.addAttribute("boardID", boardID);
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("flag", flag);
		model.addAttribute("club", club);
		model.addAttribute("xmlret", retXML);
		
		return "/ezCommunity/communityAdminLeft";
	}
	
	/**
	 * 관리메뉴 기본정보수정화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminBasic.do")
	public String adminBasic(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String name1 = "";
		String langPrimary = config.getProperty("config.lang_Primary" + userInfo.getLang());
		String langSecondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
		
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		
		if (sysopCheck != 1) {
			return "/error";
		}
		
		CommunityClubVO club = ezCommunityService.aspCommInfoGet1(code);
		
		if (club != null) {
			CommunityMemberInfoVO member = ezCommunityService.aspCommInfoGet2(commonUtil.getMultiData(userInfo.getLang()), club.getC_SysopID().trim());
			
			if (userInfo.getLang().equals("2")) {
				member.setUserName(member.getUserName2());
			}
			
			name1 = member.getUserName();
		}

		int pPermitCount = Integer.parseInt(ezCommunityService.adminMemPermitGet1(code));
		String cCateA = ezCommunityService.adminBasicGet1(code);
		String cCateB = ezCommunityService.adminBasicGet2(code);
		
		model.addAttribute("code", code);
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("club", club);
		model.addAttribute("name1", name1);
		model.addAttribute("pPermitCount", pPermitCount);
		model.addAttribute("c_cate_a", (cCateA == null) ? "" : egovMessageSource.getMessage("ezCommunity."+cCateA, new Locale(globals.getProperty("Globals.language"))));
		model.addAttribute("c_cate_b", (cCateB == null) ? "" : egovMessageSource.getMessage("ezCommunity."+cCateB, new Locale(globals.getProperty("Globals.language"))));
		model.addAttribute("lang_Primary", langPrimary);
		model.addAttribute("lang_Secondary", langSecondary);
		
		return "/ezCommunity/communityAdminBasic";
	}
	
	/**
	 * 관리메뉴 기본정보수정 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminBasicOk.do")
	public String adminBasicOk(@CookieValue("loginCookie")String loginCookie, CommunityClubVO clubVO, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		
		ezCommunityService.adminBasicOkUpdate(clubVO, code);
		
		model.addAttribute("code", code);
		model.addAttribute("sysopCheck", sysopCheck);
		
		return "/ezCommunity/communityAdminBasicOk";
	}
	
	/**
	 * 커뮤니티 환경설정화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminLogo.do")
	public String adminLogo(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		
		CommunityClubVO clubVO = ezCommunityService.adminLogoGet(code, commonUtil.getMultiData(userInfo.getLang()));
		String copType = ezCommunityService.commHomeGet4(code);
		
		clubVO.setC_Type(copType);
		
		if (userInfo.getLang().equals("2")) {
			clubVO.setC_ClubName(clubVO.getC_ClubName2());
		}
		
		model.addAttribute("code", code);
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("clubVO", clubVO);
		
		return "/ezCommunity/communityAdminLogo";
	}
	
	/**
	 * 커뮤니티 환경설정화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminLogoOk.do")
	public String adminLogoOk(@CookieValue("loginCookie")String loginCookie, ModelMap model, MultipartHttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = request.getParameter("code");

		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		
		ezCommunityService.adminLogoOk(request);
		
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("code", code);
		
		return "/ezCommunity/communityAdminLogoOk";
	}
	
	/**
	 * 홈 화면관리화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminHomeBoard.do")
	public String adminHomeBoard(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		String listHeader = "<HEADERS><HEADER><NAME>" + egovMessageSource.getMessage("ezCommunity.t1168", new Locale(globals.getProperty("Globals.language"))) + "</NAME><WIDTH>70</WIDTH></HEADER></HEADERS>";
		String listHeader2 = "<HEADERS><HEADER><NAME>" + egovMessageSource.getMessage("ezCommunity.t2015", new Locale(globals.getProperty("Globals.language"))) + "</NAME><WIDTH>70</WIDTH></HEADER></HEADERS>";
		String listHeader3 = "<HEADERS><HEADER><NAME>" + egovMessageSource.getMessage("ezCommunity.t2016", new Locale(globals.getProperty("Globals.language"))) + "</NAME><WIDTH>70</WIDTH></HEADER></HEADERS>";
		
		String returnVal = ezCommunityService.adminHomeBoard1(userInfo, code);
		String returnVal2 = ezCommunityService.adminHomeBoard2(userInfo, code);
		String returnVal3 = ezCommunityService.adminHomeBoard3(userInfo, code);

		returnVal = "<LISTVIEWDATA>" + listHeader + "<ROWS>" + returnVal + "</ROWS></LISTVIEWDATA>";
		returnVal2 = "<LISTVIEWDATA>" + listHeader2 + "<ROWS>" + returnVal2 + "</ROWS></LISTVIEWDATA>";
		returnVal3 = "<LISTVIEWDATA>" + listHeader3 + "<ROWS>" + returnVal3 + "</ROWS></LISTVIEWDATA>";
		
		model.addAttribute("code", code);
		model.addAttribute("returnVal", returnVal);
		model.addAttribute("returnVal2", returnVal2);
		model.addAttribute("returnVal3", returnVal3);
		model.addAttribute("listHeader", listHeader);
		model.addAttribute("listHeader2", listHeader2);
		model.addAttribute("listHeader3", listHeader3);
		
		return "/ezCommunity/communityAdminHomeBoard";
	}
	
	/**
	 * 홈 화면관리 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveHomeBoard.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveHomeBoard (@RequestBody String xmlData) throws Exception {
		Document xmlDom = commonUtil.convertStringToDocument(xmlData);
		
		String code = xmlDom.getElementsByTagName("CODE").item(0).getTextContent();
        String left = xmlDom.getElementsByTagName("LEFT").item(0).getTextContent();
        String right = xmlDom.getElementsByTagName("RIGHT").item(0).getTextContent();
        
		try{
	        ezCommunityService.adminHomeBoardSet("TRUE", "", 0, code, "");
	        
	        if (!left.equals("")) {
	        	int i = 1;
	        	
	        	for (String splitLeft : left.split(";")) {
	        		ezCommunityService.adminHomeBoardSet("FLASE", "1", i, code, splitLeft);
	        		i++;
	        	}
	        }
	        
	        if (!right.equals("")){
	        	int i = 1;
	        	
	        	for (String splitRight : right.split(";")) {
	        		ezCommunityService.adminHomeBoardSet("FLASE", "2", i, code, splitRight);
	        		i++;
	        	}
	        }
	        
	        return "OK";
		} catch (Exception e) {
			return "ERROR";
		}
	}
	
	/**
	 * 게시판 관리화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardProperty.do")
	public String adminBoardProperty (@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String style = "";
		String useMultiData = config.getProperty("config.Use_MultiData");
		String langPrimary = config.getProperty("config.lang_Primary"+userInfo.getLang());
		String langSecondary = config.getProperty("config.lang_Secondary"+userInfo.getLang());
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		CommunityBoardPropertyVO boardProp = ezCommunityService.getBoardProperty(boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
		}
		
		if (boardProp.getDeleteAfter() == null) {
			boardProp.setDeleteAfter("-1");
		}
		
		if (boardProp.getBoardColor() == null) {
			boardProp.setBoardColor("#000000");
		}
		
		if (ezCommunityService.boardPropertyGet(boardID) > 0) {
			style = "display:none";
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("useMultiData", useMultiData);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("boardProp", boardProp);
		model.addAttribute("_style", style);
		
		return "/ezCommunity/communityAdminBoardProperty";
	}
	
	/**
	 * 게시판 관리메뉴 일반설정 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveBoardProperty.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveBoardProperty(@RequestBody String xmlData, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String ret = ezCommunityService.saveBoardProperty(userInfo.getId(), xmlData);
		
		ezCommunityService.deleteBoard();
		
		return "<RESULT>" + ret + "</RESULT>";
	}
	
	/**
	 * 그룹생성화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardGroupCreate.do")
	public String boardGroupCreate(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary = config.getProperty("config.lang_Primary"+userInfo.getLang());
		String langSecondary = config.getProperty("config.lang_Secondary"+userInfo.getLang());
		
		String code = request.getParameter("code");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String boardID = request.getParameter("boardID");
		
		model.addAttribute("code", code);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("lang_Primary", langPrimary);
		model.addAttribute("lang_Secondary", langSecondary);
		
		return "/ezCommunity/communityAdminBoardGroupCreate";
	}
	
	/**
	 * 그룹생성화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/createBoardGroup.do")
	public void createBoardGroup(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardGroupID = request.getParameter("boardGroupID");
		String boardGroupName = request.getParameter("boardGroupName");
		String boardGroupName2 = request.getParameter("boardGroupName2");
		String code = request.getParameter("code");
		
		ezCommunityService.createBoardGroup(code, boardGroupID, boardGroupName, boardGroupName2, userInfo);
	}
	
	/**
	 * 순서변경화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardOrder.do")
	public String boardOrder(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String boardID = request.getParameter("boardID");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
		}
		
		model.addAttribute("code", code);
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("upperBoardID", parentBoardID);
		model.addAttribute("boardName", boardInfo.getBoardName());

		return "/ezCommunity/communityAdminBoardOrder";
	}
	
	/**
	 * 게시판관리 Tree 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminGetSubBoards.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String adminGetSubBoards(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pExcludeBoardID = " ";
		int pMode = 0;
		
		String upperBoardID = request.getParameter("upperBoardID");
		String code = request.getParameter("code");
		
		if (request.getParameter("pExcludeBoardID") != null) {
			pExcludeBoardID = request.getParameter("pExcludeBoardID");
		}
		
		String strXML = ezCommunityService.getBoardTree(upperBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, 1, 0, pExcludeBoardID, code, commonUtil.getMultiData(userInfo.getLang()));

		return strXML;
	}
	
	/**
	 * 순서변경 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveBoardOrder.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveBoardOrder(@RequestBody String xmlData, HttpServletRequest request) throws Exception {
		String ret = ezCommunityService.saveBoardOrder(xmlData);
		
		ezCommunityService.deleteBoard();
		
		ret = "<RESULT>" + ret + "</RESULT>";

		return ret;
	}
	
	/**
	 * 하위게시판 생성화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardCreate.do")
	public String boardCreate(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary = config.getProperty("config.lang_Primary"+userInfo.getLang());
		String langSecondary = config.getProperty("config.lang_Secondary"+userInfo.getLang());
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("lang_Primary", langPrimary);
		model.addAttribute("lang_Secondary", langSecondary);
		model.addAttribute("parentBoardName", boardInfo.getBoardName());
		
		return "/ezCommunity/communityAdminBoardCreate";
	}
	
	/**
	 * 하위게시판 생성 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/createBoard.do", method = RequestMethod.POST)
	public void createBoard(@CookieValue("loginCookie") String loginCookie , HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String boardName = request.getParameter("boardName");
		String boardName2 = request.getParameter("boardName2");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		//첨부 용량 제한 [이성우]
		String comatt = "10";
		
		ezCommunityService.createBoardInsert(code, boardID, boardName, boardName2, parentBoardID, boardGroupID, comatt, userInfo);
	}
	
	/**
	 * 게시판이동화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardMove.do")
	public String boardMove(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("boardName", boardInfo.getBoardName());
		
		return "/ezCommunity/communityAdminBoardMove";
	}
	
	/**
	 * 대상게시판선택화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardMoveSelect.do")
	public String boardMoveSelect() throws Exception {
		return "/ezCommunity/communityAdminBoardMoveSelect";
	}
	
	/**
	 * 게시판이동 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/moveBoard.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String moveBoard(HttpServletRequest request) throws Exception {
		String orgBoardID = request.getParameter("orgBoardID");
		String newParentBoardID = request.getParameter("newParentBoardID");
		String newBoardGroupID = request.getParameter("newBoardGroupID");
		
		String ret = ezCommunityService.moveBoard(orgBoardID, newParentBoardID, newBoardGroupID);
		
		ezCommunityService.deleteBoard();
		
		return "<RESULT>" + ret + "</RESULT>";
	}
	
	/**
	 * 게시판삭제화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardDelete.do")
	public String boardDelete(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName2());
		}
		
		String strXML = ezCommunityService.getBoardTree(boardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), 0, 1, 0, " ", code, commonUtil.getMultiData(userInfo.getLang()));
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("boardName", boardInfo.getBoardName());
		model.addAttribute("xmlret", strXML);
		
		return "/ezCommunity/communityAdminBoardDelete";
	}
	
	/**
	 * 게시판삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/deleteBoard.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String delete(HttpServletRequest request) throws Exception {
		String boardID = request.getParameter("boardID");
		
		String ret = ezCommunityService.brdDeleteBoard(boardID);
		ezCommunityService.deleteBoard();
		
		ret = "<RESULT>" + ret + "</RESULT>";
		
		return ret;
	}

	/**
	 * 관리메뉴 게시판검색화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminSearchBoardItem.do")
	public String adminSearchBoardItem(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String title = "", writerName = "", abstracts = "", searchStart = "", searchEnd = "", startDateTime = "", endDateTime = "";
		int pPage = 1, totalCount = 0, totalPage = 0;
		String strXML = "";
		
		String boardID = request.getParameter("boardID");
		String parentBoardID = request.getParameter("parentBoardID");
		String boardGroupID = request.getParameter("boardGroupID");
		String code = request.getParameter("code");
		
		String orgBoardParameters = request.getParameter("orgBoardParameters");
		
		if (request.getParameter("page") != null) {
			pPage = Integer.parseInt(request.getParameter("page"));
		}
		if (request.getParameter("title") != null) {
			title = request.getParameter("title");
		}
		if (request.getParameter("writerName") != null) {
			writerName = request.getParameter("writerName");
		}
		if (request.getParameter("abstract") != null) {
			abstracts = request.getParameter("abstract");
		}
		if (request.getParameter("searchStart") != null) {
			searchStart = request.getParameter("searchStart");
		}
		if (request.getParameter("searchEnd") != null) {
			searchEnd = request.getParameter("searchEnd");
		}
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		
		if (userInfo.getLang().equals("2")) {
			boardInfo.setBoardName(boardInfo.getBoardName());
		}
		
		int pStartRow = (pPage - 1) * boardInfo.getSs_SearchBoard_MaxRows() + 1;
        int pEndRow = pPage * boardInfo.getSs_SearchBoard_MaxRows();

        if (!searchStart.equals("")) {
        	startDateTime = searchStart.split(" ")[0];
        	endDateTime = searchEnd.split(" ")[0];
        }

        if (!title.equals("") || !writerName.equals("") || !abstracts.equals("") || !searchStart.equals("")) {
        	totalCount = Integer.parseInt(ezCommunityService.adminSearchItemCount(userInfo.getId(), boardID, title, writerName, abstracts, startDateTime, endDateTime));
            strXML = ezCommunityService.adminSearchItemXML(userInfo.getId(), boardID, title, writerName, abstracts, searchStart, searchEnd, pStartRow, pEndRow, commonUtil.getMultiData(userInfo.getLang()));
            
            if (totalCount > 0) {
				if (totalCount > boardInfo.getSs_SearchBoard_MaxRows()) {
					if(totalCount % boardInfo.getSs_SearchBoard_MaxRows() > 0) {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows() + 1;
					} else {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows();
					}
				} else {
					totalPage = 1;
				}
			} else {
				totalPage = 1;
			}
        }
        
        model.addAttribute("boardID", boardID);
		model.addAttribute("parentBoardID", parentBoardID);
		model.addAttribute("boardGroupID", boardGroupID);
		model.addAttribute("code", code);
		model.addAttribute("boardName", boardInfo.getBoardName());
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("orgBoardParameters", orgBoardParameters);
        model.addAttribute("searchStart", startDateTime);
        model.addAttribute("searchEnd", endDateTime);
        model.addAttribute("strXML", strXML);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("title", title);
        model.addAttribute("writerName", writerName);
        model.addAttribute("abstract", abstracts);
        
		return "/ezCommunity/communityAdminSearchBoardItem";
	}
	
	/**
	 * 검색 대상게시판 선택화면 호출
	 */
	@RequestMapping(value = "/ezCommunity/boardSelect.do")
	public String boardSelect(ModelMap model, HttpServletRequest request) {
		String code = request.getParameter("code");
		
		model.addAttribute("code", code);
		
		return "/ezCommunity/communityBoardSelect";
	}
	
	/**
	 * 탈퇴희망자 승인화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminOuterList.do")
	public String adminOuterList(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		/*int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		
		if (sysopCheck != 1) {
			return "/error";
		}*/
		
		Integer postCount = ezCommunityService.adminOuterListGet1(code);
		
		if (postCount == null) {
			postCount = 0;
		}
		
		String idSpanValue = ezCommunityService.adminOuterList(userInfo, code);

		model.addAttribute("code", code);
		model.addAttribute("postCount", postCount);
		model.addAttribute("idSpanValue", idSpanValue);
		
		return "/ezCommunity/communityAdminOuterList";
	}
	
	/**
	 * 탈퇴희망자 승인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminOuterOkNo.do")
	public String adminOuterOkNo(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String flag = request.getParameter("flag");
		String userID = request.getParameter("userID");
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		
		ezCommunityService.adminOuterOkNoSet(flag.toUpperCase(), userID, code);
		
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("code", code);
		
		return "/ezCommunity/communityAdminOuterOkNo";
	}
	
	/**
	 * 회원 탈퇴처리화면/마스터이취임화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminMemberList.do")
	public String adminMemberList(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String flag = "", ser = "";
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		
		if (request.getParameter("ser") != null) {
			ser = request.getParameter("ser");
		}
		
		ser = ser.replace("'", "''");		
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		Integer postCount = ezCommunityService.adminMemberListGet1(code);
		String strSysopID = ezCommunityService.adminMemberListGet2(code);
		String idSpanValue = ezCommunityService.adminMemberList(userInfo, code, flag, ser, strSysopID, mode);
		
		model.addAttribute("code", code);
		model.addAttribute("mode", mode);
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("postCount", postCount);
		model.addAttribute("strSysopID", strSysopID);
		model.addAttribute("idSpanValue", idSpanValue);
		
		return "/ezCommunity/communityAdminMemberList";
	}
	
	/** 
	 * 회원 탈퇴처리화면/마스터이취임화면 실행함수
	 */
	@RequestMapping( value = "/ezCommunity/adminMemberListOk.do")
	String adminMemberListOk(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		CommunityCClubUserVO clubUser = null;
		int userMode = 0;
		boolean existOutList = false;
		String propList = "extensionAttribute2;company;description;displayName;title;mail;telephoneNumber;mobile;info;homePhone;facsimileTelephoneNumber;postalCode;streetAddress";
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String cID = request.getParameter("cID");
		String cNM = request.getParameter("cNM");
		String companyID = request.getParameter("companyID");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		String infoXML = ezOrganAdminService.getPropertyList(cID, propList, config.getProperty("config.primary"));
		
		Document xmldom = commonUtil.convertStringToDocument(infoXML);
		
		CommunityMemberInfoVO memberInfo = new CommunityMemberInfoVO();
		memberInfo.setDeptName(xmldom.getElementsByTagName("DESCRIPTION").item(0).getTextContent());
		memberInfo.setHandPhone(xmldom.getElementsByTagName("MOBILE").item(0).getTextContent());
		memberInfo.setCompanyFax(xmldom.getElementsByTagName("FACSIMILETELEPHONENUMBER").item(0).getTextContent());
		memberInfo.setCompanyZip(xmldom.getElementsByTagName("POSTALCODE").item(0).getTextContent());
		memberInfo.setCompanyAddress(xmldom.getElementsByTagName("STREETADDRESS").item(0).getTextContent());
		memberInfo.setUserName(xmldom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent());
		memberInfo.setCompanyTel(xmldom.getElementsByTagName("TELEPHONENUMBER").item(0).getTextContent());
		
		CommunityMemberInfoVO memberInfoVO = ezCommunityService.getMemberInfo(companyID, cID);
		
		if (memberInfoVO != null) {
			clubUser = ezCommunityService.adminMemberListOkGet(code, cID, companyID);
			
			if (clubUser != null) {
				if (clubUser.getC_birth() != 0 && !memberInfoVO.getBirthDay().trim().equals("")) {
					if (memberInfoVO.getBirthDay().trim().substring(0, 1).equals("-")) {
						memberInfoVO.setBirthDay("(" + egovMessageSource.getMessage("ezCommunity.t538", new Locale(globals.getProperty("Globals.language"))) + memberInfoVO.getBirthDay().trim().substring(1, memberInfoVO.getBirthDay().trim().length() - 1));
					} else {
						memberInfoVO.setBirthDay("(" + egovMessageSource.getMessage("ezCommunity.t539", new Locale(globals.getProperty("Globals.language"))) + memberInfoVO.getBirthDay().trim().substring(1, memberInfoVO.getBirthDay().trim().length() - 1));
					}
				}
			} else {
				userMode = 1;
			}
		} else {
			userMode = 1;
		}
		
		Integer result = ezCommunityService.adminMemberListOkGetE(code, cID);
		
		if (result != null) {
			if (result > 0) {
				existOutList = true;
			}
		}

		model.addAttribute("code", code);
		model.addAttribute("mode", mode);
		model.addAttribute("cID", cID);
		model.addAttribute("cNM", cNM);
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("memberInfo", memberInfo);
		model.addAttribute("memberInfoVO", memberInfoVO);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("clubUser", clubUser);
		model.addAttribute("userMode", userMode);
		model.addAttribute("existOutList", existOutList);
		
		return "/ezCommunity/communityAdminMemberListOk";
	}
	
	/** 
	 * 회원 탈퇴처리화면/마스터이취임화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminMemberListOkGo.do")
	public String adminMemberListOkGo(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String cID = request.getParameter("cID");
		String userName = request.getParameter("userName");
		String cNm = request.getParameter("cNm");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		
		ezCommunityService.adminMemberListOkGoSe(mode.toUpperCase(), code, cID, cNm);
		
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("code", code);
		model.addAttribute("mode", mode);
		model.addAttribute("userName", userName);
		
		return "ezCommunity/communityAdminMemberListOkGo";
	}
	
	/**
	 * Cop 폐쇄신청화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminCommClose.do")
	public String adminCommClose(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		CommunityClubVO club = ezCommunityService.aspCommInfoGet1(code);
		
		ezCommunityService.aspCommInfoGet2(commonUtil.getMultiData(userInfo.getLang()), club.getC_SysopID().trim());
		
		CommunityMemberInfoVO member = ezCommunityService.aspCommInfoGet2(commonUtil.getMultiData(userInfo.getLang()), club.getC_SysopID().trim());
		
		String sysopName = member.getUserName();
		
		if (userInfo.getLang().equals("2")) {
			sysopName = member.getUserName2();
		}
		
		if (sysopName.equals("")) {
			sysopName = egovMessageSource.getMessage("ezCommunity.t398", new Locale(globals.getProperty("Globals.language")));
		}
		
		String strCategoryPrint = ezCommunityService.categoryPrint(club.getC_Cate_A().trim(), club.getC_Cate_B().trim(), club.getC_Cate_C().trim());
				
		model.addAttribute("code", code);
		model.addAttribute("sysopName", sysopName);
		model.addAttribute("club", club);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strCategoryPrint", strCategoryPrint);
		
		return "/ezCommunity/communityAdminCommClose";
	}
	
	/**
	 * Cop 폐쇄신청 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminCommCloseOk.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String adminCommCloseOk(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String strXML = "";
		
		String code = request.getParameter("code");
		String reason = request.getParameter("reason");
		reason = reason.replace("'", "''");
		
		CommunityCComCloseVO closeVO = ezCommunityService.adminCommCloseOkGet1(code);
		
		if (closeVO != null) {
			strXML = "<RETURN><VALUE>ExistApplication</VALUE></RETURN>";
		} else {
			CommunityClubVO clubVO = ezCommunityService.adminCommCloseOkGet2(code);
			
			if (clubVO != null) {
				 String commName = clubVO.getC_ClubName().trim();
                 commName = commName.replace("'", "''");
                 // 20100108 : 폐쇄신청 \" -> "로 나오도록 수정
                 //commName = commName.Replace("\"", "\\\"");

                 String commName2 = clubVO.getC_ClubName2().trim();
                 commName2 = commName2.replace("'", "''");
                 // 20100108 : 폐쇄신청 \" -> "로 나오도록 수정
                 //commName2 = commName2.Replace("\"", "\\\"");

                 String sysopID = clubVO.getC_SysopID().trim();
                 String companyName = userInfo.getCompanyName1();
                 
                 ezCommunityService.adminCommCloseOkInser(code, commName, commName2, sysopID, companyName, EgovDateUtil.getTodayTime(), reason, egovMessageSource.getMessage("ezCommunity.t483", new Locale(globals.getProperty("Globals.language"))));
                 
                 strXML = "<RETURN><VALUE>SuccessApplication</VALUE></RETURN>";
			}
		}
		
		return strXML;
	}
	
	/**
	 * 메인페이지화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/mainPage.do")
	public String mainPage(@CookieValue("loginCookie") String loginCookie, ModelMap model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useIE11Browser = config.getProperty("config.IE11EDITOR");

		int totalPage = ezCommunityService.mainPage(userInfo);
		
		model.addAttribute("useIE11Brower", useIE11Browser);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("totalPage", totalPage);
		
		return "/ezCommunity/communityMainPage";
	}
	
	/**
	 * My 커뮤니티 새글 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/myCopNewBoardItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String myCopNewBoardItem (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int page = Integer.parseInt(request.getParameter("page"));
		
		int startRow = (3 * (page - 1)) + 1;
		int endRow = 3 * page;
		
		return ezCommunityService.myCopNewBoardItem(userInfo, startRow, endRow);
	}
	
	/**
	 * 우수커뮤니티/ 신규커뮤니티 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getBestNewCommunity.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getBestNewCommunity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = request.getParameter("mode");
		
		return ezCommunityService.getBestNewCommunity(userInfo, mode);
	}
	
	/**
	 * 회원가입화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/join1.do")
	public String join1(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String no = request.getParameter("no");
		
		String clubName = ezCommunityService.join1Get(no, commonUtil.getMultiData(userInfo.getLang()));
		
		model.addAttribute("clubName", clubName);
		model.addAttribute("no", no);
		
		return "/ezCommunity/communityJoin1";
	}
	
	//TODO 2016-06-16 이효진 승인 필요한 회원가입
	/**
	 * 회원가입화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/join2.do")
	public String join2(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String no = request.getParameter("no");
		
		String clubName = ezCommunityService.join1Get(no, commonUtil.getMultiData(userInfo.getLang()));
		
		model.addAttribute("clubName", clubName);
		model.addAttribute("no", no);
		
		return "/ezCommunity/communityJoin2";
	}
	
	/**
	 * 회원가입화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/agreeOk.do")
	public String agreeOk(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean bCanJoin = true;
		
		String code = request.getParameter("code");
		
		String userLevel = ezCommunityService.pollMainGet1(userInfo.getId(), code);
		
		if (userLevel != null) {
			bCanJoin = false;
		}
		
		model.addAttribute("code", code);
		model.addAttribute("bCanJoin", bCanJoin);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userLevel", userLevel);
		
		return "/ezCommunity/communityAgreeOk";
	}
	
	/**
	 * 회원가입 정보입력화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/join.do")
	public String join(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");

		CommunityClubVO clubVO = ezCommunityService.adminNoticeMailOkGet1(code);
		String clubName = ezCommunityService.joinGet1(code, commonUtil.getMultiData(userInfo.getLang()));
		String sysUserName = ezCommunityService.joinGet2(clubVO.getC_SysopID().trim(), clubVO.getCompanyID(), commonUtil.getMultiData(userInfo.getLang()));
		
		clubVO.setC_ClubName(clubName);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("code", code);
		model.addAttribute("clubVO", clubVO);
		model.addAttribute("sysUserName", sysUserName);

		return "/ezCommunity/communityJoin";
	}
	
	/**
	 * 회원가입 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/joinOk.do")
	public String joinOk(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean bCanJoin = true;
		String openJob = "0", openBirth = "0";
		
		String code = request.getParameter("code");
		String cIntro = request.getParameter("cIntro");
		String birthType = request.getParameter("birthType");
		String birthYear = request.getParameter("birthYear");
		String openEmail = request.getParameter("openEmail");
		String openHp = request.getParameter("openHp");
		String openComp = request.getParameter("openComp");
		String openHouse = request.getParameter("openHouse");
		String openSex = request.getParameter("openSex");
		String birthDay = request.getParameter("birthDay ");
		String birthMonth = request.getParameter("birthMonth");
		String gender = request.getParameter("gender");
		
		if(request.getParameter("openBirth") != null) {
			openBirth = request.getParameter("openBirth");
		}
		
		String userLevel = ezCommunityService.joinOkGet1(code, userInfo.getId());
		
		if (userLevel != null) {
			bCanJoin = false;
		}
		
		ezCommunityService.joinOkSet1(code, userInfo.getId(), EgovDateUtil.getTodayTime(), userInfo.getCompanyID());
		
		String cID = ezCommunityService.joinOkGet2(code, userInfo.getId());
		CommunityClubVO clubVO = ezCommunityService.joinOkGet3(code, commonUtil.getMultiData(userInfo.getLang()));

		if(clubVO.getC_ClubConfirmType().equals("1") || clubVO.getC_ClubConfirmType().equals("2")) {
			if (openBirth.equals("1")) {
				birthDay = birthType + birthYear + "-" + birthMonth + "-" + birthDay;
			} else {
				birthDay = "";
			}
			
			ezCommunityService.JoinOkUpdate1(userInfo.getId(), code, cIntro, openEmail, openHp, openComp, openBirth, openSex, openHouse);
			CommunityMemberInfoVO memberInfoVO = ezCommunityService.joinOkGet4(userInfo.getCompanyID(), userInfo.getId());
			
			if (memberInfoVO != null) {
				ezCommunityService.JoinOkUpdate3(userInfo.getCompanyID(), userInfo.getId(), birthDay);
			} else {
				ezCommunityService.joinOkInsert(userInfo.getCompanyID(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getCompanyName1(), userInfo.getCompanyName2(), "", "", userInfo.getDeptName1(), userInfo.getDeptName2(), "", "", "", userInfo.getPhone(), userInfo.getEmail(), birthDay, gender);
			}
			
			
		} else {
			if (clubVO.getC_ClubConfirmType().equals("3")) {
				ezCommunityService.joinOkUpdate2(userInfo.getId(), code, cIntro, openEmail, openHp, openComp, openHouse, openJob, openBirth, openSex);

				if (openBirth.equals("1")) {
					birthDay = birthType + birthYear + "-" + birthMonth + "-" + birthDay;
				} else {
					birthDay = "";
				}
				
				ezCommunityService.JoinOkUpdate1(userInfo.getId(), code, cIntro, openEmail, openHp, openComp, openBirth, openSex, openHouse);
				CommunityMemberInfoVO memberInfoVO = ezCommunityService.joinOkGet4(userInfo.getCompanyID(), userInfo.getId());
				
				if (memberInfoVO != null) {
					ezCommunityService.JoinOkUpdate3(userInfo.getCompanyID(), userInfo.getId(), birthDay);
				} else {
					ezCommunityService.joinOkInsert(userInfo.getCompanyID(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getCompanyName1(), userInfo.getCompanyName2(), "", "", userInfo.getDeptName1(), userInfo.getDeptName2(), "", "", "", userInfo.getPhone(), userInfo.getEmail(), birthDay, gender);
				}
			}
		}

//		sendMail()
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("code", code);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("bCanJoin", bCanJoin);
		model.addAttribute("cID", cID);
		model.addAttribute("clubVO", clubVO);
		
		return "/ezCommunity/communityJoinOk";
	}
	
	/**
	 * 승인필요한 커뮤니티 가입시 검사 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/remote/getACL.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String remoteGetACL (HttpServletRequest request) throws Exception {
		String cID = request.getParameter("cID");
		String uID = request.getParameter("uID");

		String gClubG = ezCommunityService.getACLGet1(cID);
		String cPermit = ezCommunityService.getACLGet2(uID, cID);
		
		if (cPermit == null || cPermit.equals("0")) {
			if (gClubG.trim().equals("3")) {
				return "ERR";
			} else if (gClubG.trim().equals("2")) {
				return "OK";
			} else {
				return "";
			}
		} else {
			return "OK";
		}
	}
	
	/**
	 * OpenAlertUI 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/ezAprAlert.do")
	public String ezAprAlert () {
		return "/ezCommunity/communityAprAlert";
	}
	
	/**
	 * OpenInformationUI 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/ezAPROPINION.do")
	public String ezAPROPINION () throws Exception {
		return "/ezCommunity/communityAprOption";
	}
	
	/**
	 * 비공개 커뮤니티 가입/미가입 체크 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/getIsJoin.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getIsJoin (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		String cPermit = ezCommunityService.leftCommunityGet1(code, userInfo.getId());
		
		if (cPermit != null) {
			return "TRUE";
		} else {
			return "FALSE";
		}
	}
	
	/**
	 * 커뮤니티 가입희망자 승인화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminMemPermit.do")
	public String adminMemPermit(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String code = request.getParameter("code");

		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		String postCount = ezCommunityService.adminMemPermitGet1(code);		
		String idSpanValue = ezCommunityService.adminMemPermit(userInfo, code);
		
		model.addAttribute("code", code);
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("postCount", postCount);
		model.addAttribute("idSpanValue", idSpanValue);
		return "/ezCommunity/communityAdminMemPermit";
	}
	
	/**
	 * 커뮤니티 가입희망자 승인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/adminOkNo.do")
	public String adminOkNo(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String flag = request.getParameter("flag");
		String cID = request.getParameter("cID");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		
		ezCommunityService.okNoSet(flag.toUpperCase(), code, cID);
		
//		sendMail();
		
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("code", code);
		
		return "/ezCommunity/communityAdminMemPermit";
	}
	
	/**
	 * 오늘의 커뮤니티 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/todayCop.do", method = RequestMethod.POST)
	public String todayCop(@CookieValue("loginCookie") String loginCookie, ModelMap model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int num = 0;
		String cCatecAName = "", cCatecBName = "";
		
		Calendar calendar = Calendar.getInstance();
		int dayOfYear = calendar.get(Calendar.DAY_OF_YEAR);
		
		String rtnVal = ezCommunityService.todayCopGet1();
		
		if (rtnVal == null) {
			num = 1;
		} else {
			num = (dayOfYear % Integer.parseInt(rtnVal)) + 1;
		}
		
		CommunityClubVO club = ezCommunityService.todayCopGet2(num);
		
		if (!club.getC_Cate_A().equals("0")){
			cCatecAName = ezCommunityService.todayCopGet3(club.getC_Cate_A(), "A");
		}
		
		if (!club.getC_Cate_B().equals("0")){
			cCatecBName = ezCommunityService.todayCopGet3(club.getC_Cate_B(), "B");
		}
		
		String itemCnt = ezCommunityService.categoryListItemCntGet(club.getC_ClubNo()); 
		
		model.addAttribute("clubVO", club);
		model.addAttribute("cCateAName", cCatecAName);
		model.addAttribute("cCateBName", cCatecBName);
		model.addAttribute("itemCnt", itemCnt);
		
		return "json";
	}
	
	/**
	 * 카테고리별 커뮤니티화면 업무별/종류별 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/myCategoryCop.do", method = RequestMethod.POST)
	@ResponseBody
	public String myCategoryCop (ModelMap model, HttpServletRequest request) throws Exception {
		StringBuilder sb = new StringBuilder();
		String mode = request.getParameter("mode");
		
		sb.append("<ITEM>");
		
		if (mode.equals("A")) {
			List<CommunityCCategoryVO> categoryList= ezCommunityService.mainPageGet4("a");
			
			for(CommunityCCategoryVO category : categoryList) {
				sb.append(commonUtil.getQueryResult(ezCommunityService.mainPageCategory(category.getC_Code(), "a")));
			}
		} else {
			List<CommunityCCategoryVO> categoryList= ezCommunityService.mainPageGet4("b");
			
			for(CommunityCCategoryVO category : categoryList) {
				sb.append(commonUtil.getQueryResult(ezCommunityService.mainPageCategory(category.getC_Code(), "b")));
			}
		}
		
		sb.append("</ITEM>");
		
		return sb.toString();
	}
	
	/**
	 * 카테고리별 커뮤니티화면 업무별/종류에 따른 커뮤니티목록  호출함수
	 */
	@RequestMapping(value = "/ezCommunity/categoryCopList.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String categoryCopList(ModelMap model, HttpServletRequest request) throws Exception {
		String mode = request.getParameter("mode");
		String type = request.getParameter("type");
		int page = Integer.parseInt(request.getParameter("page"));
		
		int startRow = (5 * (page - 1)) + 1;
		int endRow = 5 * page;
		StringBuilder sb = new StringBuilder();
		
		List<CommunityClubVO> clubList = ezCommunityService.categoryListGet(type, mode, startRow, endRow);
		
		sb.append("<DATA>");
		
		for (CommunityClubVO club : clubList) {
			club.setItemCnt(Integer.parseInt(ezCommunityService.categoryListItemCntGet(club.getC_ClubNo())));
			sb.append(commonUtil.getQueryResult(club));
		}
		
		sb.append("</DATA>");
		
		return sb.toString();
	}
	
	/**
	 * 카테고리별 커뮤니티 검색기능 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/searchCop.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String searchCop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String search = "";
		StringBuilder sb = new StringBuilder();
		
		String option = request.getParameter("option");
		String keyword = request.getParameter("keyword");
		int page = Integer.parseInt(request.getParameter("page"));
		
		int startRow = (5 * (page - 1)) + 1;
		int endRow = 5 * page;
		
		if (option.equals("NAME")) {
			if (commonUtil.getMultiData(userInfo.getLang()).equals("")) {
				search = "C_CLUBNAME";
			} else {
				search = "C_CLUBNAME2";
			}
		} else {
			search = "C_CLUBDESC";
		}
		
		List<CommunityClubVO> clubList = ezCommunityService.searchCop(search, keyword, startRow, endRow, "SEA");
		
		if (clubList.size() == 0) {
			return "NOTIME";
		}
		
		sb.append("<DATA>");
		
		for (CommunityClubVO club : clubList) {
			club.setItemCnt(Integer.parseInt(ezCommunityService.categoryListItemCntGet(club.getC_ClubNo())));
			sb.append(commonUtil.getQueryResult(club));
		}
		
		sb.append("<COPCNT>");
		sb.append(clubList.size());
		sb.append("</COPCNT>");
		sb.append("</DATA>");
		
		return sb.toString();
	}
	
	
}

