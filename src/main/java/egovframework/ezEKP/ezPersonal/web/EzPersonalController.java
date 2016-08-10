package egovframework.ezEKP.ezPersonal.web;

import java.security.PrivateKey;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetCurrentPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPollListUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
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
public class EzPersonalController {
	
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
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	/**
	 * 전자결재 부재자설정 끄기 Method
	 */	
	@RequestMapping(value = "/ezPersonal/saveBujae.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveBujae(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String buJaeInfo = request.getParameter("buJae");
		String buJaeInfo2 = "";
		String proxyInfo = request.getParameter("proxy");
		String proxyInfo2 = "";
		//TODO: 원래는 user를 ad에서 정보 가져오는데 임시로 하드코딩함 전자결재외에 다른 부분 발견하면 수정요망(전자결재만 존재하면 그냥 박아도됨)
		String pClass = "user";
		
		if (buJaeInfo != null && !buJaeInfo.equals("")) {
			if (buJaeInfo.split(":").length >= 5) {
				buJaeInfo2 = buJaeInfo.split(":")[0] + ":" + buJaeInfo.split(":")[1] + ":" + buJaeInfo.split(":")[2] + ":" + buJaeInfo.split(":")[3] + ":" + buJaeInfo.split(":")[4];
			}
			
			if (buJaeInfo.split(":").length > 5) {
				buJaeInfo2 += ":" + buJaeInfo.split(":")[5];
			}
		}
		
		String result = ezOrganService.updateProperty(userInfo.getId(), "extensionAttribute5", buJaeInfo2, pClass);
		
		if (result.equals("OK")) {
			if (proxyInfo.split(":").length >= 5) {
				proxyInfo2 = proxyInfo.split(":")[0] + ":" + proxyInfo.split(":")[1] + ":" + proxyInfo.split(":")[3] + ":" + proxyInfo.split(":")[4];
			}
			
			if (proxyInfo.split(":")[0].trim().equals("")) {
				result = ezOrganService.delProxyUserInfo(userInfo.getId());
			} else {
				result = ezOrganService.setProxyUserInfo(userInfo.getId(), proxyInfo.split(":")[0], proxyInfo.split(":")[1], proxyInfo.split(":")[2], proxyInfo.split(":")[3].replace("/", ":"), proxyInfo.split(":")[4].replace("/", ":"));
			}
		}
		
		return result;
	}
	
	/**
	 * 전자결재 결재환경설정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/ezApprovalConfig.do")
	public String ezApprovalConfig(Model model) throws Exception{
		String userInfoApprovalG = config.getProperty("config.UserInfo_ApprovalG");
		
		model.addAttribute("userInfoApprovalG", userInfoApprovalG);
		
		return "ezPersonal/persEzApprovalConfig";
	}
	
	/**
	 * 전자결재 결재환경설정 암호사용설정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/approvalConfig.do")
	public String approvalConfig(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String flag = "";
		String pwd = "";
		String pwdType = "";
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		ApprovPWDVO approvPWDVO = ezCommonService.getApprovPWD(userInfo.getId());
		
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
        
		return "ezPersonal/persApprovalConfig";
	}
	
	/**
	 * 전자결재 결재환경설정 암호사용설정 비번체크 표출 Method
	 */
	@RequestMapping(value = "/ezPersonal/confirmPassword.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String confirmPassword(HttpServletRequest request) throws Exception{
		String result = "";
		String oldPass = request.getParameter("oldPassword");
		String newPass = request.getParameter("newPassword");
		
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	
    	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String newTempPass = EgovFileScrty.decryptRsa(pk, newPass);
		String newPassword = EgovFileScrty.encryptPassword(newTempPass, "unknown");
	
		if (oldPass.trim().equals(newPassword)) {
			result = "OK";
		} else {
			result = "FAIL";
		}
		
		return result;
	}
	
	/**
	 * 전자결재 결재환경설정 암호사용설정 비번저장 표출 Method
	 */
	@RequestMapping(value = "/ezPersonal/saveConfig.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveConfig(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);

		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	
    	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String flag = request.getParameter("flag");
		String newPWD = request.getParameter("newPWD");
		String pwdType = request.getParameter("pwdType");
		String newTempPass = EgovFileScrty.decryptRsa(pk, newPWD);
		String newPassword = EgovFileScrty.encryptPassword(newTempPass, "unknown");
		String result = ezPersonalService.setApprovalPwd(userInfo.getId(), flag, newPassword, pwdType);
		
		return result;
	}
	
	/**
	 * 전자결재 결재환경설정 부재자설정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/manageBujaeG.do")
	public String manageBujae(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Locale locale, Model model) throws Exception{
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
		String initDate = EgovDateUtil.getTodayTime();
		
		String result = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute5");
		
		if (result != null && !result.equals("")) {
			String[] info = result.split(":");
			
			userID = info[0];
			textName = info[1];
			deptID = info[2];
			startDate = info[3];
			endDate = info[4];
			
			if (info.length > 5) {
				bReason = info[5];
			}
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().toLowerCase().indexOf("a=1;") > -1) {
			result = ezOrganService.getProxyUserInfo(userInfo.getId());
			
			Document xmlDom = commonUtil.convertStringToDocument(result);
			
			if (xmlDom.getElementsByTagName("PROXYUSERID").getLength() > 0) {
				proxyUserID = xmlDom.getElementsByTagName("PROXYUSERID").item(0).getTextContent();
				proxyDeptID = xmlDom.getElementsByTagName("PROXYUSERDEPTID").item(0).getTextContent();
				proxyUserName = xmlDom.getElementsByTagName("PROXYUSERNAME").item(0).getTextContent();
				startDate = xmlDom.getElementsByTagName("STARTDATE").item(0).getTextContent();
				endDate = xmlDom.getElementsByTagName("ENDDATE").item(0).getTextContent();

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
		
		return "ezPersonal/persManageBujae";
	}
	
	/**
	 * 전자결재 결재환경설정 부재자설정 지정 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/selectPerson.do")
	public String selectPerson(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		
		model.addAttribute("type", type);
		model.addAttribute("userInfo", userInfo);
		
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
		userInfo = commonUtil.userInfo(loginCookie);
		
		String alert = "0";
        String complite = "0";
        String bansong = "0";
        String hesong = "0";
        String callBack = "0";
        String saveMailFlag = "0";
        
        String result = ezPersonalService.getApprovNotiConfig(userInfo.getId());
        
        Document xmlDom = commonUtil.convertStringToDocument(result);
        
        if (xmlDom.getElementsByTagName("ALERT").getLength() > 0) {
        	alert = xmlDom.getElementsByTagName("ALERT").item(0).getTextContent();
            complite = xmlDom.getElementsByTagName("COMPLETE").item(0).getTextContent();
            bansong = xmlDom.getElementsByTagName("BANSONG").item(0).getTextContent();
            hesong = xmlDom.getElementsByTagName("HESONG").item(0).getTextContent();
            callBack = xmlDom.getElementsByTagName("CALLBACK").item(0).getTextContent();
            saveMailFlag = xmlDom.getElementsByTagName("SAVEMAILFLAG").item(0).getTextContent();
        }
        
        model.addAttribute("alert", alert);
        model.addAttribute("complite", complite);
        model.addAttribute("bansong", bansong);
        model.addAttribute("hesong", hesong);
        model.addAttribute("callBack", callBack);
        model.addAttribute("saveMailFlag", saveMailFlag);
        model.addAttribute("userInfo", userInfo);
        
		return "ezPersonal/persSetApprovNoticeMail";
	}
	
	/**
	 * 전자결재 결재환경설정 알림메일설정 표출 Method
	 */
	@RequestMapping(value = "/ezPersonal/setPersonalNotiMail.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setPersonalNotiMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String[] flagList = request.getParameter("email").split(";");
		String saveMailFlag = request.getParameter("sentBoxSave");
		
		String result = ezPersonalService.setApprovNotiMail(userInfo.getId(), flagList[0], flagList[1], flagList[2], flagList[3], flagList[4], saveMailFlag);
		
		return result;
	}
	
	
	@RequestMapping(value = "/ezPersonal/signimageConfig.do")
	public String signimageConfig(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String signPath = "APPROVALSIGN";
		String signImageSize = "4";
		
		if (config.getProperty("config.UserInfo_ApprovalG").equals("YES")) {
			signPath = "APPROVALGSIGN";
		}
		
		signImageSize = config.getProperty("config.SignImageSizeLimit");
		
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("signPath", signPath);
		model.addAttribute("userInfo", userInfo);
		
		return "ezPersonal/persSignimageConfig";
	}
	
	/**
	 * 포탈 설문조사 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/homePollListUser.do")
	public String homePollListUser(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		int currentPage;
		int pageSize = 10;
		boolean isPollEmpty = false;
		String votePoll = "";
		
		if (req.getParameter("page") != null && !req.getParameter("page").equals("")) {
			currentPage = Integer.parseInt(req.getParameter("page"));
		} else {
			currentPage = 1;
		}
		
		int totalCount = ezPersonalService.getPollCount(userInfo.getCompanyID());
		
		List<PersonalGetPollListUserVO> list = ezPersonalService.getPollListUser(userInfo.getCompanyID(), totalCount, pageSize, (currentPage - 1) * pageSize);
		
		int pageCount = ((totalCount + pageSize - 1) / pageSize);
		
		if (list.size() == 0) {
			isPollEmpty = true;
		} else {
			for (int i=0; i<list.size(); i++) {
				if (list.get(i).getEndDate().indexOf("1900-01-01") > -1) {
					list.get(i).setEndDate(egovMessageSource.getMessage("ezPersonal.t244",locale));
				} else {
					list.get(i).setEndDate(list.get(i).getEndDate().substring(0, 10));
				}
				list.get(i).setStartDate(list.get(i).getStartDate().substring(0, 10));
				
				if (userInfo.getLang().equals("2") && list.get(i).getPollTitle2() != null && !list.get(i).getPollTitle2().equals("")) {
					list.get(i).setPollTitle(list.get(i).getPollTitle2());
				}
				
				PersonalGetCurrentPollVO result = ezPersonalService.getCurrentPoll(userInfo.getId(), userInfo.getCompanyID());
				
				if (result != null) {
					if (result.getResult().equals("0")) {
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
		
		return "ezPersonal/persHomePollListUser";
	}
	
	/**
	 * 포탈 설문조사 투표화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/wpLightPoll.do")
	public String wpLightPoll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String labelPollTitle = "";
		String answer = "";
		String literalAnswer = "";
		String pollSeq = "";
		PersonalGetCurrentPollVO result = ezPersonalService.getCurrentPoll(userInfo.getId(), userInfo.getCompanyID());
		
		Document xmlDom = commonUtil.convertStringToDocument("<DATA>"+commonUtil.getQueryResult(result)+"</DATA>");
		
		if (result.getItemSeq() == 0) {
			labelPollTitle = egovMessageSource.getMessage("ezPersonal.t385", locale);
		} else {
			if (userInfo.getLang().equals("2") && result.getPollTitle2() != null && !result.getPollTitle2().equals("")) {
				labelPollTitle = result.getPollTitle2();
			} else {
				labelPollTitle = result.getPollTitle();
			}
			
			pollSeq = String.valueOf(result.getItemSeq());
			int count = result.getPollSelectionCount();
			
			for (int i=0; i<count; i++) {
				answer += "<input type=radio name='answer' id='answer" + i + "' value=" + (i + 1) + "><label for='answer" + i + "' style='cursor:pointer''>" + xmlDom.getElementsByTagName("ANSWER"+(i+1)).item(0).getTextContent() + "</label><br>";
			}
			
			literalAnswer = answer;
			
			if (result.getResult().equals("0")) {
				
			} else {
				
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pollSeq", pollSeq);
		model.addAttribute("literalAnswer", literalAnswer);
		model.addAttribute("labelPollTitle", labelPollTitle);
		return "ezPersonal/persWpLightPoll";
	}
	
	/**
	 * 포탈 설문조사 결과화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/pollResult.do")
	public String pollResult(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		
		return "ezPersonal/persPollResultr";
	}
	
}
