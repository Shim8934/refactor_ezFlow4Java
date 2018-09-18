package egovframework.ezEKP.ezPortal.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGgetDeptStacticsVO;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetQuickLinkMenuVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezPortal.vo.PortalFirstMainListVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetThemeListVO;
import egovframework.ezEKP.ezPortal.vo.PortalImagePortletVO;
import egovframework.ezEKP.ezPortal.vo.PortalMyPortalListVO;
import egovframework.ezEKP.ezPortal.vo.PortalNewMyPortalPageListVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalACLVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageCategoryVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortletBoardVO;
import egovframework.ezEKP.ezPortal.vo.PortalUrlPortletVO;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 스케쥴
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.07.20    지정석    신규작성
 *
 * @see
 */

@Controller
public class EzPortalController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EzPortalController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzPortalService")
	private EzPortalService ezPortalService;
	
	@Resource(name="EzPortalAdminService")
	private EzPortalAdminService ezPortalAdminService;
	
	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;
	
	@Resource(name = "EzQuestionService")
	private EzQuestionService ezQuestionService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzPollService")
	private EzPollService ezPollService;
	/**
	 * 포탈 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/portalMain.do")
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalMain Start");
				
		userInfo = commonUtil.userInfo(loginCookie);		
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
		
        if (packageType.equals(CommonUtil.PT_BASIC)
        		|| packageType.equals(CommonUtil.PT_MAIL)) {
            return "redirect:/ezEmail/mailAloneMain.do";
        }
		
		String pageID = "";
		String skinID = "1";
		String mainUrl = "";
		String topUrl = "";
		String topHeight = "78";
		
		String userPortalPage = ezPortalService.getUserInfo(userInfo.getId(), userInfo.getDisplayName1(), pageID, "1c", "view", userInfo, userInfo.getCompanyID(), locale, userInfo.getTenantId());
		
		Document xmlDom = commonUtil.convertStringToDocument(userPortalPage);
		logger.debug("userPortalPage="+userPortalPage);
		String pUserThemeUID = "";
		if (xmlDom.getElementsByTagName("ROW").getLength() > 0) {
			pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(0).getTextContent();
		} else {
			//searchMyPortalPage
			String portalPageXml = ezPortalService.searchMyPortalPage("1", "view", userInfo, userInfo.getCompanyID());
			logger.debug("portalPageXml="+portalPageXml);
			xmlDom = commonUtil.convertStringToDocument(portalPageXml);
			if (xmlDom.getElementsByTagName("ROW").getLength() > 1) {
				for (int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
					if (xmlDom.getElementsByTagName("DEFAULTPAGE").item(i).getTextContent().equals("Y")) {
						pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(i).getTextContent();
						break;
					}
				}
			} else if (xmlDom.getElementsByTagName("ROW").getLength() == 1) {
				pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(0).getTextContent();
			} else {
				if (pUserThemeUID == null || pUserThemeUID.equals("")) {
					String commentHtml = "<!DOCTYPE html><HTML>" +
							"<HEAD>" +
                            "<link href=\""+egovMessageSource.getMessage("ezPortal.i2", locale) + "\" rel=\"stylesheet\" type=\"text/css\">" +
                            "<style type='text/css'>" +
                            "<!--" +
                            ".warningbox01 { width:540px; margin:0 auto; border:1px solid #cccaca; background:#e8e8e8;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}" +
                            ".warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 15px 25px;}" +
                            ".warnintxt01 { position:relative }" +
                            ".warningimg { position:absolute; top:0px; left:0px;}" +
                            ".warningdl { padding:10px 0px 5px 150px; margin:0px 0px 0px 0px;}" +
                            ".warningdl dt { height:40px; margin-top:10px;text-align:left;}" +
                            ".warningdl dd { padding:0px 0px 0px 5px; margin:0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left;}" +
                            ".warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}" +
                            "-->" +
                            "</style>" +
                            "</HEAD>" +
                            "<BODY>" +
                            "<div class='warningbox01' style='margin-top:100px;'>" +
                            "  <div class='warningbox02'>" +
                            "    <div class='warnintxt01' >";
							if (userInfo.getRollInfo().indexOf("c=1") > -1) {
								commentHtml += "<span class='warningimg'><img src='/images/notify/admin_img.png' width='112' height='112'></span><dl class='warningdl'>";
								commentHtml += "<dt><img src='/images/admin/top_admin.gif' width='183' height='27'></dt>";
							} else {
								commentHtml += "<span class='warningimg'><img src='/images/notify/warning02.gif' width='136' height='112'></span><dl class='warningdl'>";
								commentHtml += "<dt><img src='/images/notify/warning01.gif' width='183' height='27'></dt>";
							}					
							commentHtml += "<dd>";
							if (userInfo.getRollInfo().indexOf("c=1") > -1) {
								commentHtml += "<a class=\"imgbtn\"><span style='cursor:pointer' onclick='javascript:window.open(\"/admin/main.do\", \"_parent\", \"\")'>▒ " + egovMessageSource.getMessage("ezPortal.t410", locale) + " " + egovMessageSource.getMessage("main.t00043", locale) +"</span></a> ";
							} else {
								commentHtml += egovMessageSource.getMessage("ezPortal.t286", locale);
							}
							commentHtml += "</dd>" +
							"    </dl>" +
							"    </div>" +
							"    </div>" +
							"</div>" +
							"</BODY>" +
							"</HTML>";
							resp.setCharacterEncoding("UTF-8");
							resp.setContentType("text/html; charset=UTF-8");
							resp.getWriter().write(commentHtml);
							/*resp.getWriter().flush();*/
				}
			}
		}
		
		String strXML = ezPortalService.searchTopMenu("", "Y", 1, 100, "", userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId());
		xmlDom = commonUtil.convertStringToDocument(strXML);

		if (xmlDom.getElementsByTagName("UID_").getLength() > 0) {
			Document xmlDomTop = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang(),userInfo.getTenantId()));

			String myTopID = "";
			if (xmlDomTop != null && xmlDomTop.getElementsByTagName("UID_").getLength() != 0) {
				myTopID = xmlDomTop.getElementsByTagName("UID_").item(0).getTextContent().trim();
			}
			
			for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
				if (xmlDom.getElementsByTagName("UID_").item(i).getTextContent().trim().equals(myTopID)) {
					//기본 페이지 ID
					pageID = xmlDom.getElementsByTagName("UID_").item(i).getTextContent();

					xmlDom = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang(),userInfo.getTenantId()));
					//사용자 정보
					if (xmlDom.getElementsByTagName("USERID").getLength() > 0) {
						skinID = xmlDom.getElementsByTagName("SKINNUM").item(0).getTextContent();
					}
				}
			}

			if (pageID == null || pageID.trim().equals("")) {
				for (int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
					if (pUserThemeUID.equals(xmlDom.getElementsByTagName("THEMEUID").item(i).getTextContent().trim())) {
						pageID = xmlDom.getElementsByTagName("UID_").item(i).getTextContent();
						xmlDom = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang(),userInfo.getTenantId()));
							
						if (xmlDom.getElementsByTagName("USERID").getLength() > 0) {
							skinID = xmlDom.getElementsByTagName("SKINNUM").item(0).getTextContent();
						}
					}
				}
			}
		} else {   // 다국어로 설정된 페이지가 없는경우 첫번째 사용으로 되어 있는 레이아웃 보여준다.
			String strXML2 = ezPortalService.searchTopMenu("", "Y", 1, 100, "", userInfo.getCompanyID(), userInfo.getTenantId());
			
			Document xmlDom2 = commonUtil.convertStringToDocument(strXML2);
			if (xmlDom2.getElementsByTagName("UID_").getLength() > 0) {
				Document xmlDomTop = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang(),userInfo.getTenantId()));
				
				String myTopID = "";
				if (xmlDomTop.getElementsByTagName("UID_").getLength() != 0) {
					myTopID = xmlDomTop.getElementsByTagName("UID_").item(0).getTextContent().trim();
				}
				
				for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
					if (xmlDom.getElementsByTagName("UID_").item(i).getTextContent().trim().equals(myTopID)) {
						pageID = xmlDom2.getElementsByTagName("UID_").item(i).getTextContent();
						xmlDom2 = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang(),userInfo.getTenantId()));
						if (xmlDom2.getElementsByTagName("USERID").getLength() > 0) {
							skinID = xmlDom2.getElementsByTagName("SKINNUM").item(0).getTextContent();
						}
					}
				}
				
				if (pageID != null && pageID.equals("")) {
					pageID = xmlDom2.getElementsByTagName("UID_").item(0).getTextContent();
					xmlDom2 = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang(),userInfo.getTenantId()));
					if (xmlDom2.getElementsByTagName("USERID").getLength() > 0) {
						skinID = xmlDom2.getElementsByTagName("SKINNUM").item(0).getTextContent();
					}
				}
			}
		}
		
		String themeInfoXml = ezPortalService.getThemeInfoStr(pUserThemeUID, "3",userInfo.getTenantId(), userInfo.getCompanyID());
		
		Document xmlDomACL = commonUtil.convertStringToDocument(themeInfoXml);
		logger.debug("themeInfoXml="+themeInfoXml);
		
		if (xmlDomACL != null) {
			if  (xmlDomACL.getElementsByTagName("TOPHEIGHT").getLength() != 0 && !xmlDomACL.getElementsByTagName("TOPHEIGHT").item(0).getTextContent().equals("")) {
				topHeight = xmlDomACL.getElementsByTagName("TOPHEIGHT").item(0).getTextContent();
			}
			
			if  (xmlDomACL.getElementsByTagName("TOPURL").getLength() != 0 && !xmlDomACL.getElementsByTagName("TOPURL").item(0).getTextContent().equals("")) {
				topUrl = xmlDomACL.getElementsByTagName("TOPURL").item(0).getTextContent();
				topUrl += "?mode=view&pageID=" + pageID + "&skinNum=" + skinID;
			}
			
		}
		
		//masterAdmin nullPoint처리
		//topUrl = xmlDomACL.getElementsByTagName("TOPURL").item(0).getTextContent();
		//topUrl += "?mode=view&pageID=" + pageID + "&skinNum=" + skinID;
		
		String useStartPageURL = ezPortalService.useStartPageChack2(userInfo.getId(), userInfo.getCompanyID(), pageID, userInfo.getTenantId());
		String mode = req.getParameter("mode");
		
		if (mode != null && mode.equals("new")) {
			mainUrl = "/myoffice/main/index_environment2.htm";
		} else if (mode != null && mode.equals("mail")) {
			mainUrl = "/ezEmail/mailMain.do";
		} else if (mode != null && mode.equals("approval")) {
			mainUrl = "/ezApprovalG/apprGMain.do";
		} else if (!useStartPageURL.trim().equals("NO")) {
			mainUrl = useStartPageURL;
		} else {
			mainUrl = "/ezPortal/myPortal.do";
		}
		
		if (userInfo.getLang().equals("1")) {
			//responseCookie
		} else if (userInfo.getLang().equals("2")) {
			//
		} else if (userInfo.getLang().equals("3")) {
			
		} else if (userInfo.getLang().equals("4")) {
			
		}

		model.addAttribute("mainUrl", mainUrl);
		model.addAttribute("topUrl", topUrl);
		model.addAttribute("topHeight", topHeight);
		
		return "/ezPortal/portalMain";
	}
	
	/**
	 * 포탈 상단 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/topMenu.do")
	public String topMenu(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("topMenu started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String strHTML = "";
		String pageID = "";
		String parentPageID = "";
		String mode = "";
		String editMode = "";
		String viewMode = "";
		String displayName = "";
		String displayName2 = "";
		String width = "";
		String height = "";
		//String password;
		String skinNum = "1";
		//String skinBgFlag = "";
		//String skinBgColor = "";
		//String skinBgImage = "";
		//String skinFontColor = "";
		//String skinFontOverColor = "";
		//String skinBgString = "";
		String skinExist = "NO";
		String result = "";
		//String portalMenuID = "";
		//String portalMenuXml = "";
		//int pollNum = 0;
		String script1 = "";
		//String currSkin = "";
		String langPrimary = "";
		String langSecondary = "";
		String theme = "BASIC";
		String noneActiveX = "YES";
		String pSelectThemeUID = "";
		String pThemeSelectObject = "";
		
		langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		mode = "edit";
		
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
			pageID = req.getParameter("pageID");
		} else {
			pageID = UUID.randomUUID().toString();
		}
		
		if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").equals("")) {
			parentPageID = req.getParameter("parentPageID");
		} else {
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
				parentPageID = ezPortalService.getTopMenuConfigItem("ParentUID", pageID,userInfo.getTenantId());
			} else {
				parentPageID = "top";
			}
		}
		
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		
		//체크, 삭제 쿼리 실행
		result = ezPortalService.ezAclCheck(userInfo.getId(), userInfo.getCompanyID(), userInfo.getCompanyName1(),userInfo.getTenantId());
		//관리자 권한체크
		ezPortalService.ezCkAdminACL(userInfo.getId(), pageID, result, userInfo.getLang(), userInfo.getTenantId());
		
		if (mode.equals("edit")) {
			LoginVO auth = commonUtil.checkAdmin(loginCookie);
			
			if (auth == null) {
				resp.setCharacterEncoding("UTF-8");
				resp.setContentType("text/html; charset=UTF-8");
				resp.getWriter().write(egovMessageSource.getMessage("ezPortal.t264", locale));
				resp.getWriter().flush();
			}
		}
		
		if (mode.equals("edit")) {
			if ((req.getParameter("pageID") == null || req.getParameter("pageID").equals("")) && (req.getParameter("parentPageID") != null &&!req.getParameter("parentPageID").equals(""))) {
				if (!req.getParameter("parentPageID").trim().equals("") && !req.getParameter("parentPageID").trim().toLowerCase().equals("top")) {
					editMode = "new_inherit";
				}
			}
		}
		
		//미리보기
		if (req.getParameter("viewMode") != null && !req.getParameter("viewMode").equals("")) {
			viewMode = req.getParameter("viewMode");
		}
		
		//미리보기인 경우 자기의 캐쉬정보를 삭제한다
		if (viewMode.equals("preView")) {
			ezPortalService.deleteCacheValue(pageID, ezPortalService.getAccessList(userInfo),userInfo.getTenantId());
		}
		
		//스킨정보
		if (req.getParameter("skinNum") != null && !req.getParameter("skinNum").equals("")) {
			skinNum = req.getParameter("skinNum");
		}
		
		if (userInfo.getLang().equals("1")) {
			//currSkin = skinNum;
			Cookie skinCookie = new Cookie("skinNum", skinNum);
			resp.addCookie(skinCookie);
		} else if (userInfo.getLang().equals("2")) {
			//currSkin = skinNum + "_2";
			Cookie skinCookie = new Cookie("skinNum", skinNum + "_2");
			resp.addCookie(skinCookie);
		} else if (userInfo.getLang().equals("3")) {
			//currSkin = skinNum + "_3";
			Cookie skinCookie = new Cookie("skinNum", skinNum + "_3");
			resp.addCookie(skinCookie);
		} else if (userInfo.getLang().equals("4")) {
			//currSkin = skinNum + "_4";
			Cookie skinCookie = new Cookie("skinNum", skinNum + "_4");
			resp.addCookie(skinCookie);
		}
		
		//새로만들기
		if (mode.equals("new")) {
			strHTML = ezPortalService.getDefaultTopMenu();
		} 
		// 열기 : 본문HTML, width, height정보를 가져온다
		else {
			if (editMode.equals("new_inherit")) {
				strHTML = ezPortalService.getRenderedTopMenuHTML(parentPageID, "", mode, skinNum, userInfo, theme,userInfo.getTenantId());
				width = ezPortalService.getTopMenuConfigItem("width", ezPortalService.getTopParentPageID(parentPageID,userInfo.getTenantId(), userInfo.getCompanyID()),userInfo.getTenantId());
				height = ezPortalService.getTopMenuConfigItem("height", ezPortalService.getTopParentPageID(parentPageID,userInfo.getTenantId(), userInfo.getCompanyID()),userInfo.getTenantId());
			} else {
				strHTML = ezPortalService.getRenderedTopMenuHTML(pageID, "", mode, skinNum, userInfo, theme,userInfo.getTenantId());
				width = ezPortalService.getTopMenuConfigItem("width", ezPortalService.getTopParentPageID(pageID,userInfo.getTenantId(), userInfo.getCompanyID()),userInfo.getTenantId());
				height = ezPortalService.getTopMenuConfigItem("height", ezPortalService.getTopParentPageID(pageID,userInfo.getTenantId(), userInfo.getCompanyID()),userInfo.getTenantId());
			}
		}
		
		if ((width == null  || width.equals("")) || width.equals("-1") || width.equals("0")) {
			width = "100%";
		}
		
		if (height == null || height.equals("") || height.equals("-1") || height.equals("0")) {
			height = "100%";
		}
		
		if (mode != null && !mode.equals("view")) {
			displayName = ezPortalService.getTopMenuConfigItem("DisplayName", pageID,userInfo.getTenantId());
			displayName2 = ezPortalService.getTopMenuConfigItem("DisplayName2", pageID,userInfo.getTenantId());
			pSelectThemeUID = ezPortalService.getTopMenuConfigItem("ThemeUID", pageID,userInfo.getTenantId());
			List<PortalGetThemeListVO> list = ezPortalService.getThemeList(userInfo.getCompanyID(), userInfo.getTenantId());
			String xmlStr = "<DATA>";
			for (int i=0; i<list.size(); i++) {
				xmlStr += commonUtil.getQueryResult(list.get(i));
			}
			xmlStr += "</DATA>";
			Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
			
			for (int i=0; i<list.size(); i++) {
				if (pSelectThemeUID != null && pSelectThemeUID.equals(list.get(i).getuID())) {
					pThemeSelectObject += "<option value='" + list.get(i).getuID() + "' selected>" + xmlDom.getElementsByTagName("DISPLAYNAME"+commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent() + "</option>";
				} else {
					pThemeSelectObject += "<option value='" + list.get(i).getuID() + "'>" + xmlDom.getElementsByTagName("DISPLAYNAME"+commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent()+ "</option>";
				}
			}
		}
		
		//사용자 영역에서만 팝업 공지사항을 오픈한다.
		if (mode.equals("view") && !viewMode.equals("preview")) {
			// 팝업 공지사항
			List<PersonalGetPopUpListUserVO> infoList = ezPersonalService.getPopUpListUser(userInfo.getCompanyID(), userInfo.getTenantId());
			
			String popUp = "";
			int popUpWidth = 0;
			int popUpHeight = 0;
			String popUpPosition = "";
			String cookieValue = "";
			
			for (int i=0; i<infoList.size(); i++) {
				int itemSeq = infoList.get(i).getItemSeq();
				Cookie[] cookies = req.getCookies();
				if (cookies != null) {
					for (int j=0; j<cookies.length; j++) {
						if (cookies[j].getName().equals("POPUP_"+itemSeq+"_"+userInfo.getId())) {
							cookieValue = cookies[j].getValue();
						}
					}
					
					if (cookieValue == null || cookieValue.equals("")) {
						popUpWidth = infoList.get(i).getWidth();
						popUpHeight = infoList.get(i).getHeight();
						popUpPosition = infoList.get(i).getPosition();
						popUp += "openPopup(" + itemSeq + ", " + popUpWidth + ", " + popUpHeight + ", " + popUpPosition + ");";
					}
				}
			}
			
			if (popUp != null && !popUp.equals("")) {
				script1 = "<script language='javascript'>" + popUp + "</script>";
			}
			
			//스킨정보
			strHTML = strHTML.replace("table-layout:fixed;", "");
			//topMenuId로 사용중인 모듈을 확인하기 위해서 parameter로 전달
			strHTML = strHTML.replace("/ezPortal/environmentMain.do", "/ezPortal/environmentMain.do?topMenuID=" + pageID);
			strHTML = strHTML.replace("/ezPortal/help/help.do", "/ezPortal/help/help.do?topMenuID=" + pageID);
			
			if (!mode.equals("edit") || !mode.equals("view")) {
				mode = "view";
			}
		}
		
		//jgw 관리자체크
		LoginVO checkAdmin = commonUtil.checkAdmin(loginCookie);
		if (checkAdmin != null) {
			model.addAttribute("checkAdmin", "true");
		} else {
			model.addAttribute("checkAdmin", "false");
		}
		
		//HWP사용유무
		String useHWP = ezCommonService.getTenantConfig("useHWP", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		
		//브라우저체크
		String browser = ClientUtil.getClientInfo(req, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		if (useHWP.equals("YES")) {
			isCrossBrowser = false;
		}
		
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		model.addAttribute("pageID", pageID);
		model.addAttribute("parentPageID", parentPageID);
		model.addAttribute("editMode", editMode);
		model.addAttribute("viewMode", viewMode);
		model.addAttribute("strHTML", strHTML);
		model.addAttribute("displayName", displayName);
		model.addAttribute("displayName2", displayName2);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("mode", mode);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("skinExist", skinExist);
		model.addAttribute("script1", script1);
		model.addAttribute("pThemeSelectObject", pThemeSelectObject);
		model.addAttribute("useHWP", useHWP);
		model.addAttribute("approvalFlag", approvalFlag);
		
		logger.debug("topMenu ended");
		return "/ezPortal/portalTopMenu";
	}
	
	@RequestMapping(value = "/ezPortal/portalPage.do")
	public String portalPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalPage started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String langPrimary = "";
		String langSecondary = "";
		String mode = "";
		String pageID = "";
		String parentPageID = "";
		String myPortalPageID = "";
		String editMode = "";
		String viewMode = "";
		String skinType = "";
		String pClassID = "";
		String pClassName = "";
		String theme = "BASIC";
		String tableViewOption = "D";
		String strHTML = "";
		String width = "";
		String height = "";
		String baseType = "";
		String displayName = "";
		String displayName2 = "";
		String pSelectThemeUID = "";
		String pThemeSelectObject = "";
		String gubunFlag = "";
		String portalPageCategoryXML = "";
		
		langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		mode = "edit";
		
		// 페이지 ID
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").trim().equals("")) {
			pageID = req.getParameter("pageID");
		} else {
			pageID = UUID.randomUUID().toString();
		}
		
		// 부모 페이지 ID
		if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").trim().equals("")) {
			parentPageID = req.getParameter("parentPageID");
		} else {
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").trim().equals("")) {
				parentPageID = ezPortalService.getPortalConfigItem("ParentUID", pageID, userInfo.getTenantId()); 
			} else {
				parentPageID = "top";
			}
		}
		
		// 마이포탈페이지 ID
		if (req.getParameter("myPortalPageID") != null && !req.getParameter("myPortalPageID").trim().equals("")) {
			myPortalPageID = req.getParameter("myPortalPageID");
		}
		
		if (req.getParameter("mode") != null && !req.getParameter("mode").trim().equals("")) {
			mode = req.getParameter("mode");
		}
		
		if (mode.equals("edit")) {
			// 상속된경우
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").trim().equals("") && req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").trim().equals("")) {
				if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").trim().equals("") && req.getParameter("pageID") != null && !req.getParameter("pageID").trim().toLowerCase().equals("top")) {
					editMode = "new_inherit";
				}
			}
		}
		
		// 미리보기
		if (req.getParameter("viewMode") != null &&  !req.getParameter("viewMode").trim().equals("")) {
			viewMode = req.getParameter("viewMode");
		}
		
		// 스킨폴더 정의
		Cookie[] cookies = req.getCookies();
		String skinCookieValue = "";
		
		if (cookies != null) {
			for (int i=0; i<cookies.length; i++) {
				if (cookies[i].getName().equals("skinNum")) {
					skinCookieValue = cookies[i].getValue();
				}
			}
		}
		
		if (skinCookieValue == null || skinCookieValue.equals("")) {
			Cookie skinCookie = new Cookie("skinNum", "1");
			resp.addCookie(skinCookie);
		}
		
		skinType = skinCookieValue;
		
		if (skinType == null || skinType.equals("")) {
			skinType = "1";
		}
		skinType = "skin_" + skinType;
		
		// 미리보기인 경우 자기의 캐쉬정보를 삭제한다.
		if (viewMode.equals("preview")) {
			ezPortalService.deleteCacheValue(pageID, ezPortalService.getAccessList(userInfo),userInfo.getTenantId());
		}
		
		// 부문홈에서 호출한 경우 부문홈ID
		if (req.getParameter("pClassID") != null && !req.getParameter("pClassID").trim().equals("")) {
			pClassID = req.getParameter("pClassID");
			pClassName = req.getParameter("pClassName").replace("\"", "\\\"");
		}
		
		// 부문포탈에서 호출한 경우 USERID, DISPLAYNAME 노드를 부문포탈의 정보로 변경
		if (pClassID != null && !pClassID.trim().equals("")) {
			userInfo.setId(pClassID);
			userInfo.setDisplayName1(pClassName);
		}
		
		// 새로만들기
		if (ezPortalService.getPortalConfigItem("TableViewOption", pageID, userInfo.getTenantId()) != null && !ezPortalService.getPortalConfigItem("TableViewOption", pageID, userInfo.getTenantId()).trim().equals("")) {
			tableViewOption = ezPortalService.getPortalConfigItem("TableViewOption", pageID, userInfo.getTenantId());
		} else {
			tableViewOption = "D";
		}
		
		if (mode.trim().equals("new")) {
			strHTML = ezPortalService.getDefaultPortalPage();
		} else {  // 읽기, 편집: 본문HTML, width, height정보를 가져온다
			if (editMode.equals("new_inherit")) {
				logger.debug("new_inherit");
				strHTML = ezPortalService.getRenderedPortalPageHTML(parentPageID, "", mode, userInfo, theme, tableViewOption,userInfo.getTenantId());
				width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(parentPageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
				height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(parentPageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
			} else {
				logger.debug("no new_inherit");
				strHTML = ezPortalService.getRenderedPortalPageHTML(pageID, "", mode, userInfo, theme, tableViewOption,userInfo.getTenantId());
				width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(pageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
				height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(pageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
				baseType = ezPortalService.portalPageBaseType(pageID, userInfo.getCompanyID(), userInfo.getTenantId());
				logger.debug("userInfo.getCompanyID() = "+userInfo.getCompanyID());
				logger.debug("width = "+width);
				logger.debug("height = "+height);
				logger.debug("baseType = "+baseType);
			}
		}
		
		if (width == null || width.equals("") || width.equals("-1") || width.equals("0")) {
			width = "100%";
		}
		
		if (height == null || height.equals("") || height.equals("-1") || height.equals("0")) {
			height = "100%";
		}
		
		if (mode != null && !mode.equals("view")) {
			displayName = ezPortalService.getPortalConfigItem("DisplayName", pageID, userInfo.getTenantId());
			displayName2 = ezPortalService.getPortalConfigItem("DisplayName2", pageID, userInfo.getTenantId());
			pSelectThemeUID = ezPortalService.getPortalConfigItem("ThemeUID", pageID, userInfo.getTenantId());
			pThemeSelectObject =  ezPortalService.getThemeInfoPortal(userInfo.getCompanyID(), userInfo, pSelectThemeUID);
			
			//신규 상속페이지인 경우 부모페이지의 구분정보를 가져온다.
			if (editMode != null && editMode.equals("new_inherit")) {
				gubunFlag = ezPortalService.getPortalConfigItem("GubunFlag", parentPageID, userInfo.getTenantId());
			} else {
				gubunFlag = ezPortalService.getPortalConfigItem("GubunFlag", pageID, userInfo.getTenantId());
			}
			
			List<PortalTBLPortalPageCategoryVO> list = ezPortalService.getPortalPageCategory(userInfo.getTenantId());
			portalPageCategoryXML = "<DATA>";
			for (PortalTBLPortalPageCategoryVO result : list) {
				portalPageCategoryXML += commonUtil.getQueryResult(result);
			}
			portalPageCategoryXML += "</DATA>";
			portalPageCategoryXML = portalPageCategoryXML.replace("\"", "\\\"");
		}

		model.addAttribute("strHTML", strHTML);
		model.addAttribute("pThemeSelectObject", pThemeSelectObject);
		model.addAttribute("displayName", displayName);
		model.addAttribute("displayName2", displayName2);
		model.addAttribute("mode", mode);
		model.addAttribute("parentPageID", parentPageID);
		model.addAttribute("pageID", pageID);
		model.addAttribute("baseType", baseType);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("pSelectThemeUID", pSelectThemeUID);
		model.addAttribute("gubunFlag", gubunFlag);
		model.addAttribute("myPortalPageID", myPortalPageID);
		model.addAttribute("portalPageCategoryXML", portalPageCategoryXML);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("editMode", editMode);
		model.addAttribute("tableViewOption", tableViewOption);

		logger.debug("portalPage ended");
		return "/ezPortal/portalPortalPage";
	}
	
	/**
	 * 포탈 - 마이포탈 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/myPortal.do")
	public void myPortal (HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("myPortal started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String pageID = "";
		String mode = "view";
		String gubunFlag = "1";
		String rootGubunFlag = "";
		String resetMyParentPageID = "";
		String pMoveURL = "";
		String pUserThemeUID = "";	
		
		if (req.getParameter("mode") != null &&  !(req.getParameter("mode")).equals("")) {
			mode = req.getParameter("mode");
		}
		if (req.getParameter("gubunFlag") != null && !(req.getParameter("gubunFlag")).equals("")) {
			gubunFlag = req.getParameter("gubunFlag");
		}
		if (req.getParameter("resetMyParentPageID") != null && !req.getParameter("resetMyParentPageID").equals("")) {
			resetMyParentPageID = req.getParameter("resetMyParentPageID");
		}
		
		logger.debug("mode="+mode + ", gubunFlag=" + gubunFlag + ", resetMyParentPageID=" + resetMyParentPageID);
		
		// 권한이 있는 Root페이지 정보를 가져온다.
		String pUserPageList = ezPortalService.getUserInfo(userInfo.getId(), userInfo.getDisplayName1(), pageID, gubunFlag+"c", mode, userInfo, userInfo.getCompanyID(), locale, userInfo.getTenantId());
		logger.debug("pUserPageList="+pUserPageList);
		
		Document xmlDom = commonUtil.convertStringToDocument(pUserPageList);
		
		if (resetMyParentPageID == null || resetMyParentPageID.trim().equals("")) {
			if (xmlDom.getElementsByTagName("ROW").getLength() > 0) {
				pageID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
				gubunFlag = xmlDom.getElementsByTagName("GUBUNFLAG").item(0).getTextContent();
				rootGubunFlag = gubunFlag;
				pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(0).getTextContent();
			} else {
				String portalPageXml = ezPortalService.searchMyPortalPage(gubunFlag, mode, userInfo, userInfo.getCompanyID());
				logger.debug("portalPageXml="+portalPageXml);
				xmlDom = commonUtil.convertStringToDocument(portalPageXml);
				if (xmlDom.getElementsByTagName("ROW").getLength() > 1) {
					for (int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
						if (xmlDom.getElementsByTagName("DEFAULTPAGE").item(i).getTextContent().equals("Y")) {
							pageID = xmlDom.getElementsByTagName("UID_").item(i).getTextContent();
							gubunFlag = xmlDom.getElementsByTagName("GUBUNFLAG").item(i).getTextContent();
							rootGubunFlag = gubunFlag;
							pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(i).getTextContent();
							break;
						}
					}
				} else if (xmlDom.getElementsByTagName("ROW").getLength() == 1) {
					pageID = xmlDom.getElementsByTagName("UID_").item(0).getTextContent();
					gubunFlag = xmlDom.getElementsByTagName("GUBUNFLAG").item(0).getTextContent();
					rootGubunFlag = gubunFlag;
					pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(0).getTextContent();
				}
			}
		} else {
			//권한이 있는 페이지에 대하여 개인마이페이지
			//String gubunFlag2 = "1c";
			logger.debug("권한이 있는 페이지에 대하여 개인마이페이지");
			pageID = UUID.randomUUID().toString();								
			//String newMyPortalPage = ezPortalService.newMyPortalPageCreate(resetMyParentPageID, userInfo.getId(), gubunFlag2, userInfo.getCompanyID(), pageID);
			pMoveURL = "/ezPortal/portalPage.do?mode=edit&pageID=" + pageID + "&parentPageID=" + resetMyParentPageID;
			
			resp.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html; charset=UTF-8");
			resp.getWriter().write("<script>");
			resp.getWriter().write("function window_onload() { window.location.href = \"" + pMoveURL + "\"; }");
			resp.getWriter().write("window.onload = window_onload;");
			resp.getWriter().write("</script>");
			resp.getWriter().flush();
		}
		
		if (pageID == null || pageID.equals("")) {
			String commentHtml = "<!DOCTYPE html><HTML>" +
					"<HEAD>" +
					"<link href="+egovMessageSource.getMessage("ezPortal.i2", locale) + "\" rel=\"stylesheet\" type=\"text/css\">" +
					"<style type='text/css'>" +
					"<!--" +
					".warningbox01 { width:540px; margin:0 auto; border:1px solid #cccaca; background:#e8e8e8;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}" +
					".warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 15px 25px;}" +
					".warnintxt01 { position:relative }" +
					".warningimg { position:absolute; top:0px; left:0px;}" +
					".warningdl { padding:10px 0px 5px 150px; margin:0px 0px 0px 0px;}" +
					".warningdl dt { height:40px; margin-top:10px;text-align:left;}" +
					".warningdl dd { padding:0px 0px 0px 5px; margin:0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left;}" +
					".warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}" +
					"-->" +
					"</style>" +
					"</HEAD>" +
					"<BODY>" +
					"<div class='warningbox01' style='margin-top:100px;'>" +
					"  <div class='warningbox02'>" +
					"    <div class='warnintxt01' >";
					if (userInfo.getRollInfo().indexOf("c=1") > -1) {
						commentHtml += "<span class='warningimg'><img src='/images/notify/admin_img.png' width='112' height='112'></span><dl class='warningdl'>";
						commentHtml += "<dt><img src='/images/notify/admin.png' width='183' height='27'></dt>";
					} else {
						commentHtml += "<span class='warningimg'><img src='/images/notify/warning02.gif' width='136' height='112'></span><dl class='warningdl'>";
						commentHtml += "<dt><img src='/images/notify/warning01.gif' width='183' height='27'></dt>";
					}					
					commentHtml += "<dd>";
					if (userInfo.getRollInfo().indexOf("c=1") > -1) {
						commentHtml += "<a class=\"imgbtn\"><span style='cursor:pointer' onclick='javascript:window.open(\"/admin/main.do\", \"_parent\", \"\")'>▒ " + egovMessageSource.getMessage("ezPortal.t410", locale) + " " + egovMessageSource.getMessage("main.t00043", locale) +"</span></a> ";
					} else {
						commentHtml += egovMessageSource.getMessage("ezPortal.t286", locale);
					}
					commentHtml += "</dd>" +
					"    </dl>" +
					"    </div>" +
					"    </div>" +
					"</div>" +
					"</BODY>" +
					"</HTML>";
			
			resp.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html; charset=UTF-8");
			resp.getWriter().write(commentHtml);
			resp.getWriter().close();
		}
		
		if (mode != null && mode.equals("edit") && gubunFlag.equals(rootGubunFlag)) {
			resp.getWriter().write(egovMessageSource.getMessage("ezPortal.t287", locale));
			resp.getWriter().flush();
		}
		
		if ((resetMyParentPageID == null || (resetMyParentPageID.trim()).equals("")) && mode != null && (mode.trim()).equals("edit")) {
			pMoveURL = "/ezPortal/portalPage.do?mode=" + mode + "&parentPageID=" + resetMyParentPageID;
		} else {
			String mainUrl = ezPortalService.getMainUrl(pUserThemeUID, userInfo.getTenantId(), userInfo.getCompanyID());
			logger.debug("mainUrl="+mainUrl);
			
			//2017-02-02 mainUrl이 null이 아닐때만,
			if (mainUrl != null && !mainUrl.equals("")) {
				pMoveURL = mainUrl + "?mode=" + mode + "&pageID=" + pageID;
			}
			logger.debug("pMoveURL="+pMoveURL);
		}
		
		resp.getWriter().write("<script>");
		resp.getWriter().write("function window_onload() { window.location.href = \"" + pMoveURL + "\"; }");
		resp.getWriter().write("window.onload = window_onload;");
		resp.getWriter().write("</script>");
		resp.getWriter().flush();
		resp.getWriter().close();
		
		logger.debug("myPortal ended");
	}
	
	/**
	 * 포탈 - urlPortlet 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/urlPortlet.do")
	public void urlPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("urlPortlet started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		String pMoveURL = "";
		String gubunFlag = "";
		String pUserID = userInfo.getId();
		
		if (req.getParameter("userID") != null && !req.getParameter("userID").equals("")) {
			pUserID = req.getParameter("userID");
		}
		
		Document xmlDomProp = commonUtil.convertStringToDocument(ezPortalService.getPorletPropertiesStr(uID, userInfo.getTenantId(), userInfo.getCompanyID())); 
		logger.debug("getPortletProperties="+ezPortalService.getPorletPropertiesStr(uID, userInfo.getTenantId(), userInfo.getCompanyID()));
		if (xmlDomProp.getElementsByTagName("USERTYPE").getLength() > 0) {
			gubunFlag = xmlDomProp.getElementsByTagName("GUBUNFLAG").item(0).getTextContent();
			
			if (xmlDomProp.getElementsByTagName("USERTYPE").item(0).getTextContent().trim().equals("1")) {
				logger.debug("getPortletSubProperties="+ezPortalService.getPortletSubProperties(uID, xmlDomProp.getElementsByTagName("PORTLET_TYPE").item(0).getTextContent(), userInfo.getTenantId()));
				Document xmlDomSubProp = commonUtil.convertStringToDocument(ezPortalService.getPortletSubProperties(uID, xmlDomProp.getElementsByTagName("PORTLET_TYPE").item(0).getTextContent(), userInfo.getTenantId()));
				
				if (xmlDomSubProp.getElementsByTagName("CREATORID").getLength() > 0) {
					pMoveURL = xmlDomSubProp.getElementsByTagName("URL").item(0).getTextContent();
				}
			} else {
				PortalUrlPortletVO result = ezPortalService.urlPortlet(uID, pUserID, userInfo.getTenantId());
				String resultXML = commonUtil.getQueryResult(result);
				Document xmlDomSubProp = commonUtil.convertStringToDocument(resultXML);
				
				if (xmlDomSubProp.getElementsByTagName("CREATORID").getLength() > 0) {
					pMoveURL = xmlDomSubProp.getElementsByTagName("URL").item(0).getTextContent();
				}
			}
		}
		
		String parametersXML = ezPortalService.getPortletParameters(uID, userInfo.getTenantId());
		
		if (pMoveURL != null && !pMoveURL.equals("")) {
			pMoveURL = pMoveURL + ezPortalService.loadGetParametersXML(pMoveURL, parametersXML, userInfo);
			
			if (gubunFlag.equals("2")) {
				if (pMoveURL.indexOf("?") == -1) {
					pMoveURL = pMoveURL + "?pClassID=" + pUserID;
				} else {
					pMoveURL = pMoveURL + "&pClassID=" + pUserID;
				}
			}
			
			/* 2018-08-24 새로운 포탈 */
			String type = req.getParameter("type");
			
			if (type != null && !type.equals("")) {
				if (pMoveURL.indexOf("?") == -1) {
					pMoveURL = pMoveURL + "?type=" + type;
				} else {
					pMoveURL = pMoveURL + "&type=" + type;
				}
			}
			
			resp.getWriter().write("<script> function window_onload() { window.location.href = \"" + pMoveURL + "\"; } </script>");
			resp.getWriter().write("<body onload='window_onload()'></body>");
		} else {
			resp.getWriter().write("<font style='FONT-SIZE: 9pt'> " + egovMessageSource.getMessage("ezPortal.t276", locale) + "</font>");
		}
		logger.debug("urlPortlet ended");
	}
	
	/**
	 * 포탈 - webPart NewImage 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewImage.do")
	public String wpNewImage(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("wpNewImage started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		List<PersonalSliderImageVO> sliderList = ezPersonalService.getSilderList(userInfo.getCompanyID(), "", "", userInfo.getTenantId());
		model.addAttribute("sliderList", sliderList);
		
		logger.debug("wpNewImage ended");
		return "/ezPortal/portalWpNewImage";
	}
	
	/**
	 * 포탈 - webPart 현재시간 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpTime.do")
	public String wpTime(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		return "/ezPortal/portalWpTime";
	}
	
	/**
	 * 포탈 - webPart totalSection 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpTotalSection.do")
	public String wpTotalSection(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("wpTotalSection started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String noneActiveX = "YES";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String mailAddress = "";
		String displayName = "";
		String department = "";
		String title = "";
		String companyNm = "";
		String lastLogin = "";
		String loginIP = "";
		String pollNum = "";
		String userPhoto = "";
		String userOffset = userInfo.getOffset().split("\\|")[1];
		String userApprovalG = config.getProperty("config.UserInfo_ApprovalG");
		/*근태관리 추가*/
		String serverTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String accessID = ezPortalService.getAccessList(userInfo);
		String attitudeLinkURL = "/ezAttitude/attitudeMain.do";
		String isUseAttMenuItem = "";
		mailAddress = userInfo.getEmail();
		
		if (userInfo.getPrimary().equals("1")) {
			displayName = userInfo.getDisplayName1();
			department = userInfo.getDeptName1();
			title = userInfo.getTitle1();
			companyNm = userInfo.getCompanyName1();
		} else {
			displayName = userInfo.getDisplayName2();
			department = userInfo.getDeptName2();
			title = userInfo.getTitle2();
			companyNm = userInfo.getCompanyName2();
		}
		
		lastLogin = ezOrganService.getLastLogin(userInfo.getId(), userInfo.getTenantId());
		
		if (lastLogin != null) {
			lastLogin = EgovDateUtil.convertDate(lastLogin, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "");
			lastLogin = commonUtil.getDateStringInUTC(lastLogin, userInfo.getOffset(), false);
			loginIP = ezOrganService.getLoginIP(userInfo.getId(), userInfo.getTenantId());
		} else {
			lastLogin = "";
			loginIP = "";
		}
		
		//전자설문
		pollNum = String.valueOf(ezQuestionService.wpCountPollCount(userInfo.getId(),userInfo.getTenantId(), userInfo.getOffset()));
		
		//유저이미지
		String result = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute2", userInfo.getTenantId());
		
		if (result != null && !result.equals("")) {
			userPhoto = "<img id=myimg src='/ezCommon/downloadAttach.do?filePath=" + commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId())+ commonUtil.separator + result + "' width=36 height=36>";
		} else {
			userPhoto = "";
		}
		logger.debug("userPhoto="+userPhoto);
		//2018-08-29 장진혁 - 이미지 슬라이더
		List<PersonalSliderImageVO> sliderList = ezPersonalService.getSilderList(userInfo.getCompanyID(), "", "", userInfo.getTenantId());
		
		//새로고침 시간 컨피그화
		String refreshSecond = config.getProperty("refreshSecond");
		
		boolean checkBrowser;
		if (req.getHeader("User-Agent").indexOf("Trident") < 0 && req.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
			checkBrowser = true;
		} else {
			checkBrowser = false;
		}
		
		//근태관리 사용에 따른 시계 사용 유무 로직
		isUseAttMenuItem = ezPortalService.getMainMenuItemUID(accessID, attitudeLinkURL, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId());
		String accessList = ezPortalService.getAccessList(userInfo);
		
		//근태 태넌트 추가
		String use_attitude = ezCommonService.getTenantConfig("USE_ATTITUDE", userInfo.getTenantId());
		if (use_attitude == null || use_attitude.equals("")) {
			use_attitude = "YES";
		}
		
		/*
		 * 환경설정 좌측 메뉴 리스트에 있는 모듈의 URL과 이름을 map에 추가
		 * 여기에 입력한 모듈의 이름으로 사용 여부 확인 
		 */
		
		HashMap <String, String> moduleList = new HashMap<String, String>();

//		moduleList.put("/ezEmail/mailMain.do", "mail");
//		moduleList.put("/ezSchedule/scheduleIndex.do?funCode=2", "schedule");
//		moduleList.put("/ezApprovalG/apprGMain.do", "appr");
//		moduleList.put("/ezBoard/boardMain.do", "board");
//		moduleList.put("/ezCommunity/communityMain.do", "community");
//		moduleList.put("/ezResource/resMain.do", "res");
		moduleList.put("/ezCircular/circularIndex.do", "circular");
//		moduleList.put("/ezJournal/journalMain.do", "journal");
		
		HashMap<String, String> usedList = (HashMap<String, String>) ezPortalService.getMainMenuItemUIDList(accessList, moduleList, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId(), "");
		
		Calendar cal = Calendar.getInstance();
		String curMon = String.valueOf(cal.get(Calendar.MONTH)+1);
	
		model.addAttribute("curMon", curMon);
		
		//이달의 우수사원
		String filePath = "";
		String displayNameBirth = "";
		String titleBirth = "";
		String description = "";
				
		String term = String.valueOf(cal.get(Calendar.YEAR)) + "-" + curMon;
		
		PersonalGetEmpOfMonthVO resultBirth = ezPersonalService.getEmpOfMonth(term, userInfo);
		
		if (resultBirth != null) {
			if (resultBirth.getFilePath() != null && !resultBirth.getFilePath().equals("")) {
				filePath = "/ezCommon/downloadAttach.do?&filePath="+ commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + resultBirth.getFilePath();
			} else {
				filePath = "/images/kr/main/bestEmployee_pic_none.png";
			}
			
			if (userInfo.getPrimary().equals("1")) {
				displayNameBirth = resultBirth.getDisplayName();
				titleBirth = resultBirth.getTitle();
				description = resultBirth.getDescription();
			} else {
				displayNameBirth = resultBirth.getDisplayName2();
				titleBirth = resultBirth.getTitle2();
				description = resultBirth.getDescription2();
			}
		} else {
			filePath = "/images/kr/main/bestEmployee_pic_none.png";
		}
		
		model.addAttribute("displayNameBirth", displayNameBirth);
		model.addAttribute("titleBirth", titleBirth);
		model.addAttribute("description", description);
		model.addAttribute("filePath", filePath);
		model.addAttribute("result", resultBirth);
		
		/*
		 * moduleList에 추가해준 모듈의 이름으로 확인 
		 */
		
//		model.addAttribute("isMailUsed", usedList.get("mail"));
//		model.addAttribute("isScheduleUsed", usedList.get("schedule"));
//		model.addAttribute("isApprUsed", usedList.get("appr"));
//		model.addAttribute("isBoardUsed", usedList.get("board"));
//		model.addAttribute("isCommunityUsed", usedList.get("community"));
//		model.addAttribute("isResUsed", usedList.get("res"));
		model.addAttribute("isCircularUsed", usedList.get("circular"));
//		model.addAttribute("isJournalUsed", usedList.get("journal"));
		
		model.addAttribute("displayName", displayName);
		model.addAttribute("department", department);
		model.addAttribute("title", title);
		model.addAttribute("companyNm", companyNm);
		model.addAttribute("lastLogin", lastLogin);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("mailAddress", mailAddress);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("pollNum", pollNum);
		model.addAttribute("userPhoto", userPhoto);
		model.addAttribute("userOffset", userOffset);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("refreshSecond", refreshSecond);
		model.addAttribute("host", userInfo.getServerName());
		model.addAttribute("userApprovalG", userApprovalG);
		model.addAttribute("checkBrowser", checkBrowser);
		model.addAttribute("type", req.getParameter("type"));
		model.addAttribute("sliderList", sliderList);
		model.addAttribute("loginIP", loginIP);
		//근태관리 추가
		model.addAttribute("serverTime", serverTime);
		model.addAttribute("isUseAttMenuItem", isUseAttMenuItem);
		model.addAttribute("use_attitude", use_attitude);
		
		logger.debug("wpTotalSection ended");
		return "/ezPortal/portalWpTotalSection";
	}
	
	/**
	 * 포탈 - webPart totalSection2 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpTotalSection2.do")
	public String wpTotalSection2(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("wpTotalSection2 started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String noneActiveX = "YES";
		String filePath = "";
		String displayName = "";
		String title = "";
		String description = "";
		String pCompanyBoard = "";
		String pCompanyBDNM = "";
		String pCompanyType = "";
		String pDeptBoardID = "";
		String pDeptBDNM = "";
		String pDeptType = "";
		String pNewsBoardID = "";
		String pNewsBDNM = "";
		String pNewsType = "";
		
		List<PersonalSliderImageVO> sliderList = ezPersonalService.getSilderList(userInfo.getCompanyID(), "", "", userInfo.getTenantId());
		
		Calendar cal = Calendar.getInstance();
		String term = String.valueOf(cal.get(Calendar.YEAR)) + "-" + String.valueOf(cal.get(Calendar.MONTH)+1);
		
		PersonalGetEmpOfMonthVO result = ezPersonalService.getEmpOfMonth(term, userInfo);
		
		if (result != null) {
			if (result.getFilePath() != null && !result.getFilePath().equals("")) {
				filePath = "/admin/ezOrgan/getPersonalInfo.do?fileName="+result.getFilePath();
			} else {
				filePath = "/images/default_pic.jpg";
			}
			
			if (userInfo.getPrimary().equals("2")) {
				displayName = result.getDisplayName2();
				title = result.getTitle2();
				description = result.getDescription2();
			} else {
				displayName = result.getDisplayName();
				title = result.getTitle();
				description = result.getDescription();
			}
		}
		
		if (req.getParameter("companyBoardID") != null && !req.getParameter("companyBoardID").equals("")) {
			pCompanyBoard = req.getParameter("companyBoardID");
			pCompanyBDNM = ezPortalService.getBoardProperty(pCompanyBoard, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[0];
			pCompanyType = ezPortalService.getBoardProperty(pCompanyBoard, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[1];
		}
		
		if (req.getParameter("deptBoardID") != null && !req.getParameter("deptBoardID").equals("")) {
			pDeptBoardID = req.getParameter("deptBoardID");
			pDeptBDNM = ezPortalService.getBoardProperty(pDeptBoardID, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[0];
			pDeptType = ezPortalService.getBoardProperty(pDeptBoardID, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[1];
		}
		
		if (req.getParameter("newsBoardID") != null && !req.getParameter("newsBoardID").equals("")) {
			pNewsBoardID = req.getParameter("newsBoardID");
			pNewsBDNM = ezPortalService.getBoardProperty(pNewsBoardID, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[0];
			pNewsType = ezPortalService.getBoardProperty(pNewsBoardID, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[1];
		}
		
		model.addAttribute("filePath", filePath);
		model.addAttribute("displayName", displayName);
		model.addAttribute("title", title);
		model.addAttribute("description", description);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("pCompanyBoard", pCompanyBoard);
		model.addAttribute("pCompanyBDNM", pCompanyBDNM);
		model.addAttribute("pCompanyType", pCompanyType);
		model.addAttribute("pDeptBoardID", pDeptBoardID);
		model.addAttribute("pDeptBDNM", pDeptBDNM);
		model.addAttribute("pDeptType", pDeptType);
		model.addAttribute("pNewsBoardID", pNewsBoardID);
		model.addAttribute("pNewsBDNM", pNewsBDNM);
		model.addAttribute("pNewsType", pNewsType);
		model.addAttribute("result", result);
		model.addAttribute("sliderList", sliderList);

		logger.debug("wpTotalSection2 ended");
		return "/ezPortal/portalWpTotalSection2";	
	}
	
	/**
	 * 포탈 - webPart 공지사항 & 뉴스 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewBoard.do")
	public String wpNewBoard(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("wpNewBoard started");

		userInfo = commonUtil.userInfo(loginCookie);
		String pCompanyBoard = "";        
		String pCompanyBDNM = "";
		String pCompanyType = "";
		String pDeptBoardID = "";
		String pDeptBDNM = "";
		String pDeptType = "";
		String pNewsBoardID = "";
		String pNewsBDNM = "";
		String pNewsType = "";
		
		if (req.getParameter("companyBoardID") != null && !req.getParameter("companyBoardID").equals("")) {
			pCompanyBoard = req.getParameter("companyBoardID");
			pCompanyBDNM = ezPortalService.getBoardProperty(pCompanyBoard, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[0];
			pCompanyType = ezPortalService.getBoardProperty(pCompanyBoard, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[1];
		}
		
		if (req.getParameter("deptBoardID") != null && !req.getParameter("deptBoardID").equals("")) {
			pDeptBoardID = req.getParameter("deptBoardID");
			pDeptBDNM = ezPortalService.getBoardProperty(pDeptBoardID, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[0];
			pDeptType = ezPortalService.getBoardProperty(pDeptBoardID, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[1];
		}
		
		if (req.getParameter("newsBoardID") != null && !req.getParameter("newsBoardID").equals("")) {
			pNewsBoardID = req.getParameter("newsBoardID");
			pNewsBDNM = ezPortalService.getBoardProperty(pNewsBoardID, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[0];
			pNewsType = ezPortalService.getBoardProperty(pNewsBoardID, userInfo.getPrimary(), userInfo.getTenantId()).split("\\:")[1];
		}
		
		model.addAttribute("pCompanyBoard", pCompanyBoard);
		model.addAttribute("pCompanyBDNM", pCompanyBDNM);
		model.addAttribute("pCompanyType", pCompanyType);
		model.addAttribute("pDeptBoardID", pDeptBoardID);
		model.addAttribute("pDeptBDNM", pDeptBDNM);
		model.addAttribute("pDeptType", pDeptType);
		model.addAttribute("pNewsBoardID", pNewsBoardID);
		model.addAttribute("pNewsBDNM", pNewsBDNM);
		model.addAttribute("pNewsType", pNewsType);
		
		logger.debug("wpNewBoard ended");
		return "/ezPortal/portalWpNewBoard";
	}
	
	/**
	 * 포탈 - webPart 우수사원 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewSide.do")
	public String wpNewSide(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("wpNewSide started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("wpNewSide ended");
		
		return "/ezPortal/portalWpNewSide";
	}
	
	/**
	 * 포탈 - webPart 전자결재 & 메일 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewApprMail.do")
	public String wpNewApprMail(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("wpNewApprMail started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String id = "ROOT"; // Get_Favoritelist 함수에서 id에  "ROOT"로 박아두어서 함께 복사했으나 쿼리에는 타지 않는다.
		String kind = "000"; // 양식종류 전체에 해당하는 value 값, Portal에 양식종류 선택하는 셀렉트 박스 제작시 "000" 하드코딩을 빼고 req로 값 불러올 것
		String searchType = "";
		String searchName = "";
		String type = req.getParameter("type");
		int listType = 1;
		String nowDate = EgovDateUtil.convertDate(egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "");
		nowDate = nowDate.substring(0, 16);
		
		logger.debug("wpNewApprMail type : " + type);
		
		if (type.equals("favo")) {
			List<ApprGFormVO> result = ezApprovalGService.getFormInfoByPortal(id.trim(), kind, searchType, searchName, userInfo.getId(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
			
			logger.debug("result : " + result + "    result.size() : " + result.size());
			
			model.addAttribute("result", result);
		}
		
		//2018-09-18 구해안 부재자 정보 가져오기
		String buJaeInfo = "";
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getPrimary(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(result);
		buJaeInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		
		/* 2018-08-24 새로운 포틀릿 */
		model.addAttribute("type", type);
		model.addAttribute("userApprovalG", config.getProperty("config.UserInfo_ApprovalG"));
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("host", userInfo.getServerName());
		model.addAttribute("buJaeInfo", buJaeInfo);
		model.addAttribute("nowDate", nowDate);
		model.addAttribute("listType", listType);

		logger.debug("wpNewApprMail ended");
		return "/ezPortal/portalWpNewApprMail";
	}
		
	/**
	 * 포탈 - webPart 배너 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewGWBanner.do")
	public String wpNewGWbanner(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		return "/ezPortal/portalWpNewGWBanner";
	}
	
	/**
	 * 포탈 - webPart 커뮤니티 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewCommunity.do")
	public String wpNewCommunity(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("wpNewCommunity started");

		userInfo = commonUtil.userInfo(loginCookie);
		String strHTML = ezPortalService.addBestTable(userInfo);
		
		model.addAttribute("userLang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strHTML", strHTML);

		logger.debug("wpNewCommunity ended");
		return "/ezPortal/portalWpNewCommunity";
	}
	
	/**
	 * 포탈 - webPart 게시판 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewBoardSTD.do")
	public String wpNewBoardSTD(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("wpNewBoardSTD started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String filePath = "";
		String displayName = "";
		String title = "";
		String description = "";
		
		Calendar cal = Calendar.getInstance();
		String term = String.valueOf(cal.get(Calendar.YEAR)) + "-" + String.valueOf(cal.get(Calendar.MONTH)+1);
		
		PersonalGetEmpOfMonthVO result = ezPersonalService.getEmpOfMonth(term, userInfo);
		
		if (result != null) {
			if (result.getFilePath() != null && !result.getFilePath().equals("")) {
				filePath = "/ezCommon/downloadAttach.do?&filePath="+ commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + result.getFilePath();
			} else {
				filePath = "/images/default_pic.gif";
			}
			
			if (userInfo.getPrimary().equals("1")) {
				displayName = result.getDisplayName();
				title = result.getTitle();
				description = result.getDescription();
			} else {
				displayName = result.getDisplayName2();
				title = result.getTitle2();
				description = result.getDescription2();
			}
		}
		
		model.addAttribute("displayName", displayName);
		model.addAttribute("title", title);
		model.addAttribute("description", description);
		model.addAttribute("filePath", filePath);
		model.addAttribute("result", result);
		
		logger.debug("wpNewBoardSTD ended");

		return "/ezPortal/portalWpNewBoardSTD";
	}
	
	/**
	 * 포탈 - webPart 설문참여 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewPoll.do")
	public String wpNewPoll(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("wpNewVote is running!");
		userInfo = commonUtil.userInfo(loginCookie);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		int qstId = -1;
		String qstTitle = "";
		int totalVoteToday = 0;
		int seeResultBefore = -1;
		int compareEnd = 0;
		int compareStart = 0;
		Date nowTime = new Date();
		String votePoll = "";
		int pPollItemSeq = 0;
		String pPollTitle = "";
		StringBuilder pPollResultContent = new StringBuilder();
		
		String checkFlag = ezCommonService.getTenantConfig("useBallotSystem", userInfo.getTenantId());
		
		if (checkFlag.equalsIgnoreCase("YES")) {
			//Get list of questions for user
			Set<PollQuestionVO> setOfQuestions = new HashSet<PollQuestionVO>();
			ezPollService.getAllQuestionForUser2(userInfo, setOfQuestions, "", "");
			List<PollQuestionVO> listTotalQuestions = new ArrayList<PollQuestionVO>(setOfQuestions);		
			
			if (!listTotalQuestions.isEmpty()) {
				//Get only processing poll
				for (Iterator<PollQuestionVO> iterator = listTotalQuestions.iterator(); iterator.hasNext(); ) {
					PollQuestionVO pollQstVO = iterator.next();
					Date endDate = formatter.parse(pollQstVO.getEndDate());				
					compareEnd = endDate.compareTo(nowTime);				
					
				    if (compareEnd <= 0) {
				        iterator.remove();
				    }
				    else {
				    	//baonk added 20180109
				    	Date startDate = formatter.parse(pollQstVO.getStartDate());
				    	compareStart = startDate.compareTo(nowTime);
				    	
				    	if (compareStart > 0) {
				    		iterator.remove();
				    	}
				    	//end
				    }
				}
				
				//Get list of modifying question
				List<PollQuestionVO> listOfModifyingQst = new ArrayList<PollQuestionVO>();
				
				for (PollQuestionVO pollQstVO : listTotalQuestions) {
					if (pollQstVO.getIsMofifying() == 1) {
						listOfModifyingQst.add(pollQstVO);
					}
				}
				
				//Remove all modifying questions
				listTotalQuestions.removeAll(listOfModifyingQst);
				
				if (!listTotalQuestions.isEmpty()) {
					//Sort listQuestions by question id					
					Collections.sort(listTotalQuestions, (PollQuestionVO qst1, PollQuestionVO qst2) -> {
				        return Integer.valueOf(qst1.getQstId()).compareTo(qst2.getQstId());
					});		
					
					PollQuestionVO question = listTotalQuestions.get(listTotalQuestions.size() - 1);
					qstTitle = question.getTitle();
					qstId = question.getQstId();			
					seeResultBefore = question.getResultFirst();			
					
					//Get list of Options		
					List<PollAnswerVO> listOptions = ezPollService.getListOptionsOfQst(qstId, userInfo.getTenantId());
					
					//Sort list of options by number of votes
					Collections.sort(listOptions, (PollAnswerVO answer1, PollAnswerVO answer2) -> {
				        return Integer.valueOf(answer2.getVotesNumber()).compareTo(answer1.getVotesNumber());
					});
			
					totalVoteToday = listTotalQuestions.size();
					
					model.addAttribute("listOptions", listOptions);
					model.addAttribute("numberOfOptions", listOptions.size());				
				}
			}
			
			model.addAttribute("qstTitle", qstTitle);		
			model.addAttribute("qstId", qstId);	
			model.addAttribute("tenantId", userInfo.getTenantId());			
			model.addAttribute("seeResultBefore", seeResultBefore);
			model.addAttribute("totalVoteToday", totalVoteToday);
			
			logger.debug("wpNewVote finishes");
			return "/ezPortal/portalWpNewVote";
		}
		else {			
			PersonalLightPollVO result = ezPersonalService.getCurrentPoll(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
			
			Document xmlDom = commonUtil.convertStringToDocument("<DATA>"+commonUtil.getQueryResult(result)+"</DATA>");
			
			if (result != null) {
				if (result.getResult() > 0) {
					if (result.getResult() != 0) {
						votePoll = Integer.toString(result.getResult());
					}
				} else {
					votePoll = "";
				}	
				
				if (result.getItemSeq() > 0) {
					if (result.getItemSeq() != 0) {
						pPollItemSeq = result.getItemSeq();
						int maxAns = Integer.parseInt(result.getPollSelectionCount());
						pPollTitle = userInfo.getPrimary().equals("1") ? result.getPollTitle() : result.getPollTitle2();
						
						List<PersonalLightPollVO> list = ezPersonalService.getPollResultOrderResult(pPollItemSeq, userInfo.getTenantId());
						
						int pTotalCnt = 0;
						
						for (int i=0; i<list.size(); i++) {
							pTotalCnt = pTotalCnt + list.get(i).getCount();
						}
						
						List<Integer> pPollResultList = new ArrayList<Integer>();
						int resultPrintCnt = 0;
						
						for (int i=0; i<list.size(); i++) {
							if (i >= 4) {
								break;
							} else {
								float poolRstCnt = list.get(i).getCount();
								float poolRstPer = ((poolRstCnt / pTotalCnt) * 100);
								String strAnswer =  xmlDom.getElementsByTagName("ANSWER"+list.get(i).getResult()).item(0).getTextContent();
								String titleString = strAnswer;
								
								pPollResultList.add(list.get(i).getResult());								
								
								pPollResultContent.append("<li class='voteList_0"+ (i+1) +"'><div class='voteT'><span class='Vnum'>"+ list.get(i).getResult() + "</span><span class='Vtext'>" + titleString + "</span></div>");
								pPollResultContent.append("<div class='percent'>" + String.format("%.1f", poolRstPer) + "%</div>");
								pPollResultContent.append("<div class='voteGraph'><span style='width:" + Math.round((poolRstCnt / pTotalCnt) * 100) + "%'></span></div></li>");
								
		                        resultPrintCnt++;
							}
						}
						
						if (resultPrintCnt < 4) {
							for (int i=1; i<=maxAns; i++) {
								boolean isDuplication = false;
								for (int j=0; j<pPollResultList.size(); j++) {
									if (i == pPollResultList.get(j)) {
										isDuplication = true;
										break;
									}
								}
								
								if (!isDuplication) {
									String strAnswer = xmlDom.getElementsByTagName("ANSWER"+i).item(0).getTextContent();
									String titleString = strAnswer;
									
									/* 2018-09-10 홍승비 - 비어있는 설문조사 보기 생성 */
									pPollResultContent.append("<li class='voteList_0"+(resultPrintCnt+1)+"'><div class='voteT'><span class='Vnum'>"+ i + "</span><span class='Vtext'>" + titleString + "</span></div>");
									pPollResultContent.append("<div class='percent'>0%</div>");
									pPollResultContent.append("<div class='voteGraph'><span style='width:0%'></span></div></li>");
									
									resultPrintCnt++;
									
									if (resultPrintCnt == 4) {
										break;
									}
								}
							}
						}
					}
				}
			}

			model.addAttribute("pPollTitle", pPollTitle);
			model.addAttribute("votePoll", votePoll);
			model.addAttribute("pPollItemSeq", pPollItemSeq);
			model.addAttribute("pPollResultContent", pPollResultContent.toString());
			model.addAttribute("userLang", userInfo.getLang());
			
			logger.debug("wpNewPoll End");
			return "/ezPortal/portalWpNewPoll";
		}	
		
	}
	
	
	/**
	 * 포탈 - webPart 결재 통계 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewGraph.do")
	public String wpNewGraph(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("wpNewGraph started");

		userInfo = commonUtil.userInfo(loginCookie);
		int dMaxCount = 0;
		int sMaxCount = 0;
		
		Calendar cal = Calendar.getInstance();
		String startDate = String.valueOf(cal.get(Calendar.YEAR)) + "-" + String.valueOf(cal.get(Calendar.MONTH)) + "-01 00:00:00";
		String endDate = String.valueOf(cal.get(Calendar.YEAR)) + "-" + String.valueOf(cal.get(Calendar.MONTH)) + "-" +  ezPortalService.daysInMonth(cal.get(Calendar.MONTH), cal.get(Calendar.YEAR)) + " 23:59:59";
		
		if (startDate != null && startDate.split("-")[1].equals("0")) {
			startDate = String.valueOf(cal.get(Calendar.YEAR)-1) + "-" + "12" + "-01 00:00:00";
		}
		
		if (endDate != null && endDate.split("-")[1].equals("0")) {
			endDate = String.valueOf(cal.get(Calendar.YEAR)-1) + "-" + "12" + "-" + ezPortalService.daysInMonth(12, cal.get(Calendar.YEAR)-1) + " 23:59:59";
		}
		
		logger.debug("startDate="+startDate+", endDate="+endDate);
		
		List<ApprGgetDeptStacticsVO> list = ezApprovalGService.getDeptStactics(startDate, endDate, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		String dMax = "1";
		
		if (list.size() > 0) {
			for (int j=0; j<String.valueOf(list.get(0).getDraftCount()).length() - 1; j++) {
				dMax = dMax + "0";
			}
			
			dMaxCount = list.get(0).getDraftCount() + Integer.parseInt(dMax);
			sMaxCount = list.get(0).getSusinCount() + Integer.parseInt(dMax);
			
			for (int i=0; i<list.size(); i++) {
				if (sMaxCount < list.get(i).getSusinCount() + Integer.parseInt(dMax)) {
					sMaxCount = list.get(i).getSusinCount() + Integer.parseInt(dMax);
				}
			}
			dMaxCount = dMaxCount + sMaxCount;
			
			logger.debug("listSize="+list.size());
			for (int i=0; i<list.size(); i++) {
				logger.debug("draftCount="+list.get(i).getDraftCount());
				logger.debug("susinCount="+list.get(i).getSusinCount());
				float draftPercent = (float)list.get(i).getDraftCount() / dMaxCount * 100;
				float susinPercent = (float)list.get(i).getSusinCount() / dMaxCount * 100;
				
				list.get(i).setDraftCount((int)(draftPercent));
				list.get(i).setSusinCount((int)(susinPercent));
			}
		} else {
			dMax = "0";
			dMaxCount = 0;
		}
		logger.debug("dMaxCount="+dMaxCount);
		
		model.addAttribute("dMaxCount", dMaxCount);
		model.addAttribute("list", list);

		logger.debug("wpNewGraph ended");
		return "/ezPortal/portalWpNewGraph";
	}
	
	/**
	 * 포탈 - webPart 썸네일게시판 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewPhoto.do")
	public String wpNewPhoto(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String pPhotoGalleryID = "";
		
		if (req.getParameter("photoGalleryID") != null && !req.getParameter("photoGalleryID").equals("")) {
			pPhotoGalleryID = req.getParameter("photoGalleryID");
		}
		
		if (pPhotoGalleryID != null && !pPhotoGalleryID.equals("")) {
			model.addAttribute("pExist", "true");
		} else {
			model.addAttribute("pExist", "false");
		}
		
		model.addAttribute("pPhotoGalleryID", pPhotoGalleryID);
		return "/ezPortal/portalWpNewPhoto";
	}
	
	/**
	 * 포탈 - webPart 이달의생일 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewBirth.do")
	public String wpNewBirth(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		Calendar cal = Calendar.getInstance();
		String curMon = String.valueOf(cal.get(Calendar.MONTH)+1);
	
		model.addAttribute("curMon", curMon);	
		model.addAttribute("userInfo", userInfo);
		
		return "/ezPortal/portalWpNewBirth";
	}
	
	/**
	 * 포탈 - webPart totalSection5 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpTotalSection5.do")
	public String wpTotalSection5(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		Calendar cal = Calendar.getInstance();
		String curMon = String.valueOf(cal.get(Calendar.MONTH)+1);
		String pPhotoGalleryID = "";
			
		if (req.getParameter("photoGalleryID") != null && !req.getParameter("photoGalleryID").equals("")) {
			pPhotoGalleryID = req.getParameter("photoGalleryID");
		}
		
		model.addAttribute("curMon", curMon);	
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pPhotoGalleryID", pPhotoGalleryID);
		
		return "/ezPortal/portalWpTotalSection5";
	}
	
	/**
	 * 포탈 - webPart getQuickLink 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/getQuickLink.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getQuickLink(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("getQuickLink started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		int noViewCnt = 0;
		int cnt = 0;
		int page = Integer.parseInt(req.getParameter("page"));
		
		String[] noViewArrayID = new String[1000];
		String[] arrayID = new String[1000];
		StringBuilder result = new StringBuilder("<DATA>");
		
		List<PersonalGetQuickLinkMenuVO> realList = new ArrayList<PersonalGetQuickLinkMenuVO>();
		
		String deptFullPath = ezOrganService.getDeptFullPath(userInfo.getDeptID(), userInfo.getTenantId());
		
		String[] splitDeptPath = new String[deptFullPath.split("\\,").length];
		String reversePath = "";
		splitDeptPath = deptFullPath.split("\\,");
		
		for (int i=0; i<splitDeptPath.length; i++) {
			reversePath += splitDeptPath[splitDeptPath.length - i - 1] + ",";
		}
		
		String pAccessID = userInfo.getId() + "," + reversePath + "everyone";
		
		for (int j=0; j<pAccessID.split("\\,").length; j++) {
			List<PersonalGetQuickLinkMenuVO> getQuickLinkMenu = ezPersonalService.getQuickLinkMenu(pAccessID.split("\\,")[j].trim(), userInfo.getTenantId());
			for (int k=0; k<getQuickLinkMenu.size(); k++) {
				boolean TF = true;
				if (getQuickLinkMenu.get(k) != null && getQuickLinkMenu.get(k).getView_Flag().equals("N")) {
					noViewArrayID[noViewCnt] = getQuickLinkMenu.get(k).getQuickLinkID();
					noViewCnt++;
				} else {
					for (int z=0; z < noViewCnt; z++) {
						if (noViewArrayID != null && noViewArrayID[z].equals(getQuickLinkMenu.get(k).getQuickLinkID())) {
							TF = false;
							break;
						}
					}
					
					for (int i=0; i < cnt; i++) {
						if (arrayID[i] != null && arrayID[i].equals(getQuickLinkMenu.get(k).getQuickLinkID())) {
							TF = false;
							break;
						}
					}
					
					if (TF) {
						arrayID[cnt] = getQuickLinkMenu.get(k).getQuickLinkID();
						realList.add(getQuickLinkMenu.get(k));						
						cnt ++;
					}
				}
			}
		}
		
		int lastSize = 0;
		
		if (page+5 >= realList.size()) {
			lastSize = realList.size();
		} else {
			lastSize = page+5;
		}
		
		for (int z=page; z < lastSize; z++) {
			result.append(commonUtil.getQueryResult(realList.get(z)));
		}
		
		result.append("<SIZE><PAGE>" + realList.size() + "</PAGE></SIZE></DATA>");

		logger.debug("quickLinkXML="+result.toString());
		logger.debug("getQuickLink ended");
		
		return result.toString();
	}
	
	/**
	 * 포탈 - webPart 테마1 totalSection 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpTotalSection.do")
	public String theme1wpTotalSection(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("wpTotalSection started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String noneActiveX = "";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String mailAddress = "";
		String displayName = "";
		String department = "";
		String title = "";
		String companyNm = "";
		String userApprovalG = "";
		String lastLogin = "";
		String pollNum = "";
		String userPhoto = "";
		
		noneActiveX = "YES";
		
		mailAddress = userInfo.getEmail();
		
		if (userInfo.getPrimary().equals("1")) {
			displayName = userInfo.getDisplayName1();
			department = userInfo.getDeptName1();
			title = userInfo.getTitle1();
			companyNm = userInfo.getCompanyName1();
		} else {
			displayName = userInfo.getDisplayName2();
			department = userInfo.getDeptName2();
			title = userInfo.getTitle2();
			companyNm = userInfo.getCompanyName2();
		}
		
		userApprovalG = config.getProperty("config.UserInfo_ApprovalG"); 
		
		lastLogin = ezOrganService.getLastLogin(userInfo.getId(), userInfo.getTenantId());
		lastLogin = EgovDateUtil.convertDate(lastLogin, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "");
		lastLogin = commonUtil.getDateStringInUTC(lastLogin, userInfo.getOffset(), false);
		
		//전자설문
		pollNum = String.valueOf(ezQuestionService.wpCountPollCount(userInfo.getId(),userInfo.getTenantId(), userInfo.getOffset()));
		
		//유저이미지
		String result = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute2", userInfo.getTenantId());
		
		if (result != null && !result.equals("")) {
			userPhoto = "<img id=myimg src='/ezCommon/downloadAttach.do?filePath=" + commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId())+ commonUtil.separator + result + "' width=61 height=64>";
		} else {
			userPhoto = "<img src='/images/default_pic.jpg' width='61' height='64'>";
		}
		
		logger.debug("userPhoto="+userPhoto);
		
		model.addAttribute("displayName", displayName);
		model.addAttribute("department", department);
		model.addAttribute("title", title);
		model.addAttribute("companyNm", companyNm);
		model.addAttribute("userApprovalG", userApprovalG);
		model.addAttribute("lastLogin", lastLogin);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("mailAddress", mailAddress);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("pollNum", pollNum);
		model.addAttribute("userPhoto", userPhoto);
		model.addAttribute("useEditor", useEditor);
		
		logger.debug("wpTotalSection ended");
		return "/ezPortal/theme1/portalTheme1WpTotalSection";
	}
	
	/**
	 * 포탈 - webPart 테마1 공지사항 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemeNotice.do")
	public String theme1wpThemeNotice(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("theme1wpThemeNotice started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("theme1wpThemeNotice ended");
		return "/ezPortal/theme1/portalTheme1WpThemeNotice";
	}
	
	/**
	 * 포탈 - webPart 테마1 메일 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemeMail.do")
	public String theme1wpThemeMail(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("theme1wpThemeMail started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("theme1wpThemeMail ended");
		return "/ezPortal/theme1/portalTheme1WpThemeMail";
	}
	
	/**
	 * 포탈 - webPart 테마1 메일 그래프 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemeMailGraph.do")
	public String theme1wpThemeMailGraph(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("theme1wpThemeMaiGraph started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("theme1wpThemeMailGraph ended");
		return "/ezPortal/theme1/portalTheme1WpThemeMailGraph";
	}
	
	/**
	 * 포탈 - webPart 테마1 일정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemeCalendar.do")
	public String theme1wpThemeCalendar(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("theme1wpThemeCalendar started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("theme1wpThemeCalendar ended");
		return "/ezPortal/theme1/portalTheme1WpThemeCalendar";
	}
	
	/**
	 * 포탈 - webPart 테마1 결재 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemeAppr.do")
	public String theme1wpThemeAppr(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("theme1wpThemeAppr started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userApprovalG", config.getProperty("config.UserInfo_ApprovalG"));
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("theme1wpThemeAppr ended");
		return "/ezPortal/theme1/portalTheme1WpThemeAppr";
	}
	
	/**
	 * 포탈 - webPart 테마1 생일 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemeBirth.do")
	public String theme1wpThemeBirth(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("theme1wpThemeAppr started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		Calendar cal = Calendar.getInstance();
		String curMon = String.valueOf(cal.get(Calendar.MONTH)+1);
	
		model.addAttribute("curMon", curMon);	
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("theme1wpThemeBirth ended");
		return "/ezPortal/theme1/portalTheme1WpThemeBirth";
	}
	
	/**
	 * 포탈 - webPart 테마1 게시판 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemeBoard.do")
	public String theme1wpThemeBoard(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("theme1wpThemeBoard started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String pBoardType = "";
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pBoardType", pBoardType);
		
		logger.debug("theme1wpThemeBoard ended");
		return "/ezPortal/theme1/portalTheme1WpThemeBoard";
	}
	
	/**
	 * 포탈 - webPart 테마1 설문 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemePoll.do")
	public String theme1wpThemePoll(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("theme1wpThemePoll started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String votePoll = "";
		int pPollItemSeq = 0;
		String pPollTitle = "";
		
		PersonalLightPollVO result = ezPersonalService.getCurrentPoll(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (result != null) {
			if (result.getResult() > 0) {
				if (result.getResult() != 0) {
					votePoll = Integer.toString(result.getResult());
				}
			} else {
				votePoll = "";
			}	
			
			if (result.getItemSeq() > 0) {
				if (result.getItemSeq() != 0) {
					pPollItemSeq = result.getItemSeq();
					pPollTitle = userInfo.getPrimary().equals("1") ? result.getPollTitle() : result.getPollTitle2();
				}	
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("votePoll", votePoll);
		model.addAttribute("pPollItemSeq", pPollItemSeq);
		model.addAttribute("pPollTitle", pPollTitle);
		
		logger.debug("theme1wpThemePoll ended");
		return "/ezPortal/theme1/portalTheme1WpThemePoll";
	}
	
	/**
	 * 포탈 - webPart 테마1 포토게시판 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemePhoto.do")
	public String theme1wpThemePhoto(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("theme1wpThemePhoto started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pPhotoGalleryID = "";
		
		if (req.getParameter("photoGalleryID") != null && !req.getParameter("photoGalleryID").equals("")) {
			pPhotoGalleryID = req.getParameter("photoGalleryID");
		}
		
		String boardString = ezBoardService.getThumbListXML(userInfo, "4", pPhotoGalleryID, 1, "", "");
		logger.debug("boardString="+boardString);
		
		Document xmlDom = commonUtil.convertStringToDocument(boardString);
		StringBuilder sb = new StringBuilder();
		
		if (xmlDom.getElementsByTagName("ROW").getLength() > 0) {
			sb.append("<div id=\"content_1\" class=\"photocont\">");
			sb.append("<div class=\"images_container\" id=\"images_container\">");
            
			for (int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
				String imgSrc = xmlDom.getElementsByTagName("DATA5").item(i).getTextContent();
				String itemID = xmlDom.getElementsByTagName("DATA2").item(i).getTextContent();
				String boardID = xmlDom.getElementsByTagName("DATA1").item(i).getTextContent();
				
				if (i % 2 == 0) {
					sb.append("<ul>");
					sb.append("<li>");
					sb.append("<img style=\"cursor:pointer;\" onclick=\"ItemRead_onclick(this)\" src=\"" + "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + boardID + "&fileName=" + imgSrc.substring(imgSrc.lastIndexOf("/") + 1, imgSrc.length()) + "\" width=\"65\" height=\"65\" onclick=\"ItemRead_onclick(this)\" DATA1=\"" + boardID + "\" DATA2=\"" + itemID + "\">");
                    
					sb.append("</li>");
                    if (i == (xmlDom.getElementsByTagName("ROW").getLength() - 1)) {
                    	sb.append("</ul>");
                    }
				} else {
					sb.append("<li>");
					sb.append("<img style='cursor:pointer;' onclick='ItemRead_onclick(this)' src=\"" + "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + boardID + "&fileName=" + imgSrc.substring(imgSrc.lastIndexOf("/") + 1, imgSrc.length()) + "\" width=\"65\" height=\"65\" onclick=\"ItemRead_onclick(this)\" DATA1=\"" + boardID + "\" DATA2=\"" + itemID + "\">");
					sb.append("</li>");
					sb.append("</ul>");
				}
			}
			sb.append("</div>");
			sb.append("</div>");
			
		} else {
			sb.append("<div class=\"nodata_h\">");
            sb.append("<p><img src=\"/images/kr/theme01/main/nodata_gray.png\" ></p>");
            sb.append("<p>" + egovMessageSource.getMessage("main.t00026", locale) + "</p>");
            sb.append("</div>");
		}
		
//		logger.debug("strHTML="+sb.toString());
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strHTML", sb.toString());
		
		logger.debug("theme1wpThemePhoto ended");
		return "/ezPortal/theme1/portalTheme1WpThemePhoto";
	}
	
	/**
	 * 포탈 - webPart 테마1 커뮤니티 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemeComm.do")
	public String theme1wpThemeComm(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("theme1wpThemeComm started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("theme1wpThemeComm ended");
		return "/ezPortal/theme1/portalTheme1WpThemeComm";
	}
	
	/**
	 * 포탈 - webPart 테마1 배너 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/wpThemeBanner.do")
	public String theme1wpThemeBanner(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("theme1wpThemeBanner started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String langType = "kr";
		
		switch (userInfo.getLang()) {
            case "1": langType = "kr"; break;
            case "2": langType = "us"; break;
            case "3": langType = "jp"; break;
            case "4": langType = "cn"; break;
            default:
                break;
        }
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("langType", langType);
		
		logger.debug("theme1wpThemeBanner ended");
		return "/ezPortal/theme1/portalTheme1WpThemeBanner";
	}
	
	/**
	 * 포탈 - 테마1 포탈페이지 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/portalPage.do")
	public String theme1PortalPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("theme1PortalPage started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String langPrimary = "";
		String langSecondary = "";
		String mode = "";
		String pageID = "";
		String parentPageID = "";
		String myPortalPageID = "";
		String editMode = "";
		String viewMode = "";
		String skinType = "";
		String pClassID = "";
		String pClassName = "";
		String theme = "THEME1";
		String tableViewOption = "D";
		String strHTML = "";
		String width = "";
		String height = "";
		String baseType = "";
		String displayName = "";
		String displayName2 = "";
		String pSelectThemeUID = "";
		String pThemeSelectObject = "";
		String gubunFlag = "";
		String portalPageCategoryXML = "";
		String langType = "kr";
		
		switch (userInfo.getLang()) {
            case "1": langType = "kr"; break;
            case "2": langType = "us"; break;
            case "3": langType = "jp"; break;
            case "4": langType = "cn"; break;
            default:
                break;
        }
		
		langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		mode = "edit";
		
		// 페이지 ID
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").trim().equals("")) {
			pageID = req.getParameter("pageID");
		} else {
			pageID = UUID.randomUUID().toString();
		}
		
		// 부모 페이지 ID
		if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").trim().equals("")) {
			parentPageID = req.getParameter("parentPageID");
		} else {
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").trim().equals("")) {
				parentPageID = ezPortalService.getPortalConfigItem("ParentUID", pageID, userInfo.getTenantId()); 
			} else {
				parentPageID = "top";
			}
		}
		
		// 마이포탈페이지 ID
		if (req.getParameter("myPortalPageID") != null && !req.getParameter("myPortalPageID").trim().equals("")) {
			myPortalPageID = req.getParameter("myPortalPageID");
		}
		
		if (req.getParameter("mode") != null && !req.getParameter("mode").trim().equals("")) {
			mode = req.getParameter("mode");
		}
		
		if (mode.equals("edit")) {
			// 상속된경우
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").trim().equals("") && req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").trim().equals("")) {
				if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").trim().equals("") && req.getParameter("pageID") != null && !req.getParameter("pageID").trim().toLowerCase().equals("top")) {
					editMode = "new_inherit";
				}
			}
		}
		
		// 미리보기
		if (req.getParameter("viewMode") != null &&  !req.getParameter("viewMode").trim().equals("")) {
			viewMode = req.getParameter("viewMode");
		}
		
		// 스킨폴더 정의
		Cookie[] cookies = req.getCookies();
		String skinCookieValue = "";
		if (cookies != null) {
			for (int i=0; i<cookies.length; i++) {
				if (cookies[i].getName().equals("skinNum")) {
					skinCookieValue = cookies[i].getValue();
				}
			}
		}
		
		if (skinCookieValue == null || skinCookieValue.equals("")) {
			Cookie skinCookie = new Cookie("skinNum", "1");
			resp.addCookie(skinCookie);
		}
		
		skinType = skinCookieValue;
		
		if (skinType == null || skinType.equals("")) {
			skinType = "1";
		}
		skinType = "skin_" + skinType;
		
		// 미리보기인 경우 자기의 캐쉬정보를 삭제한다.
		if (viewMode.equals("preview")) {
			ezPortalService.deleteCacheValue(pageID, ezPortalService.getAccessList(userInfo),userInfo.getTenantId());
		}
		
		// 부문홈에서 호출한 경우 부문홈ID
		if (req.getParameter("pClassID") != null && !req.getParameter("pClassID").trim().equals("")) {
			pClassID = req.getParameter("pClassID");
			pClassName = req.getParameter("pClassName").replace("\"", "\\\"");
		}
		
		// 부문포탈에서 호출한 경우 USERID, DISPLAYNAME 노드를 부문포탈의 정보로 변경
		if (pClassID != null && !pClassID.trim().equals("")) {
			userInfo.setId(pClassID);
			userInfo.setDisplayName1(pClassName);
		}
		
		// 새로만들기
		if (ezPortalService.getPortalConfigItem("TableViewOption", pageID, userInfo.getTenantId()) != null && !ezPortalService.getPortalConfigItem("TableViewOption", pageID, userInfo.getTenantId()).trim().equals("")) {
			tableViewOption = ezPortalService.getPortalConfigItem("TableViewOption", pageID, userInfo.getTenantId());
			logger.debug("tavleViewOption="+tableViewOption);
		} else {
			tableViewOption = "D";
			logger.debug("tavleViewOption2="+tableViewOption);
		}
		
		if (mode.trim().equals("new")) {
			strHTML = ezPortalService.getDefaultPortalPage();
		} else {  // 읽기, 편집: 본문HTML, width, height정보를 가져온다
			if (editMode.equals("new_inherit")) {
				logger.debug("new_inherit");
				strHTML = ezPortalService.getRenderedPortalPageHTML(parentPageID, "", mode, userInfo, theme, tableViewOption,userInfo.getTenantId());
				width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(parentPageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
				height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(parentPageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
//				logger.debug("strHTML="+strHTML);
			} else {
				logger.debug("no new_inherit");
				strHTML = ezPortalService.getRenderedPortalPageHTML(pageID, "", mode, userInfo, theme, tableViewOption,userInfo.getTenantId());
				width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(pageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
				height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(pageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
				baseType = ezPortalService.portalPageBaseType(pageID, userInfo.getCompanyID(), userInfo.getTenantId());
//				logger.debug("strHTML="+strHTML);
			}
		}
		
		if (width == null || width.equals("") || width.equals("-1") || width.equals("0")) {
			width = "100%";
		}
		
		if (height == null || height.equals("") || height.equals("-1") || height.equals("0")) {
			height = "100%";
		}
		
		if (mode != null && !mode.equals("view")) {
			displayName = ezPortalService.getPortalConfigItem("DisplayName", pageID, userInfo.getTenantId());
			displayName2 = ezPortalService.getPortalConfigItem("DisplayName2", pageID, userInfo.getTenantId());
			pSelectThemeUID = ezPortalService.getPortalConfigItem("ThemeUID", pageID, userInfo.getTenantId());
			pThemeSelectObject =  ezPortalService.getThemeInfoPortal(userInfo.getCompanyID(), userInfo, pSelectThemeUID);
			
			//신규 상속페이지인 경우 부모페이지의 구분정보를 가져온다.
			if (editMode != null && editMode.equals("new_inherit")) {
				gubunFlag = ezPortalService.getPortalConfigItem("GubunFlag", parentPageID, userInfo.getTenantId());
			} else {
				gubunFlag = ezPortalService.getPortalConfigItem("GubunFlag", pageID, userInfo.getTenantId());
			}
			
			List<PortalTBLPortalPageCategoryVO> list = ezPortalService.getPortalPageCategory(userInfo.getTenantId());
			portalPageCategoryXML = "<DATA>";
			for (PortalTBLPortalPageCategoryVO result : list) {
				portalPageCategoryXML += commonUtil.getQueryResult(result);
			}
			portalPageCategoryXML += "</DATA>";
			portalPageCategoryXML = portalPageCategoryXML.replace("\"", "\\\"");
			
		}
		
		model.addAttribute("strHTML", strHTML);
		model.addAttribute("pThemeSelectObject", pThemeSelectObject);
		model.addAttribute("displayName", displayName);
		model.addAttribute("displayName2", displayName2);
		model.addAttribute("mode", mode);
		model.addAttribute("parentPageID", parentPageID);
		model.addAttribute("pageID", pageID);
		model.addAttribute("baseType", baseType);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("pSelectThemeUID", pSelectThemeUID);
		model.addAttribute("gubunFlag", gubunFlag);
		model.addAttribute("myPortalPageID", myPortalPageID);
		model.addAttribute("portalPageCategoryXML", portalPageCategoryXML);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("editMode", editMode);
		model.addAttribute("tableViewOption", tableViewOption);
		model.addAttribute("langType", langType);

		logger.debug("theme1PortalPage ended");
		return "/ezPortal/portalTheme1PortalPage";
	}
	
	/**
	 * 포탈 상단 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/theme1/topMenu.do")
	public String theme1topMenu(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("theme1topMenu started");

		userInfo = commonUtil.userInfo(loginCookie);
		String strHTML = "";
		String pageID = "";
		String parentPageID = "";
		String mode = "";
		String editMode = "";
		String viewMode = "";
		String displayName = "";
		String displayName2 = "";
		String width = "";
		String height = "";
		//String password;
		String skinNum = "1";
		//String skinBgFlag = "";
		//String skinBgColor = "";
		//String skinBgImage = "";
		//String skinFontColor = "";
		//String skinFontOverColor = "";
		//String skinBgString = "";
		String skinExist = "NO";
		String result = "";
		//String portalMenuID = "";
		//String portalMenuXml = "";
		//int pollNum = 0;
		String script1 = "";
		//String currSkin = "";
		String langPrimary = "";
		String langSecondary = "";
		String theme = "THEME1";
		String noneActiveX = "YES";
		String pSelectThemeUID = "";
		String pThemeSelectObject = "";
		
		langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		mode = "edit";
		
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
			pageID = req.getParameter("pageID");
		} else {
			pageID = UUID.randomUUID().toString();
		}
		
		if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").equals("")) {
			parentPageID = req.getParameter("parentPageID");
		} else {
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
				parentPageID = ezPortalService.getTopMenuConfigItem("ParentUID", pageID,userInfo.getTenantId());
			} else {
				parentPageID = "top";
			}
		}
		
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		
		if (mode.equals("edit")) {
			//관리자 권한체크
			/*	boolean auth = commonUtil.checkAdmin(loginCookie);
			if (!auth) {
				resp.setCharacterEncoding("UTF-8");
				resp.setContentType("text/html; charset=UTF-8");
				resp.getWriter().write(egovMessageSource.getMessage("ezPortal.t264", locale));
				resp.getWriter().flush();
			}*/
			LoginVO auth = commonUtil.checkAdmin(loginCookie);
			
			if (auth == null) {
				resp.setCharacterEncoding("UTF-8");
				resp.setContentType("text/html; charset=UTF-8");
				resp.getWriter().write(egovMessageSource.getMessage("ezPortal.t264", locale));
				resp.getWriter().flush();
			}
			
		}
		
		if (mode.equals("edit")) {
			if ((req.getParameter("pageID") == null || req.getParameter("pageID").equals("")) && (req.getParameter("parentPageID") != null &&!req.getParameter("parentPageID").equals(""))) {
				if (!req.getParameter("parentPageID").trim().equals("") && !req.getParameter("parentPageID").trim().toLowerCase().equals("top")) {
					editMode = "new_inherit";
				}
			}
		}
		
		//미리보기
		if (req.getParameter("viewMode") != null && !req.getParameter("viewMode").equals("")) {
			viewMode = req.getParameter("viewMode");
		}
		
		//미리보기인 경우 자기의 캐쉬정보를 삭제한다
		if (viewMode.equals("preView")) {
			ezPortalService.deleteCacheValue(pageID, ezPortalService.getAccessList(userInfo),userInfo.getTenantId());
		}
		
		//스킨정보
		if (req.getParameter("skinNum") != null && !req.getParameter("skinNum").equals("")) {
			skinNum = req.getParameter("skinNum");
		}
		
		if (userInfo.getLang().equals("1")) {
			//currSkin = skinNum;
			Cookie skinCookie = new Cookie("skinNum", skinNum);
			resp.addCookie(skinCookie);
		} else if (userInfo.getLang().equals("2")) {
			//currSkin = skinNum + "_2";
			Cookie skinCookie = new Cookie("skinNum", skinNum + "_2");
			resp.addCookie(skinCookie);
		} else if (userInfo.getLang().equals("3")) {
			//currSkin = skinNum + "_3";
			Cookie skinCookie = new Cookie("skinNum", skinNum + "_3");
			resp.addCookie(skinCookie);
		} else if (userInfo.getLang().equals("4")) {
			//currSkin = skinNum + "_4";
			Cookie skinCookie = new Cookie("skinNum", skinNum + "_4");
			resp.addCookie(skinCookie);
		}
		
		//새로만들기
		if (mode.equals("new")) {
			strHTML = ezPortalService.getDefaultTopMenu();
		} 
		// 열기 : 본문HTML, width, height정보를 가져온다
		else {
			if (editMode.equals("new_inherit")) {
				strHTML = ezPortalService.getRenderedTopMenuHTML(parentPageID, "", mode, skinNum, userInfo, theme,userInfo.getTenantId());
				width = ezPortalService.getTopMenuConfigItem("width", ezPortalService.getTopParentPageID(parentPageID,userInfo.getTenantId(), userInfo.getCompanyID()),userInfo.getTenantId());
				height = ezPortalService.getTopMenuConfigItem("height", ezPortalService.getTopParentPageID(parentPageID,userInfo.getTenantId(), userInfo.getCompanyID()),userInfo.getTenantId());
//				logger.debug("strHTML=" + strHTML);
			} else {
				strHTML = ezPortalService.getRenderedTopMenuHTML(pageID, "", mode, skinNum, userInfo, theme,userInfo.getTenantId());
				width = ezPortalService.getTopMenuConfigItem("width", ezPortalService.getTopParentPageID(pageID,userInfo.getTenantId(), userInfo.getCompanyID()),userInfo.getTenantId());
				height = ezPortalService.getTopMenuConfigItem("height", ezPortalService.getTopParentPageID(pageID,userInfo.getTenantId(), userInfo.getCompanyID()),userInfo.getTenantId());
//				logger.debug("strHTML=" + strHTML);
			}
		}
		if ((width == null  || width.equals("")) || width.equals("-1") || width.equals("0")) {
			width = "100%";
		}
		if (height == null || height.equals("") || height.equals("-1") || height.equals("0")) {
			height = "100%";
		}
		if (!mode.equals("view")) {
			displayName = ezPortalService.getTopMenuConfigItem("DisplayName", pageID,userInfo.getTenantId());
			displayName2 = ezPortalService.getTopMenuConfigItem("DisplayName2", pageID,userInfo.getTenantId());
			pSelectThemeUID = ezPortalService.getTopMenuConfigItem("ThemeUID", pageID,userInfo.getTenantId());
			List<PortalGetThemeListVO> list = ezPortalService.getThemeList(userInfo.getCompanyID(), userInfo.getTenantId());
			String xmlStr = "<DATA>";
			for (int i=0; i<list.size(); i++) {
				xmlStr += commonUtil.getQueryResult(list.get(i));
			}
			xmlStr += "</DATA>";
			Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
			
			for (int i=0; i<list.size(); i++) {
				if (pSelectThemeUID != null && pSelectThemeUID.equals(list.get(i).getuID())) {
					pThemeSelectObject += "<option value='" + list.get(i).getuID() + "' selected>" + xmlDom.getElementsByTagName("DISPLAYNAME"+commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent() + "</option>";
				} else {
					pThemeSelectObject += "<option value='" + list.get(i).getuID() + "'>" + xmlDom.getElementsByTagName("DISPLAYNAME"+commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent()+ "</option>";
				}
				
			}
			
		}
		
		//사용자 영역에서만 팝업 공지사항을 오픈한다.
		if (mode.equals("view") && !viewMode.equals("preview")) {
			// 팝업 공지사항
			List<PersonalGetPopUpListUserVO> infoList = ezPersonalService.getPopUpListUser(userInfo.getCompanyID(), userInfo.getTenantId());
			
			String popUp = "";
			int popUpWidth = 0;
			int popUpHeight = 0;
			String popUpPosition = "";
			String cookieValue = "";
			for (int i=0; i<infoList.size(); i++) {
				int itemSeq = infoList.get(i).getItemSeq();
				Cookie[] cookies = req.getCookies();
				if (cookies != null) {
					for (int j=0; j<cookies.length; j++) {
						if (cookies[j].getName().equals("POPUP_"+itemSeq)) {
							cookieValue = cookies[j].getValue();
						}
					}
					if (cookieValue == null || cookieValue.equals("")) {
						popUpWidth = infoList.get(i).getWidth();
						popUpHeight = infoList.get(i).getHeight();
						popUpPosition = infoList.get(i).getPosition();
						popUp += "openPopup(" + itemSeq + ", " + popUpWidth + ", " + popUpHeight + ", " + popUpPosition + ");";
					}
				}
				
				
			}
			
			if (popUp != null && !popUp.equals("")) {
				script1 = "<script language='javascript'>" + popUp + "</script>";
			}
			
			//스킨정보
			
			//권한체크
			result = ezPortalService.ezAclCheck(userInfo.getId(), userInfo.getCompanyID(), userInfo.getCompanyName1(),userInfo.getTenantId());
			logger.debug("ezAclCheck="+result);
			String ezCKAdminACL = ezPortalService.ezCkAdminACL(pageID,userInfo.getLang());
			logger.debug("ezCKAdminACL="+ezCKAdminACL);
			logger.debug("pageID="+pageID);
			
			/*	if (result.equals("3")) {
				//삭제 쿼리 실행
				if (ezPortalService.selectTBLPortalACL(ezCKAdminACL, userInfo.getId()) != null && !ezPortalService.selectTBLPortalACL(ezCKAdminACL, userInfo.getId()).equals("")) {
					ezPortalService.deleteTBLPortalACL(ezCKAdminACL, userInfo.getId());
				}
				
			} else {
				//체크 쿼리
				if (ezPortalService.selectTBLPortalACL(ezCKAdminACL, userInfo.getId()) == null || ezPortalService.selectTBLPortalACL(ezCKAdminACL, userInfo.getId()).equals("")) {
					ezPortalService.insertTBLPortalACL(ezCKAdminACL, userInfo.getId());
				} else {
					ezPortalService.updateTBLPortalACL(ezCKAdminACL, userInfo.getId());
				}
			}*/
			
			
			//체크, 삭제 쿼리 실행
			ezPortalService.ezCkAdminACL(userInfo.getId(), pageID, result, userInfo.getLang(), userInfo.getTenantId());
			
			strHTML = strHTML.replace("table-layout:fixed;", "");
			
			if (!mode.equals("edit") || !mode.equals("view")) {
				mode = "view";
			}
			
		}
		
		//jgw 관리자체크
		/*boolean checkAdmin = commonUtil.checkAdmin(loginCookie);*/
		/*model.addAttribute("checkAdmin", String.valueOf(checkAdmin));*/
		
		LoginVO checkAdmin = commonUtil.checkAdmin(loginCookie);
		if (checkAdmin != null) {
			model.addAttribute("checkAdmin", "true");
		} else {
			model.addAttribute("checkAdmin", "false");
		}
		
		//브라우저체크
		String browser = ClientUtil.getClientInfo(req, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		model.addAttribute("pageID", pageID);
		model.addAttribute("parentPageID", parentPageID);
		model.addAttribute("editMode", editMode);
		model.addAttribute("viewMode", viewMode);
		model.addAttribute("strHTML", strHTML);
		model.addAttribute("displayName", displayName);
		model.addAttribute("displayName2", displayName2);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("mode", mode);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("skinExist", skinExist);
		model.addAttribute("script1", script1);
		model.addAttribute("pThemeSelectObject", pThemeSelectObject);

		logger.debug("theme1topMenu ended");
		return "/ezPortal/theme1/portalTheme1TopMenu";
	}
	
	/**
	 * 포탈 - 환경설정 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/environmentMain.do")
	public String environmentMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req) throws Exception {
		logger.debug("environmentMain started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String usePortal = "";
		String url = "";
		String funCode = "";
		String topMenuID = "";
		
		usePortal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
		
		if (req.getParameter("funCode") != null && !req.getParameter("funCode").equals("")) {
			funCode = req.getParameter("funCode");
		}
		
		if (req.getParameter("topMenuID") != null && !req.getParameter("topMenuID").equals("")) {
			topMenuID = req.getParameter("topMenuID");
		}
		
		if (funCode.equals("1")) {
			url = "/ezPersonal/leftEnvironment.do?funCode=1&topMenuID="+topMenuID;
		} else {
			url = "/ezPersonal/leftEnvironment.do?topMenuID="+topMenuID;
		}
		
		model.addAttribute("usePortal", usePortal);
		model.addAttribute("url", url);
		model.addAttribute("topMenuID", topMenuID);

		logger.debug("environmentMain ended");
		return "/ezPortal/portalEnvironmentMain";
	}
	
	/**
	 * 포탈 - 환경설정 MyPortalPageList 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/myPortalPageList.do")
	public String environmentMain(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		logger.debug("environmentMain started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String pSearchString = "";
		String portalGubun = "";
		String parentPageID = "";
		String pageID = "";
		String gubunFlag = "";
		String newMyPortalPage = "";
		//String newMyPortalPageList = "";
		String searchNewMyPortalPageList = "";
		int recordCnt = 0;
		int intPage = 1;
		int totalPage = 1;
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").equals("")) {
			parentPageID = req.getParameter("parentPageID");
		} else {
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
				parentPageID = ezPortalService.getPortalConfigItem("parentUID", pageID, userInfo.getTenantId());
			} else {
				parentPageID = "Top";
			}
		}
		
		gubunFlag = "1";
		
		List<PortalMyPortalListVO> myPortalList = ezPortalService.myPortalList(gubunFlag, userInfo.getDeptPathCode(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (myPortalList.size() > 0) {
			gubunFlag = "1c";
			for (PortalMyPortalListVO myPortal : myPortalList) {
				parentPageID = myPortal.getuID_();
				newMyPortalPage = ezPortalService.newMyPortalPageCreate(parentPageID, userInfo.getId(), gubunFlag, userInfo.getCompanyID(), "", userInfo.getTenantId());
			}
		}
		
		if (myPortalList.size() > 0) {
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			for (int i=0; i<myPortalList.size(); i++) {
				List<PortalNewMyPortalPageListVO> tempNewMyPortalPageList = ezPortalService.newMyPortalList(userInfo.getId(), gubunFlag, userInfo.getTenantId(), userInfo.getCompanyID());
				for (int t=0; t<tempNewMyPortalPageList.size(); t++) {
					String uID = myPortalList.get(i).getuID_();
					String newPortalParentUID = tempNewMyPortalPageList.get(t).getParentUID().trim();
					
					if (uID != null && uID.equals(newPortalParentUID)) {
						sb.append("<ROW>");
						sb.append("<UID_>" + commonUtil.cleanValue(tempNewMyPortalPageList.get(t).getuID_()) + "</UID_>");
						sb.append("<DISPLAYNAME>" + commonUtil.cleanValue(userInfo.getLang().equals(sysLang) ? myPortalList.get(i).getDisplayName() : myPortalList.get(i).getDisplayName2()) + "</DISPLAYNAME>");
						sb.append("<USEFLAG>" + commonUtil.cleanValue(tempNewMyPortalPageList.get(t).getUseFlag()) + "</USEFLAG>");
						sb.append("</ROW>");
					}
				}
			}
			
			sb.append("</DATA>");
			//newMyPortalPageList = sb.toString();
		}
		
		if (req.getParameter("intPage") != null && !req.getParameter("intPage").equals("")) {
			intPage = Integer.parseInt(req.getParameter("intPage"));
		}
		
		int listPageSize = 15;
		
		List<PortalTBLPortalPageCategoryVO> portalPageCategory = ezPortalService.getPortalPageCategory(userInfo.getTenantId());
		
		if (portalGubun == null || portalGubun.equals("")) {
			for (PortalTBLPortalPageCategoryVO temp : portalPageCategory) {
				if (portalGubun == null || portalGubun.equals("")) {
					portalGubun = "'" + temp.getCategory() + "'";
				} else {
					portalGubun += ",'" + temp.getCategory() + "'";
				}
			}
		}
		
		gubunFlag = "1c";
		
		recordCnt = ezPortalService.searchMyPortalPageCount(gubunFlag, userInfo.getDeptPathCode(), userInfo.getCompanyID(), userInfo.getTenantId());
		totalPage = (recordCnt - 1) / listPageSize + 1;
		int pStartRow = 0;
		int pEndRow = 0;
		pStartRow = intPage * listPageSize - listPageSize + 1;
		pEndRow = intPage * listPageSize;
		
		searchNewMyPortalPageList = ezPortalService.searchMyPortal(userInfo.getId(), gubunFlag, pStartRow, pEndRow, userInfo.getCompanyID(), userInfo.getTenantId());
		logger.debug("searchNewMyPortalPageList="+searchNewMyPortalPageList);
		
		Document xmlDom = commonUtil.convertStringToDocument(searchNewMyPortalPageList);
		
		String resultHTML = "";
		
		for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
			if (xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent() != null && xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent().trim().equals("Y")) {
				resultHTML += "<script>var SelectedItems ="+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"</script>";
				resultHTML += "<dl id='"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"' onclick=\"setValueNew('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent().trim()+"', this)\" ondblclick=\"selectItem('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', this)\">";
				resultHTML	+= "<dt>";
				resultHTML	+= "<div class='onimg'></div>";
				resultHTML	+= "<img src='"+xmlDom.getElementsByTagName("IMAGEURL").item(i).getTextContent()+"' width='170' height='140'>";
				resultHTML+= "</dt>";
				resultHTML += "<dd>"+commonUtil.cleanValue(userInfo.getLang().equals(sysLang) ? xmlDom.getElementsByTagName("DISPLAYNAME").item(i).getTextContent() : xmlDom.getElementsByTagName("DISPLAYNAME2").item(i).getTextContent())+"</dd>";		
				resultHTML += "</dl>";
			} else {
				resultHTML += "<dl id='"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"' onclick=\"setValueNew('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent().trim()+"', this)\" ondblclick=\"selectItem('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', this)\">";
				resultHTML	+= "<dt>";
				resultHTML	+= "<div>";
				resultHTML	+= "<img src='"+xmlDom.getElementsByTagName("IMAGEURL").item(i).getTextContent()+"' width='170' height='140'>";
				resultHTML+= "</dt>";
				resultHTML += "<dd>"+commonUtil.cleanValue(userInfo.getLang().equals(sysLang) ? xmlDom.getElementsByTagName("DISPLAYNAME").item(i).getTextContent() : xmlDom.getElementsByTagName("DISPLAYNAME2").item(i).getTextContent())+"</dd>";		
				resultHTML += "</dl>";
			}
		}
		
		logger.debug("resultHTML="+resultHTML);
		
		model.addAttribute("searchNewMyPortalPageList", searchNewMyPortalPageList);
		model.addAttribute("resultHTML", resultHTML);
		model.addAttribute("intPage", intPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("pSearchString", pSearchString);
		model.addAttribute("portalGubun", portalGubun);
		
		logger.debug("environmentMain ended");
		return "/ezPortal/portalMyPortalPageList";
	}
	
	/**
	 * 포탈 - 환경설정 초기 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/startPageUser.do")
	public String startPageUser(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, Locale locale) throws Exception {
		logger.debug("startPageUser started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pageID = "";
		String pUserThemeUID = "";
		String homeUID = "";
        String parentUID = "";
        String imageUID = "";
        String linkURL = "";
        String myTopUID = "";
        String useStartPage = "";
        String deptPathOrgan = "";
		
		String userPortalPage = ezPortalService.getUserInfo(userInfo.getId(), userInfo.getDisplayName1(), pageID, egovMessageSource.getMessage("ezPortal.jjs08", locale), egovMessageSource.getMessage("ezPortal.jjs07", locale), userInfo, userInfo.getCompanyID(), locale, userInfo.getTenantId());
		Document xmlDom = commonUtil.convertStringToDocument(userPortalPage);
		logger.debug("userPortalPage="+userPortalPage);
		
		if (xmlDom.getElementsByTagName("ROW").getLength() > 0) {
			pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(0).getTextContent();
		} else {
			String portalPageXml = ezPortalService.searchMyPortalPage("1", "view", userInfo, userInfo.getCompanyID());
			xmlDom = commonUtil.convertStringToDocument(portalPageXml);
			if (xmlDom.getElementsByTagName("ROW").getLength() > 1) {
				for (int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
					if (xmlDom.getElementsByTagName("DEFAULTPAGE").item(i).getTextContent().equals("Y")) {
						pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(i).getTextContent();
						break;
					}
				}
			} else if (xmlDom.getElementsByTagName("ROW").getLength() == 1) {
				pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(0).getTextContent();
			}
		}
		
		String useTopMenuIDXml = ezPortalService.useTopMenuID2(userInfo.getCompanyID(), "Y", userInfo.getLang(), pUserThemeUID, userInfo.getTenantId());
		
		if (useTopMenuIDXml.equals("<DATA></DATA>")) {
			useTopMenuIDXml = ezPortalService.useTopMenuID(userInfo.getCompanyID(), "Y", pUserThemeUID, userInfo.getTenantId());
		}
		logger.debug("useTopMenuIDXml="+useTopMenuIDXml);
		
		Document xmlDom1 = commonUtil.convertStringToDocument(useTopMenuIDXml);
		Document xmlDomTop = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang(),userInfo.getTenantId()));
		logger.debug("getUserInfo="+ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang(),userInfo.getTenantId()));
		
		if (xmlDomTop.getElementsByTagName("UID").getLength() != 0) {
			myTopUID = xmlDomTop.getElementsByTagName("UID").item(0).getTextContent().trim();
		}

		for (int i=0; i<xmlDom1.getElementsByTagName("UID").getLength(); i++) {
			if (xmlDom1.getElementsByTagName("PARENTUID").item(i).getTextContent() != null && xmlDom.getElementsByTagName("PARENTUID").item(i).getTextContent().trim().equals(myTopUID)) {
				homeUID = xmlDom1.getElementsByTagName("UID_").item(i).getTextContent().trim();
				parentUID = xmlDom1.getElementsByTagName("PARENTUID").item(i).getTextContent().trim();
				imageUID = xmlDom1.getElementsByTagName("IMAGEUID").item(i).getTextContent().trim();
				linkURL = xmlDom1.getElementsByTagName("LINKURL").item(i).getTextContent().trim();
			}
		}
		
		if (homeUID == null || homeUID.equals("")) {
			homeUID = xmlDom1.getElementsByTagName("UID_").item(0).getTextContent().trim();
			parentUID = xmlDom1.getElementsByTagName("PARENTUID").item(0).getTextContent().trim();
			imageUID = xmlDom1.getElementsByTagName("IMAGEUID").item(0).getTextContent().trim();
			linkURL = xmlDom1.getElementsByTagName("LINKURL").item(0).getTextContent().trim();
		}
		logger.debug("homeUID="+homeUID);
		logger.debug("parentUID="+parentUID);
		logger.debug("imageUID="+imageUID);
		logger.debug("linkURL="+linkURL);
		
		useStartPage = ezPortalService.searchStartPage(homeUID, parentUID, imageUID, userInfo.getId(), userInfo.getCompanyID(), linkURL, userInfo.getLang(), userInfo.getTenantId());
		logger.debug("useStartPage="+useStartPage);
		
		String deptPath = userInfo.getDeptPathCode();
		
		for (int ch = 0; ch < deptPath.split("\\,").length; ch++) {
			if (ch ==0) {
				deptPathOrgan += deptPath.split("\\,")[ch].trim();
			} else {
				deptPathOrgan += "," + deptPath.split("\\,")[deptPath.split("\\,").length - (ch)].trim();
			}
		}
		
		String userDeptPath = deptPathOrgan + ",everyone";
		
		List<PortalFirstMainListVO> list = ezPortalService.firstMainList(parentUID, userDeptPath, userInfo.getTenantId());
		
		model.addAttribute("useStartPage", useStartPage);
		model.addAttribute("list", list);
		
		logger.debug("startPageUser ended");
		return "/ezPortal/portalStartPageUser";
	}
	
	/**
	 * 포탈 - 환경설정 초기 화면 저장 실행 함수
	 */
	@RequestMapping(value = "/ezPortal/useMyStartPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String useMyStartPage(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("useMyStartPage started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		String oldUID = "";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		if (req.getParameter("oldUID") != null && !req.getParameter("oldUID").equals("")) {
			oldUID = req.getParameter("oldUID");
		}
		
		logger.debug("uID="+uID+", oldUID="+oldUID);
		
		String result = ezPortalService.setUseMyStartPage(uID, oldUID, userInfo.getId(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		logger.debug("result="+result);

		logger.debug("useMyStartPage ended");
		return result;
	}
	
	/**
	 * 포탈 - 환경설정 마이포탈페이지 저장 실행 함수
	 */
	@RequestMapping(value = "/ezPortal/useMyPortalPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String useMyPortalPage(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("useMyPortalPage started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		String gubunFlag = "1c";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		String result = ezPortalService.setUseMyPortalPage(uID, userInfo.getId(), userInfo.getCompanyID(), gubunFlag, userInfo.getTenantId());

		logger.debug("useMyPortalPage ended");
		return result;
	}
	
	@RequestMapping(value = "/ezPortal/myPortalPage.do")
	public String myPortalPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("myPortalPage started");

		userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary = "";
		String langSecondary = "";
		String mode = "";
		String pageID = "";
		String parentPageID = "";
		String myPortalPageID = "";
		String editMode = "";
		String viewMode = "";
		String skinType = "";
		String pClassID = "";
		String pClassName = "";
		String theme = "BASIC";
		String tableViewOption = "D";
		String strHTML = "";
		String width = "";
		String height = "";
		String baseType = "";
		String displayName = "";
		String displayName2 = "";
		String pSelectThemeUID = "";
		String pThemeSelectObject = "";
		String gubunFlag = "";
		String portalPageCategoryXML = "";
		
		langPrimary = ezCommonService.getTenantConfig("LangPrimary"+userInfo.getLang(), userInfo.getTenantId());
		langSecondary = ezCommonService.getTenantConfig("LangSecondary"+userInfo.getLang(), userInfo.getTenantId());
		mode = "edit";
		
		// 페이지 ID
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").trim().equals("")) {
			pageID = req.getParameter("pageID");
		} else {
			pageID = UUID.randomUUID().toString();
		}
		
		// 부모 페이지 ID
		if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").trim().equals("")) {
			parentPageID = req.getParameter("parentPageID");
		} else {
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").trim().equals("")) {
				parentPageID = ezPortalService.getPortalConfigItem("ParentUID", pageID, userInfo.getTenantId()); 
			} else {
				parentPageID = "top";
			}
		}
		
		logger.debug("myPortal parentPageID="+parentPageID);
		
		// 마이포탈페이지 ID
		if (req.getParameter("myPortalPageID") != null && !req.getParameter("myPortalPageID").trim().equals("")) {
			myPortalPageID = req.getParameter("myPortalPageID");
		}
		
		if (req.getParameter("mode") != null && !req.getParameter("mode").trim().equals("")) {
			mode = req.getParameter("mode");
		}
		
		if (mode.equals("edit")) {
			// 상속된경우
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").trim().equals("") && req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").trim().equals("")) {
				if (!req.getParameter("parentPageID").trim().equals("") && !req.getParameter("pageID").trim().toLowerCase().equals("top")) {
					editMode = "new_inherit";
				}
			}
		}
		
		// 미리보기
		if (req.getParameter("viewMode") != null &&  !req.getParameter("viewMode").trim().equals("")) {
			viewMode = req.getParameter("viewMode");
		}
		
		// 스킨폴더 정의
		Cookie[] cookies = req.getCookies();
		String skinCookieValue = "";
		if (cookies != null) {
			for (int i=0; i<cookies.length; i++) {
				if (cookies[i].getName().equals("skinNum")) {
					skinCookieValue = cookies[i].getValue();
				}
			}
		}
		
		if (skinCookieValue == null || skinCookieValue.equals("")) {
			Cookie skinCookie = new Cookie("skinNum", "1");
			resp.addCookie(skinCookie);
		}
		
		skinType = skinCookieValue;
		if (skinType == null || skinType.equals("")) {
			skinType = "1";
		}
		skinType = "skin_" + skinType;
		
		// 미리보기인 경우 자기의 캐쉬정보를 삭제한다.
		if (viewMode.equals("preview")) {
			ezPortalService.deleteCacheValue(pageID, ezPortalService.getAccessList(userInfo),userInfo.getTenantId());
		}
		
		// 부문홈에서 호출한 경우 부문홈ID
		if (req.getParameter("pClassID") != null && !req.getParameter("pClassID").trim().equals("")) {
			pClassID = req.getParameter("pClassID");
			
			pClassName = req.getParameter("pClassName").replace("\"", "\\\"");
		}
		
		// 부문포탈에서 호출한 경우 USERID, DISPLAYNAME 노드를 부문포탈의 정보로 변경
		if (pClassID != null && !pClassID.trim().equals("")) {
			userInfo.setId(pClassID);
			userInfo.setDisplayName1(pClassName);
		}
		
		// 새로만들기
		tableViewOption = ezPortalService.getPortalConfigItem("TableViewOption", pageID, userInfo.getTenantId()).trim().equals("") ? "D" : ezPortalService.getPortalConfigItem("TableViewOption", pageID, userInfo.getTenantId());
		if (mode.trim().equals("new")) {
			strHTML = ezPortalService.getDefaultPortalPage();
		} else {  // 읽기, 편집: 본문HTML, width, height정보를 가져온다
			if (editMode.equals("new_inherit")) {
				strHTML = ezPortalService.getRenderedPortalPageHTML(parentPageID, "", mode, userInfo, theme, tableViewOption,userInfo.getTenantId());
				width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(parentPageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
				height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(parentPageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
			} else {
				strHTML = ezPortalService.getRenderedPortalPageHTML(pageID, "", mode, userInfo, theme, tableViewOption,userInfo.getTenantId());
				width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(pageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
				height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(pageID,userInfo.getTenantId(), userInfo.getCompanyID()), userInfo.getTenantId());
				baseType = ezPortalService.portalPageBaseType(pageID, userInfo.getCompanyID(), userInfo.getTenantId());
			}
		}
		
		if (width == null || width.equals("") || width.equals("-1") || width.equals("0")) {
			width = "100%";
		}
		
		if (height == null || height.equals("") || height.equals("-1") || height.equals("0")) {
			height = "100%";
		}
		
		if (!mode.equals("view")) {
			displayName = ezPortalService.getPortalConfigItem("DisplayName", pageID, userInfo.getTenantId());
			displayName2 = ezPortalService.getPortalConfigItem("DisplayName2", pageID, userInfo.getTenantId());
			pSelectThemeUID = ezPortalService.getPortalConfigItem("ThemeUID", pageID, userInfo.getTenantId());
			pThemeSelectObject =  ezPortalService.getThemeInfoPortal(userInfo.getCompanyID(), userInfo, pSelectThemeUID);
			
			//신규 상속페이지인 경우 부모페이지의 구분정보를 가져온다.
			if (editMode.equals("new_inherit")) {
				gubunFlag = ezPortalService.getPortalConfigItem("GubunFlag", parentPageID, userInfo.getTenantId());
			} else {
				gubunFlag = ezPortalService.getPortalConfigItem("GubunFlag", pageID, userInfo.getTenantId());
			}
			
			List<PortalTBLPortalPageCategoryVO> list = ezPortalService.getPortalPageCategory(userInfo.getTenantId());
			portalPageCategoryXML = "<DATA>";
			for (PortalTBLPortalPageCategoryVO result : list) {
				portalPageCategoryXML += commonUtil.getQueryResult(result);
			}
			portalPageCategoryXML += "</DATA>";
			portalPageCategoryXML = portalPageCategoryXML.replace("\"", "\\\"");
			
		}
		
		model.addAttribute("strHTML", strHTML);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("editMode", editMode);
		model.addAttribute("pThemeSelectObject", pThemeSelectObject);
		model.addAttribute("displayName", displayName);
		model.addAttribute("displayName2", displayName2);
		model.addAttribute("mode", mode);
		model.addAttribute("parentPageID", parentPageID);
		model.addAttribute("pageID", pageID);
		model.addAttribute("baseType", baseType);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("pSelectThemeUID", pSelectThemeUID);
		model.addAttribute("gubunFlag", gubunFlag);
		model.addAttribute("myPortalPageID", myPortalPageID);
		model.addAttribute("tableViewOption", tableViewOption);
		model.addAttribute("pClassID", pClassID);
		model.addAttribute("pClassName", pClassName);
		
		logger.debug("myPortalPage ended");
		return "/ezPortal/portalMyPortalPage";
	}
	
	/**
	 * 포탈 - 환경설정 마이포탈페이지 portalPageSearch 실행 함수
	 */
	@RequestMapping(value = "/ezPortal/portalPageSearch.do")
	public String portalPageSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("portalPageSearch started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "";
		String portalGubun = "";
		String strHTML = "";
		
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		
		List<PortalTBLPortalPageCategoryVO> list = ezPortalService.getPortalPageCategory(userInfo.getTenantId());
		
		//Root페이지만 보여지도록 설정
		for (int i=0; i<list.size(); i++) {
			if (portalGubun == null || portalGubun.equals("")) {
				portalGubun = "'" + list.get(i).getCategory() + "'";
			} else {
				portalGubun += ",'" + list.get(i).getCategory() + "'";
			}
		}
		
		String strXML = ezPortalService.searchPortalPage("", "", portalGubun, 1, 100, "", userInfo.getTenantId());
		
		Document xmlDom = commonUtil.convertStringToDocument(strXML);
		
		for (int i=0; i<xmlDom.getElementsByTagName("UID").getLength(); i++) {
			strHTML += "<tr>";
			strHTML += "<td class='white' style='padding-left:10px'>";
			strHTML += "<input type='radio' name='uid' onClick=\"RadioClick('"+xmlDom.getElementsByTagName("UID").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("DISPLAYNAME").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("DEPTH").item(i).getTextContent()+"')\">"; 
			strHTML += xmlDom.getElementsByTagName("DISPLAYNAME").item(i).getTextContent();
			strHTML += "</td>";
			strHTML += "</tr>";
		}
		
		model.addAttribute("strXML", strXML);
		model.addAttribute("strHTML", strHTML);
		model.addAttribute("mode", mode);
		
		logger.debug("portalPageSearch ended");
		return "/ezPortal/portalPortalPageSearch";
	}
	
	/**
	 * 포탈 - 환경설정 마이포탈페이지 portalPortletSearch 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/portletSearch.do")
	public String portletSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("portletSearch started");

		userInfo = commonUtil.userInfo(loginCookie);
		StringBuilder sb = new StringBuilder();
		List<PortalTBLPortalPageCategoryVO> list = ezPortalAdminService.getPortletCategory(userInfo.getTenantId());
		
		sb.append("<DATA>");
		for (int i=0; i<list.size(); i++) {
			sb.append(commonUtil.getQueryResult(list.get(i)));
		}
		sb.append("</DATA>");
		
		model.addAttribute("portletCategoryXML", sb.toString());
		if (userInfo.getPrimary() != null && userInfo.getPrimary().equals("1")) {
			model.addAttribute("userLang", "");
		} else {
			model.addAttribute("userLang", commonUtil.getLangData(userInfo.getPrimary()));
		}

		logger.debug("portletSearch ended");
		return "/ezPortal/portalPortletSearch";
	}
	
	/**
	 * 포탈 - 환경설정 마이포탈페이지 portalPortletSearchList 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/portletSearchList.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String portletSearchList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req, Locale locale) throws Exception {
		logger.debug("portletSearchList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String pPageType = "";
		String pType = "";
		String mode = "";
		
		if (req.getParameter("pPageType") != null && !req.getParameter("pPageType").equals("")) {
			pPageType = req.getParameter("pPageType");
		}
		if (req.getParameter("pType") != null && !req.getParameter("pType").equals("")) {
			pType = req.getParameter("pType");
		}
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		
		String strXML = ezPortalService.searchPortletCheckRight("", pType, pPageType, mode, 1, 100, userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), locale);
		
		logger.debug("portletSearchList ended");
		return strXML;
	}
	
	/**
	 * 포탈 - 포탈페이지 권한 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/portalPageACL.do")
	public String portalPageACL(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("portalPageACL started");
		userInfo = commonUtil.userInfo(loginCookie);
		String uID = "";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		List<PortalTBLPortalACLVO> list = ezPortalService.getAclItems(uID, userInfo.getTenantId());
		model.addAttribute("list", list);
		model.addAttribute("uID", uID);

		logger.debug("portalPageACL ended");
		return "/ezPortal/portalPortalPageACL";
	}
	
	/**
	 * 포탈 - 도움말 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/help.do")
	public String help(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("help started");

		String topMenuID = "";
		
		if (req.getParameter("topMenuID") != null && !req.getParameter("topMenuID").equals("")) {
			topMenuID = req.getParameter("topMenuID");
		}
		
		userInfo = commonUtil.userInfo(loginCookie);
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
				
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("packageType", packageType);
		model.addAttribute("topMenuID", topMenuID);
		
		logger.debug("help ended");
		return "/ezPortal/help/help";
	}
	
	/**
	 * 포탈 - 도움말 상단 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/top.do")
	public String top(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("top started");

		String topMenuID = "";
		
		if (req.getParameter("topMenuID") != null && !req.getParameter("topMenuID").equals("")) {
			topMenuID = req.getParameter("topMenuID");
		}
		
		userInfo = commonUtil.userInfo(loginCookie);
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
				
		String firstScreenMail = ezCommonService.getTenantConfig("firstScreen_Mail", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		if (firstScreenMail == null || firstScreenMail.equals("")) {
			firstScreenMail = "NO";
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

		model.addAttribute("topMenuID", topMenuID);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("userApprovalG", config.getProperty("config.UserInfo_ApprovalG"));
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("packageType", packageType);
		model.addAttribute("firstScreen_Mail", firstScreenMail);
		
		logger.debug("top ended");
		return "/ezPortal/help/top";
	}
	
	/**
	 * 포탈 - 도움말 하단 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/main.do")
	public String main(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("main started");

		userInfo = commonUtil.userInfo(loginCookie);
		String id = "";
		
		if (req.getParameter("id") != null && !req.getParameter("id").equals("")) {
			id = req.getParameter("id");
		}
		
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("id", id);

		logger.debug("main ended");
		return "/ezPortal/help/main";
	}
	
	/**
	 * 포탈 - 도움말 indexSub 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/indexSub.do")
	public String indexSub(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("indexSub started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String lUrl = "";
		String rUrl = "";
		
		if (req.getParameter("lUrl") != null && !req.getParameter("lUrl").equals("")) {
			lUrl = req.getParameter("lUrl");
		}
		if (req.getParameter("rUrl") != null && !req.getParameter("rUrl").equals("")) {
			rUrl = req.getParameter("rUrl");
		}
		
		model.addAttribute("lUrl", lUrl);
		model.addAttribute("rUrl", rUrl);

		logger.debug("indexSub ended");
		return "/ezPortal/help/indexSub";
	}
	
	/**
	 * 포탈 - 도움말 leftPortal 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftPortal.do")
	public String leftPortal(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftPortal started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftPortal ended");
		return "/ezPortal/help/leftPortal";
	}
	
	/**
	 * 포탈 - 도움말 leftMail 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftMail.do")
	public String leftMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftMail started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftMail ended");
		return "/ezPortal/help/leftMail";
	}
	
	/**
	 * 포탈 - 도움말 leftAddr 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftAddr.do")
	public String leftAddr(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftAddr started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftAddr ended");
		return "/ezPortal/help/leftAddr";
	}
	
	/**
	 * 포탈 - 도움말 leftAppr 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftAppr.do")
	public String leftAppr(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftAppr started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftAppr ended");
		return "/ezPortal/help/leftAppr";
	}
	
	/**
	 * 포탈 - 도움말 leftApprG 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftApprG.do")
	public String leftApprG(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftApprG started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftApprG ended");
		return "/ezPortal/help/leftApprG";
	}
	
	/**
	 * 포탈 - 도움말 leftBoard 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftBoard.do")
	public String leftBoard(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftBoard started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftBoard ended");
		return "/ezPortal/help/leftBoard";
	}
	
	/**
	 * 포탈 - 도움말 leftCommunity 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftCommunity.do")
	public String leftCommunity(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftCommunity started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftCommunity ended");
		return "/ezPortal/help/leftCommunity";
	}
	
	/**
	 * 포탈 - 도움말 leftEnv 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftEnv.do")
	public String leftEnv(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftEnv started");

		String topMenuID = "";

		userInfo = commonUtil.userInfo(loginCookie);
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
				
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
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("packageType", packageType);

		logger.debug("leftEnv ended");
		return "/ezPortal/help/leftEnv";
	}
	
	/**
	 * 포탈 - 도움말 leftPoll 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftPoll.do")
	public String leftPoll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftPoll started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftPoll ended");
		return "/ezPortal/help/leftPoll";
	}
	
	/**
	 * 포탈 - 도움말 leftResource 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftResource.do")
	public String leftResource(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftResource started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftResource ended");
		return "/ezPortal/help/leftResource";
	}
	
	/**
	 * 포탈 - 도움말 leftSchedule 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftSchedule.do")
	public String leftSchedule(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftSchedule started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftSchedule ended");
		return "/ezPortal/help/leftSchedule";
	}
	
	@RequestMapping(value = "/ezPortal/help/leftTask.do")
	public String leftTask(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftTask started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftTask ended");
		return "/ezPortal/help/leftTask";
	}
	
	/**
	 * 포탈 - 도움말 leftCircular 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftCircular.do")
	public String leftCircular(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftCircular started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("leftCircular ended");
		return "/ezPortal/help/leftCircular";
	}

	/**
	 * 포탈 - 도움말 leftleftWebfolder 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/leftWebfolder.do")
	public String leftWebfolder(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("leftWebfolder started");

		userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userInfo", userInfo);

		logger.debug("leftWebfolder ended");
		return "/ezPortal/help/leftWebfolder";
	}
	
	/**
	 * 포탈 - 도움말 topPortal 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/topPortal.do")
	public String topPortal(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("topPortal started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("topPortal ended");
		return "/ezPortal/help/topPortal";
	}
	
	/**
	 * 포탈 - 포틀릿 추가 portalMenuItemSearch 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/menuItemSearch.do")
	public String menuItemSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, Locale locale) throws Exception {
		logger.debug("menuItemSearch started");

		userInfo = commonUtil.userInfo(loginCookie);
		String mainHTML = "";
		String strXML = ezPortalService.searchMenuItem("", 1, 10, "", userInfo.getTenantId());
		Document xmlDom = commonUtil.convertStringToDocument(strXML);
		
		for (int i=0; i<xmlDom.getElementsByTagName("DISPLAYNAME").getLength(); i++) {
			xmlDom.getElementsByTagName("DISPLAYNAME").item(i).setTextContent(egovMessageSource.getMessage("ezPortal."+xmlDom.getElementsByTagName("DISPLAYNAME").item(i).getTextContent(), locale));
		}
		
		for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
			mainHTML += "<tr>";
			mainHTML += "<td class='white' style='padding-left:10px'>";
			mainHTML += "<input type='radio' name='uid' onClick=\"RadioClick('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("DISPLAYNAME").item(i).getTextContent()+"')\">";
			mainHTML += "<span> "+xmlDom.getElementsByTagName("DISPLAYNAME").item(i).getTextContent()+"</span>";
			mainHTML += "</tr>";
		}
		
		model.addAttribute("mainHTML", mainHTML);
		
		logger.debug("menuItemSearch ended");
		return "/ezPortal/portalMenuItemSearch";
	}
	
	/**
	 * 포탈 ActiveX 다운로드 목록 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/componentListTransfer.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String componentListTransfer(HttpServletRequest request, HttpServletResponse response) throws Exception {
		StringBuilder result = new StringBuilder();
		String realPath = commonUtil.getRealPath(request); 
		String path = "xml" + commonUtil.separator + "ezPortal" + commonUtil.separator + "componentlist.xml";
		path = realPath + commonUtil.separator + path;
		try {
			File file = new File(path);
			BufferedReader br = new BufferedReader(new FileReader(file));
			String line = null;
	
			while ((line = br.readLine()) != null) {
				result.append(line);
			}
			
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.debug("downloadServer="+result.toString().replace("DOWNLOADSERVER", request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI()))));
		return result.toString().replace("DOWNLOADSERVER", request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI())));
	}
	
	/**
	 * 포탈 ActiveX 다운로드 실행 함수
	 */
	@RequestMapping(value = "/ezPortal/progress.do")
	public String progress() {
		return "/ezPortal/portalProgress";
	}
	
	/**
	 * 포탈 - HTMLPortlet 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/htmlPortlet.do")
	public String htmlPortlet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, Locale locale, HttpServletRequest req) throws Exception {
		logger.debug("htmlPortlet started");

		userInfo = commonUtil.userInfo(loginCookie);
		String uID = "";
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		String htmlData = ezPortalService.htmlPortlet(uID, userInfo.getTenantId());
		model.addAttribute("htmlData", htmlData);

		logger.debug("htmlPortlet ended");
		return "/ezPortal/portalHtmlPortlet";
	}
	
	/**
	 * 포탈 - imagePortlet 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/imagePortlet.do")
	public String imagePortlet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, Locale locale, HttpServletRequest req) throws Exception {
		logger.debug("imagePortlet started");

		userInfo = commonUtil.userInfo(loginCookie);
		String uID = "";
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		PortalImagePortletVO result = ezPortalService.imagePortlet(uID, userInfo.getTenantId(), userInfo.getCompanyID());
		
		if (result.getImagePath() != null && !result.getImagePath().equals("")) {
			model.addAttribute("result", result);
		}

		logger.debug("imagePortlet ended");
		return "/ezPortal/portalImagePortlet";
	}
	
	/**
	 * 포탈 - boardPortlet 실행 함수
	 */
	@RequestMapping(value = "/ezPortal/boardPortlet.do")
	public void boardPortlet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, Locale locale, HttpServletRequest req, HttpServletResponse resp) throws Exception {
		logger.debug("boardPortlet started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		String pBoardID = "";
		String pItemCount = "";
		String pItemFields = "";
		String gubunFlag = "";
		String pMoveURL = "";
		String pUserID = userInfo.getId();
		
		if (req.getParameter("userID") != null && !req.getParameter("userID").equals("")) {
			pUserID = req.getParameter("userID");
		}
		
		Document xmlDomProp = commonUtil.convertStringToDocument(ezPortalService.getPorletPropertiesStr(uID, userInfo.getTenantId(), userInfo.getCompanyID())); 
		logger.debug("xmlDom="+ezPortalService.getPorletPropertiesStr(uID, userInfo.getTenantId(), userInfo.getCompanyID()));
		
		if (xmlDomProp.getElementsByTagName("USERTYPE").getLength() > 0) {
			gubunFlag = xmlDomProp.getElementsByTagName("GUBUNFLAG").item(0).getTextContent();
			
			if (xmlDomProp.getElementsByTagName("USERTYPE").item(0).getTextContent().trim().equals("1")) {
				logger.debug("uID="+uID);
				logger.debug("xmlDomProp="+ezPortalService.getPortletSubProperties(uID, xmlDomProp.getElementsByTagName("PORTLET_TYPE").item(0).getTextContent(), userInfo.getTenantId()));
				Document xmlDomSubProp = commonUtil.convertStringToDocument(ezPortalService.getPortletSubProperties(uID, xmlDomProp.getElementsByTagName("PORTLET_TYPE").item(0).getTextContent(), userInfo.getTenantId()));
				
				if (xmlDomSubProp.getElementsByTagName("CREATORID").getLength() > 0) {
					pBoardID = xmlDomSubProp.getElementsByTagName("BOARDID").item(0).getTextContent();
					pItemCount = xmlDomSubProp.getElementsByTagName("ITEMCOUNT").item(0).getTextContent();
					pItemFields = xmlDomSubProp.getElementsByTagName("ITEMFIELDS").item(0).getTextContent();
				}
			} else {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_UID", uID);
				map.put("v_CREATORID", pUserID);
				map.put("tenantID", userInfo.getTenantId());
				PortalTBLPortletBoardVO result = ezPortalService.boardPortlet(map);
				String resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";
				logger.debug("resultXML="+resultXML);
				Document xmlDomSubProp = commonUtil.convertStringToDocument(resultXML);
				
				if (result != null && xmlDomSubProp.getElementsByTagName("CREATORID").getLength() > 0) {
					pBoardID = xmlDomSubProp.getElementsByTagName("BOARDID").item(0).getTextContent();
					pItemCount = xmlDomSubProp.getElementsByTagName("ITEMCOUNT").item(0).getTextContent();
					pItemFields = xmlDomSubProp.getElementsByTagName("ITEMFIELDS").item(0).getTextContent();
				}
			}
		}
		
		if (pBoardID == null || pBoardID.equals("")) {
			resp.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html; charset=UTF-8");
			resp.getWriter().write("<font style='FONT-SIZE: 9pt'> " + egovMessageSource.getMessage("ezPortal.t275", locale) + "</font>");
		} else {
			logger.debug("gubunFlag="+gubunFlag);
			if (gubunFlag.equals("2")) {
				pMoveURL = "/ezPortal/boardListClass.do?boardID=" + pBoardID + "&itemCount=" + pItemCount + "&itemFields=" + pItemFields + "&uID=" + uID + "&pClassID=" + pUserID;
			} else {
				pMoveURL = "/ezBoard/boardListPortal.do?boardID=" + pBoardID + "&itemCount=" + pItemCount + "&itemFields=" + pItemFields + "&uID=" + uID;
			}
			resp.getWriter().write("<script> function window_onload() { window.location.href = \"" + pMoveURL + "\"; } </script>");
			resp.getWriter().write("<body onload='window_onload()'></body>");
			resp.getWriter().flush();
			resp.getWriter().close();
		}
		logger.debug("boardPortlet ended");
	}
	
	@RequestMapping(value = "/ezPortal/wpNewSchedule.do")
	public String wpNewSchedule(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("wpNewSchedule started");
		
		logger.debug("wpNewSchedule ended");
		
		return "/ezPortal/portalWpNewSchedule";
	}	
}
