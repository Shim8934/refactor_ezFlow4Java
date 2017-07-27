package egovframework.ezEKP.ezTalkGate.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezTalkGate.util.EzTalkGateUtil;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.web.LoginController;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * 
 * @Description 비즈메카톡 메신저에서 ezEKP 그룹웨어 연동 관련 호출하는 URL 처리를 수행하는 클래스
 * @author dhlee
 *
 */
@Controller
public class EzTalkGateController {

	private static final Logger logger = LoggerFactory.getLogger(EzTalkGateController.class);
	
	@Autowired
	private EzTalkGateUtil ezTalkGateUtil;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Autowired
	private LoginController loginController;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Autowired
	private CommonUtil commonUtil;
	
    @Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@RequestMapping("/ezTalkGate/main.do")
	public String ezTalkGateMain(
					@RequestParam String ezTalkId,
					@RequestParam String ezTalkPw,
					@RequestParam String ezTalkSsoType,
					HttpServletRequest request,
					HttpServletResponse response
					) throws Exception {
		logger.debug("ezTalkGateMain started.");
		
		String orgId = ezTalkGateUtil.decryptEzTalkAES(ezTalkId);
		String orgPw = ezTalkGateUtil.decryptEzTalkAES(ezTalkPw); 
		
		logger.debug("orgId=" + orgId + ",ezTalkSsoType=" + ezTalkSsoType);
		
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        int tenantId = loginService.getTenantId(serverName);
        
        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
		
		boolean isUserExists = checkIfUserExists(orgId, orgPw, tenantId);
		
		logger.debug("isUserExists=" + isUserExists);
		
		if (isUserExists) {
			String encryptedPw = EgovFileScrty.encryptPassword(orgPw, orgId);
			
			loginController.createLoginCookie(orgId, orgPw, encryptedPw, tenantId, request, response);
			
			logger.debug("ezTalkGateMain ended.");
			
			if (ezTalkSsoType.equals("mail")) {
				return "redirect:/ezEmail/mailList.do";
			} else if (ezTalkSsoType.equals("approval")) { 
				return "redirect:/ezApprovalG/aprManage.do?listType=1&subQuery=";
			} else if (ezTalkSsoType.equals("portal")) { 
				return "redirect:/ezPortal/portalMain.do";
			} else if (ezTalkSsoType.equals("noticeBoard")) { 
				return "redirect:/ezTalkGate/noticeBoard.do";
			} else if (ezTalkSsoType.equals("mailWrite")) { 
				return "redirect:/ezEmail/mailWrite.do?cmd=NEW";
			} else {
				return "";
			}
		} else {
			logger.debug("ezTalkGateMain ended.");
			
			return "redirect:/user/login/login.do";
		}
	}
	
	@RequestMapping("/ezTalkGate/noticeBoard.do")
	public String noticeBoard(
					@CookieValue("loginCookie") String loginCookie,
					Model model
					) throws Exception {
		logger.debug("noticeBoard started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		logger.debug("id=" + userInfo.getId() + ",tenantId=" + userInfo.getTenantId());
		
		String ezTalkGateNoticeBoardId = ezCommonService.getTenantConfig("ezTalkGateNoticeBoardId", userInfo.getTenantId());
		
		logger.debug("ezTalkGateNoticeBoardId=" + ezTalkGateNoticeBoardId);
		
		List<HashMap<String, Object>> boardItemList = ezBoardService.getBoardListItem(ezTalkGateNoticeBoardId, userInfo.getId(), 1, 5, 0, "", "", "1", userInfo.getTenantId());		
		
		String nowDate = commonUtil.getTodayUTCTime("");
	    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
	    
	    for (HashMap<String, Object> item : boardItemList) {
			if (item.get("WRITEDATE").toString().compareTo(nowDate) > 0) {
				item.put("ISNEW", "YES");
			} else {
				item.put("ISNEW", "NO");
			}
	    }
		
		model.addAttribute("boardItemList", boardItemList);
		
		logger.debug("noticeBoard ended.");
		
		return "ezTalkGate/noticeBoard";
	}

	@RequestMapping("/ezTalkGate/showNoticeBoardItem.do")
	public String showNoticeBoardItem(
					@CookieValue("loginCookie") String loginCookie,
					@RequestParam String itemId,
					Model model
					) throws Exception {
		logger.debug("showNoticeBoardItem started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		logger.debug("id=" + userInfo.getId() + ",tenantId=" + userInfo.getTenantId() + ",itemId=" + itemId);
				
        BoardListVO boardItem = ezBoardService.getBrdGetItemInfo("", itemId, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());        
        String writeDate = commonUtil.getDateStringInUTC(boardItem.getWriteDate(), userInfo.getOffset(), false);
        writeDate = writeDate.substring(0, writeDate.length() - 3);
        
        boardItem.setWriteDate(writeDate);
        
        model.addAttribute("boardItem", boardItem);
        
		logger.debug("showNoticeBoardItem ended.");
		
		return "ezTalkGate/showNoticeBoardItem";
	}

	@RequestMapping("/ezTalkGate/showNoticeBoardItemContent.do")
	public String showNoticeBoardItemContent(
					@CookieValue("loginCookie") String loginCookie,
					@RequestParam String itemId,
					HttpServletRequest request,
					Model model
					) throws Exception {
		logger.debug("showNoticeBoardItemContent started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		logger.debug("id=" + userInfo.getId() + ",tenantId=" + userInfo.getTenantId() + ",itemId=" + itemId);
				
        BoardListVO boardItem = ezBoardService.getBrdGetItemInfo("", itemId, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());        
        String realPath = commonUtil.getRealPath(request);
        
        String htmlData = ezCommonService.getMHTtoHTML("BOARDCONTENT", boardItem.getItemID(), userInfo.getTenantId(), realPath, request, userInfo.getLocale());
        
        model.addAttribute("htmlData", htmlData);
        
		logger.debug("showNoticeBoardItemContent ended.");
		
		return "ezTalkGate/showNoticeBoardItemContent";
	}
	
	private boolean checkIfUserExists(String id, String pw, int tenantId) throws Exception {
		logger.debug("checkIfUserExists started. id=" + id + ",tenantId=" + tenantId);
		
		boolean isUserExists = false;
		
		String encryptedPw = EgovFileScrty.encryptPassword(pw, id);
		
		logger.debug("encryptedPw=" + encryptedPw);
		
		LoginVO loginVO = new LoginVO();	
		
		loginVO.setId(id);
		loginVO.setPassword(encryptedPw);
		loginVO.setTenantId(tenantId);
		
		LoginVO resultVO = loginService.selectUser(loginVO);
		
		logger.debug("resultVO=" + resultVO);
		
		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) { 
			isUserExists = true;
		} 
		
		logger.debug("checkIfUserExists ended.");
		
		return isUserExists;
	}	
    
}
