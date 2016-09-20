package egovframework.ezEKP.ezPortal.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.List;
import java.util.Locale;
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
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezPortal.vo.PortalGetThemeListVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageCategoryVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLSkinGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLThemeGeneralVO;
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
	 * 관리자 포탈 상단메뉴영역설정 화면 호출 함수
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
	
	
}
