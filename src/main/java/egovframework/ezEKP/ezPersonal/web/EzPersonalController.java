package egovframework.ezEKP.ezPersonal.web;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.geom.Ellipse2D;
import java.awt.image.BufferedImage;
import java.awt.image.PixelGrabber;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.TimeZone;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.LocaleResolver;
import org.w3c.dom.Document;

import com.sun.org.apache.xml.internal.security.utils.Base64;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalAdminService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

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
	
    // dhlee
    @Autowired
    private EzEmailUserAdminService ezEmailUserAdminService;
    // dhlee - end
	
	public void setLocaleResolver(LocaleResolver localeResolver) {
    	this.localeResolver = localeResolver;
    }
	
	/**
	 * 전자결재 부재자설정 끄기 Method
	 */	
	@RequestMapping(value = "/ezPersonal/saveBujae.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveBujae(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("saveBujae started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String buJaeInfo = request.getParameter("buJae");
		String buJaeInfo2 = "";
		String proxyInfo = request.getParameter("proxy");
//		String proxyInfo2 = "";
		//TODO: 원래는 user를 ad에서 정보 가져오는데 임시로 하드코딩함 전자결재외에 다른 부분 발견하면 수정요망(전자결재만 존재하면 그냥 박아도됨)
		String pClass = "user";
		if (buJaeInfo != null && !buJaeInfo.equals("")) {
			if (buJaeInfo.split(":").length >= 5) {
				buJaeInfo2 = buJaeInfo.split(":")[0] + ":" + buJaeInfo.split(":")[1] + ":" + buJaeInfo.split(":")[2] + ":" + buJaeInfo.split(":")[3] + ":" + buJaeInfo.split(":")[4] + ":" + buJaeInfo.split(":")[5] + ":"  + buJaeInfo.split(":")[6];
			}
			
			if (buJaeInfo.split(":").length > 7) {
				buJaeInfo2 +=  ":" + buJaeInfo.split(":")[7];
			}
		}
		
		String result = ezOrganService.updateProperty(userInfo.getId(), "extensionAttribute5", buJaeInfo2, pClass, userInfo.getTenantId());
		
		if (result.equals("OK")) {
//			if (proxyInfo.split(":").length >= 5) {
//				proxyInfo2 = proxyInfo.split(":")[0] + ":" + proxyInfo.split(":")[1] + ":" + proxyInfo.split(":")[3] + ":" + proxyInfo.split(":")[4];
//			}
			
			if (proxyInfo.split(":")[0].trim().equals("")) {
				result = ezOrganService.delProxyUserInfo(userInfo.getId(), userInfo.getTenantId());
			} else {
				result = ezOrganService.setProxyUserInfo(userInfo.getId(), proxyInfo.split(":")[0], proxyInfo.split(":")[1], proxyInfo.split(":")[2], proxyInfo.split(":")[3]+":"+proxyInfo.split(":")[4].replace("/", ":"), proxyInfo.split(":")[5]+":"+proxyInfo.split(":")[6].replace("/", ":"), userInfo.getTenantId(), userInfo.getOffset());
			}
		}

		logger.debug("saveBujae ended");
		return result;
	}
	
	/**
	 * 전자결재 결재환경설정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/ezApprovalConfig.do")
	public String ezApprovalConfig(Model model, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception{
		logger.debug("ezApprovalConfig started");

		logger.debug("ezApprovalConfig ended");
		return "ezPersonal/persEzApprovalConfig";
	}
	
	/**
	 * 전자결재 결재환경설정 암호사용설정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/approvalConfig.do")
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
	@RequestMapping(value = "/ezPersonal/confirmPassword.do", produces = "text/xml;charset=utf-8")
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
		
		//결재 암호 나 로그인 암호가 같으면 인증되게--이사님이...
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
	@RequestMapping(value = "/ezPersonal/saveConfig.do", produces = "text/xml;charset=utf-8")
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
	@RequestMapping(value = "/ezPersonal/manageBujaeG.do")
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
			textName = info[1];
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
				startDate = commonUtil.getDateStringInUTC(xmlDom.getElementsByTagName("STARTDATE").item(0).getTextContent().substring(0, 16), userInfo.getOffset(), false);
				endDate = commonUtil.getDateStringInUTC(xmlDom.getElementsByTagName("ENDDATE").item(0).getTextContent().substring(0, 16), userInfo.getOffset(), false);
				
				startDate = startDate.substring(0, startDate.length()-2);
				endDate = endDate.substring(0, endDate.length()-2);
				
				startDate = commonUtil.getDateStringInUTC(startDate, userInfo.getOffset(), false);
				endDate = commonUtil.getDateStringInUTC(endDate, userInfo.getOffset(), false);
				
				textProxyName = proxyUserName;
			}
		}
		
		if (bReason.trim().equals("")) {
			bReason = messageSource.getMessage("ezPersonal.t35", locale);
		}
		
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
	@RequestMapping(value = "/ezPersonal/selectPerson.do")
	public String selectPerson(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("selectPerson started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		
		String uploadPortalPath = commonUtil.getUploadPath("upload_portal.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		model.addAttribute("type", type);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("uploadPortalPath", uploadPortalPath);

		logger.debug("selectPerson ended");
		return "ezPersonal/persSelectPerson";
	}
	
	/**
	 * 전자결재 결재환경설정 부재자설정 조직도 관련 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/checkName2.do")
	public String checkName2() throws Exception{
		return "ezPersonal/persCheckName2";
	}
	
	/**
	 * 전자결재 결재환경설정 알림메일설정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/setApprovNoticeMail.do")
	public String setApprovNoticeMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		logger.debug("setApprovNoticeMail started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String alert = "0";
		String complete = "0";
		String bansong = "0";
		String hesong = "0";
		String callBack = "0";
		String saveMailFlag = "0";
		
		String result = ezPersonalService.getApprovNotiConfig(userInfo.getId(), userInfo.getId(), userInfo.getTenantId());
		
		Document xmlDom = commonUtil.convertStringToDocument(result);
		
		if (xmlDom.getElementsByTagName("ALERT").getLength() > 0) {
			alert = xmlDom.getElementsByTagName("ALERT").item(0).getTextContent();
			complete = xmlDom.getElementsByTagName("COMPLETE").item(0).getTextContent();
			bansong = xmlDom.getElementsByTagName("BANSONG").item(0).getTextContent();
			hesong = xmlDom.getElementsByTagName("HESONG").item(0).getTextContent();
			callBack = xmlDom.getElementsByTagName("CALLBACK").item(0).getTextContent();
			saveMailFlag = xmlDom.getElementsByTagName("SAVEMAILFLAG").item(0).getTextContent();
		}
		
		model.addAttribute("alert", alert);
		model.addAttribute("complete", complete);
		model.addAttribute("bansong", bansong);
		model.addAttribute("hesong", hesong);
		model.addAttribute("callBack", callBack);
		model.addAttribute("saveMailFlag", saveMailFlag);
		model.addAttribute("userInfo", userInfo);

		logger.debug("setApprovNoticeMail ended");
		return "ezPersonal/persSetApprovNoticeMail";
	}
	
	/**
	 * 전자결재 결재환경설정 알림메일설정 표출 Method
	 */
	@RequestMapping(value = "/ezPersonal/setPersonalNotiMail.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setPersonalNotiMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("setPersonalNotiMail started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String[] flagList = request.getParameter("email").split(";");
		String saveMailFlag = request.getParameter("sentBoxSave");
		
		String result = ezPersonalService.setApprovNotiMail(userInfo.getId(), flagList[0], flagList[1], flagList[2], flagList[3], flagList[4], saveMailFlag, userInfo.getTenantId());

		logger.debug("setPersonalNotiMail ended");
		return result;
	}
	
	@RequestMapping(value = "/ezPersonal/signimageConfig.do")
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
	@RequestMapping(value = "/ezPersonal/homePollListUser.do")
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
		
		List<PersonalLightPollVO> list = ezPersonalService.getPollListUser(userInfo.getCompanyID(), totalCount, pageSize, (currentPage - 1) * pageSize, userInfo.getTenantId());
		
		int pageCount = ((totalCount + pageSize - 1) / pageSize);
		
		if (list.size() == 0) {
			isPollEmpty = true;
		} else {
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
				
				PersonalLightPollVO result = ezPersonalService.getCurrentPoll(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
				
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
	@RequestMapping(value = "/ezPersonal/wpLightPoll.do")
	public String wpLightPoll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception{
		logger.debug("wpLightPoll started");

		userInfo = commonUtil.userInfo(loginCookie);
		String labelPollTitle = "";
		String answer = "";
		String literalAnswer = "";
		String pollSeq = "";
		PersonalLightPollVO result = ezPersonalService.getCurrentPoll(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
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
				
				pollSeq = String.valueOf(result.getItemSeq());
				int count = Integer.parseInt(result.getPollSelectionCount());
				
				for (int i=0; i<count; i++) {
					answer += "<input type=radio name='answer' id='answer" + i + "' value=" + (i + 1) + "><label for='answer" + i + "' style='cursor:pointer''>" + xmlDom.getElementsByTagName("ANSWER"+(i+1)).item(0).getTextContent() + "</label><br>";
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
	@RequestMapping(value = "/ezPersonal/pollResult.do")
	public String pollResult(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception{
		logger.debug("pollResult started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String title = "";
		int totalCount = 0;
		String subject = "";
		
		String itemSeq = req.getParameter("itemSeq");
		
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
		for (int i=1; i<=count; i++) {
			listXML += "<ROW><TITLE>" + i + ". " + commonUtil.cleanValue(xmlDom.getElementsByTagName("ANSWER"+i).item(0).getTextContent()) + "</TITLE><COUNT>0</COUNT><PERCENT>0</PERCENT></ROW>";
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
			
			subject += " - " + egovMessageSource.getMessage("ezPersonal.t248", locale) + totalCount + egovMessageSource.getMessage("ezPersonal.t249", locale);
		}
		
		String strHtml = "";
		for (int i=0; i<resultDom.getElementsByTagName("ROW").getLength(); i++) {
			strHtml += "<span class='txt'>"+resultDom.getElementsByTagName("TITLE").item(i).getTextContent()+"</b>(<b>"+resultDom.getElementsByTagName("COUNT").item(i).getTextContent()+"</b>"+egovMessageSource.getMessage("ezPersonal.t247", locale) + "<span class='point'>"+resultDom.getElementsByTagName("PERCENT").item(i).getTextContent()+"</span>%)</span>";
			strHtml += "<table style='border:1px solid #c9c9c9;width:100%;height:12px;background-image:url(/images/quickpoll_bg.gif);'>";
			strHtml += "<tr>";
			strHtml += "<td style='width:"+Double.parseDouble(resultDom.getElementsByTagName("PERCENT").item(i).getTextContent())*4 +"px;background-color:rgb(245, 117, 120)'></td>";
			//pollResult 전자설문 그래프부분 브라우저에 따라 width px 조건에 맞게 처리
			if (req.getHeader("User-Agent").indexOf("Trident") > 0 || req.getHeader("User-Agent").indexOf("MSIE") > 0) {
				strHtml += "<td style='width:"+(400-Double.parseDouble(resultDom.getElementsByTagName("PERCENT").item(i).getTextContent())*4)+"px;'></td>";
			} else {
				strHtml += "<td style='width:"+(408-Double.parseDouble(resultDom.getElementsByTagName("PERCENT").item(i).getTextContent())*4)+"px;'></td>";
			}
			strHtml += "</tr>";
			strHtml += "</table>";
			strHtml += "<br>";
		}
		
		model.addAttribute("listPoll", resultDom);
		model.addAttribute("subject", subject);
		model.addAttribute("strHtml", strHtml);
		model.addAttribute("title", title);
		
		logger.debug("pollResult ended");
		return "ezPersonal/persPollResult";
	}
	
	/**
	 * 포탈 메인 생일자 리스트 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/mainBirthUserList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mainBirthUserList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception{
		logger.debug("mainBirthUserList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String curMon = "";
		
		if (req.getParameter("mon") != null && !req.getParameter("mon").equals("")) {
			curMon = req.getParameter("mon");
			if (Integer.parseInt(curMon) < 10 && curMon.length() == 1) {
				curMon = "0" + curMon;
			}
		} else {
			Calendar cal = Calendar.getInstance();
			curMon = String.valueOf(cal.get(Calendar.MONTH)+1);
		}
		
		String result = ezPersonalService.getBirthUserList(userInfo.getCompanyID(), curMon, userInfo.getTenantId());

		logger.debug("mainBirthUserList ended");
		return result;
	}
	
	/**
	 * 포탈 직원조회 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/personSearch.do")
	public String personSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("personSearch started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String searchString = "";
		if (req.getParameter("searchString") != null && !req.getParameter("searchString").equals("")) {
			searchString = req.getParameter("searchString");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("searchString", searchString);

		logger.debug("personSearch ended");
		return "/ezPersonal/persPersonSearch";
	}
	
	/**
	 * 포탈 직원조회 인쇄 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/personSearchPrint.do")
	public String personSearchPrint(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("personSearchPrint started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("personSearchPrint ended");
		return "/ezPersonal/persPersonSearchPrint";
	}
	
	
	/**
	 * 포탈 환경설정 left 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/leftEnvironment.do")
	public String leftEnvironment(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("leftEnvironment started");
		userInfo = commonUtil.userInfo(loginCookie);
		String funCode = "";
		String topMenuID = "";
		String ezInfoSSL = "";
		String SSL = "";
		
		if (req.getParameter("funCode") != null && !req.getParameter("funCode").equals("")) {
			funCode = req.getParameter("funCode");
		}
		
		if (req.getParameter("topMenuID") != null && !req.getParameter("topMenuID").trim().equals("")) {
			topMenuID = req.getParameter("topMenuID");
		}
		
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

		String accessList = ezPortalService.getAccessList(userInfo);
		
		/*
		 * 환경설정 좌측 메뉴 리스트에 있는 모듈의 URL과 이름을 map에 추가
		 * 여기에 입력한 모듈의 이름으로 사용 여부 확인 
		 */
		
		HashMap <String, String> moduleList = new HashMap<String, String>();

		moduleList.put("/ezEmail/mailMain.do", "mail");
		moduleList.put("/ezSchedule/scheduleIndex.do?funCode=2", "schedule");
		moduleList.put("/ezApprovalG/apprGMain.do", "appr");
		moduleList.put("/ezBoard/boardMain.do", "board");
		moduleList.put("/ezCommunity/communityMain.do", "community");
		moduleList.put("/ezResource/resMain.do", "res");
		moduleList.put("/ezCircular/circularIndex.do", "circular");
		moduleList.put("/ezJournal/journalMain.do", "journal");
		moduleList.put("/ezWebFolder/webfolderMain.do", "webfolder");

		HashMap<String, String> usedList = (HashMap<String, String>) ezPortalService.getMainMenuItemUIDList(accessList, moduleList, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId(), topMenuID);
		
		/*
		 * moduleList에 추가해준 모듈의 이름으로 확인 
		 */
		
		model.addAttribute("isMailUsed", usedList.get("mail"));
		model.addAttribute("isScheduleUsed", usedList.get("schedule"));
		model.addAttribute("isApprUsed", usedList.get("appr"));
		model.addAttribute("isBoardUsed", usedList.get("board"));
		model.addAttribute("isCommunityUsed", usedList.get("community"));
		model.addAttribute("isResUsed", usedList.get("res"));
		model.addAttribute("isCircularUsed", usedList.get("circular"));
		model.addAttribute("isJournalUsed", usedList.get("journal"));
		model.addAttribute("isWebfolderUsed", usedList.get("webfolder"));
		
		model.addAttribute("ezInfoSSL", ezInfoSSL);
		model.addAttribute("funCode", funCode);
		model.addAttribute("SSL", SSL);
		model.addAttribute("firstScreen_Mail", firstScreen_Mail);
        model.addAttribute("packageType", packageType);
        model.addAttribute("portalEnv", portalEnv);
        
		logger.debug("leftEnvironment ended");
		return "/ezPersonal/persLeftEnvirionment";
	}
	
	/**
	 * 포탈 환경설정 userManageWebPart 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/userManageWebPart.do")
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
	@RequestMapping(value = "/ezPersonal/changePersonInfo.do")
	public String changePersonInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("changePersonInfo started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String noneActiveX = "YES";
		// 모바일 설정
		//String radBirthType1 = "";
		//String radBirthType2 = "";
		String literalPhoto = "";
		
		String propList = "postalCode;streetAddress;homePhone;facsimileTelephoneNumber;extensionAttribute2;company;description;displayName;title;mail;telephoneNumber;mobile;info;extensionAttribute10;birth;birthType;password";
		
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
		
		/*if (userInfo.getLang().equals("1") || userInfo.getLang().equals("4")) {
			radBirthType1 = messageSource.getMessage("ezPersonal.t2001", locale);
			radBirthType2 = messageSource.getMessage("ezPersonal.t2002", locale);
		}*/
		
		String pInfo = xmlDom.getElementsByTagName("INFO").item(0).getTextContent();
		pInfo = pInfo.replace("&quot;", "\"");
		pInfo = pInfo.replace("&gt;", ">");
		pInfo = pInfo.replace("&lt;", "<");
		pInfo = pInfo.replace("&amp;", "&");
		
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
		
		if (useZipCodeSearch == null || useZipCodeSearch.equals("")) {
			useZipCodeSearch = "YES";
		}
		
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
		
		logger.debug("changePersonInfo ended");
		return "/ezPersonal/persChangePersonInfo";
	}
	
	/**
	 * 포탈 환경설정 사진삭제 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/deletePicture.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deletePicture(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("deletePicture started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String result = ezOrganService.updateProperty(userInfo.getId(), "extensionAttribute2", "", "user", userInfo.getTenantId());

		logger.debug("deletePicture ended");
		return result;
	}
	
	/**
	 * 포탈 환경설정 저장 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/saveUserInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveUserInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale, OrganUserVO vo) throws Exception {
		logger.debug("saveUserInfo started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		vo.setTenantId(userInfo.getTenantId());
		
		logger.debug("<<<1. : " + vo.getCn());
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date()); 
		vo.setNowDate(nowDate);
		
		ezOrganAdminService.updateDBData_user(vo);

		logger.debug("saveUserInfo ended");
		return "OK";
	}
	
	/**
	 * 포탈 환경설정 비밀번호 저장 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/changePassword.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String changePassword(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale, OrganUserVO vo, @RequestBody String xmlStr) throws Exception {
		logger.debug("changePassword started");

		userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();        
		
		logger.debug("tenantID=" + tenantID);       
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String oldPassword = xmlDom.getElementsByTagName("OLDPASSWORD").item(0).getTextContent();
		String newPassword = xmlDom.getElementsByTagName("NEWPASSWORD").item(0).getTextContent();
		
		int checkResult = ezPersonalService.checkPassword(userInfo.getId(), EgovFileScrty.decryptRsa(pk, oldPassword), tenantID);
		if (checkResult != 1) {
			return "CHKERROR";
		}
		
		// dhlee
		String domain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String mailAddr = userInfo.getId() + "@" + domain;
		
		// 이메일 계정의 암호를 새 암호로 설정한다.
		String decryptedOldPassword = EgovFileScrty.decryptRsa(pk, oldPassword);
		String decryptedNewPassword = EgovFileScrty.decryptRsa(pk, newPassword);
		int rc = ezEmailUserAdminService.checkAndUpdateUserPassword(mailAddr, decryptedOldPassword, decryptedNewPassword);
		
		if (rc == 0) { // checkAndUpdateUserPassword 성공                                                 
			try {
				// 로컬 시스템에서 해당 User의 암호를 변경한다.
				ezOrganAdminService.setPassword(userInfo.getId(), EgovFileScrty.decryptRsa(pk, newPassword), tenantID);
			} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
				ezEmailUserAdminService.checkAndUpdateUserPassword(mailAddr, decryptedNewPassword, decryptedOldPassword);
				
				throw e;
			}                                       
		} else {
			throw new Exception("setting the user '" + mailAddr + "' password failed.");
		}        
		// dhlee - end

		logger.debug("changePassword ended");
		return "OK";
	}
	
	/**
	 * 포탈 환경설정 언어및표준시간대설정 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/timeZone.do")
	public String timeZone(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("timeZone started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		logger.debug("primaryLang=" + primaryLang);					
		
		String usePrimaryLangOnly = config.getProperty("config.UsePrimaryLangOnly");
		
		model.addAttribute("strTimeZone", userInfo.getOffset());
		model.addAttribute("strLang", userInfo.getLang());
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("usePrimaryLangOnly", usePrimaryLangOnly);

		logger.debug("timeZone ended");
		return "/ezPersonal/persTimeZone";
	}
	
	/**
	 * 포탈 환경설정 언어및표준시간대설정 저장 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/saveUserTimeZone.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveUserTimeZone(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, HttpServletResponse resp,Locale locale) throws Exception {
		logger.debug("saveUserTimeZone started");

		userInfo = commonUtil.userInfo(loginCookie);
		String timeZone = "";
		String lang = "";
		String returnValue = "";
		
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
			if (lang != null &&lang.equals("1")) {
				returnValue = "ko";
			} else if (lang != null && lang.equals("2")) {
				returnValue = "en";
			} else if (lang != null && lang.equals("3")) {
				returnValue = "ja";
			} else if (lang != null && lang.equals("4")) {
				returnValue = "zh";
			}
			
			//CookieLocaleResolver에 lang값을 set해줌
			locale = new Locale(returnValue);
			localeResolver.setLocale(req, resp, locale);
			
			String cookieValue1 = "";
			Cookie[] cookies = req.getCookies();
			if (cookies != null) {
				for (int i=0; i<cookies.length; i++) {
					if (cookies[i].getName().equals("loginCookie")) {
						cookieValue1 = egovFileScrty.decryptAES(cookies[i].getValue());
					}
				}
				//loginCookie에 lang값, locale값 설정
				String cInfo = userInfo.getServerName() + "///" + cookieValue1.split("///")[1] + "///" + cookieValue1.split("///")[2] + "///" + cookieValue1.split("///")[3] + "///" + cookieValue1.split("///")[4] + "///" + returnValue + "///" + lang + "///" + timeZone  + "///" + userInfo.getTenantId() + "///" + userInfo.getDeptID() +  "///" + userInfo.getCompanyID();
				
				Cookie cookieID = new Cookie("loginCookie", egovFileScrty.encryptAES(cInfo));
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
	@RequestMapping(value = "/ezPersonal/personPicture.do")
	public String personPicture(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("personPicture started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userLang", userInfo.getLang());

		logger.debug("personPicture ended");
		return "/ezPersonal/persPersonPicture";
	}
	
	/**
	 * 포탈 환경설정 개인정보관리 사진업로드 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/photoUploadByUser.do")
	public String photoUploadByUser(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, MultipartHttpServletRequest req, Locale locale) throws Exception {
		logger.debug("photoUploadByUser started");

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
		
		fileName = userInfo.getId() + "." + fileName;
		filePath = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + fileName;
		filePath2 = "/ezCommon/downloadAttach.do?filePath="+commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + fileName;
		
		File file = new File(realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId())); 
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		writeUploadedFile(req.getFile("file1"), fileName, realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()));
		
		File imageFile = new File(realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()) + commonUtil.separator + fileName); 
		
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
			
			File profileImageFile = new File(realPath + filePath);
			ImageIO.write(bufferedImage, "png", profileImageFile);
			
			File file1 = new File(realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()) + commonUtil.separator + fileName);
			if (file1.exists()) {
				FileUtils.deleteQuietly(file1);
			}
			
			//썸네일 생성
			String thumbnailPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTHUMBNAIL", userInfo.getTenantId());
			File thumbnailFolder = new File(thumbnailPath);
			if (!thumbnailFolder.exists()) {
				thumbnailFolder.mkdirs();
			}
			
			File thumbnailFile = new File(thumbnailPath + commonUtil.separator + profileImageFile.getName());
			createThumbnail(profileImageFile, thumbnailFile);
		}
		
		ezOrganAdminService.updateProperty(userInfo.getId(), "extensionAttribute2", fileName, "user", userInfo.getTenantId());
		
	    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        date.setTimeZone(TimeZone.getTimeZone("GMT"));
        String nowDate = date.format(new Date()); 

        // 비즈메카톡과의 프로필 사진 연동을 위해 updateDT 필드를 갱신한다.
        ezOrganAdminService.updateProperty(userInfo.getId(), "updateDT", nowDate, "user", userInfo.getTenantId());
		
		model.addAttribute("filePath", filePath);
		model.addAttribute("filePath2", filePath2);

		logger.debug("photoUploadByUser ended");
		return "/ezPersonal/persPhotoUploadByUser";
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
		
		String pUniqueName = ezPortalAdminService.getUniqueFileName(pServerPath, imageName);
		
		byte[] byt = Base64.decode(imageData);
		String savePath = pServerPath + commonUtil.separator + pUniqueName;
		
		if (new File(savePath).exists()) {
			new File(savePath).delete();
		}
		
		InputStream myInputStream = new ByteArrayInputStream(byt);
		
		writeUploadedFile(myInputStream, pUniqueName, pServerPath);
		
		if (mode.equals("SLIDERIMAGE")) {
			BufferedImage bi = ImageIO.read(new File(savePath));	
			String pSaveName = UUID.randomUUID().toString() + ".jpg";
			BufferedImage bufferedImage = new BufferedImage(467, 200, bi.getType());
			bufferedImage.createGraphics().drawImage(bi, 0, 0, 467, 200, null);

			ImageIO.write(bufferedImage, "jpg", new File(pServerPath + commonUtil.separator + pSaveName));
			//ImageIO.write(bufferedImage, "png", new File(pAttachPath));

			File file1 = new File(savePath);
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
		    File cFile = new File(stordFilePathReal);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdir();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(stordFilePathReal + File.separator + newName);
	
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
	 */
	@RequestMapping(value = "/ezPersonal/getApprovNoticeMail.do")
	@ResponseBody
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
	@RequestMapping(value = "/ezPersonal/getNoticeList.do", produces = "text/xml;charset=utf-8")
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
	@RequestMapping(value = "/ezPersonal/showNotice.do")
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
	@RequestMapping(value = "/ezPersonal/noticeList.do")
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
		List<PersonalNoticeVO> list = ezPersonalService.getNoticeListUser(userInfo.getCompanyID(), totalCount, pageSize, (currentPage-1) * pageSize, userInfo.getTenantId());
		
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
				e1.printStackTrace();
			}
		}
		
		return result;
	}
}
