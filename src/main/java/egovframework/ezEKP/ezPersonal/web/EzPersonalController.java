package egovframework.ezEKP.ezPersonal.web;

import java.security.PrivateKey;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetCurrentPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPollListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPollResultOrderResultVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
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
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
    private LocaleResolver localeResolver;
	
	public void setLocaleResolver(LocaleResolver localeResolver) {
    	this.localeResolver = localeResolver;
    }
	
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
        model.addAttribute("userID", userInfo.getId());
        
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
		String userID = request.getParameter("userID");
		
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	
    	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String newTempPass = EgovFileScrty.decryptRsa(pk, newPass);
		String newPassword = EgovFileScrty.encryptPassword(newTempPass, userID);
	
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
		String newPassword = EgovFileScrty.encryptPassword(newTempPass, userInfo.getId());
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
		
		String title = "";
		int totalCount = 0;
		String subject = "";
		
		String itemSeq = req.getParameter("itemSeq");
		
		if (req.getParameter("answer") != null && !req.getParameter("answer").equals("")) {
			ezPersonalService.insertResult(Integer.parseInt(itemSeq), userInfo.getId(), Integer.parseInt(req.getParameter("answer")));
		}
		
		PersonalGetCurrentPollVO pollInfo = ezPersonalService.getPollInfo(Integer.parseInt(itemSeq)); 
		Document xmlDom = commonUtil.convertStringToDocument("<DATA>"+commonUtil.getQueryResult(pollInfo)+"</DATA>");
		List<PersonalGetPollResultOrderResultVO> pollResultList = ezPersonalService.getPollResult(Integer.parseInt(itemSeq));
		
		if (userInfo.getLang().equals("2") && pollInfo.getPollTitle2() != null && !pollInfo.getPollTitle2().equals("")) {
			subject = pollInfo.getPollTitle2();
		} else {
			subject = pollInfo.getPollTitle();
		}
		
		if (pollInfo.getEndDate().indexOf("1900-01-01") > -1) {
			title = pollInfo.getStartDate() + " - " + egovMessageSource.getMessage("ezPersonal.t244", locale);
		} else {
			title = pollInfo.getStartDate() + " - " + pollInfo.getEndDate();
		}
		
		int count = pollInfo.getPollSelectionCount();
		
		String listXML = "";
		for (int i=1; i<=count; i++) {
			listXML += "<ROW><TITLE>" + i + ". " + xmlDom.getElementsByTagName("ANSWER"+i).item(0).getTextContent() + "</TITLE><COUNT>0</COUNT><PERCENT>0</PERCENT></ROW>";
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
				
				resultDom.getElementsByTagName("PERCENT").item(i).setTextContent(String.valueOf(temp));
			}
			
			subject += " - " + egovMessageSource.getMessage("ezPersonal.t248", locale) + totalCount + egovMessageSource.getMessage("ezPersonal.t249", locale);
		}
		
		String strHtml = "";
		for (int i=0; i<resultDom.getElementsByTagName("ROW").getLength(); i++) {
			strHtml += "<span class='txt'>"+resultDom.getElementsByTagName("TITLE").item(i).getTextContent()+"</b>(<b>"+resultDom.getElementsByTagName("COUNT").item(i).getTextContent()+"</b>"+egovMessageSource.getMessage("ezPersonal.t247", locale) + "<span class='point'>"+resultDom.getElementsByTagName("PERCENT").item(i).getTextContent()+"</span>%)</span>";
			strHtml += "<table style='border:1px solid #c9c9c9;width:100%;height:12px;background-image:url(/images/quickpoll_bg.gif);'>";
			strHtml += "<tr>";
			strHtml += "<td style='width:"+Double.parseDouble(resultDom.getElementsByTagName("PERCENT").item(i).getTextContent())*4 +"px;background-color:#68bbef'></td>";
			strHtml += "<td style='width:"+(400-Double.parseDouble(resultDom.getElementsByTagName("PERCENT").item(i).getTextContent())*4)+"px;'></td>";
			strHtml += "</tr>";
			strHtml += "</table>";
			strHtml += "<br>";
		}
		
		model.addAttribute("listPoll", resultDom);
		model.addAttribute("subject", subject);
		model.addAttribute("strHtml", strHtml);
		model.addAttribute("title", title);
		return "ezPersonal/persPollResult";
	}
	
	/**
	 * 포탈 메인 생일자 리스트 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/mainBirthUserList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mainBirthUserList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception{
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
		
		String result = ezPersonalService.getBirthUserList(userInfo.getCompanyID(), curMon);
	
		return result;
	}
	
	/**
	 * 포탈 직원조회 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/personSearch.do")
	public String personSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String useOCS = config.getProperty("config.USE_OCS");
		String searchString = "";
		if (req.getParameter("searchString") != null && !req.getParameter("searchString").equals("")) {
			searchString = req.getParameter("searchString");
		}
System.out.println("searchString:"+searchString);
		model.addAttribute("useOCS", useOCS);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("searchString", searchString);
		
		return "/ezPersonal/persPersonSearch";
	}
	
	/**
	 * 포탈 환경설정 left 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/leftEnvironment.do")
	public String leftEnvironment(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String funCode = "";
		String ezInfoSSL = "";
		String SSL = "";
		String usePortal = "";
		
		if (req.getParameter("funCode") != null && !req.getParameter("funCode").equals("")) {
			funCode = req.getParameter("funCode");
		}
		if (config.getProperty("config.ezInfoSSL") != null && !config.getProperty("config.ezInfoSSL").equals("")) {
			 ezInfoSSL = config.getProperty("config.ezInfoSSL");
		}
		
		SSL = req.getRequestURL().toString();
		usePortal = config.getProperty("config.Use_Portal");
		
		model.addAttribute("usePortal", usePortal);
		model.addAttribute("ezInfoSSL", ezInfoSSL);
		model.addAttribute("funCode", funCode);
		model.addAttribute("SSL", SSL);
		
		return "/ezPersonal/persLeftEnvirionment";
	}
	
	/**
	 * 포탈 환경설정 userManageWebPart 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/userManageWebPart.do")
	public String userManageWebPart(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
	
		List<PersonalGetWebPartGroupVO> listGroup = ezPersonalService.getWebPartGroup(userInfo.getCompanyID(), "U");
		List<PersonalGetWebPartVO> list = ezPersonalService.getUserWebPart(userInfo.getId(), userInfo.getCompanyID(), userInfo.getDeptPathCode());
		
		model.addAttribute("listGroup", listGroup);
		model.addAttribute("list", list);
		return "/ezPersonal/persUserManageWebPart";
	}
	
	/**
	 * 포탈 환경설정 개인정보관리 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/changePersonInfo.do")
	public String changePersonInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String noneActiveX = "YES";
		// 모바일 설정
		String useMobileMgmt = "";
		String radBirthType1 = "";
		String radBirthType2 = "";
		String literalPhoto = "";
		
		String propList = "postalCode;streetAddress;homePhone;facsimileTelephoneNumber;extensionAttribute2;company;description;displayName;title;mail;telephoneNumber;mobile;info;extensionAttribute10;birth;birthType;password";
		
		String result = ezOrganService.getPropertyList(userInfo.getId(), propList, userInfo.getLang());
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
		
		if (userInfo.getLang().equals("1") || userInfo.getLang().equals("4")) {
			radBirthType1 = messageSource.getMessage("ezPersonal.t2001", locale);
			radBirthType2 = messageSource.getMessage("ezPersonal.t2002", locale);
		}
		
		String pInfo = xmlDom.getElementsByTagName("INFO").item(0).getTextContent();
		pInfo = pInfo.replace("&quot;", "\"");
		pInfo = pInfo.replace("&gt;", ">");
		pInfo = pInfo.replace("&lt;", "<");
		pInfo = pInfo.replace("&amp;", "&");
		
		if (xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() == null || xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().equals("")) {
			literalPhoto = "<img id=myimg " + messageSource.getMessage("ezPersonal.i1",locale) + ">";
		} else {
			literalPhoto = "<img id=myimg SRC='/ezCommon/downloadAttach.do?filePath=/files/upload_personal/photo/" + xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() + "' width=119 height=128>";
		}
		
		String publicModulus = egovFileScrty.getPbm();
		
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("userLang", userInfo.getLang());
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
		model.addAttribute("literalPhoto", literalPhoto);
		model.addAttribute("birthType", birthType);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("txtOldPassword", password);
		
		return "/ezPersonal/persChangePersonInfo";
	}
	
	/**
	 * 포탈 환경설정 사진삭제 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/deletePicture.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deletePicture(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String result = ezOrganService.updateProperty(userInfo.getId(), "extensionAttribute2", "", "user");
		return result;
	}
	
	/**
	 * 포탈 환경설정 저장 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/saveUserInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveUserInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale, OrganUserVO vo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		ezOrganAdminService.updateDBData_user(vo);
		return "OK";
	}
	
	/**
	 * 포탈 환경설정 비밀번호 저장 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/changePassword.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String checkPassword(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale, OrganUserVO vo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		
		return "OK";
	}
	
	/**
	 * 포탈 환경설정 언어및표준시간대설정 화면 호출 Method
	 */
	@RequestMapping(value = "/ezPersonal/timeZone.do")
	public String timeZone(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("strTimeZone", userInfo.getOffset());
		model.addAttribute("strLang", userInfo.getLang());
		return "/ezPersonal/persTimeZone";
	}
	
	/**
	 * 포탈 환경설정 언어및표준시간대설정 저장 실행 Method
	 */
	@RequestMapping(value = "/ezPersonal/saveUserTimeZone.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveUserTimeZone(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, HttpServletResponse resp,Locale locale) throws Exception {
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
			//CookieLocaleResolver에 DB에서 가져온 lang값을 set해줌
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
				String cInfo = config.getProperty("config.ServerName")+ "///" + cookieValue1.split("///")[1] + "///" + cookieValue1.split("///")[2] + "///" + cookieValue1.split("///")[3] + "///" + cookieValue1.split("///")[4] + "///" + returnValue + "///" + lang + "///" + timeZone;
			
				Cookie cookieID = new Cookie("loginCookie", egovFileScrty.encryptAES(cInfo));
	        	cookieID.setPath("/");
	        	resp.addCookie(cookieID);
			}
			
		}

		return "OK";
	}
}
