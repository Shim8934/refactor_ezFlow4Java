package egovframework.ezEKP.ezCommon.web;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 공통
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    황윤진    신규작성
 *
 * @see
 */
@Controller
public class EzCommonController extends EgovFileMngUtil{
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties globals;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCommonController.class);
	
	@RequestMapping(value = "/ezCommon/manyColor.do")
	public String manyColor(HttpServletRequest request, ModelMap model) throws Exception {
		String type = "";
		
		type = request.getParameter("type");
		
		if (type == null) {
			type = "";
		}
		
		model.addAttribute("type", type);
		return "ezCommon/manyColor";
	}
	
	/**
	 * 게시판 html -> mht 변환 표출 Method
	 */
	@RequestMapping(value = "/ezCommon/htmlToMHT.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String htmlToMHT(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("htmlToMHT started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
        String strHTML = "";
        String realPath = commonUtil.getRealPath(request);
        
        if (request.getParameter("strHTML") != null) {
        	strHTML = request.getParameter("strHTML");
        	strHTML = URLDecoder.decode(strHTML, "utf-8");
        }
        
        String scheme = "http://";
    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
    		scheme = "https://";
    	}
        
    	while (strHTML.indexOf("src=\"/ezEmail/downloadInline.do") > 0) {
    		int pos1 = strHTML.indexOf("src=\"/ezEmail/downloadInline.do") + 5;
    		int pos2 = pos1 + strHTML.substring(pos1).indexOf("\"");
    		String imgUrlOrg = strHTML.substring(pos1, pos2);
			String imgUrl = imgUrlOrg.replaceAll("&amp;", "&");
			
			String convertImgUrl = ezEmailService.mailContentDownload(loginCookie, imgUrl, realPath);
			convertImgUrl = "replace_" + scheme + userInfo.getServerName() + convertImgUrl;
			logger.debug("convertImgUrl=" + convertImgUrl);
			
			strHTML = strHTML.replace(imgUrlOrg, convertImgUrl);
    	}
    	
        strHTML = strHTML.replace("replace_" + scheme, scheme);

        // reform 리폼관련 
//        if (strHTML.IndexOf("__reform_data_bind_list") > -1) {
//            HTMLDocument iDoc = new HTMLDocument();
//            iDoc.designMode = "on";
//            object[] oPageText = { strHTML };
//            IHTMLDocument2 doc = (IHTMLDocument2)iDoc;
//            doc.write(oPageText);
//
//            IHTMLElement dataBindControlListElement = iDoc.getElementById("__reform_data_bind_list");
//            if (dataBindControlListElement != null)
//            {
//                string dataBindControlListElementValue = (string)dataBindControlListElement.getAttribute("value");
//                JArray dataBindControlList = JArray.Parse(dataBindControlListElementValue);
//                foreach (string item in dataBindControlList)
//                {
//                    IHTMLElement dataBindControl = iDoc.getElementById(item);
//                    if (dataBindControl != null)
//                    {
//                        string dataBindControlValue = (string)dataBindControl.getAttribute("value");
//                        JObject dataBindControlValueObject = JObject.Parse(dataBindControlValue);
//                        string sqlQuery = dataBindControlValueObject["sql"].ToString();
//                        sqlQuery = EncryptionHelper.getInstance().Decrypt(sqlQuery);
//                        dataBindControlValueObject["sql"] = sqlQuery;
//                        dataBindControl.setAttribute("value", dataBindControlValueObject.ToString());
//                    }
//                }
//                strHTML = iDoc.documentElement.outerHTML;
//            }
//
//            System.Runtime.InteropServices.Marshal.ReleaseComObject(doc);
//        }
        // reform - end
        
        strHTML = commonUtil.cleanScriptValue(strHTML, request.getParameter("type"));
        
        String mhtData = ezCommonService.startHtml2Mht(strHTML, realPath, userInfo.getLocale());
        
        logger.debug("htmlToMHT ended.");
        
        return mhtData;
	}
	
	/**
	 * 게시판 mht -> html 변환 표출 Method
	 */
	@RequestMapping(value = "/ezCommon/mhtToHTMLContent.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mhtToHTMLContent(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale) throws Exception{
		logger.debug("mhtToHTMLContent started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemID = "";
		String type = "";
		String realPath = commonUtil.getRealPath(request);
		String strResult = "";
		String scheme = "http://";
		
    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
    		scheme = "https://";
    	}
		
		itemID = request.getParameter("itemID");
		type = request.getParameter("type");
		if (type == null) {
			type = "";
		}
		strResult = ezCommonService.getMHTtoHTML(type, itemID, userInfo.getTenantId(), realPath, request, locale, scheme);

		logger.debug("mhtToHTMLContent ended");
		return strResult;
	}
	
	/**
	 * 게시판 mht -> html 변환 표출 Method
	 */
	@RequestMapping(value = "/ezCommon/mhtToHTML.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mhtToHTML(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale) throws Exception{
		logger.debug("mhtToHTML started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String filePath = "";
        String uploadModule = commonUtil.getUploadPath("upload_common.MHTIMAGE", userInfo.getTenantId()) + commonUtil.separator; 
        String realPath = commonUtil.getRealPath(request);
        String strURL = request.getParameter("strURL");
        String domain = request.getServerName() +":" +request.getServerPort();
        String scheme = "http://";
		
    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
    		scheme = "https://";
    	}
    	
        logger.debug("strURL="+strURL + ",uploadModule="+uploadModule);
        
        filePath = realPath + uploadModule;
        
        File file = new File(filePath);
        if (!file.exists()) {
        	file.mkdirs();
        }
        String m_strMHT = "";
        
        try {
        	m_strMHT = ezCommonService.loadMHTFile(realPath + strURL);
		} catch (Exception e) {
			e.printStackTrace();
			m_strMHT= "";
		}
        
        String result = "";
        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain, scheme);

        if (strHTML.equals("error")) {
        	strHTML = commonUtil.cleanValue(strHTML);
        } else {
        	if (strHTML.indexOf("<BODY>") > -1) {
        		strHTML = strHTML.substring(strHTML.indexOf("<BODY>") + 6, strHTML.indexOf("</BODY>"));
        		strHTML = commonUtil.cleanValue(strHTML);
        		result = "<BODYDATA>" + strHTML + "</BODYDATA>";
        	} else if (strHTML.indexOf("<BODY") > -1) {
        		strHTML = strHTML.substring(strHTML.indexOf(">", strHTML.indexOf("<BODY")) + 1, strHTML.indexOf("</BODY>"));
        		strHTML = commonUtil.cleanValue(strHTML);
        		result = "<BODYDATA>" + strHTML + "</BODYDATA>";
        	} else {
        		if (strHTML.indexOf("<body>") > -1) {
        			strHTML = strHTML.substring(strHTML.indexOf("<body") + 6, strHTML.indexOf("</body>"));
        			strHTML = commonUtil.cleanValue(strHTML);
        		} else {
        			strHTML = strHTML.substring(strHTML.indexOf(">", strHTML.indexOf("<body")) + 1, strHTML.indexOf("</body>"));
        			strHTML = commonUtil.cleanValue(strHTML);
        		}
        		/*String attribute = "orgdocnum";
		
				StringBuffer sb = new StringBuffer();
				
				sb.append("<NODE>");
				sb.append("<NODENAME>" + attribute + "</NODENAME>");
				sb.append("<NODEVALUE>" + strHTML + "</NODEVALUE>");
				
				attribute = "formid";
				
				sb.append("<NODENAME>" + attribute + "</NODENAME>");
				sb.append("<NODEVALUE>" + strHTML + "</NODEVALUE>");
				sb.append("</NODE>");
				
				result = "<?xml version=\"1.0\" encoding=\"utf-8\" ?><ROOT><BODYATTS>" + commonUtil.cleanValue(sb.toString()) + "</BODYATTS>" + "<BODYDATA>" + strHTML + "</BODYDATA></ROOT>";*/
				
				result = "<?xml version=\"1.0\" encoding=\"utf-8\" ?><ROOT><BODYDATA>" + strHTML + "</BODYDATA></ROOT>";
			}
		}

		logger.debug("mhtToHTML ended");
		return result;
	}
	
	/**
	 * ID클릭시 사용자 정보화면 호출 Method
	 */
	@RequestMapping(value = "/ezCommon/showPersonInfo.do")
	public String showPersonInfo(@CookieValue("loginCookie")String loginCookie, Locale locale,
						HttpServletRequest request, HttpServletResponse response,
						ModelMap model) throws Exception {
		logger.debug("showPersonInfo started");

		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String id = "", email = "", pDeptID = "";
		
		String literalEmail = "";
		String literalDisplayName = "";
		String literalPhoto = "";
		String literalDept = "";
		String literalTitle = "";
		String literalCompany = "";
		String literalMobile = "";
		String literalHomePhone = "";
		String literalFax = "";
		String literalPostal = "";
		String literalAddress = "";
		String literalPhone = "";
		String literalInfo = "";
		
		String proplist = "EXTENSIONATTRIBUTE2;COMPANY;DESCRIPTION;DISPLAYNAME;TITLE;MAIL;TELEPHONENUMBER;MOBILE;INFO;HOMEPHONE;FACSIMILETELEPHONENUMBER;POSTALCODE;STREETADDRESS;DEPARTMENT";
		
		if (request.getParameter("id") != null) {
			id = request.getParameter("id");
		}
		
		if (request.getParameter("email") != null) {
			email = request.getParameter("email");
		}
		
		if (request.getParameter("dept") != null) {
			pDeptID = request.getParameter("dept");
		}
		
		logger.debug("id=" + id + ",email=" + email + ",dept=" + pDeptID);
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", loginVO.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", loginVO.getTenantId());
		
		logger.debug("dotNetIntegration=" + dotNetIntegration);
		
		if (dotNetIntegration.equals("YES")) {
			String parameter = "";
			String personId = "";
			String useEmpNumberLogin = ezCommonService.getTenantConfig("UseEmpNumberLogin", loginVO.getTenantId());
			String mailInnerDomain = ezCommonService.getTenantConfig("MailInnerDomain", loginVO.getTenantId());
			String[] mailInnerDomains = mailInnerDomain.split(";");
			boolean isInnerUser = false;
			
			if (!email.isEmpty()) {
				int atSignPos = email.indexOf("@");
				
				if (atSignPos != -1) {
					personId = email.substring(0, atSignPos);
					String domain = email.substring(atSignPos + 1);
					
					for (String innerDomain : mailInnerDomains) {
						if (domain.equals(innerDomain)) {
							isInnerUser = true;
						}
					}
				}
			} else if (!id.isEmpty()) {
				personId = id;
				isInnerUser = true;
			}
			
			logger.debug("personId=" + personId + ",isInnerUser=" + isInnerUser);
			
			LoginVO user = null;
			
			if (isInnerUser) {
				LoginVO login = new LoginVO();
				login.setId(personId);
				login.setDn("NOPASSWORD");
				login.setTenantId(loginVO.getTenantId());
				
				user = loginService.selectUser(login);
			}
			
			if (useEmpNumberLogin.equals("YES")) {
				if (user != null && user.getSabun() != null) {
					personId = user.getSabun();
				}
			}
			
			if (user == null) {
				parameter = "email=" + URLEncoder.encode(email, "utf-8");
			} else {
				parameter = "id=" + URLEncoder.encode(personId, "utf-8") + "&alias=" + URLEncoder.encode(user.getEmail(), "utf-8"); 
			}
			
			logger.debug("parameter=" + parameter);
			
			return "redirect:" + dotNetUrl + "/myoffice/common/ShowPersonInfo.aspx?" + parameter; 
		}
		
		if (id.equals("")) {
			if (!email.equals("")) {
				id = ezOrganService.getCNByEmail(email, loginVO.getTenantId());
			}
		}
		
		if (id != null && !id.equals("")) {
			String infoXML = ezOrganService.getPropertyList(id, proplist, loginVO.getPrimary(), loginVO.getTenantId());
			
			Document xmldom = commonUtil.convertStringToDocument(infoXML);
			if (xmldom.getElementsByTagName("MAIL") == null) {
				literalEmail = email;
				literalDisplayName = email;
				literalPhoto = "<IMG SRC='" + egovMessageSource.getMessage("main.e14", locale) + "' width=119 height=128>";
			} else {
				
//        		if (xmldom.getElementsByTagName(email) == null) {
//        			infoXML = ezOrganService.getSearchLikeByEmail(id);
//        			xmldom = commonUtil.convertStringToDocument(infoXML);
//        		}
				
				if (!pDeptID.equals("") && !xmldom.getElementsByTagName("DEPARTMENT").item(0).getTextContent().equals(pDeptID)) {
					String infoXML2 = ezOrganService.getUserAddjobInfo(id, pDeptID, loginVO.getPrimary(), loginVO.getTenantId());
					
					if (infoXML2!=null && !infoXML2.equals("") && !infoXML2.equals("<DATA></DATA>")) {
						Document xmldom2 = commonUtil.convertStringToDocument(infoXML2);
						
						literalDept = xmldom2.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
						literalTitle= xmldom2.getElementsByTagName("TITLE").item(0).getTextContent();		
						literalCompany = xmldom2.getElementsByTagName("COMPANY").item(0).getTextContent();
					} else {
						literalDept = xmldom.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
						literalTitle= xmldom.getElementsByTagName("TITLE").item(0).getTextContent();
						literalCompany = xmldom.getElementsByTagName("COMPANY").item(0).getTextContent();
					}
					
				} else {
					literalCompany = xmldom.getElementsByTagName("COMPANY").item(0).getTextContent();
					literalDept = xmldom.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
					literalTitle= xmldom.getElementsByTagName("TITLE").item(0).getTextContent();
				}
				
				if (!xmldom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().equals("") && xmldom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().contains(".")) {
					literalPhoto = "<IMG SRC='/admin/ezOrgan/getPersonalInfo.do?fileName=" + xmldom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() + "' width=119 height=128>";
				} else {
					literalPhoto = "<IMG SRC='" + egovMessageSource.getMessage("main.e14", locale) + "' width=119 height=128>";
				}
				
				literalDisplayName = xmldom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
				literalEmail = xmldom.getElementsByTagName("MAIL").item(0).getTextContent();
				literalPhone = xmldom.getElementsByTagName("TELEPHONENUMBER").item(0).getTextContent();
				literalMobile = xmldom.getElementsByTagName("MOBILE").item(0).getTextContent();
				literalHomePhone = xmldom.getElementsByTagName("HOMEPHONE").item(0).getTextContent();
				literalFax = xmldom.getElementsByTagName("FACSIMILETELEPHONENUMBER").item(0).getTextContent();
				literalPostal = xmldom.getElementsByTagName("POSTALCODE").item(0).getTextContent();
				literalAddress= xmldom.getElementsByTagName("STREETADDRESS").item(0).getTextContent();
				literalInfo = xmldom.getElementsByTagName("INFO").item(0).getTextContent().replace(commonUtil.CRLF, "<BR>");
			}
		} else {
			String domainName = ezCommonService.getTenantConfig("DomainName", loginVO.getTenantId());
			
			int atSignIndex = email.indexOf("@");
			
			if (atSignIndex != -1) {
				String searchId = email.substring(0, atSignIndex);
				String searchDomain = email.substring(atSignIndex + 1);
				
				// 이메일 주소의 도메인이 시스템의 도메인과 동일하면 부서 혹은 공용배포그룹에
				// 해당하는 이메일 주소인 지를 검사한다.
				if (searchDomain.equalsIgnoreCase(domainName)) {
					OrganDeptVO deptVO = ezOrganService.getDeptInfo(searchId, loginVO.getPrimary(), loginVO.getTenantId());
					
					// 이메일 아이디에 match되는 부서가 있는 경우
					if (deptVO != null) {
						if (loginVO.getPrimary().equals("1")) {
							literalCompany = deptVO.getExtensionAttribute3();
						} else {
							literalCompany = deptVO.getCompNm2();
						}
						
						literalEmail = deptVO.getMail();
						literalDisplayName = deptVO.getDisplayName();
					// 이메일 아이디에 match되는 부서가 있는 경우 공용배포그룹에 match되는 항목이 있는 지 확인한다.
					} else {
						List<MailDistributionVO> distributionList = ezEmailService.getDistributionList(loginVO.getCompanyID(), loginVO.getTenantId());
						
						if (distributionList != null && distributionList.size() > 0) {				
							for (MailDistributionVO distribution : distributionList) {
								if (distribution.getId().equalsIgnoreCase(searchId)) {
									literalEmail = distribution.getMail();
									literalDisplayName = distribution.getName();
									break;
								}
							}				
						}				
					}
				}
			}
			
			// 부서 혹은 공용배포그룹에 match되는 항목이 없는 경우엔 지정된 이메일 주소를 그대로 사용한다.
			if (literalEmail.isEmpty()) {
				literalEmail = email;
				literalDisplayName = email;
			}
			
			literalPhoto = "<IMG SRC='" + egovMessageSource.getMessage("main.e14", locale) + "' width=119 height=128>";
		}
		
		model.addAttribute("LiteralEmail", literalEmail);
		model.addAttribute("LiteralDisplayName", literalDisplayName);
		model.addAttribute("LiteralPhoto", literalPhoto);
		model.addAttribute("LiteralDept", literalDept);
		model.addAttribute("LiteralTitle", literalTitle);
		model.addAttribute("LiteralCompany", literalCompany);
		model.addAttribute("LiteralMobile", literalMobile);
		model.addAttribute("LiteralHomePhone", literalHomePhone);
		model.addAttribute("LiteralFax", literalFax);
		model.addAttribute("LiteralPostal", literalPostal);
		model.addAttribute("LiteralAddress", literalAddress);
		model.addAttribute("LiteralPhone", literalPhone);
		model.addAttribute("LiteralInfo", literalInfo);

		logger.debug("showPersonInfo ended");
        return "/ezCommon/showPersonInfo";
	}
	
	@RequestMapping(value = "/ezCommon/downloadAttach.do")
	public void downloadAttach(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttach started");

		String filePath = request.getParameter("filePath");
		String fileName = "";
//		String realPath = commonUtil.getRealPath(request);
		
		if (request.getParameter("fileName") != null) {
			fileName = request.getParameter("fileName");
		} else {
			fileName = filePath.substring(filePath.lastIndexOf(commonUtil.separator) + 1); 
		}
		/* 2018-05-04 홍승비 - 포탈 홈 화면에서 커뮤니티 디폴트 썸네일 표출하기 */
		if(fileName.equals("default_logo_empty.png")) {
			filePath = "/images/ezCommunity/logo/default_logo_empty.png";			
		}
		
		downImage(filePath, request, response);
		
//		2018-08-14 천성준 - IE, https에서 이미지 깨짐현상 때문에 주석 후, downImage로 대체
//		downFile(request, response, realPath + filePath, fileName);
//		ezCommonService.responseAttach(filePath, fileName, true, request, response);
		
		logger.debug("downloadAttach ended");
	}
	
	/**
	 * image파일용량 줄여주는 함수
	 */
	@RequestMapping(value = "/ezCommon/convertSaveImage.do")
	public void convertSaveImage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("convertSaveImage started");

		String realPath = commonUtil.getRealPath(request);
		
		String pImgUrl = request.getParameter("url");
		String width = request.getParameter("width");
		String height = request.getParameter("height");
//		String type = request.getParameter("type");
		
		logger.debug("pImgUrl=" + pImgUrl + ",width=" + width + ",height=" + height);
		
		String realFilePath = pImgUrl.replace(request.getScheme() + ":" + commonUtil.separator + commonUtil.separator + request.getServerName() + ":" + request.getServerPort(), realPath);
		
		File file = new File(realFilePath);
		
		BufferedImage inputImage = ImageIO.read(file);
		BufferedImage outputImage = null;
		Graphics2D saveImage = null;
		
//		int nImgWidth = inputImage.getWidth();
//      int nImgHeight = inputImage.getHeight();
		int nWidth = 100, nHeight = 100;
		
		if (!width.equals("")) {
			nWidth = Integer.parseInt(width);
		}
		
		if (!height.equals("")) {
			nHeight = Integer.parseInt(height);
		}
		
		if (nWidth > 0 && nHeight > 0) {
			outputImage= new BufferedImage(nWidth, nHeight, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, nWidth, nHeight, null);
			saveImage.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
			
			ImageIO.write(outputImage, realFilePath.substring(realFilePath.lastIndexOf(".") + 1), file);
		}
		
		//TODO 2016-07-05 이효진 type1 로 들어오는 경우 있을때 추가 
		/*if (type.equals("1")) {
			response.getWriter().print();
		}*/

		logger.debug("convertSaveImage ended");
	}
}
