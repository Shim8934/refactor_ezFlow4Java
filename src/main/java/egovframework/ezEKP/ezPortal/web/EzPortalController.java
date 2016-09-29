package egovframework.ezEKP.ezPortal.web;

import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezPortal.vo.PortalFirstMainListVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetThemeListVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalACLVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageCategoryVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalUrlPortletVO;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
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
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzPortalService")
	private EzPortalService ezPortalService;
	
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
	
	/**
	 * 포탈 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/portalMain.do")
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String pageID = "";
		String skinID = "1";
		String mainUrl = "";
		String topUrl = "";
		String topHeight = "78";
		
		try {
			String userPortalPage = ezPortalService.getUserInfo(userInfo.getId(), userInfo.getDisplayName1(), pageID, "1c", "view", userInfo, userInfo.getCompanyID());
			Document xmlDom = commonUtil.convertStringToDocument(userPortalPage);
			
			String pUserThemeUID = "";
			if (xmlDom.getElementsByTagName("ROW").getLength() > 0) {
				pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(0).getTextContent();
			} else {
				//searchMyPortalPage
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
				} else {
					if (pUserThemeUID == null || pUserThemeUID.equals("")) {
						String commentHtml = "<!DOCTYPE html><HTML>" +
								"<HEAD>" +
                                "<link href=\"/css/" + egovMessageSource.getMessage("ezPortal.i2", locale) + "\" rel=\"stylesheet\" type=\"text/css\">" +
                                "<style type='text/css'>" +
                                "<!--" +
                                ".warningbox01 { width:540px; margin:0 auto; border:1px solid #cccaca; background:#e8e8e8;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}" +
                                ".warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 20px 25px;}" +
                                ".warnintxt01 { position:relative ;padding-bottom:10px;}" +
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
                                "    <div class='warnintxt01' >" +
                                "    <span class='warningimg'><img src='/images/notify/warning02.gif' width='136' height='112'></span>" +
                                "    <dl class='warningdl'>" +
                                "    <dt><img src='/images/notify/warning01.gif' width='183' height='27'></dt>" +
                                "    <dd>" +
                                "        " + egovMessageSource.getMessage("ezPortal.t286", locale) + "<br>";
						
								if (userInfo.getRollInfo().indexOf("c=1") > -1) {
									commentHtml += "        <a class=\"imgbtn\"><span style='cursor:pointer' onclick='javascript:window.open(\"/admin/main.do\", \"\", \"\")'>" + egovMessageSource.getMessage("ezPortal.t410", locale) + "</span></a> ";
								}
								commentHtml += "    </dd>" +
								"    </dl>" +
								"    </div>" +
								"    </div>" +
								"</div>" +
								"</BODY>" +
								"</HTML>";
								resp.setCharacterEncoding("UTF-8");
								resp.setContentType("text/html; charset=UTF-8");
								resp.getWriter().write(commentHtml);
								resp.getWriter().flush();
					}
				}
			}
			String strXML = ezPortalService.searchTopMenu("", "Y", 1, 100, "", userInfo.getLang(), userInfo.getCompanyID());
			xmlDom = commonUtil.convertStringToDocument(strXML);

			if (xmlDom.getElementsByTagName("UID_").getLength() > 0) {
				Document xmlDomTop = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang()));

				String myTopID = "";
				if (xmlDomTop != null && xmlDomTop.getElementsByTagName("UID_").getLength() != 0) {
					myTopID = xmlDomTop.getElementsByTagName("UID_").item(0).getTextContent().trim();
				}
				for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
					if (xmlDom.getElementsByTagName("UID_").item(i).getTextContent().trim().equals(myTopID)) {
						//기본 페이지 ID
						pageID = xmlDom.getElementsByTagName("UID_").item(i).getTextContent();

						xmlDom = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang()));
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
							xmlDom = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang()));
								
							if (xmlDom.getElementsByTagName("USERID").getLength() > 0) {
								skinID = xmlDom.getElementsByTagName("SKINNUM").item(0).getTextContent();
							}
						}
					}
				}
			} else {   // 다국어로 설정된 페이지가 없는경우 첫번째 사용으로 되어 있는 레이아웃 보여준다.
				String strXML2 = ezPortalService.searchTopMenu("", "Y", 1, 100, "", userInfo.getCompanyID());
				
				Document xmlDom2 = commonUtil.convertStringToDocument(strXML2);
				if (xmlDom2.getElementsByTagName("UID_").getLength() > 0) {
					Document xmlDomTop = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang()));
					String myTopID = "";
					if (xmlDomTop.getElementsByTagName("UID_").getLength() != 0) {
						myTopID = xmlDomTop.getElementsByTagName("UID_").item(0).getTextContent().trim();
					}
					
					for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
						if (xmlDom.getElementsByTagName("UID_").item(i).getTextContent().trim().equals(myTopID)) {
							pageID = xmlDom2.getElementsByTagName("UID_").item(i).getTextContent();
							xmlDom2 = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang()));
							if (xmlDom2.getElementsByTagName("USERID").getLength() > 0) {
								skinID = xmlDom2.getElementsByTagName("SKINNUM").item(0).getTextContent();
							}
						}
					}
					if (pageID.equals("")) {
						pageID = xmlDom2.getElementsByTagName("UID_").item(0).getTextContent();
						xmlDom2 = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang()));
						if (xmlDom2.getElementsByTagName("USERID").getLength() > 0) {
							skinID = xmlDom2.getElementsByTagName("SKINNUM").item(0).getTextContent();
						}
					}
				}
			}
			
			String themeInfoXml = ezPortalService.getThemeInfoStr(pUserThemeUID, "3");
			
			Document xmlDomACL = commonUtil.convertStringToDocument(themeInfoXml);
			
			if (xmlDomACL != null) {
				if  (xmlDomACL.getElementsByTagName("TOPHEIGHT").item(0).getTextContent() != null && !xmlDomACL.getElementsByTagName("TOPHEIGHT").item(0).getTextContent().equals("")) {
					topHeight = xmlDomACL.getElementsByTagName("TOPHEIGHT").item(0).getTextContent();
				}
			}
			
			topUrl = xmlDomACL.getElementsByTagName("TOPURL").item(0).getTextContent();
			topUrl += "?mode=view&pageID=" + pageID + "&skinNum=" + skinID;
			String useStartPageURL = ezPortalService.useStartPageChack2(userInfo.getId(), userInfo.getCompanyID(), pageID);

			if ("new".equals(req.getParameter("mode"))) {
				mainUrl = "/myoffice/main/index_environment2.htm";
			} else if ("mail".equals(req.getParameter("mode"))) {
				mainUrl = "/myoffice/main/index_myoffice.aspx?funCode=1";
			} else if ("approval".equals(req.getParameter("mode"))) {
				mainUrl = "/myoffice/ezApproval/index_approval.aspx";
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "/ezPortal/portalMain";
	}
	
	/**
	 * 포탈 상단 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/topMenu.do")
	public String topMenu(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
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
		
		try {
			langPrimary = config.getProperty("config.lang_Primary"+ userInfo.getLang());
			langSecondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
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
					parentPageID = ezPortalService.getTopMenuConfigItem("ParentUID", pageID);
				} else {
					parentPageID = "top";
				}
			}
			
			if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
				mode = req.getParameter("mode");
			}

			if (mode.equals("edit")) {
				//관리자 권한체크
				boolean auth = commonUtil.checkAdmin(loginCookie);
				if (!auth) {
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
				ezPortalService.deleteCacheValue(pageID, ezPortalService.getAccessList(userInfo));
			}

			//스킨정보
			if (req.getParameter("skinNum") != null && !req.getParameter("skinNum").equals("")) {
				skinNum = req.getParameter("skinNum");
			}
				
			if (userInfo.getLang().equals("1")) {
				//resp.cookies skinnum
				//currSkin = skinNum;
			} else if (userInfo.getLang().equals("2")) {
				//currSkin = skinNum + "_2";
			} else if (userInfo.getLang().equals("3")) {
				//currSkin = skinNum + "_3";
			} else if (userInfo.getLang().equals("4")) {
				//currSkin = skinNum + "_4";
			}
				
			//새로만들기
			if (mode.equals("new")) {
				strHTML = ezPortalService.getDefaultTopMenu();
			} 
			// 열기 : 본문HTML, width, height정보를 가져온다
			else {
				if (editMode.equals("new_inherit")) {
					strHTML = ezPortalService.getRenderedTopMenuHTML(parentPageID, "", mode, skinNum, userInfo, theme);
					width = ezPortalService.getTopMenuConfigItem("width", ezPortalService.getTopParentPageID(parentPageID));
					height = ezPortalService.getTopMenuConfigItem("height", ezPortalService.getTopParentPageID(parentPageID));
				} else {
					strHTML = ezPortalService.getRenderedTopMenuHTML(pageID, "", mode, skinNum, userInfo, theme);
					width = ezPortalService.getTopMenuConfigItem("width", ezPortalService.getTopParentPageID(pageID));
					height = ezPortalService.getTopMenuConfigItem("height", ezPortalService.getTopParentPageID(pageID));
				}
			}
			if ((width == null  || width.equals("")) || width.equals("-1") || width.equals("0")) {
				width = "100%";
			}
			if (height == null || height.equals("") || height.equals("-1") || height.equals("0")) {
				height = "100%";
			}
			if (!mode.equals("view")) {
				displayName = ezPortalService.getTopMenuConfigItem("DisplayName", pageID);
				displayName2 = ezPortalService.getTopMenuConfigItem("DisplayName2", pageID);
				pSelectThemeUID = ezPortalService.getTopMenuConfigItem("ThemeUID", pageID);
				List<PortalGetThemeListVO> list = ezPortalService.getThemeList(userInfo.getCompanyID());
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
				List<PersonalGetPopUpListUserVO> infoList = ezPersonalService.getPopUpListUser(userInfo.getCompanyID());
				
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
				result = ezPortalService.ezAclCheck(userInfo.getId(), userInfo.getCompanyID(), userInfo.getCompanyName1());

				String ezCKAdminACL = ezPortalService.ezCkAdminACL(pageID,userInfo.getLang());

				if (result.equals("3")) {
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
				}
				
				strHTML = strHTML.replace("table-layout:fixed;", "");
				
				if (!mode.equals("edit") || !mode.equals("view")) {
					mode = "view";
				}
				
			}
System.out.println("pThemeSelectObject:"+pThemeSelectObject);
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
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "/ezPortal/portalTopMenu";
	}
	
	
	@RequestMapping(value = "/ezPortal/portalPage.do")
	public String portalPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
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
		String pageOption = "";
		try {
			userInfo = commonUtil.userInfo(loginCookie);
			langPrimary = config.getProperty("config.lang_Primary"+ userInfo.getLang());
			langSecondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
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
					parentPageID = ezPortalService.getPortalConfigItem("ParentUID", pageID); 
				} else {
					parentPageID = "top";
				}
			}
			
			// 마이포탈페이지 ID
			if (req.getParameter("myPortalPageID") != null && !req.getParameter("myPortalPageID").trim().equals("")) {
				myPortalPageID = req.getParameter("myPortalPageID");
			}
			
			if (req.getParameter("pageOption") != null && !req.getParameter("pageOption").trim().equals("")) {
				pageOption = req.getParameter("pageOption");
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
			if (req.getParameter("skinNum") != null &&  !req.getParameter("skinNum").equals("")) {
				//respons skinNum
			}
			skinType = req.getParameter("skinNum");
			if (skinType != null && skinType.trim().equals("")) {
				skinType = "1";
			}
			skinType = "skin_" + skinType;
			
			// 미리보기인 경우 자기의 캐쉬정보를 삭제한다.
			if (viewMode.equals("preview")) {
				ezPortalService.deleteCacheValue(pageID, ezPortalService.getAccessList(userInfo));
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
			if (ezPortalService.getPortalConfigItem("TableViewOption", pageID) != null && !ezPortalService.getPortalConfigItem("TableViewOption", pageID).trim().equals("")) {
				tableViewOption = ezPortalService.getPortalConfigItem("TableViewOption", pageID);
			} else {
				tableViewOption = "D";
			}
			
			if (mode.trim().equals("new")) {
				strHTML = ezPortalService.getDefaultPortalPage();
			} else {  // 읽기, 편집: 본문HTML, width, height정보를 가져온다
				if (editMode.equals("new_inherit")) {
					strHTML = ezPortalService.getRenderedPortalPageHTML(parentPageID, "", mode, userInfo, theme, tableViewOption);
					width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(parentPageID));
					height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(parentPageID));
System.out.println("strHTML:"+strHTML);
				} else {
					strHTML = ezPortalService.getRenderedPortalPageHTML(pageID, "", mode, userInfo, theme, tableViewOption);
					width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(pageID));
					height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(pageID));
					baseType = ezPortalService.portalPageBaseType(pageID, userInfo.getCompanyID());
System.out.println("strHTML1:"+strHTML);
				}
			}
			
			if (width == null || (width).equals("") || (width).equals("-1") || (width).equals("0")) {
				width = "100%";
			}
					
			if (height == null || height.equals("") || height.equals("-1") || height.equals("0")) {
				height = "100%";
			}
					
			if (!mode.equals("view")) {
				displayName = ezPortalService.getPortalConfigItem("DisplayName", pageID);
				displayName2 = ezPortalService.getPortalConfigItem("DisplayName2", pageID);
	            pSelectThemeUID = ezPortalService.getPortalConfigItem("ThemeUID", pageID);
	            pThemeSelectObject =  ezPortalService.getThemeInfoPortal(userInfo.getCompanyID(), userInfo, pSelectThemeUID);
	            List<PortalGetThemeListVO> themeList = ezPortalService.getThemeList(userInfo.getCompanyID());
	        	String xmlStr = "<DATA>";
				for (int i=0; i<themeList.size(); i++) {
					xmlStr += commonUtil.getQueryResult(themeList.get(i));
				}
				xmlStr += "</DATA>";
				Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
				
				for (int i=0; i<themeList.size(); i++) {
					if (pSelectThemeUID != null && pSelectThemeUID.equals(themeList.get(i).getuID())) {
						pThemeSelectObject += "<option value='" + themeList.get(i).getuID() + "' selected>" + xmlDom.getElementsByTagName("DISPLAYNAME"+commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent() + "</option>";
					} else {
						pThemeSelectObject += "<option value='" + themeList.get(i).getuID() + "'>" + xmlDom.getElementsByTagName("DISPLAYNAME"+commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent()+ "</option>";
					}
					
				}        
	            //신규 상속페이지인 경우 부모페이지의 구분정보를 가져온다.
	            if (editMode.equals("new_inherit")) {
	            	gubunFlag = ezPortalService.getPortalConfigItem("GubunFlag", parentPageID);
	            } else {
	            	gubunFlag = ezPortalService.getPortalConfigItem("GubunFlag", pageID);
	            }
	                    
	            List<PortalTBLPortalPageCategoryVO> list = ezPortalService.getPortalPageCategory();
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
			
			return "/ezPortal/portalPortalPage";
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
		
	}
	
	/**
	 * 포탈 - 마이포탈 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/myPortal.do")
	public void myPortal (HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		try {
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
			
			// 권한이 있는 Root페이지 정보를 가져온다.
			String pUserPageList = ezPortalService.getUserInfo(userInfo.getId(), userInfo.getDisplayName1(), pageID, gubunFlag+"c", mode, userInfo, userInfo.getCompanyID());

			Document xmlDom = commonUtil.convertStringToDocument(pUserPageList);

			if (resetMyParentPageID == null || resetMyParentPageID.trim().equals("")) {
				if (xmlDom.getElementsByTagName("ROW").getLength() > 0) {
					pageID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
					gubunFlag = xmlDom.getElementsByTagName("GUBUNFLAG").item(0).getTextContent();
					rootGubunFlag = gubunFlag;
					pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(0).getTextContent();
				} else {
					String portalPageXml = ezPortalService.searchMyPortalPage(gubunFlag, mode, userInfo, userInfo.getCompanyID());

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
				pageID = UUID.randomUUID().toString();								
				//String newMyPortalPage = ezPortalService.newMyPortalPageCreate(resetMyParentPageID, userInfo.getId(), gubunFlag2, userInfo.getCompanyID(), pageID);
				pMoveURL = "/ezPortal/portalPage.do?mode=edit&pageID=" + pageID + "&parentPageID=" + resetMyParentPageID;
				
				resp.setCharacterEncoding("UTF-8");
				resp.setContentType("text/html; charset=UTF-8");
				resp.getWriter().write("<script>");
				resp.getWriter().write("function window_onload() { window.location.href = \"" + pMoveURL + "\"; }");
				resp.getWriter().write("window.onload = window_onload;");
				resp.getWriter().write("</script>");
				//resp.getWriter().flush();
			}
			
			if (pageID == null || pageID.equals("")) {
				String commentHtml = "<!DOCTYPE html><HTML>" +
                        "<HEAD>" +
                        "<link href=\"/css/" + egovMessageSource.getMessage("ezPortal.i2", locale) + "\" rel=\"stylesheet\" type=\"text/css\">" +
                        "<style type='text/css'>" +
                        "<!--" +
                        ".warningbox01 { width:540px; margin:0 auto; border:1px solid #cccaca; background:#e8e8e8;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}" +
                        ".warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 20px 25px;}" +
                        ".warnintxt01 { position:relative ;padding-bottom:10px;}" +
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
                        "    <div class='warnintxt01' >" +
                        "    <span class='warningimg'><img src='/images/notify/warning02.gif' width='136' height='112'></span>" +
                        "    <dl class='warningdl'>" +
                        "    <dt><img src='/images/notify/warning01.gif' width='183' height='27'></dt>" +
                        "    <dd>" +
                        "        " + egovMessageSource.getMessage("ezPortal.t286", locale) + "<br>";
						if (userInfo.getRollInfo().indexOf("c=1") > -1) {
							commentHtml += "        <a class=\"imgbtn\"><span style='cursor:pointer' onclick='javascript:window.open(\"/admin/main.do\", \"\", \"\")'>" + egovMessageSource.getMessage("ezPortal.t410", locale) + "</span></a> ";
						}
						commentHtml += "    </dd>" +
						"    </dl>" +
						"    </div>" +
						"    </div>" +
						"</div>" +
						"</BODY>" +
						"</HTML>";
						resp.getWriter().write(commentHtml);
							//resp.getWriter().flush();
							//resp.getWriter().close();
							
			}
			
			if (mode != null && mode.equals("edit") && gubunFlag.equals(rootGubunFlag)) {
				resp.getWriter().write(egovMessageSource.getMessage("ezPortal.t287", locale));
				resp.getWriter().flush();
			}
			
			if ((resetMyParentPageID == null || (resetMyParentPageID.trim()).equals("")) && mode != null && (mode.trim()).equals("edit")) {
				pMoveURL = "/ezPortal/portalPage.do?mode=" + mode + "&parentPageID=" + resetMyParentPageID;
			} else {
				String mainUrl = ezPortalService.getMainUrl(pUserThemeUID);
				pMoveURL = mainUrl + "?mode=" + mode + "&pageID=" + pageID;
			}
			
			resp.getWriter().write("<script>");
			resp.getWriter().write("function window_onload() { window.location.href = \"" + pMoveURL + "\"; }");
			resp.getWriter().write("window.onload = window_onload;");
			resp.getWriter().write("</script>");
			//resp.getWriter().flush();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 포탈 - urlPortlet 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/urlPortlet.do")
	public void urlPortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		try {
			String uID = "";
			if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
				uID = req.getParameter("uID");
			}
			//String pCreatorId = "";
			String pMoveURL = "";
			String gubunFlag = "";
			String pUserID = userInfo.getId();
			
			if (req.getParameter("userID") != null && !req.getParameter("userID").equals("")) {
				pUserID = req.getParameter("userID");
			}
			
			Document xmlDomProp = commonUtil.convertStringToDocument(ezPortalService.getPorletPropertiesStr(uID)); 

			if (xmlDomProp.getElementsByTagName("USERTYPE").getLength() > 0) {
				gubunFlag = xmlDomProp.getElementsByTagName("GUBUNFLAG").item(0).getTextContent();

				if (xmlDomProp.getElementsByTagName("USERTYPE").item(0).getTextContent().trim().equals("1")) {
					Document xmlDomSubProp = commonUtil.convertStringToDocument(ezPortalService.getPortletSubProperties(uID, xmlDomProp.getElementsByTagName("PORTLETTYPE").item(0).getTextContent()));
					
					if (xmlDomSubProp.getElementsByTagName("CREATORID").getLength() > 0) {
						//pCreatorId = xmlDomSubProp.getElementsByTagName("CREATORID").item(0).getTextContent();
						pMoveURL = xmlDomSubProp.getElementsByTagName("URL").item(0).getTextContent();
					}
				} else {
					PortalUrlPortletVO result = ezPortalService.urlPortlet(uID, pUserID);
					String resultXML = commonUtil.getQueryResult(result);
					Document xmlDomSubProp = commonUtil.convertStringToDocument(resultXML);
					
					if (xmlDomSubProp.getElementsByTagName("CREATORID").getLength() > 0) {
						//pCreatorId = xmlDomSubProp.getElementsByTagName("CREATORID").item(0).getTextContent();
						pMoveURL = xmlDomSubProp.getElementsByTagName("URL").item(0).getTextContent();
					}
				}
			}
			
			String parametersXML = ezPortalService.getPortletParameters(uID);
			
			if (pMoveURL != null && !pMoveURL.equals("")) {
				pMoveURL = pMoveURL + ezPortalService.loadGetParametersXML(pMoveURL, parametersXML, userInfo);
				
				if (gubunFlag.equals("2")) {
					if (pMoveURL.indexOf("?") == -1) {
						pMoveURL = pMoveURL + "?pClassID=" + pUserID;
					} else {
						pMoveURL = pMoveURL + "&pClassID=" + pUserID;
					}
				}
				resp.getWriter().write("<script> function window_onload() { window.location.href = \"" + pMoveURL + "\"; } </script>");
				resp.getWriter().write("<body onload='window_onload()'></body>");
			} else {
				resp.getWriter().write("<font style='FONT-SIZE: 9pt'> " + egovMessageSource.getMessage("ezPortal.t276", locale) + "</font>");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 포탈 - webPart NewImage 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewImage.do")
	public String wpNewImage(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		try {
			List<PersonalSliderImageVO> sliderList = ezPersonalService.getSilderList(userInfo.getCompanyID(), "", "");
			model.addAttribute("sliderList", sliderList);
			return "/ezPortal/portalWpNewImage";
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 포탈 - webPart 현재시간 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpTime.do")
	public String wpTime(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		try {
			return "/ezPortal/portalWpTime";
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 포탈 - webPart totalSection 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpTotalSection.do")
	public String wpTotalSection(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String noneActiveX = "";
		String useEditor = config.getProperty("config.EDITOR");
		String useIE11Browser = "";
		String mailAddress = "";
		String displayName = "";
		String department = "";
		String title = "";
		String companyNm = "";
		String userApprovalG = "";
		String lastLogin = "";
		String pollNum = "";
		String userPhoto = "";
		
		try {
			noneActiveX = "YES";
			
			//String userOffset = userInfo.getOs().split("\\|")[1];
			String userOffset = "+09:00";
			
			if ((req.getHeader("User-Agent").indexOf("rv:11") > 0 || req.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && config.getProperty("config.IE11EDITOR").equals("CK")) {
				useIE11Browser = "CK";
			}
			
			mailAddress = userInfo.getEmail();
			if (userInfo.getLang().equals("1")) {
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
			
			lastLogin = ezCommonService.wpCountLoginTime(userInfo.getId());
			
			//전자설문
			pollNum = String.valueOf(ezQuestionService.wpCountPollCount(userInfo.getId()));
			
			//유저이미지
			String result = ezOrganService.getPropertyValue(userInfo.getId(), "extensionAttribute2");
			
			if (result != null && !result.equals("")) {
				userPhoto = "<IMG id=myimg SRC='/ezCommon/downloadAttach.do?filePath=" + URLEncoder.encode("/files/upload_personal/photo/" + result, "UTF-8") + "' width=61 height=64>";
			} else {
				userPhoto = "<img src='/images/default_pic.jpg' width='61' height='64'>";
			}
			
			model.addAttribute("displayName", displayName);
			model.addAttribute("department", department);
			model.addAttribute("title", title);
			model.addAttribute("companyNm", companyNm);
			model.addAttribute("userApprovalG", userApprovalG);
			model.addAttribute("lastLogin", lastLogin);
			model.addAttribute("noneActiveX", noneActiveX);
			model.addAttribute("useIE11Browser", useIE11Browser);
			model.addAttribute("mailAddress", mailAddress);
			model.addAttribute("userInfo", userInfo);
			model.addAttribute("userLang", userInfo.getLang());
			model.addAttribute("pollNum", pollNum);
			model.addAttribute("userPhoto", userPhoto);
			model.addAttribute("userOffset", userOffset);
			model.addAttribute("useEditor", useEditor);
			
			return "/ezPortal/portalWpTotalSection";
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 포탈 - webPart totalSection2 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpTotalSection2.do")
	public String wpTotalSection2(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
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
		
		List<PersonalSliderImageVO> sliderList = ezPersonalService.getSilderList(userInfo.getCompanyID(), "", "");
		
		Calendar cal = Calendar.getInstance();
		String term = String.valueOf(cal.get(Calendar.YEAR)) + "-" + String.valueOf(cal.get(Calendar.MONTH)+1);
		
		PersonalGetEmpOfMonthVO result = ezPersonalService.getEmpOfMonth(term);
		
		if (result != null) {
			if (result.getFilePath() != null && !result.getFilePath().equals("")) {
				filePath = "/ezCommon/interface.do?type=personal&fileName="+result.getFilePath();
			} else {
				filePath = "/images/default_pic.jpg";
			}
			
			if (userInfo.getLang().equals("2")) {
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
			pCompanyBDNM = ezPortalService.getBoardProperty(pCompanyBoard, userInfo.getLang()).split("\\:")[0];
			pCompanyType = ezPortalService.getBoardProperty(pCompanyBoard, userInfo.getLang()).split("\\:")[1];
		}
		if (req.getParameter("deptBoardID") != null && !req.getParameter("deptBoardID").equals("")) {
			pDeptBoardID = req.getParameter("deptBoardID");
			pDeptBDNM = ezPortalService.getBoardProperty(pDeptBoardID, userInfo.getLang()).split("\\:")[0];
			pDeptType = ezPortalService.getBoardProperty(pDeptBoardID, userInfo.getLang()).split("\\:")[1];
		}
		if (req.getParameter("newsBoardID") != null && !req.getParameter("newsBoardID").equals("")) {
			pNewsBoardID = req.getParameter("newsBoardID");
			pNewsBDNM = ezPortalService.getBoardProperty(pNewsBoardID, userInfo.getLang()).split("\\:")[0];
			pNewsType = ezPortalService.getBoardProperty(pNewsBoardID, userInfo.getLang()).split("\\:")[1];
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
		
		return "/ezPortal/portalWpTotalSection2";	
	}
	
	/**
	 * 포탈 - webPart 공지사항 & 뉴스 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewBoard.do")
	public String wpNewBoard(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
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
        //String pItemID = "";
        //String pDocTitle = "";
       // String pDocContent = "";
        //boolean pExist = true;
		try {
			if (req.getParameter("companyBoardID") != null && !req.getParameter("companyBoardID").equals("")) {
				pCompanyBoard = req.getParameter("companyBoardID");
				pCompanyBDNM = ezPortalService.getBoardProperty(pCompanyBoard, userInfo.getLang()).split("\\:")[0];
				pCompanyType = ezPortalService.getBoardProperty(pCompanyBoard, userInfo.getLang()).split("\\:")[1];
			}
			if (req.getParameter("deptBoardID") != null && !req.getParameter("deptBoardID").equals("")) {
				pDeptBoardID = req.getParameter("deptBoardID");
				pDeptBDNM = ezPortalService.getBoardProperty(pDeptBoardID, userInfo.getLang()).split("\\:")[0];
				pDeptType = ezPortalService.getBoardProperty(pDeptBoardID, userInfo.getLang()).split("\\:")[1];
			}
			if (req.getParameter("newsBoardID") != null && !req.getParameter("newsBoardID").equals("")) {
				pNewsBoardID = req.getParameter("newsBoardID");
				pNewsBDNM = ezPortalService.getBoardProperty(pNewsBoardID, userInfo.getLang()).split("\\:")[0];
				pNewsType = ezPortalService.getBoardProperty(pNewsBoardID, userInfo.getLang()).split("\\:")[1];
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
			return "/ezPortal/portalWpNewBoard";
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * 포탈 - webPart 우수사원 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewSide.do")
	public String wpNewSide(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String filePath = "";
		String displayName = "";
		String title = "";
		String description = "";
		
		try {
			Calendar cal = Calendar.getInstance();
			String term = String.valueOf(cal.get(Calendar.YEAR)) + "-" + String.valueOf(cal.get(Calendar.MONTH)+1);
			
			
			PersonalGetEmpOfMonthVO result = ezPersonalService.getEmpOfMonth(term);
			
			if (result != null) {
				if (result.getFilePath() != null && !result.getFilePath().equals("")) {
					filePath = "/ezCommon/interface.do?type=personal&fileName="+result.getFilePath();
				} else {
					filePath = "/images/default_pic.jpg";
				}
				
				if (userInfo.getLang().equals("2")) {
					displayName = result.getDisplayName2();
					title = result.getTitle2();
					description = result.getDescription2();
				} else {
					displayName = result.getDisplayName();
					title = result.getTitle();
					description = result.getDescription();
				}
			}
			
			model.addAttribute("displayName", displayName);
			model.addAttribute("title", title);
			model.addAttribute("description", description);
			model.addAttribute("filePath", filePath);
			model.addAttribute("result", result);
			return "/ezPortal/portalWpNewSide";
		} catch (Exception e) {
			return "";
		}
	}
	
	/**
	 * 포탈 - webPart 전자결재 & 메일 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewApprMail.do")
	public String wpNewApprMail(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
	
		try {
			
			model.addAttribute("userApprovalG", config.getProperty("config.UserInfo_ApprovalG"));
			model.addAttribute("userLang", userInfo.getLang());
			model.addAttribute("userInfo", userInfo);
			return "/ezPortal/portalWpNewApprMail";
		} catch (Exception e) {
			return "";
		}
	}
	
	/**
	 * 포탈 - webPart 배너 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewGWBanner.do")
	public String wpNewGWbanner(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
	
		
		try {
			
			return "/ezPortal/portalWpNewGWBanner";
		} catch (Exception e) {
			return "";
		}
	}
	
	/**
	 * 포탈 - webPart 커뮤니티 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewCommunity.do")
	public String wpNewCommunity(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String strHTML = ezPortalService.addBestTable(userInfo);
		
		try {
			model.addAttribute("userInfo", userInfo);
			model.addAttribute("strHTML", strHTML);
			return "/ezPortal/portalWpNewCommunity";
		} catch (Exception e) {
			return "";
		}
	}
	
	/**
	 * 포탈 - webPart 게시판 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewBoardSTD.do")
	public String wpNewBoardSTD(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
	
		try {
			
			model.addAttribute("userLang", userInfo.getLang());
			return "/ezPortal/portalWpNewBoardSTD";
		} catch (Exception e) {
			return "";
		}
	}
	
	/**
	 * 포탈 - webPart 설문참여 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewPoll.do")
	public String wpNewPoll(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String votePoll = "";
		int pPollItemSeq = 0;
		String pPollTitle = "";
		String pPollResultContent = "";
		
		PersonalLightPollVO result = ezPersonalService.getCurrentPoll(userInfo.getId(), userInfo.getCompanyID());
		
		Document xmlDom = commonUtil.convertStringToDocument("<DATA>"+commonUtil.getQueryResult(result)+"</DATA>");
		
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
				pPollTitle = userInfo.getLang().equals("1") ? result.getPollTitle() : result.getPollTitle2();
				
				List<PersonalLightPollVO> list = ezPersonalService.getPollResultOrderResult(pPollItemSeq);
				
				int pTotalCnt = 0;
				for (int i=0; i<list.size(); i++) {
					pTotalCnt = pTotalCnt + list.get(i).getCount();
				}
				//ArrayList pPollResultList
				List<Integer> pPollResultList = new ArrayList<Integer>();
				int resultPrintCnt = 0;
				for (int i=0; i<list.size(); i++) {
					if (i >= 4) {
						break;
					} else {
						float poolRstCnt = list.get(i).getCount();
						float poolRstPer = ((poolRstCnt / pTotalCnt) * 100);
						String strAnswer =  xmlDom.getElementsByTagName("ANSWER"+list.get(i).getResult()).item(0).getTextContent();
						if (strAnswer.length() > 11) {
							strAnswer = strAnswer.substring(0, 11) + "…";
						}
						pPollResultList.add(list.get(i).getResult());
						pPollResultContent += "<dl class=\"poll_list\">" + "<dt>" + list.get(i).getResult() + "." + strAnswer + " (" + 
						"<strong>" + list.get(i).getCount() + "</strong>" + egovMessageSource.getMessage("main.t20000", locale) +
						"<strong class=\"redtxt\">" + String.format("%.1f", poolRstPer)  + "</strong>%)</dt>" +
						"<dd  class=\"graphbar\"><p class=\"gx_bar1\" style=\"width:" + String.format("%.1f", poolRstPer) + "%\"></p></dd>" +
						"</dl>";
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
							if (strAnswer.length() > 13) {
								strAnswer = strAnswer.substring(0, 13) + "...";
							}
							pPollResultContent += "<dl class=\"poll_list\">" + "<dt>" + i + "." + strAnswer + " (" +
                                    						"<strong>0</strong>명/ " + "<strong class=\"redtxt\">0</strong>%)</dt>" +
                                    						"<dd  class=\"graphbar\"><p class=\"gx_bar1\" style=\"width:0%\"></p></dd>" + "</dl>";
															resultPrintCnt++;
							
							if (resultPrintCnt == 4) {
								break;
							}
						}
						
					}
				}
			}
		}
		
		model.addAttribute("pPollTitle", pPollTitle);
		model.addAttribute("votePoll", votePoll);
		model.addAttribute("pPollItemSeq", pPollItemSeq);
		model.addAttribute("pPollResultContent", pPollResultContent);
		model.addAttribute("userLang", userInfo.getLang());
		return "/ezPortal/portalWpNewPoll";
		
	}
	
	/**
	 * 포탈 - webPart 결재 통계 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/wpNewGraph.do")
	public String wpNewGraph(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		int dMaxCount = 0;
		//int sMaxCount = 0;
		//float draftPercent = 0;
		//float susinPercent = 0;
		
		Calendar cal = Calendar.getInstance();
		String startDate = String.valueOf(cal.get(Calendar.YEAR)) + "-" + String.valueOf(cal.get(Calendar.MONTH)-1) + "-01 00:00:00";
		String endDate = String.valueOf(cal.get(Calendar.YEAR)) + "-" + String.valueOf(cal.get(Calendar.MONTH)-1) + "-" +  ezPortalService.daysInMonth(cal.get(Calendar.MONTH)-1, cal.get(Calendar.YEAR)) + " 23:59:59";
	
		List<ApprGgetDeptStacticsVO> list = ezApprovalGService.getDeptStactics(startDate, endDate, userInfo.getPrimary(), userInfo.getCompanyID());
		
		String dMax = "1";
		if (list.size() > 0) {
			for (int j=0; j<String.valueOf(list.get(0).getDraftCount()).length() - 1; j++) {
				dMax = dMax + "0";
			}
			
			dMaxCount = list.get(0).getDraftCount() + Integer.parseInt(dMax);
			//sMaxCount = list.get(0).getSusinCount() + Integer.parseInt(dMax);
			
			for (int i=0; i<list.size(); i++) {
				//draftPercent = list.get(i).getDraftCount() / dMaxCount * 100;
				//susinPercent = list.get(i).getSusinCount() / dMaxCount * 100;
			}
		} else {
			dMax = "0";
			dMaxCount = 0;
		}
		
		model.addAttribute("dMaxCount", dMaxCount);
		model.addAttribute("list", list);
		
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
		
		model.addAttribute("userLang", userInfo.getLang());
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
		model.addAttribute("userLang", userInfo.getLang());
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
		userInfo = commonUtil.userInfo(loginCookie);
		
		int noViewCnt = 0;
		int cnt = 0;
		String[] noViewArrayID = new String[1000];
		String[] arrayID = new String[1000];
		StringBuilder result = new StringBuilder("<DATA>");
		
		String deptFullPath = ezOrganService.getDeptFullPath(userInfo.getDeptID());

		String[] splitDeptPath = new String[deptFullPath.split("\\,").length];
		String reversePath = "";
		splitDeptPath = deptFullPath.split("\\,");
		
		for (int i=0; i<splitDeptPath.length; i++) {
			reversePath += splitDeptPath[splitDeptPath.length - i - 1] + ",";
		}
		
		String pAccessID = userInfo.getId() + "," + reversePath + "everyone";
		
		for (int j=0; j<pAccessID.split("\\,").length; j++) {
			PersonalGetQuickLinkMenuVO getQuickLinkMenu = ezPersonalService.getQuickLinkMenu(pAccessID.split("\\,")[j].trim());

			if (getQuickLinkMenu != null) {
				boolean TF = true;
				if (getQuickLinkMenu != null && getQuickLinkMenu.getView_Flag().equals("N")) {
					noViewArrayID[noViewCnt] = getQuickLinkMenu.getQuickLinkID();
					noViewCnt++;
				} else {
					for (int z=0; z < noViewCnt; z++) {
						if (noViewArrayID != null && noViewArrayID[z].equals(getQuickLinkMenu.getQuickLinkID())) {
							TF = false;
							break;
						}
					}
					
					for (int i=0; i < cnt; i++) {
						if (arrayID[i] != null && arrayID[i].equals(getQuickLinkMenu.getQuickLinkID())) {
							TF = false;
							break;
						}
					}

					if (TF) {
						arrayID[cnt] = getQuickLinkMenu.getQuickLinkID();
						cnt ++;
						result.append("<ROW>");
						
						for (Field field : getQuickLinkMenu.getClass().getDeclaredFields()) {
							field.setAccessible(true);
							String data = String.valueOf(field.get(getQuickLinkMenu));
							
							if(data == null || data.equals(null) || data.equals("null")){
								data = "";
							}	
							result.append("<" + field.getName().toUpperCase() + ">");
							result.append(commonUtil.cleanValue(data));
							result.append("</" + field.getName().toUpperCase() + ">");
						}
						result.append("</ROW>");
					}
				}
			}
		}
		result.append("</DATA>");
		return result.toString();
	}
	
	
	/**
	 * 포탈 - 환경설정 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/environmentMain.do")
	public String environmentMain(Model model, HttpServletRequest req) throws Exception {
		String usePortal = "";
		String url = "";
		String funCode = "";
		
		usePortal = config.getProperty("config.Use_Portal");
		
		if (req.getParameter("funCode") != null && !req.getParameter("funCode").equals("")) {
			funCode = req.getParameter("funCode");
		}
		
		if (funCode.equals("1")) {
			url = "/ezPersonal/leftEnvironment.do?funCode=1";
		} else {
			url = "/ezPersonal/leftEnvironment.do";
		}

		model.addAttribute("usePortal", usePortal);
		model.addAttribute("url", url);
		
		return "/ezPortal/portalEnvironmentMain";
	}
	
	/**
	 * 포탈 - 환경설정 MyPortalPageList 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/myPortalPageList.do")
	public String environmentMain(Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pSearchString = "";
		String portalGubun = "";
		String portalPageCategoryXML = "";
		String myPortalListXML = "";
		String parentPageID = "";
		String pageID = "";
		String gubunFlag = "";
		String newMyPortalPage = "";
		String newMyPortalPageXML = "";
		String newMyPortalPageList = "";
		String searchNewMyPortalPageList = "";
		int recordCnt = 0;
		int intPage = 1;
		int totalPage = 1;
		
		if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").equals("")) {
			parentPageID = req.getParameter("parentPageID");
		} else {
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
				parentPageID = ezPortalService.getPortalConfigItem("parentUID", pageID);
			} else {
				parentPageID = "Top";
			}
		}
		
		gubunFlag = "1";
		List<PortalTBLPortalPageGeneralVO> myPortalList = ezPortalService.myPortalList(gubunFlag, userInfo.getDeptPathCode(), userInfo.getCompanyID());
		
		if (myPortalList.size() > 0) {
			gubunFlag = "1c";
			for (PortalTBLPortalPageGeneralVO myPortal : myPortalList) {
				parentPageID = myPortal.getuID();
				newMyPortalPage = ezPortalService.newMyPortalPageCreate(parentPageID, userInfo.getId(), gubunFlag, userInfo.getCompanyID(), "");
			}
		}
		
		if (myPortalList.size() > 0) {
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			for (int i=0; i<myPortalList.size(); i++) {
				List<PortalTBLPortalPageGeneralVO> tempNewMyPortalPageList = ezPortalService.newMyPortalList(userInfo.getId(), gubunFlag);
				for (int t=0; t<tempNewMyPortalPageList.size(); t++) {
					String uID = myPortalList.get(i).getuID();
					String newPortalParentUID = tempNewMyPortalPageList.get(t).getParentUID().trim();
					
					if (uID != null && uID.equals(newPortalParentUID)) {
						sb.append("<ROW>");
						sb.append("<UID_>" + tempNewMyPortalPageList.get(t).getuID() + "</UID_>");
                        sb.append("<DISPLAYNAME>" + tempNewMyPortalPageList.get(t).getDisplayName() + "</DISPLAYNAME>");
                        sb.append("<USEFLAG>" + tempNewMyPortalPageList.get(t).getUseFlag() + "</USEFLAG>");
                        sb.append("</ROW>");
					}
				}
			}
			sb.append("</DATA>");
			newMyPortalPageList = sb.toString();
		}
		
		if (req.getParameter("intPage") != null && !req.getParameter("intPage").equals("")) {
			intPage = Integer.parseInt(req.getParameter("intPage"));
		}
		
		int listPageSize = 15;
		
		List<PortalTBLPortalPageCategoryVO> portalPageCategory = ezPortalService.getPortalPageCategory();
		
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
		
		recordCnt = ezPortalService.searchMyPortalPageCount(gubunFlag, userInfo.getDeptPathCode(), userInfo.getCompanyID());
		totalPage = (recordCnt - 1) / listPageSize + 1;
		int pStartRow = 0;
		int pEndRow = 0;
		pStartRow = intPage * listPageSize - listPageSize + 1;
		pEndRow = intPage * listPageSize;
		
		searchNewMyPortalPageList = ezPortalService.searchMyPortal(userInfo.getId(), gubunFlag, pStartRow, pEndRow, userInfo.getCompanyID());
		
		Document xmlDom = commonUtil.convertStringToDocument(searchNewMyPortalPageList);
		
		String resultHTML = "";
		for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
			if (xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent() != null && xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent().trim().equals("Y")) {
				resultHTML += "<script>var SelectedItems ="+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"</script>";
				resultHTML += "<dl id='"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"' onclick=\"setValueNew('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent().trim()+"', this)\" ondblclick=\"selectItem('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', this)\">";
				resultHTML	+= "<dt>";
				resultHTML	+= "<div class='onimg'></div>";
				resultHTML	+= "<img src='"+xmlDom.getElementsByTagName("IMAGEURL").item(i).getTextContent()+"' width='175' height='140'>";
				resultHTML+= "</dt>";
				resultHTML += "<dd>"+xmlDom.getElementsByTagName("DISPLAYNAME").item(i).getTextContent()+"</dd>";		
        		resultHTML += "</dl>";
			} else {
				resultHTML += "<dl id='"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"' onclick=\"setValueNew('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent().trim()+"', this)\" ondblclick=\"selectItem('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', this)\">";
				resultHTML	+= "<dt>";
				resultHTML	+= "<div>";
				resultHTML	+= "<img src='"+xmlDom.getElementsByTagName("IMAGEURL").item(i).getTextContent()+"' width='175' height='140'>";
				resultHTML+= "</dt>";
				resultHTML += "<dd>"+xmlDom.getElementsByTagName("DISPLAYNAME").item(i).getTextContent()+"</dd>";		
        		resultHTML += "</dl>";
			}
		}
		
		model.addAttribute("searchNewMyPortalPageList", searchNewMyPortalPageList);
		model.addAttribute("resultHTML", resultHTML);
		model.addAttribute("intPage", intPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("pSearchString", pSearchString);
		model.addAttribute("portalGubun", portalGubun);
		return "/ezPortal/portalMyPortalPageList";
	}
	
	
	/**
	 * 포탈 - 환경설정 초기 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/startPageUser.do")
	public String startPageUser(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
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
		
		String userPortalPage = ezPortalService.getUserInfo(userInfo.getId(), userInfo.getDisplayName1(), pageID, "1c", "view", userInfo, userInfo.getCompanyID());
		Document xmlDom = commonUtil.convertStringToDocument(userPortalPage);
		
		if (xmlDom.getElementsByTagName("ROW").getLength() > 0) {
			pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(0).getTextContent();
		} else {
			String portalPageXml = ezPortalService.searchMyPortalPage("1", "view", userInfo, userInfo.getCompanyID());
			
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
		
		String useTopMenuIDXml = ezPortalService.useTopMenuID2(userInfo.getCompanyID(), "Y", userInfo.getLang(), pUserThemeUID);
		
		if (useTopMenuIDXml.equals("<DATA></DATA>")) {
			useTopMenuIDXml = ezPortalService.useTopMenuID(userInfo.getCompanyID(), "Y", pUserThemeUID);
		}
		
		Document xmlDom1 = commonUtil.convertStringToDocument(useTopMenuIDXml);
		
		Document xmlDomTop = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang()));

		if (xmlDomTop.getElementsByTagName("UID").getLength() != 0) {
			myTopUID = xmlDomTop.getElementsByTagName("UID").item(0).getTextContent().trim();
		}

		for (int i=0; i<xmlDom1.getElementsByTagName("UID").getLength(); i++) {
			if (xmlDom1.getElementsByTagName("PARENTUID").item(i).getTextContent() != null && xmlDom.getElementsByTagName("PARENTUID").item(i).getTextContent().trim().equals(myTopUID)) {
				homeUID = xmlDom1.getElementsByTagName("UID").item(i).getTextContent().trim();
				parentUID = xmlDom1.getElementsByTagName("PARENTUID").item(i).getTextContent().trim();
				imageUID = xmlDom1.getElementsByTagName("IMAGEUID").item(i).getTextContent().trim();
				linkURL = xmlDom1.getElementsByTagName("LINKURL").item(i).getTextContent().trim();
			}
		}
		
		if (homeUID == null || homeUID.equals("")) {
			homeUID = xmlDom1.getElementsByTagName("UID").item(0).getTextContent().trim();
			parentUID = xmlDom1.getElementsByTagName("PARENTUID").item(0).getTextContent().trim();
			imageUID = xmlDom1.getElementsByTagName("IMAGEUID").item(0).getTextContent().trim();
			linkURL = xmlDom1.getElementsByTagName("LINKURL").item(0).getTextContent().trim();
		}
		
		useStartPage = ezPortalService.searchStartPage(homeUID, parentUID, imageUID, userInfo.getId(), userInfo.getCompanyID(), linkURL).trim();
		
		String deptPath = userInfo.getDeptPathCode();
		for (int ch = 0; ch < deptPath.split("\\,").length; ch++) {
			if (ch ==0) {
				deptPathOrgan += deptPath.split("\\,")[ch].trim();
			} else {
				deptPathOrgan += "," + deptPath.split("\\,")[deptPath.split("\\,").length - (ch)].trim();
			}
		}
		
		String userDeptPath = deptPathOrgan + ",everyone";
		
		List<PortalFirstMainListVO> list = ezPortalService.firstMainList(parentUID, userDeptPath);
		
		model.addAttribute("useStartPage", useStartPage);
		model.addAttribute("list", list);
		return "/ezPortal/portalStartPageUser";
	}
	
	/**
	 * 포탈 - 환경설정 초기 화면 저장 실행 함수
	 */
	@RequestMapping(value = "/ezPortal/useMyStartPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String useMyStartPage(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		String oldUID = "";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		if (req.getParameter("oldUID") != null && !req.getParameter("oldUID").equals("")) {
			oldUID = req.getParameter("oldUID");
		}
		
		String result = ezPortalService.setUseMyStartPage(uID, oldUID, userInfo.getId(), userInfo.getCompanyID(), userInfo.getLang());
		
		return result;
	}
	
	/**
	 * 포탈 - 환경설정 마이포탈페이지 저장 실행 함수
	 */
	@RequestMapping(value = "/ezPortal/useMyPortalPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String useMyPortalPage(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		String gubunFlag = "1c";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		String result = ezPortalService.setUseMyPortalPage(uID, userInfo.getId(), userInfo.getCompanyID(), gubunFlag);
		return result;
	}
	
	@RequestMapping(value = "/ezPortal/myPortalPage.do")
	public String myPortalPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
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
		try {
			
			langPrimary = config.getProperty("config.lang_Primary"+ userInfo.getLang());
			langSecondary = config.getProperty("config.lang_Secondary1" + userInfo.getLang());
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
					parentPageID = ezPortalService.getPortalConfigItem("ParentUID", pageID); 
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
			if (req.getParameter("skinNum") != null &&  !req.getParameter("skinNum").equals("")) {
				//respons skinNum
			}
			skinType = req.getParameter("skinNum");
			if (skinType != null && skinType.trim().equals("")) {
				skinType = "1";
			}
			skinType = "skin_" + skinType;
			
			// 미리보기인 경우 자기의 캐쉬정보를 삭제한다.
			if (viewMode.equals("preview")) {
				ezPortalService.deleteCacheValue(pageID, ezPortalService.getAccessList(userInfo));
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
			tableViewOption = ezPortalService.getPortalConfigItem("TableViewOption", pageID).trim().equals("") ? "D" : ezPortalService.getPortalConfigItem("TableViewOption", pageID);
			if (mode.trim().equals("new")) {
				strHTML = ezPortalService.getDefaultPortalPage();
			} else {  // 읽기, 편집: 본문HTML, width, height정보를 가져온다
				if (editMode.equals("new_inherit")) {
					strHTML = ezPortalService.getRenderedPortalPageHTML(parentPageID, "", mode, userInfo, theme, tableViewOption);
					width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(parentPageID));
					height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(parentPageID));
				} else {
					strHTML = ezPortalService.getRenderedPortalPageHTML(pageID, "", mode, userInfo, theme, tableViewOption);
					width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(pageID));
					height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(pageID));
					baseType = ezPortalService.portalPageBaseType(pageID, userInfo.getCompanyID());
				}
			}
			
			if (width == null || (width).equals("") || (width).equals("-1") || (width).equals("0")) {
				width = "100%";
			}
					
			if (height == null || height.equals("") || height.equals("-1") || height.equals("0")) {
				height = "100%";
			}
					
			if (!mode.equals("view")) {
				displayName = ezPortalService.getPortalConfigItem("DisplayName", pageID);
				displayName2 = ezPortalService.getPortalConfigItem("DisplayName2", pageID);
	            pSelectThemeUID = ezPortalService.getPortalConfigItem("ThemeUID", pageID);
	            pThemeSelectObject =  ezPortalService.getThemeInfoPortal(userInfo.getCompanyID(), userInfo, pSelectThemeUID);
	                    
	            //신규 상속페이지인 경우 부모페이지의 구분정보를 가져온다.
	            if (editMode.equals("new_inherit")) {
	            	gubunFlag = ezPortalService.getPortalConfigItem("GubunFlag", parentPageID);
	            } else {
	            	gubunFlag = ezPortalService.getPortalConfigItem("GubunFlag", pageID);
	            }
	                    
	            List<PortalTBLPortalPageCategoryVO> list = ezPortalService.getPortalPageCategory();
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
			
			return "/ezPortal/portalMyPortalPage";
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * 포탈 - 환경설정 마이포탈페이지 portalPageSearch 실행 함수
	 */
	@RequestMapping(value = "/ezPortal/portalPageSearch.do")
	public String portalPageSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "";
		String portalGubun = "";
		String strHTML = "";
		
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		
		List<PortalTBLPortalPageCategoryVO> list = ezPortalService.getPortalPageCategory();
		
		//Root페이지만 보여지도록 설정
		for (int i=0; i<list.size(); i++) {
			if (portalGubun == null || portalGubun.equals("")) {
				portalGubun = "'" + list.get(i).getCategory() + "'";
			} else {
				portalGubun += ",'" + list.get(i).getCategory() + "'";
			}
		}
		
		String strXML = ezPortalService.searchPortalPage("", "", portalGubun, 1, 100, "");

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
		
		return "/ezPortal/portalPortalPageSearch";
	}
	
	/**
	 * 포탈 - 환경설정 마이포탈페이지 portalPortletSearch 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/portletSearch.do")
	public String portletSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		StringBuilder sb = new StringBuilder();
		List<PortalTBLPortalPageCategoryVO> list = ezPortalService.getPortalPageCategory();
		
		sb.append("<DATA>");
		for (int i=0; i<list.size(); i++) {
			sb.append(commonUtil.getQueryResult(list.get(i)));
		}
		sb.append("</DATA>");

		model.addAttribute("portletCategoryXML", sb.toString());
		if (userInfo.getLang() != null && userInfo.getLang().equals("1")) {
			model.addAttribute("userLang", "");
		} else {
			model.addAttribute("userLang", commonUtil.getLangData(userInfo.getLang()));
		}
		
		return "/ezPortal/portalPortletSearch";
	}
	
	/**
	 * 포탈 - 환경설정 마이포탈페이지 portalPortletSearchList 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/portletSearchList.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String portletSearchList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
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
		
		String strXML = ezPortalService.searchPortletCheckRight("", pType, pPageType, mode, 1, 100, userInfo, userInfo.getCompanyID());

		return strXML;
	}
	
	/**
	 * 포탈 - 포탈페이지 권한 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/portalPageACL.do")
	public String portalPageACL(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String uID = "";
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		List<PortalTBLPortalACLVO> list = ezPortalService.getAclItems(uID);
		model.addAttribute("list", list);
		model.addAttribute("uID", uID);
		return "/ezPortal/portalPortalPageACL";
	}
	
	/**
	 * 포탈 - 도움말 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/help/help.do")
	public String help(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("lang", userInfo.getLang());
		
		return "/ezPortal/help/help";
	}
	
	/**
	 * 포탈 - 포틀릿 추가 portalMenuItemSearch 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPortal/menuItemSearch.do")
	public String menuItemSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String mainHTML = "";
		String strXML = ezPortalService.searchMenuItem("", 1, 10, "");
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
		return "/ezPortal/portalMenuItemSearch";
	}
}
