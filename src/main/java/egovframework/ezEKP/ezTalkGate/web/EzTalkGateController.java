package egovframework.ezEKP.ezTalkGate.web;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezTalkGate.util.EzTalkGateUtil;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.web.LoginController;
import egovframework.let.utl.fcc.service.ClientUtil;
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
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private Properties config;

    @Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
    
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;

	@RequestMapping("/ezTalkGate/getUserCn.do")
	@ResponseBody
	public JSONObject getUserCn(@RequestParam String userId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getUserCn started.");

		Map<String, Object> result = new HashMap<>();
		String userCn = userId;
		// 1 성공 2 실패
		String value = "1";

		try {
			String serverName = request.getServerName();
			int tenantId = loginService.getTenantId(serverName);
			logger.debug("serverName={}, tenantId={}, uesrId={}", serverName, tenantId, userId);

			LoginVO login = new LoginVO();
			login.setId(userId);
			login.setDn("NOPASSWORD");
			login.setTenantId(tenantId);
			LoginVO user = loginService.selectUser(login);

			if (user == null || user.getId() == null) {
				value = "2";
			} else {
				userCn = user.getId();
			}
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			value = "2";
		}

		result.put("userCn", userCn);
		result.put("value", value);

		logger.debug("getUserCn ended. result={}", result);

		return new JSONObject(result);
	}

    @RequestMapping("/ezTalkGate/tokenLogin.do")
    @ResponseBody
    public String ezTalkTokenLogin(
    			@RequestParam String ezTalkId,
    			HttpServletRequest request,
    			HttpServletResponse response
    		) throws Exception{
    	logger.debug("ezTalkTokenLogin started.");
		String result = "Y";

		String serverName = request.getServerName();
		int tenantId = loginService.getTenantId(serverName);
		logger.debug("serverName=" + serverName + ",tenantId=" + tenantId);

		String userId = ezTalkGateUtil.decryptEzTalkAES(ezTalkId);
		logger.debug("userId=" + userId);

		try {
			String useMobileManagemant = ezCommonService.getTenantConfig("useMobileManagemant", tenantId);
			logger.debug("useMobileManagemant=" + useMobileManagemant);

			if (useMobileManagemant.equals("YES")) {
				String notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, userId, "notUseMobileLogin");
				String adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, userId,
				        "adminOrderNotUsedMobileLogin");

				// 전체 사용안함. 사용자, 관리자 설정
				if (adminOrderNotUsedMobileLogin.equals("1") || notUseAllMobileLogin.equals("1")) {
					logger.debug("userId=" + userId + ", no use mobile login by userconfig.");
					result = "N";
				} else {
					// 기능 사용하며, 기기별 검색
					String inputParams = "userId=" + userId + "&deviceId=";
					logger.debug("userId=" + userId + ",deviceId=");

					String requestURL = "/ezTalkGate/getUserMobileDeviceUsedInfo";
					String getResult = ezEmailUtil
					        .getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
					logger.debug("getResult=" + getResult);

					JSONParser parser = new JSONParser();
					JSONObject resultObj = (JSONObject) parser.parse(getResult);
					int mobileUsed = (resultObj.get("data").equals("")) ? 0
					        : Integer.valueOf(String.valueOf(resultObj.get("data")));

					if (mobileUsed > 0) {
						logger.debug("userId=" + userId + ", no use mobile login by deviceInfo.");
						result = "N";
					}

					if ("YES".equals(ezCommonService.getTenantConfig("useLoginStop", tenantId)) && ezOrganAdminService.checkStopUser(userId, tenantId) > 0) {
						// 사용자 정지 리턴
						logger.debug("userId={}, stoped user.", userId);
						result = "S";
					}
				}
			}
		} catch (Exception e) {
			result = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("ezTalkTokenLogin ended. mobileUsed=" + result);
		return result;
    }
	
    @RequestMapping("/ezTalkGate/login.do")
    @ResponseBody
	public String ezTalkLogin(
					@RequestParam String ezTalkId,
					@RequestParam String ezTalkPw,
					@RequestParam(required=false) String type,
					HttpServletRequest request,
					HttpServletResponse response
					) throws Exception {
		logger.debug("ezTalkLogin started.");
		String result = "FAIL";
		
		try {
			String serverName = request.getServerName();
	        int serverPort = request.getServerPort();
	        int tenantId = loginService.getTenantId(serverName);
	        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);

			String userId = ezTalkGateUtil.decryptEzTalkAES(ezTalkId);
			String userPw = ezTalkGateUtil.decryptEzTalkAES(ezTalkPw);
			type = (type == null) ? "" : type;
			logger.debug("type=" + type + "orgId=" + userId);
			
			boolean isUserExists = checkIfUserExists(userId, userPw, tenantId);
			logger.debug("isUserExists=" + isUserExists);
			
			if (isUserExists) {
				// 2023.09.22 한슬기 : 비밀번호가 만료되었는지 체크.
				LoginVO loginVO = new LoginVO();
				loginVO.setId(userId);
				loginVO.setTenantId(tenantId);
				loginVO.setDn("NOPASSWORD");
				LoginVO resultVO = loginService.selectUser(loginVO);
				
				String companyId = resultVO.getCompanyID();
				
				// 비밀번호 만료 주기 (일 단위, 0:사용안함)
				String expirePassPeriod = ezCommonService.getCompanyConfig(tenantId, companyId, "ExpirePassPeriod");
				expirePassPeriod = expirePassPeriod.trim().equals("") ? "0" : expirePassPeriod;

				// 비밀번호 만료기한 설정을 사용 하지 않을 경우
                if ("0".equals(expirePassPeriod.trim())) {
                    result = "OK";
                } else {	// 비밀번호 만료기한 설정을 사용 할 경우
					Date baseDT = getExpiryDeadline(expirePassPeriod,"yyyy-MM-dd HH:mm:ss");
					Date passwordUpdateDT = resultVO.getPassword_updatedt();

					if (passwordUpdateDT == null) {
						passwordUpdateDT = resultVO.getUpdateDT();
					}

					logger.debug("passwordUpdateDT : {}", passwordUpdateDT);
					logger.debug("baseDT : {}", baseDT);

					// 마지막 개인정보 수정일자 - 오늘 날짜 >= 0 -> 경우 비밀번호 만료기한이 지난 것
					int diff = EgovDateUtil.getDaysDiff(baseDT, passwordUpdateDT);
					logger.debug("diff : {}", diff);

					if (diff <= 0) {
						result = "PASSWORD_EXPIRED";
					} else {
						result = "OK";
					}
				}

                // 2018.10.25 yjks - 모바일 사용 설정 확인 추가
				// type이 M이면 모바일 로그인
				if (type.equals("M")) {
					String useMobileManagemant = ezCommonService.getTenantConfig("useMobileManagemant", tenantId);
					
					if (useMobileManagemant.equals("YES")) {
						String notUseAllMobileLogin = ezCommonService.getUserConfigInfo(tenantId, userId, "notUseMobileLogin");
						String adminOrderNotUsedMobileLogin = ezCommonService.getUserConfigInfo(tenantId, userId, "adminOrderNotUsedMobileLogin");
						
						if (adminOrderNotUsedMobileLogin.equals("1") || notUseAllMobileLogin.equals("1")) {
							logger.debug("userId=" + userId + ", no use mobile login by userconfig");
							result = "NOTUSE";
						} else {
							String inputParams = "userId=" + userId + "&deviceId=";
							logger.debug("userId=" + userId + ", deviceId=");
							
							String requestURL = "/ezTalkGate/getUserMobileDeviceUsedInfo";
							String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
							logger.debug("getResult=" + getResult);
							
							JSONParser parser = new JSONParser();
							JSONObject resultObj = (JSONObject) parser.parse(getResult);
							int mobileUsed = (resultObj.get("data").equals("")) ? 
												0 : Integer.valueOf(String.valueOf(resultObj.get("data")));
							
							if (mobileUsed > 0) {
								logger.debug("userId=" + userId + ", no use mobile login by deviceInfo");
								result = "NOTUSE";
							}
						}
					}
				}
				
				// 사용자정지 여부를 체크
				String useLoginStop = ezCommonService.getTenantConfig("useLoginStop", tenantId);
				
				if (useLoginStop != null && useLoginStop.equals("YES")) {
					int flag = ezOrganAdminService.checkStopUser(userId, tenantId);
					if(flag > 0) {
						result = "STOPUSER";
					}
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = "ERROR";
		}
		
		logger.debug("ezTalkLogin ended. mobile=" + result);
		return result;
    }

	private Date getExpiryDeadline(String expirePassPeriod, String pattern) throws Exception {
		int realPeriod = Integer.parseInt("-" + expirePassPeriod.trim());

		Calendar cal = Calendar.getInstance();
		SimpleDateFormat date = new SimpleDateFormat(pattern);

		String baseStr = commonUtil.getTodayUTCTime("");
		Date baseDT = date.parse(baseStr);

		cal.setTime(baseDT);
		cal.add(Calendar.DATE, realPeriod);

		baseDT = cal.getTime();
		return baseDT;
	}

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
		
		boolean isUserExists = checkIfUserExists(orgId, tenantId);
		
		logger.debug("isUserExists=" + isUserExists);
		
		if (isUserExists) {
			// 정지된 사용자는 그룹웨어로 접속할 수 없게 해야함
			String useLoginStop = ezCommonService.getTenantConfig("useLoginStop", tenantId);

			if ("YES".equals(useLoginStop)) {
				int flag = ezOrganAdminService.checkStopUser(orgId, tenantId);
				if (flag > 0) {
					logger.debug("stoped user: {}", orgId);
					logger.debug("ezTalkGateMain ended.");

					// 2021-12-28 이사라 : 로그인 실패 로그 저장
					LoginVO setVo = new LoginVO();
					setVo.setId(orgId);
					setVo.setTenantId(tenantId);
					setVo.setDn("NOPASSWORD");
					
					LoginVO user = loginService.selectUser(setVo);
					
					if (user != null && user.getId() != null && !user.getId().equals("")) { 
						user.setIp(ClientUtil.getClientIP(request));
						user.setAgent(ClientUtil.getClientInfo(request, "agent"));
						user.setOs(ClientUtil.getClientInfo(request, "os"));
						user.setBrowser(ClientUtil.getClientInfo(request, "browser"));
						user.setTenantId(tenantId);
						user.setStatus("N");
						
						if (user.getTitle2() == null) {
							user.setTitle2("");
						}
						
						loginService.insertLog(user);
					}
					
					return "cmm/error/stopedUserDenied";
				}
			}

			String encryptedPw = EgovFileScrty.encryptPassword(orgPw, orgId);
			
			OrganUserVO userVO = ezOrganAdminService.getUserInfo(orgId, "1", tenantId);
			String deptId = userVO.getDepartment();
			String compId = userVO.getPhysicalDeliveryOfficeName();
			
			// sso 접속시에도 로그인 이력 남도록 추가  
			LoginVO setVo = new LoginVO();
			setVo.setId(orgId);
			setVo.setTenantId(tenantId);
			setVo.setDn("NOPASSWORD");
			
			LoginVO vo = loginService.selectUser(setVo);
			
			// 2021-12-28 이사라 : 세션ID를 세션코드로 입력 
        	String sessionCode =  request.getSession().getId();
        	logger.debug("Login sessionCode = " + sessionCode);
        	
			vo.setIp(ClientUtil.getClientIP(request));
			vo.setAgent(ClientUtil.getClientInfo(request, "agent"));
			vo.setOs(ClientUtil.getClientInfo(request, "os"));
			vo.setBrowser(ClientUtil.getClientInfo(request, "browser"));
			vo.setTenantId(tenantId);
			vo.setStatus("Y");
			vo.setSessionCode(sessionCode);
			
			if (vo.getTitle2() == null) {
				vo.setTitle2("");
			}
			
			loginService.insertLog(vo);
			
			loginController.createLoginCookie(orgId, orgPw, encryptedPw, tenantId, request, response, deptId, compId);
						
			logger.debug("ezTalkGateMain ended.");
			
			if (ezTalkSsoType.equals("mail")) {
				return "redirect:/ezEmail/mailMain.do";
			} else if (ezTalkSsoType.equals("approval")) { 
				return "redirect:/ezApprovalG/apprGMain.do";
			} else if (ezTalkSsoType.equals("portal")) { 
				return "redirect:/ezPortal/portalMain.do";
			} else if (ezTalkSsoType.equals("noticeBoard")) { 
				return "redirect:/ezTalkGate/noticeBoard.do?ezTalkId=" + URLEncoder.encode(orgId, "UTF-8") + "&ezTalkPw=" + URLEncoder.encode(ezTalkPw, "UTF-8");
			} else if (ezTalkSsoType.equals("noticeBoard2")) { 
				return "redirect:/ezTalkGate/noticeBoard2.do";
			} else if (ezTalkSsoType.equals("mailWrite")) { 
				String emailAddress = request.getParameter("emailAddress") == null ? "" : request.getParameter("emailAddress");
				String name = request.getParameter("name") == null ? "" : request.getParameter("name");
				String to = request.getParameter("to") == null ? "" : request.getParameter("to");
				
				// 단일 수신자의 경우
				if (!emailAddress.equals("")) {
					name = name.equals("") ? emailAddress : name;
					String msgTo = String.format("%s <%s>", name, emailAddress);
					
					logger.debug("msgTo=" + msgTo);
					
					// 자기 자신이 수신자인 경우
					if (emailAddress.equalsIgnoreCase(vo.getEmail())) {
						logger.debug("isMailToMe=YES");
						
						return "redirect:/ezEmail/mailWrite.do?cmd=NEW&msgto=" + URLEncoder.encode(msgTo, "UTF-8") + "&isMailToMe=YES";
					} else {					
						return "redirect:/ezEmail/mailWrite.do?cmd=NEW&msgto=" + URLEncoder.encode(msgTo, "UTF-8");
					}
				// 다중 수신자의 경우
				} else if (!to.equals("")) { 
					logger.debug("to=" + to);
					
					// 수신자에 자기 자신이 포함되어 있는 경우
					if (to.contains("<" + vo.getEmail() + ">")) {
						logger.debug("isMailToMe=YES");
						
						return "redirect:/ezEmail/mailWrite.do?cmd=NEW&msgto=" + URLEncoder.encode(to, "UTF-8") + "&isMailToMe=YES";
					} else {
						return "redirect:/ezEmail/mailWrite.do?cmd=NEW&msgto=" + URLEncoder.encode(to, "UTF-8");
					}
				} else {
					return "redirect:/ezEmail/mailWrite.do?cmd=NEW";
				}
			} else {
				return "";
			}
		} else {
			logger.debug("ezTalkGateMain ended.");
			
			return "redirect:/user/login/login.do";
		}
	}
	
	@RequestMapping("/ezTalkGate/noticeBoardDetailList.do")
	public String noticeBoardDetailList(
			@RequestParam String boardType,
			@RequestParam String ezTalkId,
			@RequestParam String ezTalkPw,
			HttpServletRequest request, 
			HttpServletResponse response) {
		logger.debug("noticeBoardDetailList started.");
		
		String redirectUrl = "redirect:/user/login/login.do";
		
		try {
			String orgId = ezTalkId;
			String orgPw = ezTalkGateUtil.decryptEzTalkAES(ezTalkPw);
			logger.debug("ezTalkId=" + orgId + ",ezTalkPw=" + orgPw);
			
			String serverName = request.getServerName();
			int serverPort = request.getServerPort();
			int tenantId = loginService.getTenantId(serverName);
			logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
			
			boolean isUserExists = checkIfUserExists(orgId, tenantId);
			logger.debug("isUserExists=" + isUserExists);
			
			if (isUserExists) {
				String encryptPw = EgovFileScrty.encryptPassword(orgPw, orgId);
				
				LoginVO setVo = new LoginVO();
				setVo.setId(orgId);
				setVo.setTenantId(tenantId);
				setVo.setDn("NOPASSWORD");
				
				LoginVO vo = loginService.selectUser(setVo);
				logger.debug("id=" + orgId + ", pw=" + encryptPw + ", companyId=" + vo.getCompanyID());
				
				String ezTalkGateNoticeBoardId = ezBoardService.getEzTalkGateNoticeBoardId(vo.getCompanyID(), tenantId);
				logger.debug("ezTalkGateNoticeBoardId=" + ezTalkGateNoticeBoardId);
				
				OrganUserVO userVO = ezOrganAdminService.getUserInfo(orgId, "1", tenantId);
				String deptId = userVO.getDepartment();
				String compId = userVO.getPhysicalDeliveryOfficeName();
				
				loginController.createLoginCookie(orgId, orgPw, encryptPw, tenantId, request, response, deptId, compId);
								
	        	if (ezTalkGateNoticeBoardId != null) {
					redirectUrl = "redirect:/ezBoard/boardMainRedirect.do?boardID="
									+ URLEncoder.encode(ezTalkGateNoticeBoardId, "UTF-8");
	        	}

	        	logger.debug("redirectUrl=" + redirectUrl);
			}
			 
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("noticeBoardDetailList ended.");
		return redirectUrl;
	}
	
	@RequestMapping("/ezTalkGate/noticeBoard.do")
	public String noticeBoard(
					@CookieValue("loginCookie") String loginCookie,
					Model model,
					HttpServletRequest request,
					HttpServletResponse response
					) throws Exception {
		logger.debug("noticeBoard started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		logger.debug("id=" + userInfo.getId() + ",tenantId=" + userInfo.getTenantId());
		
		String ezTalkId = request.getParameter("ezTalkId") != null ? request.getParameter("ezTalkId") : "";
		String ezTalkPw = request.getParameter("ezTalkPw") != null ? request.getParameter("ezTalkPw") : "";
		logger.debug("ezTalkId = " + ezTalkId);
		logger.debug("ezTalkPw = " + ezTalkPw);
		
		String ezTalkGateNoticeBoardId = ezBoardService.getEzTalkGateNoticeBoardId(userInfo.getCompanyID(), userInfo.getTenantId());
		logger.debug("ezTalkGateNoticeBoardId=" + ezTalkGateNoticeBoardId);
		
		List<HashMap<String, Object>> boardItemList = ezBoardService.getBoardListItem(ezTalkGateNoticeBoardId, 
				userInfo.getId(), 1, 5, 0, "", "", new HashMap<String, String>(), "1", userInfo.getTenantId());		
		logger.debug("boardItemList=" + boardItemList);
		
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
		model.addAttribute("noticeBoardID", ezTalkGateNoticeBoardId);
		model.addAttribute("ezTalkId", ezTalkId);
		model.addAttribute("ezTalkPw", ezTalkPw);
		
		logger.debug("noticeBoard ended.");
		
		return "ezTalkGate/noticeBoard";
	}

	@RequestMapping("/ezTalkGate/noticeBoard2.do")
	public String noticeBoard2(
					@CookieValue("loginCookie") String loginCookie,
					Model model
					) throws Exception {
		logger.debug("noticeBoard2 started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		logger.debug("id=" + userInfo.getId() + ",tenantId=" + userInfo.getTenantId());
		
		String ezTalkGateNoticeBoardId2 = ezCommonService.getTenantConfig("ezTalkGateNoticeBoardId2", userInfo.getTenantId());
		
		logger.debug("ezTalkGateNoticeBoardId2=" + ezTalkGateNoticeBoardId2);
		
		List<HashMap<String, Object>> boardItemList = ezBoardService.getBoardListItem(ezTalkGateNoticeBoardId2, userInfo.getId(), 1, 5, 0, "", "", new HashMap<String, String>(), "1", userInfo.getTenantId());		
		
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
		model.addAttribute("noticeBoardID", ezTalkGateNoticeBoardId2);
		
		logger.debug("noticeBoard2 ended.");
		
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
        
        /* 2019-09-11 홍승비 - 톡에서 공지사항 게시물 읽을 경우, 조회수 업데이트 및 조회자 정보 삽입되도록 수정 */
        ezBoardService.setAsRead(userInfo, boardItem.getBoardID(), boardItem.getItemID());
        
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
        String scheme = "http://";
		
    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
    		scheme = "https://";
    	}
        
        String htmlData = ezCommonService.getMHTtoHTML("BOARDCONTENT", boardItem.getItemID(), userInfo.getTenantId(), realPath, request, userInfo.getLocale(), scheme);
        
        model.addAttribute("htmlData", htmlData);
        
		logger.debug("showNoticeBoardItemContent ended.");
		
		return "ezTalkGate/showNoticeBoardItemContent";
	}
	
	@RequestMapping("/ezTalkGate/checkBlockedByIP.do")
	@ResponseBody
	public String checkBlockedByIP(@RequestParam String ezTalkId, @RequestParam String ip, HttpServletRequest request, Model model) throws Exception {
		logger.debug("checkBlockedByIP started.");
		// FAIL 에러발생, 0 밴 된 유저, 1 정상 유저
		String result = "FAIL";

		try {
			String serverName = request.getServerName();
			int tenantId = loginService.getTenantId(serverName);
			String userId = ezTalkGateUtil.decryptEzTalkAES(ezTalkId);

			logger.debug("serverName={}, tenantId={}, orgId={}, ip={}", serverName, tenantId, userId, ip);

			LoginVO loginVO = new LoginVO();
			loginVO.setId(userId);
			loginVO.setTenantId(tenantId);
			loginVO.setDn("NOPASSWORD");
			loginVO = loginService.selectUser(loginVO);
			loginVO.setIp(ip);

			result = loginController.ipAccessCheck(loginVO) ? "1" : "0";
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
		}

		logger.debug("checkBlockedByIP ended. result={}", result);

		return result;
	}
	
	@RequestMapping("/ezTalkGate/getModuleNotice.do")
	@ResponseBody
	// jwseo99 리팩토링 해야됨
	public String getModuleNotice(@RequestParam String ezTalkId, @RequestParam String type, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getModuleNotice started.");
		String result = "FAIL";

		try {
			String serverName = request.getServerName();
			int tenantId = loginService.getTenantId(serverName);
			String userId = ezTalkGateUtil.decryptEzTalkAES(ezTalkId);

			logger.debug("serverName={}, tenantId={}, orgId={}, type={}", serverName, tenantId, userId, type);

			int mailCount = 0;
			int approvalCount = 0;
			boolean isMailType = type.contains("M");
			boolean isApprovalType = type.contains("A");
			boolean isAll = isMailType && isApprovalType;

			Map<String, Object> parameters = new HashMap<>();
			// "{"useQuestion":"NO","useCircular":"NO","useMail":"YES","useApproval":"YES","useSchedule":"YES"}"
			parameters.put("useQuestion", "NO");
			parameters.put("useCircular", "NO");
			parameters.put("useSchedule", "NO");
			parameters.put("useMail", "YES");
			parameters.put("useApproval", "YES");

			String url = "/rest/ezPortal/settingInfo/unreadCounts/users/" + userId;

			JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, parameters, request, "get", null);
			String status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				JSONObject data = (JSONObject) resultBody.get("data");
				// data.get("pollCount");
				// data.get("circularCount");
				// data.get("scheduleCount");
				mailCount = Optional.ofNullable(data.get("unreadMailCount")).map(Object::toString).map(Integer::parseInt).orElse(0);
				approvalCount = Optional.ofNullable(data.get("approvalCount")).map(Object::toString).map(Integer::parseInt).orElse(0);
			}

			if (isAll) {
				if (type.startsWith("M")) {
					result = String.format("%d/%d", mailCount, approvalCount);
				} else {
					result = String.format("%d/%d", approvalCount, mailCount);
				}
			} else {
				result = Integer.toString(isMailType ? mailCount : approvalCount);
			}
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
		}

		logger.debug("getModuleNotice ended. result={}", result);

		return result;
	}
	
	@RequestMapping("/ezTalkGate/getNotUseMobileUserList.do")
	@ResponseBody
	public String getNotUseMobileUserList(HttpServletRequest request, Model model) throws Exception {
		logger.debug("getNotUseMobileUserList started.");

		String result = "[]";

		try {
			String serverName = request.getServerName();
			int tenantId = loginService.getTenantId(serverName);
			logger.debug("serverName={}, tenantId={}", serverName, tenantId);

			List<String> userList = ezOrganAdminService.getNotUseMobileUserList(tenantId);
			result = JSONArray.toJSONString(userList);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
		}

		logger.debug("getNotUseMobileUserList ended. result={}", result);

		return result;
	}

	private boolean checkIfUserExists(String id, int tenantId) throws Exception {
		return checkIfUserExists(id, null, tenantId);
	}

	private boolean checkIfUserExists(String id, String pw, int tenantId) throws Exception {
		logger.debug("checkIfUserExists started. id=" + id + ",tenantId=" + tenantId);
		
		boolean isUserExists = false;
		
		LoginVO loginVO = new LoginVO();	
		//tenantId = 0;
		loginVO.setId(id);
		loginVO.setTenantId(tenantId);

		if (pw == null) {
			loginVO.setDn("NOPASSWORD");
		} else {
			//String encryptedPw = EgovFileScrty.encryptPassword(pw, id);
			loginVO.setDn("NOPASSWORD");
			LoginVO resultVO = loginService.selectUser(loginVO);
			String encryptedPw = EgovFileScrty.encryptPassword(pw, resultVO.getId());

			logger.debug("encryptedPw=" + encryptedPw);

			loginVO.setPassword(encryptedPw);
		}
		
		// AD 패스워드 체크
		if (ezCommonService.getTenantConfig("USE_AD", tenantId).equalsIgnoreCase("YES")) {
        	// true 이면 그룹웨어 암호 변경
        	// false 이면 그냥 로그인 금지
        	String chkADpass = loginService.chkADAndUpdatePassword(id, pw, tenantId);
        	
        	if (chkADpass.equalsIgnoreCase("false")) {
        		// vo의 password에 null 값을 넣어서 selectUser에서 무조건 암호가 틀리게 한다.
        		isUserExists = false;            		
        	}
        }
		
		LoginVO resultVO = loginService.selectUser(loginVO);
		
		logger.debug("resultVO={}", resultVO);
		
		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
			// 공유사서함 기능을 사용할 경우 공유사서함 계정으로의 로그인을 막는다.
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
			
			if (useSharedMailbox.equals("YES") && resultVO.getDeptID() != null && resultVO.getDeptID().startsWith("shared_mailbox_")) {
				logger.debug("Cannot login with shared mailbox account.");
			} else {
				isUserExists = true;
			}
		}
		
		logger.debug("checkIfUserExists ended.");
		
		return isUserExists;
	}	
    
}
