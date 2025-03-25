package egovframework.ezEKP.ezPersonal.web;

import com.sun.org.apache.xml.internal.security.utils.Base64;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOutOfOfficeInfoVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezOrgan.web.EzOrganAdminController;
import egovframework.ezEKP.ezPersonal.service.EzPersonalAdminService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.vo.*;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.rest.Result;
import egovframework.let.utl.sim.service.EgovFileScrty;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.LocaleResolver;
import org.w3c.dom.Document;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.geom.Ellipse2D;
import java.awt.image.BufferedImage;
import java.awt.image.PixelGrabber;
import java.io.*;
import java.nio.file.Files;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.*;
import java.util.stream.Collectors;

/** 
 * @Description [Controller] 사용자 - Personal
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.07.20    황윤진         신규작성
 *
 * @see
 */

@Controller
public class EzPersonalController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EzPersonalController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EgovMessageSource messageSource;
	
	@Resource(name = "crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;
	
	@Resource(name = "EzPersonalAdminService")
	private EzPersonalAdminService ezPersonalAdminService;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="EzPortalAdminService")
	private EzPortalAdminService ezPortalAdminService;
	
	@Resource(name="EzPortalService")
	private EzPortalService ezPortalService;
	
	@Autowired
    private LocaleResolver localeResolver;
	
	@Autowired
    private EzEmailUtil ezEmailUtil;
	
	@Autowired
    private LoginService loginService;

	@Autowired
	private EzOrganAdminController ezOrganAdminController;
	
    // dhlee
    @Autowired
    private EzEmailUserAdminService ezEmailUserAdminService;
    // dhlee - end

	@Resource(name = "EzNewPortalService")
	private EzNewPortalService ezNewPortalService;
	
	public void setLocaleResolver(LocaleResolver localeResolver) {
    	this.localeResolver = localeResolver;
    }
	
	/**
	 * 전자결재 부재자설정 끄기 Method
	 */	
	@RequestMapping(value = "/ezPersonal/saveBujae.do", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String saveBujae(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("saveBujae started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String buJaeInfo = request.getParameter("buJae");
		String buJaeInfo2 = "";
		String proxyInfo = request.getParameter("proxy");
		String dept = request.getParameter("dept");
		String buJaeId = request.getParameter("buJaeId");
//		String proxyInfo2 = "";
		// 전자결재만 존재하면 아래와 같이 "user"로 하드코딩이 가능하나, 다른 모듈 존재 시 수정 필요함
		String pClass = "user";
		if (buJaeInfo != null && !buJaeInfo.equals("")) {
			if (buJaeInfo.split(":").length >= 5) {
				buJaeInfo2 = buJaeInfo.split(":")[0] + ":" + buJaeInfo.split(":")[1] + ":" + buJaeInfo.split(":")[2] + ":" + buJaeInfo.split(":")[3] + ":" + buJaeInfo.split(":")[4] + ":" + buJaeInfo.split(":")[5] + ":"  + buJaeInfo.split(":")[6];
			}
			
			if (buJaeInfo.split(":").length > 7) {
				buJaeInfo2 +=  ":" + buJaeInfo.split(":")[7];
			}
		}
		
		String result = "";
		String userRealDeptId = "";
		
		if (buJaeId == null || buJaeId.equals("")) {
			userRealDeptId = ezOrganService.getUserOrgDeptId(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
			if (dept == null || dept.equals("") || dept.equals(userRealDeptId)) {
				result = ezOrganService.updateProperty(userInfo.getId(), "extensionAttribute5", buJaeInfo2, pClass, userInfo.getTenantId());
			} else {
				result = ezOrganService.updateAddJobProxy(userInfo.getId(), buJaeInfo2, userInfo.getTenantId(), dept);
			}
		} else {
			userRealDeptId = ezOrganService.getUserOrgDeptId(buJaeId, userInfo.getTenantId(), userInfo.getCompanyID());
			if (dept == null || dept.equals("") || dept.equals(userRealDeptId)) {
				result = ezOrganService.updateProperty(buJaeId, "extensionAttribute5", buJaeInfo2, pClass, userInfo.getTenantId());
			} else {
				result = ezOrganService.updateAddJobProxy(buJaeId, buJaeInfo2, userInfo.getTenantId(), dept);
			}
		}
		
		
		
		if (result.equals("OK")) {
//			if (proxyInfo.split(":").length >= 5) {
//				proxyInfo2 = proxyInfo.split(":")[0] + ":" + proxyInfo.split(":")[1] + ":" + proxyInfo.split(":")[3] + ":" + proxyInfo.split(":")[4];
//			}
			
		/*	if (proxyInfo.split(":")[0].trim().equals("")) {
				result = ezOrganService.delProxyUserInfo(userInfo.getId(), userInfo.getTenantId());
			} else {
				result = ezOrganService.setProxyUserInfo(userInfo.getId(), p roxyInfo.split(":")[0], proxyInfo.split(":")[1], proxyInfo.split(":")[2], proxyInfo.split(":")[3]+":"+proxyInfo.split(":")[4].replace("/", ":"), proxyInfo.split(":")[5]+":"+proxyInfo.split(":")[6].replace("/", ":"), userInfo.getTenantId(), userInfo.getOffset());
			}*/
			if (buJaeId == null || buJaeId.equals("")) {
				if (proxyInfo.split("\\|")[0].trim().equals("")) {
					result = ezOrganService.delProxyUserInfo(userInfo.getId(), userInfo.getTenantId());
				} else {
					result = ezOrganService.setProxyUserInfo(userInfo.getId(), proxyInfo.split("\\|")[0], proxyInfo.split("\\|")[1], proxyInfo.split("\\|")[2], proxyInfo.split("\\|")[3], proxyInfo.split("\\|")[4], userInfo.getTenantId(), userInfo.getOffset());
				}
			} else {
				if (proxyInfo.split("\\|")[0].trim().equals("")) {
					result = ezOrganService.delProxyUserInfo(buJaeId, userInfo.getTenantId());
				} else {
					result = ezOrganService.setProxyUserInfo(buJaeId, proxyInfo.split("\\|")[0], proxyInfo.split("\\|")[1], proxyInfo.split("\\|")[2], proxyInfo.split("\\|")[3], proxyInfo.split("\\|")[4], userInfo.getTenantId(), userInfo.getOffset());
				}
			}
			
		}

		logger.debug("saveBujae ended");
		return result;
	}
	
	/**
	 * 전자결재 결재환경설정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/ezApprovalConfig.do", method = RequestMethod.GET)
	public String ezApprovalConfig(Model model, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception{
		logger.debug("ezApprovalConfig started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String useShareApproval = ezCommonService.getTenantConfig("useShareApproval", userInfo.getTenantId());
		String autoSaveFlag = ezCommonService.getTenantConfig("AprAutoSaveFlag", userInfo.getTenantId());
		
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useShareApproval", useShareApproval);
		model.addAttribute("autoSaveFlag", autoSaveFlag);
		
		logger.debug("ezApprovalConfig ended");
		return "ezPersonal/persEzApprovalConfig";
	}
	
	/**
	 * 전자결재 결재환경설정 암호사용설정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/approvalConfig.do", method = RequestMethod.GET)
	public String approvalConfig(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("approvalConfig started");

		userInfo = commonUtil.userInfo(loginCookie);
		String flag = "";
		String pwd = "";
		String pwdType = "";
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		ApprovPWDVO approvPWDVO = ezCommonService.getApprovPWD(userInfo);
		
		if (approvPWDVO != null) {
			flag = approvPWDVO.getFlag();
			pwd = approvPWDVO.getPwd();
			pwdType = approvPWDVO.getPwdType();
		}
		
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("pwdType", pwdType);
		model.addAttribute("pwd", pwd);
		model.addAttribute("flag", flag);
		model.addAttribute("userID", userInfo.getId());

		logger.debug("approvalConfig ended");
		return "ezPersonal/persApprovalConfig";
	}
	
	/**
	 * 전자결재 결재환경설정 암호사용설정 비번체크 표출 Method
	 */
	@RequestMapping(value = "/ezPersonal/confirmPassword.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String confirmPassword(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("confirmPassword started");
		userInfo = commonUtil.userInfo(loginCookie);
		String result = "";

        String oldPass = request.getParameter("oldPassword");
		String loginPass = ezOrganService.getEncPassword(userInfo.getId(), userInfo.getTenantId());
		String newPass = request.getParameter("newPassword");
		String userID = request.getParameter("userID");
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String newTempPass = EgovFileScrty.decryptRsa(pk, newPass);
		String newPassword = EgovFileScrty.encryptPassword(newTempPass, userID);
		
		// 결재 암호나 로그인 암호가 같으면 인증되게 처리
		if (loginPass.trim().equals(newPassword) || oldPass.trim().equals(newPassword)) {
			result = "OK";
		} else {
			result = "FAIL";
		}
		
		logger.debug("confirmPassword ended");
		return result;
	}
	
	/**
	 * 전자결재 결재환경설정 암호사용설정 비번저장 표출 Method
	 */
	@RequestMapping(value = "/ezPersonal/saveConfig.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveConfig(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("saveConfig started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String flag = request.getParameter("flag");
		String newPWD = request.getParameter("newPWD");
		String pwdType = request.getParameter("pwdType");
		String newPassword = "";
		if (newPWD.isEmpty()) {
			newPassword = ezOrganService.getEncPassword(userInfo.getId(), userInfo.getTenantId());
		} else {
			String newTempPass = EgovFileScrty.decryptRsa(pk, newPWD);
			newPassword = EgovFileScrty.encryptPassword(newTempPass, userInfo.getId());
		}
		
		String result = ezPersonalService.setApprovalPwd(userInfo.getId(), flag, newPassword, pwdType, userInfo.getTenantId(), userInfo.getCompanyID());

		logger.debug("saveConfig ended");
		return result;
	}
	
	/**
	 * 전자결재 결재환경설정 부재자설정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/manageBujaeG.do", method = RequestMethod.GET)
	public String manageBujae(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Locale locale, Model model) throws Exception{
		logger.debug("manageBujae started");

		userInfo = commonUtil.userInfo(loginCookie);
		String userID = "";
		String deptID = "";
		String startDate = "";
		String endDate = "";
		String bReason = "";
		String textName = "";
		String proxyUserID = "";
		String proxyDeptID = "";
		String proxyUserName = "";
		String textProxyName = "";
		String initDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		String result = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute5", userInfo.getTenantId());
		String cDate = "";
		String cTime = "";
		if (result != null && !result.equals("")) {
			String[] info = result.split(":");
			
			userID = info[0];
			String lang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
			textName = ezOrganService.getPropertyValue(info[0], "displayname" + lang, userInfo.getTenantId());
			deptID = info[2];
			startDate = info[3] + ":" + info[4];
			endDate = info[5] + ":" + info[6];
			
			if (info.length > 7) {
				bReason = info[7];
			}
		} else {
			cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false);
			cTime = cDate.split(" ")[1].substring(0, 2);
			
			cDate = cDate.substring(0, 10);
			startDate = cDate + " " + cTime + ":00:00";
			
			cDate = cDate.substring(0, 10);
			endDate = cDate + " " + String.format("%02d", Integer.parseInt(cTime) + 1) + ":00:00";
			
			deptID = userInfo.getDeptID();		// 2020-09-16 김민성 - 현재 설정된 대리 결재자 정보가 없는 경우 사용자의 부서 정보를 가져온다
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().toLowerCase().indexOf("a=1;") > -1) {
			result = ezOrganService.getProxyUserInfo(userInfo.getId(), userInfo.getTenantId(), userInfo.getOffset());
			
			Document xmlDom = commonUtil.convertStringToDocument(result);
			
			if (xmlDom.getElementsByTagName("PROXYUSERID").getLength() > 0) {
				proxyUserID = xmlDom.getElementsByTagName("PROXYUSERID").item(0).getTextContent();
				proxyDeptID = xmlDom.getElementsByTagName("PROXYUSERDEPTID").item(0).getTextContent();
				proxyUserName = xmlDom.getElementsByTagName("PROXYUSERNAME").item(0).getTextContent();
				/*startDate = commonUtil.getDateStringInUTC(xmlDom.getElementsByTagName("STARTDATE").item(0).getTextContent().substring(0, 16), userInfo.getOffset(), false);
				endDate = commonUtil.getDateStringInUTC(xmlDom.getElementsByTagName("ENDDATE").item(0).getTextContent().substring(0, 16), userInfo.getOffset(), false);*/
				startDate = xmlDom.getElementsByTagName("STARTDATE").item(0).getTextContent();
				endDate = xmlDom.getElementsByTagName("ENDDATE").item(0).getTextContent();
				
				textProxyName = proxyUserName;
			}
		}
		
		if (bReason.trim().equals("")) {
			bReason = messageSource.getMessage("ezPersonal.t35", locale);
		}
		
		//겸직리스트 
		List<OrganUserVO> addJobList = ezOrganAdminService.getUserAddJobList(userInfo.getId(), userInfo.getPrimary(), userInfo.getTenantId());
		
		model.addAttribute("addJobList", addJobList);
		model.addAttribute("deptID", deptID);
		model.addAttribute("userID", userID);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("bReason", bReason);
		model.addAttribute("proxyUserID", proxyUserID);
		model.addAttribute("proxyDeptID", proxyDeptID);
		model.addAttribute("proxyUserName", proxyUserName);
		model.addAttribute("initDate", initDate);
		model.addAttribute("textName", textName);
		model.addAttribute("textProxyName", textProxyName);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalFlag", approvalFlag);

		logger.debug("manageBujae ended");
		return "ezPersonal/persManageBujae";
	}
	
	/**
	 * 전자결재 결재환경설정 부재자설정 지정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/selectPerson.do", method = RequestMethod.GET)
	public String selectPerson(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("selectPerson started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String type = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(request.getParameter("type")));
		String dept = request.getParameter("dept"); 
		String tagName = request.getParameter("tagName");
		String companyID = Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID());

		String uploadPortalPath = commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		userInfo.setDeptID(dept);
		
		model.addAttribute("dept", dept);
		model.addAttribute("type", type);
		model.addAttribute("tagName", tagName);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("companyID", companyID);
		model.addAttribute("uploadPortalPath", uploadPortalPath);

		logger.debug("selectPerson ended");
		return "ezPersonal/persSelectPerson";
	}
	
	/**
	 * 전자결재 결재환경설정 부재자설정 조직도 관련 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/checkName2.do", method = RequestMethod.GET)
	public String checkName2() throws Exception{
		return "ezPersonal/persCheckName2";
	}
	
	/**
	 * 전자결재 결재환경설정 알림메일설정 호출 Method
	 * @deprecated 알림환경설정 도입에 의해 사용되지 않음
	 */
	@RequestMapping(value = "/ezPersonal/setApprovNoticeMail.do", method = RequestMethod.GET)
	@Deprecated
	public String setApprovNoticeMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("setApprovNoticeMail started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String alert = "0";
		String complete = "0";
		String bansong = "0";
		String hesong = "0";
		String callBack = "0";
		String saveMailFlag = "0";
		String linePass = "0";
		
		String result = ezPersonalService.getApprovNotiConfig(userInfo.getId(), userInfo.getId(), userInfo.getTenantId());
		
		Document xmlDom = commonUtil.convertStringToDocument(result);
		
		if (xmlDom.getElementsByTagName("ALERT").getLength() > 0) {
			alert = xmlDom.getElementsByTagName("ALERT").item(0).getTextContent();
			complete = xmlDom.getElementsByTagName("COMPLETE").item(0).getTextContent();
			bansong = xmlDom.getElementsByTagName("BANSONG").item(0).getTextContent();
			hesong = xmlDom.getElementsByTagName("HESONG").item(0).getTextContent();
			callBack = xmlDom.getElementsByTagName("CALLBACK").item(0).getTextContent();
			saveMailFlag = xmlDom.getElementsByTagName("SAVEMAILFLAG").item(0).getTextContent();
			linePass = xmlDom.getElementsByTagName("LINEPASS").item(0).getTextContent();
		}
		
		model.addAttribute("alert", alert);
		model.addAttribute("complete", complete);
		model.addAttribute("bansong", bansong);
		model.addAttribute("hesong", hesong);
		model.addAttribute("callBack", callBack);
		model.addAttribute("saveMailFlag", saveMailFlag);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useSaveSentMail", "YES".equalsIgnoreCase(config.getProperty("config.SentMailStoredInSentbox", "YES")));
		model.addAttribute("linePass", linePass);

		logger.debug("setApprovNoticeMail ended");
		return "ezPersonal/persSetApprovNoticeMail";
	}
	
	/**
	 * 전자결재 결재환경설정 알림메일설정 표출 Method
	 * @deprecated 알림환경설정 도입에 의해 사용되지 않음
	 */
	@RequestMapping(value = "/ezPersonal/setPersonalNotiMail.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	@Deprecated
	public String setPersonalNotiMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("setPersonalNotiMail started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String[] flagList = request.getParameter("email").split(";");
		String saveMailFlag = request.getParameter("sentBoxSave");
		String linePass = request.getParameter("linePass");
		
		String result = ezPersonalService.setApprovNotiMail(userInfo.getId(), flagList[0], flagList[1], flagList[2], flagList[3], flagList[4], saveMailFlag, userInfo.getTenantId(), linePass);

		logger.debug("setPersonalNotiMail ended");
		return result;
	}
	
	@RequestMapping(value = "/ezPersonal/signimageConfig.do", method = RequestMethod.GET)
	public String signimageConfig(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("signimageConfig started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String signPath = "APPROVALGSIGN";
		String signImageSize = "4";
		
		signImageSize = ezCommonService.getTenantConfig("SignImageSizeLimit", userInfo.getTenantId());
		
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("signPath", signPath);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("signimageConfig ended");
		return "ezPersonal/persSignimageConfig";
	}
	
	/**
	 * 포탈 설문조사 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/homePollListUser.do", method = RequestMethod.GET)
	public String homePollListUser(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception{
		logger.debug("homePollListUser started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		int currentPage;
		int pageSize = 15;
		boolean isPollEmpty = false;
		String votePoll = "";
		
		if (req.getParameter("page") != null && !req.getParameter("page").equals("")) {
			currentPage = Integer.parseInt(req.getParameter("page"));
		} else {
			currentPage = 1;
		}
		
		int totalCount = ezPersonalService.getPollCount(userInfo.getCompanyID(), userInfo.getTenantId());
		
		List<PersonalLightPollVO> list = ezPersonalService.getPollListUser(userInfo.getCompanyID(), totalCount, pageSize, Math.multiplyExact(Math.subtractExact(currentPage, 1), pageSize), userInfo.getTenantId());
		
		int pageCount = ((totalCount + pageSize - 1) / pageSize);
		
		if (list.size() == 0) {
			isPollEmpty = true;
		} else {
			/* 2021-09-01 홍승비 - 빠른설문의 시작일, 종료일 시간단위는 처음 생성 시 UTC시간이 아니라 00:00:01, 23:59:59로 고정되어 저장되므로 UTC시간 변경하지 않음 */
            // 2023-01-13 전인하 - 타임존을 적용하여 UTC 시간으로 수정 (빠른설문 > DB에 들어가는 값이 UTC 시간으로 변경됨에 따라 비교조건도 UTC 시간으로 수정)
			for (int i=0; i<list.size(); i++) {
				if (commonUtil.getDateStringInUTC(list.get(i).getEndDate(), userInfo.getOffset(), false).indexOf("1900-01-01") > -1) {
					list.get(i).setEndDate(egovMessageSource.getMessage("ezPersonal.t244",locale));
				} else {
                    list.get(i).setEndDate(commonUtil.getDateStringInUTC(list.get(i).getEndDate(), userInfo.getOffset(), false).substring(0, 10));
				}
                list.get(i).setStartDate(commonUtil.getDateStringInUTC(list.get(i).getStartDate(), userInfo.getOffset(), false).substring(0, 10));
				
				if (userInfo.getPrimary().equals("2") && list.get(i).getPollTitle2() != null && !list.get(i).getPollTitle2().equals("")) {
					list.get(i).setPollTitle(list.get(i).getPollTitle2());
				}
				
				PersonalLightPollVO result = ezPersonalService.getCurrentPoll(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getOffset());
				
				if (result != null) {
					if (result.getResult() == 0) {
						votePoll = String.valueOf(result.getItemSeq());
					} else {
						votePoll = "";
					}
				}
			}
		}
		
		model.addAttribute("list", list);
		model.addAttribute("votePoll", votePoll);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("pageCount", pageCount);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("isPollEmpty", isPollEmpty);
		model.addAttribute("pageSize", pageSize);

		logger.debug("homePollListUser ended");
		return "ezPersonal/persHomePollListUser";
	}
	
	/**
	 * 포탈 설문조사 투표화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/wpLightPoll.do", method = RequestMethod.GET)
	public String wpLightPoll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception{
		logger.debug("wpLightPoll started");

		userInfo = commonUtil.userInfo(loginCookie);
		String labelPollTitle = "";
		String answer = "";
		String literalAnswer = "";
		String pollSeq = "";
		PersonalLightPollVO result = ezPersonalService.getCurrentPoll(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getOffset());
		
		Document xmlDom = commonUtil.convertStringToDocument("<DATA>"+commonUtil.getQueryResult(result)+"</DATA>");
		
		if (result != null) {
			if (result.getItemSeq() == 0) {
				labelPollTitle = egovMessageSource.getMessage("ezPersonal.t385", locale);
			} else {
				if (userInfo.getPrimary().equals("2") && result.getPollTitle2() != null && !result.getPollTitle2().equals("")) {
					labelPollTitle = result.getPollTitle2();
				} else {
					labelPollTitle = result.getPollTitle();
				}
				//2018-07-26 김보미 - title ellipsis처럼 보이게 처리
				String pollTitle = labelPollTitle;
				if (labelPollTitle.length() > 93) {
					pollTitle = labelPollTitle.substring(0, 92) + "...";
				}
				
				labelPollTitle = "<span title='" + labelPollTitle + "'>" + pollTitle + "</span>";
				
				pollSeq = String.valueOf(result.getItemSeq());
				int count = Integer.parseInt(result.getPollSelectionCount());
				//2018-07-26 김보미 - ellipsis처리하기 위해 div추가
//				for (int i=0; i<count; i++) {
//					answer += "<input type=radio name='answer' id='answer" + i + "' value=" + (i + 1) + "><label for='answer" + i + "' style='cursor:pointer''>" + xmlDom.getElementsByTagName("ANSWER"+(i+1)).item(0).getTextContent() + "</label><br>";
//				}
				for (int i=0; i<count; i++) {
					answer += "<div class='line_ellipsis' title='" + xmlDom.getElementsByTagName("ANSWER"+(i+1)).item(0).getTextContent() + "'>";
					answer += "<input type=radio name='answer' id='answer" + i + "' value=" + (i + 1) + "><label for='answer" + i + "' style='cursor:pointer''>" + xmlDom.getElementsByTagName("ANSWER"+(i+1)).item(0).getTextContent() + "</label><br>";
					answer += "</div>";
				}
				
				literalAnswer = answer;
				
				if (result.getResult() == 0) {
					
				} else {
					
				}
			}
			
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pollSeq", pollSeq);
		model.addAttribute("literalAnswer", literalAnswer);
		model.addAttribute("labelPollTitle", labelPollTitle);
		
		logger.debug("wpLightPoll ended");
		return "ezPersonal/persWpLightPoll";
	}
	
	/**
	 * 포탈 설문조사 결과화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/pollResult.do", method = RequestMethod.GET)
	public String pollResult(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception{
		logger.debug("pollResult started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String title = "";
		int totalCount = 0;
		String subject = "";
		//2018-07-26 김보미 - 설문제목 ellipsis처럼 보이게 처리
		String subjectContent = "";
		String subjectCnt = "";
		
		String itemSeq = req.getParameter("itemSeq");
		
		String flag = "";
		if (req.getParameter("flag") != null) {
			flag = req.getParameter("flag");
		}
		
		if (req.getParameter("answer") != null && !req.getParameter("answer").equals("")) {
			ezPersonalService.insertResult(Integer.parseInt(itemSeq), userInfo.getId(), Integer.parseInt(req.getParameter("answer")), userInfo.getTenantId());
		}
		
		PersonalLightPollVO pollInfo = ezPersonalService.getPollInfo(Integer.parseInt(itemSeq), userInfo.getTenantId()); 
		Document xmlDom = commonUtil.convertStringToDocument("<DATA>"+commonUtil.getQueryResult(pollInfo)+"</DATA>");
		List<PersonalLightPollVO> pollResultList = ezPersonalService.getPollResult(Integer.parseInt(itemSeq), userInfo.getTenantId());
		
		if (userInfo.getPrimary().equals("2") && pollInfo.getPollTitle2() != null && !pollInfo.getPollTitle2().equals("")) {
			subject = pollInfo.getPollTitle2();
		} else {
			subject = pollInfo.getPollTitle();
		}
		
		if (commonUtil.getDateStringInUTC(pollInfo.getEndDate(), userInfo.getOffset(), false).indexOf("1900-01-01") > -1) {
			title = commonUtil.getDateStringInUTC(pollInfo.getStartDate(), userInfo.getOffset(), false) + " - " + egovMessageSource.getMessage("ezPersonal.t244", locale);
		} else {
			title = commonUtil.getDateStringInUTC(pollInfo.getStartDate(), userInfo.getOffset(), false) + " - " + commonUtil.getDateStringInUTC(pollInfo.getEndDate(), userInfo.getOffset(), false);
		}
		
		int count = Integer.parseInt(pollInfo.getPollSelectionCount());
		
		String listXML = "";
		String[] array_title = new String[11];
		array_title[0] = "";
		for (int i=1; i<=count; i++) {
			array_title[i] = commonUtil.cleanValue(xmlDom.getElementsByTagName("ANSWER"+i).item(0).getTextContent());
			listXML += "<ROW><TITLE>" + i + "." + commonUtil.cleanValue(xmlDom.getElementsByTagName("ANSWER"+i).item(0).getTextContent()) + "</TITLE><COUNT>0</COUNT><PERCENT>0</PERCENT></ROW>";
		}
		
		Document resultDom = commonUtil.convertStringToDocument("<DATA>"+listXML+"</DATA>");
		
		for (int i=0; i<pollResultList.size(); i++) {
			int index = pollResultList.get(i).getResult();
			resultDom.getElementsByTagName("COUNT").item(index - 1).setTextContent(String.valueOf(pollResultList.get(i).getCount()));
			totalCount += pollResultList.get(i).getCount();
		}
		
		if (totalCount != 0) {
			for (int i=0; i<resultDom.getElementsByTagName("COUNT").getLength(); i++) {
				double temp = Double.parseDouble(resultDom.getElementsByTagName("COUNT").item(i).getTextContent()) * 100.0 / totalCount;
				String temp1 = String.valueOf(temp);
				if (temp1.indexOf("\\.") > -1) {
					if (temp1.split("\\.")[1].length() > 1) {
						String temp2 = temp1.split("\\.")[1].substring(1, 1);
						int temp3 = 0;
						if (Integer.parseInt(temp2) >= 5) {
							temp3 = Integer.parseInt(temp1.split("\\.")[1].substring(0, 1)) + 1;
						} else {
							temp3 = Integer.parseInt(temp1.split("\\.")[1].substring(0, 1));
						}
						
						temp2 = temp1.split("\\.")[0] + "." + temp3;
						temp = Double.parseDouble(temp2);
					}
				}
				
				resultDom.getElementsByTagName("PERCENT").item(i).setTextContent(String.format("%.1f", temp));
			}
			//subject += " - " + egovMessageSource.getMessage("ezPersonal.t248", locale) + totalCount + egovMessageSource.getMessage("ezPersonal.t249", locale);
			subjectCnt +=  egovMessageSource.getMessage("ezPersonal.t248", locale) + " " + totalCount + egovMessageSource.getMessage("ezPersonal.t249", locale);
		}
		//2018-07-26 김보미 - 설문제목 ellipsis처럼 보이게 처리
		else {
			subjectCnt = "";
		}
		//2018-07-26 김보미 - 설문제목 ellipsis처럼 보이게 처리
		if (subject.length() > 86) {
			subjectContent = subject.substring(0, 86) + "...";
		}
		
		String strHtml = "";
		//2018-07-26 김보미 - 설문결과 내용부분 수정
//		for (int i=0; i<resultDom.getElementsByTagName("ROW").getLength(); i++) {
//			strHtml += "<span class='txt'>"+resultDom.getElementsByTagName("TITLE").item(i).getTextContent()+"</b>(<b>"+resultDom.getElementsByTagName("COUNT").item(i).getTextContent()+"</b>"+egovMessageSource.getMessage("ezPersonal.t247", locale) + "<span class='point'>"+resultDom.getElementsByTagName("PERCENT").item(i).getTextContent()+"</span>%)</span>";
//			strHtml += "<table style='border:1px solid #c9c9c9;width:100%;height:12px;background-image:url(/images/quickpoll_bg.gif);'>";
//			strHtml += "<tr>";
//			strHtml += "<td style='width:"+Double.parseDouble(resultDom.getElementsByTagName("PERCENT").item(i).getTextContent())*4 +"px;background-color:rgb(245, 117, 120)'></td>";
//			//pollResult 전자설문 그래프부분 브라우저에 따라 width px 조건에 맞게 처리
//			if (req.getHeader("User-Agent").indexOf("Trident") > 0 || req.getHeader("User-Agent").indexOf("MSIE") > 0) {
//				strHtml += "<td style='width:"+(400-Double.parseDouble(resultDom.getElementsByTagName("PERCENT").item(i).getTextContent())*4)+"px;'></td>";
//			} else {
//				strHtml += "<td style='width:"+(408-Double.parseDouble(resultDom.getElementsByTagName("PERCENT").item(i).getTextContent())*4)+"px;'></td>";
//			}
//			strHtml += "</tr>";
//			strHtml += "</table>";
//			strHtml += "<br>";
//		}
		//2023-07-28 황인경 - 설문결과 태그 위치 수정
		for (int i=0; i<resultDom.getElementsByTagName("ROW").getLength(); i++) {
			strHtml += "<li class='poll_list1'>" + "<div class='Pt_QstOptTitleDiv' style='width: 22%;' title='" + array_title[i+1] + "'><span class='Vnum'>" + (i+1)  + 
					"</span><span class='Vtext'>" + array_title[i+1] +"</div>" + "<div class='graphbar1' id='divGraph" + i + "' style='display: block;'>" ;
			if (resultDom.getElementsByTagName("PERCENT").item(i).getTextContent().equals("0.0") || resultDom.getElementsByTagName("PERCENT").item(i).getTextContent().equals("0")) {
				strHtml += "<p id='graph" + i + "' class='gx_bar11' style='display: none;'></p>";
			} else {
				strHtml += "<p id='graph" + i + "' class='gx_bar11' style='width:" + resultDom.getElementsByTagName("PERCENT").item(i).getTextContent() + "%;'></p>" ;
			}
			strHtml += "</div>" + "<div id='info" + i + "' class='Pt_QstInfoDiv'>&nbsp" + "<span class='Pt_QstInfoVotes'>" + 
			resultDom.getElementsByTagName("COUNT").item(i).getTextContent() + "</span>" + "/" ; 
			if (resultDom.getElementsByTagName("PERCENT").item(i).getTextContent().equals("0")) {
				strHtml += "<span class='Pt_QstInfoPercent'>" + resultDom.getElementsByTagName("PERCENT").item(i).getTextContent() + ".0</span>";
			} else {
				strHtml += "<span class='Pt_QstInfoPercent'>" + resultDom.getElementsByTagName("PERCENT").item(i).getTextContent() + "</span>";
			}
			strHtml += "%</div></li>";	
		}
		/*for (int i=0; i<resultDom.getElementsByTagName("ROW").getLength(); i++) {
			strHtml +=
					
					"<li class='poll_list1'>" +
							"<div class='Pt_QstOptTitleDiv' style='width: 22%;' title='" + array_title[i+1] + "'><span class='Vnum'>" + (i+1)  + "</span><span class='Vtext'>" + array_title[i+1] +"</div>" +
							"<div id='info" + i + "' class='Pt_QstInfoDiv'>&nbsp" + 
							"<span class='Pt_QstInfoVotes'>"+ resultDom.getElementsByTagName("COUNT").item(i).getTextContent() + "</span>" +
							egovMessageSource.getMessage("ezPersonal.hyh17", locale) + "/" ;
			if (resultDom.getElementsByTagName("PERCENT").item(i).getTextContent().equals("0")) {
				strHtml += "<span class='Pt_QstInfoPercent'>" + resultDom.getElementsByTagName("PERCENT").item(i).getTextContent() + ".0</span>";
			} else {
				strHtml += "<span class='Pt_QstInfoPercent'>" + resultDom.getElementsByTagName("PERCENT").item(i).getTextContent() + "</span>";
			}
			strHtml += "%</div>"+
					"<div class='graphbar1' id='divGraph" + i + "' style='display: block;'>" ;
			if (resultDom.getElementsByTagName("PERCENT").item(i).getTextContent().equals("0.0") || resultDom.getElementsByTagName("PERCENT").item(i).getTextContent().equals("0")) {
				strHtml += "<p id='graph" + i + "' class='gx_bar11' style='display: none;'></p>";
			} else {
				strHtml += "<p id='graph" + i + "' class='gx_bar11' style='width:" + resultDom.getElementsByTagName("PERCENT").item(i).getTextContent() + "%;'></p>" ;
			}
			strHtml += "</div>"+
					"</li>";	
			
		}*/
		
		model.addAttribute("listPoll", resultDom);
		model.addAttribute("subject", subject);
		model.addAttribute("strHtml", strHtml);
		model.addAttribute("title", title);
		//2018-07-26 김보미 - 설문제목 ellipsis처럼 보이게 처리
		model.addAttribute("subjectContent", subjectContent);
		model.addAttribute("subjectCont", subjectCnt);
		
		logger.debug("pollResult ended");
		if(flag.equals("preview")) {
			// 미리보기 창
			return "admin/ezPersonal/personalPollResultPreview";
		} else {
			return "ezPersonal/persPollResult";
		}
	}
	
	/**
	 * 포탈 메인 생일자 리스트 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/mainBirthUserList.do", method = RequestMethod.POST)
	public String mainBirthUserList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, @RequestBody HashMap<String, Integer> paramMap, HttpServletRequest request) throws Exception{
		logger.debug("mainBirthUserList started");

		userInfo = commonUtil.userInfo(loginCookie);
		int month = paramMap.get("month");
		logger.debug("month = " + month);
		
		List<OrganUserVO> list = ezPersonalService.getBirthUserList(userInfo.getCompanyID(), userInfo.getTenantId(), month, userInfo.getLang());

		model.addAttribute("list", list);
		
		logger.debug("mainBirthUserList ended");
		
		return "json";
	}
	
	/**
	 * 포탈 직원조회 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/personSearch.do", method = RequestMethod.GET)
	public String personSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("personSearch started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String searchString = "";
		if (req.getParameter("searchString") != null && !req.getParameter("searchString").equals("")) {
			searchString = req.getParameter("searchString");
		}
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("searchString", searchString);
		model.addAttribute("primaryLang", primaryLang);

		String useShowAllCompanies = ezCommonService.getTenantConfig("useShowAllCompanies", userInfo.getTenantId());
		model.addAttribute("useShowAllCompanies", useShowAllCompanies);
		
		logger.debug("personSearch ended");
		return "/ezPersonal/persPersonSearch";
	}
	
	/**
	 * 포탈 직원조회 인쇄 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/personSearchPrint.do", method = RequestMethod.GET)
	public String personSearchPrint(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("personSearchPrint started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useShowAllCompanies", "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useShowAllCompanies", userInfo.getTenantId())));

		logger.debug("personSearchPrint ended");
		return "/ezPersonal/persPersonSearchPrint";
	}
	
	
	/**
	 * 포탈 환경설정 left 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/leftEnvironment.do", method = RequestMethod.GET)
	public String leftEnvironment(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("leftEnvironment started");
		userInfo = commonUtil.userInfo(loginCookie);
		String funCode = "";
		// String topMenuID = "";
		String ezInfoSSL = "";
		String SSL = "";
		
		if (req.getParameter("funCode") != null && !req.getParameter("funCode").equals("")) {
			funCode = req.getParameter("funCode");
		}
		
		/* if (req.getParameter("topMenuID") != null && !req.getParameter("topMenuID").trim().equals("")) {
			topMenuID = req.getParameter("topMenuID");
		} */
		
		if (config.getProperty("config.ezInfoSSL") != null && !config.getProperty("config.ezInfoSSL").equals("")) {
			ezInfoSSL = config.getProperty("config.ezInfoSSL");
		}
		
		SSL = req.getRequestURL().toString();
		
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
		
		//초기화면 메일만 사용하고 싶을 때 YES
		String	firstScreen_Mail = ezCommonService.getTenantConfig("firstScreen_Mail", userInfo.getTenantId());
		//마이포탈설정 0:보이게,1:마이포탈페이지만,2:초기화면설정만
		String portalEnv = ezCommonService.getTenantConfig("portalEnv", userInfo.getTenantId());
		
		if (portalEnv == null || portalEnv.equals("")) {
			portalEnv = "0";
		}
		if (firstScreen_Mail == null || firstScreen_Mail.equals("")) {
			firstScreen_Mail = "NO";
		}

		// String accessList = ezPortalService.getAccessList(userInfo);
		
		/*
		 * 환경설정 좌측 메뉴 리스트에 있는 모듈의 URL과 이름을 map에 추가
		 * 여기에 입력한 모듈의 이름으로 사용 여부 확인 
		 */
		
		HashMap <String, String> moduleList = new HashMap<String, String>();

		moduleList.put("/ezEmail/mailMain.do", "mail");
		moduleList.put("/ezSchedule/scheduleIndex.do", "schedule");
		moduleList.put("/ezApprovalG/apprGMain.do", "appr");
		moduleList.put("/ezBoard/boardMain.do", "board");
		moduleList.put("/ezCommunity/communityMain.do", "community");
		moduleList.put("/ezResource/resMain.do", "res");
		moduleList.put("/ezCircular/circularIndex.do", "circular");
		moduleList.put("/ezJournal/journalMain.do", "journal");
		moduleList.put("/ezWebFolder/webfolderMain.do", "webfolder");
		
		String companyId = userInfo.getCompanyID();
		int tenantId = userInfo.getTenantId();
		String portletLang = userInfo.getLang();
		String userId = userInfo.getId();
		String deptId = userInfo.getDeptID();
		
		List<MenuInfoVO> menuList = ezNewPortalService.getUserMenuList(companyId, tenantId, portletLang, userId, deptId);
		/*HashMap<String, String> usedList = (HashMap<String, String>) ezPortalService.getMainMenuItemUIDList(accessList, moduleList, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId(), topMenuID);*/
		
		String useQuestion = ezCommonService.getTenantConfig("useQuestion", tenantId);
		String useMemo = ezCommonService.getTenantConfig("useMemo", tenantId);
		String useLadder = ezCommonService.getTenantConfig("useLadder", tenantId);
		String useCabinet = ezCommonService.getTenantConfig("useCabinet", tenantId);
		String useVote = ezCommonService.getTenantConfig("useBallotSystem", tenantId);
		String useJournal = ezCommonService.getTenantConfig("USE_JOURNAL", tenantId);
		String useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", tenantId);
		String useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", tenantId);
		String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", tenantId);
		String useEzPMS = ezCommonService.getTenantConfig("USE_ezPMS", tenantId);
		String useCommunity = ezCommonService.getTenantConfig("USE_COMMUNITY", tenantId);
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantId);
		
		String usePortal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
		String useSchedule = ezCommonService.getTenantConfig("useSchedule", tenantId);
		String useBoard = ezCommonService.getTenantConfig("useBoard", tenantId);
		String useToDo = ezCommonService.getTenantConfig("useToDo", tenantId);
		
		if (useAttitude == null || useAttitude.equals("")) {
			useAttitude = "NO";
		}
		
		if (useMemo == null || useMemo.equals("")) {
			useMemo = "YES";
		}
		
		if (useLadder == null || useLadder.equals("")) {
			useLadder = "NO";
		}
		
		if (useCabinet == null || useCabinet.equals("")) {
			useCabinet = "NO";
		}
		
		if (useVote == null || useVote.equals("")) {
			useVote = "YES";
		}
		
		if (useJournal == null || useJournal.equals("")) {
			useJournal = "NO";
		}
		
		if (useCircular == null || useCircular.equals("")) {
			useCircular = "YES";
		}
		
		if (useQuestion == null || useQuestion.equals("")) {
			useQuestion = "NO";
		}
		
		if (useWebfolder == null || useWebfolder.equals("")) {
			useWebfolder = "NO";
		}
		
		if (useCommunity == null || useCommunity.equals("")) {
			useCommunity = "YES";
		}
		
		if (useEzPMS == null || useEzPMS.equals("")) {
			useEzPMS = "NO";
		}
		
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		if (useSchedule == null || useSchedule.equals("")) {
			useSchedule = "YES";
		}
		
		if (useBoard == null || useBoard.equals("")) {
			useBoard = "YES";
		}
		
		if (useToDo == null || useToDo.equals("")) {
			useToDo = "YES";
		}
		
		if (useQuestion.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 14));
		}
		
		if (useMemo.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 18));
		}
		
		if (useLadder.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 16));
		}
		
		if (useCabinet.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 11));
		}
		
		if (useVote.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 15));
		}
		
		if (useJournal.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 8));
		}
		
		if (useCircular.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 7));
		}
		
		if (useAttitude.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 9));
		}
		
		if (useWebfolder.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 10));
		}
		
		if (useEzPMS.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 12));
		}
		
		if (useCommunity.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 5));
		}
		
		if (useExternalMailServer.equalsIgnoreCase("YES")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 1));
		}
		
		if (useSchedule.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 2));
		}
		
		if (useBoard.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 4));
		}
		
		if (useToDo.equals("NO")) {
			menuList.removeIf(vo -> (vo.getMenuId() == 17));
		}
		/*
		 * moduleList에 추가해준 모듈의 이름으로 확인 
		 */
		int menuListCount = menuList.size();
		
		for (int i = 0; i < menuListCount; i++) {
			int menuId = menuList.get(i).getMenuId();
			
			if (menuId == 1) {
				model.addAttribute("isMailUsed", "Y");
			} else if (menuId == 3) {
				model.addAttribute("isApprUsed", "Y");
			} else if (menuId == 2) {
				model.addAttribute("isScheduleUsed", "Y");
			} else if (menuId == 4) {
				model.addAttribute("isBoardUsed", "Y");
			} else if (menuId == 5) {
				model.addAttribute("isCommunityUsed", "Y");
			} else if (menuId == 6) {
				model.addAttribute("isResUsed", "Y");
			} else if (menuId == 7) {
				model.addAttribute("isCircularUsed", "Y");
			} else if (menuId == 8) {
				model.addAttribute("isJournalUsed", "Y");
			} else if (menuId == 10) {
				model.addAttribute("isWebfolderUsed", "Y");
			} else if (menuId == 12) {
				model.addAttribute("isPMSUsed", "Y");
			} else if (menuId == 17) {
				model.addAttribute("isTaskUsed", "Y");
			}
		}
		
		model.addAttribute("ezInfoSSL", ezInfoSSL);
		model.addAttribute("funCode", funCode);
		model.addAttribute("SSL", SSL);
		model.addAttribute("firstScreen_Mail", firstScreen_Mail);
        model.addAttribute("packageType", packageType);
        model.addAttribute("portalEnv", portalEnv);
        model.addAttribute("usePortal", usePortal);
        model.addAttribute("useEzTalkNotification", "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useEzTalkNotification", tenantId)));
        
		logger.debug("leftEnvironment ended");
		return "/ezPersonal/persLeftEnvirionment";
	}
	
	/**
	 * 포탈 환경설정 userManageWebPart 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/userManageWebPart.do", method = RequestMethod.GET)
	public String userManageWebPart(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("userManageWebPart started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		List<PersonalGetWebPartGroupVO> listGroup = ezPersonalService.getWebPartGroup(userInfo.getCompanyID(), "U", userInfo.getTenantId());
		List<PersonalGetWebPartVO> list = ezPersonalService.getUserWebPart(userInfo.getId(), userInfo.getCompanyID(), userInfo.getDeptPathCode(), userInfo.getTenantId());
		
		model.addAttribute("listGroup", listGroup);
		model.addAttribute("list", list);

		logger.debug("userManageWebPart ended");
		return "/ezPersonal/persUserManageWebPart";
	}
	
	/**
	 * 포탈 환경설정 개인정보관리 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/changePersonInfo.do", method = RequestMethod.GET)
	public String changePersonInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("changePersonInfo started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		OrganUserVO userVO = ezOrganService.getUserInfo(userInfo.getId(), userInfo.getPrimary(), userInfo.getTenantId());
		String userManualFlag = userVO.getManualFlag();
		logger.debug("userManualFlag={}", userManualFlag);
		
		String companyID = userInfo.getCompanyID();
		logger.debug("companyID=" + companyID);
		
		String noneActiveX = "YES";
		String userMobileManaged = "NO";
		// 모바일 설정
		//String radBirthType1 = "";
		//String radBirthType2 = "";
		String literalPhoto = "";
		
		String propList = "postalCode;streetAddress;homePhone;facsimileTelephoneNumber;extensionAttribute2;company;description;displayName;title;mail;telephoneNumber;mobile;info;extensionAttribute10;birth;birthType;password;FURIGANA;EXTENSIONPHONE;OFFICEMOBILE";
		
		String result = ezOrganService.getPropertyList(userInfo.getId(), propList, userInfo.getPrimary(), userInfo.getTenantId());
		Document xmlDom = commonUtil.convertStringToDocument(result);
		
		String labelCompany = xmlDom.getElementsByTagName("COMPANY").item(0).getTextContent();
		String labelDepartment = xmlDom.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
		String labelDisplayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
		String labelTitle = xmlDom.getElementsByTagName("TITLE").item(0).getTextContent();
		String labelJikChek = xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE10").item(0).getTextContent();
		String labelMail = xmlDom.getElementsByTagName("MAIL").item(0).getTextContent();
		String txtTelePhone = xmlDom.getElementsByTagName("TELEPHONENUMBER").item(0).getTextContent();
		String txtMobilePhone = xmlDom.getElementsByTagName("MOBILE").item(0).getTextContent();
		String txtHomePhone = xmlDom.getElementsByTagName("HOMEPHONE").item(0).getTextContent();
		String txtFax = xmlDom.getElementsByTagName("FACSIMILETELEPHONENUMBER").item(0).getTextContent();
		String txtZipCode = xmlDom.getElementsByTagName("POSTALCODE").item(0).getTextContent();
		String txtAddress = xmlDom.getElementsByTagName("STREETADDRESS").item(0).getTextContent();
		String birthDay = xmlDom.getElementsByTagName("BIRTH").item(0).getTextContent();
		String birthType = xmlDom.getElementsByTagName("BIRTHTYPE").item(0).getTextContent();
		String password = xmlDom.getElementsByTagName("PASSWORD").item(0).getTextContent();
		String literalFurigana = xmlDom.getElementsByTagName("FURIGANA").item(0).getTextContent();
		String literalExtensionPhone = xmlDom.getElementsByTagName("EXTENSIONPHONE").item(0).getTextContent();
		String literalOfficeMobile = xmlDom.getElementsByTagName("OFFICEMOBILE").item(0).getTextContent();
		
		/*if (userInfo.getLang().equals("1") || userInfo.getLang().equals("4")) {
			radBirthType1 = messageSource.getMessage("ezPersonal.t2001", locale);
			radBirthType2 = messageSource.getMessage("ezPersonal.t2002", locale);
		}*/
		
		/* 2018-09-13 홍승비 - 개인정보관리 담당업무 자기소개 특수문자 처리 */
		String pInfo = xmlDom.getElementsByTagName("INFO").item(0).getTextContent();
		pInfo = commonUtil.cleanValue(pInfo);
		
		if (xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() == null || xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().equals("")) {
			literalPhoto = "<img id=myimg " + messageSource.getMessage("ezPersonal.i1",locale) + ">";
		} else {
			literalPhoto = "<img id=myimg SRC='/ezCommon/downloadAttach.do?filePath=" + commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + "/" + xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() + "' width=119 height=128>";
		}
		
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		String useAddressOpenAPI = config.getProperty("config.USE_AddressOpenAPI");
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String useZipCodeSearch = ezCommonService.getTenantConfig("useZipCodeSearch", userInfo.getTenantId());
		String useMobileManagemant = ezCommonService.getTenantConfig("useMobileManagemant", userInfo.getTenantId());
		String useAllowUserMobileManagement = ezCommonService.getTenantConfig("useAllowUserMobileManagement", userInfo.getTenantId());
		
		boolean useMailAliasSettingOnLogin = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useMailAliasSettingOnLogin", userInfo.getTenantId()));
		
		if (useMailAliasSettingOnLogin) {
			int mailIdLength = labelMail.indexOf("@");
			if (mailIdLength > 0) {
				labelMail = labelMail.substring(0, mailIdLength);
			}

			String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
			model.addAttribute("domainName", domainName);
		}
		
		if (useMobileManagemant.equals("YES") && useAllowUserMobileManagement.equals("YES")) {
			userMobileManaged = "YES";
		}
		
		if (useZipCodeSearch == null || useZipCodeSearch.equals("")) {
			useZipCodeSearch = "YES";
		}
		
		String pwPolicyExplain = commonUtil.getPwPolicyExplain(companyID, userInfo.getTenantId(), locale);
		boolean useOnlyInnerMail = "yes".equalsIgnoreCase(ezCommonService.getTenantConfig("UseOnlyInnerMail", userInfo.getTenantId()));
		
		// 2021-05-26 김민성 - office 사용시 사용자 비밀번호관리탭 제외
		String ezOffice365Auth = ezCommonService.getTenantConfig("ezOffice365Auth", userInfo.getTenantId());
		if (ezOffice365Auth == null || ezOffice365Auth.equals("")) {
			ezOffice365Auth = "NO";
		}
		model.addAttribute("ezOffice365Auth", ezOffice365Auth);
		
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("txtInfo", pInfo);
		model.addAttribute("labelCompany", labelCompany);
		model.addAttribute("labelDepartment", labelDepartment);
		model.addAttribute("labelDisplayName", labelDisplayName);
		model.addAttribute("labelTitle", labelTitle);
		model.addAttribute("labelJikChek", labelJikChek);
		model.addAttribute("labelMail", labelMail);
		model.addAttribute("txtTelePhone", txtTelePhone);
		model.addAttribute("txtMobilePhone", txtMobilePhone);
		model.addAttribute("txtHomePhone", txtHomePhone);
		model.addAttribute("txtFax", txtFax);
		model.addAttribute("txtZipCode", txtZipCode);
		model.addAttribute("txtAddress", txtAddress);
		model.addAttribute("birthDay", birthDay);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("literalPhoto", literalPhoto);
		model.addAttribute("birthType", birthType);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("txtOldPassword", password);
		model.addAttribute("useAddressOpenAPI", useAddressOpenAPI);
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("useZipCodeSearch", useZipCodeSearch);
		model.addAttribute("locale", userInfo.getLocale());
		model.addAttribute("userMobileManaged", userMobileManaged);
		model.addAttribute("LiteralFurigana", literalFurigana);
		model.addAttribute("LiteralExtensionPhone", literalExtensionPhone);
		model.addAttribute("LiteralOfficeMobile", literalOfficeMobile);
		model.addAttribute("useMailAliasSettingOnLogin", useMailAliasSettingOnLogin);
		model.addAttribute("companyID", companyID);
		model.addAttribute("pwPolicyExplain", pwPolicyExplain);
		model.addAttribute("useOnlyInnerMail", useOnlyInnerMail);
		model.addAttribute("userManualFlag", userManualFlag);
		
		logger.debug("changePersonInfo ended");
		return "/ezPersonal/persChangePersonInfo";
	}
	
	/**
	 * 포탈 환경설정 사진삭제 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/deletePicture.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deletePicture(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("deletePicture started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String result = ezOrganService.updateProperty(userInfo.getId(), "extensionAttribute2", "", "user", userInfo.getTenantId());

	    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        date.setTimeZone(TimeZone.getTimeZone("GMT"));
        String nowDate = date.format(new Date()); 

        // 비즈메카톡과의 프로필 사진 연동을 위해 updateDT 필드를 갱신한다.
        ezOrganAdminService.updateProperty(userInfo.getId(), "updateDT", nowDate, "user", userInfo.getTenantId());
		
        String useBizmekaTalk = ezCommonService.getTenantConfig("UseBizmekaTalk", userInfo.getTenantId());
        
        if (useBizmekaTalk.equals("YES")) {
        	try {
        		ezOrganAdminController.invokeEzTalkSyncServerForSingle(userInfo.getId(), userInfo.getTenantId());
        	} catch (Exception e) {
        		logger.error(e.getMessage(), e);
        	}
        }
		
		logger.debug("deletePicture ended");
		return result;
	}
	
	/**
	 * 포탈 환경설정 저장 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/saveUserInfo.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveUserInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale, OrganUserVO vo) throws Exception {
		logger.debug("saveUserInfo started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		vo.setTenantId(userInfo.getTenantId());
		
		// displayname2가 null로 넘어오는데, 이럴 경우 displayname2은 displayname으로 대체되는 문제가 생겨서 추가
		vo.setDisplayName2(userInfo.getDisplayName2());
		
		// 2024.02.13 한슬기 : cn, displayName 파라미터 변조하여 수정 불가능한 정보를 수정할 수 있는 문제. 파라미터로 cn과 displayName을 전달받지 않고 백단에서 처리
		vo.setCn(userInfo.getId());
		
		logger.debug("<<<1. : " + vo.getCn());
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date()); 
		vo.setNowDate(nowDate);
		
		ezOrganAdminService.updateDBData_user(vo);

        String useBizmekaTalk = ezCommonService.getTenantConfig("UseBizmekaTalk", userInfo.getTenantId());
        
        if (useBizmekaTalk.equals("YES")) {
        	try {
        		ezOrganAdminController.invokeEzTalkSyncServerForSingle(userInfo.getId(), userInfo.getTenantId());
        	} catch (Exception e) {
        		logger.error(e.getMessage(), e);
        	}
        }
		
		logger.debug("saveUserInfo ended");
		return "OK";
	}
	
	/**
	 * 포탈 환경설정 비밀번호 저장 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/changePassword.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String changePassword(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale, OrganUserVO vo, @RequestBody String xmlStr) throws Exception {
		logger.debug("changePassword started");
		String result = "ERROR";

		process : {

		// 1. 주 수행 변수 oldPw, newPw
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String oldPassword = xmlDom.getElementsByTagName("OLDPASSWORD").item(0).getTextContent();
		String newPassword = xmlDom.getElementsByTagName("NEWPASSWORD").item(0).getTextContent();
		
		String decryptedOldPassword = EgovFileScrty.decryptRsa(pk, oldPassword);
		String decryptedNewPassword = EgovFileScrty.decryptRsa(pk, newPassword);
		
		// 2. 사용자 정보 : loginCookie
		userInfo = commonUtil.userInfo(loginCookie);
		String cn = userInfo.getId();
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		logger.debug("userInfo : cn={}, companyID={}, tenantID={}", cn, companyID, tenantID);

		// 3. 비밀번호 검증
		if (!ezPersonalService.checkPassword(cn, decryptedOldPassword, tenantID)) {	// 현암호와 db암호가 일치하지 않음(실패)
			result = "CHKERROR";
			break process;
		}

		// 4. 비밀번호 변경 수행
		result = ezOrganAdminService.changePasswordWithEmailSystem(cn, tenantID, decryptedOldPassword, decryptedNewPassword);
		}

		logger.debug("changePassword ended. result ={}", result);
		return result;
	}
	
	/**
	 * 포탈 환경설정 언어및표준시간대설정 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/timeZone.do", method = RequestMethod.GET)
	public String timeZone(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("timeZone started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		logger.debug("primaryLang=" + primaryLang);					
		
		String usePrimaryLangOnly = config.getProperty("config.UsePrimaryLangOnly");
		
		model.addAttribute("strTimeZone", userInfo.getOffset());
		model.addAttribute("strLang", StringUtils.isBlank(userInfo.getLang())? "1" : userInfo.getLang());
		model.addAttribute("primaryLang", StringUtils.isBlank(primaryLang)? "1" : primaryLang);
		model.addAttribute("usePrimaryLangOnly", usePrimaryLangOnly);
		model.addAttribute("useJapanese", ezCommonService.getTenantConfig("useJapanese", userInfo.getTenantId()));
		model.addAttribute("useChinese", ezCommonService.getTenantConfig("useChinese", userInfo.getTenantId()));
		model.addAttribute("useVietnamese", ezCommonService.getTenantConfig("useVietnamese", userInfo.getTenantId()));
		model.addAttribute("useIndonesian", ezCommonService.getTenantConfig("useIndonesian", userInfo.getTenantId()));

		logger.debug("timeZone ended");
		return "/ezPersonal/persTimeZone";
	}
	
	/**
	 * 포탈 환경설정 언어및표준시간대설정 저장 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/saveUserTimeZone.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveUserTimeZone(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, HttpServletResponse resp,Locale locale) throws Exception {
		logger.debug("saveUserTimeZone started");

		userInfo = commonUtil.userInfo(loginCookie);
		String timeZone = "";
		String lang = "";
		String returnValue = "";
		boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));
		String ezSessionId = loginCookie; // useDbSession가 true인 경우에만 사용
		
		if (req.getParameter("timeZone") != null && !req.getParameter("timeZone").equals("")) {
			timeZone = req.getParameter("timeZone");
		}
		if (req.getParameter("lang") != null && !req.getParameter("lang").equals("")) {
			lang = req.getParameter("lang");
		}
		
		userInfo.setOffset(timeZone);
		userInfo.setLang(lang);
		logger.debug("userID="+userInfo.getId());
		logger.debug("timeZone="+timeZone);
		logger.debug("lang="+lang);
		String result = ezCommonService.saveUserLocalInfo(userInfo.getId(), userInfo);
		
		if (result != null && result.equals("OK")) {
			if (lang != null) {
				returnValue = commonUtil.getTwoLetterLangFromLangNum(lang);
			}
			
			//CookieLocaleResolver에 lang값을 set해줌
			locale = new Locale(returnValue);
			localeResolver.setLocale(req, resp, locale);
			
			String cookieValue1 = "";
			Cookie[] cookies = req.getCookies();
			if (cookies != null) {
				/* loginCookie를 파라미터로 받기때문에 for이 불필요하여 주석 처리
				for (int i=0; i<cookies.length; i++) {
					if (cookies[i].getName().equals("loginCookie")) {
						cookieValue1 = egovFileScrty.decryptAES(cookies[i].getValue());
					}
				}*/

				cookieValue1 = commonUtil.getDecryptedLoginCookie(loginCookie);

				//loginCookie에 lang값, locale값 설정
				String cInfo = userInfo.getServerName() + "///" + cookieValue1.split("///")[1] + "///" + cookieValue1.split("///")[2]
						+ "///" + cookieValue1.split("///")[3] + "///" + cookieValue1.split("///")[4] + "///" + returnValue + "///"
						+ lang + "///" + timeZone  + "///" + userInfo.getTenantId() + "///" + userInfo.getDeptID() +  "///" + userInfo.getCompanyID()
						+ "///" + Optional.ofNullable(userInfo.getJobId()).orElse("");

				loginCookie = egovFileScrty.encryptAES(cInfo);
				
				if (useDbSession) {
					loginService.updateSession(ezSessionId, loginCookie);
		
					loginCookie = ezSessionId;
				}

				Cookie cookieID = new Cookie("loginCookie", loginCookie);
				cookieID.setPath("/");
				resp.addCookie(cookieID);
			}
		}
		
		logger.debug("saveUserTimeZone ended");
		return "OK";
	}
	
	/**
	 * 포탈 환경설정 개인정보관리 사진설정 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/personPicture.do", method = RequestMethod.GET)
	public String personPicture(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("personPicture started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userLang", userInfo.getLang());

		logger.debug("personPicture ended");
		return "/ezPersonal/persPersonPicture";
	}
	
	/**
	 * 포탈 환경설정 개인정보관리 사진 저장 Method
	 */
	@RequestMapping(value = "/ezPersonal/photoUploadByUser.do", method = RequestMethod.POST)
	@ResponseBody
	public void photoUploadByUser(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("photoUploadByUser started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String fileName = req.getParameter("fileName"); //임시파일명
		String fileName2 = "";
		String filePath = "";
		String filePath2 = "";
		String realPath = req.getServletContext().getRealPath("");
		
		String fileExt = fileName.substring(fileName.lastIndexOf(".")+1);
		fileName2 = userInfo.getId() + "." + fileExt; //바꿀파일명
		filePath = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + fileName;//임시파일경로
		filePath2 = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + fileName2;//바꿀파일경로
		
		File file = new File(commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()))); 
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		File tempImageFile = new File(commonUtil.detectPathTraversal(realPath + filePath));
		File newImageFile = new File(commonUtil.detectPathTraversal(realPath + filePath2));
		
		if (newImageFile.exists()) {
			FileUtils.deleteQuietly(newImageFile);
		}
		
		if (tempImageFile.exists()) {
			tempImageFile.renameTo(newImageFile);
		}
		
		File tempThumnailFile = new File(commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_personal.PHOTOTHUMBNAIL", userInfo.getTenantId()) + commonUtil.separator + fileName)); 
		File newThumnailFile = new File(commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_personal.PHOTOTHUMBNAIL", userInfo.getTenantId()) + commonUtil.separator + fileName2)); 
		
		if (newThumnailFile.exists()) {
			FileUtils.deleteQuietly(newThumnailFile);
		}
		
		if (tempThumnailFile.exists()) {
			tempThumnailFile.renameTo(newThumnailFile);
		}
		
		
		ezOrganAdminService.updateProperty(userInfo.getId(), "extensionAttribute2", fileName2, "user", userInfo.getTenantId());
		
	    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        date.setTimeZone(TimeZone.getTimeZone("GMT"));
        String nowDate = date.format(new Date()); 

        // 비즈메카톡과의 프로필 사진 연동을 위해 updateDT 필드를 갱신한다.
        ezOrganAdminService.updateProperty(userInfo.getId(), "photo_updateDT", nowDate, "user", userInfo.getTenantId());
		
        String useBizmekaTalk = ezCommonService.getTenantConfig("UseBizmekaTalk", userInfo.getTenantId());
        
        if (useBizmekaTalk.equals("YES")) {
        	try {
        		ezOrganAdminController.invokeEzTalkSyncServerForSingle(userInfo.getId(), userInfo.getTenantId());
        	} catch (Exception e) {
        		logger.error(e.getMessage(), e);
        	}
        }
        
		logger.debug("photoUploadByUser ended");
	}
	
	/**
	 * 초기화면 관리자 슬라이드이미지 IE9 이미지 업로드 실행 함수
	 */
	@RequestMapping(value = "/ezPersonal/uploadSliderImage.do", method = RequestMethod.POST)
	@ResponseBody
	public String uploadSliderImage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		logger.debug("uploadSliderImage Start");
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		logger.debug("xmlStr="+xmlStr);
		String mode = "";
		
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
	
		String realPath = req.getServletContext().getRealPath("");
		String pDirPath = realPath+commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId());
		String pServerPath = pDirPath + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + mode;
		
		String imageName = xmlDom.getElementsByTagName("FILENAME").item(0).getTextContent();
		String imageData = xmlDom.getElementsByTagName("DATA").item(0).getTextContent();
		
		String pUniqueName = ezNewPortalService.getUniqueFileName(pServerPath, imageName);
		
		byte[] byt = Base64.decode(imageData);
		String savePath = pServerPath + commonUtil.separator + pUniqueName;
		
		if (new File(commonUtil.detectPathTraversal(savePath)).exists()) {
			new File(commonUtil.detectPathTraversal(savePath)).delete();
		}
		
		InputStream myInputStream = new ByteArrayInputStream(byt);
		
		writeUploadedFile(myInputStream, pUniqueName, pServerPath);
		
		if (mode.equals("SLIDERIMAGE")) {
			BufferedImage bi = ImageIO.read(new File(commonUtil.detectPathTraversal(savePath)));
			String pSaveName = UUID.randomUUID().toString() + ".jpg";
			BufferedImage bufferedImage = new BufferedImage(467, 200, bi.getType());
			bufferedImage.createGraphics().drawImage(bi, 0, 0, 467, 200, null);

			ImageIO.write(bufferedImage, "jpg", new File(commonUtil.detectPathTraversal(pServerPath + commonUtil.separator + pSaveName)));
			//ImageIO.write(bufferedImage, "png", new File(pAttachPath));

			File file1 = new File(commonUtil.detectPathTraversal(savePath));
			if (file1.exists()) {
				FileUtils.deleteQuietly(file1);
			}
			return commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + mode + commonUtil.separator + pSaveName;
		} else {
			logger.debug("path="+commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId()) + commonUtil.separator +userInfo.getCompanyID() + commonUtil.separator + mode + commonUtil.separator + pUniqueName);
			return commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + mode + commonUtil.separator + pUniqueName;
		}
	}
	
	 protected void writeUploadedFile(InputStream stream, String newName, String stordFilePath) throws Exception {
	 	OutputStream bos = null;
		String stordFilePathReal = (stordFilePath==null?"":stordFilePath);
		
		try {
		    File cFile = new File(commonUtil.detectPathTraversal(stordFilePathReal));
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(commonUtil.detectPathTraversal(stordFilePathReal + File.separator + newName));
	
		    int bytesRead = 0;
		    byte[] buffer = new byte[BUFF_SIZE];
	
		    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
		    	bos.write(buffer, 0, bytesRead);
		    }
		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
    }
	 
	/**
	 * 전자결재G 결재 문서 알림 메일 
	 * @deprecated 알림환경설정 도입에 의해 사용되지 않음
	 */
	@RequestMapping(value = "/ezPersonal/getApprovNoticeMail.do", method = RequestMethod.POST)
	@ResponseBody
	@Deprecated
	public String getApprovNoticeMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception {
		logger.debug("getApprovNoticeMail started");

		userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String userID = doc.getElementsByTagName("USERID").item(0).getTextContent().trim();

		String result = ezPersonalService.getApprovNotiConfig(userID, userInfo.getId(), userInfo.getTenantId());

		logger.debug("getApprovNoticeMail ended");
		return result;
	}
	
	/**
	 * 포탈 테마1 공지사항 리스트 가져오기 실행 함수
	 */
	@RequestMapping(value = "/ezPersonal/getNoticeList.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getNoticeList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("getNoticeList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		List<PersonalNoticeVO> list = ezPersonalService.getNoticeListMain(userInfo.getCompanyID(), userInfo.getTenantId());
		
		StringBuilder result = new StringBuilder("<DATA>");
		
		for (int i=0; i<list.size(); i++) {
			result.append(commonUtil.getQueryResult(list.get(i)));
		}
		
		result.append("</DATA>");
		
		logger.debug("result="+result.toString());
		logger.debug("getNoticeList ended");
		return result.toString();
	}
	
	/**
	 * 포탈 테마1 공지사항 상세정보 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/showNotice.do", method = RequestMethod.GET)
	public String showNotice(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("showNotice started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemSeq = req.getParameter("itemSeq");
		String title = "";
		String postDate = "";
		String content = "";
		
		PersonalNoticeVO result =  ezPersonalAdminService.getNoticeInfo(itemSeq, userInfo.getTenantId());
		
		if (userInfo.getPrimary().equals("2") && result.getTitle2() != null && !result.getTitle2().equals("")) {
			title = result.getTitle2();
		} else {
			title = result.getTitle();
		}
		
		postDate = commonUtil.getDateStringInUTC(result.getPostDate(), userInfo.getOffset(), false);
		content = result.getContent().replace("<a ", "<a target=\"_blank\"").replace("<A ", "<A target=\"_blank\"");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("title", title);
		model.addAttribute("postDate", postDate);
		model.addAttribute("content", content);

		logger.debug("showNotice ended");
		return "/ezPersonal/persShowNotice";
	}
	
	/**
	 * 포탈 테마1 공지사항 리스트 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/noticeList.do", method = RequestMethod.GET)
	public String noticeList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("noticeList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		int pageSize = 15;
		int currentPage = 0;
		int totalCount = 0;
		
		
		if (req.getParameter("page") != null && !req.getParameter("page").equals("")) {
			currentPage = Integer.parseInt(req.getParameter("page"));
		} else {
			currentPage = 1;
		}
		
		totalCount = ezPersonalAdminService.getNoticeCountUser(userInfo.getCompanyID(), userInfo.getTenantId());
		List<PersonalNoticeVO> list = ezPersonalService.getNoticeListUser(userInfo.getCompanyID(), totalCount, pageSize, Math.multiplyExact(Math.subtractExact(currentPage, 1), pageSize), userInfo.getTenantId());
		
		int pageCount = (totalCount + pageSize -1) / pageSize; 
		
		model.addAttribute("pageCount", pageCount);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("list", list);
		
		logger.debug("noticeList ended");
		return "/ezPersonal/persNoticeList";
	}
	
	private boolean createThumbnail(File sourceFile, File targetFile) {
		boolean result = false;
		
		try {
			BufferedImage sourceImage = ImageIO.read(sourceFile);
			int w = 100;
		    int h = 100;
		    
		    BufferedImage targetImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);

		    Graphics2D g2 = targetImage.createGraphics();
		    g2.setClip(new Ellipse2D.Float(0, 0, w, h));
		    g2.drawImage(sourceImage, 0, 0, w, h, null);
		    g2.dispose();
			
			ImageIO.write(targetImage, "png", targetFile);
			
			result = true;
		} catch (Exception e) {
			logger.debug("fail to create thumbnail : " + sourceFile.getName());
			
			try {
				Files.copy(sourceFile.toPath(), targetFile.toPath());
				logger.debug("copy original File to thumbnail.");
			} catch (IOException e1) {
				logger.error(e1.getMessage(), e1);
			}
		}
		
		return result;
	}
	
	/**
	 * 공유결재자 설정 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/manageShare.do", method = RequestMethod.GET)
	public String manageShare(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("manageShare started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("manageShare ended");
		return "/ezPersonal/persManageShare";
	}
	
	/**
	 * 공유결재자 선택 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/selectShareApproval.do", method = RequestMethod.GET)
	public String selectShareApproval(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("selectShareApproval started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("selectShareApproval ended");
		return "/ezPersonal/persSelectShareApproval";
	}
	
	/**
	 * 공유결재자 리스트 가져오는 Method
	 */
	@RequestMapping(value = "/ezPersonal/shareApprovalList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String shareApprovalList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("shareApprovalList started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String result = ezPersonalService.getShareApprovalList(userInfo.getId(), userInfo.getLang(), userInfo.getOffset(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("shareApprovalList ended");
		return result;
	}
	
	/**
	 * 공유결재자 추가 Method
	 */
	@RequestMapping(value = "/ezPersonal/saveShareApproval.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveShareApproval(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("saveShareApproval started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String shareUserId = req.getParameter("shareUserId");
		String shareUserDeptId = req.getParameter("shareUserDeptId");
		
		ezPersonalService.insertShareApproval(userInfo.getId(), shareUserId, shareUserDeptId, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("saveShareApproval ended");
		return "OK";
	}
	
	/**
	 * 공유결재자 삭제 Method
	 */
	@RequestMapping(value = "/ezPersonal/removeShareApproval.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String deleteShareApproval(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("removeShareApproval started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String shareUserId = req.getParameter("shareUserId");
		
		ezPersonalService.deleteShareApproval(userInfo.getId(), shareUserId, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("removeShareApproval ended");
		return "OK";
	}
	
	/**
	 * 포탈 환경설정 개인정보관리 모바일설정 화면 호출 메서드 - 2018.10.22 (yjks)
	 */
	@RequestMapping(value = "/ezPersonal/mobileManaged.do", method = RequestMethod.GET)
	public String mobileManaged(@CookieValue("loginCookie") String loginCookie,	Model model) throws Exception {
		logger.debug("mobileManaged started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int tenantId = userInfo.getTenantId();
		String userId = userInfo.getId();
		String inputParams = "userId=" + userId;
		logger.debug("inputParams=" + inputParams);
		
		JSONParser parser = new JSONParser();
		JSONArray jsonArr = null;
		
		String requestURL = "/ezTalkGate/getUserMobileDeviceList";
		
		String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
		logger.debug("result=" + getResult);
		
		JSONObject resultObj = (JSONObject) parser.parse(getResult);
		
		if (!resultObj.get("data").equals("0")) {
			jsonArr = (JSONArray) resultObj.get("data");
		}
		
		String adminOrder = ezCommonService.getUserConfigInfo(tenantId, userId, "adminOrderNotUsedMobileLogin");
		String notUserMobileLogin = ezCommonService.getUserConfigInfo(tenantId, userId, "notUseMobileLogin");
		
		adminOrder = adminOrder.equals("") ? "0" : adminOrder;
		notUserMobileLogin = notUserMobileLogin.equals("") ? "0" : notUserMobileLogin;
		
		model.addAttribute("deviceInfo", jsonArr);
		model.addAttribute("adminOrder", adminOrder);
		model.addAttribute("notUserMobileLogin", notUserMobileLogin);

		logger.debug("mobileManaged ended");
		return "/ezPersonal/persPersonMobileManaged";
	}
	
	/**
	 * 포탈 환경설정 개인정보관리 모바일설정 전체 사용/사용안함 업데이트 메서드 - 2018.10.22 (yjks)
	 */
	@RequestMapping(value = "/ezPersonal/setMobileManaged.do", method = RequestMethod.POST)
	@ResponseBody
	public void setMobileManaged(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, HttpServletResponse response) {
		logger.debug("setMobileManaged started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String returnValue = "OK";
		int tenantId = userInfo.getTenantId();
		String notUsed = request.getParameter("pNotUsed");
		String userId = userInfo.getId();
		
		try {
			// 해당 사용자 전체 사용안함 처리 
			String notUserMobileLogin = ezCommonService.getUserConfigInfo(tenantId, userId, "notUseMobileLogin");
			logger.debug("notUserMobileLogin=" + notUserMobileLogin + ", notUsed=" + notUsed);
			
			// notUsed는 사용자가 사용안함이면 notUseMobileLogin 처리
			// 관리자의 사용안함이면 현재상태에서 disabled 처리
			if (notUserMobileLogin.equals("")) {
				ezCommonService.insertUserConfigInfo(tenantId, userId, "notUseMobileLogin", notUsed);
			} else {
				ezCommonService.updateUserConfigInfo(tenantId, userId, "notUseMobileLogin", notUsed);
			}
		} catch (Exception e) {
			returnValue = "ERROR";
			
			logger.error(e.getMessage(), e);
		}
		
		response.addHeader("Result", returnValue);
		logger.debug("setMobileManaged ended. " + returnValue);
	}
	
	/**
	 * 포탈 환경설정 개인정보관리 모바일설정 모바일 기기 삭제 메서드 - 2018.10.22 (yjks)
	 */
	@RequestMapping(value = "/ezPersonal/deleteMobileDeviceManaged.do", method = RequestMethod.POST)
	@ResponseBody
	public void deleteMobileDeviceManaged(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, HttpServletResponse response) {
		logger.debug("deleteMobileDeviceManaged started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String returnValue = "DELETE";
		String devId = request.getParameter("pDevId");
		String pUserId = request.getParameter("userId");
		String userId = pUserId == null ? userInfo.getId() : pUserId;
		String inputParams = "userId=" + userId + "&devId=" + devId;
		logger.debug("inputParams=" + inputParams);
		
		try {
			String requestURL = "/ezTalkGate/deleteUserMobileDevice";
			String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
			logger.debug("getResult=" + getResult);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		response.addHeader("Result", returnValue);
		logger.debug("deleteMobileDeviceManaged ended.");
	}
	
	/**
	 *  포탈 환경설정 개인정보관리 모바일설정 모바일 기기 사용여부 저장 메서드 - 2018.10.22 (yjks)
	 */
	@RequestMapping(value= "/ezPersonal/setMobileDeviceInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public void setMobileDeviceInfo(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, HttpServletResponse response) {
		logger.debug("setMobileDeviceInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String returnValue = "OK";
		String pUserId = request.getParameter("userId");
		String userId = pUserId == null ? userInfo.getId() : pUserId;
		String devId = request.getParameter("pDevId");
		String notUsed = request.getParameter("pState");
		String inputParams = "userId=" + userId + "&devId=" + devId + "&notUsed=" + notUsed;
		logger.debug("inputParams=" + inputParams);
		
		try {
			String requestURL = "/ezTalkGate/setMobileDeviceInfo";
			String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
			logger.debug("getResult=" + getResult);
		} catch (Exception e) {
			returnValue = "ERROR";
			
			logger.error(e.getMessage(), e);
		}
		
		response.addHeader("Result", returnValue);
		logger.debug("setMobileDeviceInfo ended.");
	}
	
	/**
	 * 공유결재자 중복확인
	 */
	@RequestMapping(value = "/ezPersonal/checkDuplShareUser.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String checkDuplShareUser(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("checkDuplShareUser started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String shareUserId = req.getParameter("shareUserId");
		
		String rtnValue = "";
		
		rtnValue = ezPersonalService.getCheckDuplShareUser(userInfo.getId(), shareUserId, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("checkDuplShareUser ended");
		return rtnValue;
	}


	
	/**
	 * 2018-12-07 홍승비 - 포탈 환경설정 개인정보관리 사진정보만 가져오는 메서드
	 */
	@RequestMapping(value = "/ezPersonal/getUserPhoto.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getLiteralPhoto(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, Locale locale) throws Exception {
		logger.debug("getUserPhoto started");

		userInfo = commonUtil.userInfo(loginCookie);	
		String literalPhoto = "";
		
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute2", userInfo.getPrimary(), userInfo.getTenantId());
		Document xmlDom = commonUtil.convertStringToDocument(result);
		
		if (xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() == null || xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().equals("")) {
			literalPhoto = "<img id=myimg " + messageSource.getMessage("ezPersonal.i1",locale) + ">";
		} else {
			literalPhoto = "<img id=myimg SRC='/ezCommon/downloadAttach.do?filePath=" + commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + "/" + xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() + "' width=119 height=128>";
		}
		
		model.addAttribute("literalPhoto", literalPhoto);
		model.addAttribute("locale", userInfo.getLocale());
		
		logger.debug("getUserPhoto ended");
		return literalPhoto;
	}
	
	/**
	 * 포탈 환경설정 개인정보관리 사진 임시저장 Method
	 */
	@RequestMapping(value = "/ezPersonal/tempPhotoUploadByUser.do", method = RequestMethod.POST)
	public String tempPhotoUploadByUser(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, MultipartHttpServletRequest req, Locale locale) throws Exception {
		logger.debug("tempPhotoUploadByUser started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String fileName = "";
		String filePath = "";
		String filePath2 = "";
		String realPath = req.getServletContext().getRealPath("");
		
		fileName = req.getFile("file1").getOriginalFilename();
		
		if (fileName.indexOf(".") != -1) {
			fileName = fileName.substring(fileName.lastIndexOf(".")+1);
		} else {
			fileName = "";
		}
		
		String[] extArr = { "gif", "jpg"};
		boolean ret = false;
		
		for (int i=0; i<extArr.length; i++) {
			if (fileName.toLowerCase().trim().equals(extArr[i].toLowerCase().trim())) {
				ret = true;
				break;
			}
		}
		
		if (ret == false) {
			//return "";
		}
		
		fileName = "temp_" + userInfo.getId() + "." + fileName;
		filePath = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + fileName;
		filePath2 = "/ezCommon/downloadAttach.do?filePath="+commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + fileName;
		
		File file = new File(commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()))); 
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		writeUploadedFile(req.getFile("file1"), fileName, realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()));
		
		File imageFile = new File(commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()) + commonUtil.separator + fileName)); 
		
		if (imageFile.exists()) {
			BufferedImage bi = ImageIO.read(imageFile);	
			//화질 개선 코드			
			Image imgTarget = bi.getScaledInstance(119, 128, Image.SCALE_SMOOTH);
			int pixels[] = new int[119 * 128]; 
			PixelGrabber pg = new PixelGrabber(imgTarget, 0, 0, 119, 128, pixels, 0, 119); 
			try {
				pg.grabPixels(); // JEPG 포맷의 경우 오랜 시간이 걸린다.
			} catch (InterruptedException e) {
				throw new IOException(e.getMessage());
			} 
//			BufferedImage destImg = new BufferedImage(119, 128, BufferedImage.TYPE_INT_RGB);
//			destImg.setRGB(0, 0, 119, 128, pixels, 0, 119); 
			//기존코드	
			BufferedImage bufferedImage = new BufferedImage(119, 128, BufferedImage.TYPE_4BYTE_ABGR);
			bufferedImage.createGraphics().drawImage(bi, 0, 0, 119, 128, Color.WHITE, null);
			
			File profileImageFile = new File(commonUtil.detectPathTraversal(realPath + filePath));
			ImageIO.write(bufferedImage, "png", profileImageFile);
			
			File file1 = new File(commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()) + commonUtil.separator + fileName));
			if (file1.exists()) {
				FileUtils.deleteQuietly(file1);
			}
			
			//썸네일 생성
			String thumbnailPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTHUMBNAIL", userInfo.getTenantId());
			File thumbnailFolder = new File(commonUtil.detectPathTraversal(thumbnailPath));
			if (!thumbnailFolder.exists()) {
				thumbnailFolder.mkdirs();
			}
			
			File thumbnailFile = new File(commonUtil.detectPathTraversal(thumbnailPath + commonUtil.separator + profileImageFile.getName()));
			createThumbnail(profileImageFile, thumbnailFile);
		}
		
		model.addAttribute("filePath", filePath);
		model.addAttribute("filePath2", filePath2);

		logger.debug("tempPhotoUploadByUser ended");
		return "/ezPersonal/persPhotoUploadByUser";
	}
	
	/**
	 * 겸직 부재자설정 셀렉트박스 ajax 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPersonal/manageAddJobBujaeG.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject manageAddJobBujae(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("manageBujae started");

		userInfo = commonUtil.userInfo(loginCookie);
		String userID = "";
		String deptID = "";
		String startDate = "";
		String endDate = "";
		String bReason = "";
		String textName = "";
		String proxyUserID = "";
		String proxyDeptID = "";
		String proxyUserName = "";
		String textProxyName = "";
		String initDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String dept = request.getParameter("dept");
		String bujaeId = request.getParameter("bujaeId");
		String result = "";
		
		String userRealDeptId = "";
		
		if (bujaeId == null || bujaeId.equals("")) {
			userRealDeptId = ezOrganService.getUserOrgDeptId(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
			if (dept.equals(userRealDeptId)) {
				result = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute5", userInfo.getTenantId());
			} else {
				result = ezOrganService.getAddJobProxy(userInfo.getId(), dept, userInfo.getTenantId());
			}
		} else {
			userRealDeptId = ezOrganService.getUserOrgDeptId(bujaeId, userInfo.getTenantId(), userInfo.getCompanyID());
			if (dept.equals(userRealDeptId)) {
				result = ezOrganService.getPropertyValue(bujaeId, "extensionAttribute5", userInfo.getTenantId());
			} else {
				result = ezOrganService.getAddJobProxy(bujaeId, dept, userInfo.getTenantId());
			}
		}
		
		
		String cDate = "";
		String cTime = "";
		if (result != null && !result.equals("")) {
			String[] info = result.split(":");
			
			userID = info[0];
			textName = ezOrganService.getPropertyValue(info[0], "displayname", userInfo.getTenantId());
			deptID = info[2];
			startDate = info[3] + ":" + info[4];
			endDate = info[5] + ":" + info[6];
			
			if (info.length > 7) {
				bReason = info[7];
			}
		} else {
			cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false);
			cTime = cDate.split(" ")[1].substring(0, 2);
			
			cDate = cDate.substring(0, 10);
			startDate = cDate + " " + cTime + ":00:00";
			
			cDate = cDate.substring(0, 10);
			endDate = cDate + " " + Integer.toString((Integer.parseInt(cTime) + 1)) + ":00:00";
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().toLowerCase().indexOf("a=1;") > -1) {
			result = ezOrganService.getProxyUserInfo(userInfo.getId(), userInfo.getTenantId(), userInfo.getOffset());
			
			Document xmlDom = commonUtil.convertStringToDocument(result);
			
			if (xmlDom.getElementsByTagName("PROXYUSERID").getLength() > 0) {
				proxyUserID = xmlDom.getElementsByTagName("PROXYUSERID").item(0).getTextContent();
				proxyDeptID = xmlDom.getElementsByTagName("PROXYUSERDEPTID").item(0).getTextContent();
				proxyUserName = xmlDom.getElementsByTagName("PROXYUSERNAME").item(0).getTextContent();
				/*startDate = commonUtil.getDateStringInUTC(xmlDom.getElementsByTagName("STARTDATE").item(0).getTextContent().substring(0, 16), userInfo.getOffset(), false);
				endDate = commonUtil.getDateStringInUTC(xmlDom.getElementsByTagName("ENDDATE").item(0).getTextContent().substring(0, 16), userInfo.getOffset(), false);*/
				startDate = xmlDom.getElementsByTagName("STARTDATE").item(0).getTextContent();
				endDate = xmlDom.getElementsByTagName("ENDDATE").item(0).getTextContent();
				
				textProxyName = proxyUserName;
			}
		}
		
		if (bReason.trim().equals("")) {
			bReason = messageSource.getMessage("ezPersonal.t35", locale);
		}
		
		JSONObject json = new JSONObject();
		json.put("deptID", deptID);
		json.put("userID", userID);
		json.put("startDate", startDate);
		json.put("endDate", endDate);
		json.put("bReason", bReason);
		json.put("proxyUserID", proxyUserID);
		json.put("proxyDeptID", proxyDeptID);
		json.put("proxyUserName", proxyUserName);
		json.put("initDate", initDate);
		json.put("textName", textName);
		json.put("textProxyName", textProxyName);
		json.put("userInfo", userInfo);
		json.put("approvalFlag", approvalFlag);

		logger.debug("manageBujae ended");
		return json;
	}
	
	/**
	 * 겸직 부재자정보 호출
	 */
	@RequestMapping(value = "/ezPersonal/getBujaeInfo.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getBujaeInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("getBujaeInfo started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String dept = request.getParameter("dept");
		String bujaeId = request.getParameter("bujaeId");
		String result = "";
		
		String userRealDeptId = "";
		
		if (bujaeId == null || bujaeId.equals("")) {
			userRealDeptId = ezOrganService.getUserOrgDeptId(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
			if (dept.equals(userRealDeptId)) {
				result = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute5", userInfo.getTenantId());
			} else {
				result = ezOrganService.getAddJobProxy(userInfo.getId(), dept, userInfo.getTenantId());
			}
		} else {
			userRealDeptId = ezOrganService.getUserOrgDeptId(bujaeId, userInfo.getTenantId(), userInfo.getCompanyID());
			if (dept.equals(userRealDeptId)) {
				result = ezOrganService.getPropertyValue(bujaeId, "extensionAttribute5", userInfo.getTenantId());
			} else {
				result = ezOrganService.getAddJobProxy(bujaeId, dept, userInfo.getTenantId());
			}
		}
		
		logger.debug("getBujaeInfo ended");
		return result;
	}

	/**
	 * 사용자가 설정하는 alias 메일주소 도메인체크 및 중복체크 실행 함수<br>
	 * - 사용자 기본 이메일 주소(cn@도메인)를 제외한 alias는 중복에 안 걸림
	 */
	@RequestMapping(value = "/ezPersonal/checkEmailId.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkEmailId(@CookieValue("loginCookie") String loginCookie, @RequestParam String emailId) throws Exception {
		logger.debug("checkEmailId started.");

		String returnValue = "ERROR";

		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			logger.debug("userId={}, emailId={}", userInfo.getId(), emailId);

			int tenantId = userInfo.getTenantId();
			String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
			String userEmail = userInfo.getId() + "@" + domain;
			String aliasEmail = emailId + "@" + domain;
			returnValue = ezEmailService.checkIndividualAliasWithoutOwned(userEmail, aliasEmail, tenantId);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("checkEmailId ended. returnValue={}", returnValue);

		return returnValue;
	}

	/**
	 * 사용자가 설정하는 alias 메일주소 도메인체크 및 중복체크 실행 함수 <br>
	 * - 사용자 기본 이메일 주소(cn@도메인)를 제외한 alias는 중복에 안 걸림
	 */
	@RequestMapping(value = "/ezPersonal/saveUserEmail.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveUserEmail(@CookieValue("loginCookie") String loginCookie, @RequestParam String emailId) throws Exception {
		logger.debug("saveUserEmail started.");

		String returnValue = "ERROR";

		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String userId = userInfo.getId();
			logger.debug("userId={}, emailId={}", userId, emailId);

			int tenantId = userInfo.getTenantId();
			String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
			String userEmail = userId + "@" + domain;
			String updateAlias = emailId + "@" + domain;
			String originAlias = ezCommonService.getUserConfigInfo(tenantId, userId, "userFriendlyEmailAddress");

			returnValue = ezEmailService.updatePrimaryIndividualAlias(userEmail, originAlias, updateAlias, tenantId);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("saveUserEmail ended. returnValue={}", returnValue);

		return returnValue;
	}
	
	/**
	 * 환경설정 부재자설정 jangsewon
	 */
	@RequestMapping(value = "/ezPersonal/saveBujaeUser.do", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	@ResponseBody
	public void saveBujaeUser(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {
		response.setContentType("application/json;charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		response.getWriter().write(ezPersonalService.saveBujaeUser(loginCookie, userInfo, request, response, model).toString());
	}

	@GetMapping("/ezPersonal/notificationSetting.do")
	public String notificationSetting() {
		// 사용자가 전자결재를 사용하거나 톡 푸시를 사용한다면 PUSH 환경설정 탭을 활성화함
		// 메일만 사용하면서 톡 푸시를 사용하지 않는다면 PUSH 환경설정이 필요 없기 때문임
		return "/ezPersonal/noti/notificationSetting";
	}

	@GetMapping("/ezPersonal/notificationItemTab.do")
	public String notificationItemTab(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("notificationItemTab started.");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		Set<String> menuCodeList = ezNewPortalService.getUserMenuList(user.getCompanyID(), user.getTenantId(), user.getLang(), user.getId(), user.getDeptID())
				.stream().map(MenuInfoVO::getMenuCode).filter(Objects::nonNull).map(String::toLowerCase).collect(Collectors.toSet());
		model.addAttribute("useMail", menuCodeList.contains("mail"));
		model.addAttribute("useApproval", menuCodeList.contains("approval"));
		model.addAttribute("useEzTalkNotification", "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useEzTalkNotification", user.getTenantId())));
		model.addAttribute("useExternalMailServer", "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useExternalMailServer", user.getTenantId())));
		model.addAttribute("disableItemFinder", new PersonalNotiDisableItemVO.Finder(ezPersonalService.getAllNotiDisableItem(user.getId(), user.getTenantId())));

		String packageType = commonUtil.getPackageType(user.getTenantId());
		model.addAttribute("packageType",packageType);
		
		model.addAttribute("usePassAprLine", "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("usePassAprLine", user.getTenantId())));
		
		logger.debug("notificationItemTab ended.");
		return "/ezPersonal/noti/notificationItemTab";
	}

	@GetMapping("/ezPersonal/notificationPreferenceTab.do")
	public String notificationPreferenceTab(@CookieValue("loginCookie") String loginCookie, Model model) {
		logger.debug("notificationPreferenceTab started.");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		model.addAttribute("notiPreferences", ezPersonalService.getNotiPreferences(user.getId(), user.getTenantId()));
		logger.debug("notificationPreferenceTab ended.");
		return "/ezPersonal/noti/notificationPreferenceTab";
	}

	@PostMapping(value = "/ezPersonal/saveNotificationDisableItems.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public Result saveNotificationDisableItems(@CookieValue("loginCookie") String loginCookie, @RequestBody List<PersonalNotiDisableItemVO> disableItems) {
		logger.debug("saveNotificationDisableItems started.");
		Result result;

		try {
			LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
			ezPersonalService.setNotiDisableItems(user.getId(), user.getTenantId(), disableItems);
			result = Result.success();
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result = Result.failure();
		}

		logger.debug("saveNotificationDisableItems ended.");
		return result;
	}

	@PostMapping("/ezPersonal/saveNotificationPreferences.do")
	@ResponseBody
	public Result saveNotificationPreferences(@CookieValue("loginCookie") String loginCookie, @RequestBody PersonalNotiPreferencesVO preferencesVO) {
		logger.debug("saveNotificationPreferences started.");
		Result result;

		try {
			LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
			ezPersonalService.setNotiPreferences(user.getId(), user.getTenantId(), preferencesVO);
			result = Result.success();
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result = Result.failure();
		}

		logger.debug("saveNotificationPreferences ended.");
		return result;
	}

	@PostMapping("/ezPersonal/clearAbsence.do")
	@ResponseBody
	public String clearAbsence(@CookieValue("loginCookie") String loginCookie) {
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String proxy = "";
			String userID = userInfo.getId();
			int tenantID = userInfo.getTenantId();

			List<ApprGOutOfOfficeInfoVO> listOutOfOfficeInfo = ezApprovalGService.getListOutOfOfficeInfo(userInfo.getId(), userInfo.getTenantId());

			for (ApprGOutOfOfficeInfoVO vo : listOutOfOfficeInfo) {
				boolean isMainJob = "-1".equals(vo.getJobID());
				if (isMainJob) {
					ezOrganService.updateProperty(userID, "extensionAttribute5", proxy, "user", tenantID);
				} else {
					ezOrganService.updateAddJobProxy(userID, proxy, tenantID, vo.getDeptID(), vo.getJobID());
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "false";
		}
		return "true";
	}

	/**
	 * 공유결재자 설정 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/manageAutoSave.do", method = RequestMethod.GET)
	public String manageAutoSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("manageAutoSave started");

		userInfo = commonUtil.userInfo(loginCookie);

		String autoSaveFlag =  ezCommonService.getUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "autoSave");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("autoSaveFlag", autoSaveFlag);
		
		logger.debug("manageAutoSave ended");
		
		return "/ezPersonal/persManageAutoSave";
	}

	/**
	 * 공유결재자 추가 Method
	 */
	@RequestMapping(value = "/ezPersonal/addAutoSave.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String addAutoSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("addAutoSave started");

		userInfo = commonUtil.userInfo(loginCookie);

		String autoSaveTime = req.getParameter("autoSaveTime");
		String getPropertyValue = ezCommonService.getUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "autoSave");

		if (!getPropertyValue.equals("")) {
			ezCommonService.updateUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "autoSave", autoSaveTime);
		} else {
			ezCommonService.insertUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "autoSave", autoSaveTime);
		}

		logger.debug("addAutoSave ended");
		return "OK";
	}
}
