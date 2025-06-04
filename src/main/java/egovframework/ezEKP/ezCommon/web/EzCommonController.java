package egovframework.ezEKP.ezCommon.web;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;

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
public class EzCommonController extends EzFileMngUtil{
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCommonController.class);
	
	@RequestMapping(value = "/ezCommon/manyColor.do", method = RequestMethod.GET)
	public String manyColor(HttpServletRequest request, ModelMap model) throws Exception {
		String type = "";
		
		type = request.getParameter("type");
		
		if (type == null) {
			type = "";
		}
		
		type = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(type));
		model.addAttribute("type", type);
		return "ezCommon/manyColor";
	}
	
	/**
	 * 게시판 html -> mht 변환 표출 Method
	 */
	@RequestMapping(value = "/ezCommon/htmlToMHT.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
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
		
        String scheme = "YES".equals(ezCommonService.getTenantConfig("USE_HTTPS", userInfo.getTenantId())) ? "https://" : "http://";

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

        strHTML = commonUtil.cleanScriptValue(strHTML);
        
        String mhtData = ezCommonService.startHtml2Mht(strHTML, realPath, userInfo.getLocale());
        
        logger.debug("htmlToMHT ended.");
        
        return mhtData;
	}
	
	/**
	 * 게시판 mht -> html 변환 표출 Method
	 */
	@RequestMapping(value = "/ezCommon/mhtToHTMLContent.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mhtToHTMLContent(@CookieValue(value="loginCookie", required = false) String loginCookie, HttpServletRequest request, Locale locale) throws Exception{
		logger.debug("mhtToHTMLContent started");

		LoginVO userInfo = new LoginVO();
		String type = request.getParameter("type") == null ? "" : request.getParameter("type");

		/* 2025-08-11 비회원 읽기권한 pass */
		if (loginCookie == null || loginCookie.isEmpty()) {
			if(type.equals("BOARDCONTENT")) {
				userInfo.setTenantId(Integer.parseInt(config.getProperty("config.guestDefaultTenantId")));
			} else {
				return "redirect:/user/login/login.do";
			}
		} else {
			userInfo = commonUtil.userInfo(loginCookie);
		}
		
		String itemID = request.getParameter("itemID") == null ? "" : request.getParameter("itemID");
		String realPath = commonUtil.getRealPath(request);
		String strResult = "";
		String scheme = "http://";
		
    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
    		scheme = "https://";
    	}
		
		strResult = ezCommonService.getMHTtoHTML(type, itemID, userInfo.getTenantId(), realPath, request, locale, scheme);

		logger.debug("mhtToHTMLContent ended");
		return strResult;
	}
	
	/**
	 * 게시판 mht -> html 변환 표출 Method
	 */
	@RequestMapping(value = "/ezCommon/mhtToHTML.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mhtToHTML(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale) throws Exception{
		logger.debug("mhtToHTML started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
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

		/* 2024-05-08 양지혜 - 공개문서에서 파라미터 조작으로 접근 취약점 보완. 경로에 문서(doc) 디렉토리가 포함된 경우 열람권한 체크 */
		if (strURL.contains("/doc/")) {
			String[] tmpUrl = strURL.split("doc/");
			if (userInfo.getRollInfo().indexOf("c=1") == -1 && (userInfo.getRollInfo().indexOf("m=1") == -1 && !tmpUrl[1].contains(userInfo.getCompanyID()))) {
				String accessInfo = ezCommonService.getTenantConfig("UserInfo_ApprovalG_VIEW", userInfo.getTenantId());
				String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
				String[] tmpStr = strURL.split("/");
				String docID = tmpStr[tmpStr.length - 1].substring(0, 20);
				String aprPass = "";
				String endPass = "";
				aprPass = ezApprovalGService.getAccessYNGforAPR(docID, accessInfo, approvalFlag, userInfo);
				endPass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag, userInfo.getDeptID());
				if (aprPass.contains("FALSE") || endPass.contains("FALSE")) {
					return "NoAccess";
				}
			}
		}
        
        filePath = realPath + uploadModule;
        
        File file = new File(commonUtil.detectPathTraversal(filePath));
        if (!file.exists()) {
        	file.mkdirs();
        }
        String m_strMHT = "";
        
        try {
        	m_strMHT = ezCommonService.loadMHTFile(realPath + strURL);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
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
	@RequestMapping(value = "/ezCommon/showPersonInfo.do", method = RequestMethod.GET)
	public String showPersonInfo(@CookieValue("loginCookie")String loginCookie, Locale locale,
						HttpServletRequest request, HttpServletResponse response,
						ModelMap model) throws Exception {
		logger.debug("showPersonInfo started");

		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String id = "", email = "", pDeptID = "";
		String userType = "";
		String userName = "";
		
		String literalEmail = "";
		String literalDisplayName = "";
		String literalPhoto = "";
		String literalDept = "";
		String literalTitle = "";
		String literalRole = "";
		String literalCompany = "";
		String literalMobile = "";
		String literalHomePhone = "";
		String literalFax = "";
		String literalPostal = "";
		String literalAddress = "";
		String literalPhone = "";
		String literalInfo = "";
		boolean aliasMailUse = false;
		String literalFurigana = "";
		String literalExtensionPhone = "";
		String literalOfficeMobile = "";
		
		String proplist = "EXTENSIONATTRIBUTE2;COMPANY;DESCRIPTION;DISPLAYNAME;TITLE;MAIL;TELEPHONENUMBER;MOBILE;INFO;HOMEPHONE;FACSIMILETELEPHONENUMBER;POSTALCODE;STREETADDRESS;DEPARTMENT;EXTENSIONATTRIBUTE10";
		
		if (request.getParameter("id") != null) {
			id = request.getParameter("id");
		}
		
		if (request.getParameter("email") != null) {
			email = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(request.getParameter("email")));
		}
		
		if (request.getParameter("dept") != null) {
			pDeptID = request.getParameter("dept");
		}
		
		if (request.getParameter("userType") != null) {
			userType = request.getParameter("userType");
		}
		
		if (request.getParameter("userName") != null) {
			userName = request.getParameter("userName");
		}
		
		String jobId = Optional.ofNullable(request.getParameter("jobId")).orElse("");
		String type = Optional.ofNullable(request.getParameter("type")).orElse("");

		logger.debug("id=" + id + ", email=" + email + ", dept=" + pDeptID + ", userType=" + userType + ", userName="
				+ userName + ", jobId=" + jobId + ", type=" + type);

		OrganUserVO userCheckVO = ezOrganService.getUserInfo(id, "1", loginVO.getTenantId());
		if (userCheckVO != null) {
			logger.debug(id + " is member.");
			proplist += ";FURIGANA;EXTENSIONPHONE;OFFICEMOBILE";
		}
		logger.debug("prop=" + proplist);
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", loginVO.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", loginVO.getTenantId());
		
		logger.debug("dotNetIntegration=" + dotNetIntegration);
		
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", loginVO.getTenantId());
		
		/* 2021-08-27 홍승비 - 직위/직책/권한그룹 클릭 시 전달받은 이름만을 표출하도록 수정 */
		if (userType.equals("jikwi") || userType.equals("jikchek") || userType.equals("group")) {
			literalDisplayName = userName;
			literalPhoto = "<IMG SRC='" + egovMessageSource.getMessage("main.e14", locale) + "' width=119 height=128>";
		}
		else {
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
				
				// 사용자 아이디가 비어있거나 공유사서함인 경우에도 이메일 주소만 표시하도록 한다.
				if (user == null  || user.getId() == null || user.getDeptID().startsWith("shared_mailbox")) {
					parameter = "email=" + URLEncoder.encode(email, "utf-8");
				} else {
					parameter = "id=" + URLEncoder.encode(personId, "utf-8") + "&alias=" + URLEncoder.encode(user.getEmail(), "utf-8"); 
				}
				
				logger.debug("parameter=" + parameter);
				
				return "redirect:" + dotNetUrl + "/myoffice/common/ShowPersonInfo.aspx?PAGETYPE=POPUP&" + parameter;
			}
			
			if (id.equals("")) {
				if (!email.equals("")) {
					id = ezOrganService.getCNByEmail(email, loginVO.getTenantId());
				}
			} 
			
			//email이 alias 메일이어서 id를 못가져왔을 경우
			//alias mail인지 check후 원래 이메일 주소에서 id를 가져온다.
			if (id == null || id.equals("")) {
				if (email.contains("@")) {
					List<String> aliasAddress = new ArrayList<String>();
					aliasAddress.add(email);
					Map<String, String> targetAddress = ezEmailService.getAliasAddressMap(aliasAddress, loginVO.getTenantId());
					
					if (targetAddress != null) {
						String resultTargetAddress = targetAddress.get(email);
						logger.debug("resultAddress=" + resultTargetAddress);
						
						if (resultTargetAddress != null) {
							aliasMailUse = true;
							int atSignPos = resultTargetAddress.indexOf("@");
							if (atSignPos != -1) {
								id = resultTargetAddress.substring(0, atSignPos);
								logger.debug("id=" + id);
							}
						}
					}
				}
			}
			
			if (id != null && !id.equals("")) {
				
				MailDistributionVO mailDlVo = ezEmailService.getDistributionInfo(id, loginVO.getTenantId());
				if (mailDlVo != null && mailDlVo.getName() != null) {
					literalEmail = mailDlVo.getMail();
					literalDisplayName = mailDlVo.getName();
					logger.debug("Distribution(alias) info email=" + literalEmail + ", displayName=" + literalDisplayName);
				} else {
				
					String infoXML = ezOrganService.getPropertyList(id, proplist, loginVO.getPrimary(), loginVO.getTenantId());
					
					Document xmldom = commonUtil.convertStringToDocument(infoXML);
					if (xmldom.getElementsByTagName("MAIL") == null) {
						literalEmail = email;
						literalDisplayName = email;
						literalPhoto = "<IMG SRC='" + egovMessageSource.getMessage("main.e14", locale) + "' width=119 height=128>";
					} else {
						if (!pDeptID.equals("") && !xmldom.getElementsByTagName("DEPARTMENT").item(0).getTextContent().equals(pDeptID)) {
							// 2024.05.16 장혜연 직원 상세정보 조회시 jobId도 고려되도록 추가
							String infoXML2 = ezOrganService.getUserAddjobInfoWithJobId(id, pDeptID, loginVO.getPrimary(), jobId, loginVO.getTenantId());
							
							if (infoXML2 != null && !infoXML2.equals("") && !infoXML2.equals("<DATA></DATA>")) {
								Document xmldom2 = commonUtil.convertStringToDocument(infoXML2);
								
								literalDept = xmldom2.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
								literalTitle= xmldom2.getElementsByTagName("TITLE").item(0).getTextContent();		
								literalCompany = xmldom2.getElementsByTagName("COMPANY").item(0).getTextContent();
								literalRole= xmldom2.getElementsByTagName("EXTENSIONATTRIBUTE10").item(0).getTextContent();		
							} else {
								literalDept = xmldom.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
								literalTitle= xmldom.getElementsByTagName("TITLE").item(0).getTextContent();
								literalCompany = xmldom.getElementsByTagName("COMPANY").item(0).getTextContent();
								literalRole= xmldom.getElementsByTagName("EXTENSIONATTRIBUTE10").item(0).getTextContent();
							}
							
						} else {
							literalCompany = xmldom.getElementsByTagName("COMPANY").item(0).getTextContent();
							literalDept = xmldom.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
							literalTitle= xmldom.getElementsByTagName("TITLE").item(0).getTextContent();
							literalRole= xmldom.getElementsByTagName("EXTENSIONATTRIBUTE10").item(0).getTextContent();
							// 겸직자의 상세보기 화면 표출 시 jobid를 통하여 직위,직책 값을 가져옴
							if (type.equals("addJob")) {
								OrganUserVO userAddJob = ezOrganService.getAddJobInfo(id, pDeptID, jobId, loginVO.getTenantId());
								literalTitle = userAddJob.getTitle();
								literalRole = userAddJob.getRole();
							}
						}

						String defaultPic = egovMessageSource.getMessage("main.e14", locale);
						String userImg = defaultPic;

						if (!xmldom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().equals("") && xmldom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().contains(".")) {
							userImg = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + xmldom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent();
						}

						literalPhoto = "<IMG SRC='" + userImg + "' onerror=\"this.src='" + defaultPic + "'\" width=119 height=128>";
						
						/* 2018-09-13 홍승비 - 사원 정보 보기 시 담당업무 자기소개 특수문자 처리 */
		//				literalCompany = xmldom.getElementsByTagName("COMPANY").item(0).getTextContent();
						literalDisplayName = xmldom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
						literalEmail = xmldom.getElementsByTagName("MAIL").item(0).getTextContent();
						literalPhone = xmldom.getElementsByTagName("TELEPHONENUMBER").item(0).getTextContent();
						literalMobile = xmldom.getElementsByTagName("MOBILE").item(0).getTextContent();
						literalHomePhone = xmldom.getElementsByTagName("HOMEPHONE").item(0).getTextContent();
						literalFax = xmldom.getElementsByTagName("FACSIMILETELEPHONENUMBER").item(0).getTextContent();
						literalPostal = xmldom.getElementsByTagName("POSTALCODE").item(0).getTextContent();
						literalAddress= xmldom.getElementsByTagName("STREETADDRESS").item(0).getTextContent();
						literalInfo = commonUtil.cleanValue(xmldom.getElementsByTagName("INFO").item(0).getTextContent());
						if (userCheckVO != null) { // 사용자 정보보기 일때만
							literalFurigana = xmldom.getElementsByTagName("FURIGANA").item(0).getTextContent();
							literalExtensionPhone = xmldom.getElementsByTagName("EXTENSIONPHONE").item(0).getTextContent();
							literalOfficeMobile = xmldom.getElementsByTagName("OFFICEMOBILE").item(0).getTextContent();
						}
						OrganDeptVO deptVO = ezOrganService.getDeptInfo(id, loginVO.getPrimary(), loginVO.getTenantId());
						
						// 이메일 아이디에 match되는 부서가 있는 경우
						if (deptVO != null) {
							if (loginVO.getPrimary().equals("1")) {
								literalCompany = deptVO.getExtensionAttribute3();
							} else {
								literalCompany = deptVO.getCompNm2();
							}
							
							literalEmail = deptVO.getMail();
							literalDisplayName = deptVO.getDisplayName();
							
							if (!deptVO.getExtensionAttribute2().equals(deptVO.getCn())){
								literalDept = deptVO.getDisplayName();
							}
						} 
					}
				} // mailDlVo if_Else End
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
							
							if (!deptVO.getExtensionAttribute2().equals(deptVO.getCn())){
								literalDept = deptVO.getDisplayName();
							}
							
							literalEmail = deptVO.getMail();
							literalDisplayName = deptVO.getDisplayName();
						// 이메일 아이디에 match되는 부서가 없는 경우 공용배포그룹에 match되는 항목이 있는 지 확인한다.
						} else {
							MailDistributionVO mailDlVo = ezEmailService.getDistributionInfo(searchId, loginVO.getTenantId());
							if (mailDlVo != null && mailDlVo.getName() != null) {
								literalEmail = mailDlVo.getMail();
								literalDisplayName = mailDlVo.getName();
							}
							/*List<MailDistributionVO> distributionList = ezEmailService.getDistributionList(loginVO.getCompanyID(), loginVO.getTenantId());
							
							if (distributionList != null && distributionList.size() > 0) {				
								for (MailDistributionVO distribution : distributionList) {
									if (distribution.getId().equalsIgnoreCase(searchId)) {
										literalEmail = distribution.getMail();
										literalDisplayName = distribution.getName();
										break;
									}
								}				
							}			*/	
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
			
			//보낸사람이 alias mail로 보냈을 경우, 메일주소에 alias 주소로 입력
			if (aliasMailUse == true) {
				literalEmail = email;
			}
		}
		
		model.addAttribute("LiteralEmail", literalEmail);
		model.addAttribute("LiteralDisplayName", literalDisplayName);
		model.addAttribute("LiteralPhoto", literalPhoto);
		model.addAttribute("LiteralDept", literalDept);
		model.addAttribute("LiteralTitle", literalTitle);
		model.addAttribute("LiteralRole", literalRole);
		model.addAttribute("LiteralCompany", literalCompany);
		model.addAttribute("LiteralMobile", literalMobile);
		model.addAttribute("LiteralHomePhone", literalHomePhone);
		model.addAttribute("LiteralFax", literalFax);
		model.addAttribute("LiteralPostal", literalPostal);
		model.addAttribute("LiteralAddress", literalAddress);
		model.addAttribute("LiteralPhone", literalPhone);
		model.addAttribute("LiteralInfo", literalInfo);
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("LiteralFurigana", literalFurigana);
		model.addAttribute("LiteralExtensionPhone", literalExtensionPhone);
		model.addAttribute("LiteralOfficeMobile", literalOfficeMobile);

		logger.debug("showPersonInfo ended");
        return "/ezCommon/showPersonInfo";
	}

	@RequestMapping(value = "/fileroot/**", method = RequestMethod.GET)
	@ResponseBody
	public void downloadFileroot(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadFileroot started.");

		String filePath = URLDecoder.decode(request.getRequestURI(), "utf-8");

		logger.debug("filePath={}", filePath);

		downImage(filePath, request, response);

		logger.debug("downloadFileroot ended.");
	}

	@RequestMapping(value = "/ezCommon/downloadAttach.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadAttach(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttach started");

		String filePath = request.getParameter("filePath");
		
		if (filePath == null) {
			return;
		}
		
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
	@RequestMapping(value = "/ezCommon/convertSaveImage.do", method = RequestMethod.POST)
	@ResponseBody
	public void convertSaveImage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("convertSaveImage started");

		String realPath = commonUtil.getRealPath(request);
		
		String pImgUrl = request.getParameter("url");
		String width = request.getParameter("width");
		String height = request.getParameter("height");
//		String type = request.getParameter("type");
		
		logger.debug("pImgUrl=" + pImgUrl + ",width=" + width + ",height=" + height);
		
		StringBuilder sb = new StringBuilder();
		sb.append(request.getScheme()).append("://").append(request.getServerName());
		
		int serverPort = request.getServerPort();
		if(serverPort != 80 && serverPort != 443) {
			sb.append(":").append(serverPort);
		}
		
		String realFilePath = pImgUrl.replace(sb.toString(), realPath);
		
		logger.debug("realFilePath : {}", realFilePath);
		
		File file = new File(commonUtil.detectPathTraversal(realFilePath));
		
		BufferedImage inputImage = ImageIO.read(file);
		BufferedImage outputImage = null;
		Graphics2D saveImage = null;
		
//		int nImgWidth = inputImage.getWidth();
//      int nImgHeight = inputImage.getHeight();
		int nWidth = 100, nHeight = 100;
		
		if (!width.equals("")) {
			nWidth = (int) Float.parseFloat(width); // width가 소수형태로 넘어올 때도 있음
		}
		
		if (!height.equals("")) {
			nHeight = (int) Float.parseFloat(height);
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
	//2019-09-20 메신저 다운로드 추가
	@RequestMapping(value = "/ezCommon/talkDownloadAttach.do", method = RequestMethod.GET)
	@ResponseBody
	public void talkDownloadAttach(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("talkDownloadAttach started");

		// 20211102 조진호 - 경기대학교 웹취약점(모의해킹) 체크 결과에 따른 조치. 기존 filePath는 get parameter로 받아와 경로가 보였지만 이 부분을 서버에서 처리하는 방식으로 수정
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String filePath = ezCommonService.getTenantConfig("talkFilePath", userInfo.getTenantId());
		String fileName = filePath.substring(filePath.lastIndexOf(commonUtil.separator) + 1); 
		String realPath = commonUtil.getRealPath(request);

		downFile(request, response, realPath + filePath, fileName);
		
		logger.debug("talkDownloadAttach ended");
	}

	@RequestMapping(value="/ezCommon/attachWebFolderFile.do",method=RequestMethod.GET , produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject attachWebFolderFile(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		logger.debug("attachWebFolderFile started.");
		
		JSONObject result = new JSONObject();
		
		LoginVO userInfo 				= commonUtil.userInfo(loginCookie);
		String fileListStr             	= request.getParameter("fileList") == null ? null : request.getParameter("fileList");
		String param 					= request.getParameter("param") == null ? "" : request.getParameter("param") ;

		if (fileListStr == null){
			result.put("status", "ERROR");
			return result;
		}
		
		JSONParser jp                 	= new JSONParser();
		JSONArray fileListJson 			= (JSONArray) jp.parse(fileListStr);
		
		JSONObject returnData = ezCommonService.attachWebFolderFile(fileListJson, userInfo, param, request);
		List<String> downloadPath = new ArrayList<String>();   
		
		if (!(returnData.get("status").toString()).equalsIgnoreCase("ERROR")){
			downloadPath = (List<String>) returnData.get("downloadPath");
		}
		
		JSONArray jsonArr = new JSONArray();
		JSONObject json = null;
		
		if(downloadPath.size() == fileListJson.size()){
			for(int i = 0; i < fileListJson.size(); i++){
				json = new JSONObject((JSONObject)fileListJson.get(i));
				json.remove("downloadLink");
				json.put("downloadLink", downloadPath.get(i));
				jsonArr.add(json);
			}
		}
		
		result.put("status", returnData.get("status"));
		result.put("fileList", jsonArr);
		logger.debug("attachWebFolderFile ended.");
		return result;
	}
	
	/**
	 * 2021-12-09 홍승비 - 파일 업로드 시 확장자 체크 메서드 분리 (ajax 호출용, USE_FileExtension만 체크)
	 * */
	@RequestMapping(value = "/ezCommon/checkUseFileExtension.do", method = RequestMethod.GET)
	@ResponseBody
	public String checkUseFileExtension(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("checkUseFileExtension started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		String fileExt = request.getParameter("fileExt");
		String result = "";
		
		logger.debug("checkUseFileExtension file extension is : " + fileExt);
		// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
		if (!useExtension.contains("*") && (fileExt.isEmpty() || useExtension.toLowerCase().indexOf(fileExt.toLowerCase()) < 0)) {
			result = "UPLOAD_EXT_ERROR";
		} else {
			result = "OK";
		}
		
		logger.debug("checkUseFileExtension ended, result = " + result);
		return result;
	}
	
	/**
	 * 2021-12-09 홍승비 - 이미지 업로드 시 확장자 체크 메서드 분리 (ajax 호출용, USE_FileExtension을 포함)
	 * */
	@RequestMapping(value = "/ezCommon/checkImgExtension.do", method = RequestMethod.GET)
	@ResponseBody
	public String checkImgExtension(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("checkImgExtension started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		String fileExt = request.getParameter("fileExt");
		String result = "";
		
		logger.debug("checkImgExtension file extension is : " + fileExt);
		if (commonUtil.checkImgExtension(fileExt) == false || (!useExtension.equals("*") && useExtension.toLowerCase().indexOf(fileExt.toLowerCase()) < 0)) {
			result = "UPLOAD_EXT_ERROR";
		} else {
			result = "OK";
		}
		
		logger.debug("checkImgExtension ended, result = " + result);
		return result;
	}

	@PostMapping(value = "/ezcommon/logging", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String frontLogging(HttpServletRequest request) {

		String logTitle = request.getParameter("logTitle");
		String logMsg = request.getParameter("logMsg");
		String stack = request.getParameter("stack");

		logger.debug("logTitle: " + logTitle + " / logMsg: " + logMsg);
		logger.debug("stack: " + stack);

		return "true";
	}

	/**
	 * 공통 confirm 호출 Method
	 */
	@RequestMapping(value = "/ezCommon/ezConfirm.do", method = RequestMethod.GET)
	public String ezAprOpinion(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) {
		return "ezCommon/ezConfirm";
	}
}
