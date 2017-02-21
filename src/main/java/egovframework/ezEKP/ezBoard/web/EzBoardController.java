package egovframework.ezEKP.ezBoard.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.security.PrivateKey;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.TimeZone;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.HandlerMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAccessVO;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardLineReplyVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardReadVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 사용자 - 게시판 
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    황윤진    신규작성
 *
 * @see
 */
@Controller
public class EzBoardController extends EgovFileMngUtil{
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "loginService")
	private LoginService loginService;
	
	@Resource(name = "crypto") 
    private EgovFileScrty egovFileScrty;
 
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzBoardController.class);
	
	/**
	 * 게시판 메인화면 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardMain.do")
	public String boardMain(HttpServletRequest req, Model model) {
		String func = "";
		String subFunc = "";

		if (req.getParameter("func") != null && !req.getParameter("func").equals("")) {
			func = req.getParameter("func");	
		}
		if (req.getParameter("subFunc") != null && !req.getParameter("subFunc").equals("")) {
			subFunc = req.getParameter("subFunc");	
		}
		
		model.addAttribute("func", func);
		model.addAttribute("subFunc", subFunc);
		
		return "ezBoard/boardMain";
	}
	
	/**
	 * 게시판 메인화면 Redirect 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardMainRedirect.do")
	public String boardMainRedirect(HttpServletRequest req, Model model) {
		String boardID = "";
		String photoType = "";

		if (req.getParameter("boardID") != null && !req.getParameter("boardID").equals("")) {
			boardID = req.getParameter("boardID");	
		}
		if (req.getParameter("photoType") != null && !req.getParameter("photoType").equals("")) {
			photoType = req.getParameter("photoType");	
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("photoType", photoType);
		
		return "ezBoard/boardMainRedirect";
	}
	
	/**
	 * 게시판 왼쪽화면 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardLeft.do")
	public String boardLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception{
		String redirectBoardID = "";
        String redirectBoardGroupID = "";
        String func = "";
        String subFunc = "";
        String photoType = "";
        String applyFlag = "";
        
        userInfo = commonUtil.userInfo(loginCookie);
        
        String strLang = userInfo.getLang();
		String pUserID = userInfo.getId();
		String pDeptID = userInfo.getDeptID();
		String pCompanyID = userInfo.getCompanyID();
		String pRollInfo = userInfo.getRollInfo();
		int tenantID = userInfo.getTenantId();
		
		if (request.getParameter("photoType") != null && !request.getParameter("photoType").equals("")) {
			photoType  = request.getParameter("photoType");
		}
		
		if (request.getParameter("boardID") != null && !request.getParameter("boardID").equals("")) {
			redirectBoardID  = request.getParameter("boardID");

			List<BoardVO> leftBoardList = ezBoardService.getLeft_BoardSTD(redirectBoardID, tenantID);
			for (BoardVO i :  leftBoardList) {
				redirectBoardGroupID += commonUtil.makeListField(i.getBoardGroupId()) + ",";
			}

			if (redirectBoardGroupID.length() != 0)
				redirectBoardGroupID = redirectBoardGroupID.substring(0, redirectBoardGroupID.length() - 1);
		}
		
		if (request.getParameter("func") != null) {
			func = request.getParameter("func");
		}
		
		if (request.getParameter("subFunc") != null) {
			subFunc = request.getParameter("subFunc");
		}
		
		int pSelectBy = 0;
		String pRootBoardID = "top";
		String pSubFlag = "0";
        String pExcludeBoardID = " ";
        String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pRootBoardID, pUserID, pDeptID, pCompanyID, tenantID);
        List<BoardVO> applyUserList = ezBoardAdminService.checkApplyUser(tenantID);
        
        for (BoardVO vo: applyUserList) {
        	if (vo.getApprUserId().toLowerCase().indexOf(pUserID.toLowerCase()) > -1) {
        		applyFlag = "OK";
        	}
        }
        int pMode = 0;
        
        if (pRollInfo != null && (boardGroupAdmin_FG.equals("OK") || pRollInfo.toLowerCase().indexOf("c=1") > -1 || pRollInfo.toLowerCase().indexOf("k=1") > -1 || pRollInfo.toLowerCase().indexOf("n=1") > -1)) {
        	pMode = 0;
        } else {
        	pMode = 1;
        }
        //Library 연결 부분 Method화
        String resultXML = ezBoardService.getBoardTree(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, commonUtil.getMultiData(strLang, userInfo.getTenantId()), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(resultXML);
		int resultCount = doc.getElementsByTagName("NODE").getLength();
		
		String questionAdmin = "false";
		if (userInfo.getRollInfo().toLowerCase().indexOf("l=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1) {
			questionAdmin = "true";
		}

        modelMap.addAttribute("userInfo", userInfo);
        modelMap.addAttribute("resultCount", resultCount);
        modelMap.addAttribute("resultXML", resultXML);
        modelMap.addAttribute("func",func);
        modelMap.addAttribute("subFunc",subFunc);
        modelMap.addAttribute("photoType",photoType);
        modelMap.addAttribute("redirectBoardID",redirectBoardID);
        modelMap.addAttribute("redirectBoardGroupID",redirectBoardGroupID);
        modelMap.addAttribute("applyFlag",applyFlag);
        modelMap.addAttribute("questionAdmin", questionAdmin);
        
		return "ezBoard/boardLeft";
	}
	
	/**
	 * 게시판 즐겨찾기화면 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardItemList_favorite.do")
	public String boardItemList_favorite(Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
    	return "ezBoard/boardItemList_favorite";
	}
	
	/**
	 * 게시판 즐겨찾기 데이터 표출 Method
	 */
	@RequestMapping(value="/ezBoard/get_favoriteList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String get_favoriteList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
        String mode = request.getParameter("mode");
        String userID = userInfo.getId();

        List<BoardMyFavoriteVO> resultList = ezBoardService.get_favoriteList(userID, mode, userInfo.getTenantId());
        String parentName = parentBoardName(resultList, userInfo);
        StringBuffer sb = new StringBuffer();
        
        sb.append("<DATA>");

		for (int i = 0; i < resultList.size(); i++) {
			sb.append(commonUtil.getQueryResult(resultList.get(i)));
		}
		sb.append("</DATA>");
		
		return "<ROOT>" + sb.toString() + parentName + "</ROOT>";
	}
	
	/**
	 * 게시판 환경설정 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardConfig.do")
	public String boardConfig() throws Exception{	
		return "ezBoard/boardConfig";
	}
	
	/**
	 * 게시판 환경설정 일반 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardGeneral.do")
	public String boardGeneral(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, Model model) throws Exception {
		loginVO = commonUtil.userInfo(loginCookie); 
		String pUserID = loginVO.getId();
		
		BoardConfigVO boardListConfig = ezBoardService.getBoardList_Config(pUserID, loginVO.getTenantId());
		
		if (boardListConfig == null) {
			boardListConfig = new BoardConfigVO();
			boardListConfig.setListCount(20);
			boardListConfig.setPreview("OFF");
			boardListConfig.setPreviewHList(50);
			boardListConfig.setPreviewHContent(50);
			boardListConfig.setPreviewWList(50);
			boardListConfig.setPreviewWContent(50);
		}
		
		model.addAttribute("boardListConfig", boardListConfig);
		
		return "ezBoard/boardGeneral";
	}
	
	/**
	 * 게시판 사용자환경설정 저장 Method
	 */
	@RequestMapping(value="/ezBoard/board_generallist_save.do", method = RequestMethod.POST)
	public void boardGeneralListSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse response, BoardConfigVO boardConfigVO) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		boardConfigVO.setTenantID(userInfo.getTenantId());
		boardConfigVO.setUserId(userInfo.getId());

		ezBoardService.setBoardList_Config(boardConfigVO);
	}
	
	/**
	 * 게시판 환경설정즐겨찾기 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardFavorite.do")
	public String boardFavorite(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "ezBoard/boardFavorite";
	}
	
	/**
	 * 게시판 부모게시판명 표출 Method
	 */
	public String parentBoardName(List<BoardMyFavoriteVO> resultList, LoginVO userInfo) throws Exception{
        String rtv = "";
        String BoardIdList = "";
        int BoardIdListCount = 0;
        
        for (int i = 0; i < resultList.size(); i++) {
            BoardIdList += resultList.get(i).getBoardId().trim();
            if (i != resultList.size() - 1)
                BoardIdList += ";";            
        }
        BoardIdListCount = BoardIdList.split(";").length;
        
        rtv = ezBoardService.get_parentBoardName(BoardIdList.trim(), BoardIdListCount, userInfo.getPrimary(), userInfo.getTenantId(), userInfo.getLocale());
        
        return "<DATA><TOPBOARDLIST>" + rtv + "</TOPBOARDLIST></DATA>";
    }
	
	/**
	 * 게시판 나의게시판 설정 표출 Method
	 */
   @RequestMapping(value="/ezBoard/getMyBoardsConfig.do", produces = "text/xml; charset=utf-8")
   @ResponseBody
   public String getMyBoardsConfig(HttpServletRequest req, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse res) throws Exception{
	   userInfo = commonUtil.userInfo(loginCookie);
	   
	   String lang = userInfo.getLang();
       String pRootTreeID = req.getParameter("rootTreeID");
       String pCountFlag = req.getParameter("countFlag");
       String resultXML = getMyBoardTreeConfig(userInfo.getId(), pRootTreeID, commonUtil.getMultiData(lang, userInfo.getTenantId()), userInfo.getTenantId());

       if (ezCommonService.getTenantConfig("USE_BOARD_LEFTMENU_COUNT", userInfo.getTenantId()).equals("YES") && pCountFlag != null && pCountFlag.equals("YES")) {
    	   Document doc = commonUtil.convertStringToDocument(resultXML);
    	   NodeList nList = doc.getElementsByTagName("NODE");
           String strName = "";
           int intCount = 0;
           
           for (int i = 0; i < nList.getLength(); i++) {
               if (nList.item(i).getChildNodes().item(4).getTextContent().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
            	   intCount = ezBoardService.getBrdNewItemCount(userInfo.getId(), userInfo.getTenantId());

                   if (intCount != 0) {
                	   strName = "(" + intCount + ")";
                   }
                   
                   nList.item(i).getChildNodes().item(0).setTextContent(nList.item(i).getChildNodes().item(0).getTextContent() + strName);
                   
                   resultXML = commonUtil.convertDocumentToString(doc);
               } else {
                   if (nList.item(i).getChildNodes().item(5).getTextContent().trim().equals("BOARD")) {
                	   BoardPropertyVO boardInfo = getBoardInfo(nList.item(i).getChildNodes().item(4).getTextContent().trim(), userInfo);
                	   BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
                	   myFavoriteVO.setUserId(userInfo.getId());
                	   myFavoriteVO.setBoardId(nList.item(i).getChildNodes().item(4).getTextContent());
                	   myFavoriteVO.setType("1");
                	   myFavoriteVO.setTenantID(userInfo.getTenantId());
                	   myFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
                	   
                	   if (boardInfo != null) {
                		   if (boardInfo.getGuBun() != null && boardInfo.getGuBun().equals("4")) {
                			   intCount = ezBoardService.getThumbNailCount(myFavoriteVO);
                		   } else {
                			   intCount = ezBoardService.getBrdTotalItemCount(myFavoriteVO);
                		   }
                	   }
                       
                       strName = "";
                       if (intCount != 0) {
                    	   strName = "(" + intCount + ")";
                       }
                       
                       nList.item(i).getChildNodes().item(0).setTextContent(nList.item(i).getChildNodes().item(0).getTextContent() + strName);
                       
                       resultXML = commonUtil.convertDocumentToString(doc);
                   }
               }
           }
       }
       
       return resultXML;
   }
   
   /**
	 * 게시판 나의게시판트리 설정 표출 Method
	 */
	public String getMyBoardTreeConfig(String userID, String pRootTreeID, String lang, int tenantID) throws Exception{
        List<BoardMyFavoriteVO> resultList  = ezBoardAdminService.getMyBoardTree_get3(userID, pRootTreeID.trim(), tenantID);
        
        StringBuilder sb = new StringBuilder();
        
        sb.append("<TREEVIEWDATA>");

        for (int i = 0; i < resultList.size(); i++) {
            sb.append("<NODE>");
            
            if (lang.equals("")) {
            	sb.append("<VALUE><![CDATA[" + resultList.get(i).getTreeName() + "]]></VALUE>");
            } else {
            	sb.append("<VALUE><![CDATA[" + resultList.get(i).getTreeName2() + "]]></VALUE>");
            }
            sb.append("<STYLE><![CDATA[]]></STYLE>");
            sb.append("<DATA1>" + resultList.get(i).getTreeId().trim() + "</DATA1>");
            
            if (lang.equals("")) {
            	sb.append("<DATA2><![CDATA[" + resultList.get(i).getTreeName().trim() + "]]></DATA2>");
            } else {
            	sb.append("<DATA2><![CDATA[" + resultList.get(i).getTreeName2().trim() + "]]></DATA2>");
            }
            sb.append("<DATA3><![CDATA[" + resultList.get(i).getTreeBoardId() + "]]></DATA3>");
            
            if (resultList.get(i).getTreeBoardId() == null || resultList.get(i).getTreeBoardId().equals("")) {
            	sb.append("<DATA4>TREE</DATA4>");
            } else {
            	sb.append("<DATA4>BOARD</DATA4>");
            }
            sb.append("<DATA5></DATA5>");
            sb.append("<EXPANDED>FALSE</EXPANDED>");
            
            if (resultList.get(i).getChildCnt() > 0) {
            	sb.append("<ISLEAF>FALSE</ISLEAF>");
            } else {
            	sb.append("<ISLEAF>TRUE</ISLEAF>");
            }

            if (resultList.get(i).getTreeBoardId() != null && resultList.get(i).getTreeBoardId().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
            	sb.append("<SELECT>TRUE</SELECT>");
            }
            sb.append("</NODE>");
        }

        sb.append("</TREEVIEWDATA>");
        
        return sb.toString();
	}
	/**
	 * 게시판 일반,포토,새 게시판리스트 호출 Method
	 */
	@RequestMapping(value= {"/ezBoard/boardItemList_new.do", "/ezBoard/boardItemList.do", "/ezBoard/boardItemListPhoto.do"})
	public String boardItemList(HttpServletRequest request, LoginVO userInfo, BoardPropertyVO boardPropertyVO, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String use_ocs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
        String use_Editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId()); 
        String use_IE11Browser = ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId());
        String use_oneLineCount = "";
        String pBoardID = boardPropertyVO.getBoardID();
        String pBoardName = boardPropertyVO.getBoardName();
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		
		//뷰만 다르고 cs가 같은 경우여서 requestURL 사용해서 다이나믹뷰
		requestURL = requestURL.substring(1, requestURL.length() - 3);
		
		BoardPropertyVO boardInfo = getBoardInfo(pBoardID, userInfo);
		
		if (boardPropertyVO.getAdminType() == null) {
			boardInfo.setAdminType("");
		} else {
			boardInfo.setAdminType(boardPropertyVO.getAdminType());
		}
		
		if (boardPropertyVO.getButtonHidden() == null) {
			boardInfo.setButtonHidden("N");
		} else {
			boardInfo.setButtonHidden(boardPropertyVO.getButtonHidden());
		}
		
		if (boardPropertyVO.getBoardType() == null) {
			boardInfo.setBoardType("");
		} else {
			boardInfo.setBoardType(boardPropertyVO.getBoardType());
		}
		
        if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && use_IE11Browser.equals("CK")) {
        	use_IE11Browser = "CK";
        }
        
        BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(pBoardID, userInfo.getTenantId());
        
        if (boardProperty != null && boardProperty.getOneLineReply() != null && boardProperty.getOneLineReply().equals("1")) {
        	use_oneLineCount = "YES";
        } else {
        	use_oneLineCount = "NO";
        }
        
        if (boardInfo.getListView_FG().equals("true")) {
            if (request.getParameter("page") == null || request.getParameter("page").equals("")) {
            	boardInfo.setPage(1);
            } else {
            	boardInfo.setPage(boardPropertyVO.getPage());
            }
            
            if (boardPropertyVO.getSortBy() != null) {
            	boardInfo.setSortBy(boardPropertyVO.getSortBy());
            }
            
            if (boardInfo.getBoardName() != null) {
            	pBoardName = boardInfo.getBoardName();
            }
        }

        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("boardName", commonUtil.cleanValue(pBoardName));
        model.addAttribute("boardID", pBoardID);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("use_ocs", use_ocs);
        model.addAttribute("use_Editor", use_Editor);
        model.addAttribute("use_IE11Browser", use_IE11Browser);
        model.addAttribute("use_oneLineCount", use_oneLineCount);
        
        return requestURL;
	}

	/**
	 * 게시판 게시판정보 표출 Method
	 */
	public BoardPropertyVO getBoardInfo(String pBoardID, LoginVO userInfo) throws Exception{
		BoardPropertyVO boardInfo = new BoardPropertyVO();
		boardInfo.setSs_board_maxRows(20);
		boardInfo.setSs_searchBoard_maxRows(10);             

		if (pBoardID == null || pBoardID.equals("")) {
			boardInfo.setBoardName(egovMessageSource.getMessage("ezBoard.t229", userInfo.getLocale()));	
			return boardInfo;
		}
		
		String deptPath = userInfo.getDeptPathCode();
	    String deptPathOrgan = "";
	    for (int ch = 0; ch < deptPath.split(",").length; ch++) {
	        if (ch == 0) {
	        	deptPathOrgan += deptPath.split(",")[ch].trim();
	        } else {
	        	deptPathOrgan += "," + deptPath.split(",")[deptPath.split(",").length - (ch)].trim();
	        }
	    }
	    
	    String userDeptPath = deptPathOrgan + ",everyone";
	    
		for (int i = 0; i < userDeptPath.split(",").length; i++)
		{
			BoardPropertyVO boardInfoTemp = ezBoardAdminService.getACL(pBoardID, userDeptPath.split(",")[i].trim(), userInfo.getTenantId());
			if (boardInfoTemp != null) {
				boardInfo = boardInfoTemp;
				break;
			}
		}
		
		String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
		boardInfo.setBoardGroupAdmin_FG(boardGroupAdmin_FG);
		
	    if (pBoardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
	    	boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (userInfo.getRollInfo() != null && (userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1)) {
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (boardInfo.getBoardGroupAdmin_FG() != null && boardInfo.getBoardGroupAdmin_FG().equals("OK")) {	
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (boardInfo.getBoardAdmin_FG() == null || boardInfo.getBoardAdmin_FG().equals("")) {
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("false");
			boardInfo.setRead_FG("false");
			boardInfo.setWrite_FG("false");
			boardInfo.setReply_FG("false");
			boardInfo.setDelete_FG("false");
		}
	
	    BoardPropertyVO strProp = ezBoardService.getBoardProperty(pBoardID, userInfo.getTenantId());
	
	    if (strProp != null) {
	    	boardInfo.setExpireDays(commonUtil.getDateStringInUTC(strProp.getItemExpires(), userInfo.getOffset(), false));
 	    	boardInfo.setAttachSizeLimit(strProp.getAttachSizeLimit());
	    	 
		    if (userInfo.getPrimary() != null && strProp.getBoardName2() != null && userInfo.getPrimary().equals("2") && !strProp.getBoardName2().equals("")) {
		    	boardInfo.setBoardName(strProp.getBoardName2().replace("\"", "&quot;"));
		    } else {
		    	boardInfo.setBoardName(strProp.getBoardName().replace("\"", "&quot;"));
		    }
		    
			boardInfo.setReplyNotify(strProp.getReplyNotify());
			boardInfo.setGuBun(strProp.getGuBun());
			boardInfo.setUrl(strProp.getUrl());
	        boardInfo.setApprMail_FG(strProp.getApprMailFlag());
	        boardInfo.setAttributeYN(strProp.getAttributeYN());
		}
	    
        return boardInfo;
	}
	
	/**
	 * 게시판 게시판정보2 표출 Method
	 */
	public BoardPropertyVO getBoardInfo(BoardPropertyVO boardInfo, String pBoardID, LoginVO userInfo) throws Exception{
		boardInfo.setSs_board_maxRows(20);
		boardInfo.setSs_searchBoard_maxRows(10);             

		if (pBoardID.equals("")) {
			boardInfo.setBoardName(egovMessageSource.getMessage("ezBoard.t229", userInfo.getLocale()));		
			return null;
		}

		String deptPath = userInfo.getDeptPathCode();
	    String deptPathOrgan="";
	    
	    for (int ch=0; ch<deptPath.split(",").length; ch++) {
	        if (ch==0)
	            deptPathOrgan+=deptPath.split(",")[ch].trim();
	        else
	            deptPathOrgan+=","+deptPath.split(",")[deptPath.split(",").length-(ch)].trim();
	    }
	    
	    String userDeptPath = deptPathOrgan+",everyone";
	    
		for (int i=0; i<userDeptPath.split(",").length; i++)
		{
			BoardPropertyVO boardInfoTemp = ezBoardAdminService.getACL(pBoardID, userDeptPath.split(",")[i].trim(), userInfo.getTenantId());
			
			if (boardInfoTemp == null) {
				break;
			} else {
				boardInfo = boardInfoTemp;
			}
		}
		
		String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
		boardInfo.setBoardGroupAdmin_FG(boardGroupAdmin_FG);
		
	    if (pBoardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
	    	boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (userInfo.getRollInfo() != null && (userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1)) {
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (boardInfo.getBoardGroupAdmin_FG() != null && boardInfo.getBoardGroupAdmin_FG().equals("OK")) {
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (boardInfo.getBoardAdmin_FG() == null || boardInfo.getBoardAdmin_FG().equals("")) {
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("false");
			boardInfo.setRead_FG("false");
			boardInfo.setWrite_FG("false");
			boardInfo.setReply_FG("false");
			boardInfo.setDelete_FG("false");
		}
	
	    BoardPropertyVO strProp = ezBoardService.getBoardProperty(pBoardID, userInfo.getTenantId());
	
	    if (strProp != null) {
	    	boardInfo.setExpireDays(strProp.getItemExpires());
	    	boardInfo.setAttachSizeLimit(strProp.getAttachSizeLimit());
	    	 
	    	if (userInfo.getPrimary() != null && strProp.getBoardName2() != null && userInfo.getPrimary().equals("2") && !strProp.getBoardName2().equals("")) {
		    	boardInfo.setBoardName(strProp.getBoardName2().replace("\"", "&quot;"));
		    } else {
		    	boardInfo.setBoardName(strProp.getBoardName().replace("\"", "&quot;"));
		    }
			boardInfo.setReplyNotify(strProp.getReplyNotify());
			boardInfo.setGuBun(strProp.getGuBun());
			boardInfo.setUrl(strProp.getUrl());
	        boardInfo.setApprMail_FG(strProp.getApprMailFlag());
	        boardInfo.setAttributeYN(strProp.getAttributeYN());
		}
	    
        return boardInfo;
	}
	
	/**
	 * 게시판 게시판리스트 표출 Method
	 */
    @RequestMapping(value = "/ezBoard/getBoardList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getBoardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, BoardVO boardVO) throws Exception{
    	userInfo = commonUtil.userInfo(loginCookie);
    	
        String boardID = boardVO.getBoardId();
        String boardType = boardVO.getBoardType();
        String mode = boardVO.getMode();
        String type = "1";
        String resultXML = "";
        
        if (boardVO.getType() != null && !boardVO.getType().equals("")) {
        	type = boardVO.getType();
        }
        
        BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
        
        boardVO.setType(type);
        boardVO.setLang(userInfo.getLang());
        boardVO.setTenantID(userInfo.getTenantId());
        
        if (boardType.equals("4")) { // 썸네일 
        	resultXML = getThumbList(boardVO, userInfo, type);
        } else if (boardType.equals("5")) { //Q&A
            resultXML = getQnAListItem(boardVO, userInfo, type, boardInfo.getBoardAdmin_FG());
        } else if (boardType.equals("M")) { //마이게시판
        	resultXML = getMyboardList(boardVO, userInfo, mode);
        } else if (boardType.equals("A")) { //게시판승인
        	resultXML = getApprboardList(boardVO, userInfo, mode, type);
        } else {
            if (boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
            	boardVO.setBoardType("N");
            	resultXML = getNewItemList(boardVO, userInfo);
            } else {
            	resultXML = getBoardListItem(boardVO, userInfo, type);
            }
        }

        return resultXML.toString();
    }
    
    /**
	 * 게시판 승인게시판 표출 Method
	 */
    public String getApprboardList(BoardVO boardVO, LoginVO userInfo, String mode, String type) throws Exception{
    	String orderOption1 = "";
        String orderOption2 = "";
        String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());

        List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(boardVO);

        int i = 0;
        int hlength = headerList.size();
        int writeDateSN = 0;    
        int titleSN = 0;        

        for (i = 0; i < hlength; i++) {
            if (!boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
                if (boardVO.getOrderOption().equals("")) {
                    orderOption1 = headerList.get(i).getColName() + " ";
                    orderOption2 = headerList.get(i).getColName() + " DESC ";
                } else {
                    orderOption1 = headerList.get(i).getColName() + " DESC ";
                    orderOption2 = headerList.get(i).getColName() + " ";
                }
            }
        }
        int noticeCount = 0;
        int boardCount = 0;
        
        if (mode == null || !mode.equals("temp")) {
        	boardCount = ezBoardService.getApprBoardTotalItemCount(userInfo);
        } else {
        	boardCount = ezBoardService.getMyBoardTotalItemCountTemp(userInfo);
        }
   
        int startRow = 1;
        int endRow = 0;

        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
        
        int personalCount = boardConfigVO.getListCount();
        String previewtype = boardConfigVO.getPreview();
        String fieldName = "";
        String fieldValue = "";
        
        if (boardVO.getPageNum() == 0) {
        	boardVO.setPageNum(1);
        }
        
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        
        if (mode == null || !mode.equals("temp")) {
	        noticeCount = 0;
	        
	        if (noticeCount > 0) {
	        	int start = ((boardVO.getPageNum() - 1) * personalCount) + 1;
                int end = (boardVO.getPageNum() * personalCount);
                
	            List<HashMap<String, Object>> noticeList = ezBoardService.getMyNoticePostItem(userInfo, "Y", start, end);
	
	            int k = 0;
	            int nlength = noticeList.size();
	            
	            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
	            resultXML.append("<PAGECNT>" + ((int)noticeCount  +  (int)boardCount) + "</PAGECNT>");
	            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
	            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
	            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
	            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
	            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
	            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
	            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
	            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
	            resultXML.append("<LISTVIEWDATA>");
	            resultXML.append("<HEADERS>");
	            
	            for (BoardListHeaderVO vo:headerList) {
	            	resultXML.append("<HEADER>");
	        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
	            	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
	            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
	            	resultXML.append("</HEADER>");
	            }
	            resultXML.append("</HEADERS>");
	            resultXML.append("<ROWS>");
	            
	            for (k=0; k < nlength; k++) {
	            	resultXML.append("<ROW>");
	                for (i = 0; i < hlength; i++) {
	                	resultXML.append("<CELL>");
	                    fieldName = headerList.get(i).getColName().toUpperCase();
	                    
	                    if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
	                        fieldName = fieldName + strMultiData;
	                    }
	                    if (fieldName.equals("WRITEDATE")) {
	                    	fieldValue = commonUtil.getDateStringInUTC((String) noticeList.get(k).get(fieldName), userInfo.getOffset(), false);
	                    	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
	                    } else {
	                    	fieldValue = commonUtil.cleanValue(String.valueOf(noticeList.get(k).get(fieldName)));
	                    }
	                    
	                    resultXML.append("<VALUE>"+fieldValue+"</VALUE>");
	                    
	                    if (i == 0) {
	                    	resultXML.append("<DATA1>" + noticeList.get(k).get("BOARDID") + "</DATA1>");
	                    	resultXML.append("<DATA2>" + noticeList.get(k).get("ITEMID") + "</DATA2>");
	            			resultXML.append("<DATA3>" + noticeList.get(k).get("WRITERID") + "</DATA3>");
	    					resultXML.append("<DATA4>" + noticeList.get(k).get("IMPORTANCE") + "</DATA4>");
	    					resultXML.append("<DATA5>" + noticeList.get(k).get("READFLAG") + "</DATA5>");
	    					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)noticeList.get(k).get("ABSTRACT")) + "</DATA6>");
	    					String nowDate = commonUtil.getTodayUTCTime("");
	    				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
	    				    
	    					if (noticeList.get(k).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
	    						resultXML.append("<DATA7>Y</DATA7>");
	    					} else {
	    						resultXML.append("<DATA7>N</DATA7>");
	    					}
	    					resultXML.append("<DATA8>" + noticeList.get(k).get("ITEMLEVEL") + "</DATA8>");
	    					resultXML.append("<DATA9>" + noticeList.get(k).get("NOTICE") + "</DATA9>");
	    					resultXML.append("<DATA10></DATA10>");
	    					resultXML.append("<DATA11>" + noticeList.get(k).get("ONELINECNT") + "</DATA11>");
	                    }
	                    resultXML.append("</CELL>");
	                }
	                resultXML.append("</ROW>");
	            }
	        } else {
	            startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
	            endRow = (personalCount * boardVO.getPageNum());
	
	            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
	            resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
	            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
	            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
	            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
	            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
	            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
	            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
	            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
	            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
	            resultXML.append("<LISTVIEWDATA>");
	            resultXML.append("<HEADERS>");
	            
	            for (BoardListHeaderVO vo:headerList) {
	            	resultXML.append("<HEADER>");
	        		resultXML.append("<NAME>"+vo.getName()+"</NAME>");
	            	resultXML.append("<WIDTH>"+vo.getWidth()+"</WIDTH>");
	            	resultXML.append("<COLNAME>"+vo.getColName()+"</COLNAME>");
	            	resultXML.append("</HEADER>");
	            }
	            resultXML.append("</HEADERS>");
	            resultXML.append("<ROWS>");
	        }
	        if (boardVO.getPageNum() != 1) {
	            startRow = ((personalCount * (boardVO.getPageNum() - 1)) - noticeCount) + 1;
	            endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
	        }
        } else {
        	startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
            endRow = (personalCount * boardVO.getPageNum());

            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
            resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
            resultXML.append("<LISTVIEWDATA>");
            resultXML.append("<HEADERS>");
            
            for (BoardListHeaderVO vo:headerList) {
            	resultXML.append("<HEADER>");
        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
            	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
            	resultXML.append("</HEADER>");
            }
            resultXML.append("</HEADERS>");
            resultXML.append("<ROWS>");
        }
        startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
        endRow = (personalCount * boardVO.getPageNum());
        
        List<HashMap<String, Object>> boardListItem = new ArrayList<HashMap<String,Object>>();
        
        if (mode == null || !mode.equals("temp")) {
        	boardListItem = ezBoardService.getApprBoardListItem(userInfo, startRow, endRow, boardCount, orderOption1, orderOption2);
        } else {
        	boardListItem = ezBoardService.getMyBoardListItemTemp(userInfo, startRow, endRow, boardCount, orderOption1, orderOption2);
        }
        
        int dlength = boardListItem.size();
        
        for (int j = 0; j < dlength; j++) {
        	resultXML.append("<ROW>");
            for (i = 0; i < hlength; i++) {
            	resultXML.append("<CELL>");
                fieldName = headerList.get(i).getColName().toUpperCase();

                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
                    fieldName = fieldName + strMultiData;
                }

                if (fieldName.equals("WRITEDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC((String) boardListItem.get(j).get(fieldName), userInfo.getOffset(), false);
                	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                } else {
                    fieldValue = commonUtil.cleanValue(String.valueOf(boardListItem.get(j).get(fieldName)));
                }
                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                
                if (i == 0) {
                	resultXML.append("<DATA1>" + boardListItem.get(j).get("BOARDID") + "</DATA1>");
                	resultXML.append("<DATA2>" + boardListItem.get(j).get("ITEMID") + "</DATA2>");
        			resultXML.append("<DATA3>" + boardListItem.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardListItem.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardListItem.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardListItem.get(j).get("ABSTRACT")) + "</DATA6>");
					String nowDate = commonUtil.getTodayUTCTime("");
				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
				    
					if (boardListItem.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					resultXML.append("<DATA8>" + boardListItem.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardListItem.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardListItem.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardListItem.get(j).get("ONELINECNT") + "</DATA11>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");

        return resultXML.toString();
	}
    
	/**
	 * 게시판 나의게시판리스트 표출 Method
	 */
    public String getMyboardList(BoardVO boardVO, LoginVO userInfo, String mode) throws Exception{
    	String orderOption1 = "";
        String orderOption2 = "";
        String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());

        List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(boardVO);

        int i = 0;
        int hlength = headerList.size();
        int writeDateSN = 0;
        int titleSN = 0;

        for (i = 0; i < hlength; i++) {
            if (!boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
                if (boardVO.getOrderOption().equals("")) {
                	if (headerList.get(i).getColName().equals("BOARDNAME")) {
                		orderOption1 = "B." + headerList.get(i).getColName() + " ";
                		orderOption2 = "B." + headerList.get(i).getColName() + " DESC ";
                	} else {
                		orderOption1 = "A." + headerList.get(i).getColName() + " ";
                		orderOption2 = "A." + headerList.get(i).getColName() + " DESC ";
                	}
                } else {
                	if (headerList.get(i).getColName().equals("BOARDNAME")) {
                		orderOption1 = "B." + headerList.get(i).getColName() + " DESC ";
                        orderOption2 = "B." + headerList.get(i).getColName() + " ";
                	} else {
                		orderOption1 = "A." + headerList.get(i).getColName() + " DESC ";
                        orderOption2 = "A." + headerList.get(i).getColName() + " ";
                	}
                }
            }
        }
        int noticeCount = 0;
        int boardCount = 0;
        
        if (mode == null || !mode.equals("temp")) {
        	boardCount = ezBoardService.getMyBoardTotalItemCount(userInfo);
        } else {
        	boardCount = ezBoardService.getMyBoardTotalItemCountTemp(userInfo);
        }
   
        int startRow = 1;
        int endRow = 0;

        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
        
        int personalCount = boardConfigVO.getListCount();
        String previewtype = boardConfigVO.getPreview();
        String fieldName = "";
        String fieldValue = "";
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        
        if (mode == null || !mode.equals("temp")) {
	        noticeCount = ezBoardService.getMyNoticePostItemCount(userInfo);
	        
	        if (noticeCount > 0) {
	        	int start = ((boardVO.getPageNum() - 1) * personalCount) + 1;
                int end = (boardVO.getPageNum() * personalCount);
                
	            List<HashMap<String, Object>> noticeList = ezBoardService.getMyNoticePostItem(userInfo, "Y", start, end);
	
	            int k = 0;
	            int nlength = noticeList.size();
	            
	            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
	            resultXML.append("<PAGECNT>" + ((int)noticeCount  +  (int)boardCount) + "</PAGECNT>");
	            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
	            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
	            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
	            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
	            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
	            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
	            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
	            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
	            resultXML.append("<LISTVIEWDATA>");
	            resultXML.append("<HEADERS>");
	            
	            for (BoardListHeaderVO vo:headerList) {
	            	resultXML.append("<HEADER>");
	        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
	            	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
	            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
	            	resultXML.append("</HEADER>");
	            }
	            resultXML.append("</HEADERS>");
	            resultXML.append("<ROWS>");
	            
	            for (k=0; k < nlength; k++) {
	            	resultXML.append("<ROW>");
	                for (i = 0; i < hlength; i++) {
	                	resultXML.append("<CELL>");
	                    fieldName = headerList.get(i).getColName().toUpperCase();
	                    
	                    if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
	                        fieldName = fieldName + strMultiData;
	                    }
	                    if (fieldName.equals("WRITEDATE")) {
	                    	fieldValue = commonUtil.getDateStringInUTC((String) noticeList.get(k).get(fieldName), userInfo.getOffset(), false);
	                    	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
	                    } else {
	                    	fieldValue = commonUtil.cleanValue(String.valueOf(noticeList.get(k).get(fieldName)));
	                    }
	                    
	                    resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
	                    
	                    if (i == 0) {
	                    	resultXML.append("<DATA1>" + noticeList.get(k).get("BOARDID") + "</DATA1>");
	                    	resultXML.append("<DATA2>" + noticeList.get(k).get("ITEMID") + "</DATA2>");
	            			resultXML.append("<DATA3>" + noticeList.get(k).get("WRITERID") + "</DATA3>");
	    					resultXML.append("<DATA4>" + noticeList.get(k).get("IMPORTANCE") + "</DATA4>");
	    					resultXML.append("<DATA5>" + noticeList.get(k).get("READFLAG") + "</DATA5>");
	    					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)noticeList.get(k).get("ABSTRACT")) + "</DATA6>");
	    				    String nowDate = commonUtil.getTodayUTCTime("");
	    				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
	    				    
	    					if (noticeList.get(k).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
	    						resultXML.append("<DATA7>Y</DATA7>");
	    					} else {
	    						resultXML.append("<DATA7>N</DATA7>");
	    					}
	    					resultXML.append("<DATA8>" + noticeList.get(k).get("ITEMLEVEL") + "</DATA8>");
	    					resultXML.append("<DATA9>" + noticeList.get(k).get("NOTICE") + "</DATA9>");
	    					resultXML.append("<DATA10></DATA10>");
	    					resultXML.append("<DATA11>" + noticeList.get(k).get("ONELINECNT") + "</DATA11>");
	                    }
	                    resultXML.append("</CELL>");
	                }
	                resultXML.append("</ROW>");
	            }
	        } else {
	            startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
	            endRow = (personalCount * boardVO.getPageNum());
	
	            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
	            resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
	            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
	            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
	            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
	            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
	            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
	            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
	            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
	            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
	            resultXML.append("<LISTVIEWDATA>");
	            resultXML.append("<HEADERS>");
	            
	            for (BoardListHeaderVO vo:headerList) {
	            	resultXML.append("<HEADER>");
	        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
	            	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
	            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
	            	resultXML.append("</HEADER>");
	            }
	            resultXML.append("</HEADERS>");
	            resultXML.append("<ROWS>");
	        }
	        if (boardVO.getPageNum() != 1) {
	            startRow = ((personalCount * (boardVO.getPageNum() - 1)) - noticeCount)  +  1;
	            endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
	        }
        } else {
        	startRow = ((personalCount * (boardVO.getPageNum() - 1)))  +  1;
            endRow = (personalCount * boardVO.getPageNum());

            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
            resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
            resultXML.append("<LISTVIEWDATA>");
            resultXML.append("<HEADERS>");
            
            for (BoardListHeaderVO vo:headerList) {
            	resultXML.append("<HEADER>");
        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
            	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
            	resultXML.append("</HEADER>");
            }
            resultXML.append("</HEADERS>");
            resultXML.append("<ROWS>");
        }
        startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
        endRow = (personalCount * boardVO.getPageNum());
        
        List<HashMap<String, Object>> boardListItem = new ArrayList<HashMap<String,Object>>();
        
        if (mode == null || !mode.equals("temp")) {
        	boardListItem = ezBoardService.getMyBoardListItem(userInfo, startRow, endRow, boardCount, orderOption1, orderOption2);
        } else {
        	boardListItem = ezBoardService.getMyBoardListItemTemp(userInfo, startRow, endRow, boardCount, orderOption1, orderOption2);
        }
        
        int dlength = boardListItem.size();
        
        for (int j = 0; j < dlength; j++) {
        	resultXML.append("<ROW>");
            for (i = 0; i < hlength; i++) {
            	resultXML.append("<CELL>");
                fieldName = headerList.get(i).getColName().toUpperCase();

                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
                    fieldName = fieldName + strMultiData;
                }

                if (fieldName.equals("WRITEDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC((String) boardListItem.get(j).get(fieldName), userInfo.getOffset(), false);
                	fieldValue = fieldValue.substring(0, fieldValue.length() - 3);
                } else {
                    fieldValue = commonUtil.cleanValue(String.valueOf(boardListItem.get(j).get(fieldName)));
                }
                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                
                if (i == 0) {
                	resultXML.append("<DATA1>" + boardListItem.get(j).get("BOARDID") + "</DATA1>");
                	resultXML.append("<DATA2>" + boardListItem.get(j).get("ITEMID") + "</DATA2>");
        			resultXML.append("<DATA3>" + boardListItem.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardListItem.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardListItem.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardListItem.get(j).get("ABSTRACT")) + "</DATA6>");
					String nowDate = commonUtil.getTodayUTCTime("");
				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
				    
					if (boardListItem.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					resultXML.append("<DATA8>" + boardListItem.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardListItem.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardListItem.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardListItem.get(j).get("ONELINECNT") + "</DATA11>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");

        return resultXML.toString();
	}

    /**
	 * 게시판 Q&A게시판리스트 표출 Method
	 */
	public String getQnAListItem(BoardVO boardVO, LoginVO userInfo, String type, String adminType) throws Exception{
    	String orderOption1 = "";
        String orderOption2 = "";
        String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());

        List<BoardListHeaderVO> headerList = ezBoardService.getListHeaderBoardID(boardVO);

        int i = 0;
        int hlength = headerList.size();
        int writeDateSN = 0;    //작성일 순번
        int titleSN = 0;            //제목 순번

        for (i = 0; i < hlength; i++) {
            if (!boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
                if (boardVO.getOrderOption().equals("")) {
                    orderOption1 = headerList.get(i).getColName() + " ";
                    orderOption2 = headerList.get(i).getColName() + " DESC ";
                } else {
                    orderOption1 = headerList.get(i).getColName() + " DESC ";
                    orderOption2 = headerList.get(i).getColName() + " ";
                }
            }
            
            if (headerList.get(i).getColName().toUpperCase().equals("WRITEDATE")) {
                writeDateSN = i;
            }
            if (headerList.get(i).getColName().toUpperCase().equals("TITLE")) {
                titleSN = i;
            }
        }
        int noticeCount = 0;
        
        if (type.equals("1")) {
        	boardVO.setNowDate(commonUtil.getTodayUTCTime(""));
        	noticeCount = ezBoardService.getNoticePostItemCount(boardVO);
        }
        BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
        boardMyFavoriteVO.setBoardId(boardVO.getBoardId());
        boardMyFavoriteVO.setUserId(userInfo.getId());
        boardMyFavoriteVO.setType(type);
        boardMyFavoriteVO.setTenantID(userInfo.getTenantId());
        boardMyFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
        
        int boardCount = ezBoardService.getBrdTotalItemCount(boardMyFavoriteVO);
   
        int startRow = 1;
        int endRow = 0;

        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
        
        int personalCount = boardConfigVO.getListCount();
        String previewtype = boardConfigVO.getPreview();
        String fieldName = "";
        String fieldValue = "";
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");

        if (noticeCount > 0 && type.equals("1")) {
            endRow = (personalCount * boardVO.getPageNum()) - noticeCount;

            List<HashMap<String, Object>> noticeList = ezBoardService.getNoticePostItem(boardVO, personalCount);

            int k = 0;
            int nlength = noticeList.size();
            
            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
            resultXML.append("<PAGECNT>" + ((int)noticeCount  +  (int)boardCount) + "</PAGECNT>");
            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
            resultXML.append("<LISTVIEWDATA>");
            resultXML.append("<HEADERS>");
            
            for (BoardListHeaderVO vo:headerList) {
            	resultXML.append("<HEADER>");
        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
            	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
            	resultXML.append("</HEADER>");
            }
            resultXML.append("</HEADERS>");
            resultXML.append("<ROWS>");
            
            for (k=0; k < nlength; k++) {
            	resultXML.append("<ROW>");
                for (i = 0; i < hlength; i++) {
                	resultXML.append("<CELL>");
                    fieldName = headerList.get(i).getColName().toUpperCase();
                    
                    if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
                        fieldName = fieldName + strMultiData;
                    }
                    if (fieldName.equals("WRITEDATE")) {
                    	fieldValue = commonUtil.getDateStringInUTC((String) noticeList.get(k).get(fieldName), userInfo.getOffset(), false);
                    	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                    } else {
                    	fieldValue = commonUtil.cleanValue(String.valueOf(noticeList.get(k).get(fieldName)));
                    }
                    
                    resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                    
                    if (i == 0) {
                    	resultXML.append("<DATA1>" + noticeList.get(k).get("BOARDID") + "</DATA1>");
                    	resultXML.append("<DATA2>" + noticeList.get(k).get("ITEMID") + "</DATA2>");
            			resultXML.append("<DATA3>" + noticeList.get(k).get("WRITERID") + "</DATA3>");
    					resultXML.append("<DATA4>" + noticeList.get(k).get("IMPORTANCE") + "</DATA4>");
    					resultXML.append("<DATA5>" + noticeList.get(k).get("READFLAG") + "</DATA5>");
    					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)noticeList.get(k).get("ABSTRACT")) + "</DATA6>");
    					String nowDate = commonUtil.getTodayUTCTime("");
    				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
    				    
    					if (noticeList.get(k).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
    						resultXML.append("<DATA7>Y</DATA7>");
    					} else {
    						resultXML.append("<DATA7>N</DATA7>");
    					}
    					resultXML.append("<DATA8>" + noticeList.get(k).get("ITEMLEVEL") + "</DATA8>");
    					resultXML.append("<DATA9>" + noticeList.get(k).get("NOTICE") + "</DATA9>");
    					resultXML.append("<DATA10></DATA10>");
    					resultXML.append("<DATA11>" + noticeList.get(k).get("ONELINECNT") + "</DATA11>");
    					resultXML.append("<TITLE>" +  commonUtil.cleanValue((String)noticeList.get(k).get("TITLE"))  + "</TITLE>");
    					
    					if (commonUtil.getPrimaryData(boardVO.getLang(), userInfo.getTenantId()).equals("1")) {
    						resultXML.append("<WRITERNAME>" + noticeList.get(k).get("WRITERNAME") + "</WRITERNAME>");
    						resultXML.append("<WRITERDEPTNAME>" + noticeList.get(k).get("WRITERDEPTNAME") + "</WRITERDEPTNAME>");
    					} else {
    						resultXML.append("<WRITERNAME>" + noticeList.get(k).get("WRITERNAME2") + "</WRITERNAME>");
    						resultXML.append("<WRITERDEPTNAME>" + noticeList.get(k).get("WRITERDEPTNAME2") + "</WRITERDEPTNAME>");
    					}
    					resultXML.append("<WRITEDATE>" + noticeList.get(k).get("WRITEDATE") + "</WRITEDATE>");
    					resultXML.append("<ATTACHMENTS>" + noticeList.get(k).get("ATTACHMENTS") + "</ATTACHMENTS>");
                    }
                    resultXML.append("</CELL>");
                }
                resultXML.append("</ROW>");
            }
        } else {
            startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
            endRow = (personalCount * boardVO.getPageNum());

            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
            resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
            resultXML.append("<LISTVIEWDATA>");
            resultXML.append("<HEADERS>");
            
            for (BoardListHeaderVO vo:headerList) {
            	resultXML.append("<HEADER>");
        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
            	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
            	resultXML.append("</HEADER>");
            }
            resultXML.append("</HEADERS>");
            resultXML.append("<ROWS>");
            
        }
        if (boardVO.getPageNum() != 1) {
            startRow = ((personalCount * (boardVO.getPageNum() - 1)) - noticeCount) + 1;
            endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
        }
        List<HashMap<String, Object>> boardListItem = ezBoardService.getQnABoardListItem(boardVO.getBoardId(), userInfo.getId(), startRow, endRow, boardCount, orderOption1, orderOption2, type, adminType, userInfo.getTenantId());

        int dlength = boardListItem.size();
        
        for (int j = 0; j < dlength; j++) {
        	resultXML.append("<ROW>");
            for (i = 0; i < hlength; i++) {
            	resultXML.append("<CELL>");
                fieldName = headerList.get(i).getColName().toUpperCase();

                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
                    fieldName = fieldName + strMultiData;
                }

                if (fieldName.equals("WRITEDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC((String) boardListItem.get(j).get(fieldName), userInfo.getOffset(), false);
                	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                } else {
                    fieldValue = commonUtil.cleanValue(String.valueOf(boardListItem.get(j).get(fieldName)));
                }

                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                if (i == 0) {
                	resultXML.append("<DATA1>" + boardListItem.get(j).get("BOARDID") + "</DATA1>");
                	resultXML.append("<DATA2>" + boardListItem.get(j).get("ITEMID") + "</DATA2>");
        			resultXML.append("<DATA3>" + boardListItem.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardListItem.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardListItem.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardListItem.get(j).get("ABSTRACT")) + "</DATA6>");
					String nowDate = commonUtil.getTodayUTCTime("");
				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
				    
					if (boardListItem.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					resultXML.append("<DATA8>" + boardListItem.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardListItem.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10></DATA10>");
					resultXML.append("<DATA11>" + boardListItem.get(j).get("ONELINECNT") + "</DATA11>");
					resultXML.append("<TITLE>" + commonUtil.cleanValue((String)boardListItem.get(j).get("TITLE")) + "</TITLE>");
					resultXML.append("<WRITERNAME>" + boardListItem.get(j).get("WRITERNAME") + "</WRITERNAME>");
					resultXML.append("<WRITERNAME2>" + boardListItem.get(j).get("WRITERNAME2") + "</WRITERNAME2>");
					resultXML.append("<WRITERDEPTNAME>" + boardListItem.get(j).get("WRITERDEPTNAME") + "</WRITERDEPTNAME>");
					resultXML.append("<WRITERDEPTNAME2>" + boardListItem.get(j).get("WRITERDEPTNAME2") + "</WRITERDEPTNAME2>");
					resultXML.append("<WRITEDATE>" + boardListItem.get(j).get("WRITEDATE") + "</WRITEDATE>");
					resultXML.append("<ATTACHMENTS>" + boardListItem.get(j).get("ATTACHMENTS") + "</ATTACHMENTS>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
        return resultXML.toString();
	}

	/**
	 * 게시판 섬네일게시판리스트 표출 Method
	 */
	public String getThumbList(BoardVO boardVO, LoginVO userInfo, String type) throws Exception{
    	String orderOption1 = "";
        String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
        
        List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(boardVO);
        
        int i = 0;
        int hlength = headerList.size();

        for (i = 0; i < hlength; i++) {
            if (!boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
                if (boardVO.getOrderOption().equals("")) {
                	if (headerList.get(i).getColName().indexOf("WRITEDATE") > -1) {
                		orderOption1 = headerList.get(i).getColName().replace("WRITEDATE", "A.WRITEDATE") + " ";
                	} else if (headerList.get(i).getColName().indexOf("WRITERNAME") > -1) {
                		orderOption1 = headerList.get(i).getColName().replace("WRITERNAME", "A.WRITERNAME") + " ";
                	} else {
                		orderOption1 = headerList.get(i).getColName()+ " ";
                	}
                } else {
                	if (headerList.get(i).getColName().indexOf("WRITEDATE") > -1) {
                		orderOption1 = headerList.get(i).getColName().replace("WRITEDATE", "A.WRITEDATE") + " DESC";
                	} else if (headerList.get(i).getColName().indexOf("WRITERNAME") > -1) {
                		orderOption1 = headerList.get(i).getColName().replace("WRITERNAME", "A.WRITERNAME") + " DESC";
                	} else {
                		orderOption1 = headerList.get(i).getColName()+ " DESC";
                	}
                }
            }
        }
        BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
        myFavoriteVO.setBoardId(boardVO.getBoardId());
        myFavoriteVO.setUserId(userInfo.getId());
        myFavoriteVO.setType(type);
        myFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
        
        int boardCount = ezBoardService.getThumbNailCount(myFavoriteVO);
        
        BoardListVO boardListVO = new BoardListVO();
        boardListVO.setPageCount(boardCount);
        boardListVO.setTotalCount(boardCount);
        boardListVO.setStartRow(1);
        boardListVO.setEndRow(0);
        boardListVO.setOrderBySub(orderOption1);
        boardListVO.setUserID(userInfo.getId());
        
        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
        
        boardListVO.setStartRow(boardConfigVO.getListCount() * (boardVO.getPageNum() - 1) + 1);
        boardListVO.setEndRow(boardConfigVO.getListCount() * boardVO.getPageNum());
        
        if (boardVO.getTitle() == null) {
        	boardVO.setTitle("");
        }
        if (boardVO.getABSTRACT() == null) {
        	boardVO.setABSTRACT("");
        }
        if (boardVO.getWriterName() == null) {
        	boardVO.setWriterName("");
        }
        List<HashMap<String, Object>> boardThumbnailList = ezBoardService.getThumbnailList(boardListVO, boardVO);
		
        int dlength = boardThumbnailList.size();
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + boardListVO.getTotalCount() + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + boardListVO.getPageCount() + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + boardConfigVO.getListCount() + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
        resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
        resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
        resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (BoardListHeaderVO vo:headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        String fieldName = "";
        String fieldValue = "";
        
        for (int j = 0; j < dlength; j++) {
        	resultXML.append("<ROW>");
            for (i = 0; i < hlength; i++) {
            	resultXML.append("<CELL>");
            	fieldName = headerList.get(i).getColName().toUpperCase();

                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
                    fieldName = fieldName + strMultiData;
                }
                if (fieldName.equals("WRITEDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC((String)boardThumbnailList.get(j).get(fieldName), userInfo.getOffset(), false);
                	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                } else {
                	fieldValue = commonUtil.cleanValue(String.valueOf(boardThumbnailList.get(j).get(fieldName)));
                }
                
                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                
                if (i == 0) {
                	resultXML.append("<DATA1>" + boardThumbnailList.get(j).get("BOARDID") + "</DATA1>");
                	resultXML.append("<DATA2>" + boardThumbnailList.get(j).get("ITEMID") + "</DATA2>");
        			resultXML.append("<DATA3>" + boardThumbnailList.get(j).get("WRITERID") + "</DATA3>");
        			String nowDate = commonUtil.getTodayUTCTime("");
				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
				    
					if (boardThumbnailList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA4>Y</DATA4>");
					} else {
						resultXML.append("<DATA4>N</DATA4>");
					}
					resultXML.append("<DATA5>" + boardThumbnailList.get(j).get("FILEPATH") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardThumbnailList.get(j).get("MAINCONTENT")) + "</DATA6>");
					resultXML.append("<DATA7>" + boardThumbnailList.get(j).get("ONELINECNT") + "</DATA7>");
					resultXML.append("<DATA8>" + boardThumbnailList.get(j).get("READFLAG") + "</DATA8>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
		return resultXML.toString();
	}

	/**
	 * 게시판 게시판검색리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getSearchBoardList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getSearchBoardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, BoardVO boardVO) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
    	String returnQuery = "(1=1) ";
    	String mode = boardVO.getMode();
    	
    	BoardPropertyVO boardInfo = getBoardInfo(boardVO.getBoardId(), userInfo);
    	boardVO.setSubFlag("N");
    	boardVO.setSearchQuery(boardVO.getSearchQuery().replace("&lt;", "<").replace("&gt;", ">"));
    	
    	Document searchQueryDoc = commonUtil.convertStringToDocument(boardVO.getSearchQuery());
    	
    	if (boardVO.getSearchQuery().indexOf("SEARCHSUBBOARD;") != -1) {
    		boardVO.setSubFlag("Y");
        }
    	
        if (boardVO.getSearchQuery().indexOf("TITLE;") != -1) {
            boardVO.setTitle(searchQueryDoc.getElementsByTagName("TITLE").item(0).getTextContent());
            returnQuery += " AND TITLE like '%" + boardVO.getTitle() + "%' ";
        }
        
        if (boardVO.getSearchQuery().indexOf("WRITERNAME;") != -1) {
            boardVO.setWriterName(searchQueryDoc.getElementsByTagName("WRITERNAME").item(0).getTextContent());
            returnQuery += " AND ( A.WRITERNAME like '%" + boardVO.getWriterName() + "%' ";
            returnQuery += " OR A.WRITERNAME2 like '%" + boardVO.getWriterName() + "%' ) ";
        }

        if (boardVO.getSearchQuery().indexOf("STARTDATE;") != -1) {
            returnQuery += " AND WRITEDATE > '" + commonUtil.getDateStringInUTC(searchQueryDoc.getElementsByTagName("STARTDATE").item(0).getTextContent() + " 00:00:00", userInfo.getOffset(), true) + "' ";
        }
        
        if (boardVO.getSearchQuery().indexOf("ENDDATE;") != -1) {
            returnQuery += " AND WRITEDATE <  '" + commonUtil.getDateStringInUTC(searchQueryDoc.getElementsByTagName("ENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true) + "' ";
        }
        
        if (boardVO.getSearchQuery().indexOf("ABSTRACT;") != -1) {
            boardVO.setABSTRACT(searchQueryDoc.getElementsByTagName("ABSTRACT").item(0).getTextContent());
            returnQuery += " AND ABSTRACT like '%" + boardVO.getABSTRACT() + "%' ";
        }
        
        if (boardVO.getBoardType().equals("5") && boardInfo.getBoardAdmin_FG().equals("false")) {
            returnQuery += " AND TOPWRITERID = '" + userInfo.getId() + "' ";
        }
        
        boardVO.setSearchQuery(returnQuery);
        String boardXML = "";
        
        if (boardVO.getBoardType().equals("4")) {
        	boardXML = getSearchThumbListXML(userInfo, boardVO);
        } else if (boardVO.getBoardType().equals("M")) {
        	boardXML = getSearchMyBoardListItemXML(userInfo, boardVO, mode);
        } else {
        	boardXML = getSearchBoardListItemXML(userInfo, boardVO);
        }
        
    	return boardXML;
    }
	
	/**
	 * 게시판 나의게시판검색리스트 표출 Method
	 */
	public String getSearchMyBoardListItemXML(LoginVO userInfo, BoardVO boardVO, String mode) throws Exception{
		String orderOption1 = "";
        String orderOption2 = "";
        String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
        boardVO.setLang(userInfo.getLang());
        boardVO.setTenantID(userInfo.getTenantId());

        List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(boardVO);

        // 헤더 정보를 세팅한다.
        int i = 0;
        int hlength = headerList.size();

        for (i = 0; i < hlength; i++) {
            if (!boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
                if (boardVO.getOrderOption().equals("")) {
                    orderOption1 = headerList.get(i).getColName() + " ";
                    orderOption2 = headerList.get(i).getColName() + " DESC ";
                } else {
                    orderOption1 = headerList.get(i).getColName() + " DESC ";
                    orderOption2 = headerList.get(i).getColName() + " ";
                }
            }
        }
        int boardCount = 0;
        
        if (mode == null || !mode.equals("temp")) {
        	boardCount = ezBoardService.getSearchMyBoardItemCount(userInfo, boardVO);
        } else {
        	boardCount = ezBoardService.getSearchMyBoardItemCountTemp(userInfo, boardVO);
        }
        
        BoardListVO boardListVO = new BoardListVO();
        boardListVO.setPageCount(boardCount);
        boardListVO.setTotalCount(boardCount);
        boardListVO.setStartRow(1);
        boardListVO.setEndRow(0);
        boardListVO.setOrderBySub(orderOption1);
        boardListVO.setOrderByMain(orderOption2);
        boardListVO.setUserID(userInfo.getId());
        
        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
        
        boardListVO.setStartRow(boardConfigVO.getListCount() * (boardVO.getPageNum()-1) + 1);
        boardListVO.setEndRow(boardConfigVO.getListCount() * boardVO.getPageNum());
        
        if (boardVO.getTitle() == null) {
        	boardVO.setTitle("");
        }
        if (boardVO.getABSTRACT() == null) {
        	boardVO.setABSTRACT("");
        }
        if (boardVO.getWriterName() == null) {
        	boardVO.setWriterName("");
        }
        
        List<HashMap<String, Object>> boardSearchList = null;
        
        if (mode == null || !mode.equals("temp")) {
        	boardSearchList = ezBoardService.getSearchMyBoardItemList(boardListVO, boardVO);
        } else {
        	boardSearchList = ezBoardService.getSearchMyBoardItemListTemp(boardListVO, boardVO);
        }
		
        int dlength = boardSearchList.size();
        
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + boardConfigVO.getListCount() + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
        resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
        resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
        resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (BoardListHeaderVO vo:headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        String fieldName = "";
        String fieldValue = "";
        
        for (int j = 0; j < dlength; j++) {
        	resultXML.append("<ROW>");
            for (i = 0; i < hlength; i++) {
            	resultXML.append("<CELL>");
            	fieldName = headerList.get(i).getColName().toUpperCase();

                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
                    fieldName = fieldName + strMultiData;
                }
                if (fieldName.equals("WRITEDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC((String)boardSearchList.get(j).get(fieldName), userInfo.getOffset(), false);
                	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                } else {
                	fieldValue = commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get(fieldName)));
                }
                
                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                
                if (i == 0) {
                	resultXML.append("<DATA1>" + boardSearchList.get(j).get("BOARDID") + "</DATA1>");
                	resultXML.append("<DATA2>" + boardSearchList.get(j).get("ITEMID") + "</DATA2>");
        			resultXML.append("<DATA3>" + boardSearchList.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardSearchList.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardSearchList.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + boardSearchList.get(j).get("ABSTRACT") + "</DATA6>");
					String nowDate = commonUtil.getTodayUTCTime("");
				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
				    
					if (boardSearchList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					resultXML.append("<DATA8>" + boardSearchList.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardSearchList.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardSearchList.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardSearchList.get(j).get("ONELINECNT") + "</DATA11>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
		return resultXML.toString();
	}

	/**
	 * 게시판 섬네일게시판검색리스트 표출 Method
	 */
	public String getSearchThumbListXML(LoginVO userInfo, BoardVO boardVO) throws Exception{
		String orderOption1 = "";
        String orderOption2 = "";
        String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
        boardVO.setLang(userInfo.getLang());
        boardVO.setTenantID(userInfo.getTenantId());

        List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(boardVO);
        
        int i = 0;
        int hlength = headerList.size();

        for (i = 0; i < hlength; i++) {
            if (!boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
                if (boardVO.getOrderOption().equals("")) {
                	if (headerList.get(i).getColName().indexOf("WRITEDATE") > -1) {
                		orderOption1 = headerList.get(i).getColName().replace("WRITEDATE", "A.WRITEDATE") + " ";
                	} else if (headerList.get(i).getColName().indexOf("WRITERNAME") > -1) {
                		orderOption1 = headerList.get(i).getColName().replace("WRITERNAME", "A.WRITERNAME") + " ";
                	} else {
                		orderOption1 = headerList.get(i).getColName()+ " ";
                	}
                } else {
                	if (headerList.get(i).getColName().indexOf("WRITEDATE") > -1) {
                		orderOption1 = headerList.get(i).getColName().replace("WRITEDATE", "A.WRITEDATE") + " DESC";
                	} else if (headerList.get(i).getColName().indexOf("WRITERNAME") > -1) {
                		orderOption1 = headerList.get(i).getColName().replace("WRITERNAME", "A.WRITERNAME") + " DESC";
                	} else {
                		orderOption1 = headerList.get(i).getColName()+ " DESC";
                	}
                }
            }
        }
        
        boardVO.setNowDate(commonUtil.getTodayUTCTime(""));
        int boardCount = ezBoardService.getSearchBoardItemCount(boardVO);
        
        BoardListVO boardListVO = new BoardListVO();
        boardListVO.setPageCount(boardCount);
        boardListVO.setTotalCount(boardCount);
        boardListVO.setStartRow(1);
        boardListVO.setEndRow(0);
        boardListVO.setOrderBySub(orderOption1);
        boardListVO.setOrderByMain(orderOption2);
        boardListVO.setUserID(userInfo.getId());
        
        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
        
        boardListVO.setStartRow(boardConfigVO.getListCount() * (boardVO.getPageNum()-1) + 1);
        boardListVO.setEndRow(boardConfigVO.getListCount() * boardVO.getPageNum());
        
        if (boardVO.getTitle() == null) {
        	boardVO.setTitle("");
        }
        if (boardVO.getABSTRACT() == null) {
        	boardVO.setABSTRACT("");
        }
        if (boardVO.getWriterName() == null) {
        	boardVO.setWriterName("");
        }
        List<HashMap<String, Object>> boardThumbnailList = ezBoardService.getSearchThumbnailList(boardListVO, boardVO);
		
        int dlength = boardThumbnailList.size();
        
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + boardConfigVO.getListCount() + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
        resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
        resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
        resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (BoardListHeaderVO vo:headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        String fieldName = "";
        String fieldValue = "";
        
        for (int j = 0; j < dlength; j++) {
        	resultXML.append("<ROW>");
            for (i = 0; i < hlength; i++) {
            	resultXML.append("<CELL>");
            	fieldName = headerList.get(i).getColName().toUpperCase();

                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
                    fieldName = fieldName + strMultiData;
                }
                if (fieldName.equals("WRITEDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC((String)boardThumbnailList.get(j).get(fieldName), userInfo.getOffset(), false);
                	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                } else {
                	fieldValue = commonUtil.cleanValue(String.valueOf(boardThumbnailList.get(j).get(fieldName)));
                }
                
                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                
                if (i == 0) {
                	resultXML.append("<DATA1>" + boardThumbnailList.get(j).get("BOARDID") + "</DATA1>");
                	resultXML.append("<DATA2>" + boardThumbnailList.get(j).get("ITEMID") + "</DATA2>");
        			resultXML.append("<DATA3>" + boardThumbnailList.get(j).get("WRITERID") + "</DATA3>");
        			String nowDate = commonUtil.getTodayUTCTime("");
				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
				    
					if (boardThumbnailList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA4>Y</DATA4>");
					} else {
						resultXML.append("<DATA4>N</DATA4>");
					}
					resultXML.append("<DATA5>" + boardThumbnailList.get(j).get("FILEPATH") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardThumbnailList.get(j).get("MAINCONTENT")) + "</DATA6>");
					resultXML.append("<DATA7>" + boardThumbnailList.get(j).get("ONELINECNT") + "</DATA7>");
					resultXML.append("<DATA8>" + boardThumbnailList.get(j).get("READFLAG") + "</DATA8>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
		return resultXML.toString();
	}

	/**
	 * 게시판 게시판리스트검색 표출 Method
	 */
	public String getSearchBoardListItemXML(LoginVO userInfo, BoardVO boardVO) throws Exception{
		String orderOption1 = "";
        String orderOption2 = "";
        String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
        boardVO.setLang(userInfo.getLang());
        boardVO.setTenantID(userInfo.getTenantId());

        List<BoardListHeaderVO> headerList = ezBoardService.getListHeaderBoardID(boardVO);

        // 헤더 정보를 세팅한다.
        int i = 0;
        int hlength = headerList.size();

        for (i = 0; i < hlength; i++) {
            if (!boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
                if (boardVO.getOrderOption().equals("")) {
                    orderOption1 = headerList.get(i).getColName() + " ";
                    orderOption2 = headerList.get(i).getColName() + " DESC ";
                } else {
                    orderOption1 = headerList.get(i).getColName() + " DESC ";
                    orderOption2 = headerList.get(i).getColName() + " ";
                }
            }
        }
        
        boardVO.setNowDate(commonUtil.getTodayUTCTime(""));
        int boardCount = ezBoardService.getSearchBoardItemCount(boardVO);
        
        BoardListVO boardListVO = new BoardListVO();
        boardListVO.setPageCount(boardCount);
        boardListVO.setTotalCount(boardCount);
        boardListVO.setStartRow(1);
        boardListVO.setEndRow(0);
        boardListVO.setOrderBySub(orderOption1);
        boardListVO.setOrderByMain(orderOption2);
        boardListVO.setUserID(userInfo.getId());
        
        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
        
        boardListVO.setStartRow(boardConfigVO.getListCount() * (boardVO.getPageNum()-1) + 1);
        boardListVO.setEndRow(boardConfigVO.getListCount() * boardVO.getPageNum());
        
        if (boardVO.getTitle() == null) {
        	boardVO.setTitle("");
        }
        if (boardVO.getABSTRACT() == null) {
        	boardVO.setABSTRACT("");
        }
        if (boardVO.getWriterName() == null) {
        	boardVO.setWriterName("");
        }
        List<HashMap<String, Object>> boardSearchList = ezBoardService.getSearchBoardItemList(boardListVO, boardVO);
		
        int dlength = boardSearchList.size();
        
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + boardConfigVO.getListCount() + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
        resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
        resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
        resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (BoardListHeaderVO vo:headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        String fieldName = "";
        String fieldValue = "";
        
        for (int j = 0; j < dlength; j++) {
        	resultXML.append("<ROW>");
            for (i = 0; i < hlength; i++) {
            	resultXML.append("<CELL>");
            	fieldName = headerList.get(i).getColName().toUpperCase();

                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("BOARDNAME")) {
                    fieldName = fieldName + strMultiData;
                }
                if (fieldName.equals("WRITEDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC((String)boardSearchList.get(j).get(fieldName), userInfo.getOffset(), false);
                	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                } else {
                	fieldValue = commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get(fieldName)));
                }
                
                resultXML.append("<VALUE>"+fieldValue+"</VALUE>");
                
                if (i == 0) {
                	resultXML.append("<DATA1>" + boardSearchList.get(j).get("BOARDID") + "</DATA1>");
                	resultXML.append("<DATA2>" + boardSearchList.get(j).get("ITEMID") + "</DATA2>");
        			resultXML.append("<DATA3>" + boardSearchList.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardSearchList.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardSearchList.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + boardSearchList.get(j).get("ABSTRACT") + "</DATA6>");
					String nowDate = commonUtil.getTodayUTCTime("");
				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
				    
					if (boardSearchList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					resultXML.append("<DATA8>" + boardSearchList.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardSearchList.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardSearchList.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardSearchList.get(j).get("ONELINECNT") + "</DATA11>");
					resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardSearchList.get(j).get("MAINCONTENT")) + "</DATA12>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
		return resultXML.toString();
	}

	/**
	 * 게시판 새게시판리스트 표출 Method
	 */
	public String getNewItemList(BoardVO boardVO, LoginVO userInfo) throws Exception{
        String orderOption1 = "";
        String orderOption2 = "";
        String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());
        
        BoardListVO boardListVO = new BoardListVO();
        
        List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(boardVO);
        
        int i = 0;
        int hlength = headerList.size();
        for (i = 0; i < hlength; i++) {
            if (!boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
                if (boardVO.getOrderOption().equals("")) {                            
                    if (headerList.get(i).getName().indexOf("BOARDNAME") > -1) {
                    	orderOption1 = headerList.get(i).getColName().replace("BOARDNAME", "B.BOARDNAME") + " ";
                    } else {
                    	orderOption1 = headerList.get(i).getColName() + " ";
                    }
                } else {
                    if (headerList.get(i).getColName().indexOf("BOARDNAME") > -1) {
                    	orderOption1 = headerList.get(i).getColName().replace("BOARDNAME", "B.BOARDNAME") + " DESC ";
                    } else {
                    	orderOption1 = headerList.get(i).getColName() + " DESC ";
                    }
                }
            }
        }
        
        String fieldName = "";
        String fieldValue = "";
        
        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
        
        int boardCount = ezBoardService.getNewItemListCount(userInfo);
        int startRow = 1;
        int endRow = 0;
        int personalCount_ = boardConfigVO.getListCount();
        
        boardConfigVO.setPageCnt(boardCount);
        boardConfigVO.setTotalCnt(boardCount);
        
        startRow = (personalCount_ * (boardVO.getPageNum() - 1)) + 1;
        endRow = (personalCount_ * boardVO.getPageNum());
        
        boardListVO.setUserID(userInfo.getId());
        boardListVO.setTenantID(userInfo.getTenantId());
        boardListVO.setStartRow(startRow);
        boardListVO.setEndRow(endRow);
        boardListVO.setTotalCount(boardCount);
        boardListVO.setOrderBySub(orderOption1);
        boardListVO.setOrderByMain(orderOption2);
        
        List<HashMap<String, Object>> boardList = ezBoardService.getNewItemList(boardListVO);
        
        int dlength = boardList.size();
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
        resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
        resultXML.append("<PERSONALCNT>" + personalCount_ + "</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
        resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
        resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
        resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for (BoardListHeaderVO vo:headerList) {
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
        	resultXML.append("</HEADER>");
        }
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        for (int j = 0; j < dlength; j++) {
        	resultXML.append("<ROW>");
            for (i = 0; i < hlength; i++) {
            	resultXML.append("<CELL>");
            	fieldName = headerList.get(i).getColName().toUpperCase();

                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("BOARDNAME")) {
                    fieldName = fieldName + strMultiData;
                }
                if (fieldName.equals("WRITEDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC((String)boardList.get(j).get(fieldName), userInfo.getOffset(), false);
                	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                } else {
                	fieldValue = commonUtil.cleanValue(String.valueOf(boardList.get(j).get(fieldName)));
                }
                
                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                
                if (i == 0) {
                	resultXML.append("<DATA1>" + boardList.get(j).get("BOARDID") + "</DATA1>");
                	resultXML.append("<DATA2>" + boardList.get(j).get("ITEMID") + "</DATA2>");
        			resultXML.append("<DATA3>" + boardList.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardList.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>1</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardList.get(j).get("ABSTRACT")) + "</DATA6>");
					resultXML.append("<DATA7>N</DATA7>");
					resultXML.append("<DATA8>" + boardList.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardList.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardList.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardList.get(j).get("ONELINECNT") + "</DATA11>");
					resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardList.get(j).get("MAINCONTENT")) + "</DATA12>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
		return resultXML.toString();
	}
	
	/**
	 * 게시판 게시판게시물 표출 Method
	 */
	public String getBoardListItem(BoardVO boardVO, LoginVO userInfo, String type) throws Exception{
        String orderOption1 = "";
        String orderOption2 = "";
        String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());

        List<BoardListHeaderVO> headerList = ezBoardService.getListHeaderBoardID(boardVO);

        // 헤더 정보를 세팅한다.
        int i = 0;
        int hlength = headerList.size(); 
        int writeDateSN = 0;    //작성일 순번
        int titleSN = 0;            //제목 순번

        for (i = 0; i < hlength; i++) {
            if (!boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
                if (boardVO.getOrderOption().equals("")) {
                    orderOption1 = headerList.get(i).getColName() + " ";
                    orderOption2 = headerList.get(i).getColName() + " DESC ";
                } else {
                    orderOption1 = headerList.get(i).getColName() + " DESC ";
                    orderOption2 = headerList.get(i).getColName() + " ";
                }
            }
            if (headerList.get(i).getColName().toUpperCase().equals("WRITEDATE")) {
                writeDateSN = i;
            }
            if (headerList.get(i).getColName().toUpperCase().equals("TITLE")) {
                titleSN = i;
            }
        }
        int noticeCount = 0;
        
        if (type.equals("1")) {
        	boardVO.setNowDate(commonUtil.getTodayUTCTime(""));
        	noticeCount = ezBoardService.getNoticePostItemCount(boardVO);
        }
        
        BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
        boardMyFavoriteVO.setBoardId(boardVO.getBoardId());
        boardMyFavoriteVO.setUserId(userInfo.getId());
        boardMyFavoriteVO.setType(type);
        boardMyFavoriteVO.setTenantID(userInfo.getTenantId());
        boardMyFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
        
        int boardCount = ezBoardService.getBrdTotalItemCount(boardMyFavoriteVO);
   
        int startRow = 1;
        int endRow = 0;

        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
        
        int personalCount = boardConfigVO.getListCount();
        String previewtype = boardConfigVO.getPreview();
        String fieldName = "";
        String fieldValue = "";
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");

        if (noticeCount > 0 && type.equals("1")) {
            endRow = (personalCount * boardVO.getPageNum()) - noticeCount;

            List<HashMap<String, Object>> noticeList = ezBoardService.getNoticePostItem(boardVO, personalCount);

            int k = 0;
            int nlength = noticeList.size();
            
            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
            resultXML.append("<PAGECNT>" + ((int)noticeCount + (int)boardCount) + "</PAGECNT>");
            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
            resultXML.append("<LISTVIEWDATA>");
            resultXML.append("<HEADERS>");
            
            for (BoardListHeaderVO vo:headerList) {
            	resultXML.append("<HEADER>");
        		resultXML.append("<NAME>"+vo.getName()+"</NAME>");
            	resultXML.append("<WIDTH>"+vo.getWidth()+"</WIDTH>");
            	resultXML.append("<COLNAME>"+vo.getColName()+"</COLNAME>");
            	resultXML.append("</HEADER>");
            }
            resultXML.append("</HEADERS>");
            resultXML.append("<ROWS>");
            
            for (k=0; k < nlength; k++) {
            	resultXML.append("<ROW>");
                for (i = 0; i < hlength; i++) {
                	resultXML.append("<CELL>");
                    fieldName = headerList.get(i).getColName().toUpperCase();
                    
                    if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
                        fieldName = fieldName + strMultiData;
                    }
                    if (fieldName.equals("WRITEDATE")) {
                    	fieldValue = commonUtil.getDateStringInUTC((String) noticeList.get(k).get(fieldName), userInfo.getOffset(), false);
                    	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                    } else {
                    	fieldValue = commonUtil.cleanValue(String.valueOf(noticeList.get(k).get(fieldName)));
                    }
                    
                    if (fieldValue == null || fieldValue.equals(null) || fieldValue.equals("null")) {
                    	fieldValue = "";
    				}
                    
                    resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                    
                    if (i == 0) {
                    	resultXML.append("<DATA1>" + noticeList.get(k).get("BOARDID") + "</DATA1>");
                    	resultXML.append("<DATA2>" + noticeList.get(k).get("ITEMID") + "</DATA2>");
            			resultXML.append("<DATA3>" + noticeList.get(k).get("WRITERID") + "</DATA3>");
    					resultXML.append("<DATA4>" + noticeList.get(k).get("IMPORTANCE") + "</DATA4>");
    					resultXML.append("<DATA5>" + noticeList.get(k).get("READFLAG") + "</DATA5>");
    					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)noticeList.get(k).get("ABSTRACT")) + "</DATA6>");
    					String nowDate = commonUtil.getTodayUTCTime("");
    				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
    				    
    					if (noticeList.get(k).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
    						resultXML.append("<DATA7>Y</DATA7>");
    					} else {
    						resultXML.append("<DATA7>N</DATA7>");
    					}
    					resultXML.append("<DATA8>" + noticeList.get(k).get("ITEMLEVEL") + "</DATA8>");
    					resultXML.append("<DATA9>" + noticeList.get(k).get("NOTICE") + "</DATA9>");
    					resultXML.append("<DATA10></DATA10>");
    					resultXML.append("<DATA11>" + noticeList.get(k).get("ONELINECNT") + "</DATA11>");
    					resultXML.append("<DATA12>" + commonUtil.cleanValue((String)noticeList.get(k).get("MAINCONTENT")) + "</DATA12>");
    					resultXML.append("<TITLE>" +  commonUtil.cleanValue((String)noticeList.get(k).get("TITLE"))  + "</TITLE>");
    					
    					if (commonUtil.getPrimaryData(boardVO.getLang(), userInfo.getTenantId()).equals("1")) {
    						resultXML.append("<WRITERNAME>" + noticeList.get(k).get("WRITERNAME") + "</WRITERNAME>");
    						resultXML.append("<WRITERDEPTNAME>" + noticeList.get(k).get("WRITERDEPTNAME") + "</WRITERDEPTNAME>");
    					} else {
    						resultXML.append("<WRITERNAME>" + noticeList.get(k).get("WRITERNAME2") + "</WRITERNAME>");
    						resultXML.append("<WRITERDEPTNAME>" + noticeList.get(k).get("WRITERDEPTNAME2") + "</WRITERDEPTNAME>");
    					}
    					resultXML.append("<WRITEDATE>" + commonUtil.getDateStringInUTC((String)noticeList.get(k).get("WRITEDATE"), userInfo.getOffset(), false) + "</WRITEDATE>");
    					resultXML.append("<ATTACHMENTS>" + noticeList.get(k).get("ATTACHMENTS") + "</ATTACHMENTS>");
                    }
                    resultXML.append("</CELL>");
                }
                resultXML.append("</ROW>");
            }
        } else {
            startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
            endRow = (personalCount * boardVO.getPageNum());

            resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
            resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
            resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
            resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
            resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
            resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
            resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
            resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
            resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
            resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
            resultXML.append("<LISTVIEWDATA>");
            resultXML.append("<HEADERS>");
            
            for (BoardListHeaderVO vo:headerList) {
            	resultXML.append("<HEADER>");
        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
            	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
            	resultXML.append("</HEADER>");
            }
            resultXML.append("</HEADERS>");
            resultXML.append("<ROWS>");
            
        }
        if (boardVO.getPageNum() != 1) {
            startRow = ((personalCount * (boardVO.getPageNum() - 1)) - noticeCount) + 1;
            endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
        }
        
        List<HashMap<String, Object>> boardListItem = ezBoardService.getBoardListItem(boardVO.getBoardId(), userInfo.getId(), startRow, endRow, boardCount, orderOption1, orderOption2, type, userInfo.getTenantId());

        int dlength = boardListItem.size();
        
        for (int j = 0; j < dlength; j++) {
        	resultXML.append("<ROW>");
            for (i = 0; i < hlength; i++) {
            	resultXML.append("<CELL>");
                fieldName = headerList.get(i).getColName().toUpperCase();

                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
                    fieldName = fieldName + strMultiData;
                }

                if (fieldName.equals("WRITEDATE")) {
                	fieldValue = commonUtil.getDateStringInUTC((String) boardListItem.get(j).get(fieldName), userInfo.getOffset(), false);
                	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                } else {
                    fieldValue = commonUtil.cleanValue(String.valueOf(boardListItem.get(j).get(fieldName)));
                }

                if (fieldValue == null || fieldValue.equals(null) || fieldValue.equals("null")) {
                	fieldValue = "";
				}
                
                resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
                
                if (i == 0) {
                	resultXML.append("<DATA1>" + boardListItem.get(j).get("BOARDID") + "</DATA1>");
                	resultXML.append("<DATA2>" + boardListItem.get(j).get("ITEMID") + "</DATA2>");
        			resultXML.append("<DATA3>" + boardListItem.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardListItem.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardListItem.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardListItem.get(j).get("ABSTRACT")) + "</DATA6>");
					String nowDate = commonUtil.getTodayUTCTime("");
				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
				    
					if (boardListItem.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					resultXML.append("<DATA8>" + boardListItem.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardListItem.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10></DATA10>");
					resultXML.append("<DATA11>" + boardListItem.get(j).get("ONELINECNT") + "</DATA11>");
					resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardListItem.get(j).get("MAINCONTENT")) + "</DATA12>");
					resultXML.append("<TITLE>" + commonUtil.cleanValue((String)boardListItem.get(j).get("TITLE")) + "</TITLE>");
					resultXML.append("<WRITERNAME>" + boardListItem.get(j).get("WRITERNAME") + "</WRITERNAME>");
					resultXML.append("<WRITERNAME2>" + boardListItem.get(j).get("WRITERNAME2") + "</WRITERNAME2>");
					resultXML.append("<WRITERDEPTNAME>" + boardListItem.get(j).get("WRITERDEPTNAME") + "</WRITERDEPTNAME>");
					resultXML.append("<WRITERDEPTNAME2>" + boardListItem.get(j).get("WRITERDEPTNAME2") + "</WRITERDEPTNAME2>");
					resultXML.append("<WRITEDATE>" + commonUtil.getDateStringInUTC((String)boardListItem.get(j).get("WRITEDATE"), userInfo.getOffset(), false) + "</WRITEDATE>");
					resultXML.append("<ATTACHMENTS>" + boardListItem.get(j).get("ATTACHMENTS") + "</ATTACHMENTS>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
        return resultXML.toString();
    }
	
	/**
	 * 게시판 서브게시판 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getSubBoards.do")
	public void getSubBoards(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, BoardPropertyVO boardInfo, HttpServletRequest req, HttpServletResponse res) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
	    String pRootBoardID = "";
	    String pSubFlag = "";
	    int pSelectBy = 0;
	    String pExcludeBoardID = " ";
	    
	    if (req.getParameter("rootBoardID") != null && !req.getParameter("rootBoardID").equals("")) {
	    	pRootBoardID = req.getParameter("rootBoardID");
	    }
	    if (req.getParameter("subFlag") != null && !req.getParameter("subFlag").equals("")) {
	    	pSubFlag = req.getParameter("subFlag");
	    }
	    if (req.getParameter("selectFlag") != null && !req.getParameter("selectFlag").equals("")) {
	    	pSelectBy = Integer.parseInt(req.getParameter("selectFlag"));
	    }
	    if (req.getParameter("pExcludeBoardID") != null && !req.getParameter("pExcludeBoardID").equals("")) {
	    	pExcludeBoardID = req.getParameter("pExcludeBoardID");
	    }
	
	    String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
	    int pMode = 0;
	
	    if (userInfo.getRollInfo() != null && (boardGroupAdmin_FG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1)) {
	    	pMode = 0;
	    } else {
	    	pMode = 1;
	    }
	
	    String strXML = ezBoardService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());

	    Document doc = commonUtil.convertStringToDocument(strXML);
	    NodeList nList = doc.getElementsByTagName("NODE");
	    
	    if (!strXML.substring(0, 5).toUpperCase().equals("ERROR")) {
	        if (ezCommonService.getTenantConfig("USE_BOARD_LEFTMENU_COUNT", userInfo.getTenantId()).equals("YES")) {
            	BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
            	int intCount = 0;
            	
	            if (nList != null) {
	            	for (int i = 0; i < nList.getLength(); i++) {
	            		Node node = nList.item(i);
	            		
	            		myFavoriteVO.setBoardId(node.getChildNodes().item(2).getTextContent());
            			myFavoriteVO.setUserId(userInfo.getId());
            			myFavoriteVO.setType("1");
            			myFavoriteVO.setTenantID(userInfo.getTenantId());
            			myFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
            			
	            		if (node.getChildNodes().item(6).getTextContent().equals("4")) {
	            			intCount = ezBoardService.getThumbNailCount(myFavoriteVO);
	            		} else if (node.getChildNodes().item(6).getTextContent().equals("5")) {
	            			boardInfo = getBoardInfo(node.getChildNodes().item(2).getTextContent(), userInfo);
	            			myFavoriteVO.setBoardAdmin_FG(boardInfo.getBoardAdmin_FG());
	            			intCount = ezBoardService.getQNABrdTotalItemCount(myFavoriteVO);
	            		} else {
	            			intCount = ezBoardService.getBrdTotalItemCount(myFavoriteVO);
	            		}
	            		String strName = "";
	            		
	            		if (intCount != 0) {
	            			strName = "(" + intCount + ")";
	            		}
	            		node.getChildNodes().item(0).setTextContent(node.getChildNodes().item(0).getTextContent() + strName);
	            	}
	            }
	        }
	    } else {
	    	doc = commonUtil.convertStringToDocument("<RESULT>ERROR</RESULT>");
	    }
	    
	    String output = commonUtil.convertDocumentToString(doc);
	    
	    res.setContentType("text/xml"); 
        res.setCharacterEncoding("UTF-8");
        res.setHeader("Cache-Control", "no-cache");
        res.getWriter().write(output);
	}
	
	/**
	 * 게시판 환경설정 순서  표출 Method
	 */
	@RequestMapping(value="/ezBoard/saveListOrder.do", method = RequestMethod.POST)
	public void saveListOrder(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
        String pBoardList = request.getParameter("pBoardList");
        String pDelBoardList = request.getParameter("pDelboardList");
 
        ezBoardService.setListOrder(userInfo, pBoardList, pDelBoardList);
	}
	
	/**
	 * 게시판 환경설정 탭 표출 Method
	 */
	@RequestMapping(value="/ezBoard/set_TabUse.do")
	public void set_TabUse(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String pUserID = loginVO.getId();
		String pBoardList = request.getParameter("pBoardList");
		String tabUsed = request.getParameter("tabUsed");
		int tenantID = loginVO.getTenantId();

        ezBoardService.setTabUsed(pUserID, pBoardList, tabUsed, tenantID);
	}
	
	/**
	 * 게시판 게시판권한체크 표출 Method
	 */
	public boolean accessCheck(String itemID, String boardType, LoginVO userInfo) throws Exception{
        String rootBoardID = "top";
        String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(rootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
        
        if (userInfo.getRollInfo() != null && (boardGroupAdmin_FG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1)) {
            return true;
        } else {
            int result = 0;
            boolean rtv = false;

            String deptPath = userInfo.getDeptPathCode();
            String deptPathOrgan = "";
            for (int ch = 0; ch < deptPath.split(",").length; ch++) {
                if (ch == 0) {
                	deptPathOrgan += deptPath.split(",")[ch].trim();
                } else {
                	deptPathOrgan += "," + deptPath.split(",")[deptPath.split(",").length - (ch)].trim();
                }
            }
            String userDeptPath = deptPathOrgan + ",everyone";

            if (boardType == null || boardType.toUpperCase().equals("")) {
            	boardType = "GENERAL";
            }
            for (int i = 0; i < userDeptPath.split(",").length; i++) {
            	result = ezBoardService.getCheckItemID(itemID, boardType, userDeptPath.split(",")[i].trim(), userInfo.getTenantId());
            	
                if (boardType.toUpperCase().equals("GENERAL")) {
                    if (result > 0) {
                        rtv = false;
                        break;
                    } else {
                        rtv = true;
                    }
                } else {
                    if (result > 0) {
                        rtv = true;
                        break;
                    } else {
                        rtv = false;
                        break;
                    }
                }
            }
            
            return rtv;
        }
    }
	
	/**
	 * 게시판 게시판게시물 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemView.do")
	public String getBoardItemView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
        String apprFlag = "Y";
        String extenLang = "1";
        String location = "";
        String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String useIE11Browser = "";
        String publicModulus = egovFileScrty.getPbm();
        String publicExponent = "10001";
        
        if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && useIE11Browser.equals("CK")) {
        	useIE11Browser = "CK";
        }

        String adjacentItemsEnableFlag = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
        String showAdjacent = request.getParameter("showAdjacent");
        String boardID = request.getParameter("boardID");
        String itemID = request.getParameter("itemID");
        String pReservedItem = request.getParameter("pReservedItem");
        
        location = request.getParameter("location");
        
        if (!accessCheck(itemID, location, userInfo)) {
        	return "main/warning";
        }
        BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
        //KMS 안써서 픽스
        String useEzKMS = "NO";
        
        if (!boardInfo.getRead_FG().equals("true")) {
        	return "main/warning";
        }
        String guBun = boardInfo.getGuBun();
        //추가항목 잇을 경우 추가항목을 가져온다
        List<BoardAttributeVO> boardAttr = new ArrayList<BoardAttributeVO>();
        int boardAttrCount = 0; 
        
        if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
        	boardAttr = ezBoardAdminService.getBoardAttribute(boardID, userInfo.getTenantId());
        	boardAttrCount = boardAttr.size();
        	
            if (!commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
            	extenLang = "2";
            }
        }
        BoardListVO boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
        
        if (boardItem == null) {
        	return "main/warning";
        }
        
        ezBoardService.setAsRead(userInfo, boardID, itemID);
        
        if (boardItem.getApprFlag() != null && boardItem.getApprFlag().equals("N")) {
		    int checkCnt = ezBoardService.getCheckApprUserList(userInfo.getId(), itemID, userInfo.getTenantId());
		    
		    if (checkCnt == 0) {
		    	boardItem.setApprFlag("W");
		    }
        }
        
        BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());

        String nowTime = commonUtil.getTodayUTCTime("");
        String writeTime = boardItem.getWriteDate();

        if (EgovDateUtil.getDaysDiff(writeTime.substring(0,10), nowTime.substring(0,10)) < 0) {
            pReservedItem = "true";
        }

        boardItem.setWriteDate(commonUtil.getDateStringInUTC(boardItem.getWriteDate(), userInfo.getOffset(), false));
        boardItem.setEndDate(commonUtil.getDateStringInUTC(boardItem.getEndDate(), userInfo.getOffset(), false));
        
        if (boardItem.getEndDate() != null && boardItem.getEndDate().substring(0, 4).equals("9999")) {
        	boardItem.setEndDate(egovMessageSource.getMessage("ezBoard.t287", userInfo.getLocale()));
        }
        
        BoardVO adjacentItem = new BoardVO();
        if (adjacentItemsEnableFlag != null && showAdjacent != null && adjacentItemsEnableFlag.equals("1") && showAdjacent.equals("1")) {
            if (boardItem.getUpperItemIDTree() == null || boardItem.getUpperItemIDTree().equals("") ) {
            	boardItem.setUpperItemIDTree(itemID);
            }
            
            if (!guBun.equals("3")) {
            	adjacentItem = getAdjacentItems(itemID, boardID, boardItem.getUpperItemIDTree(), boardItem.getParentWriteDate(), userInfo.getTenantId());
            } else {
            	adjacentItem = getAdjacentItemsPhoto(itemID, boardID, boardItem.getUpperItemIDTree(), boardItem.getParentWriteDate(), userInfo.getTenantId());
            }

            if (adjacentItem.getPreviousTitle().equals("")) {
            	adjacentItem.setPreviousTitle(egovMessageSource.getMessage("ezBoard.t330", userInfo.getLocale()));
            }
            if (adjacentItem.getNextTitle().equals("")) {
            	adjacentItem.setNextTitle(egovMessageSource.getMessage("ezBoard.t331", userInfo.getLocale()));
            }
        }
        
        if (boardInfo.getBoardName() != null && !boardInfo.getBoardName().equals("")) {
        	boardInfo.setBoardName(commonUtil.cleanValue(boardInfo.getBoardName()));
        }
        
        if (boardInfo.getBoardName1() != null && !boardInfo.getBoardName1().equals("")) {
        	boardInfo.setBoardName1(commonUtil.cleanValue(boardInfo.getBoardName1()));
        }
        
        if (boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().equals("")) {
        	boardInfo.setBoardName2(commonUtil.cleanValue(boardInfo.getBoardName2()));
        }
        
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("boardItem", boardItem);
        model.addAttribute("boardAttr", boardAttr);
        model.addAttribute("boardAttrCount", boardAttrCount);
        model.addAttribute("adjacentItem", adjacentItem);
        model.addAttribute("boardPropertyVO", boardPropertyVO);
        model.addAttribute("apprFlag", apprFlag);
        model.addAttribute("extenLang", extenLang);
        model.addAttribute("location", location);
        model.addAttribute("useOcs", useOcs);
        model.addAttribute("useEditor", useEditor);
        model.addAttribute("useIE11Browser", useIE11Browser);
        model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
        model.addAttribute("showAdjacent", showAdjacent);
        model.addAttribute("boardID", boardID);
        model.addAttribute("itemID", itemID);
        model.addAttribute("pReservedItem", pReservedItem);
        model.addAttribute("useEzKMS", useEzKMS);
        model.addAttribute("guBun", guBun);
        model.addAttribute("publicModulus", publicModulus);
        model.addAttribute("publicExponent", publicExponent);
        
        return "ezBoard/boardItemView";
    }
	
	/**
	 * 게시판 읽음표시 실행 Method
	 */
	@RequestMapping(value="/ezBoard/setRead.do")
	public void setAsRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pBoardID = "";
        String pItemIDList = "";
        
        if (request.getParameter("boardID") != null) {
        	pBoardID = request.getParameter("boardID");
        }
        if (request.getParameter("itemIDList") != null) {
        	pItemIDList = request.getParameter("itemIDList");
        }
        
        String[] itemIDs = pItemIDList.split(";");
        
        for (int k = 0; k < itemIDs.length; k++) {
        	ezBoardService.setAsRead(userInfo, pBoardID, itemIDs[k]);
        }
	}
	
	/**
	 * 게시판 새게시물,임시게시물게시하기 호출 Method
	 */
	@RequestMapping(value = {"/ezBoard/boardNewItem.do", "/ezBoard/boardNewItemTempPhoto.do"})
	public String newBoardItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, BoardListVO boardListVO, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
        String extenLang = "1";
        String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
        String publicModulus = egovFileScrty.getPbm();
        String publicExponent = "10001";
        String mode = "";
        String boardID = "";
        String itemID = "";
        String url = "";
        String hasAttach = "";
        String strWriterFakeName = "";
        String reservedItem = "";
        String checkForm = "";
        String useBackGround = "";
        String docID = "";
        String boardType = "";
        String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
        
        requestURL = requestURL.substring(1, requestURL.length() - 3);
        
        if (request.getParameter("mode") != null) {
        	mode = request.getParameter("mode");
        }
        if (boardListVO.getBoardID() != null) {
        	boardID = boardListVO.getBoardID();
        }
        if (boardListVO.getItemID() != null) {
        	itemID = boardListVO.getItemID();
        }
        if (request.getParameter("url") != null) {
        	url = request.getParameter("url");
        }
        if (request.getParameter("bType") != null) {
        	boardType = request.getParameter("bType");
        }
        if (request.getParameter("docID") != null) {
        	docID = request.getParameter("docID");
        }
        if (request.getParameter("reservedItem") != null) {
        	reservedItem = request.getParameter("reservedItem");
        }
        String newGuid = UUID.randomUUID().toString();
        BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
        
        if (boardInfo.getWrite_FG() != null && boardInfo.getWrite_FG().equals("false")) {
        	return "main/warning";
        }
        //추가 항목 가져오는 소스 
        List<BoardAttributeVO> boardAttributeListVO = new ArrayList<BoardAttributeVO>();
        if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
        	boardAttributeListVO = ezBoardAdminService.getBoardAttribute(boardID, userInfo.getTenantId());
        	if (!commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
        		extenLang = "2";
        	}
        }
        String startDateTime = "";
        String endDateTime = "";
        String expireDays = "";
        String expireItem = "";
        String strTitle = "";
        String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
        
        if (!url.equals("")) {        	
        	startDateTime = today;
        	endDateTime = EgovDateUtil.addDay(startDateTime, 30, "yyyy-MM-dd");
        	expireDays = "-1";
        } else {
        	expireDays = boardInfo.getExpireDays();
        	if (!mode.equals("new")) {
        		if (!mode.equals("temp")) {
        			boardListVO = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
        		} else {
        			boardListVO = ezBoardService.getBrdGetItemInfoTemp(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
        		}
        		if (mode.equals("reply")) {
        			boardListVO.setItemLevel(String.valueOf((Integer.parseInt(boardListVO.getItemLevel()) + 1)));
        			boardListVO.setABSTRACT("");
        		}
        		strTitle = boardListVO.getTitle();
        		boardListVO.setTitle(boardListVO.getTitle());
        		boardListVO.setABSTRACT(boardListVO.getABSTRACT());
        		
        		if (Integer.parseInt(boardListVO.getAttachments()) > 0) {
        			hasAttach = "YES";
        		}
        	}
        	startDateTime = today;
        	
        	if (mode.equals("modify") || mode.equals("temp")) {
        		if (boardListVO.getEndDate().substring(0, 4).equals("9999")) {
        			expireItem = "YES";
        			if (expireDays.equals("-1")) {
        				endDateTime = EgovDateUtil.addDay(today, 30, "yyyy-MM-dd");
        			} else {
        				endDateTime = EgovDateUtil.addDay(today, Integer.parseInt(expireDays), "yyyy-MM-dd");
        			}
        		} else {
        			boardListVO.setEndDate(commonUtil.getDateStringInUTC(boardListVO.getEndDate(), userInfo.getOffset(), false));
        			endDateTime = commonUtil.getDateStringInUTC(boardListVO.getEndDate(), userInfo.getOffset(), false).split(" ")[0];
        		}
        		
        		startDateTime = commonUtil.getDateStringInUTC(boardListVO.getStartDate(), userInfo.getOffset(), false);
        	} else {
        		if (expireDays.equals("-1")) {
        			endDateTime = EgovDateUtil.addDay(today, 30, "yyyy-MM-dd");
    			} else {
    				endDateTime = EgovDateUtil.addDay(today, Integer.parseInt(expireDays), "yyyy-MM-dd");
    			}
        	}
        	if (boardInfo.getGuBun().equals("2")) {
    			strWriterFakeName = boardListVO.getWriterName();
        	}
        }
        
        ZoneId utc = ZoneId.ofOffset("UTC", ZoneOffset.of(userInfo.getOffset().split("\\|")[1]));
		ZonedDateTime getTime = ZonedDateTime.of(LocalDateTime.now(utc), utc);
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH");
		
		if (getTime.getMinute() > 30) {
			getTime.plusHours(1);
			startDateTime = getTime.format(formatter);
			startDateTime = startDateTime + ":00:00"; 
		} else {
			startDateTime = getTime.format(formatter);
			startDateTime = startDateTime + ":30:00"; 
		}
		
                
        if (reservedItem.equals("true")) {
        	startDateTime = commonUtil.getDateStringInUTC(boardListVO.getStartDate(), userInfo.getOffset(), false);
        }
        
        checkForm = ezBoardService.checkForm(boardID, "Y", userInfo.getTenantId());
        useBackGround = ezBoardService.checkBackGroundImage(boardID, userInfo.getTenantId());
        
        if (boardInfo.getBoardName() != null && !boardInfo.getBoardName().equals("")) {
        	boardInfo.setBoardName(commonUtil.cleanValue(boardInfo.getBoardName()));
        }
        
        if (boardInfo.getBoardName1() != null && !boardInfo.getBoardName1().equals("")) {
        	boardInfo.setBoardName1(commonUtil.cleanValue(boardInfo.getBoardName1()));
        }
        
        if (boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().equals("")) {
        	boardInfo.setBoardName2(commonUtil.cleanValue(boardInfo.getBoardName2()));
        }
        
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("boardListVO", boardListVO);
        model.addAttribute("boardAttributeListVO", boardAttributeListVO);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("extenLang", extenLang);
        model.addAttribute("editor", editor);
        model.addAttribute("uploadFilePath", uploadFilePath);
        model.addAttribute("mode", mode);
        model.addAttribute("boardID", boardID);
        model.addAttribute("itemID", itemID);
        model.addAttribute("url", url);
        model.addAttribute("hasAttach", hasAttach);
        model.addAttribute("strWriterFakeName", strWriterFakeName);
        model.addAttribute("reservedItem", reservedItem);
        model.addAttribute("checkForm", checkForm);
        model.addAttribute("useBackGround", useBackGround);
        model.addAttribute("strNow", today);
        model.addAttribute("startDateTime", startDateTime);
        model.addAttribute("endDateTime", endDateTime);
        model.addAttribute("expireDays", expireDays);
        model.addAttribute("expireItem", expireItem);
        model.addAttribute("strTitle", strTitle);
        model.addAttribute("newGuid", newGuid);
        model.addAttribute("docID", docID);
        model.addAttribute("boardType", boardType);
        model.addAttribute("publicModulus", publicModulus);
        model.addAttribute("publicExponent", publicExponent);
	    model.addAttribute("isCrossBrowser", isCrossBrowser);
        
		return requestURL;
	}
	
	/**
	 * 게시판 ckeditor 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/ckEditor.do")
	public String ckEditor(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userInfo",userInfo);
		
		return "ezBoard/boardCKEditor";
	}
	
	/**
	 * 게시판 draganddrop 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/dragAndDrop.do")
	public String dragAndDrop(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo",userInfo);
		
		return "ezBoard/boardDragAndDrop";
	}
	
	/**
	 * 게시판 게시물저장 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/saveItem.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveItem(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("saveItem started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		String pMode = "";
        String gubun = "";
        String realPath = commonUtil.getRealPath(request);
        
        if (request.getParameter("mode") != null) {
        	pMode = request.getParameter("mode");
        }
        if (request.getParameter("guBun") != null) {
        	gubun = request.getParameter("guBun");
        }
        
        Document doc = commonUtil.convertStringToDocument(xmlData.toString());

        String attachList = "";
        String smallName = "";
        String title = "";
        String itemID = "";
        String[] attchArray = null;
        String[] smallArray = null;
        String[] itemid = null;
    	
    	if (gubun.equals("2")) {
    		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
    		String rpwd = EgovFileScrty.decryptRsa(pk, doc.getElementsByTagName("DOCPASSWORD").item(0).getTextContent());
    		
    		doc.getElementsByTagName("DOCPASSWORD").item(0).setTextContent(EgovFileScrty.encryptPassword(rpwd, "unknown"));
    	}   	
    	
        BoardPropertyVO boardInfo = getBoardInfo(doc.getElementsByTagName("BOARDID").item(0).getTextContent(), userInfo);
        
        if (boardInfo.getWrite_FG().equals("false")) {
            return "<RESULT>INACCESSIBLE</RESULT>";
        }
        if (gubun.equals("3")) {
            attachList = doc.getElementsByTagName("ATTACHMENTS").item(0).getTextContent();
            smallName = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
            title = doc.getElementsByTagName("TITLE").item(0).getTextContent();
            itemID = doc.getElementsByTagName("ITEMID").item(0).getTextContent();
            attchArray = attachList.split(";");
            smallArray = smallName.split(";");
            itemid = itemID.split(";");
        }                

        String ret = "";

        //gubun 3이면 포토게시판 2는 익명
        if (gubun.equals("3")) {
            if (attchArray.length == smallArray.length) {
                for (int i = 0; i < attchArray.length - 1; i++) {
                    doc.getElementsByTagName("ATTACHMENTS").item(0).setTextContent(attchArray[i] + ";");
                    doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).setTextContent(smallArray[i]);
                    doc.getElementsByTagName("ITEMID").item(0).setTextContent(itemid[i]);
                    doc.getElementsByTagName("UPPERITEMIDTREE").item(0).setTextContent(itemid[i]);
                    
                    if (attchArray.length > 2) {
                    	doc.getElementsByTagName("TITLE").item(0).setTextContent(title + "_" + (i + 1));
                    }
                    if (i > 0) {
                        pMode = "New";
                        doc.getElementsByTagName("STARTDATE").item(0).setTextContent(commonUtil.getTodayUTCTime(""));
                    }
                    ret = insertNewItem(doc, pMode, realPath, userInfo);
                }
            }
        } else {
            ret = insertNewItem(doc, pMode, realPath, userInfo);
        }
        
        logger.debug("saveItem ended. ret=" + ret);
        
        return "<RESULT>" + ret + "</RESULT>";
	}

	/**
	 * 게시판 게시물저장 실행 Method
	 */
	public String insertNewItem(Document doc, String pMode, String realPath, LoginVO userInfo) throws Exception{
		BoardListVO boardListVO = new BoardListVO();

		boolean saveMHTResult = false;
		boardListVO.setFilePath(doc.getElementsByTagName("FILEPATH").item(0).getTextContent());
		boardListVO.setItemID(doc.getElementsByTagName("ITEMID").item(0).getTextContent());
		boardListVO.setBoardID(doc.getElementsByTagName("BOARDID").item(0).getTextContent());
		boardListVO.setWriterID(doc.getElementsByTagName("WRITERID").item(0).getTextContent());
		boardListVO.setTopWriterID(doc.getElementsByTagName("TOPWRITERID").item(0).getTextContent());
		boardListVO.setWriterName(doc.getElementsByTagName("WRITERNAME").item(0).getTextContent());
		boardListVO.setWriterName2(doc.getElementsByTagName("WRITERNAME2").item(0).getTextContent());
		boardListVO.setWriterDeptID(doc.getElementsByTagName("DEPTID").item(0).getTextContent());
		boardListVO.setWriterDeptName(doc.getElementsByTagName("DEPTNAME").item(0).getTextContent());
		boardListVO.setWriterDeptName2(doc.getElementsByTagName("DEPTNAME2").item(0).getTextContent());
		boardListVO.setWriterCompanyID(doc.getElementsByTagName("COMPANYID").item(0).getTextContent());
		boardListVO.setWriterCompanyName(doc.getElementsByTagName("COMPANYNAME").item(0).getTextContent());
		boardListVO.setWriterCompanyName2(doc.getElementsByTagName("COMPANYNAME2").item(0).getTextContent());
		boardListVO.setWriteDate(commonUtil.getTodayUTCTime(""));
		boardListVO.setImportance(doc.getElementsByTagName("IMPORTANCE").item(0).getTextContent());
		boardListVO.setTitle(doc.getElementsByTagName("TITLE").item(0).getTextContent());
		boardListVO.setRealPath(realPath);
		boardListVO.setTenantID(userInfo.getTenantId());
		
		if (pMode.equals("copy")) {
			boardListVO.setContentLocation(doc.getElementsByTagName("CONTENTLOCATION").item(0).getTextContent());
		} else {
			boardListVO.setContentLocation(commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator + boardListVO.getBoardID() + commonUtil.separator + "doc" + commonUtil.separator + boardListVO.getItemID() + ".mht");
		}
		
		if (doc.getElementsByTagName("STARTDATE").item(0).getTextContent() != null && !doc.getElementsByTagName("STARTDATE").item(0).getTextContent().equals("")) {
			boardListVO.setStartDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("STARTDATE").item(0).getTextContent(), userInfo.getOffset(), true));
			boardListVO.setWriteDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("STARTDATE").item(0).getTextContent(), userInfo.getOffset(), true));
		} else {
			boardListVO.setStartDate(commonUtil.getTodayUTCTime(""));
		}
		
		boardListVO.setEndDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("ENDDATE").item(0).getTextContent(), userInfo.getOffset(), true));
		boardListVO.setABSTRACT(doc.getElementsByTagName("ABSTRACT").item(0).getTextContent());
		boardListVO.setAttachments(doc.getElementsByTagName("ATTACHMENTS").item(0).getTextContent());
		boardListVO.setUpperItemIDTree(doc.getElementsByTagName("UPPERITEMIDTREE").item(0).getTextContent());
		
		//답변의 경우 최근에 답변 달은 것이 최상위로 와야함(by design)
		if (pMode.equals("reply")) {
			boardListVO.setUpperItemIDTree(boardListVO.getUpperItemIDTree() + ezBoardService.getReverseDateNow() + boardListVO.getItemID());
		}
		boardListVO.setItemLevel(doc.getElementsByTagName("ITEMLEVEL").item(0).getTextContent());

		if (!pMode.equals("copy")) {
			boardListVO.setMainContent(doc.getElementsByTagName("CONTENT").item(0).getTextContent().replace("@r!n@", "\r\n"));
			
			if (pMode.equals("reply") || pMode.equals("modify")) {
				boardListVO.setParentWriteDate(doc.getElementsByTagName("PARENTWRITEDATE").item(0).getTextContent());
			} else {
				boardListVO.setParentWriteDate("docNO");
			}
		} else {
			boardListVO.setParentWriteDate("docNO");
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent() == null || doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent().equals("")) {
			boardListVO.setExtensionAttribute1("0");
		} else {
			boardListVO.setExtensionAttribute1(doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent());
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() == null || doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().equals("")) {
			boardListVO.setExtensionAttribute2("0");
		} else {
			boardListVO.setExtensionAttribute2(doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent());
		}
		
		boardListVO.setExtensionAttribute3(doc.getElementsByTagName("EXTENSIONATTRIBUTE3").item(0).getTextContent());
		boardListVO.setExtensionAttribute32(doc.getElementsByTagName("EXTENSIONATTRIBUTE32").item(0).getTextContent());
		boardListVO.setExtensionAttribute4(doc.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent());
		boardListVO.setExtensionAttribute5(doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent());
		boardListVO.setDocPassword(doc.getElementsByTagName("DOCPASSWORD").item(0).getTextContent());
		boardListVO.setReadFlag(doc.getElementsByTagName("READCOUNTFLAG").item(0).getTextContent());
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE6").item(0) != null) {
			boardListVO.setExtensionAttribute6(doc.getElementsByTagName("EXTENSIONATTRIBUTE6").item(0).getTextContent());
		} else {
			boardListVO.setExtensionAttribute6("");
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE7").item(0) != null) {
			boardListVO.setExtensionAttribute7(doc.getElementsByTagName("EXTENSIONATTRIBUTE7").item(0).getTextContent());
		} else {
			boardListVO.setExtensionAttribute7("");
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE8").item(0) != null) {
			boardListVO.setExtensionAttribute8(doc.getElementsByTagName("EXTENSIONATTRIBUTE8").item(0).getTextContent());
		} else {
			boardListVO.setExtensionAttribute8("");
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE9").item(0) != null) {
			boardListVO.setExtensionAttribute9(doc.getElementsByTagName("EXTENSIONATTRIBUTE9").item(0).getTextContent());
		} else {
			boardListVO.setExtensionAttribute9("");
		}
		
		if (doc.getElementsByTagName("EXTENSIONATTRIBUTE10").item(0) != null) {
			boardListVO.setExtensionAttribute10(doc.getElementsByTagName("EXTENSIONATTRIBUTE10").item(0).getTextContent());
		} else {
			boardListVO.setExtensionAttribute10("");
		}
		
		if (!pMode.equals("copy")) {
			saveMHTResult = ezBoardService.saveMHT(boardListVO.getMainContent(), boardListVO.getItemID(), boardListVO.getBoardID(), boardListVO.getFilePath(), "BOARD", realPath);
			if (saveMHTResult == false) {
				return egovMessageSource.getMessage("ezCommunity.lhj04", userInfo.getLocale());
			}
		}
		
		if (boardListVO.getAttachments() != null && !boardListVO.getAttachments().equals("")) {
			boardListVO.setHasAttach("1");
		} else {
			boardListVO.setHasAttach("0");
		}
		
		if (boardListVO.getItemLevel() == null || boardListVO.getItemLevel().equals("")) {
			boardListVO.setItemLevel("0");
		}

		if (pMode.equals("modify")) {
			ezBoardService.brdUpdateItem(boardListVO, "BOARD");
		} else if (pMode.equals("temp")) {
			ezBoardService.brdNewItemTemp(boardListVO);
		} else {
			ezBoardService.brdNewItem(boardListVO);
		}
		
		if (boardListVO.getAttachments() != null && !boardListVO.getAttachments().equals("")) {
			if (!ezBoardService.saveAttachmentsInfo(boardListVO.getAttachments(), boardListVO.getItemID(), boardListVO.getBoardID(), boardListVO.getFilePath(), "BOARD", realPath, userInfo.getTenantId())) {
				return egovMessageSource.getMessage("ezCommunity.lhj05", userInfo.getLocale());
			}
			boardListVO.setHasAttach("1");
		} else {
			boardListVO.setHasAttach("0");
		}
		
		return "OK";
	}
	
	/**
	 * 게시판 게시물첨부 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/uploadItemAttach.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String uploadItemAttach(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload"); 
		int cnt = multiFile.size();
		String realPath = commonUtil.getRealPath(request);
		String[] pFileName = new String[cnt];
        Long[] fileSize = new Long[cnt];
        String[] fileLocation = new String[cnt];
        String[] resultUpload = new String[cnt];
        String[] sGUID = new String[cnt];
        String[] pUploadSN = new String[cnt];
        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
        
        for (int i = 0; i < cnt; i++) {
            resultUpload[i] = "false";
            sGUID[i] = UUID.randomUUID().toString();
            pUploadSN[i] = "{" + sGUID[i] + "}";
        }
        
        int maxSize = 0;
        String pBoardID = "";
        String pMode = "";
        maxSize = Integer.parseInt(request.getParameter("maxSize"));
        pBoardID = request.getParameter("boardID");
        pMode = request.getParameter("mode");

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
            pFileName[i] = pFileName[i].replace("+", "%2b");
            pFileName[i] = pFileName[i].replace(";", "%3b");
        }

        String pDirPath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
        pDirPath = realPath + pDirPath;
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        File file = new File(pDirPath);
        File file2 = new File(pDirPath + pBoardID + commonUtil.separator + "uploadFile");
        
        if (!file.exists()) {
        	file.mkdirs();
        	file2.mkdirs();
        }

        for (int i = 0; i < cnt; i++) {
        	fileSize[i] = multiFile.get(i).getSize();

            if (fileSize[i] > maxSize) {
                resultUpload[i] = "overflow";
            } else {
                if (pMode.equals("ATT")) {
                    if (useExtension.toLowerCase().indexOf(pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1).toString().toLowerCase()) == -1 && !useExtension.equals("*")) {
                        resultUpload[i] = "denied";
                    } else {
                        String pAttachPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId()) + commonUtil.separator;
                        File fTemp = new File(pAttachPath);
                        
                        if (!file.exists()) {
                        	fTemp.mkdirs();
                        }
                        writeUploadedFile(multiFile.get(i), pUploadSN[i] + "_" + pFileName[i], pAttachPath);
                        fileLocation[i] = pAttachPath + pUploadSN[i] + "_" + pFileName[i];
                        resultUpload[i] = "true";
                    }
                }
            }
        }
        
        StringBuffer strXML = new StringBuffer();

        strXML.append("<ROOT><NODES>");
        for (int i = 0; i < cnt; i++) {
            if (pMode.equals("PHOTO")) {
                strXML.append("<NODE><PUPLOADSN><![CDATA[" + pUploadSN[i] + pFileName[i].substring(pFileName[i].lastIndexOf('.')) + "]]></PUPLOADSN>");
            } else {
                strXML.append("<NODE><PUPLOADSN><![CDATA[" + pUploadSN[i] + "_" + pFileName[i] + "]]></PUPLOADSN>");
            }
            strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>");
            strXML.append("<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>");
            strXML.append("<FILESIZE>" + fileSize[i] + "</FILESIZE>");
            strXML.append("<FILELOCATION><![CDATA[" + fileLocation[i] + "]]></FILELOCATION>");
            strXML.append("</NODE>");
        }
        strXML.append("</NODES></ROOT>");
        
        return strXML.toString();
    }
	
	/**
	 * 게시판 게시물첨부(IE9) 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/itemAttachFile.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String itemAttachFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String returnVal = "";
		String guid = "";
		String fileTitle = "";
		String ext = "";
		String prefix = "";
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		if (request.getParameter("guid") != null) {
			guid = request.getParameter("guid");
		}
		if (request.getParameter("name") != null) {
			fileTitle = request.getParameter("name");
		}
		if (request.getParameter("ext") != null) {
			ext = request.getParameter("ext");
		}
		if (request.getParameter("prefix") != null) {
			prefix = request.getParameter("prefix");
		}
		
		String boardID = prefix;
		String uploadSN = "{" + guid + "}";
		String fileName = fileTitle + "." + ext;
		
		if (request.getParameter("filename") != null) {
			fileName = request.getParameter("filename");
		}
		
		fileName = fileName.replace("+", "%2b");
        fileName = fileName.replace(";", "%3b");
        fileName = fileName.replace("~", "%7e");
        fileName = fileName.replace("=", "%3d");
        
        String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator;
        
        if (useExtension.toLowerCase().indexOf(fileName.substring(fileName.lastIndexOf(".") + 1).toString().toLowerCase()) == -1 && !useExtension.equals("*")) {
        	returnVal = "denied";
        } else {
        	if (!new File(dirPath + "tempUploadFile").exists()) {
        		new File(dirPath + "tempUploadFile").mkdirs();
        	}
        	
        	if (!new File(dirPath + boardID).exists()) {
        		new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
        		new File(dirPath + boardID + commonUtil.separator + "doc").mkdirs();
        	} else if (!new File(dirPath + boardID + commonUtil.separator + "uploadFile").exists()) {
        		new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
        	}
        	
        	String attachPath = dirPath + "tempUploadFile" + commonUtil.separator + uploadSN + "_" + fileName;
        	
            InputStream stream = null;
            OutputStream bos = null;         
            
            try {
                stream = request.getInputStream();
                bos = new FileOutputStream(attachPath);
//                long fileSize = 0;
                int bytesRead = 0;
                byte[] buffer = new byte[BUFF_SIZE];
        
                while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
                    bos.write(buffer, 0, bytesRead);
//                    fileSize += bytesRead;
                }
            } catch (Exception e) {
                throw e;                
            } finally {
                if (bos != null) {
                    try {
                        bos.close();
                    } catch (Exception ignore) {
                    }
                }
                if (stream != null) {
                    try {
                        stream.close();
                    } catch (Exception ignore) {
                    }
                }
            }
            returnVal = "OK_" + uploadSN + "_" + fileName;
        }
        
		return returnVal;
	}
	
	/**
	 * 포토게시판 게시물첨부(IE9) 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/itemAttachFilePhoto.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String itemAttachFilePhoto(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String returnVal = "";
		String guid = "";
		String fileTitle = "";
		String ext = "";
		String prefix = "";
		
		if (request.getParameter("guid") != null) {
			guid = request.getParameter("guid");
		}
		if (request.getParameter("name") != null) {
			fileTitle = request.getParameter("name");
		}
		if (request.getParameter("ext") != null) {
			ext = request.getParameter("ext");
		}
		if (request.getParameter("prefix") != null) {
			prefix = request.getParameter("prefix");
		}
		
		String boardID = prefix;
		String uploadSN = "{" + guid + "}";
		String fileName = fileTitle + "." + ext;
		
		fileName = fileName.replace("+", "%2b");
		fileName = fileName.replace(";", "%3b");
		fileName = fileName.replace("~", "%7e");
		fileName = fileName.replace("=", "%3d");
		
		String fileExt = "";
		
		if (fileName.length() > 4) {
			fileExt = fileName.substring(fileName.length() - 4).toLowerCase();
		}
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		if (!new File(dirPath + "tempUploadFile").exists()) {
			new File(dirPath + "tempUploadFile").mkdirs();
		}
		
		if (!new File(dirPath + boardID).exists()) {
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
			new File(dirPath + boardID + commonUtil.separator + "doc").mkdirs();
		} else if (!new File(dirPath + boardID + commonUtil.separator + "uploadFile").exists()) {
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
		}
		
		String attachPath = dirPath + "tempUploadFile" + commonUtil.separator + uploadSN + "." + ext;
		String mapPath = dirPath + "tempUploadFile" + commonUtil.separator;
		
		InputStream stream = null;
		OutputStream bos = null;         
		
		try {
			stream = request.getInputStream();
			bos = new FileOutputStream(attachPath);
//			long fileSize = 0;
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
//				fileSize += bytesRead;
			}
		} catch (Exception e) {
			throw e;                
		} finally {
			if (bos != null) {
				try {
					bos.close();
				} catch (Exception ignore) {
				}
			}
			if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
				}
			}
		}
		
		File imageFile = new File(attachPath);	
		
		int nImgWidth = 0;
		int nImgHeight = 0;
		
		if (imageFile.exists()) {			
			BufferedImage bi = ImageIO.read(imageFile);			    
			nImgWidth = bi.getWidth();
			nImgHeight = bi.getHeight();
			int nWidth = 0, nHeight = 0;
			
            if (nImgWidth > nImgHeight) {
                nWidth = 200;
                nHeight = (bi.getHeight() * nWidth) / bi.getWidth();
            } else {
                nHeight = 200;
                nWidth = (bi.getWidth() * nHeight) / bi.getHeight();
            }
            
            BufferedImage bufferedImage = new BufferedImage(nWidth, nHeight, bi.getType());
            bufferedImage.createGraphics().drawImage(bi, 0, 0, nWidth, nHeight, null);
            ImageIO.write(bufferedImage, ext, new File(mapPath + "s_" + uploadSN + fileExt));
		}
		
		returnVal = "OK_" + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId()) + commonUtil.separator + uploadSN + fileExt;
		
		return returnVal;
	}
	
	/**
	 * 게시판 첨부파일가져오기 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getItemAttachments.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String getItemAttachments(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pItemID = "";
        String pTitle = "";
        String pConLocation = "";
        String pMode = "";
        String realPath = commonUtil.getRealPath(request);
        
        pItemID = request.getParameter("itemID");
        pTitle = request.getParameter("title");
        pConLocation = request.getParameter("conLocation");
        pMode = request.getParameter("mode");
        
        String strXML = "";

        if (pMode != null && (pMode.equals("boardContent") || pMode.equals("boardAttach"))) {
        	strXML = getItemAttachmentXML_Retrans(pItemID, realPath, pMode, pConLocation, pTitle, userInfo.getTenantId());
        } else {
        	strXML = getItemAttachmentXML(pItemID, userInfo.getTenantId());
        }
        
        return strXML;
	}

	/**
	 * 게시판 재전송관련 표출 Method
	 * @param tenantID 
	 */
	public String getItemAttachmentXML_Retrans(String pItemID, String filePath, String pMode, String pConLocation, String pTitle, int tenantID) throws Exception{
		List<BoardAttachVO> boardAttachVOList = ezBoardService.brdGetItemAttachmentInfo(pItemID, tenantID);
		
		StringBuilder resultXML = new StringBuilder();
		resultXML.append("<NODES>");
		
		if (pMode.equals("boardAttach")) {
            File file = new File(filePath + commonUtil.separator + pConLocation);
            String fileExtension = pConLocation.substring(pConLocation.lastIndexOf("."));
            String newFilePath = "tempUploadFile" + commonUtil.separator + "{" + UUID.randomUUID() + "}_" + pTitle + fileExtension;
            File fileMove = new File(filePath + commonUtil.getUploadPath("upload_board.ROOT", tenantID) + commonUtil.separator + newFilePath);
            FileUtils.copyFile(file, fileMove);
            
            long mhtSize = file.length();

            resultXML.append("<NODE>");
            resultXML.append("<ItemID>" + pItemID + "</ItemID>");
            resultXML.append("<FileName>" + pTitle + fileExtension + "</FileName>");
            resultXML.append("<FilePath>" + commonUtil.cleanValue(newFilePath) + "</FilePath>");
            resultXML.append("<FileSize>" + getProperSizeDisplay(String.valueOf(mhtSize)) + "</FileSize>");
            resultXML.append("<FileSize2>" + mhtSize + "</FileSize2>");
            resultXML.append("</NODE>");
        }

        for (int i = 0; i < boardAttachVOList.size(); i++) {
            String pFilePath = boardAttachVOList.get(i).getFilePath();
            String newFilePath = pFilePath.split("/")[pFilePath.split("/").length - 1];
            
            newFilePath = "tempUploadFile" +commonUtil.separator+ "{" + UUID.randomUUID() + "}" + newFilePath.substring(newFilePath.indexOf("_"), newFilePath.length());

            File file = new File(filePath + commonUtil.separator + pFilePath);
            File fileMove = new File(filePath + commonUtil.getUploadPath("upload_board.ROOT", tenantID) + commonUtil.separator + newFilePath);
            FileUtils.copyFile(file, fileMove);
            
            resultXML.append("<NODE>");
            resultXML.append("<ItemID>" + boardAttachVOList.get(i).getItemID() + "</ItemID>");
            resultXML.append("<FileName>" + boardAttachVOList.get(i).getFileName() + "</FileName>");
            resultXML.append("<FilePath>" + commonUtil.cleanValue(newFilePath) + "</FilePath>");
            resultXML.append("<FileSize>" + getProperSizeDisplay(boardAttachVOList.get(i).getFileSize()) + "</FileSize>");
            resultXML.append("<FileSize2>" + boardAttachVOList.get(i).getFileSize() + "</FileSize2>");
            resultXML.append("</NODE>");
        }
        resultXML.append("</NODES>");
        
        return resultXML.toString();
	}

	/**
	 * 게시판 첨부파일관련 표출 Method
	 * @param tenantID 
	 */
	public String getItemAttachmentXML(String pItemID, int tenantID) throws Exception{
		List<BoardAttachVO> boardAttachVOList = ezBoardService.brdGetItemAttachmentInfo(pItemID, tenantID);
		
		StringBuilder resultXML = new StringBuilder();
		resultXML.append("<NODES>");
		
		for (int i = 0; i < boardAttachVOList.size(); i++) {
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + boardAttachVOList.get(i).getItemID() + "</ItemID>");
			resultXML.append("<GUID>" + boardAttachVOList.get(i).getGuid().trim() + "</GUID>");
			resultXML.append("<FilePath>" + boardAttachVOList.get(i).getFilePath() + "</FilePath>");
			resultXML.append("<FileName>" + boardAttachVOList.get(i).getFileName() + "</FileName>");
			resultXML.append("<FileSize>" + getProperSizeDisplay(boardAttachVOList.get(i).getFileSize()) + "</FileSize>");
			resultXML.append("<FileSize2>" + boardAttachVOList.get(i).getFileSize() + "</FileSize2>");
			resultXML.append("</NODE>");
		}
		resultXML.append("</NODES>");
		
		return resultXML.toString();
	}
	
	/**
	 * 게시판 사용자가 보기에 편리한 형태로 파일 사이즈를 변환해 주는 Method
	 */
	public String getProperSizeDisplay(String pSize) throws Exception{
	    if (Integer.parseInt(pSize) > 1048576) {
	    	return Math.round((Integer.parseInt(pSize) / 1024 / 102.4) / 10) + " MB";
	    } else if (Integer.parseInt(pSize) > 1024) {
	    	return Math.round((Integer.parseInt(pSize) / 102.4) / 10) + " KB";
	    } else {
	    	return pSize + " Byte";
	    }
	}
	
	/**
	 * 게시판 첨부파일다운 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/boardAttachDown.do")
	public void boardAttachDown(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
		String attID = request.getParameter("attID");
		String realPath = commonUtil.getRealPath(request);
		
		if (attID != null && !attID.equals("")) {
			downFile(request, response, realPath + filePath, attID);
		} else {
			downFile(request, response, realPath + filePath, fileName);
		}
	}
	
	/**
	 * 게시판 게시물답변여부 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/checkIfHasReply.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String checkIfHasReply(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemList = "";
		String result = ""; 
		itemList = request.getParameter("itemList");
		
		for (int i = 0; i < itemList.split(";").length; i++) {
			String tempItemID = itemList.split(";")[i].split(",")[0];
			
			result = ezBoardService.brdCheckIfHasReply(tempItemID, userInfo.getTenantId());
			
			if (result.equals("TRUE")) {
				break;
			}
		}
		
		return result;
	}
	
	/**
	 * 게시판 게시물삭제 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/deleteItem.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String deleteItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "";
		String itemList = "";
		String boardID = "";
		String realPath = commonUtil.getRealPath(request);
		
		itemList = request.getParameter("itemList");
		mode = request.getParameter("mode");
		boardID = request.getParameter("boardID");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		String result = ezBoardService.deleteItem(itemList, mode, boardID, realPath, userInfo, boardInfo);
		
		return result;
	}
	
	/**
	 * 게시판 게시물복사 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/copyBoardItem.do")
	public String copyBoardItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		String itemIDList = "";
		String boardIDs = "";
		
		userInfo = commonUtil.userInfo(loginCookie);
		itemIDList = request.getParameter("itemIDList");
		boardIDs = request.getParameter("boardID");
		
		String[] boardID = boardIDs.split(";");
		
		for (int k = 0; k < boardID.length - 1; k++) {
			BoardPropertyVO boardInfo = getBoardInfo(boardID[k], userInfo);
			
			if (!boardInfo.getRead_FG().equals("true")) {
				return "main/warning";
			}
			
			if (!boardInfo.getBoardAdmin_FG().equals("true")) {
				if (!boardInfo.getBoardGroupAdmin_FG().equals("true")) {
					return "main/warning";
				}
			}
		}
		
		model.addAttribute("itemIDList", itemIDList);
		model.addAttribute("boardID", boardIDs);
		
		return "ezBoard/boardCopyItem";
	}
	
	/**
	 * 게시판 게시판권한 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getACL.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getACL(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String strACLXML = "";
		String userDeptPath = userInfo.getDeptPathCode() + ",everyone";
		
		if (ezBoardAdminService.checkIfBoardGroupAdmin(boardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId()).equals("OK")) {
			strACLXML = "<NODES><NODE><ACCESS>1</ACCESS><BOARDADMIN>true</BOARDADMIN><LIST>true</LIST><READ>true</READ><WRITE>true</WRITE><REPLY>true</REPLY><DELETE>true</DELETE><INHERIT>false</INHERIT><POSTNOTICE></POSTNOTICE></NODE></NODES>";
		} else if (userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1) {
			strACLXML = "<NODES><NODE><ACCESS>1</ACCESS><BOARDADMIN>true</BOARDADMIN><LIST>true</LIST><READ>true</READ><WRITE>true</WRITE><REPLY>true</REPLY><DELETE>true</DELETE><INHERIT>false</INHERIT><POSTNOTICE></POSTNOTICE></NODE></NODES>";
		} else {
			BoardPropertyVO boardPropertyVO = null;
			
			for (int k = 0; k < userDeptPath.split(",").length; k++) {
				boardPropertyVO = ezBoardAdminService.getACL(boardID, userDeptPath.split(",")[k], userInfo.getTenantId());
				
				if (boardPropertyVO != null) {
					break;
				}
			}
			StringBuilder sb = new StringBuilder();
			sb.append("<NODES>");
			
			if (boardPropertyVO != null) {
				sb.append("<NODE>");
				sb.append("<ACCESS>" + boardPropertyVO.getAccess_() + "</ACCESS>");
				sb.append("<BOARDADMIN>" + boardPropertyVO.getBoardAdmin_FG() + "</BOARDADMIN>");
				sb.append("<LIST>" + boardPropertyVO.getListView_FG() + "</LIST>");
				sb.append("<READ>" + boardPropertyVO.getRead_FG() + "</READ>");
				sb.append("<WRITE>" + boardPropertyVO.getWrite_FG() + "</WRITE>");
				sb.append("<REPLY>" + boardPropertyVO.getReply_FG() + "</REPLY>");
				sb.append("<DELETE>" + boardPropertyVO.getDelete_FG() + "</DELETE>");
				sb.append("<INHERIT>" + boardPropertyVO.getInherit_FG() + "</INHERIT>");
				sb.append("<POSTNOTICE>" + boardPropertyVO.getPostNotice() + "</POSTNOTICE>");
				sb.append("</NODE>");			
			}	
			sb.append("</NODES>");
			
			strACLXML = sb.toString();
		}
		
		return strACLXML;
	}
	
	/**
	 * 게시판 익명게시판여부 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/checkIfAnonyBoard.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String checkIfAnonyBoard(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		String result = "";
		String boardID = "";
		
		boardID = request.getParameter("boardID");
		userInfo = commonUtil.userInfo(loginCookie);
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (boardInfo.getGuBun() != null && boardInfo.getUrl() != null && (boardInfo.getGuBun().equals("2") || !boardInfo.getUrl().trim().equals("") || boardInfo.getGuBun().equals("3") || boardInfo.getGuBun().equals("4"))) {
			result = "<RESULT>anonyboard</RESULT>";
        } else if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
        	result = "<RESULT>attributeextension</RESULT>";
        } else {
            result = "<RESULT>normalboard</RESULT>";
        }
		
		return result;
	}
	
	/**
	 * 게시판 게시물복사 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/copyItem.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String boardCopyItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String orgItemIDList = "";
		String orgBoardID = "";
		String destBoardID = "";
		String uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String result = "";
		
		orgItemIDList = request.getParameter("orgItemIDList");
		orgBoardID = request.getParameter("orgBoardID");
		destBoardID = request.getParameter("destBoardID");
		
		for (int i = 0; i < orgItemIDList.split(";").length; i++) {
			result = copyItem(orgItemIDList.split(";")[i], orgBoardID, "{"+ UUID.randomUUID() +"}", destBoardID, uploadFilePath, realPath, userInfo);
		}
		
		return "<RESULT>" + result + "</RESULT>";
	}

	/**
	 * 게시판 게시물복사 실행 Method
	 */
	public String copyItem(String orgItemID, String orgBoardID, String destItemID, String destBoardID, String uploadFilePath, String realPath, LoginVO userInfo) throws Exception{
		String result = "";
		BoardListVO boardLisitVO = ezBoardService.getCopyItem(orgItemID, orgBoardID, userInfo.getTenantId());
		//MHT 파일위치 변경
		boardLisitVO.setContentLocation(boardLisitVO.getContentLocation().replace(orgBoardID, destBoardID).replace(orgItemID, destItemID));
		boardLisitVO.setStartDate("");
		boardLisitVO.setItemLevel("1");
		
		if (boardLisitVO.getExtensionAttribute1() == null) {
			boardLisitVO.setExtensionAttribute1("0");
		}
		
		if (boardLisitVO.getExtensionAttribute2() == null) {
			boardLisitVO.setExtensionAttribute2("0");
		}
		
		if (boardLisitVO.getExtensionAttribute3() == null) {
			boardLisitVO.setExtensionAttribute3("0");
		}
		
		if (boardLisitVO.getExtensionAttribute32() == null) {
			boardLisitVO.setExtensionAttribute32("0");
		}
		
		if (boardLisitVO.getExtensionAttribute4() == null) {
			boardLisitVO.setExtensionAttribute4("0");
		}
		
		if (boardLisitVO.getExtensionAttribute5() == null) {
			boardLisitVO.setExtensionAttribute5("0");
		}
		copyFiles(orgItemID, orgBoardID, destItemID, destBoardID, realPath + uploadFilePath, "copy");
		
		List<String> attachmentList = ezBoardService.getCopyItemAttach(orgItemID, userInfo.getTenantId());
		String attachments = "";
		
		if (attachmentList != null) {
			attachments = copyAttachments(orgBoardID, destItemID, destBoardID, attachmentList, realPath + uploadFilePath, "copy", userInfo.getTenantId());
		}
		
		StringBuilder sb = new StringBuilder();

        sb.append("<NODES>");
        sb.append("<NODE>");
        sb.append("<FILEPATH>" + uploadFilePath + "</FILEPATH>");
        sb.append("<ITEMID>" + destItemID + "</ITEMID>");
        sb.append("<BOARDID>" + destBoardID + "</BOARDID>");
        sb.append("<TOPWRITERID>" + boardLisitVO.getTopWriterID() + "</TOPWRITERID>");
        sb.append("<WRITERID>" + boardLisitVO.getWriterID() + "</WRITERID>");
        sb.append("<WRITERNAME>" + commonUtil.cleanValue(boardLisitVO.getWriterName()) + "</WRITERNAME>");
        sb.append("<WRITERNAME2>" + commonUtil.cleanValue(boardLisitVO.getWriterName2()) + "</WRITERNAME2>");
        sb.append("<DEPTID>" + boardLisitVO.getWriterDeptID() + "</DEPTID>");
        sb.append("<DEPTNAME>" + commonUtil.cleanValue(boardLisitVO.getWriterDeptName()) + "</DEPTNAME>");	
        sb.append("<DEPTNAME2>" + commonUtil.cleanValue(boardLisitVO.getWriterDeptName2()) + "</DEPTNAME2>");
        sb.append("<COMPANYID>" + boardLisitVO.getWriterCompanyID() + "</COMPANYID>");
        sb.append("<COMPANYNAME>" + commonUtil.cleanValue(boardLisitVO.getWriterCompanyName()) + "</COMPANYNAME>");
        sb.append("<COMPANYNAME2>" + commonUtil.cleanValue(boardLisitVO.getWriterCompanyName2()) + "</COMPANYNAME2>");
        sb.append("<IMPORTANCE>" + boardLisitVO.getImportance() + "</IMPORTANCE>");
        sb.append("<TITLE>" + commonUtil.cleanValue(boardLisitVO.getTitle()) + "</TITLE>");
        sb.append("<CONTENTLOCATION>" + boardLisitVO.getContentLocation() + "</CONTENTLOCATION>");
        sb.append("<STARTDATE>" + commonUtil.getDateStringInUTC(boardLisitVO.getStartDate(), userInfo.getOffset(), false) + "</STARTDATE>");
        sb.append("<ENDDATE>" + commonUtil.getDateStringInUTC(boardLisitVO.getEndDate(), userInfo.getOffset(), false) + "</ENDDATE>");
        sb.append("<ABSTRACT>" + commonUtil.cleanValue(boardLisitVO.getABSTRACT()) + "</ABSTRACT>");
        sb.append("<ATTACHMENTS>" + commonUtil.cleanValue(attachments) + "</ATTACHMENTS>");
        sb.append("<UPPERITEMIDTREE>" + destItemID + "</UPPERITEMIDTREE>");
        sb.append("<ITEMLEVEL>1</ITEMLEVEL>");
        sb.append("<EXTENSIONATTRIBUTE1>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute1()) + "</EXTENSIONATTRIBUTE1>");
        sb.append("<EXTENSIONATTRIBUTE2>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute2()) + "</EXTENSIONATTRIBUTE2>");
        sb.append("<EXTENSIONATTRIBUTE3>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute3()) + "</EXTENSIONATTRIBUTE3>");
        sb.append("<EXTENSIONATTRIBUTE32>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute32()) + "</EXTENSIONATTRIBUTE32>");
        sb.append("<EXTENSIONATTRIBUTE4>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute4()) + "</EXTENSIONATTRIBUTE4>");
        sb.append("<EXTENSIONATTRIBUTE5>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute5()) + "</EXTENSIONATTRIBUTE5>");
        sb.append("<DOCPASSWORD></DOCPASSWORD>");
        sb.append("<READCOUNTFLAG>N</READCOUNTFLAG>");
        sb.append("</NODE>");
        sb.append("</NODES>");

        result = insertNewItem(commonUtil.convertStringToDocument(sb.toString()), "copy", realPath, userInfo);
        
        if (result.equals("OK")) {
        	ezBoardService.updateCopyItem(destItemID, userInfo.getTenantId());
        }
        
		return result;
	}

	/**
	 * 게시판 첨부복사 표출 Method
	 * @param tenantID 
	 */
	public String copyAttachments(String orgBoardID, String destItemID, String destBoardID, List<String> attachmentList, String path, String mode, int tenantID) throws Exception{
		String orgFilePath = "";
		String destFilePath = "";
		String returnString = "";
		
        for (int i = 0; i < attachmentList.size(); i++) {
            orgFilePath = attachmentList.get(i);
            orgFilePath = path.replace(commonUtil.getUploadPath("upload_board.ROOT", tenantID), "") + orgFilePath;
            
            String fileName = "";
            fileName = attachmentList.get(i).substring(attachmentList.get(i).lastIndexOf(commonUtil.separator + "uploadFile" + commonUtil.separator) + 12).substring(39);
            fileName = "{" + UUID.randomUUID() + "}_" + fileName;

            destFilePath = path + commonUtil.separator + destBoardID + commonUtil.separator + "uploadFile" + commonUtil.separator + fileName;

            if (returnString.equals("")) {
            	returnString += destBoardID + commonUtil.separator + "uploadFile" + commonUtil.separator + fileName;
            } else {
            	returnString = returnString + ";" + destBoardID + commonUtil.separator + "uploadFile" + commonUtil.separator + fileName;
            }
            //move 이면 지우고 옮기기
            if (mode.equals("copy")) {
            	FileUtils.copyFile(new File(orgFilePath), new File(destFilePath));
            } else {
            	FileUtils.moveFile(new File(orgFilePath), new File(destFilePath));
            }
        }
        
        return returnString;
	}

	/**
	 * 게시판 파일복사 실행 Method
	 */
	public void copyFiles(String orgItemID, String orgBoardID, String destItemID, String destBoardID, String path, String mode) throws Exception{
		String orgFilePath = "";
        String destFilePath = "";

        orgFilePath = path + commonUtil.separator + orgBoardID + commonUtil.separator + "doc" + commonUtil.separator + orgItemID + ".mht";
        destFilePath = path + commonUtil.separator + destBoardID + commonUtil.separator + "doc" + commonUtil.separator + destItemID + ".mht";

        File file = new File(path + commonUtil.separator + destBoardID);
        
        if (!file.exists()) {
            file.mkdir();
            new File(path + commonUtil.separator + destBoardID + commonUtil.separator + "doc").mkdir();
            new File(path + commonUtil.separator + destBoardID + commonUtil.separator + "uploadFile").mkdir();
        }
        //move 이면 지우고 옮기기
        if (mode.equals("copy")) {
        	FileUtils.copyFile(new File(orgFilePath), new File(destFilePath));
        } else {
        	FileUtils.moveFile(new File(orgFilePath), new File(destFilePath));
        }
	}
	
	/**
	 * 게시판 게시물이동 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/moveBoardItem.do")
	public String moveBoardItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String itemIDList = request.getParameter("itemIDList");
		
		String boardID = request.getParameter("boardID");
		
		model.addAttribute("itemIDList", itemIDList);
		model.addAttribute("boardID", boardID);
		model.addAttribute("userInfo", userInfo);
		
		return "ezBoard/boardMoveItem";
	}
	
	/**
	 * 게시판 게시물이동 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/moveItem.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String boardMoveItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String orgItemIDList = "";
		String orgBoardID = "";
		String destBoardID = "";
		String uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String result = "";
		
		orgItemIDList = request.getParameter("orgItemIDList");
		orgBoardID = request.getParameter("orgBoardID");
		destBoardID = request.getParameter("destBoardID");
		
		for (int i = 0; i < orgItemIDList.split(";").length; i++) {
			result = moveItem(orgItemIDList.split(";")[i], orgBoardID, "{"+ UUID.randomUUID() +"}", destBoardID, uploadFilePath, realPath, userInfo);
		}
		
		return "<RESULT>" + result + "</RESULT>";
	}

	/**
	 * 게시판 게시물이동 실행 표출 Method
	 */
	public String moveItem(String orgItemID, String orgBoardID, String destItemID, String destBoardID, String uploadFilePath, String realPath, LoginVO userInfo) throws Exception{
		String result = "";
		BoardListVO boardLisitVO = ezBoardService.getCopyItem(orgItemID, orgBoardID, userInfo.getTenantId());
		//MHT 파일위치 변경
		boardLisitVO.setContentLocation(boardLisitVO.getContentLocation().replace(orgBoardID, destBoardID).replace(orgItemID, destItemID));
		boardLisitVO.setStartDate("");
		boardLisitVO.setItemLevel("1");
		
		if (boardLisitVO.getExtensionAttribute1() == null) {
			boardLisitVO.setExtensionAttribute1("0");
		}
		
		if (boardLisitVO.getExtensionAttribute2() == null) {
			boardLisitVO.setExtensionAttribute2("0");
		}
		
		if (boardLisitVO.getExtensionAttribute3() == null) {
			boardLisitVO.setExtensionAttribute3("0");
		}
		
		if (boardLisitVO.getExtensionAttribute32() == null) {
			boardLisitVO.setExtensionAttribute32("0");
		}
		
		if (boardLisitVO.getExtensionAttribute4() == null) {
			boardLisitVO.setExtensionAttribute4("0");
		}
		
		if (boardLisitVO.getExtensionAttribute5() == null) {
			boardLisitVO.setExtensionAttribute5("0");
		}
		copyFiles(orgItemID, orgBoardID, destItemID, destBoardID, realPath + uploadFilePath, "move");
		
		List<String> attachmentList = ezBoardService.getCopyItemAttach(orgItemID, userInfo.getTenantId());
		String attachments = "";
		
		if (attachmentList != null) {
			attachments = copyAttachments(orgBoardID, destItemID, destBoardID, attachmentList, realPath + uploadFilePath, "move", userInfo.getTenantId());
		}
		
		StringBuilder sb = new StringBuilder();

        sb.append("<NODES>");
        sb.append("<NODE>");
        sb.append("<FILEPATH>" + uploadFilePath + "</FILEPATH>");
        sb.append("<ITEMID>" + destItemID + "</ITEMID>");
        sb.append("<BOARDID>" + destBoardID + "</BOARDID>");
        sb.append("<TOPWRITERID>" + boardLisitVO.getTopWriterID() + "</TOPWRITERID>");
        sb.append("<WRITERID>" + boardLisitVO.getWriterID() + "</WRITERID>");
        sb.append("<WRITERNAME>" + commonUtil.cleanValue(boardLisitVO.getWriterName()) + "</WRITERNAME>");
        sb.append("<WRITERNAME2>" + commonUtil.cleanValue(boardLisitVO.getWriterName2()) + "</WRITERNAME2>");
        sb.append("<DEPTID>" + boardLisitVO.getWriterDeptID() + "</DEPTID>");
        sb.append("<DEPTNAME>" + commonUtil.cleanValue(boardLisitVO.getWriterDeptName()) + "</DEPTNAME>");	
        sb.append("<DEPTNAME2>" + commonUtil.cleanValue(boardLisitVO.getWriterDeptName2()) + "</DEPTNAME2>");
        sb.append("<COMPANYID>" + boardLisitVO.getWriterCompanyID() + "</COMPANYID>");
        sb.append("<COMPANYNAME>" + commonUtil.cleanValue(boardLisitVO.getWriterCompanyName()) + "</COMPANYNAME>");	
        sb.append("<COMPANYNAME2>" + commonUtil.cleanValue(boardLisitVO.getWriterCompanyName2()) + "</COMPANYNAME2>");
        sb.append("<IMPORTANCE>" + boardLisitVO.getImportance() + "</IMPORTANCE>");
        sb.append("<TITLE>" + commonUtil.cleanValue(boardLisitVO.getTitle()) + "</TITLE>");
        sb.append("<CONTENTLOCATION>" + boardLisitVO.getContentLocation() + "</CONTENTLOCATION>");
        sb.append("<STARTDATE>" + commonUtil.getDateStringInUTC(boardLisitVO.getStartDate(), userInfo.getOffset(), false) + "</STARTDATE>");
        sb.append("<ENDDATE>" + commonUtil.getDateStringInUTC(boardLisitVO.getEndDate(), userInfo.getOffset(), false) + "</ENDDATE>");
        sb.append("<ABSTRACT>" + commonUtil.cleanValue(boardLisitVO.getABSTRACT()) + "</ABSTRACT>");
        sb.append("<ATTACHMENTS>" + commonUtil.cleanValue(attachments) + "</ATTACHMENTS>");
        sb.append("<UPPERITEMIDTREE>" + boardLisitVO.getUpperItemIDTree() + "</UPPERITEMIDTREE>");
        sb.append("<ITEMLEVEL>" + boardLisitVO.getItemLevel() + "</ITEMLEVEL>");
        sb.append("<EXTENSIONATTRIBUTE1>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute1()) + "</EXTENSIONATTRIBUTE1>");
        sb.append("<EXTENSIONATTRIBUTE2>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute2()) + "</EXTENSIONATTRIBUTE2>");
        sb.append("<EXTENSIONATTRIBUTE3>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute3()) + "</EXTENSIONATTRIBUTE3>");
        sb.append("<EXTENSIONATTRIBUTE32>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute32()) + "</EXTENSIONATTRIBUTE32>");
        sb.append("<EXTENSIONATTRIBUTE4>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute4()) + "</EXTENSIONATTRIBUTE4>");
        sb.append("<EXTENSIONATTRIBUTE5>" + commonUtil.cleanValue(boardLisitVO.getExtensionAttribute5()) + "</EXTENSIONATTRIBUTE5>");
        sb.append("<DOCPASSWORD></DOCPASSWORD>");
        sb.append("<READCOUNTFLAG>N</READCOUNTFLAG>");
        sb.append("</NODE>");
        sb.append("</NODES>");

        result = insertNewItem(commonUtil.convertStringToDocument(sb.toString()), "copy", realPath, userInfo);
        
        if (result.equals("OK")) {
        	ezBoardService.updateMoveItem(destItemID, orgItemID, userInfo.getTenantId());
        }
        
		return result;
	}
	
	/**
	 * 게시판 나의게시판추가 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/addToMyBoards.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String addToMyBoards(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String result = ezBoardAdminService.addMyBoards(userInfo.getId(), boardID, userInfo.getTenantId());
		
		return "<RESULT>" + result + "</RESULT>";
	}
	
	/**
	 * 게시판 나의게시판설정 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/myBoardConfig.do")
	public String myBoardConfig(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		String boardID = request.getParameter("boardID");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		model.addAttribute("type", type);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardInfo", boardInfo);
		
		return "ezBoard/boardMyBoardConfig";
	}
	
	/**
	 * 게시판 이름적는창 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/inputNameDlg.do")
	public String inputNameDlg() {
		return "ezBoard/boardInputNameDlg";
	}
	
	/**
	 * 게시판 나의게시판설정 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/setMyBoardsConfig.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String setMyBoardsConfig(@RequestBody String xmlPara, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		userInfo = commonUtil.userInfo(loginCookie);
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		boardMyFavoriteVO.setUserId(userInfo.getId());
		boardMyFavoriteVO.setTreeId(doc.getElementsByTagName("PTREEID").item(0).getTextContent());
		boardMyFavoriteVO.setTreeName(doc.getElementsByTagName("PTREENAME").item(0).getTextContent());
		boardMyFavoriteVO.setTreeName2(doc.getElementsByTagName("PTREENAME2").item(0).getTextContent());
		boardMyFavoriteVO.setTreeUpper(doc.getElementsByTagName("PUPPERID").item(0).getTextContent());
		boardMyFavoriteVO.setMode(doc.getElementsByTagName("PMODE").item(0).getTextContent());
		boardMyFavoriteVO.setBoardId(doc.getElementsByTagName("PBOARDID").item(0).getTextContent());
		boardMyFavoriteVO.setTenantID(userInfo.getTenantId());
		
		String retValue = ezBoardAdminService.setMyBoardTreeConfig(boardMyFavoriteVO);
		
		return "<RESULT>" + retValue + "</RESULT>";
	}
	
	/**
	 * 게시판 나의게시판 이동 복사 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/myBoardmovecopy.do")
	public String myBoardmovecopy(Model model, HttpServletRequest request) {
		String selID = request.getParameter("selID");
		
		model.addAttribute("selID", selID);
		
		return "ezBoard/boardMyBoardMoveCopy";
	}
	
	/**
	 * 게시판 나의게시판이동복사 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/setMyBoardMoveCopy.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String setMyBoardMoveCopy(@RequestBody String xmlPara, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		userInfo = commonUtil.userInfo(loginCookie);
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		boardMyFavoriteVO.setUserId(userInfo.getId());
		boardMyFavoriteVO.setSelTreeID(doc.getElementsByTagName("PSELTREEID").item(0).getTextContent());
		boardMyFavoriteVO.setMoveTreeID(doc.getElementsByTagName("PMOVETREEID").item(0).getTextContent());
		boardMyFavoriteVO.setMode(doc.getElementsByTagName("PMODE").item(0).getTextContent());
		boardMyFavoriteVO.setTenantID(userInfo.getTenantId());
		
		String result = ezBoardAdminService.setMyBoardTreeMoveCopy(boardMyFavoriteVO);
		
		return "<RESULT>" + result + "</RESULT>";
	}
	
	/**
	 * 게시판 공지순서 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardNotiOrder.do")
	public String boardNotiOrder(HttpServletRequest request, Model model) {
		String boardID = request.getParameter("boardID");
		
		model.addAttribute("boardID", boardID);
		
		return "ezBoard/boardNotiOrder";
	}
	
	/**
	 * 게시판 공지순서리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getNotiitemList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getNotiitemList(@RequestBody String boardID, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String resultXml  = ezBoardService.getNoticePostItemAll(boardID, userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(resultXml);
		NodeList nList = doc.getElementsByTagName("ROW");
		
		String result = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + egovMessageSource.getMessage("ezBoard.t208", userInfo.getLocale()) + "</NAME><WIDTH>70</WIDTH></HEADER></HEADERS><ROWS>";
		
        for (int i = nList.getLength() - 1; i >= 0; i--) {
            result += "<ROW><CELL><VALUE><![CDATA[" + commonUtil.cleanValue(doc.getElementsByTagName("TITLE").item(i).getTextContent()) + "]]></VALUE>";
            result += "<DATA1><![CDATA[" + doc.getElementsByTagName("ITEMID").item(i).getTextContent() + "]]></DATA1></CELL></ROW>";
        }
        result += "</ROWS></LISTVIEWDATA>";
        
		return result;
	}
	
	/**
	 * 게시판 공지순서저장 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/saveNotiOrder.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String saveNotiOrder(@RequestBody String itemID, @CookieValue("loginCookie") String loginCookie) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String rtnValue = ezBoardService.setNotiOrder(itemID, userInfo.getTenantId());
		
		return rtnValue;
	}
	
	/**
	 * 게시판 부모게시판아이디 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getParentBoardID.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String getParentBoardID(@RequestBody String boardID, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String parentBoardID = ezBoardService.getParentBoardID(boardID, userInfo.getTenantId());
		
		return parentBoardID;
	}
	
	/**
	 * 게시판 게시물미리보기 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemPreView.do")
	public String boardItemPreView(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String guBun = request.getParameter("guBun");
		String boardID = request.getParameter("boardID");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String extenLang = "1";
		String strNow = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
			List<BoardAttributeVO> attributeList = ezBoardAdminService.getBoardAttribute(boardID, userInfo.getTenantId());
			
			if (!commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
				extenLang = "2";
			}
			model.addAttribute("attributeList", attributeList);
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("guBun", guBun);
		model.addAttribute("boardID", boardID);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("extenLang", extenLang);
		model.addAttribute("strNow", strNow);
		
		return "ezBoard/boardItemPreView";
	}
	
	/**
	 * 게시판 게시물파일경로 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getContentInfo.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String getContentInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String type = request.getParameter("type");
		String docID = request.getParameter("docID");
		String filePath = "";
		
		filePath = ezBoardService.getContentInfo(type, docID, userInfo.getTenantId());
		
		return filePath;
	}
	
	/**
	 * 게시판 게시판재전송 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardRetransOption.do")
	public String boardRetransOption() {
		return "ezBoard/boardRetransOption";
	}
	
	/**
	 * 게시판 읽은리스트 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/itemReadList.do")
	public String itemReadList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		
		List<BoardReadVO> boardReadList = ezBoardService.getReaderList(boardID, itemID, userInfo.getId(), commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		model.addAttribute("boardReadList", boardReadList);
		model.addAttribute("offset", userInfo.getOffset());
		
		return "ezBoard/boardItemReadList";
	}
	
	/**
	 * 게시판 인쇄관련 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemViewPrintOption.do")
	public String boardItemViewPrintOption(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String btnStyle1 = "";
        String btnStyle2 = "";
        String btnStyle3 = "";
        
		if (userInfo.getLang().equals("1")) {
            btnStyle1 = "width:80px";
            btnStyle2 = "width:80px";
            btnStyle3 = "width:100px";
        } else if (userInfo.getLang().equals("2")) {
            btnStyle1 = "width:70px";
            btnStyle2 = "width:100px";
            btnStyle3 = "width:150px";
        } else if (userInfo.getLang().equals("3")) {
            btnStyle1 = "width:80px";
            btnStyle2 = "width:80px";
            btnStyle3 = "width:110px";
        } else if (userInfo.getLang().equals("4")) {
            btnStyle1 = "width:80px";
            btnStyle2 = "width:80px";
            btnStyle3 = "width:110px";
        }
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("btnStyle1", btnStyle1);
		model.addAttribute("btnStyle2", btnStyle2);
		model.addAttribute("btnStyle3", btnStyle3);
		model.addAttribute("oneLineReplyFlag", boardPropertyVO.getOneLineReply());
		
		return "ezBoard/boardItemViewPrintOption";
	}
	
	/**
	 * 게시판 게시물인쇄관련 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemViewPrint.do")
	public String boardItemViewPrint(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String reservedItem = request.getParameter("reservedItem");
		String oneLine = request.getParameter("oneLine");
		String attach = request.getParameter("attach");
		String oneLineReplyFlag = ezCommonService.getTenantConfig("ONELINE_REPLY_ENABLE", userInfo.getTenantId());
		int menuCount = 0;
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		BoardListVO boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);
		
		if (boardItem.getExtensionAttribute3() == null || boardItem.getExtensionAttribute3().equals("")) {
			boardItem.setExtensionAttribute3(" ");
		}
		
		if (boardItem.getExtensionAttribute4() == null || boardItem.getExtensionAttribute4().equals("")) {
			boardItem.setExtensionAttribute4(" ");
		}
		
		if (boardItem.getEndDate() != null && boardItem.getEndDate().substring(0, 4).equals("9999")) {
			boardItem.setEndDate(egovMessageSource.getMessage("ezBoard.t287", userInfo.getLocale()));
		}
		
		if (boardInfo.getBoardName() != null && !boardInfo.getBoardName().equals("")) {
        	boardInfo.setBoardName(commonUtil.cleanValue(boardInfo.getBoardName()));
        }
        
        if (boardInfo.getBoardName1() != null && !boardInfo.getBoardName1().equals("")) {
        	boardInfo.setBoardName1(commonUtil.cleanValue(boardInfo.getBoardName1()));
        }
        
        if (boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().equals("")) {
        	boardInfo.setBoardName2(commonUtil.cleanValue(boardInfo.getBoardName2()));
        }
		
		model.addAttribute("boardItem", boardItem);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("menuCount", menuCount);
		model.addAttribute("attach", attach);
		model.addAttribute("oneLine", oneLine);
		model.addAttribute("reservedItem", reservedItem);
		model.addAttribute("oneLineReplyFlag", oneLineReplyFlag);
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		
		return "ezBoard/boardItemViewPrint";
	}
	
	/**
	 * 게시판 익명게시판 비번체크 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/checkPassWord.do")
	public String checkPassWord(HttpServletRequest request, Model model) throws Exception{
		String replyID = request.getParameter("replyID");
		String itemID = request.getParameter("itemID");
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		model.addAttribute("replyID", replyID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("publicModulus", publicModulus);
        model.addAttribute("publicExponent", publicExponent);
        
		return "ezBoard/boardCheckPassWord";
	}
	
	/**
	 * 게시판 익명게시판 비번체크 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/confirmPassword.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String confirmPassword(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	String replyID = request.getParameter("replyID");
    	String itemID = request.getParameter("itemID");
		String newPassword = request.getParameter("newPassword");
		String oldPassword = "";
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		String rpwd = EgovFileScrty.decryptRsa(pk, newPassword);
		
		newPassword = EgovFileScrty.encryptPassword(rpwd, "unknown");
		
		if (replyID != null && !replyID.equals(""))	{
			oldPassword = ezBoardService.getOneLinePassWord(replyID, itemID, userInfo.getTenantId()).trim();
		} else {
			oldPassword = ezBoardService.getDocPassWord(itemID, userInfo.getTenantId()).trim();
		}

		if (newPassword != null && newPassword.equals(oldPassword)) {
			return "OK";
		} else {
			return "NO";
		}
	}
	
	/**
	 * 게시판 포토게시물 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemViewPhoto.do")
	public String boardItemViewPhoto(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "new";
		String apprFlag = "Y";
		String adjacentItemsEnableFlag = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
		String showAdjacent = request.getParameter("showAdjacent");
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String reservedItem = request.getParameter("pReservedItem");
		String location = request.getParameter("location");
		String useOCS = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String publicModulus = egovFileScrty.getPbm();
        String publicExponent = "10001";
        
		BoardListVO boardItem = new BoardListVO();
		BoardVO boardAdjacent = null;
		
		mode = request.getParameter("mode");
		
		if (!accessCheck(itemID, location, userInfo)) {
			return "main/warning";
		}
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (!boardInfo.getRead_FG().equals("true")) {
			return "main/warning";
		}
		if (mode == null || !mode.equals("temp")) {
			boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		} else {
			boardItem = ezBoardService.getBrdGetItemInfoTemp(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		}
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);
		
		if (boardItem == null || boardItem.getWriterID() == null || boardItem.getWriterID().equals("")) {
			return "main/error";
		}
		
		if (boardItem.getApprFlag() != null && boardItem.getApprFlag().equals("N")) {
			int checkCnt = ezBoardService.checkApprUserList(userInfo.getId(), itemID, userInfo.getTenantId());
			if (checkCnt == 0) {
				boardItem.setApprFlag("");
			}
		}
		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		String nowTime = commonUtil.getTodayUTCTime("");
		String parentTime = boardItem.getParentWriteDate();
		//TODO 확인하라
		if (parentTime.compareTo(nowTime) > 0) {
			reservedItem = "true";
		}
		if (boardItem.getParentWriteDate().compareTo(boardItem.getWriteDate()) > 0) {
			boardItem.setWriteDate(boardItem.getParentWriteDate());
		}
		if (boardItem.getEndDate().substring(0, 4).equals("9999")) {
			boardItem.setEndDate(egovMessageSource.getMessage("ezBoard.t287", userInfo.getLocale()));
		}
		
		if (adjacentItemsEnableFlag.equals("1") && showAdjacent.equals("1")) {
			if (boardItem.getUpperItemIDTree() == null || boardItem.getUpperItemIDTree().equals("")) {
				boardItem.setUpperItemIDTree(itemID);
			}
			if (boardInfo.getGuBun().equals("3")) {
				boardAdjacent = getAdjacentItems(itemID, boardID, boardItem.getUpperItemIDTree(), boardItem.getParentWriteDate(), userInfo.getTenantId());
			} else {
				boardAdjacent = getAdjacentItemsPhoto(itemID, boardID, boardItem.getUpperItemIDTree(), boardItem.getParentWriteDate(), userInfo.getTenantId());
			}
			
			if (boardAdjacent.getPreviousTitle().equals("")) {
				boardAdjacent.setPreviousTitle(egovMessageSource.getMessage("ezBoard.t330", userInfo.getLocale()));
			}
			
			if (boardAdjacent.getNextTitle().equals("")) {
				boardAdjacent.setNextTitle(egovMessageSource.getMessage("ezBoard.t331", userInfo.getLocale()));
			}
		}
		
		if (boardInfo.getBoardName() != null && !boardInfo.getBoardName().equals("")) {
        	boardInfo.setBoardName(commonUtil.cleanValue(boardInfo.getBoardName()));
        }
        
        if (boardInfo.getBoardName1() != null && !boardInfo.getBoardName1().equals("")) {
        	boardInfo.setBoardName1(commonUtil.cleanValue(boardInfo.getBoardName1()));
        }
        
        if (boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().equals("")) {
        	boardInfo.setBoardName2(commonUtil.cleanValue(boardInfo.getBoardName2()));
        }
        
        boardItem.setWriteDate(commonUtil.getDateStringInUTC(boardItem.getWriteDate(), userInfo.getOffset(), false));
        boardItem.setEndDate(commonUtil.getDateStringInUTC(boardItem.getEndDate(), userInfo.getOffset(), false));
        boardItem.setParentWriteDate(commonUtil.getDateStringInUTC(boardItem.getParentWriteDate(), userInfo.getOffset(), false));
		
		model.addAttribute("boardAdjacent", boardAdjacent);
		model.addAttribute("itemID", itemID);
		model.addAttribute("apprFlag", apprFlag);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("useOCS", useOCS);
		model.addAttribute("boardItem", boardItem);
		model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("reservedItem", reservedItem);
		model.addAttribute("oneLineReplyFlag", boardProperty.getOneLineReply());
		model.addAttribute("publicModulus", publicModulus);
        model.addAttribute("publicExponent", publicExponent);
		
		return "ezBoard/boardItemViewPhoto";
	}
	
	/**
	 * 게시판 포토게시물 앞뒤 게시물 표출 Method
	 * @param tenantID 
	 */
	public BoardVO getAdjacentItemsPhoto(String itemID, String boardID, String upperItemIDTree, String parentWriteDate, int tenantID) throws Exception{
		BoardVO boardVO = new BoardVO();
		
		if (boardVO.getPreviousItemID().equals("")) {
			List<BoardListVO> adjacentItem = ezBoardService.getAdjacentItems2Photo(boardID, parentWriteDate, tenantID);
			
			for (int k = 0; k < adjacentItem.size(); k++) {
				if (adjacentItem.get(k).getItemID().equals(itemID)) {
					boardVO.setPreviousItemID(adjacentItem.get(k - 1).getItemID());
					boardVO.setPreviousTitle(adjacentItem.get(k - 1).getTitle());
				}
			}
		}
		
		if (boardVO.getNextItemID().equals("")) {
			List<BoardListVO> adjacentItem = ezBoardService.getAdjacentItems3Photo(boardID, parentWriteDate, tenantID);
			
			for (int k = 0; k < adjacentItem.size(); k++) {
				if (adjacentItem.get(k).getItemID().equals(itemID)) {
					boardVO.setNextItemID(adjacentItem.get(k + 1).getItemID());
					boardVO.setNextTitle(adjacentItem.get(k + 1).getTitle());
				}
			}
		}
		
		boardVO.setPreviousTitle(commonUtil.cleanValue(boardVO.getPreviousTitle()));
		boardVO.setNextTitle(commonUtil.cleanValue(boardVO.getNextTitle()));
		
		return boardVO;
	}

	/**
	 * 게시판 일반게시판 앞뒤게시물 표출 Method
	 * @param tenantID 
	 */
	public BoardVO getAdjacentItems(String itemID, String boardID, String upperItemIDTree, String parentWriteDate, int tenantID) throws Exception{
		BoardVO boardVO = new BoardVO();
		String tempItemID = "";
		String tempTitle = "";
		List<BoardListVO> adjacentItem = ezBoardService.getAdjacentItems1(boardID, parentWriteDate, upperItemIDTree.substring(0, 38), tenantID);
		
		for (int i = 0; i < adjacentItem.size(); i++) {
			if (adjacentItem.get(i).getItemID().equals(itemID)) {
				boardVO.setPreviousItemID(tempItemID);
				boardVO.setPreviousTitle(tempTitle);
			}
			
			if (adjacentItem.get(i).getItemID().equals(itemID) && i < (adjacentItem.size() - 1)) {
				boardVO.setNextItemID(adjacentItem.get(i+1).getItemID());
				boardVO.setNextTitle(adjacentItem.get(i+1).getTitle());
			}
			tempItemID = adjacentItem.get(i).getItemID();
			tempTitle = adjacentItem.get(i).getTitle();
		}
		
		if (boardVO.getPreviousItemID().equals("")) {
			adjacentItem = ezBoardService.getAdjacentItems2(boardID, parentWriteDate, tenantID);
			
			for (int j = 0; j < adjacentItem.size() - 1; j++) {
				if (adjacentItem.get(j).getItemID().equals(itemID)) {
					boardVO.setPreviousItemID(adjacentItem.get(j+1).getItemID());
					boardVO.setPreviousTitle(adjacentItem.get(j+1).getTitle());
				}
			}
		}
		
		if (boardVO.getNextItemID().equals("")) {
			adjacentItem = ezBoardService.getAdjacentItems3(boardID, parentWriteDate, itemID, upperItemIDTree.substring(0, 38), boardVO.getPreviousItemID(), tenantID);
			
			if (adjacentItem.size() > 0) {
				boardVO.setNextItemID(adjacentItem.get(0).getItemID());
				boardVO.setNextTitle(adjacentItem.get(0).getTitle());
			}
		}
		boardVO.setPreviousTitle(commonUtil.cleanValue(boardVO.getPreviousTitle()));
		boardVO.setNextTitle(commonUtil.cleanValue(boardVO.getNextTitle()));
		
		return boardVO;
	}

	/**
	 * 게시판 섬네일리스트 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemListThumbnail.do")
	public String boardItemListThumbnail(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "new";
		String apprFlag = "Y";
		String useOCS = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String boardID = request.getParameter("boardID");
		String boardType = request.getParameter("boardType");
		String adminType = request.getParameter("adminType");
		String buttonHidden = "N";
		String boardName = request.getParameter("boardName");
		String useOneLineCount = "NO";
		String sortBy = "";
		int page = 0;
		
		if (request.getParameter("buttonHidden") != null) {
			buttonHidden = request.getParameter("buttonHidden");
		}
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		if (boardInfo.getListView_FG().equals("true")) {
			boardName = boardInfo.getBoardName();
			
			if (request.getParameter("sortBy") != null) {
				sortBy = request.getParameter("sortBy");
			}
			
			if (request.getParameter("page") == null) {
				page = 1;
			} else {
				page = Integer.parseInt(request.getParameter("page"));
			}
		}
		
		model.addAttribute("mode", mode);
		model.addAttribute("apprFlag", apprFlag);
		model.addAttribute("useOCS", useOCS);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardType", boardType);
		model.addAttribute("adminType", adminType);
		model.addAttribute("buttonHidden", buttonHidden);
		model.addAttribute("boardName", commonUtil.cleanValue(boardName));
		model.addAttribute("useOneLineCount", useOneLineCount);
		model.addAttribute("sortBy", sortBy);
		model.addAttribute("page", page);
		model.addAttribute("boardProperty", boardProperty);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		
		return "ezBoard/boardItemListThumbnail";
	}
	
	/**
	 * 게시판 포토게시물 게시하기 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/newBoardItemPhoto.do")
	public String newBoardItemPhoto(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = userInfo.getDisplayName1();
		String userEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String boardID = request.getParameter("boardID");
		String url = request.getParameter("url");
		String boardType = request.getParameter("bType");
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		String uploadFilePath = "";
		String strNow = "";
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (boardInfo.getWrite_FG().equals("false")) {
			return "main/warning"; 
		}
		uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		strNow = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		model.addAttribute("userID", userID);
		model.addAttribute("userEditor", userEditor);
		model.addAttribute("boardID", boardID);
		model.addAttribute("url", url);
		model.addAttribute("boardType", boardType);
		model.addAttribute("uploadFilePath", uploadFilePath);
		model.addAttribute("strNow", strNow);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		return "ezBoard/boardNewItemPhoto";
	}
	
	/**
	 * 게시판 게시물이미지업로드 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardImageUpload.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String imageUpload(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = request.getParameter("mode");
		String pFileLimit = request.getParameter("fileLimit");
		String uniqueIDs = request.getParameter("uniqueIDs");
		String realPath = commonUtil.getRealPath(request);
		String dirPath = "";
		String serverPath = "";
		String resultUpload = "";
		String fileName = "";
		String fileLocation = "";
		String thumbnailName = "";
		long fileSize = 0;
		List<MultipartFile> multiFile = null;
		
		if (mode.equals("PICTURE")) {
			multiFile = request.getFiles("file1");
			dirPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
			serverPath = dirPath + commonUtil.separator;
		} else if (mode.equals("DEL")) {
			String delServerPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
			String imagePath = "";
			String s_imagePath = "";
			String unique_ID = "";
			
			for (int i = 0; i < uniqueIDs.split(";").length; i++) {
				unique_ID = uniqueIDs.split(";")[i];
				imagePath = delServerPath + commonUtil.separator + unique_ID;
				s_imagePath = delServerPath + commonUtil.separator + "s_" + unique_ID;
				File file = new File(imagePath);
				File file1 = new File(s_imagePath);
				
				if (file.exists()) {
					deleteFile(imagePath);
				}
				if (file1.exists()) {
					deleteFile(s_imagePath);
				}
			}
			
			return "DEL";
		} else {
			multiFile = request.getFiles("file1");
			dirPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId());
			serverPath = dirPath + commonUtil.separator;
		}
		
		String uniqueName = "";
		File file = new File(serverPath);
		
		if (!file.exists()) {
			file.mkdirs();
		}
		StringBuffer strXML = new StringBuffer();

		strXML.append("<ROOT><NODES>");
		
		if (pFileLimit != null && pFileLimit.equals("0") || pFileLimit.equals("")) {
			pFileLimit = "2";
		}
		int fileLimit = Integer.parseInt(pFileLimit) * 1024 * 1024;
		
		for (int i = 0; i < multiFile.size(); i++) {
			fileSize = multiFile.get(i).getSize();
			if (fileSize > fileLimit) {
				resultUpload = "overflow";
                strXML.append("<NODE><PUPLOADSN><![CDATA[" + uniqueName + "]]></PUPLOADSN>");
                strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
                strXML.append("<PFILENAME><![CDATA[" + fileName + "]]></PFILENAME>");
                strXML.append("<FILESIZE>" + fileSize + "</FILESIZE>");
                strXML.append("<FILELOCATION><![CDATA[" + fileLocation + "]]></FILELOCATION>");
                strXML.append("<MODE><![CDATA[" + mode + "]]></MODE>");
                strXML.append("</NODE>");
			} else {
				if (multiFile.get(i).getOriginalFilename() != null && !multiFile.get(i).getOriginalFilename().equals("")) {
					String pFileName = multiFile.get(i).getOriginalFilename();
					if (pFileName.indexOf(commonUtil.separator.toString()) > 0) {
						pFileName = pFileName.split("/")[pFileName.split("/").length - 1];
					}
					fileName = commonUtil.cleanValue(pFileName);
				}
				fileName = fileName.replace("+", "%2b");
				fileName = fileName.replace(";", "%3b");
				
				String extension = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.lastIndexOf(".") + 1 + 3);
				String guid = "{" + UUID.randomUUID().toString() + "}";
				
				uniqueName = guid + "." + extension;
				thumbnailName = "s_" + guid + "." + extension;
				
				writeUploadedFile(multiFile.get(i), uniqueName, serverPath);
				fileLocation = uniqueName;
				File imageFile = new File(serverPath + uniqueName);	
				
				int nImgWidth = 0;
				int nImgHeight = 0;
				
				if (imageFile.exists()) {			
					BufferedImage bi = ImageIO.read(imageFile);			    
					nImgWidth = bi.getWidth();
					nImgHeight = bi.getHeight();
					int nWidth = 0, nHeight = 0;
					
                    if (nImgWidth > nImgHeight) {
                        nWidth = 200;
                        nHeight = (bi.getHeight() * nWidth) / bi.getWidth();
                    } else {
                        nHeight = 200;
                        nWidth = (bi.getWidth() * nHeight) / bi.getHeight();
                    }
                    BufferedImage bufferedImage = new BufferedImage(nWidth, nHeight, bi.getType());
                    bufferedImage.createGraphics().drawImage(bi, 0, 0, nWidth, nHeight, null);
                    ImageIO.write(bufferedImage, extension, new File(serverPath + thumbnailName));
				}
				resultUpload = "true";

                strXML.append("<NODE><THUMBNAILNAME><![CDATA[" + thumbnailName + "]]></THUMBNAILNAME>");
                strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
                strXML.append("<PFILENAME><![CDATA[" + fileName + "]]></PFILENAME>");
                strXML.append("<FILESIZE>" + fileSize + "</FILESIZE>");
                strXML.append("<FILELOCATION><![CDATA[" + serverPath + thumbnailName + "]]></FILELOCATION>");
                strXML.append("<MODE><![CDATA[" + mode + "]]></MODE>");
                strXML.append("<UNIQUEID><![CDATA[" + uniqueName + "]]></UNIQUEID>");
                strXML.append("<OFILENAME><![CDATA[" + multiFile.get(i).getOriginalFilename() + "]]></OFILENAME>");
                strXML.append("</NODE>");
			}
		}
		strXML.append("</NODES></ROOT>");
		
		return strXML.toString();
	}
	
	/**
	 * 게시판 섬네일정보 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/getBoardThumbnailInfo.do")
	public void getBoardThumbnailInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		String boardID = request.getParameter("boardID");
		String fileName = request.getParameter("fileName");
		String realPath = commonUtil.getRealPath(request);
		String pSignatureDir = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String filePath = "";
		
        if (type.equals("BOARDTHUM")) {
        	pSignatureDir = pSignatureDir + commonUtil.separator + boardID + commonUtil.separator + "uploadFile";
        } else {
        	pSignatureDir = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
        }
        filePath = pSignatureDir + commonUtil.separator + fileName;
        
        if (filePath != null && !filePath.equals("")) {
        	logger.debug("filePath : " + filePath + "|| fileName : " + fileName);
        	downFile(request, response, realPath + filePath, fileName);
        }
	}
	
	/**
	 * 게시판 포토게시물저장 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/saveItemPhoto.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String saveItemPhoto(HttpServletRequest request, @RequestBody String resultXML, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String result = "";
		String mode = request.getParameter("mode");
		String guBun = request.getParameter("guBun");
        String itemIDs = "";
        String[] itemID = null;
        String realPath = commonUtil.getRealPath(request);
		Document doc = commonUtil.convertStringToDocument(resultXML);
		String mainImageID = doc.getElementsByTagName("MAINIMAGEID").item(0).getTextContent();
		
		BoardPropertyVO boardInfo = getBoardInfo(doc.getElementsByTagName("BOARDID").item(0).getTextContent(), userInfo);
		if (boardInfo.getWrite_FG().equals("false")) {
			return "<RESULT>INACCESSIBLE</RESULT>";
		}
		
		if (guBun.equals("3") || guBun.equals("4")) {
			itemIDs = doc.getElementsByTagName("ITEMID").item(0).getTextContent();
			itemID = itemIDs.split(";");
		}
		
		doc.getElementsByTagName("ENDDATE").item(0).setTextContent(doc.getElementsByTagName("ENDDATE").item(0).getTextContent().substring(0, 10) + " 23:59:59");
		doc.getElementsByTagName("CONTENT").item(0).setTextContent(doc.getElementsByTagName("CONTENT").item(0).getTextContent().replace(System.lineSeparator(), "<br>"));
		
		if (!mode.equals("temp")) {
			mode = "New";
		}
		doc.getElementsByTagName("ITEMID").item(0).setTextContent(itemID[0]);
		doc.getElementsByTagName("UPPERITEMIDTREE").item(0).setTextContent(itemID[0]);
		
		result = ezBoardService.newItemPhoto(doc, mode, realPath, userInfo, mainImageID);
		
		return "<RESULT>" + result + "</RESULT>";
	}

	/**
	 * 게시판 승인유저리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/get_apprUserList.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String get_apprUserList(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("pBoardID");
		List<BoardVO> list = ezBoardService.get_apprUserList(boardID, userInfo.getTenantId());

		StringBuilder result = new StringBuilder("<NODES>");
		
		for (int i=0; i < list.size(); i++) {
			BoardVO vo = list.get(i);
			
			result.append("<NODE>");
			result.append("<BOARDID>" + vo.getBoardId() + "</BOARDID>");
			result.append("<APPRUSERID>" + vo.getApprUserId() + "</APPRUSERID>");
			result.append("<DISPLAYNAME>" + commonUtil.cleanValue(vo.getBoardName()) + "</DISPLAYNAME>");
			result.append("<DISPLAYNAME2>" + vo.getBoardType() + "</DISPLAYNAME2>");
			result.append("<DESCRIPTION>" + vo.getOrderCell() + "</DESCRIPTION>");
			result.append("<DESCRIPTION2>" + vo.getOrderOption() + "</DESCRIPTION2>");
			result.append("</NODE>");
		}
		result.append("</NODES>");
		
		return result.toString();
	}
	
	/**
	 * 게시판 이미지리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/imageViewList.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String imageViewList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String g_ImageUrl = "";
		String realPath = commonUtil.getRealPath(request);
		int imageCnt = 10;
		int page = Integer.parseInt(request.getParameter("page"));
		int pStartRow = (page - 1) * imageCnt + 1;
        int pEndRow = page * imageCnt;
        
        int imageCount = ezBoardService.photoViewDBCount(itemID, boardID, userInfo.getTenantId());
        
        List<BoardAttachVO> photoViewList = ezBoardService.photoViewDB(itemID, boardID, pStartRow, pEndRow, userInfo.getTenantId());
        
        StringBuffer sb = new StringBuffer();
        
        sb.append("<DATA>");
        
        for (int k = 0; k < photoViewList.size(); k++) {
        	sb.append("<ROW>");
        	sb.append("<IMAGECOUNT>" + imageCount + "</IMAGECOUNT>");
        	sb.append("<IMAGEID>" + photoViewList.get(k).getImageID() + "</IMAGEID>");
        	sb.append("<FILEPATH>" + photoViewList.get(k).getFilePath() + "</FILEPATH>");
        	sb.append("<FILECONTENT>" + commonUtil.cleanValue(photoViewList.get(k).getFileContent()) + "</FILECONTENT>");
        	sb.append("<FLAG>" + photoViewList.get(k).getFlag() + "</FLAG>");
        	sb.append("<IMAGENAME>" + photoViewList.get(k).getImageName() + "</IMAGENAME>");
        	
        	String filePath = photoViewList.get(k).getFilePath();
        	int idx = filePath.lastIndexOf(commonUtil.separator);
        	g_ImageUrl = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator + filePath.substring(0, idx + 1) + filePath.substring(idx + 1).replace("+", "%20");

            String pDirPath = realPath + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
            String orgpDirPath = pDirPath + commonUtil.separator + filePath.substring(0, idx + 1) + filePath.substring(idx + 1);
            String despPath = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId()) + commonUtil.separator + filePath.substring(idx + 1);
        	
            File file = new File(orgpDirPath);
            File file2 = new File(despPath);
            File file3 = new File(despPath.replace("s_", ""));
            
            if (file.exists() && !file2.exists()) {
            	FileUtils.copyFile(file, file2);
            	FileUtils.copyFile(file, file3);
            }
            
            sb.append("<IMAGEPATH>" + g_ImageUrl + ";" + "</IMAGEPATH>");
            sb.append("</ROW>");
        }
        
        sb.append("</DATA>");
        
		return sb.toString();
	}
	
	/**
	 * 게시판 포토게시판이미지추가 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/addImageItem.do")
	public String addImageItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		return "ezBoard/boardAddImageItem";
	}
	
	/**
	 * 게시판 포토게시판 이미지저장 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/saveImageItem.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String saveImageItem(@RequestBody String requestXML, HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("saveImageItem started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String uploadFilePath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String result = ezBoardService.saveImageItem(requestXML, uploadFilePath, userInfo);

		logger.debug("saveImageItem ended");
        
		return result;
	}
	
	/**
	 * 게시판 포토게시물 수정 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/modifyImageItem.do")
	public String modifyImageItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String imageID = request.getParameter("imageID");
		int page = Integer.parseInt(request.getParameter("page"));
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String guBun = request.getParameter("guBun");
		String imageContent = "";
		String g_ImageUrl = "";
		String listImages = "";
		String mainFg = "";
		String g_Width = "230";
		String g_Height = "230";
		int imageCnt = 10;
		int pStartRow = (page - 1) * imageCnt + 1;
        int pEndRow = page * imageCnt;
        String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
        List<BoardAttachVO> photoViewList = ezBoardService.photoViewDB(itemID, boardID, pStartRow, pEndRow, userInfo.getTenantId());
        BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);

        for (int k = 0; k < photoViewList.size(); k++) {
        	String listImage = photoViewList.get(k).getImageID();
        	
        	if (imageID.equals(listImage)) {
        		imageContent = photoViewList.get(k).getFileContent();
        		String filePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator + photoViewList.get(k).getFilePath();
        		int idx = filePath.lastIndexOf(commonUtil.separator);
        		
        		g_ImageUrl = filePath.substring(0, idx + 1) + filePath.substring(idx + 1).replace("+", "%20");
        		listImages = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + boardID + "&fileName=" + g_ImageUrl.split("/")[7].replace("s_", "") + ";";
        		mainFg = photoViewList.get(k).getFlag();
        	}
        }
        
        model.addAttribute("listCount", photoViewList.size());
        model.addAttribute("listImage", imageID);
        model.addAttribute("listImages", listImages.substring(0, listImages.length() - 1));
        model.addAttribute("imageContent", imageContent);
        model.addAttribute("boardID", boardID);
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("isCrossBrowser", isCrossBrowser);
        model.addAttribute("mainFg", mainFg);
        model.addAttribute("itemID", itemID);
        model.addAttribute("guBun", guBun);
        model.addAttribute("g_Width", g_Width);
        model.addAttribute("g_Height", g_Height);
        model.addAttribute("orgImagePath", listImages.substring(0, listImages.length() - 1));
		
		return "ezBoard/boardModifyImageItem";
	}
	
	/**
	 * 게시판 포토게시물 삭제 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/deleteImageItem.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String deleteImageItem(HttpServletRequest request, @RequestBody String resultXML, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String imageID = "";
        String boardID = "";
        String filePath = "";
        String mod = "";
        String content = "";
        String oFileName = "";
        String rtnValue = "";
        Document doc = commonUtil.convertStringToDocument(resultXML);
        
        mod = request.getParameter("mod");
        
        if (mod.equals("Del")) {
        	boardID = request.getParameter("boardID");
        	imageID = request.getParameter("imageIDs");
        	
        	String[] tempImageID = imageID.split(";");
        	try {
        		for (int k = 0; k < tempImageID.length; k++) {
        			ezBoardService.photoListDel(boardID, tempImageID[k], userInfo.getTenantId());
        		}
        		
        		rtnValue = "OK";
			} catch (Exception e) {
				logger.error("EzBoard :: deleteImageItem");
				rtnValue = "ERROR";
			}
        } else if (mod.equals("Mod")) {
        	String uploadFilePath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
        	String mainFg = doc.getElementsByTagName("MAINFG").item(0).getTextContent();
        	
        	boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
        	imageID = doc.getElementsByTagName("IMAGEID").item(0).getTextContent();
        	filePath = doc.getElementsByTagName("FILEPATH").item(0).getTextContent();
        	content = doc.getElementsByTagName("CONTENT").item(0).getTextContent();
        	oFileName = doc.getElementsByTagName("OFILENAME").item(0).getTextContent();
        	
        	String file_Path = "";
        	
            if (!filePath.equals("")) {
            	String tempFilePath = uploadFilePath + commonUtil.separator + filePath;
                File file = new File(tempFilePath);
                
                if (file.exists()) {
                	file_Path = uploadFilePath + commonUtil.separator + boardID + commonUtil.separator + "uploadFile" + filePath.replace("tempUploadFile", "");
                }
                FileUtils.copyFile(file, new File(file_Path));
                deleteFile(tempFilePath);

                if (filePath.indexOf("s_") > -1) {
                	tempFilePath = uploadFilePath + commonUtil.separator + filePath.replace("s_", "");
                	File file2 = new File(tempFilePath);
                	
                	if (file2.exists()) {
                		filePath = uploadFilePath + commonUtil.separator + boardID + commonUtil.separator + "uploadFile" + filePath.replace("s_", "").replace("tempUploadFile", "");
                	}
                	FileUtils.copyFile(file2, new File(filePath));
                	deleteFile(tempFilePath);
                }
            }
            
            if (!filePath.equals("")) {
            	file_Path = file_Path.replace(uploadFilePath + commonUtil.separator, "");
            } else {
            	file_Path = "";
            }
            
            ezBoardService.photoListUpdate(imageID, boardID, content, file_Path, doc.getElementsByTagName("ITEMID").item(0).getTextContent(), mainFg, oFileName, userInfo.getTenantId());
            
            return "OK";
            
        } else if (mod.equals("add")) {
        	String itemID = doc.getElementsByTagName("ITEMID").item(0).getTextContent();
        	String title = doc.getElementsByTagName("TITLE").item(0).getTextContent();
        	boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
        	content = doc.getElementsByTagName("CONTENT").item(0).getTextContent().replace(System.lineSeparator(), "<br>");;
        	
        	ezBoardService.photoListAlbumEdit(boardID, itemID, title, content, userInfo.getTenantId());
        	
        	return "OK";
        } else if (mod.equals("temp")) {
        	String itemID = doc.getElementsByTagName("ITEMID").item(0).getTextContent();
        	String title = doc.getElementsByTagName("TITLE").item(0).getTextContent();
        	boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
        	content = doc.getElementsByTagName("CONTENT").item(0).getTextContent().replace(System.lineSeparator(), "<br>");;
        	
        	ezBoardService.photoListAlbumEditTemp(boardID, itemID, title, content, userInfo.getTenantId());
        	
        	return "OK";
        } else {
        	ezBoardService.setMainImageID(doc.getElementsByTagName("IMAGEID").item(0).getTextContent(), doc.getElementsByTagName("ITEMID").item(0).getTextContent(), userInfo.getTenantId());
        	
        	return "OK";
        }
        
        return rtnValue;
	}
	
	/**
	 * 게시판 포토게시물삭제 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemDelete.do")
	public String boardItemDelete(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String g_ImageUrl = "";
		String listImages = "";
		String imageID = "";
		String imageContent = "";
		String mainFg = "";
		
		List<BoardAttachVO> photoViewList = ezBoardService.photoViewDBAll(itemID, boardID, userInfo.getTenantId());
		int imageCount = photoViewList.size();
		
		for (int k = 0; k < imageCount; k++) {
			String filePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator + photoViewList.get(k).getFilePath();
			int idx = filePath.lastIndexOf(commonUtil.separator);
			
			g_ImageUrl = filePath.substring(0, idx + 1) + filePath.substring(idx + 1).replace("+", "%20");
			listImages += "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + boardID + "&fileName=" + g_ImageUrl.split("/")[7] + ";";
			imageID += photoViewList.get(k).getImageID() + ";";
			imageContent += photoViewList.get(k).getFileContent() + ";";
			mainFg += photoViewList.get(k).getFlag().trim() + ";";
		}
		
		model.addAttribute("imageCount", imageCount);
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("g_ImageUrl", g_ImageUrl);
		model.addAttribute("listImages", listImages);
		model.addAttribute("imageID", imageID);
		model.addAttribute("imageContent", imageContent);
		model.addAttribute("mainFg", mainFg);
		
		return "ezBoard/boardItemDelete";
	}
	
	/**
	 * 게시판 포토앨범 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/photoAlbumEdit.do")
	public String photoAlbumEdit() {
		return "ezBoard/boardPhotoAlbumEdit";
	}
	
	/**
	 * 게시판 포토게시판이미지다운 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/imagedownload.do")
	public String imagedownload(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String g_ImageUrl = "";
		String listImages = "";
		String imageID = "";
		String imageContent = "";
		String fileName = "";
		String encodeFileHref = "";
		
		List<BoardAttachVO> photoViewList = ezBoardService.photoViewDBAll(itemID, boardID, userInfo.getTenantId());
		int imageCount = photoViewList.size();
		
		for (int k = 0; k < imageCount; k++) {
			String filePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator + photoViewList.get(k).getFilePath();
			int idx = filePath.lastIndexOf(commonUtil.separator);
			
			g_ImageUrl = filePath.substring(0, idx + 1) + filePath.substring(idx + 1).replace("+", "%20");
			listImages += "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + boardID + "&fileName=" + g_ImageUrl.split("/")[7] + ";";
			imageID += photoViewList.get(k).getImageID() + ";";
			imageContent += photoViewList.get(k).getFileContent() + ";";
			
			if (photoViewList.get(k).getImageName().split("/").length > 1) {
				fileName += photoViewList.get(k).getImageName().split("/")[3] + ";";
				encodeFileHref += "/ezBoard/boardAttachDown.do?filePath=" + filePath + "&fileName=" + (g_ImageUrl.split("/")[7]).replace("s_", "") +
                        "&attID=" + photoViewList.get(k).getImageName().split("/")[3] + ";";
			} else {
				fileName += photoViewList.get(k).getImageName() + ";";
				encodeFileHref += "/ezBoard/boardAttachDown.do?filePath=" + filePath + "&fileName=" + (g_ImageUrl.split("/")[7]).replace("s_", "") +
                        "&attID=" + photoViewList.get(k).getImageName() + ";";
			}
		}
		
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("listImages", listImages);
		model.addAttribute("imageID", imageID);
		model.addAttribute("imageContent", imageContent);
		model.addAttribute("imageCount", imageCount);
		model.addAttribute("fileName", fileName);
		model.addAttribute("encodeFileHref", encodeFileHref);
		
		return "ezBoard/boardImagedownload";
	}
	
	/**
	 * 게시판 나의게시물 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemListMyList.do")
	public String boardItemListMyList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		int page = 1;
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId()); 
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useEditor", useEditor);
		
		return "ezBoard/boardItemListMyList";
	}
	
	/**
	 * 게시판 게시판트리모달 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/writeBoardSelectModal.do")
	public String writeBoardSelectModal(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		model.addAttribute("useEditor", useEditor);
		
		return "ezBoard/boardWriteSelectModal";
	}
	
	/**
	 * 게시판 게시판트리 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/writeBoardSelect.do")
	public String writeBoardSelect(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		model.addAttribute("useEditor", useEditor);
		
		return "ezBoard/boardWriteSelect";
	}
	
	/**
	 * 게시판 게시판정보 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getBoardInfo.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getBoardInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		String strXML = "<DATA>";
		
        strXML += "<BOARDNAME>" + commonUtil.cleanValue(boardInfo.getBoardName()) + "</BOARDNAME>";
        strXML += "<ATTACHLIMIT>" + boardInfo.getAttachSizeLimit() + "</ATTACHLIMIT>";
        strXML += "<EXPIREDAYS>" + boardInfo.getExpireDays() + "</EXPIREDAYS>";
        strXML += "<GUBUN>" + boardInfo.getGuBun() + "</GUBUN>";
        strXML += "<FORM>" + ezBoardService.checkForm(boardID, "Y", userInfo.getTenantId()) + "</FORM>";
        strXML += "<BACKIMAGE>" + ezBoardService.checkBackGroundImage(boardID, userInfo.getTenantId()) + "</BACKIMAGE>";
        strXML += "</DATA>";
        
		return strXML;
	}
	
	/**
	 * 게시판 예약게시물리스트 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardReservedItemList.do")
	public String boardReservedItemList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String orgBoardParameters = "";
		int page = 1;
		String sortBy = "";
		String boardType = "";
		String adminType = "";
		String boardName = egovMessageSource.getMessage("ezBoard.t229", userInfo.getLocale());
		String isVpn = "";
		int totalCount = 0;
		int totalPage = 0;
		
		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		if (request.getParameter("orgBoardParameters") != null) {
			orgBoardParameters = request.getParameter("orgBoardParameters");
		}
		if (request.getParameter("boardType") != null) {
			boardType = request.getParameter("boardType");
		}
		if (request.getParameter("adminType") != null) {
			adminType = request.getParameter("adminType");
		}
		if (request.getParameter("sortBy") != null) {
			sortBy = request.getParameter("sortBy");
		}
		
		BoardPropertyVO boardInfo = getBoardInfo("", userInfo);
		
		int startRow = (page - 1) * boardInfo.getSs_board_maxRows() + 1;
        int endRow = page * boardInfo.getSs_board_maxRows();
        
        List<BoardListVO> reservedList = ezBoardService.getReservedItemList(userInfo.getId(), startRow, endRow, sortBy, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getOffset(), userInfo.getTenantId());
        totalCount = ezBoardService.getReservedItemListCount(userInfo.getId(), userInfo.getTenantId());
        
        if (reservedList == null && page > 1) {
        	page -= 1;
        	startRow = (page - 1) * boardInfo.getSs_board_maxRows() + 1;
        	endRow = page * boardInfo.getSs_board_maxRows();
        	reservedList = ezBoardService.getReservedItemList(userInfo.getId(), startRow, endRow, sortBy, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getOffset(), userInfo.getTenantId());
        }
        
        if (totalCount > 0) {
            if (totalCount > boardInfo.getSs_board_maxRows()) {
                String temp = String.valueOf(totalCount / boardInfo.getSs_board_maxRows());
                if (temp.indexOf(".") != 0) {
                	totalPage = Integer.parseInt(temp.split(".")[0] + 1);
                } else {
                	totalPage = Integer.parseInt(temp);
                }
            } else {
                totalPage = 1;
            }
        } else {
            totalPage = 1;
        }
        
        model.addAttribute("useEditor", useEditor);
        model.addAttribute("orgBoardParameters", orgBoardParameters);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("boardType", boardType);
        model.addAttribute("adminType", adminType);
        model.addAttribute("boardName", commonUtil.cleanValue(boardName));
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("page", page);
        model.addAttribute("reservedList", reservedList);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("isVpn", isVpn);
		
		return "ezBoard/boardReservedItemList";
	}
	
	/**
	 * 게시판 임시게시물리스트 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemListTemp.do")
	public String boardItemListTemp(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		int page = 1;

		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useOcs", useOcs);
		
		return "ezBoard/boardItemListTemp";
	}
	
	/**
	 * 게시판 임시게시물 삭제 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/deleteTempItem.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String deleteTempItem(@RequestBody String strItemID, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "";
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		
		String resultVal = ezBoardService.deleteTempItem1(mode, strItemID, userInfo.getTenantId());
		
		return resultVal;
	}
	
	/**
	 * 게시판 게시물설정 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/setBoardConfig.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String setBoardConfig(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("pUserID");
		String listCount = request.getParameter("pListCount");
		String preView = request.getParameter("pPreView");
		int tempCount = 10;
		
		if (listCount != null) {
			tempCount = Integer.parseInt(listCount);
		}
		
		String result = ezBoardService.setBoardConfig(userID, tempCount, preView, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 게시판 게시물미리보기 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getPreviewItem.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getPreviewItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String location = "";
		String itemID = "";
		String mode = "";
		String boardID = "";
		
		location = request.getParameter("location"); 		
		itemID = request.getParameter("itemID"); 		
		boardID = request.getParameter("boardID"); 		
		mode = request.getParameter("mode");
		
		if (!accessCheck(itemID, location, userInfo)) {
			return "<DATA>NO</DATA>";
		}
		
		String retXML = "";
		
		if (!mode.equals("temp")) {
			retXML = ezBoardService.getItemXML(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getOffset(), userInfo.getTenantId());
		} else {
			retXML = ezBoardService.getItemTempXML(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getOffset(), userInfo.getTenantId());
		}
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);
		
		return retXML;
	}
	
	/**
	 * 게시판 미리보기게시물 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemPreviewContent.do")
	public String boardItemPreviewContent() throws Exception{
		return "ezBoard/boardItemPreviewContent";
	}
	
	/**
	 * 게시판 첨부관련정보 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getBoardAttachInfo.do")
	public void getBoardAttachInfo(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String attID = request.getParameter("attID");
		String itemID = request.getParameter("itemID");
		String fileName = "";
		String filePath = "";
		String realPath = commonUtil.getRealPath(request);
		
		BoardAttachVO result = ezBoardService.getAttachInfo(itemID, attID, userInfo.getTenantId());
		
		filePath = result.getFilePath();
		fileName = result.getFileName();
		
		if (filePath != null && !filePath.equals("")) {
			downFile(request, response, realPath + filePath, fileName);
		}
	}
	
	/**
	 * 게시판 리스트설정셋팅 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/boardGeneralListSave2.do")
	public String boardGeneralListSave2(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String listCount = request.getParameter("listCount");
		String previewMode = request.getParameter("previewMode");
		String list = request.getParameter("list");
		String content = request.getParameter("content");
		
		ezBoardService.setBoardList_Config2(userID, listCount, previewMode, list, content, userInfo.getTenantId());
		
		return "json";
	}

	/**
	 * 게시판 게시판승인 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemListAppr.do")
	public String boardItemListAppr(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		int page = 0;
		
		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		model.addAttribute("page", page);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useEditor", useEditor);
		
		return "ezBoard/boardItemListAppr";
	}
	
	/**
	 * 게시판 게시판승인리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/apprBoardItem.do", produces="text/plain; charset=utf-8")
	@ResponseBody
	public String apprBoardItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pMod = request.getParameter("mode");
		String itemList = request.getParameter("itemList");
		String result = "";
		
		String[] tempItem = itemList.split(";");
		
		for (int k = 0; k < tempItem.length; k++) {
			result = ezBoardService.apprItem(userInfo.getId(), tempItem[k], pMod, userInfo.getTenantId());
		}
		
		return result;
	}
	
	/**
	 * 게시판 게시판반려사유 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardApprOpinion.do")
	public String boardApprOpinion(HttpServletRequest request, Model model) throws Exception{
		String itemList = request.getParameter("itemList");
		String mode = request.getParameter("mode");
		
		model.addAttribute("mode", mode);
		model.addAttribute("itemList", itemList);
		
		return "ezBoard/boardApprOpinion";
	}
	
	/**
	 * 게시판 한줄댓글저장 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/saveOneLineReply.do")
	public void saveOneLineReply(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		String itemID = request.getParameter("itemID");
		String replyID = request.getParameter("replyID");
		String boardID = request.getParameter("boardID");
		String content = request.getParameter("content");
		String password = request.getParameter("password");
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String rpwd = EgovFileScrty.decryptRsa(pk, password);
		password = EgovFileScrty.encryptPassword(rpwd, "unknown");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (boardInfo.getGuBun().equals("2")) {
			userInfo.setDisplayName1(egovMessageSource.getMessage("ezBoard.t249", userInfo.getLocale()).split(";")[0]);
			userInfo.setDisplayName2(egovMessageSource.getMessage("ezBoard.t249", userInfo.getLocale()).split(";")[1]);
			userInfo.setId("");
		}
		
		content = content.replace("'", "''");
		
		ezBoardService.saveOneLineReply(itemID, replyID, boardID, userInfo, content, password);
	}
	
	/**
	 * 게시판 한줄댓글삭제 표출 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/deleteOneLineReply.do", produces="text/plain; charset=utf-8")
	@ResponseBody
	public String deleteOneLineReply(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String guBun = request.getParameter("guBun");
		String replyID = request.getParameter("replyID");
		String result = ezBoardService.deleteOneLineReply(userInfo.getId(), replyID, guBun, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 게시판 한줄댓글 오너체크 표출 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/checkOneLineOwner.do")
	@ResponseBody
	public String checkOneLineOwner(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String replyID = request.getParameter("replyID");
		String result = ezBoardService.checkOneLineOwner(replyID, userInfo.getId(), userInfo.getTenantId());

		return result;
	}
	
	/**
	 * 게시판 한줄댓글리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/readOneLineReply.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String readOneLineReply(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String userName = "";
		
		userName = "USERNAME" + commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		
		List<BoardLineReplyVO> boardLineReplyVOList = ezBoardService.readOneLineReply(boardID, itemID, userName, userInfo.getTenantId());
        StringBuffer sb = new StringBuffer();
        
        sb.append("<DATA>");

		for (int i = 0; i < boardLineReplyVOList.size(); i++) {
			StringBuilder stb = new StringBuilder();		
			
			if (boardLineReplyVOList.get(i) != null) {
				stb.append("<ROW>");
				
				for(Field field : boardLineReplyVOList.get(i).getClass().getDeclaredFields()){
			        field.setAccessible(true);
					String data = String.valueOf(field.get(boardLineReplyVOList.get(i)));
		
					if(data == null || data.equals(null) || data.equals("null")){
						data = "";
					}				
			        stb.append("<" + field.getName().toUpperCase() + ">");
			        if (field.getName().toUpperCase().equals("WRITEDATE")) {
			        	stb.append(commonUtil.getDateStringInUTC(data, userInfo.getOffset(), false));
			        } else {
			        	stb.append(commonUtil.cleanValue(data));
			        }
			        stb.append("</" + field.getName().toUpperCase() + ">");		        
			    }
				stb.append("</ROW>");
			} else {
				stb.append("");
			}
			sb.append(stb.toString());
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	/**
	 * 게시판 게시판게시하기 첨부파일업로드 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/uploadApprovFile.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String uploadApprovFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody String xmlPara) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String strXML = "";
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String boardID = xmlDom.getElementsByTagName("BOARDID").item(0).getTextContent();
		String realPath = commonUtil.getRealPath(request);
		int cnt = xmlDom.getElementsByTagName("ROW").getLength();
		
		String[] fileName = new String[cnt];
		String[] orgFileName = new String[cnt];
		String[] fileSize = new String[cnt];
		String[] fileLocation = new String[cnt];
		String[] type = new String[cnt];
		String[] uploadSN = new String[cnt];
		
		for (int k = 0; k < cnt; k++) {
			fileName[k] = xmlDom.getElementsByTagName("FILENAME").item(k).getTextContent();
			fileLocation[k] = xmlDom.getElementsByTagName("FILEPATH").item(k).getTextContent();
			fileSize[k] = xmlDom.getElementsByTagName("FILESIZE").item(k).getTextContent();
			orgFileName[k] = xmlDom.getElementsByTagName("ORGFILEPATH").item(k).getTextContent();
			type[k] = xmlDom.getElementsByTagName("TYPE").item(k).getTextContent();
			uploadSN[k] = "{" + UUID.randomUUID().toString() + "}";
		}
		
		String dirPath = realPath + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String dirPath2 = "";
		
		if (type[0].equals("APPROVAL")) {
			dirPath2 = realPath + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		} else {
			dirPath2 = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		}
		
		File file = new File(dirPath + boardID);
		
		if (!file.exists()) {
			file.mkdirs();
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdir();
			new File(dirPath + boardID + commonUtil.separator + "doc").mkdir();
		} else if (!new File(dirPath + boardID + commonUtil.separator + "uploadFile").exists()) {
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
		}
		
		for (int k = 0; k < fileName.length; k++) {
			if (orgFileName[k].substring(orgFileName[k].lastIndexOf(".")).toUpperCase().indexOf("MHT") > -1 ||
				orgFileName[k].substring(orgFileName[k].lastIndexOf(".")).toUpperCase().indexOf("HWP") > -1 ||
				orgFileName[k].substring(orgFileName[k].lastIndexOf(".")).toUpperCase().indexOf("DOC") > -1 ) {
				
				fileName[k] = fileName[k] + orgFileName[k].substring(orgFileName[k].lastIndexOf("."));
				
				file = new File(dirPath2 + commonUtil.separator + fileLocation[k]);
				fileSize[k] = String.valueOf(file.length());
			}
			
			file = new File(dirPath2 + commonUtil.separator + fileLocation[k]);

			if (file.exists()) {
				FileUtils.copyFile(file, new File(dirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + uploadSN[k] + "_" + fileName[k].replace("\\", "").replace("/", "").replace(":", "").replace("?", "").
                        replace('"' + "", "").replace("*", "").replace("<", "").replace(">", "").replace("|", "")));
			}
		}
		
		strXML = "<ROOT><NODES>";
		
		for (int k = 0; k < cnt; k++) {
			strXML += "<NODE><PUPLOADSN><![CDATA[" + uploadSN[k] + "_" + fileName[k] + "]]></PUPLOADSN>";
            strXML += "<RESULTUPLOADA><![CDATA[true]]></RESULTUPLOADA>";
            strXML += "<PFILENAME><![CDATA[" + fileName[k] + "]]></PFILENAME>";
            strXML += "<FILESIZE>" + fileSize[k] + "</FILESIZE>";
            strXML += "<FILELOCATION><![CDATA[" + dirPath + "tempUploadFile" + commonUtil.separator + uploadSN[k] + "_" + fileName[k] + "]]></FILELOCATION>";
            strXML += "</NODE>";
		}
		
		strXML += "</NODES></ROOT>";
		
		return strXML;
	}
	
	/**
	 * 포탈 포토갤러리 포틀릿 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getImagePortletList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getImagePortletList(HttpServletRequest request, @RequestBody String xmlPara, @CookieValue("loginCookie") String loginCookie) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String pBoardType = xmlDom.getElementsByTagName("pBoardType").item(0).getTextContent();
		String pBoardID = xmlDom.getElementsByTagName("pBoardID").item(0).getTextContent();
		int pPageNum = Integer.parseInt(xmlDom.getElementsByTagName("pPageNum").item(0).getTextContent());
		String pOrderCell = xmlDom.getElementsByTagName("orderCell").item(0).getTextContent();
		String pOrderOption = xmlDom.getElementsByTagName("orderOption").item(0).getTextContent();
		
		String boardXML = ezBoardService.getThumbListXML(userInfo, pBoardType, pBoardID, pPageNum, pOrderCell, pOrderOption);
		
		return boardXML;
	}
	
	/**
	 * 게시판 게시판트리(boardPortlet) 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardSelect.do")
	public String boardSelect(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useIE11Browser = ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId());
		String noneActiveX = "YES";
		
		if (req.getHeader("User-Agent").indexOf("rv:11") > 0 || req.getHeader("User-Agent").indexOf("Trident/7.0") > 0 && useIE11Browser.equals("CK")) {
			useIE11Browser = "CL";
		}
		
		String pRootBoardID = "top";
		String pSubFlag = "0";
		int pSelectBy = 0;
		String pExcludeBoardID = " ";
		
		String boardGroupAdminFG = ezBoardAdminService.checkIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		int pMode = 0;
		if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1) {
			pMode = 0;
		} else {
			pMode = 1;
		}
		
		String retXML = ezBoardService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		if (retXML.substring(0, 5).toUpperCase().equals("ERROR")) {
			retXML = "<RESULT>ERROR</RESULT>";
		}
		
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("noneActiveX", noneActiveX);
		
		return "ezBoard/boardBoardSelect";
	}
	
	/**
	 * 게시판 메일보내기 컨텐츠 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getItemInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getItemInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getItemInfo started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");

		String result = ezBoardService.getItemXML(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getOffset(), userInfo.getTenantId());

		logger.debug("getItemInfo ended");
		
		return result;
	}
	
	/**
	 * 게시판 메일보내기 첨부파일 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getItemAttachmentsMail.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getItemAttachments(@CookieValue("loginCookie") String loginCookie, BoardItemVO boardItemVO, HttpServletRequest request) throws Exception {
		logger.debug("getItemAttachments started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		
		boardItemVO.setTenantID(userInfo.getTenantId());
		boardItemVO.setFilePath(realPath);
		
		String result = "";
		
		if (boardItemVO.getMode() != null && (boardItemVO.getMode().equals("boardContent") || boardItemVO.getMode().equals("boardAttach"))) {
			boardItemVO.setTitle(commonUtil.cleanValue(boardItemVO.getTitle()));
			result = ezBoardService.getItemAttachmentXMLRetrans(boardItemVO);
		} else {
			result = ezBoardService.getItemAttachmentXML(boardItemVO);
		}
		
		logger.debug("getItemAttachments ended");
		
		return result;
	}
	
	/**
	 * 게시판 게시알림 메일전송 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/sendPostNotiMail.do")
	public void sendPostNotiMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("sendPostNotiMail started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		logger.debug("boardID=" + boardID + ",itemID=" + itemID);
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		BoardListVO boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		String strURL = "Item_View_New('" + boardID + "','" + itemID + "','" + boardInfo.getGuBun() + "');";
        strURL = "<span style=\"color:blue;cursor:pointer;text-decoration:underline;\" onClick=\"" + strURL + "\">";
		
        String strDate = commonUtil.getDateStringInUTC(boardItem.getWriteDate(), userInfo.getOffset(), false); 
        strDate += "( " + userInfo.getOffset().split("\\|")[1] + " )";
        
        StringBuilder bodyContent = new StringBuilder();

        bodyContent.append("<DIV id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
        bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t250", userInfo.getLocale()) + "<br><br>");
        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + boardInfo.getBoardName());
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", userInfo.getLocale()) + strDate);
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + userInfo.getTitle() + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + boardItem.getTitle() + "</a>");
        bodyContent.append("</DIV>");
        
        String subject = "[" + egovMessageSource.getMessage("ezBoard.t255", userInfo.getLocale()) + boardInfo.getBoardName() + "] " + boardItem.getTitle();
        
        List<BoardAccessVO> list = ezBoardService.getPostNotiMailUserList(boardID, userInfo.getPrimary(), userInfo.getTenantId());
        
        for (BoardAccessVO vo : list) {
        	InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	String mail = "";
        	
        	try {
        		OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(vo.getAccessID(), userInfo.getPrimary(), userInfo.getTenantId());
        		
        		mail = AccessUserInfo.getMail();
				logger.debug("user sendMail");
			} catch (Exception e) {
				OrganDeptVO accessDeptInfo = ezOrganService.getDeptInfo(vo.getAccessID(), userInfo.getPrimary(), userInfo.getTenantId());
				
				mail = accessDeptInfo.getMail();
				logger.debug("dept sendMail");
			}
        	
        	InternetAddress to = new InternetAddress();
        	to.setPersonal(vo.getAccessName(), "UTF-8");
        	to.setAddress(mail);
        	
        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
        }
		
		logger.debug("sendPostNotiMail ended.");
	}
	
	/**
	 * 게시글 존재여부 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getItemViewNew.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getItemViewNew(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getItemViewNew started.");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		
		int result = ezBoardService.getItemViewNew(boardID, itemID, userInfo.getTenantId());
		
		logger.debug("getItemViewNew ended.");
		
		return "<DATA>" + result + "</DATA>";
	}
	
	/**
	 * 게시판 답변알림 메일전송 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/sendReplyNoticeMail.do")
	public void sendReplyNoticeMail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("sendReplyNoticeMail started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String itemTreeID = request.getParameter("itemTreeID");
		logger.debug("boardID=" + boardID + ",itemID=" + itemID + ",itemTreeID=" + itemTreeID);
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (!boardInfo.getReplyNotify().equals("1")) {
			return ;
		}
		
		String strXML = ezBoardService.getItemXML(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getOffset(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(strXML);
		String title = doc.getElementsByTagName("Title").item(0).getTextContent();
		String strURL =  "javascript:Item_View_New('" + boardID + "','" + itemID + "');";
        strURL = "<span style=\"color:blue;cursor:pointer;text-decoration:underline;\" onClick=\"" + strURL + "\">";
        
        StringBuilder bodyContent = new StringBuilder();
        
        bodyContent.append("<DIV id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
        bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t259", userInfo.getLocale()) + "<br><br>");
        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + boardInfo.getBoardName());
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", userInfo.getLocale()) + commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + userInfo.getTitle() + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + title + "</span>");
        bodyContent.append("</DIV>");
        
        String subject = "[" + egovMessageSource.getMessage("ezBoard.t260", userInfo.getLocale()) + boardInfo.getBoardName() + "]" + title;
        
        List<BoardListVO> boardListVOs = ezBoardService.getReplyNoticeMail(boardID, itemTreeID, userInfo.getLang(), userInfo.getTenantId());
        
        for (BoardListVO vo : boardListVOs) {
        	InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	InternetAddress to = new InternetAddress();
        	to.setPersonal(vo.getWriterName(), "UTF-8");
        	to.setAddress(vo.getMail());
        	
        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
        }

		logger.debug("sendReplyNoticeMail ended");
	}
	
	/**
	 * 게시판 전자결재승인관련 메일전송 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/sendApprNoticeMail.do")
	public void sendApprnoticeMail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("sendApprnoticemail started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		logger.debug("boardID=" + boardID + ",itemID=" + itemID);
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		String strXML = ezBoardService.getItemXML(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getOffset(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(strXML);
		String title = doc.getElementsByTagName("Title").item(0).getTextContent();
		String gubun = doc.getElementsByTagName("GUBUN").item(0).getTextContent();
		String strURL = "javascript:Item_View_APPR('" + boardID + "','" + itemID + "','" + gubun + "');";
        strURL = "<a style='color:blue;text-decoration:underline;cursor:pointer;' onClick=" + strURL + ">";
        
        StringBuilder bodyContent = new StringBuilder();
        
        bodyContent.append("<DIV id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
        bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t999006", userInfo.getLocale()) + "<br><br>");
        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + boardInfo.getBoardName());
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", userInfo.getLocale()) + commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + userInfo.getTitle() + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + title + "</a>");
        bodyContent.append("</DIV>");
        
        String subject = "[" + egovMessageSource.getMessage("ezBoard.t999006", userInfo.getLocale()) + boardInfo.getBoardName() + "]" + title;
        
        List<LoginVO> loginVOs = ezBoardService.getSendApprMailList(boardID, userInfo.getLang(), userInfo.getTenantId());
        
        for (LoginVO vo : loginVOs) {
        	InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	InternetAddress to = new InternetAddress();
        	to.setPersonal(vo.getDisplayName(), "UTF-8");
        	to.setAddress(vo.getEmail());
        	
        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
        }
        
		logger.debug("sendApprnoticemail ended");
	}
	
	/**
	 * 게시판 전자결재승인반려관련 메일전송 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/sendReturnNoticeMail.do")
	public void sendReturnNoticemail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("sendReturnNoticemail started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String content = request.getParameter("content");
		
		logger.debug("content=" + content + ",itemID=" + itemID);
		
		String[] itemIDs = itemID.split(";");
		
		for (int k = 0; k < itemIDs.length; k++) {
			String tempItemID = itemIDs[k].split(",")[0];
			
			BoardListVO boardListVO = ezBoardService.getItemInfo("", tempItemID, userInfo.getLang(), userInfo.getTenantId());
			
			String strURL = "javascript:Item_View_APPR('" + boardListVO.getBoardID() + "','" + tempItemID + "','" + boardListVO.getGuBun() + "');";
	        strURL = "<a style='color:blue;text-decoration:underline;cursor:pointer;' onClick=" + strURL + ">";
	        
	        StringBuilder bodyContent = new StringBuilder();
	        
	        bodyContent.append("<DIV id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
	        bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t999015", userInfo.getLocale()) + "<br><br>");
	        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + boardListVO.getBoardName());
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + boardListVO.getTitle() + "</a>");
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t999016", userInfo.getLocale()) + " : " + content + "</a>");
	        bodyContent.append("</DIV>");
	        
	        String subject = "[" + egovMessageSource.getMessage("ezBoard.t999017", userInfo.getLocale()) + "]" + boardListVO.getTitle();
	        
        	InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	InternetAddress to = new InternetAddress();
        	to.setPersonal(boardListVO.getWriterName(), "UTF-8");
        	to.setAddress(boardListVO.getMail());
        	
        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
		}
		
		logger.debug("sendReturnNoticemail ended");
	}
	
	/**
	 * 게시판 boardListPortal 화면 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardListPortal.do")
	public String boardListPortal(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemCount = request.getParameter("itemCount");
		String itemFields = request.getParameter("itemFields");
        
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		List<BoardListVO> list = ezBoardService.getUnreadItems(userInfo.getId(), boardID, Integer.parseInt(itemCount), userInfo.getTenantId());
		
		int totalCount = ezBoardService.getUnreadItemsCount(userInfo.getId(), boardID, userInfo.getTenantId());
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("totalCount", totalCount);
		
		return "ezBoard/boardListPortal";
	}
	
	@RequestMapping(value = "/ezBoard/boardItemPreViewPhotoContent.do")
	public String boardItemPreViewPhotoContent(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardItemPreViewPhotoContent started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String showAdjacent = request.getParameter("showAdjacent");
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String mode = request.getParameter("mode");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (!boardInfo.getRead_FG().equals("true")) {
        	return "main/warning";
        }
		
//		String retVal = "";
//		
//		if (!mode.equals("temp")) {
//			retVal = ezBoardService.getItemXML(boardID, itemID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
//		} else {
//			retVal = ezBoardService.getItemTempXML(boardID, itemID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
//		}
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);

		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("mode", mode);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		
		logger.debug("boardItemPreViewPhotoContent ended");
		
		return "ezBoard/boardItemPreViewPhotoContent";
	}
}