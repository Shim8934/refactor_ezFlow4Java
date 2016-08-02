package egovframework.ezEKP.ezPortal.web;

import java.net.URLEncoder;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageCategoryVO;
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
					if (pUserThemeUID.equals("")) {
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
			
			if (!xmlDomACL.getElementsByTagName("TOPHEIGHT").item(0).getTextContent().equals("")) {
				topHeight = xmlDomACL.getElementsByTagName("TOPHEIGHT").item(0).getTextContent();
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
		String password;
		String skinNum = "1";
		String skinBgFlag = "";
		String skinBgColor = "";
		String skinBgImage = "";
		String skinFontColor = "";
		String skinFontOverColor = "";
		String skinBgString = "";
		String skinExist = "NO";
		String result = "";
		String portalMenuID = "";
		String portalMenuXml = "";
		int pollNum = 0;
		String script1;
		String currSkin = "";
		String langPrimary = "";
		String langSecondary = "";
		String theme = "BASIC";
		String noneActiveX = "YES";
		
		try {
			langPrimary = config.getProperty("config.lang_Primary"+ userInfo.getLang());
			langSecondary = config.getProperty("config.lang_Secondary1" + userInfo.getLang());
			mode = "edit";
			
			if (!("").equals(req.getParameter("pageID"))) {
				pageID = req.getParameter("pageID");
			} else {
				pageID = UUID.randomUUID().toString();
			}
			
			if (!("").equals(req.getParameter("parentPageID"))) {
				parentPageID = req.getParameter("parentPageID");
			} else {
				if (!("").equals(req.getParameter("pageID"))) {
					parentPageID = ezPortalService.getTopMenuConfigItem("ParentUID", pageID);
				} else {
					parentPageID = "top";
				}
			}
			
			if (!("").equals(req.getParameter("mode"))) {
				mode = req.getParameter("mode");
			}

			if (("edit").equals(mode)) {
				//관리자 권한체크
				boolean auth = commonUtil.checkAdmin(loginCookie);
				if (!auth) {
					resp.setCharacterEncoding("UTF-8");
					resp.setContentType("text/html; charset=UTF-8");
					resp.getWriter().write(egovMessageSource.getMessage("ezPortal.t264", locale));
					resp.getWriter().flush();
				}
			}
				
			if ("edit".equals(mode)) {
				if (req.getParameter("pageID").equals("") && !req.getParameter("parentPageID").equals("")) {
					if (!req.getParameter("parentPageID").trim().equals("") && !req.getParameter("parentPageID").trim().toLowerCase().equals("top")) {
						editMode = "new_inherit";
					}
				}
			}
				
			//미리보기
			if (req.getParameter("viewMode") != null) {
				viewMode = req.getParameter("viewMode");
			}
				
			//미리보기인 경우 자기의 캐쉬정보를 삭제한다
			if (("preView").equals(viewMode)) {
				ezPortalService.deleteCacheValue(pageID, ezPortalService.getAccessList(userInfo));
			}
				
			//스킨정보
			if (!("").equals(req.getParameter("skinNum"))) {
				skinNum = req.getParameter("skinNum");
			}
				
			if (userInfo.getLang().equals("1")) {
				//resp.cookies skinnum
				currSkin = skinNum;
			} else if (userInfo.getLang().equals("2")) {
				currSkin = skinNum + "_2";
			} else if (userInfo.getLang().equals("3")) {
				currSkin = skinNum + "_3";
			} else if (userInfo.getLang().equals("4")) {
				currSkin = skinNum + "_4";
			}
				
			//새로만들기
			if (mode.equals("new")) {
				strHTML = ezPortalService.getDefaultTopMenu();
			} 
			// 열기 : 본문HTML, width, height정보를 가져온다
			else {
				if (editMode.equals("new_inherit")) {
					strHTML = ezPortalService.getRenderedTopMenuHTML(parentPageID, "", mode, skinNum, userInfo, theme);
					//width = ezPortalService.getTopMenuConfigItem(ezPortalService.gett)
					//height
				} else {
					strHTML = ezPortalService.getRenderedTopMenuHTML(pageID, "", mode, skinNum, userInfo, theme);
					//width = ezPortalService.getTopMenuConfigItem(ezPortalService.gett)
					//height
				}
			}
			if (width.equals("") || width.equals("-1") || width.equals("0")) {
				width = "100%";
			}
			if (height.equals("") || height.equals("-1") || height.equals("0")) {
				height = "100%";
			}
			if (!mode.equals("view")) {
				displayName = ezPortalService.getTopMenuConfigItem("DisplayName", pageID);
				displayName2 = ezPortalService.getTopMenuConfigItem("DisplayName2", pageID);
			}
				
			//사용자 영역에서만 팝업 공지사항을 오픈한다.

			model.addAttribute("strHTML", strHTML);
			model.addAttribute("displayName", displayName);
			model.addAttribute("displayName2", displayName2);
			model.addAttribute("langPrimary", langPrimary);
			model.addAttribute("langSecondary", langSecondary);
			model.addAttribute("userInfo", userInfo);
			model.addAttribute("lang", userInfo.getLang());
			model.addAttribute("mode", "view");
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
		try {
			userInfo = commonUtil.userInfo(loginCookie);
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
System.out.println("parentPageID:"+parentPageID);
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
			if (!pClassID.trim().equals("")) {
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
					strHTML = ezPortalService.getRenderedPortalPageHTML(parentPageID, "", mode, userInfo, theme, tableViewOption);
					width = ezPortalService.getPortalConfigItem("width", ezPortalService.getTopParentPageID(pageID));
					height = ezPortalService.getPortalConfigItem("height", ezPortalService.getTopParentPageID(pageID));
					baseType = ezPortalService.portalPageBaseType(pageID, userInfo.getCompanyID());
				}
			}
			
			if (("").equals(width) || ("-1").equals(width) || ("0").equals(0)) {
				width = "100%";
			}
					
			if (("").equals(height) || ("-1").equals(height) || ("0").equals(height)) {
				height = "100%";
			}
					
			if (!mode.equals("view")) {
				displayName = ezPortalService.getPortalConfigItem("DisplayName", pageID);
				displayName2 = ezPortalService.getPortalConfigItem("DisplayName2", pageID);
	            pSelectThemeUID = ezPortalService.getPortalConfigItem("ThemeUID", pageID);
	            pThemeSelectObject =  ezPortalService.getThemeInfo(userInfo.getCompanyID(), userInfo);
	                    
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
					
System.out.println("strHTML:"+strHTML);

				model.addAttribute("strHTML", strHTML);
				model.addAttribute("pThemeSelectObject", pThemeSelectObject);
				model.addAttribute("displayName", displayName);
				model.addAttribute("displayName2", displayName2);
				model.addAttribute("mode", mode);
				model.addAttribute("parentPageID", parentPageID);
				model.addAttribute("baseType", baseType);
				model.addAttribute("baseType", baseType);
				model.addAttribute("langPrimary", langPrimary);
				model.addAttribute("langSecondary", langSecondary);
			
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
System.out.println("reset:"+resetMyParentPageID);
			if (resetMyParentPageID.length() == 0) {
System.out.println("???");
				if (xmlDom.getElementsByTagName("ROW").getLength() > 0) {
					pageID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
					gubunFlag = xmlDom.getElementsByTagName("GUBUNFLAG").item(0).getTextContent();
					rootGubunFlag = gubunFlag;
					pUserThemeUID = xmlDom.getElementsByTagName("THEMEUID").item(0).getTextContent();
				} else {
					String portalPageXml = ezPortalService.searchMyPortalPage(gubunFlag, mode, userInfo, userInfo.getCompanyID());
System.out.println("portalPageXml:"+portalPageXml);
					
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
				String gubunFlag2 = "1c";
				pageID = UUID.randomUUID().toString();
				String newMyPortalPage = ezPortalService.newMyPortalPageCreate(resetMyParentPageID, userInfo.getId(), gubunFlag2, userInfo.getCompanyID(), pageID);
				pMoveURL = "/ezPortal/portalPage.do?mode=edit&pageID=" + pageID + "&parentPageID=" + resetMyParentPageID;
				
				resp.setCharacterEncoding("UTF-8");
				resp.setContentType("text/html; charset=UTF-8");
				resp.getWriter().write("<script>");
				resp.getWriter().write("function window_onload() { window.location.href = \"" + pMoveURL + "\"; }");
				resp.getWriter().write("window.onload = window_onload;");
				resp.getWriter().write("</script>");
				//resp.getWriter().flush();
			}
			
			if (("").equals(pageID)) {
				//권한이 있는 포탈페이지가 없을 경우
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
						if (userInfo.getRollInfo().indexOf("c=1") > -1)
							commentHtml += "        <a class=\"imgbtn\"><span style='cursor:pointer' onclick='javascript:window.open(\"/admin/main.do\", \"\", \"\")'>" + egovMessageSource.getMessage("ezPortal.t410", locale) + "</span></a> ";
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
			
			if (("edit").equals(mode) && gubunFlag.equals(rootGubunFlag)) {
				resp.getWriter().write(egovMessageSource.getMessage("ezPortal.t287", locale));
				resp.getWriter().flush();
			}
			
			if (resetMyParentPageID != null && (resetMyParentPageID.trim()).equals("") && mode != null && (mode.trim()).equals("edit")) {
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
			String pCreatorId = "";
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
						pCreatorId = xmlDomSubProp.getElementsByTagName("CREATORID").item(0).getTextContent();
						pMoveURL = xmlDomSubProp.getElementsByTagName("URL").item(0).getTextContent();
					}
				} else {
					PortalUrlPortletVO result = ezPortalService.urlPortlet(uID, pUserID);
					String resultXML = commonUtil.getQueryResult(result);
					Document xmlDomSubProp = commonUtil.convertStringToDocument(resultXML);
					
					if (xmlDomSubProp.getElementsByTagName("CREATORID").getLength() > 0) {
						pCreatorId = xmlDomSubProp.getElementsByTagName("CREATORID").item(0).getTextContent();
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
			List<PersonalGetSliderListVO> sliderList = ezPersonalService.getSilderList(userInfo.getCompanyID(), "", "");
			
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
		String langStr = "";
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
			langStr = userInfo.getLang();
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
        String pItemID = "";
        String pDocTitle = "";
        String pDocContent = "";
        boolean pExist = true;
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
			return "";
		}
	}
	
}
