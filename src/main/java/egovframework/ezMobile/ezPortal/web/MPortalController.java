package egovframework.ezMobile.ezPortal.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
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
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezPortal.vo.PortalFirstMainListVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetThemeListVO;
import egovframework.ezEKP.ezPortal.vo.PortalImagePortletVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
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
public class MPortalController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(MPortalController.class);
	
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
	
	/**
	 * 모바일 포탈 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/mobile/ezPortal/portalMain.do")
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalMain Start");
		
		/*userInfo = commonUtil.userInfo(loginCookie);
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
							resp.getWriter().flush();
				}
			}
		}
		
		String strXML = ezPortalService.searchTopMenu("", "Y", 1, 100, "", userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId());
		xmlDom = commonUtil.convertStringToDocument(strXML);

		if (xmlDom.getElementsByTagName("UID_").getLength() > 0) {
			Document xmlDomTop = commonUtil.convertStringToDocument(ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang(),userInfo.getTenantId()));
			logger.debug("xmlDomTop:"+ezPortalService.getUserInfo(userInfo.getId(), userInfo.getLang(),userInfo.getTenantId()));
			
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
		
		logger.debug("pageID:"+pageID);
		//메인메뉴 리스트
		List<PortalMenuItemItemsMenuItemsVO> list = ezPortalAdminService.loadMenuItems("203", pageID, userInfo.getTenantId());
		
		for (Iterator<PortalMenuItemItemsMenuItemsVO> result = list.iterator();result.hasNext();) {
			PortalMenuItemItemsMenuItemsVO value = result.next();
			
			//홈,커뮤니티,SNS,회람판,전자결재 메뉴 안나오도록 처리
			if (value.getDisplayName().equals("커뮤니티") || value.getDisplayName().equals("홈") || value.getDisplayName().equals("SNS") || value.getDisplayName().equals("회람판") || value.getDisplayName().equals("전자결재")) {
				result.remove();
			}
			
			//권한 검색 후 권한이 없는 메뉴에 대해서 삭제
			if (ezPortalService.checkViewRightBln(value.getuID(), ezPortalService.getAccessList(userInfo), userInfo.getTenantId()) == false) {
				result.remove();
			}
		}
		*/
		
	/*	String listStr = "<DATA>";
		
		for (int i=0; i<list.size(); i++) {
			listStr += commonUtil.getQueryResult(list.get(i));
		}
		
		listStr += "</DATA>";
		
		Document gXmlDom = commonUtil.convertStringToDocument(listStr);
		
		String menuList = "";
		for (int i=0; i<list.size(); i++) {
			if (ezPortalService.checkViewRightBln(list.get(i).getuID(), ezPortalService.getAccessList(userInfo), userInfo.getTenantId()) == false) {
				continue;
			}
			menuList += gXmlDom.getElementsByTagName("DISPLAYNAME" + commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent();
		}
		logger.debug("menuList:"+menuList);*/
		
		//model.addAttribute("list", list);
		logger.debug("portalMain End");
		
		
		String mainOption = req.getParameter("mainOption");
		
		if (mainOption == null) {
			mainOption = "M";
		}
		
		if (mainOption.equals("F")) {
			return "/mobile/ezPortal/mPortalFlow";
		} else if (mainOption.equals("S")) {
			return "/mobile/ezPortal/mPortalSlide";
		} else if (mainOption.equals("T")) {
			return "/mobile/ezPortal/mPortalTimeLine";
		} else {
			return "/mobile/ezPortal/mPortalMain";
		}
	}	
}
