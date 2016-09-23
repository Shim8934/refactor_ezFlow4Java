package egovframework.ezEKP.ezPortal.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPortal.dao.EzPortalAdminDAO;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezPortal.vo.PortalGetPortletParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetThemeListVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalPortletGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLBuiltInParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalACLVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageCategoryVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLSkinGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLThemeGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuItemsVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 포탈 관리자
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.09.08    지정석    신규작성
 *
 * @see
 */

@Controller
public class EzPortalAdminController extends EgovFileMngUtil {
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
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name="EzPortaAdminDAO")
	private EzPortalAdminDAO ezPortalAdminDAO;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	/**
	 * 관리자 포탈  메인 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/portalMain.do")
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		if (commonUtil.checkAdmin(loginCookie)) {
			return "/admin/ezPortal/portalMain";
		} else {
			return "";
		}
	}
	
	/**
	 * 관리자 포탈  좌측 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/leftTop.do")
	public String leftTop(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		if (commonUtil.checkAdmin(loginCookie)) {
			return "/admin/ezPortal/portalLeftTop";
		} else {
			return "";
		}
	}
	
	/**
	 * 관리자 포탈  테마리스트 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/themeList.do")
	public String themeList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
	
		if (commonUtil.checkAdmin(loginCookie)) {
			List<PortalGetThemeListVO> list = ezPortalService.getThemeList(userInfo.getCompanyID());
			String result = ezPortalService.ezAclCheck(userInfo.getId(), userInfo.getCompanyID(), userInfo.getCompanyName());
			model.addAttribute("result", result);
			model.addAttribute("list", list);
			return "/admin/ezPortal/portalThemeList";
		} else {
			return "";
		}
	}
	
	/**
	 * 관리자 포탈  테마정보 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/themeInfo.do")
	public String themeInfo(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String mode = "new";
		String strUserLang = commonUtil.getMultiData(userInfo.getLang());
		String pKeyCode = "";
		String themeNm1 = "";
		String themeNm2 = "";
		String themeNm3 = "";
		String themeNm4 = "";
		String themeImage = "";
		String themeTopURL = "";
		String themeMainURL = "";
		String noneActiveX = "YES";
		int themeTopHeight = 0;
		PortalTBLThemeGeneralVO result = new PortalTBLThemeGeneralVO();
		
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		
		if (mode.equals("modify")) {
			if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
				pKeyCode = req.getParameter("uID");
			}
			result = ezPortalService.getThemeInfo(pKeyCode, "3");
			
			themeNm1 = result.getDisplayName();
			themeNm2 = result.getDisplayName2();
			themeNm3 = result.getDisplayName3();
			themeNm4 = result.getDisplayName4();
			themeImage = result.getImageURL();
			themeTopURL = result.getTopURL();
			themeMainURL = result.getMainURL();
			themeTopHeight = result.getTopHeight();
		}
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("pKeyCode", pKeyCode);
		model.addAttribute("themeNm1", themeNm1);
		model.addAttribute("themeNm2", themeNm2);
		model.addAttribute("themeNm3", themeNm3);
		model.addAttribute("themeNm4", themeNm4);
		model.addAttribute("themeImage", themeImage);
		model.addAttribute("themeTopURL", themeTopURL);
		model.addAttribute("themeMainURL", themeMainURL);
		model.addAttribute("themeTopHeight", themeTopHeight);
		model.addAttribute("strUserLang", strUserLang);
		model.addAttribute("result", result);
		model.addAttribute("mode", mode);
		
		return "/admin/ezPortal/portalThemeInfo";
	}
	
	/**
	 * 관리자 포탈  테마삭제 함수 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/deleteThemeInfo.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteThemeInfo(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String pResult = "";
		String pThemeID = xmlDom.getElementsByTagName("THEMEID").item(0).getTextContent();
		
		pResult = ezPortalAdminService.useThemeInfo(pThemeID);
		
		if (pResult != null && pResult.equals("NO")) {
			ezPortalAdminService.deleteTheme(pThemeID); 
		}
		
		return "OK";
	}
	
	/**
	 * 관리자 포탈  테마만들기 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/saveThemeInfo.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String saveThemeinfo(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String pThemeID = UUID.randomUUID().toString();
		if (xmlDom.getElementsByTagName("THEMEID").getLength() != 0 && !xmlDom.getElementsByTagName("MODE").item(0).getTextContent().equals("NEW")) {
			pThemeID = xmlDom.getElementsByTagName("THEMEID").item(0).getTextContent();
		}
		String pImageURL = xmlDom.getElementsByTagName("IMAGEPATH").item(0).getTextContent();
		
		ezPortalAdminService.setThemeInfo(pThemeID, xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent(),xmlDom.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent(), xmlDom.getElementsByTagName("DISPLAYNAME3").item(0).getTextContent(), xmlDom.getElementsByTagName("DISPLAYNAME4").item(0).getTextContent(), pImageURL,xmlDom.getElementsByTagName("TOPURL").item(0).getTextContent(),xmlDom.getElementsByTagName("MAINURL").item(0).getTextContent(), userInfo.getCompanyID(), userInfo.getId(), userInfo.getDisplayName(), Integer.parseInt(xmlDom.getElementsByTagName("TOPHEIGHT").item(0).getTextContent()));
		
		return "OK";
	}
	
	/**
	 * 관리자 포탈  테마만들기 이미지업로드 표출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/portletImageUpload.do")
	public String portletImageUpload(MultipartHttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		int cnt = 1;
		String[] pFileName = new String[cnt];
		String[] fileSize = new String[cnt];
		String[] fileLocation = new String[cnt];
		String[] resultUpload = new String[cnt];
		String[] sGUID = new String[cnt];
		String[] pUploadSN = new String[cnt];
		String realPath = req.getServletContext().getRealPath("");
		String pUniqueName = "";
		
		for (int i=0; i<cnt; i++) {
			resultUpload[i] = "false";
			sGUID[i] = UUID.randomUUID().toString();
			pUploadSN[i] = "{" + sGUID[i] + "}";
		}
		
		String mode = "";
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			//mode = req.getParameter("mode");
			mode = "Theme";
		}
		String pBoardID = mode;
		
		if (req.getFiles("file1") != null) {
			for (int i=0; i<cnt; i++) {
				String fileName = req.getFiles("file1").get(i).getOriginalFilename();
				if (fileName.indexOf(commonUtil.separator.toString()) > 0) {
					fileName = fileName.split(commonUtil.separator.toString())[fileName.split(commonUtil.separator.toString()).length - 1];
				}
				pFileName[i] = fileName;
			}
		}
		for (int i=0; i<cnt; i++) {
			pFileName[i] = pFileName[i].replace("+", "%2b");
			pFileName[i] = pFileName[i].replace(";", "%3b");
		}
		
		String pDirPath = realPath+config.getProperty("upload_portal.ROOT");
		String pServerPath = pDirPath + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + pBoardID;
		
		if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
			pDirPath = pDirPath + commonUtil.separator;
		}
		
		File file = new File(pServerPath);
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		for (int i=0; i<cnt; i++) {
			fileSize[i] = String.valueOf(req.getFiles("file1").get(i).getSize());
			pUniqueName = ezPortalAdminService.getUniqueFileName(pServerPath, pFileName[i]);

			String pAttachPath = pDirPath + userInfo.getCompanyID() + commonUtil.separator + pBoardID + commonUtil.separator + pUniqueName;
			writeUploadedFile(req.getFiles("file1").get(i), pUniqueName, pServerPath);
			
			fileLocation[i] = userInfo.getCompanyID() + commonUtil.separator + pBoardID + commonUtil.separator + pUniqueName;

			File imageFile = new File(pServerPath + commonUtil.separator + pUniqueName);
			
			int nImgWidth = 0;
			int nImgHeight = 0;
			
			if (imageFile.exists()) {
				BufferedImage bi = ImageIO.read(imageFile);	
				
				nImgWidth = bi.getWidth();
				nImgHeight = bi.getHeight();
				int nWidth = 0, nHeight = 0;
				
				if (nImgWidth > nImgHeight) {
                    nWidth = 200;
                    nHeight = (bi.getHeight() * nWidth) / bi.getWidth();
                } else {
                    nHeight = 200;
                    nWidth = (bi.getWidth() * nHeight) / bi.getHeight();
                }
				
				
				if (mode.equals("Theme")) {
					String pSaveName = UUID.randomUUID().toString() + ".jpg";
					BufferedImage bufferedImage = new BufferedImage(170, 140, bi.getType());
					bufferedImage.createGraphics().drawImage(bi, 0, 0, 170, 140, null);

					ImageIO.write(bufferedImage, "jpg", new File(pServerPath + commonUtil.separator + pSaveName));
					//ImageIO.write(bufferedImage, "png", new File(pAttachPath));

					File file1 = new File(pAttachPath);
					if (file1.exists()) {
						FileUtils.deleteQuietly(file1);
					}
					fileLocation[i] = userInfo.getCompanyID() + commonUtil.separator + pBoardID + commonUtil.separator + pSaveName;
				}
				
				resultUpload[i] = "true";
			
			}
		}
		String strXML = "<ROOT><NODES>";
		
		for (int i=0; i < cnt; i++) {
			 strXML += "<NODE><PUPLOADSN><![CDATA[" + pUniqueName + "]]></PUPLOADSN>";
             strXML += "<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>";
             strXML += "<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>";
             strXML += "<FILESIZE>" + fileSize[i] + "</FILESIZE>";
             strXML += "<FILELOCATION><![CDATA[" + fileLocation[i] + "]]></FILELOCATION>";
             strXML += "</NODE>"; 
		}
		strXML += "</NODES></ROOT>";
		
		model.addAttribute("strXML", strXML);
		
		return "/admin/ezPortal/portalPortletImageUpload";
	
	}
	
	/**
	 * 관리자 포탈 상단메뉴영역설정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/topList.do")
	public String topList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
	
		if (commonUtil.checkAdmin(loginCookie)) {
			String strXML = ezPortalService.searchTopMenu("", "", 1, 100, "", userInfo.getCompanyID());
			String result = ezPortalService.ezAclCheck(userInfo.getId(), userInfo.getCompanyID(), userInfo.getCompanyName());
			String returnXML = "";
			
			Document xmlDom = commonUtil.convertStringToDocument(strXML);

			for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) { 
				if(result.equals("1")){//전체관리자 일때만 edit모드로 변환 할수있도록 함 _ 2007-09-18 %>  
				  returnXML += "<tr style=\"cursor:pointer\" onClick=\"setValue('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent()+"', this)\" onDblClick=\"selectItem('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', this)\">"; 
				} else {
				  returnXML += "<tr style=\"cursor:pointer\" onClick=\"setValue('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent()+"', this)\">";
				}
				returnXML += "<td width='60'>"+(i+1)+"</td>";
				returnXML += "<td>"+xmlDom.getElementsByTagName("DISPLAYNAME" + commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent()+"</td>"; 
				returnXML += "<td width='250'>"+xmlDom.getElementsByTagName("THEMENM" + commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent()+"</td>";
				if (xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent().equals("Y")) {
					returnXML += "<td width='150'>"+egovMessageSource.getMessage("ezPortal.t259", locale)+"</td>";
				} else {
					returnXML += "<td width='150'></td>";
				}
				returnXML += "<td width='150'>";
				
				if (xmlDom.getElementsByTagName("LANG").item(i).getTextContent().trim().equals("1")) {
					returnXML += egovMessageSource.getMessage("ezPortal.t403", locale);
				} else if (xmlDom.getElementsByTagName("LANG").item(i).getTextContent().trim().equals("2")) {
					returnXML += egovMessageSource.getMessage("ezPortal.t404", locale);
				} else if (xmlDom.getElementsByTagName("LANG").item(i).getTextContent().trim().equals("3")) {
					returnXML += egovMessageSource.getMessage("ezPortal.t4093", locale);
				} else if (xmlDom.getElementsByTagName("LANG").item(i).getTextContent().trim().equals("4")) {
					returnXML += egovMessageSource.getMessage("ezPortal.t4094", locale);
				}
				
				returnXML += "</td></tr>";
				
			  } 
			    
			model.addAttribute("result", result);
			model.addAttribute("returnXML", returnXML);
			return "/admin/ezPortal/portalTopList";
		} else {
			return "";
		}
	}
	
	/**
	 * 관리자 포탈 상단메뉴 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/deleteTopPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteTopPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		ezPortalAdminService.deleteTopPage(uID);
		
		return "OK";
	}
	
	/**
	 * 관리자 포탈 상단메뉴영역설정 선택페이지 사용 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/useTopPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String useTopPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		ezPortalAdminService.topSetUsePage2(uID, userInfo.getCompanyID());
		
		return "OK";
	}
	
	/**
	 * 관리자 포탈 상단메뉴영역설정 선택페이지 사용 취소 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/outOfUseTopMenu.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String outOfSetUsePage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		ezPortalAdminService.topOutOfSetUsePage(uID, userInfo.getCompanyID());
		
		return "OK";
	}
	
	/**
	 * 관리자 포탈 상단메뉴영역설정 선택페이지 언어 설정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/setLang.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String setLang(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		String lang = "";
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		if (req.getParameter("lang") != null && !req.getParameter("lang").equals("")) {
			lang = req.getParameter("lang");
		}
		
		ezPortalAdminService.setUseLang(uID, userInfo.getCompanyID(), lang);
		
		return "OK";
	}
	
	/**
	 * 관리자 포탈 상단메뉴영역설정 전체메뉴레이아웃 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/portalSaveSkin.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String portalSaveSkin(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pageID = "";
		
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
			pageID = req.getParameter("pageID");
		}
		
		String skinName = "";
		String skinBgFlag = "";
		String skinBgColor = "";
		String skinBgImage = "";
		String skinFontColor = "";
		String skinFontOverColor = "";
		
		List<PortalTBLSkinGeneralVO> list = ezPortalAdminService.selectSkinGeneral(); 
		
		for (int i=0; i<list.size(); i++) {
			if (list.get(i).getSkinBgFlag() != null && !list.get(i).getSkinBgFlag().equals("")) {
				skinName = list.get(0).getSkinName();
				skinBgFlag = list.get(0).getSkinBgFlag();
				skinBgColor = list.get(0).getSkinBgColor();
				skinBgImage = list.get(0).getSkinBgImage();
				skinFontColor = list.get(0).getSkinFontColor();
				skinFontOverColor = list.get(0).getSkinFontOverColor();
			}
			
			ezPortalAdminService.portalSaveSkin(pageID, skinName, skinBgFlag, skinBgColor, skinBgImage, skinFontColor, skinFontOverColor);
			
		}
		
		return "OK";
	}
	
	/**
	 * 관리자 포탈 상단메뉴영역설정 전체메뉴레이아웃 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/portalSaveTopMenu.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String portalSaveTopMenu(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pageID = "";
		String parentPageID = "";

		if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
			pageID = req.getParameter("pageID");
		}
		
		if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").equals("")) {
			parentPageID = req.getParameter("parentPageID");
		}
		
		String ret = ezPortalAdminService.saveTopMenu(pageID, parentPageID, userInfo.getId(), userInfo.getDisplayName(), xmlStr, userInfo.getCompanyID());
		
		return ret;
	}
	
	/**
	 * 관리자 포탈  포탈페이지관리 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/portalPageList.do")
	public String portalPageList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String pSearchString = "";
		String portalGubun = "";
		int recordCnt = 0;
		int intPage = 1;
		int totalPage = 1;
		String portalPageCategoryXML = "";
		String defaultPageUID = "";
		
		if (commonUtil.checkAdmin(loginCookie)) {
			if (req.getParameter("pSearchString") != null && !req.getParameter("pSearchString").equals("")) {
				pSearchString = req.getParameter("pSearchString");
			}
			if (req.getParameter("portalGubun") != null && !req.getParameter("portalGubun").equals("")) {
				portalGubun = req.getParameter("portalGubun");
			}
			if (req.getParameter("intPage") != null && !req.getParameter("intPage").equals("")) {
				if (Integer.parseInt(req.getParameter("intPage")) > 0) {
					intPage = Integer.parseInt(req.getParameter("intPage"));
				}
			}
			
			int listPageSize = 15; // 목록갯수
			
			List<PortalTBLPortalPageCategoryVO> list = ezPortalService.getPortalPageCategory();
			
			// 전체선택시 Root페이지만 보여지도록 설정
			if (portalGubun == null || portalGubun.equals("")) {
				for (int i=0; i<list.size(); i++) {
					if (portalGubun == null || portalGubun.equals("")) {
						portalGubun = "'" + list.get(i).getCategory() + "'";
					} else {
						portalGubun += ",'" + list.get(i).getCategory() + "'";
					}
				}
			}
			
			recordCnt = ezPortalService.searchMyPortalPageCount(pSearchString, portalGubun, userInfo.getCompanyID());
			totalPage = (recordCnt - 1) / listPageSize + 1; // 총 페이지수
			
			int pStartRow = 0;
			int pEndRow = 0;
			pStartRow = intPage * listPageSize - listPageSize + 1;
			pEndRow = intPage * listPageSize;
			
			String strXML = ezPortalAdminService.searchPortalPage(pSearchString, "", portalGubun, pStartRow, pEndRow, "", userInfo.getCompanyID());
			Document xmlDom = commonUtil.convertStringToDocument(strXML);
System.out.println("strXML:"+strXML);
			for (int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
				if (xmlDom.getElementsByTagName("DEFAULTPAGE").item(i).getTextContent().trim().equals("Y")) {
					defaultPageUID = xmlDom.getElementsByTagName("UID").item(i).getTextContent();
					break;
				}
			}

			String mainHtml = "";
			for (int i=0; i<xmlDom.getElementsByTagName("UID").getLength(); i++) {
				mainHtml += "<tr style=\"cursor:pointer\" onClick=\"setValue('"+xmlDom.getElementsByTagName("UID").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("GUBUNFLAG").item(i).getTextContent()+"', '"+xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent()+"', this)\" ondblclick=\"selectItem('"+xmlDom.getElementsByTagName("UID").item(i).getTextContent()+"', this)\">";
				mainHtml += "<td width=\"120\" style=\"display:none\">";
					if (xmlDom.getElementsByTagName("GUBUNFLAG").item(i).getTextContent().indexOf("c") < 0) {
						mainHtml += xmlDom.getElementsByTagName("GUBUNNAME").item(i).getTextContent() + "Root";
					} else {
						mainHtml += xmlDom.getElementsByTagName("GUBUNNAME").item(i).getTextContent();
					}
				mainHtml += "</td>";
				mainHtml += "<td>" + xmlDom.getElementsByTagName("DISPLAYNAME" + commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent() +"</td>"; 
	            mainHtml += "<td width='100'>"; 
	            
	            if (xmlDom.getElementsByTagName("DEFAULTPAGE").item(i).getTextContent() == null || xmlDom.getElementsByTagName("DEFAULTPAGE").item(i).getTextContent().equals("")) {
	            	mainHtml += "";
	            } else {
	            	if (xmlDom.getElementsByTagName("DEFAULTPAGE").getLength() != 0 && xmlDom.getElementsByTagName("DEFAULTPAGE").item(i).getTextContent().trim().equals("Y")) {
	            		mainHtml += egovMessageSource.getMessage("ezPortal.t259", locale);	
	            	} else {
	            		mainHtml += "";
	            	}
	            }
	            
	            mainHtml += "</td>";
	            mainHtml += "<td width='150'>"+xmlDom.getElementsByTagName("THEMENM" + commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent()+"</td>"; 
				mainHtml += "<td width='130'>";
				if (xmlDom.getElementsByTagName("USEFLAG").item(i).getTextContent().trim().equals("Y")) {
					mainHtml += egovMessageSource.getMessage("ezPortal.t259", locale);
				}
				mainHtml += "</td>";
				
				mainHtml += "<td width='170'>"+xmlDom.getElementsByTagName("CREATEDATE").item(i).getTextContent()+"</td>";
				
				mainHtml += "</tr>";
			}

			model.addAttribute("intPage", intPage);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("pSearchString", pSearchString);
			model.addAttribute("portalGubun", portalGubun);
			model.addAttribute("pSearchString", pSearchString);
			model.addAttribute("defaultPageUID", defaultPageUID);
			model.addAttribute("mainHtml", mainHtml);
			return "/admin/ezPortal/portalPageList";
		} else {
			return "";
		}
	}
	
	/**
	 * 관리자 포탈 포탈페이지관리 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/deletePortalPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deletePortalPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		String uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
		
		String ret = ezPortalAdminService.deletePortalPage(uID);
		
		return ret;
	}
	
	/**
	 * 관리자 포탈 포탈페이지관리 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/portalSavePortalPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String portalSavePortalPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String callPageID = "";
		String pageID = "";
		String parentPageID = "";
		String type = "";
		
		if (req.getParameter("callingPageID") != null && !req.getParameter("callingPageID").equals("")) {
			callPageID = req.getParameter("callingPageID");
		}
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
			pageID = req.getParameter("pageID");
		}
		if (req.getParameter("parentPageID") != null && !req.getParameter("parentPageID").equals("")) {
			parentPageID = req.getParameter("parentPageID");
		}
		if (req.getParameter("type") != null && !req.getParameter("type").equals("")) {
			type = req.getParameter("type");
		}
		
		String ret = ezPortalAdminService.savePortalPage(callPageID, pageID, parentPageID, xmlStr, userInfo.getCompanyID(), type);
		return ret;
	}
	
	/**
	 * 관리자 포탈 포탈페이지관리 선택페이지사용 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/usePortalPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String usePortalPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		String gubunFlag = "";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		if (req.getParameter("gubunFlag") != null && !req.getParameter("gubunFlag").equals("")) {
			gubunFlag = req.getParameter("gubunFlag");
		}
		
		String result = ezPortalAdminService.setUsePage(uID, gubunFlag, userInfo.getCompanyID());
		
		return result;
	}
	
	/**
	 * 관리자 포탈 포탈페이지관리 선택페이지사용 취소 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/outOfUsePortalPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String outOfUsePortalPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String uID = "";
		String gubunFlag = "";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		if (req.getParameter("gubunFlag") != null && !req.getParameter("gubunFlag").equals("")) {
			gubunFlag = req.getParameter("gubunFlag");
		}
		
		String result = ezPortalAdminService.outOfSetUsePage(uID, gubunFlag, userInfo.getCompanyID());
		
		return result;
	}
	
	/**
	 * 관리자 포탈 포탈페이지관리 기본페이지 설정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/setDefaultPortalPage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String setDefaultPortalPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		String pUID = xmlDom.getElementsByTagName("PAGEUID").item(0).getTextContent();
		String pGubunFlag = xmlDom.getElementsByTagName("GUBUNFLAG").item(0).getTextContent();
		String pFlag = xmlDom.getElementsByTagName("FLAG").item(0).getTextContent();
		
		ezPortalAdminService.setDefaultPage(pUID, pFlag, pGubunFlag, userInfo.getCompanyID());
		
		return "OK";
	}
	
	/**
	 * 관리자 포탈 포탈페이지관리 권한설정 권한 설정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/addRight.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addRight(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String ret = ezPortalAdminService.insertAclItem(xmlStr);
		return ret;
	}
	
	/**
	 * 관리자 포탈 포탈페이지관리 권한설정 권한 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/removeACL.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String removeACL(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String ret = ezPortalAdminService.deleteAclItem(xmlStr);
		return ret;
	}
	
	
	/**
	 * 관리자 포탈 포탈페이지관리 권한 선택 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/selectTarget.do")
	public String selectTarget(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String topID = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("defaultwin", "To");
		model.addAttribute("strXML", "");
		model.addAttribute("topID", topID);
		model.addAttribute("useOCS", "");
		model.addAttribute("pSearchString", "");
		return "/admin/ezPortal/portalSelectTarget";
		
	}
	
	/**
	 * 관리자 포탈 포틀릿관리 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/portletList.do")
	public String portletList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String portalPageGubun = "";
		String pSearchString = "";
		String portalGubun = "";
		int recordCnt = 0;
		int intPage = 1;
		int totalPage = 1;
		String portalPageCategoryXML = "";
		String portletCategoryXML = "";
		String noneActiveX = "YES";
		
		if (commonUtil.checkAdmin(loginCookie)) {
			if (req.getParameter("portalPageGubun") != null && !req.getParameter("portalPageGubun").equals("")) {
				portalPageGubun = req.getParameter("portalPageGubun");
			}
			if (req.getParameter("portalGubun") != null && !req.getParameter("portalGubun").equals("")) {
				portalGubun = req.getParameter("portalGubun");
			}
			if (req.getParameter("pSearchString") != null && !req.getParameter("pSearchString").equals("")) {
				pSearchString = req.getParameter("pSearchString");
			}
			
			if (req.getParameter("intPage") != null && !req.getParameter("intPage").equals("")) {
				if (Integer.parseInt(req.getParameter("intPage")) > 0) {
					intPage = Integer.parseInt(req.getParameter("intPage")); 
				}
			}
			
			int listPageSize = 15;
			
			List<PortalTBLPortalPageCategoryVO> portalPagelist = ezPortalService.getPortalPageCategory();
			portalPageCategoryXML = "<DATA>";
			for (int i=0; i<portalPagelist.size(); i++) {
				portalPageCategoryXML += commonUtil.getQueryResult(portalPagelist.get(i));
			}
			portalPageCategoryXML += "</DATA>";
			portalPageCategoryXML.replace("\"", "\\\"");
			
			List<PortalTBLPortalPageCategoryVO> portletPagelist = ezPortalAdminService.getPortletCategory();
			portletCategoryXML = "<DATA>";
			for (int i=0; i<portletPagelist.size(); i++) {
				portletCategoryXML += commonUtil.getQueryResult(portletPagelist.get(i));
			}
			portletCategoryXML += "</DATA>";
			portletCategoryXML.replace("\"", "\\\"");
			
			recordCnt = ezPortalAdminService.searchPortletCount(pSearchString, portalGubun, portalPageGubun, userInfo.getCompanyID());
			totalPage = (recordCnt - 1) / listPageSize + 1;
			
			int pStartRow = 0;
			int pEndRow = 0;
			pStartRow = intPage * listPageSize - listPageSize + 1;
			pEndRow = intPage * listPageSize;
			
			String strXML = ezPortalAdminService.searchPortlet(pSearchString, portalGubun, portalPageGubun, pStartRow, pEndRow, "", userInfo.getCompanyID());
			Document xmlDom = commonUtil.convertStringToDocument(strXML);
			String strHtml = "";

			for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
				strHtml += "<tr style=\"cursor:pointer\" onClick=\"setValue('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', this)\" onDblClick=\"selectItem('"+xmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', this)\">";
				strHtml += "<td width='300'>"+xmlDom.getElementsByTagName("DISPLAYNAME" + commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent()+"</td>";
				strHtml += "<td>"+egovMessageSource.getMessage("ezPortal."+xmlDom.getElementsByTagName("TYPE").item(i).getTextContent(), locale) +"</td>";
				strHtml += "</tr>";
			}
			
			model.addAttribute("userInfo", userInfo);
			model.addAttribute("intPage", intPage);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("strHtml", strHtml);
			model.addAttribute("portletCategoryXML", portletCategoryXML);
			model.addAttribute("portalPageCategoryXML", portalPageCategoryXML);
			model.addAttribute("noneActiveX", noneActiveX);
			
			return "/admin/ezPortal/portalPortletList";
		} else {
			return "";
		}
		
	}
	
	/**
	 * 관리자 포탈 포틀릿관리 상세보기 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/portletEdit.do")
	public String portletEdit(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary = config.getProperty("config.lang_Primary"+userInfo.getLang());
		String langSecondary = config.getProperty("config.lang_Secondary"+userInfo.getLang());
		String uID = "";
		String menuIndex = "1";
		String mode = "edit";
		String pDocPath = "";
		String pOpenMode = "";
        String pWindowOption = "";
        String pImageType = "";
        String pImagePath = "";
        String pImageWidth = "";
        String pImageHeight = "";
        String pCreatorID = "";
        String pUsertype = "";
        String pBoardID = "";
        String pBoardName = "";
        String pItemCount = "";
        String pItemFields = "";
        String pMoveURL = "";
        String portletCategoryXML = "";
        String portalPageCategoryXML = "";
        String portletFrameType = "";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		if (req.getParameter("menuIndex") != null && !req.getParameter("menuIndex").equals("")) {
			menuIndex = req.getParameter("menuIndex");
		}
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		
		List<PortalTBLPortalPageCategoryVO> portletPagelist = ezPortalAdminService.getPortletCategory();
		portletCategoryXML = "<DATA>";
		for (int i=0; i<portletPagelist.size(); i++) {
			portletCategoryXML += commonUtil.getQueryResult(portletPagelist.get(i));
		}
		portletCategoryXML += "</DATA>";
		portletCategoryXML.replace("\"", "\\\"");
		
		portletCategoryXML.replace("포틀릿", "portlet").replace("이미지", "Image").replace("게시판", "Board");
		
		if (mode.equals("new")) {
			uID = ezPortalAdminService.createNewPortlet(userInfo.getCompanyID());
			
			if (uID == null || uID.equals("")) {
				resp.getWriter().write(egovMessageSource.getMessage("ezPortal.t175", locale));
				resp.getWriter().flush();
			}
		}
		
		PortalPortletGeneralVO prop = ezPortalAdminDAO.getPortletProperties(uID);
		List<PortalGetPortletParametersVO> param = ezPortalService.getPortletParametres(uID);
		
		if (prop.getFrameType() !=null && prop.getFrameType().equals("")) {
			portletFrameType = prop.getFrameType().trim();
		} else {
			portletFrameType = prop.getFrameType();
		}
		
		String portletType = String.valueOf(prop.getPortletType());
		String subData = ezPortalService.getPortletSubProperties(uID, portletType);

		Document subProp = commonUtil.convertStringToDocument(subData);
		
		List<PortalTBLBuiltInParametersVO> paramType = ezPortalAdminService.menuItemEdit();
		
		List<PortalTBLPortalACLVO> aclList = ezPortalService.getAclItems(uID);
		
		//포탈페이지 카테고리 정보를 가져온다.
		List<PortalTBLPortalPageCategoryVO> portalPagelist = ezPortalService.getPortalPageCategory();
		portalPageCategoryXML = "<DATA>";
		for (int i=0; i<portalPagelist.size(); i++) {
			portalPageCategoryXML += commonUtil.getQueryResult(portalPagelist.get(i));
		}
		portalPageCategoryXML += "</DATA>";
		portalPageCategoryXML.replace("\"", "\\\"");
		
		//URL포틀릿
		if (portletType.equals("1")) {
			// 1: 관리자지정, 2: 사용자지정
			
			if (pUsertype == null || pUsertype.equals("")) {
				pUsertype = "1";
			} else {
				pUsertype = prop.getUserType().trim();
			}
			
			if (subData != null && !subData.equals("<DATA></DATA>")) {
				pCreatorID = subProp.getElementsByTagName("CREATORID").item(0).getTextContent();
				pMoveURL = subProp.getElementsByTagName("URL").item(0).getTextContent();
			}
		} else if (portletType.equals("2")) {
			//HTML 포틀릿
			pDocPath = subProp.getElementsByTagName("HTMLDATA").item(0).getTextContent();
			
		} else if (portletType.equals("3")) {
			//이미지 포틀릿
			pImagePath = subProp.getElementsByTagName("IMAGEPATH").item(0).getTextContent();
			pImageWidth = subProp.getElementsByTagName("IMAGEWIDTH").item(0).getTextContent();
			pImageHeight = subProp.getElementsByTagName("IMAGEHEIGHT").item(0).getTextContent();
			pOpenMode = subProp.getElementsByTagName("OPENMODE").item(0).getTextContent();
			pWindowOption = subProp.getElementsByTagName("WINDOWOPTION").item(0).getTextContent();
			pImageType = subProp.getElementsByTagName("IMAGETYPE").item(0).getTextContent();
		} else if (portletType.equals("4")) {
			//게시판 포틀릿
			pUsertype = prop.getUserType().trim();
			if (pUsertype.equals("1")) {
				pCreatorID = subProp.getElementsByTagName("CREATORID").item(0).getTextContent();
				pBoardID = subProp.getElementsByTagName("BOARDID").item(0).getTextContent();
				pItemCount = subProp.getElementsByTagName("ITEMCOUNT").item(0).getTextContent();
				pItemFields = subProp.getElementsByTagName("ITEMFIELDS").item(0).getTextContent();
				pBoardName = ezBoardService.portalPageItemEdit(pBoardID);
			}
			
		}
		
		String paramHtml = "";
		for (int i=0; i<param.size(); i++) {
			if (param.get(i).getParamType() == 0) {
				paramHtml += "<tr>";
				paramHtml += "<td>"+param.get(i).getParamName()+"</td>";
    			paramHtml += "<td>"+param.get(i).getParamValue()+"</td>";
    			paramHtml += "<td width='39' align='center'><a class='imgbtn'><span onClick=\"RemoveParameter('"+param.get(i).getParamName()+"')\" >"+egovMessageSource.getMessage("ezPortal.t67", locale)+"</span></a></td>"; 
  			    paramHtml += "</tr>";
			} else {
				paramHtml += "<tr>";
				paramHtml += "<td>"+param.get(i).getParamName()+"</td>";
    			paramHtml += "<td>"+param.get(i).getDescription()+"</td>";
    			paramHtml += "<td width='39' align='center'><a class='imgbtn'><span onClick=\"RemoveParameter('"+param.get(i).getParamName()+"')\" >"+egovMessageSource.getMessage("ezPortal.t67", locale)+"</span></a></td>"; 
  			    paramHtml += "</tr>";
			}
		}
		
		model.addAttribute("uID", uID);
		model.addAttribute("pBoardID", pBoardID);
		model.addAttribute("pBoardName", pBoardName);
		model.addAttribute("pItemCount", pItemCount);
		model.addAttribute("pMoveURL", pMoveURL);
		model.addAttribute("prop", prop);
		model.addAttribute("menuIndex", menuIndex);
		model.addAttribute("pDocPath", pDocPath);
		model.addAttribute("pImageType", pImageType);
		model.addAttribute("pImagePath", pImagePath);
		model.addAttribute("pImageWidth", pImageWidth);
		model.addAttribute("pImageHeight", pImageHeight);
		model.addAttribute("pCreatorID", pCreatorID);
		model.addAttribute("pUserType", pUsertype);
		model.addAttribute("pItemFields", pItemFields);
		model.addAttribute("portletCategoryXML", portletCategoryXML);
		model.addAttribute("portalPageCategoryXML", portalPageCategoryXML);
		model.addAttribute("portletFrameType", portletFrameType);
		model.addAttribute("pOpenMode", pOpenMode);
		model.addAttribute("pWindowOption", pWindowOption);
		model.addAttribute("paramType", paramType);
		model.addAttribute("param", param);
		model.addAttribute("aclList", aclList);
		model.addAttribute("paramHtml", paramHtml);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("mode", mode);
		
		return "/admin/ezPortal/portalPortletEdit";
		
	}
	
	/**
	 * 관리자 포탈 포틀릿관리 포틀릿설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/savePortletProperty.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String savePortletProperty(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		String ret = ezPortalAdminService.savePortletProperties(xmlStr);
		return ret;
	}
	
	/**
	 * 관리자 포탈 포틀릿관리 포틀릿설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/savePortletSubProperty.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String savePortletSubProperty(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String portletType = "";
		
		if (req.getParameter("portletType") != null && !req.getParameter("portletType").equals("")) {
			portletType = req.getParameter("portletType");
		}
		
		String uID= "";
		String displayName = "";
		String pContent = "";
		String mhtFilePath = "";
		String result = "";
		String imagePath = "";
		String imageWidth = "";
		String imageHeight = "";
		String imageType = "";
		String openMode = "";
		String windowOption = "";
		String userType = "";
		String boardID = "";
		String itemCount = "";
		String itemFields = "";
		String oldCreatorID = "";
		String oldUserType = "";
		String oldBoardID = "";
		String moveUrl = "";
		boolean bResult = false;
		
		//URL포틀릿
		if (portletType.equals("1")) {
			uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
			oldCreatorID = xmlDom.getElementsByTagName("OLDCREATORID").item(0).getTextContent();
			oldUserType = xmlDom.getElementsByTagName("OLDUSERTYPE").item(0).getTextContent();
			userType = xmlDom.getElementsByTagName("USERTYPE").item(0).getTextContent();
			moveUrl = xmlDom.getElementsByTagName("MOVEURL").item(0).getTextContent();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_OLDUSERTYPE", oldUserType);
			map.put("v_UID", uID);
			map.put("v_CREATORID", oldCreatorID);
			map.put("v_USERTYPE", userType);
			map.put("v_USERID", userInfo.getId());
			map.put("v_URL", moveUrl);
			ezPortalAdminService.savePortletSubProperty(map);
		} else if (portletType.equals("2")) {
			// html 포틀릿
			uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
			displayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
			pContent = xmlDom.getElementsByTagName("CONTENT").item(0).getTextContent();
			mhtFilePath = "/files/upload_portal/mht" + uID + ".mht";
			bResult = saveMHT(pContent, uID, config.getProperty("upload_portal.ROOT") + commonUtil.separator);
			
			if (bResult == true) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_UID", uID);
				map.put("v_DISPLAYNAME", displayName);
				map.put("v_HTMLDATA", mhtFilePath);
				ezPortalAdminDAO.savePortletSubProperty2(map);
			}
		} else if (portletType.equals("3")) {
			//이미지 포틀릿
			uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
			imagePath = xmlDom.getElementsByTagName("IMAGEPATH").item(0).getTextContent();
			imageWidth = xmlDom.getElementsByTagName("IMAGEWIDTH").item(0).getTextContent();
			imageHeight = xmlDom.getElementsByTagName("IMAGEHEIGHT").item(0).getTextContent();
			imageType = xmlDom.getElementsByTagName("IMAGETYPE").item(0).getTextContent();
			openMode = xmlDom.getElementsByTagName("OPENMODE").item(0).getTextContent();
			windowOption = xmlDom.getElementsByTagName("WINDOWOPTION").item(0).getTextContent();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_UID", uID);
			map.put("v_IMAGEPATH", imagePath);
			map.put("v_IMAGEWIDTH", Integer.parseInt(imageWidth));
			map.put("v_IMAGEHEIGHT", Integer.parseInt(imageHeight));
			map.put("v_IMAGETYPE", imageType);
			map.put("v_OPENMODE", openMode);
			map.put("v_WINDOWSOPTION", windowOption);
			ezPortalAdminDAO.savePortletSubProperty3(map);
		} else if (portletType.equals("4")) {
			//게시판 포틀릿
			uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
			userType = xmlDom.getElementsByTagName("USERTYPE").item(0).getTextContent();
			boardID = xmlDom.getElementsByTagName("BOARDID").item(0).getTextContent();
			itemCount = xmlDom.getElementsByTagName("ITEMCOUNT").item(0).getTextContent();
			itemFields = xmlDom.getElementsByTagName("ITEMFIELDS").item(0).getTextContent();
			oldCreatorID = xmlDom.getElementsByTagName("OLDCREATORID").item(0).getTextContent();
			oldUserType = xmlDom.getElementsByTagName("OLDUSERTYPE").item(0).getTextContent();
			oldBoardID = xmlDom.getElementsByTagName("OLDBOARDID").item(0).getTextContent();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_OLDUSERTYPE", oldUserType);
			map.put("v_UID", uID);
			map.put("v_CREATORID", oldCreatorID);
			map.put("v_BOARDID", boardID);
			map.put("v_USERTYPE", userType);
			map.put("v_USERID", userInfo.getId());
			map.put("v_ITEMCOUNT", itemCount);
			map.put("v_ITEMFIELDS", itemFields);
			ezPortalAdminDAO.savePortletSubProperty4(map);
		}
		return "OK";
	}
	
	public boolean saveMHT (String strHTML, String strMHTFileName, String strFilePath) {
		String docPath = "";
		String mhtFilePath = "";
		try {
			docPath = strFilePath + "\\Mht";
			
			if (!new File(docPath).exists()) {
				File dir = new File(docPath);
				dir.mkdirs();
			}
			
			mhtFilePath = docPath + commonUtil.separator + strMHTFileName + ".mht";
			
			if (new File(mhtFilePath).exists()) {
				new File(mhtFilePath).delete();
			}
			
			PrintWriter pw = new PrintWriter(new File(mhtFilePath));
			pw.print(strHTML);
			pw.flush();
			pw.close();
			
			return true;
		} catch (Exception e) {
			return false;
		}
		
	}
	
	/**
	 * 관리자 포탈 포틀릿관리 파라미터제거 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/removeParameter.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	
	public void removeParameter(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		String uID = "";
		String paramName = "";
		String mode = "";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		if (req.getParameter("paramName") != null && !req.getParameter("paramName").equals("")) {
			paramName = req.getParameter("paramName");
		}
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		
		if (mode == null || mode.equals("")) {
			mode = "0";
		}
		
		ezPortalAdminService.removeParameter(Integer.parseInt(mode), uID, paramName);
		
	}
	
	/**
	 * 관리자 포탈 포틀릿관리 파라미터 추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/addParameter.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addParameter(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		String mode = "";
		String ret = "";
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		
		if (mode.equals("1")) {
			ret = ezPortalAdminService.savePortletParameters(xmlStr);
		} else {
			ret = ezPortalAdminService.saveMenuItemParameters(xmlStr);
		}
		
		return ret;
	}
	
	/**
	 * 관리자 포탈 포틀릿관리 CKEditor 내용 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/portletEditCKContent.do")
	public String portletEditCKContent(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String pMode= "";
		
		if (req.getParameter("draftFlag") != null && !req.getParameter("drfatFlag").equals("")) {
			pMode = req.getParameter("drfatFlag");
		}
		
		model.addAttribute("pMode", pMode);
		return "/admin/ezPortal/portalPortletCKContent";
		
		
	}
	
	/**
	 * 관리자 포탈 포틀릿관리 포틀릿 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/deletePortlet.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deletePortlet(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		String uID = "";
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		String ret = ezPortalAdminService.deletePortlet(uID);
		
		return ret;
	}
	
	/**
	 * 관리자 포탈 포틀릿관리 포틀릿 미리보기 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/portletPreview.do")
	public String portletPreview(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String strHTML= "";
		String height= "";
		String portletWidth= "";
		String portletHeight= "";
		String uID = "";
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		
		PortalPortletGeneralVO prop = ezPortalAdminDAO.getPortletProperties(uID);
		
		String displayName = prop.getDisplayName();
		String url = prop.getUrl();
		
		String showTitleBar = prop.getShowTitleBar();
		height = String.valueOf(prop.getHeight());
		portletWidth = String.valueOf(prop.getWidth());
		portletHeight = String.valueOf(prop.getHeight());

		StringBuilder sb = new StringBuilder();
		 sb.append("<table id='main_table' border=0 cellpadding=0 cellspacing=0 width=100% style='table-layout:fixed;'>");

         if (showTitleBar.trim().equals("1")) {
             sb.append("<TR>\n");
             sb.append("<TD class='portlet' align=left><img src='/css/ezPortal/portlet_bar.gif' width=3 height=15 border=0 align=absmiddle> <span class='portletfont'>" + displayName + "</span></TD>\n");
             sb.append("</TR>\n");
         }
         sb.append("<TR style='WIDTH:100%; HEIGHT:" + height + "px'>\n");
         sb.append("<TD style='WIDTH:100%' align=middle valign=top><iframe width=100% height=" + height + " border=0 src='" + url + ezPortalService.loadGetParameters(url, uID, userInfo) + "' frameborder=0 scrolling=no></iframe></TD>\n");
         sb.append("</TR>\n");
         sb.append("</table>\n");

         strHTML = sb.toString();
		
		model.addAttribute("strHTML", strHTML);
		model.addAttribute("portletWidth", portletWidth);
		model.addAttribute("portletHeight", portletHeight);
		
		return "/admin/ezPortal/portalPortletPreview";
		
	}
	
	/**
	 * 관리자 포탈 포틀릿관리 포틀릿 미리보기 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/logoList.do")
	public String logoList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String pageID = "";
		String layoutList = "";
		String logoAreaExist = "NO";  // layout에 로고영역이 존재하는지 여부
		
		if (commonUtil.checkAdmin(loginCookie)) {
			String strXML = ezPortalService.searchTopMenu("", "", 1, 100, "", userInfo.getCompanyID());
			Document xmlDom = commonUtil.convertStringToDocument(strXML);
			if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
				pageID = req.getParameter("pageID");
			}
			
			if (pageID == null || pageID.equals("")) {
				for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
					pageID = xmlDom.getElementsByTagName("UID_").item(i).getTextContent();
					break;
				}
			}
			
			String pSelected = "";
			StringBuilder sb = new StringBuilder();
			for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
				if (xmlDom.getElementsByTagName("UID_").item(i).getTextContent().equals(pageID)) {
					pSelected = "selected";
				} else {
					pSelected = "";
				}
				sb.append("<option value='" + xmlDom.getElementsByTagName("UID_").item(i).getTextContent() + "' " + pSelected + ">" + xmlDom.getElementsByTagName("DISPLAYNAME" + commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent().trim() + "</option>");
			}
			layoutList = sb.toString();
			
			String gXmlStr = ezPortalAdminService.loadLogoItems(pageID);
			Document gXmlDom = commonUtil.convertStringToDocument(gXmlStr);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pPUID", "201");
			map.put("v_pPAGEID", pageID);
			PortalTBLTopMenuItemsVO result = ezPortalAdminService.loadPositionSettings(map);
			String xmlStr = commonUtil.getQueryResult(result);
			Document xmlDom1 = commonUtil.convertStringToDocument(xmlStr);
			
			if (xmlDom1.getElementsByTagName("ALIGN").getLength() > 0) {
				logoAreaExist = "YES";
			}
			
			String mainHTML = "";
			for (int i=0; i<gXmlDom.getElementsByTagName("UID_").getLength(); i++) {
				mainHTML += "<tr style='cursor:pointer' imageurl='"+gXmlDom.getElementsByTagName("NORMALIMAGEPATH").item(i).getTextContent()+"' onclick=\"setValue('"+gXmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', this)\" ondblclick=\"selectItem('"+gXmlDom.getElementsByTagName("UID_").item(i).getTextContent()+"', this)\">";
				mainHTML += "<td width='60'>"+String.valueOf(i+1)+"</td>";
				mainHTML += "<td>"+gXmlDom.getElementsByTagName("DISPLAYNAME" + commonUtil.getLangData(userInfo.getPrimary())).item(i).getTextContent()+"</td>";
				mainHTML += "</tr>";
			}
			
			model.addAttribute("logoAreaExist", logoAreaExist);
			model.addAttribute("mainHTML", mainHTML);
			model.addAttribute("pageID", pageID);
			model.addAttribute("layoutList", layoutList);
			return "/admin/ezPortal/portalLogoList";
		} else {
			return "";
		}
		
	}
	
	/**
	 * 관리자 포탈 로고설정 상세보기 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/logoEdit.do")
	public String logoEdit(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String langPrimary = config.getProperty("config.lang_Primary"+userInfo.getLang());
		String langSecondary = config.getProperty("config.lang_Secondary"+userInfo.getLang());
		String uID = "";
		String menuIndex = "1";
		String mode = "edit";
        String windowOption = "";
        String imagePath = "";
        String imageWidth = "";
        String imageHeight = "";
        String displayName = "";
        String displayName2 = "";
        String linkURL = "";
        String linkLocation = "";
        String parentUID = "";
		String pageID = "";
        
		
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		if (req.getParameter("menuIndex") != null && !req.getParameter("menuIndex").equals("")) {
			menuIndex = req.getParameter("menuIndex");
		}
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
			pageID = req.getParameter("pageID");
		}
		
		
		if (mode.equals("new")) {
			if (req.getParameter("parentUID") != null && !req.getParameter("parentUID").equals("")) {
				parentUID = req.getParameter("parentUID");
			}
			uID = ezPortalAdminService.createNewLogoItem(parentUID, pageID);
		}

		PortalMenuItemItemsImageVO result = ezPortalAdminService.logoEdit(uID, pageID);
		
		if (result != null) {
			displayName = result.getDisplayName();
			displayName2 = result.getDisplayName2();
			imagePath = result.getNormalImagePath();
			linkURL = result.getLinkURL();
			linkLocation = result.getLinkLocation();
			windowOption = result.getWindowOption();
			imageWidth = String.valueOf(result.getImageWidth());
			imageHeight = String.valueOf(result.getImageHeight());
		}
		
		List<PortalTBLPortalACLVO> aclList = ezPortalService.getAclItems(uID);
		
		model.addAttribute("uID", uID);
		model.addAttribute("pageID", pageID);
		model.addAttribute("parentUID", parentUID);
		model.addAttribute("noneActiveX", "YES");
		model.addAttribute("menuIndex", menuIndex);
		model.addAttribute("aclList", aclList);
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("mode", mode);
		model.addAttribute("displayName", displayName);
		model.addAttribute("displayName2", displayName2);
		model.addAttribute("imagePath", imagePath);
		model.addAttribute("linkURL", linkURL);
		model.addAttribute("linkLocation", linkLocation);
		model.addAttribute("windowOption", windowOption);
		model.addAttribute("imageWidth", imageWidth);
		model.addAttribute("imageHeight", imageHeight);
		
		return "/admin/ezPortal/portalLogoEdit";
		
	}
	
	/**
	 * 관리자 포탈 로고설정 로고 추가 및 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/saveLogoImage.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String saveLogoImage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		String pageID = "";
		String mode = "";
		String uID = "";
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
			pageID = req.getParameter("pageID");
		}
		if (req.getParameter("mode") != null && !req.getParameter("mode").equals("")) {
			mode = req.getParameter("mode");
		}
		if (req.getParameter("uID") != null && !req.getParameter("uID").equals("")) {
			uID = req.getParameter("uID");
		}
		String pServerPath = config.getProperty("upload_portal.ROOT") + commonUtil.separator + "Logo";
		
		//로고저장
		if (mode.equals("SAVE")) {
			Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
			String oldImageName = xmlDom.getElementsByTagName("OLDFILENAME").item(0).getTextContent();
			String displayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
			String displayName2 = xmlDom.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent();
			String normalImage = xmlDom.getElementsByTagName("NORMALIMAGE").item(0).getTextContent();
			String imageWidth = xmlDom.getElementsByTagName("IMAGEWIDTH").item(0).getTextContent();
			String imageHeight = xmlDom.getElementsByTagName("IMAGEHEIGHT").item(0).getTextContent();
			String linkUrl = xmlDom.getElementsByTagName("LINKURL").item(0).getTextContent();
			String linkLocation = xmlDom.getElementsByTagName("LINKLOCATION").item(0).getTextContent();
			String windowOption = xmlDom.getElementsByTagName("WINDOWOPTION").item(0).getTextContent();
			String skin = xmlDom.getElementsByTagName("SKIN").item(0).getTextContent();
			
			if (oldImageName != null && !oldImageName.equals("")) {
				if (new File(pServerPath + commonUtil.separator + oldImageName).exists()) {
					new File(pServerPath + commonUtil.separator + oldImageName).delete();
				}
			}
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_UID", uID);
			map.put("v_OWNERPAGEID", pageID);
			if (skin == null || skin.equals("")) {
				skin = "0";
			}
			map.put("v_SKINNUM", Integer.parseInt(skin));
			map.put("v_DISPLAYNAME", displayName);
			map.put("v_DISPLAYNAME2", displayName2);
			map.put("v_NORMALIMAGEPATH", normalImage);
			if (imageWidth == null || imageWidth.equals("")) {
				imageWidth = "0";
			}
			map.put("v_IMAGEWIDTH", Integer.parseInt(imageWidth));
			if (imageHeight == null || imageHeight.equals("")) {
				imageHeight = "0";
			}
			map.put("v_IMAGEHEIGHT", Integer.parseInt(imageHeight));
			map.put("v_LINKURL", linkUrl);
			map.put("v_LINKLOCATION", linkLocation);
			map.put("v_WINDOWOPTION", windowOption);
			ezPortalAdminService.saveLogoImage(map);
		} else if (mode.equals("DEL")) {
			//기존 저장된 파일명
			String oldFileName = "";
			if (req.getParameter("oldFileName") != null && !req.getParameter("oldFileName").equals("")) {
				oldFileName = req.getParameter("oldFileName");
			}
			
			if (oldFileName != null && !oldFileName.equals("")) {
				if (new File(pServerPath + commonUtil.separator + oldFileName).exists()) {
					new File(pServerPath + commonUtil.separator + oldFileName).delete();
				}
			}
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_UID", uID);
			map.put("v_OWNERPAGEID", pageID);
			ezPortalAdminService.saveLogoImage2(map);
		}
		return "OK";
	}
	
	/**
	 * 관리자 포탈 로고설정 위치설정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/menuPosition.do")
	public String menuPosition(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);

        String parentUID = "";
		String pageID = "";
		String align = "center";
		String vAlign = "middle";
        String leftMargin = "0";
        String rightMargin = "0";
        String topMargin = "0";
        String bottomMargin = "0";
		
		if (req.getParameter("parentUID") != null && !req.getParameter("parentUID").equals("")) {
			parentUID = req.getParameter("parentUID");
		}
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
			pageID = req.getParameter("pageID");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPUID", "201");
		map.put("v_pPAGEID", pageID);
		PortalTBLTopMenuItemsVO result = ezPortalAdminService.loadPositionSettings(map);
		String xmlStr = commonUtil.getQueryResult(result);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		if (xmlDom.getElementsByTagName("ALIGN").getLength() > 0) {
			if (xmlDom.getElementsByTagName("ALIGN").item(0).getTextContent() != null && !xmlDom.getElementsByTagName("ALIGN").item(0).getTextContent().equals("")) {
				align = xmlDom.getElementsByTagName("ALIGN").item(0).getTextContent().trim();
			}
			if (xmlDom.getElementsByTagName("VALIGN").item(0).getTextContent() != null && !xmlDom.getElementsByTagName("VALIGN").item(0).getTextContent().equals("")) {
				vAlign = xmlDom.getElementsByTagName("VALIGN").item(0).getTextContent().trim();
			}
			if (xmlDom.getElementsByTagName("LEFTMARGIN").item(0).getTextContent() != null && !xmlDom.getElementsByTagName("LEFTMARGIN").item(0).getTextContent().equals("")) {
				leftMargin = xmlDom.getElementsByTagName("LEFTMARGIN").item(0).getTextContent().trim();
			}
			if (xmlDom.getElementsByTagName("RIGHTMARGIN").item(0).getTextContent() != null && !xmlDom.getElementsByTagName("RIGHTMARGIN").item(0).getTextContent().equals("")) {
				rightMargin = xmlDom.getElementsByTagName("RIGHTMARGIN").item(0).getTextContent().trim();
			}
			if (xmlDom.getElementsByTagName("TOPMARGIN").item(0).getTextContent() != null && !xmlDom.getElementsByTagName("TOPMARGIN").item(0).getTextContent().equals("")) {
				topMargin = xmlDom.getElementsByTagName("TOPMARGIN").item(0).getTextContent().trim();
			}
			if (xmlDom.getElementsByTagName("BOTTOMMARGIN").item(0).getTextContent() != null && !xmlDom.getElementsByTagName("BOTTOMMARGIN").item(0).getTextContent().equals("")) {
				bottomMargin = xmlDom.getElementsByTagName("BOTTOMMARGIN").item(0).getTextContent().trim();
			}
		}
		
		model.addAttribute("align", align);
		model.addAttribute("vAlign", vAlign);
		model.addAttribute("leftMargin", leftMargin);
		model.addAttribute("rightMargin", rightMargin);
		model.addAttribute("topMargin", topMargin);
		model.addAttribute("bottomMargin", bottomMargin);
		model.addAttribute("pageID", pageID);
		model.addAttribute("parentUID", parentUID);
		
		return "/admin/ezPortal/portalMenuPosition";
		
	}
	
	/**
	 * 관리자 포탈 로고설정 위치설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/savePositionSettings.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String savePositionSettings(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		String pageID = "";
		if (req.getParameter("pageID") != null && !req.getParameter("pageID").equals("")) {
			pageID = req.getParameter("pageID");
		}
		
		String ret = ezPortalAdminService.savePositionSettings(xmlStr, pageID);
		
		return ret;
	}
	
	/**
	 * 관리자 포탈 서비스적용 실행 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/deleteCache.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String deleteCache(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale, @RequestBody String xmlStr) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String pUID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
		
		ezPortalService.deleteCacheValue(pUID, ezPortalService.getAccessList(userInfo));
		
		return "OK";
	}
	
	
}
