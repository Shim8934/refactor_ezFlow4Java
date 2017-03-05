package egovframework.ezEKP.ezApprovalG.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.HandlerMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSecondApprVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 사용자 - 전자결재G
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.22    황윤진         신규작성
 *
 * @see
 */

@Controller
public class EzApprovalGController extends EgovFileMngUtil{
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGController.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties globals;
	
	@Resource(name = "crypto") 
    private EgovFileScrty egovFileScrty;

	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Autowired
	private EgovMessageSource messageSource;

	@Value("#{globals['Globals.DbType']}")
	private String dbType;
	/**
	 * 전자결재G 메인화면 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/apprGMain.do")
	public String apprGMain(HttpServletRequest request, Model model, HttpServletResponse response){
		int listType = 1;
		
		if (request.getParameter("listType") != null) {
			listType = Integer.parseInt(request.getParameter("listType"));
		}
		
		model.addAttribute("listType", listType);
		
		return "ezApprovalG/apprGMain";
	}

	/**
	 * 전자결재G LEFT화면 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/apprGLeft.do")
	public String apprGLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
        logger.debug("apprGLeft Started");  
        userInfo = commonUtil.aprUserInfo(loginCookie);
		String viewLeftCount = ezCommonService.getTenantConfig("APPROVLEFTCOUNT", userInfo.getTenantId());
		String listType = request.getParameter("listType");
		String userSendOut = "";
		String firstContainerID = "";
		String subTitleString = "";
		boolean isSubTitle = false;
		StringBuffer containers = new StringBuffer();
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		List<ApprGLeftVO> apprGLeftVOList = ezApprovalGService.getUseContInfo(userInfo, "2");
		
		String sendOutDept = ezApprovalGService.getOptionInfo("A55", "001", userInfo, "CODE");
		String optGamsabu = ezApprovalGService.getOptionInfo("A40", "001", userInfo, "CODE");
		
        logger.debug("apprGLeft Value : sendOutDept=" + sendOutDept + "optGamsabu=" +optGamsabu);       

		if (sendOutDept.toUpperCase().indexOf(userInfo.getDeptID().toUpperCase()) > -1) {
			userSendOut = "YES";
		}
		
		if (apprGLeftVOList.size() > 0) {
			firstContainerID = apprGLeftVOList.get(0).getContainerID();
		}
		
		for (int k = 0; k < apprGLeftVOList.size(); k++) {
			if (k == 0) {
			    containers.append("'" + apprGLeftVOList.get(k).getContainerID() + "'");
			} else {
				containers.append(", '" + apprGLeftVOList.get(k).getContainerID() + "'");
			}
		}
		String infoXML = ezOrganService.getPropertyValue(userInfo.getDeptID(), "extensionAttribute4", userInfo.getTenantId());
		
		List<Object> referenceTemp = new ArrayList<Object>();
		referenceTemp.add(subTitleString);
		referenceTemp.add(isSubTitle);
		
		getUserSubTitle(userInfo, referenceTemp);
		
		model.addAttribute("apprGLeftVOList", apprGLeftVOList);
		model.addAttribute("listType", listType);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("containers", containers.toString());
		model.addAttribute("viewLeftCount", viewLeftCount);
		model.addAttribute("subTitleString", referenceTemp.get(0));
		model.addAttribute("isSubTitle", referenceTemp.get(1));
		model.addAttribute("infoXML", infoXML);
		model.addAttribute("userSendOut", userSendOut);
		model.addAttribute("optGamsabu", optGamsabu);
		model.addAttribute("firstContainerID", firstContainerID);
		model.addAttribute("szRoleInfo", userInfo.getRollInfo());
		model.addAttribute("strLang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
        logger.debug("apprGLeft Value : listType=" + listType + "containers=" + containers.toString() + "viewLeftCount=" + viewLeftCount);       

        logger.debug("apprGLeft Ended");       

		return "ezApprovalG/apprGLeft";
	}

	/**
	 * 전자결재G 서브타이틀 실행 Method
	 */
	public void getUserSubTitle(LoginVO userInfo, List<Object> referenceTemp) throws Exception{
        logger.debug("getUserSubTitle started");       

		String propList = "extensionAttribute4;department;description;title;title2;description2";
		String results = ezOrganService.getPropertyList(userInfo.getId(), propList, userInfo.getPrimary(), userInfo.getTenantId());
		String myDept = "";
		String subTitleString = "";
		boolean isSubTitle = false;
		Document doc = commonUtil.convertStringToDocument(results);
		
		String deptInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent();
        String deptID = doc.getElementsByTagName("DEPARTMENT").item(0).getTextContent();
        String deptName = doc.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
        String title = doc.getElementsByTagName("TITLE1").item(0).getTextContent();
        String deptName2 = doc.getElementsByTagName("DESCRIPTION2").item(0).getTextContent();
        String title2 = doc.getElementsByTagName("TITLE2").item(0).getTextContent();
        
        myDept = userInfo.getPrimary().equals("1") ? deptName : deptName2;
        
        if (userInfo.getDeptID().equals(deptID)) {
        	if (title.equals("")){
        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "'  selected >" + myDept + "</option>";
        	} else {
        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "'  selected >" + myDept + "[" + title + "]" + "</option>";
        	}
        } else {
        	if (title.equals("")){
        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "' >" + myDept + "</option>";
        	} else {
        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "' >" + myDept + "[" + title + "]" + "</option>";
        	}
        }
        
        String lang = "";
        
        if (!userInfo.getPrimary().equals("1")) {
        	lang = "2";
        }
        
        if (!deptInfo.equals("")) {
        	isSubTitle = true;
        	String[] deptList = deptInfo.split(";");
        	
        	for (int k = 0; k < deptList.length; k++) {
        		String[] subList = deptList[k].split(":");
        		String pTitle_ = userInfo.getPrimary().equals("1") ? commonUtil.cleanValue(subList[1]) : commonUtil.cleanValue(subList[2]);
                String pTitle1_ = ""; 
                String pTitle2_ = "";
                
                if (subList.length > 1) {
                    pTitle1_ = commonUtil.cleanValue(subList[1]);
                }
 
                if (subList.length > 2) {
                    pTitle2_ = commonUtil.cleanValue(subList[2]);
                } else {
                    pTitle2_ = pTitle1_;
                }
                
                String pDeptNM1_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DISPLAYNAME", userInfo.getTenantId()));
                String pDeptNM2_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DISPLAYNAME2", userInfo.getTenantId()));
                String pDeptNM_ = userInfo.getPrimary().equals("1") ? pDeptNM1_ : pDeptNM2_;
                
                if (userInfo.getDeptID().equals(subList[0])) {
                    if (pTitle_.equals("")) {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "'  selected>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang, userInfo.getTenantId())) + "</option>";
                    } else {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "'  selected>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang, userInfo.getTenantId())) + "[" + pTitle_ + "]" + "</option>";
                    }
                } else {
                    if (pTitle_.equals("")) {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "' >" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang, userInfo.getTenantId())) + "</option>";
                    } else {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "' >" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang, userInfo.getTenantId())) + "[" + pTitle_ + "]" + "</option>";
                    }
                }
        	}
        }
        logger.debug("getUserSubTitle Value : subTitleString =" + subTitleString);       
        logger.debug("getUserSubTitle Value : isSubTitle =" + isSubTitle);       

        referenceTemp.set(0, subTitleString);
        referenceTemp.set(1, isSubTitle);
        logger.debug("getUserSubTitle ended");       
	}
	
	/**
	 * 전자결재G 우측리스트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprManage.do")
	public String aprManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String openYear = ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId());
		String buJaeInfo = "";
		String nowDate = EgovDateUtil.convertDate(egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "");
		String susinAdmin = "";
		String listType = request.getParameter("listType");
		String viewLeftCount = ezCommonService.getTenantConfig("APPROVLEFTCOUNT", userInfo.getTenantId()); 
		String useMobile = ezCommonService.getTenantConfig("Use_Mobile", userInfo.getTenantId()); 
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String selMenu = "all";
		
		nowDate = nowDate.substring(0, 16);
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getPrimary(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(result);
		
		buJaeInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("viewLeftCount", viewLeftCount);
		model.addAttribute("buJaeInfo", buJaeInfo);
		model.addAttribute("nowDate", nowDate);
		model.addAttribute("selMenu", selMenu);
		model.addAttribute("openYear", openYear);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useMobile", useMobile);
		model.addAttribute("listType", listType);
		
		return "ezApprovalG/apprGManage";
	}
	
	/**
	 * 전자결재G 결재리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getAprDocList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getAprDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		String listType = request.getParameter("listType");
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String pageSize = request.getParameter("pageSize");
		String pageNum = request.getParameter("pageNum");
		String companyID = request.getParameter("companyID");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String searchQuery = request.getParameter("searchQuery");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userLang = userInfo.getLang();
		Document domSub = null;
		
		if (searchQuery != null && searchQuery.length() > 10) {
			String tempQuery = "";
			String returnQuery = "(1 = 1) ";
			
			domSub = commonUtil.convertStringToDocument(searchQuery);
			tempQuery = domSub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
			
			if (tempQuery.indexOf("DOCNO;") != -1) {
				returnQuery += " AND DOCNO LIKE '%" + domSub.getElementsByTagName("DOCNO").item(0).getTextContent() + "%' ";
			}
			
			if (tempQuery.indexOf("DOCTITLE;") != -1) {
                returnQuery += " AND DocTitle LIKE '%" + domSub.getElementsByTagName("DOCTITLE").item(0).getTextContent() + "%' ";
            }

            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    returnQuery += " AND WRITERNAME" + userLang + " LIKE '%" + domSub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                }
            } else {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    returnQuery += " AND WRITERNAME LIKE '%" + domSub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                }
            }

            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                    returnQuery += " AND WriterDeptName" + userLang + " LIKE '%" + domSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent() + "%' ";
                }
            } else {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                    returnQuery += " AND WriterDeptName LIKE '%" + domSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent() + "%' ";
                }
            }

            if (tempQuery.indexOf("APRSTARTDATE;") != -1) {
                if (listType.equals("10")) {
                	if (!dbType.equals("mysql")) {
                    	returnQuery += " AND RECEIVEDDATE >= TO_DATE('" + domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01','YYYY-MM-DD HH24:MI:SS') ";
                	} else {
                    	returnQuery += " AND RECEIVEDDATE >= STR_TO_DATE('" + domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01','%Y-%m-%d %H:%i:%s') ";
                	}
                } else {
                	if (!dbType.equals("mysql")) {
                		returnQuery += " AND STARTDATE >= TO_DATE('" + domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01','YYYY-MM-DD HH24:MI:SS') ";
                	} else {
                		returnQuery += " AND STARTDATE >= STR_TO_DATE('" + domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01','%Y-%m-%d %H:%i:%s') ";

                	}
                }
            }
            
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
                if (listType.equals("10")){
                	if (!dbType.equals("mysql")) {
                		returnQuery += " AND RECEIVEDDATE <= TO_DATE('" + domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59','YYYY-MM-DD HH24:MI:SS') ";
                	} else {
                		returnQuery += " AND RECEIVEDDATE <= STR_TO_DATE('" + domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59','%Y-%m-%d %H:%i:%s') ";
                	}
                } else {
                	if (!dbType.equals("mysql")) {
                		returnQuery += " AND STARTDATE <= TO_DATE('" + domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59','YYYY-MM-DD HH24:MI:SS') ";
                	} else {
                		returnQuery += " AND STARTDATE <= STR_TO_DATE('" + domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59','%Y-%m-%d %H:%i:%s') ";
                	}
                }
            }
            
            if (tempQuery.indexOf("FORMID;") != -1) {
                returnQuery += " AND FormID = '" + domSub.getElementsByTagName("FORMID").item(0).getTextContent() + "' ";
            }
            
            if (tempQuery.indexOf("KAPR;") != -1) {
                returnQuery += " AND keyword LIKE '%" + domSub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
            }
            
            if (tempQuery.indexOf("KEND;") != -1) {
                returnQuery += " AND TBL_EXPAPRDOCINFO.keyword LIKE '%" + domSub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
            }
            
            if (tempQuery.indexOf("CAPR;") != -1) {
                returnQuery += " AND TBL_EXPENDAPRDOCINFO.itemcode = '" + domSub.getElementsByTagName("itemCODE").item(0).getTextContent() + "' ";
            }
            
            if (tempQuery.indexOf("CEND;") != -1) {
                returnQuery += " AND TBL_EXPAPRDOCINFO.itemcode = '" + domSub.getElementsByTagName("itemCODE").item(0).getTextContent() + "' ";
            }
            
            if (tempQuery.indexOf("URGENTAPPROVAL;") != -1) {
                returnQuery += " AND URGENTAPPROVAL = '" + domSub.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent() + "' ";
            }
            
            searchQuery = returnQuery;
		}
		
		String resultXML = ezApprovalGService.aprDocList(listType, userID, deptID, pageSize, pageNum, orderCell, orderOption, companyID, userLang, searchQuery, domSub, userInfo.getTenantId(), userInfo.getOffset());
	
		return resultXML;
	}
	
	/**
	 * 전자결재G 결재라인리스트 호출 Method
	 */
	@RequestMapping(value = {"/ezApprovalG/getLineList.do","/ezApprovalG/getTotalAttachInfo.do","/ezApprovalG/getReceiptinfo.do","/ezApprovalG/getOpinionInfo.do"}, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getLineList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("c=1") == -1) {
			if (mode.toUpperCase().equals("APR") || mode.toUpperCase().equals("TMP")) {
				if (docID != null && !docID.equals("")) {
					String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1", tenantID, userInfo.getOffset());
					String[] proxyUserArray = proxyUser.split(",");
					boolean checkPermission = true;
					if (proxyUserArray.length > 1) {
						String docList = ezApprovalGService.getAprLineInfoDB(docID.trim(), "1", "", "", userInfo.getCompanyID(), userInfo.getTenantId());
						Document docXML = commonUtil.convertStringToDocument(docList);
						
						for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
							if (docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("002")) {
								String curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k).getTextContent();
								
								for (int j = 0; j < proxyUserArray.length; j++) {
									if (curAprUserID.equals(proxyUserArray[j].trim().substring(1, proxyUserArray[j].trim().length() - 2))){
										checkPermission = false;
										break;
									}
								}
							}
						}
					}
					if (checkPermission) {
						String checkMode = "";
						if (mode.toUpperCase().equals("TMP")){
							checkMode = "TMP";
						} else {
							checkMode = "REC";
						}
						Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), checkMode, userInfo.getCompanyID(), userInfo.getTenantId());
						
						if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
							return "<RESULT>NOTPERMISSION</RESULT>";
						}
					}
				}
			} else if (mode.toUpperCase().equals("END")) {
				String accessInfo = config.getProperty("config.UserInfo_ApprovalG_VIEW");
				String pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
				
				if (!pass.equals("<RESULT>TRUE</RESULT>")) {
					return "<RESULT>NOTPERMISSION</RESULT>";
				}
			}
		}
		String result = "";
		
		if (requestURL.indexOf("getLineList") > -1) {
			result = ezApprovalGService.getLineInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else if (requestURL.indexOf("getTotalAttachInfo") > -1) {
			result = ezApprovalGService.getAttachInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else if (requestURL.indexOf("getReceiptinfo") > -1) {
			result = ezApprovalGService.getReceiptInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else if (requestURL.indexOf("getOpinionInfo") > -1) {
			result = ezApprovalGService.getOpinionInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		}
		
		return result;
	}
	
	/**
	 * 전자결재G 레프트메뉴카운트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getListCount.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getListCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, @RequestBody String docXml) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(docXml);
		String listType = doc.getElementsByTagName("LISTTYPE").item(0).getTextContent();
		String mode = request.getParameter("mode");
		String susinAdmin = "user";
		String result = "";
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "admin";
		}
		
		if (mode != null) {
			result = ezApprovalGService.getWebPartList(listType, userInfo.getId(), userInfo.getDeptID(), "", "LEFT", susinAdmin, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else {
			result = ezApprovalGService.getWebPartList(listType, userInfo.getId(), userInfo.getDeptID(), "", "COUNT", susinAdmin, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		}
		
		return result;
	}
	
	/**
	 * 전자결재G 기안양식 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getFormCont.do")
	public String getFormCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String deptID = userInfo.getDeptID();
		String docType = ezApprovalGService.getDocType("", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		String userForm = ezApprovalGService.getOptionInfo("A57", "001", userInfo, "CODE");
		String docFileType = "";
		
		if (request.getParameter("fileType") != null) {
			docFileType = request.getParameter("fileType");
		}
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("docType", docType);
		model.addAttribute("userForm", userForm);
		model.addAttribute("docFileType", docFileType);
		
		return "ezApprovalG/apprGFormCont";
	}
	
	/**
	 * 전자결재G 기안양식 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getForm.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String id = request.getParameter("id");
		String kind = request.getParameter("kind");
		String searchType = request.getParameter("searchType");
		String searchName = request.getParameter("searchName");
		String result = ezApprovalGService.getFormInfo(id.trim(), kind, searchType, searchName, userInfo.getId(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안양식함 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getFormContainer.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormContainer(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String id = request.getParameter("id");
		String deptID = request.getParameter("deptID");
		String result = ezApprovalGService.getFormContainerInfo(id, deptID, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 양식즐겨찾기등록 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setFormUserInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setFormUserInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String para, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(para);
		String formID = doc.getElementsByTagName("PARA").item(0).getTextContent();
		String result = ezApprovalGService.setUserFormInfo(formID.trim(), userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 양식즐겨찾기삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delFormUserInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delFormUserInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String para, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(para);
		String formID = doc.getElementsByTagName("PARA").item(0).getTextContent();
		String result = ezApprovalGService.delUserFormInfo(formID.trim(), userInfo.getId(), userInfo.getCompanyID(),userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 얼러트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprAlert.do")
	public String ezAPRALERT() throws Exception{
		return "ezApprovalG/apprGezAPRALERT";
	}
	
	/**
	 * 전자결재G 기안하기 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/draftui.do")
	public String draftui(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String susinAdmin = "";
		String formURL = request.getParameter("formURL");
		String draftFlag = request.getParameter("draftFlag");
		String formDocType = request.getParameter("formDocType");
		String susinSN = request.getParameter("susinSN");
		String docState = request.getParameter("docState");
		String listType = request.getParameter("listType");
		String aprState = request.getParameter("aprState");
		String isTmpDoc = request.getParameter("isTmpDoc");
		String docSN = "";
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		if (listType.equals("21")) {
			if (request.getParameter("docSN") != null) {
				docSN = request.getParameter("docSN");
			}
		}
		
		String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0,4) + commonUtil.separator;
		String mode = "APR";
		String docID = isTmpDoc;
		
		File file = new File (dirPath);
		if(!file.exists()) {
			file.mkdirs();
		}
		
		if (listType.equals("1") || listType.equals("2") || listType.equals("3")) {
			mode = "APR";
		} else if (listType.equals("4") || listType.equals("6") || listType.equals("10") || listType.equals("99")) {
			mode = "REC";
		} else if (listType.equals("21")) {
			docID = docSN;
			mode = "TMP";
		}
		
		if (docID != null && !docID.equals("")) {
			String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1", tenantID, userInfo.getOffset());
			String[] proxyUserArray = proxyUser.split(",");
			boolean checkPermission = true;
			
			if (proxyUserArray.length > 1) {
				String docList = ezApprovalGService.getAprLineInfoDB(docID.trim(), "1", "", "", userInfo.getCompanyID(), userInfo.getTenantId());
				Document docXML = commonUtil.convertStringToDocument(docList);
				
				for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
					if (docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("002")) {
						String curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k).getTextContent();
						
						for (int j = 0; j < proxyUserArray.length; j++) {
							if (curAprUserID.equals(proxyUserArray[j].trim().substring(1, proxyUserArray[j].trim().length() - 2))) {
								checkPermission = false;
								break;
							}
						}
					}
				}
			}
			if (checkPermission) {
				Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), mode, userInfo.getCompanyID(), userInfo.getTenantId());
				
				if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
					return "main/warning";
				}
			}
		}
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");
		
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optisSplit", optisSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("sihangURL", sihangURL);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("formURL", formURL);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("formDocType", formDocType);
		model.addAttribute("susinSN", susinSN);
		model.addAttribute("docState", docState);
		model.addAttribute("listType", listType);
		model.addAttribute("aprState", aprState);
		model.addAttribute("isTmpDoc", isTmpDoc);
		model.addAttribute("docSN", docSN);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("dirPath", dirPath);
		
		return "ezApprovalG/apprGDraftui";
	}
	
	/**
	 * 전자결재G 패스워드 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getApprovalPWD.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String getApprovalPWD(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String result = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안내용 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/draftContent.do")
	public String draftContent(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		String mode = "";
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		if (request.getParameter("draftFlag") != null) {
			mode = request.getParameter("draftFlag");
		}
		
		model.addAttribute("mode", mode);
		model.addAttribute("editor", editor);
		
		return "ezApprovalG/apprGDraftContent";
	}
	
	/**
	 * 전자결재G ckeditor 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ckEditor.do")
	public String ckEditor(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		String height = request.getParameter("height");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("height", height);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGCKEditor";
	}
	
	/**
	 * 전자결재G code 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getCodeData.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCodeData(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String code1 = request.getParameter("code1");
		String code2 = request.getParameter("code2");
		String flag = request.getParameter("flag");
		String result = ezApprovalGService.getOptionInfo(code1, code2, userInfo, flag);
		
		return "<RESULT>" + result + "</RESULT>";
	}
	
	/**
	 * 전자결재G 결재정보 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezApprovalInfo.do")
	public String ezApprovalInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String securityNode3 = ezApprovalGService.getSecurityType("", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		String startDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String endDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String initFlag = request.getParameter("initFlag");
		String guBun = request.getParameter("guBun").trim();
		String docSN = "";
		String susinAdmin = "";
		String aprTypeXML = "";
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		
		if (request.getParameter("docSN") != null) {
			docSN = request.getParameter("docSN");
		}
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		if (initFlag.trim().equals("")) {
			initFlag = "0";
		}
		
		aprTypeXML = ezApprovalGService.getAprType(userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		String optGamsabu = ezApprovalGService.getOptionInfo("A40", "001", userInfo, "CODE");
		String susinGroupUseFlag = ezApprovalGService.getCode2Name("A53", "002", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("optGamsabu", optGamsabu);
		model.addAttribute("susinGroupUseFlag", susinGroupUseFlag);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("securityNode3", securityNode3);
		model.addAttribute("startDateTime", startDateTime);
		model.addAttribute("endDateTime", endDateTime);
		model.addAttribute("initFlag", initFlag);
		model.addAttribute("guBun", guBun);
		model.addAttribute("docSN", docSN);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("aprTypeXML", aprTypeXML);
		
		return "ezApprovalG/apprGezApprovalInfo";
	}
	
	/**
	 * 전자결재G 결재라인 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineRequest.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprLineRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.getAprLineInfo(docID.trim(), userID, formID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());

		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/getLineTemplist.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getLineTemplist(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String tempList = ezApprovalGService.getTempList(userID, formID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		String headerXML = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t379", locale) + "</NAME><WIDTH>100%</WIDTH></HEADER></HEADERS><ROWS>" + tempList + "</ROWS></LISTVIEWDATA>";
		
		return headerXML;
	}
	
	/**
	 * 전자결재G 양식체크 얼러트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/formCheckUI.do")
	public String formCheckUI(){
		return "ezApprovalG/apprGFormCheckUI";
	}
	
	/**
	 * 전자결재G 의견얼러트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprOpinion.do")
	public String ezAprOpinion(){
		return "ezApprovalG/apprGezAprOpinion";
	}

	/**
	 * 전자결재G 결재라인저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineSave.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprLineSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String ret) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalGService.updateLineInfo(ret, userInfo.getCompanyID(), userInfo.getLang(), userInfo);
		
		return result;
	}
	
	/**
	 * 전자결재G 수신정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptSave.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprDeptSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String ret2) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
	
		String result = ezApprovalGService.updateReceiptInfo(ret2, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 결재선저장 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineTempletName.do")
	public String aprLineTempletName(){
		return "ezApprovalG/apprGaprLineTempletName";
	}
	
	/**
	 * 전자결재G 결재선리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineTempletList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprLineTempletList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.getLineTempletInfo(formID, userID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 결재선리스트 정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLineTempletListInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprLineTempletListInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprSN = request.getParameter("aprLineSN");
		String result = ezApprovalGService.getLineTempletDetailInfo(formID, userID, aprSN, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 양식세부사항 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getFormDetail.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormDetail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String formID = request.getParameter("formID");
		String companyID = request.getParameter("companyID");
		String resultXML = ezApprovalGService.getFormInfoDetail(formID, companyID, userInfo.getTenantId());
		
		return resultXML;
	}
	
	/**
	 * 전자결재G 기안하기 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getFormRecv.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String getFormRecv(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.getFormRecvApr(docID, formID, userInfo.getId(), userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		return result;
	}
	
	/**
	 * 전자결재G 새문서만들기 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/createNewDoc.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String createNewDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.createNewDoc(formID, userInfo.getCompanyID(),userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 현재날짜(시분초까지) 표출 Method
	 * @throws Exception 
	 */
	@RequestMapping(value = "/ezApprovalG/getFullDate.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String getFullDate(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String fullDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset() ,false);
		fullDate = fullDate.substring(0, 16).replace("-", "."); 
		
		return fullDate;
	}
	
	/**
	 * 전자결재G 현재날짜 표출 Method
	 * @throws Exception 
	 */
	@RequestMapping(value = "/ezApprovalG/getDate.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String getDate() throws Exception{
		String fullDate = commonUtil.getTodayUTCTime("");
		fullDate = fullDate.substring(0, 10).replace("-", ".");
		
		return fullDate;
	}
	
	/**
	 * 전자결재G 기안취소시 언두 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/undoDoc.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String undoDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.deleteDocInfo(docID, "CHECK", userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 결재선저장하기 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/createAprLineTemplet.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String createAprLineTemplet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String aprLineXml) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(aprLineXml);
		String result = ezApprovalGService.updateLineTempletDetailInfo(xmlDom, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		return result;
	}
	
	/**
	 * 전자결재G 결재선 삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delAprLineTempletList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delAprLineTempletList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprLineSN = request.getParameter("aprLineSN");
		String result = ezApprovalGService.deleteLineTempletDetailInfo(formID, userID, aprLineSN, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 결재선적용하기 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/addToAprLine.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String addToAprLine(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprSN = request.getParameter("aprSN");
		String result = ezApprovalGService.addToAprLine(userID, formID, aprSN, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 수신자정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptRequest.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprDeptRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String mode = "ING";
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		
		String result = ezApprovalGService.getReceiptInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang(),userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처저장얼러트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptTempletName.do")
	public String aprDeptTempletName(){
		return "ezApprovalG/apprGaprDeptTempletName";
	}
	
	/**
	 * 전자결재G 수신처저장리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getAprDeptTempletList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAprDeptTempletList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.getReceiptTempletInfo(formID, userID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처 즐겨찾기 리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getReceptTemplist.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getReceptTemplist(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String tempList = ezApprovalGService.getTempList3(userID, formID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		String headerXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t379", locale) + "</NAME><WIDTH>100%</WIDTH></HEADER></HEADERS><ROWS>" + tempList + "</ROWS></LISTVIEWDATA>";
		
		return headerXml;
	}
	
	/**
	 * 전자결재G 수신처 즐겨찾기 리스트디테일 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getAprDeptTempletListInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAprDeptTempletListInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprSN = request.getParameter("aprSN");
		String result = ezApprovalGService.getReceiptTempletDetailInfo(formID, userID, aprSN, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처 그룹 리스트 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getReceptGroupList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getReceptGroupList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Locale locale) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String tempList = ezApprovalGService.getTempList(userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		String headerXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t1568", locale) + "</NAME><WIDTH>100%</WIDTH></HEADER></HEADERS><ROWS>" + tempList + "</ROWS></LISTVIEWDATA>";
		
		return headerXml;
	}
	
	/**
	 * 전자결재G 수신처 그룹 추가 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getReceptGroupADDTo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getReceptGroupADDTo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String groupID = request.getParameter("groupID");
		String xmlList = ezApprovalGService.getListXML(groupID, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		return xmlList;
	}
	
	/**
	 * 전자결재G 수신처 그룹 리스트디테일 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getReceptGroupDetailList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getReceptGroupDetailList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Locale locale, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String groupID = request.getParameter("groupID");
		String tempList = ezApprovalGService.getTempList2(groupID, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
		String headerXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t950", locale) + "</NAME><WIDTH>100%</WIDTH></HEADER></HEADERS><ROWS>" + tempList + "</ROWS></LISTVIEWDATA>";
		
		return headerXml;
	}
	
	/**
	 * 전자결재G 수신처 즐겨찾기 적용 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/addToAprDept.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String addToAprDept(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprDeptSN = request.getParameter("aprSN");
		String result = ezApprovalGService.addToAprDept(userID, formID, aprDeptSN, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처 즐겨찾기 삭제 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/delAprDeptTempletList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delAprDeptTempletList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprDeptSN = request.getParameter("aprSN");
		String result = ezApprovalGService.deleteReceiptTempletDetailInfo(formID, userID, aprDeptSN, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처 즐겨찾기 추가 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/createAprDeptTemplet.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String createAprDeptTemplet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlDom) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlDom);
		String result = ezApprovalGService.updateReceiptTempletDetailInfo(doc, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 대기능 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTaskCategory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getTaskCategory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String type = request.getParameter("strType");
		String result = ezApprovalGService.getTaskCategory(deptCode, companyID, type, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 중기능 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTaskMiddleCategory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getTaskMiddleCategory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String cateCode = request.getParameter("cateCode");
		String result = ezApprovalGService.getTaskMiddleCategory(deptCode, companyID, cateCode, userInfo.getTenantId());

		return result;
	}
	
	/**
	 * 전자결재G 기록물철 소기능 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTaskSubCategory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getTaskSubCategory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getTaskSubCategory started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String cateCode = request.getParameter("cateCode");
		String strType = request.getParameter("strType");
		String result = ezApprovalGService.getTaskSubCategory(deptCode, companyID, cateCode, strType, userInfo.getTenantId());
		
		logger.debug("getTaskSubCategory ended.");

		return result;
	}
	
	/**
	 * 전자결재G 기록물철 소기능(소분류) 별 단위업무정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTaskInSubCategory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getTaskInSubCategory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getTaskInSubCategory started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String cateCode = request.getParameter("cateCode");
		String strType = request.getParameter("strType");
		String result = ezApprovalGService.getTaskInSubCategory(deptCode, companyID, cateCode, strType, userInfo.getPrimary(), userInfo.getTenantId());
		
		logger.debug("getTaskInSubCategory ended.");
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getCabinetSimpleList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetSimpleList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getCabinetSimpleList started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("companyID");
		String processDeptCode = request.getParameter("processDeptCode");
		String productionYear = request.getParameter("produceYear");
		String taskCode = request.getParameter("taskCode");
		String flag = request.getParameter("flag");
		String langType = request.getParameter("langType");
		
		String result = ezApprovalGService.getSimpleCabinetList(companyID, processDeptCode, productionYear, taskCode, flag, langType, userInfo.getTenantId());
		logger.debug("getCabinetSimpleList ended.");
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 단위업무 검색 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/findTask.do")
	public String findTask() throws Exception{
		return "ezApprovalG/apprGFindTask";
	}
	
	/**
	 * 전자결재G 기록물철 단위업무 검색 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/findTaskList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String findTaskList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptCode = request.getParameter("deptCode");
		String title = request.getParameter("title");
		String code = request.getParameter("code");
		String flag = request.getParameter("flag");
		String companyID = request.getParameter("companyID");
		String langType = request.getParameter("langType");
		String pageSize = request.getParameter("pageSize");
		String pageNO = request.getParameter("pageNO");
		String result = ezApprovalGService.findTask(deptCode, title, code, flag, companyID, langType, pageSize, pageNO, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 의견버튼 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprOpinion.do")
	public String aprOpinion(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String susinAdmin = "";
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGaprOpinion";
	}
	
	/**
	 * 전자결재G 기안 의견리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/opinionRequest.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String opinionRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getOpinionInfo(docID, "CAPR", "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 의견삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/opinionDel.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String opinionDel(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.deleteOpinionInfo(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 의견저장 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/opinionSave.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String opinionSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlDom) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document docXML = commonUtil.convertStringToDocument(xmlDom);
		String result = ezApprovalGService.updateOpinionInfo(docXML, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}

	/**
	 * 전자결재G 기안 첨부 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprAttach.do")
	public String aprAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String formID = request.getParameter("formID");
		String docID = request.getParameter("docID");
		String draftFlag = request.getParameter("draftFlag");
		String serverName = userInfo.getServerName();
		String susinAdmin = "";
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String formList = ezApprovalGService.getOptionInfo("A36", "007", userInfo, "CODE");
		String poptExt = ezApprovalGService.getOptionInfo("A39", "001", userInfo, "CODE");
		String maxSize = ezApprovalGService.getOptionInfo("A39", "002", userInfo, "CODE");
		String isBody = "";

		if (!formList.replace(formID, "").equals(formList)) {
			isBody = "YES";
		}
		
		model.addAttribute("formID", formID);
		model.addAttribute("docID", docID);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("serverName", serverName);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("poptExt", poptExt);
		model.addAttribute("maxSize", maxSize);
		model.addAttribute("isBody", isBody);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGaprAttach";
	}
	
	/**
	 * 전자결재G 기안 첨부업로드 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/upload.do")
	public String upload(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, MultipartHttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		MultipartFile multilFile = request.getFile("file1");
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		String companyID = request.getParameter("compid");
		String docID = request.getParameter("docid");
		String fileAttachSN = request.getParameter("attachsn");
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String oldYear = ezApprovalGService.getDocHrefYear(docID, companyID, userInfo.getTenantId());
		String fileName = multilFile.getOriginalFilename();
		String resultUpload = "";
		String fileLocation = "";
		int fileSize = (int) multilFile.getSize();
		int maxSize = 0;
		
		if (request.getParameter("maxsize") != null) {
			maxSize = Integer.parseInt(request.getParameter("maxsize"));
		}
		
		String upd = dirPath + companyID + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator;
		String tempUpd = dirPath + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator;
		File uFile = new File(upd);
		File tFile = new File(tempUpd);
		
		if (uFile.isDirectory()) {
			uFile.mkdir();
		}
		
		if (!tFile.isDirectory()) {
			tFile.mkdirs();
		}
		
		if (!uFile.isDirectory()) {
			uFile.mkdirs();
		}
		if (fileName.indexOf("\\") > -1) {
			fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
		}
		
		String fileAttachFormatSN = "00000" + fileAttachSN;
		fileAttachFormatSN = fileAttachFormatSN.substring(fileAttachFormatSN.length() - 4, fileAttachFormatSN.length());
		
		String saveFileName = docID + fileAttachFormatSN + fileName;
		
		if (fileSize > maxSize) {
			resultUpload = "overflow";
		} else {
			if (useExtension.indexOf(fileName.substring(fileName.lastIndexOf(".") + 1)) == -1 && !useExtension.equals("*")) {
				resultUpload = "denied";
			} else {
				writeUploadedFile(multilFile, saveFileName, tempUpd);
				fileLocation = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator + saveFileName;
				resultUpload = "true";
			}
		}
		
		model.addAttribute("resultUpload", resultUpload);
		model.addAttribute("fileLocation", fileLocation);
		model.addAttribute("fileName", fileName);
		model.addAttribute("fileSize", fileSize);
		
		return "ezApprovalG/apprGupload";
	}
	
	/**
	 * 전자결재G 기안 첨부명,쪽수 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprAttachName.do")
	public String aprAttachName(){
		return "ezApprovalG/apprGaprAttachName";
	}
	
	/**
	 * 전자결재G 기안 첨부리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/attachRequest.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String attachRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getAttachFileInfo(docID, "ING", "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());

		return result;
	}
	
	/**
	 * 전자결재G 기안 첨부삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/deleteServerFile.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String deleteServerFile(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String rtnVal = "";
		String docID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String attachSN = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String fileName = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String upd = dirPath + userInfo.getCompanyID() + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator;
		String fileAttachFormatSN = "00000" + attachSN;
		fileAttachFormatSN = fileAttachFormatSN.substring(fileAttachFormatSN.length() - 4);
		
		String fileSpec = upd + docID + fileAttachFormatSN + fileName;
		
		if (new File(fileSpec).exists()) {
			deleteFile(fileSpec);
			rtnVal = "TRUE";
		} else {
			rtnVal = "FALSE";
		}
		
		return rtnVal;
	}
	
	/**
	 * 전자결재G 기안 첨부히스토리 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/updateAttachHistory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String updateAttachHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String attachSN = request.getParameter("attachSN");
		String tempUserID = request.getParameter("userID");
		String tempUserName = request.getParameter("userName");
		String tempUserName2 = request.getParameter("userName2");
		String tempUserJobTitle = request.getParameter("userJobTitle");
		String tempUserJobTitle2 = request.getParameter("userJobTitle2");
		String tempUserDeptID = request.getParameter("userDeptID");
		String tempUserDeptName = request.getParameter("userDeptName");
		String tempUserDeptName2 = request.getParameter("userDeptName2");
		String modifyFlag = request.getParameter("modifyFlag");
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.updateHistoryForAttach(docID, attachSN, tempUserID, tempUserName, tempUserName2, tempUserJobTitle, tempUserJobTitle2, 
																  tempUserDeptID, tempUserDeptName, tempUserDeptName2, modifyFlag, dirPath, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 첨부저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprAttachSave.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprAttachSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		for (int k = 0; k < xmlDom.getElementsByTagName("DATA1").getLength(); k++) {
			String fileDocID = xmlDom.getElementsByTagName("DATA3").item(k).getTextContent();
			String oldYear = ezApprovalGService.getDocHrefYear(fileDocID, userInfo.getCompanyID(), userInfo.getTenantId());
			String upd = dirPath + userInfo.getCompanyID() + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(fileDocID) + commonUtil.separator;
			String fileName = xmlDom.getElementsByTagName("DATA1").item(k).getTextContent().split("/")[xmlDom.getElementsByTagName("DATA1").item(k).getTextContent().split("/").length - 1];
			
			File filePath = new File(dirPath);
		        if (!filePath.exists()) {
		        	filePath.mkdirs();
		        }
			File file = new File(dirPath + userInfo.getCompanyID() + commonUtil.separator + "tempUploadFile" + commonUtil.separator + fileName);
			
			if (file.exists()) {
				FileUtils.moveFile(file, new File(upd + fileName));
			} else {
				file.mkdirs();
			}
			
			xmlDom.getElementsByTagName("DATA1").item(k).setTextContent(commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(fileDocID) + commonUtil.separator + fileName);
		}
		String result = ezApprovalGService.updateAttachFileInfo(xmlDom, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 첨부삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/attachRemove.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String attachRemove(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.deleteAttachFileInfo(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 첨부다운 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/downloadAttach.do")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String docStatus = request.getParameter("docStatus");
		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
		String realPath = commonUtil.getRealPath(request);
		String result = "";
		
		if (docStatus != null && (docStatus.toUpperCase().equals("APR") || docStatus.toUpperCase().equals("TMP"))) {
			if (docID != null && !docID.equals("")) {
				String checkMode = "";
				
				if (docStatus.toCharArray().equals("TMP")) {
					checkMode = "TMP";
				} else {
					checkMode = "REC";
				}
				
				Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), checkMode, userInfo.getCompanyID(), userInfo.getTenantId());
				
				if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
					result = "NOTPERMISSION";
				}
			}
		} else if (docStatus != null && docStatus.toUpperCase().equals("END")) {
			String accessInfo = config.getProperty("config.UserInfo_ApprovalG_VIEW");
			String pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
			
			if (!pass.equals("<RESULT>TRUE</RESULT>")) {
				result = "NOTPERMISSION";
			}
		}

		if (fileName == null || fileName.equals("")) {
			fileName = filePath.substring(filePath.lastIndexOf("/") + 1); 
		}
		
		if (!result.equals("NOTPERMISSION")) {
			downFile(request, response, realPath + filePath, fileName);
		}
	}
	
	/**
	 * 전자결재G 기안 문서첨부 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprCabinetAttach.do")
	public String aprCabinetAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String draftflag = request.getParameter("draftFlag");
		
		model.addAttribute("draftFlag", draftflag);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGaprCabinetAttach";
	}
	
	/**
	 * 전자결재G 기안 문서첨부 헤더정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getLVHeaderInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getLVHeaderInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String listFlag = request.getParameter("listFlag");
		String listType = request.getParameter("listType");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.getListInfoXml(listFlag, listType, companyID, userInfo.getLang(), userInfo);
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 진행율 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/showProgress.do")
	public String showProgress(HttpServletRequest request, Model model){
		String fileInfo = request.getParameter("fileInfo");
		
		model.addAttribute("fileInfo", fileInfo);
		
		return "ezApprovalG/apprGshowProgress";
	}
	
	@RequestMapping(value = "/ezApprovalG/getTransList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getTransList() throws Exception{
		//TODO: 닷net버전이 미구현 된거같음 미구현 + 사용안함
		return "";
	}
	
	/**
	 * 전자결재G 기안 문서첨부 문서리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getRecordList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getRecordList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, @RequestBody String xmlDom) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlDom);
		String result = ezApprovalGService.getRecordList(doc, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 문서첨부 검색 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/searchRec.do")
	public String searchRec(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGsearchRec";
	}
	
	/**
	 * 전자결재G 기안 문서첨부 코드리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getCodeList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCodeList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.getCodeInfo(companyID, userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}

	/**
	 * 전자결재G 기안 문서첨부 업무담당자 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/selectUser.do")
	public String selectUser() throws Exception{
		return "ezApprovalG/apprGselectUser";
	}
	
	/**
	 * 전자결재G 기안 문서첨부 문서첨부정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getAttachInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAttachInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getAttachDocInfo(docID, "ING", "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}

	/**
	 * 전자결재G 기안 문서첨부 업무담당자여부 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/iSCabCharger.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String iSCabCharger(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String cabClassNo = request.getParameter("cabClassNo");
		String userID = request.getParameter("userID");
		String result = ezApprovalGService.isCabCharger(companyID, cabClassNo.trim(), userID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 문서첨부 업데이트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/updateDocAttach.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String updateDocattach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlDom) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlDom);
		String result = ezApprovalGService.updateAttachDocInfo(doc, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}

	/**
	 * 전자결재G 기안 문서첨부 삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delAttachDoc.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delAttachDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.deleteAttachDocInfo(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 문서보기 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/contDocView.do")
	public String contDocView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String susinAdmin = "";
		String endDir = "";
		String signCheck = "";
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("orgDocID");
		String formID = request.getParameter("formID");
		String title = request.getParameter("title");
		
		if(orgDocID == null){
			orgDocID ="";
		}
		if (!orgDocID.equals("") && orgDocID!=null) {
			endDir = String.valueOf(Integer.parseInt(orgDocID) % 1000);
		}
		
		String accessInfo = config.getProperty("config.UserInfo_ApprovalG_VIEW");
		String pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		if (pass.equals("<RESULT>TRUE</RESULT>")) {
			if (docHref.trim().equals("") || docHref.indexOf("/1000/") >= 0 || docHref.split("/").length == 1) {
				String strXML = ezApprovalGService.getDocInfo(docID, "END", "Href", userInfo.getCompanyID(), userInfo.getTenantId());
				Document resultXML = commonUtil.convertStringToDocument(strXML);
				
				if (resultXML.getElementsByTagName("HREF").item(0) != null && !resultXML.getElementsByTagName("HREF").item(0).getTextContent().trim().equals("")) {
					docHref = resultXML.getDocumentElement().getTextContent();
				}
			}
			
			String readRecXML = "<PARAMETER><DOCID>" + makeXMLString(docID) +
                    "</DOCID><USERID>" + makeXMLString(userInfo.getId()) +
                    "</USERID><USERNAME>" + makeXMLString(userInfo.getDisplayName1()) +
                    "</USERNAME><USERTITLE>" + makeXMLString(userInfo.getTitle1()) +
                    "</USERTITLE><DEPTCODE>" + makeXMLString(userInfo.getDeptID()) +
                    "</DEPTCODE><DEPTNAME>" + makeXMLString(userInfo.getDeptName1()) +
                    "</DEPTNAME><COMPANYID>" + makeXMLString(userInfo.getCompanyID()) +
                    "</COMPANYID><USERNAME2>" + makeXMLString(userInfo.getDisplayName2()) +
                    "</USERNAME2><USERTITLE2>" + makeXMLString(userInfo.getTitle2()) +
                    "</USERTITLE2><DEPTNAME2>" + makeXMLString(userInfo.getDeptName2()) +
                    "</DEPTNAME2></PARAMETER>";
			ezApprovalGService.saveRecReadHist(readRecXML, userInfo.getTenantId());
			String rtnXML = ezApprovalGService.getDocInfo(docID, "END", "SignCheck", userInfo.getCompanyID(), userInfo.getTenantId());
			Document resultXML = commonUtil.convertStringToDocument(rtnXML);
			
			if (resultXML.getElementsByTagName("SIGNCHECK").item(0) != null && !resultXML.getElementsByTagName("SIGNCHECK").item(0).getTextContent().trim().equals("")) {
				signCheck = resultXML.getElementsByTagName("SIGNCHECK").item(0).getTextContent().trim();
			}
		}
		
		model.addAttribute("editor", editor);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("signCheck", signCheck);
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("listSusin", listSusin);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("endDir", endDir);
		model.addAttribute("formID", formID);
		model.addAttribute("title", title);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pass", pass);
		
		return "ezApprovalG/apprGcontDocView";
	}
	
	public String makeXMLString(String orgString) throws Exception{
		return orgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}
	
	/**
	 * 전자결재G 부서에수발신담당자체크 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/receiverChk.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String receiverChk(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String rtnVal = ezApprovalGService.receiverChk(deptID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return rtnVal;
	}
	
	/**
	 * 전자결재G 대결재자정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/checkAprPerson.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String checkAprPerson(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String msg = request.getParameter("msg");
		Document xmlDoc = commonUtil.convertStringToDocument(ezApprovalGService.getEA5Value(msg, userInfo.getTenantId(), userInfo.getCompanyID()));
		String ex5 = "", langType = "", name = "";
		
		if (!userInfo.getPrimary().equals("1")) {
			langType = "2";
		}
		
		for (int k = 0; k < xmlDoc.getElementsByTagName("EXTENSIONATTRIBUTE5").getLength(); k++) {
			ex5 = xmlDoc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(k).getTextContent();
			
			String[] arry = ex5.split(":");
			
			name = ezOrganService.getPropertyValue(arry[0], "DISPLAYNAME" + langType, userInfo.getTenantId());
			xmlDoc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(k).setTextContent(xmlDoc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(k).getTextContent().replace(arry[1], name));
		}
		
		return commonUtil.convertDocumentToString(xmlDoc);
	}
	
	/**
	 * 전자결재G 기안 기록물철 즐겨찾기 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getMyTaskCode.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getMyTaskCode(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String result = ezApprovalGService.getMyTaskCode(userID, deptID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 분리첨부 추가 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/insSepAttach.do")
	public String insSepAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGinsSepAttach";
	}
	
	/**
	 * 전자결재G 기안 즐겨찾기 추가 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setMyTaskCode.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setMyTaskCode(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("setMyTaskCode started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabinetID = request.getParameter("cabinetID");
		String taskCode = request.getParameter("taskCode");
		String type = request.getParameter("type");
		String result = ezApprovalGService.setMyTaskCode(userInfo.getId(), userInfo.getDeptID(), cabinetID, taskCode, type, userInfo.getCompanyID(), userInfo.getTenantId());
		logger.debug("setMyTaskCode ended.");

		return result;
	}
	
	/**
	 * 전자결재G 기안 철정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getCabinetInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabinetID = request.getParameter("cabinetID");
		String companyID = request.getParameter("companyID");
		String strType = request.getParameter("strType");
		String result = ezApprovalGService.getCabinetInfo(cabinetID, companyID, strType, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 분리첨부 등록 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/regSepAttach.do", method = RequestMethod.GET)
	public String regSepAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGregSepAttach";
	}
	
	/**
	 * 전자결재G 기안 분리첨부 등록 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/regSepAttach.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String regSepAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String para) throws Exception{
		logger.debug("regSepAttach started");
		userInfo = commonUtil.aprUserInfo(loginCookie);

		Document doc = commonUtil.convertStringToDocument(para);
		String result = ezApprovalGService.registerSepAttach(doc, userInfo.getTenantId(), userInfo.getLocale());
		logger.debug("regSepAttach result = " + result);
		logger.debug("regSepAttach ended");

		return result;
	}
	
	/**
	 * 전자결재G 기안 인쇄 호출 Method
	 */
	@RequestMapping(value = "ezApprovalG/ezApprovalPrint")
	public String ezApprovalPrint() throws Exception{
		return "ezApprovalG/apprGezApprovalPrint";
	}
	
	/**
	 * 전자결재G 기안 인쇄상세질문 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezprtQuestion.do")
	public String ezprtQuestion(HttpServletRequest request, Model model) throws Exception{
		String opinion = request.getParameter("opinion");
		String attach = request.getParameter("attach");
		
		model.addAttribute("attach", attach);
		model.addAttribute("opinion", opinion);
		
		return "ezApprovalG/apprGezprtQuestion";
	}
	
	/**
	 * 전자결재G 기안 변경내역 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprHistory.do")
	public String ezAprHistory(HttpServletRequest request, Model model) throws Exception{
		String docID = request.getParameter("docID");
		
		model.addAttribute("docID", docID);
		
		return "ezApprovalG/apprGezAprHistory";
	}
	
	/**
	 * 전자결재G 기안 변경내역 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getDocHistory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getDocHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getHistoryForDoc(docID, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 변경내역 결재선탭 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getLineHistory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getLineHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getHistoryForLine(docID, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 변경내역 첨부탭 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getAttachHistory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAttachHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getHistoryForAttach(docID, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안 변경내역 결재문서탭 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getLineHistoryDetail.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getLineHistoryDetail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String modifySN = request.getParameter("changeSN");
		String result = ezApprovalGService.getHistoryForLineDetail(docID, modifySN, "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 임시보관 삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/removeTMPDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String removeTMPDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = docID.split("@")[0];
		String sn = docID.split("@")[1];
		String path = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.deleteTmpDocInfo(userID, sn, path, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 임시보관 저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/saveTmpFile.do", produces = "text/xml;charset=utf8")
	@ResponseBody
	public String saveTmpFile(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String formText = request.getParameter("html");
		String path = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String ret = "";
		InputStream stream = null;
		OutputStream bos = null;
		
		try {
		File file = new File(path + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + "1000");
		File file1 = new File(path + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docID));

		if (!file.exists()) {
			file.mkdirs();
		}
		
		if (!file1.exists()) {
			file1.mkdir();
		}
		
		String tmpPath = path + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docID);
		
		File file2 = new File(tmpPath + commonUtil.separator + "TMP");
		
		if (!file2.exists()) {
			file2.mkdirs();
		}
		
		String saveFileName = tmpPath + commonUtil.separator + "TMP" + commonUtil.separator + docID + ".mht";
		
			stream = new ByteArrayInputStream(formText.getBytes("UTF-8"));
			
			bos = new FileOutputStream(saveFileName);
			
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
			ret ="TRUE";
		} catch (Exception e) {
			ret = "FALSE";
		} finally {
		   if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		   if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
	    
		return ret;
	}
	
	/**
	 * 전자결재G 기안 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doDraft.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String doDraft(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String docID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		xmlDom.getDocumentElement().getChildNodes().item(6).setTextContent(commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + 
				commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator + xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent() + ".mht");
		String aprState = "003";
		
		if (xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent().equals("000")) {
			aprState = "000";
		} else if (xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent().equals("001")) {
			aprState = "001";
			xmlDom.getDocumentElement().getChildNodes().item(6).setTextContent(commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + 
				commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator + "TMP" + commonUtil.separator + xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent() + ".mht");
		}
		
		String result = ezApprovalGService.doProcess(aprState, xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent(), 
				xmlDom.getElementsByTagName("PUSERNAME2").item(0).getTextContent(), dirPath, xmlDom.getDocumentElement().getChildNodes().item(22).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent(), xmlDom, "", userInfo.getCompanyID(), userInfo.getLang(), userInfo); 
		
		return result;
	}
	
	/**
	 * 전자결재G 첨부사이즈 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getExtTotalAttachSize.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getExtTotalAttachSize(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getExtTotalAttachSizestarted.");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getTotalAttachSize(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("getExtTotalAttachSize result =" + result );
		logger.debug("getExtTotalAttachSize started.");

		return result;
	}
	
	/**
	 * 전자결재G 결재선 체크 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/checkAprLines.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String checkAprLines(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.chkAprLines(doc, userInfo.getLang(), userInfo);
		
		return result;
	}
	
	/**
	 * 전자결재G 결재선 체크 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/checkDeptLines.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String checkDeptLines(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.chkDeptLines(doc, userInfo.getCompanyID(), userInfo.getLang(), userInfo);
		
		return result;
	}
	
	/**
	 * 전자결재G 얼럿트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprAlertLong.do")
	public String ezAprAlertLong() throws Exception{
		return "ezApprovalG/apprGezAprAlertLong";
	}
	
	/**
	 * 전자결재G 서명 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getSignRequest.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSignRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String result = ezOrganService.getPropertyValue(userID, "extensionAttribute3", userInfo.getTenantId());
		if (result != null) {
			String[] signText = result.split(";");
			int tempLength = signText.length;
			StringBuilder resultXML = new StringBuilder("<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t433", locale) + "</NAME><WIDTH>140</WIDTH></HEADER></HEADERS><ROWS>");
			
			for (int k = 0; k < tempLength; k++) {
				if (!signText[k].equals("")) {
					resultXML.append("<ROW><CELL><VALUE>" + messageSource.getMessage("ezApprovalG.t434", locale) + k + "</VALUE><DATA1>" + signText[k] + "</DATA1></CELL></ROW>");
				}
			}
			
			resultXML.append("</ROWS></LISTVIEWDATA>");
			
			return resultXML.toString();
		} else {
			StringBuilder resultXML = new StringBuilder("<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t433", locale) + "</NAME><WIDTH>140</WIDTH></HEADER></HEADERS><ROWS>");
			
			resultXML.append("</ROWS></LISTVIEWDATA>");
			
			return resultXML.toString();
		}
	}
	
	/**
	 * 전자결재G 서명 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprSign.do")
	public String aprSign(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userInfoApprovalG = config.getProperty("config.UserInfo_ApprovalG");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userInfoApprovalG", userInfoApprovalG);
		
		return "ezApprovalG/apprGaprSign";
	}
	
	/**
	 * 전자결재G 서명저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/approvalGSign.do")
	public void approvalGSign(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("approvalGSign started");

		userInfo = commonUtil.aprUserInfo(loginCookie);

		String fileName = request.getParameter("fileName");
		String signatureDir = commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId());
		
		fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
		signatureDir = signatureDir + commonUtil.separator + fileName.split("_")[0];
		
		String result = signatureDir + commonUtil.separator + fileName;

		ezCommonService.responseAttach(result, fileName, true, request, response);
		logger.debug("approvalGSign ended");

	}
	
	/**
	 * 전자결재G 의견개수 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getOpinionCount.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getOpinionCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getOpinionCount started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String ingFlag = request.getParameter("chkFlag");
		String result = ezApprovalGService.getOpinionCount(docID, userID, ingFlag, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		result = "<RESULT>" + result + "</RESULT>";
		logger.debug("getOpinionCount result=" + result);
		logger.debug("getOpinionCount ended");
		return result;
	}
	
	/**
	 * 전자결재G 파일저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/saveFile.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveFile(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String formText = request.getParameter("html");
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String path = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		String saveFileName = "";
		String saveDir = "";
		String ret = "";
		String realPath = commonUtil.getRealPath(request);
		InputStream stream = null;
		OutputStream bos = null;
		
		saveFileName = realPath + path + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator + docID + ".mht"; 
		saveDir = realPath + path + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docID);
		try {
			
		File file = new File(saveDir);
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		
		

			stream = new ByteArrayInputStream(formText.getBytes("UTF-8"));
			
			bos = new FileOutputStream(saveFileName);
			
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
			ret = "TRUE";
		} catch (Exception e) {
			ret = "FALSE";
		} finally {
			   if (bos != null) {
					try {
					    bos.close();
					} catch (Exception ignore) {
						logger.debug("IGNORED: {}", ignore.getMessage());
					}
			    }
			   if (stream != null) {
					try {
						stream.close();
					} catch (Exception ignore) {
						logger.debug("IGNORED: {}", ignore.getMessage());
					}
			    }
		}
	    
		return ret;
	}
	
	/**
	 * 전자결재G 결재선이력 업뎃 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/updateLineHistory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String updateLineHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("updateLineHistory started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String userName = request.getParameter("userName");
		String userName2 = request.getParameter("userName2");
		String userJobTitle = request.getParameter("userJobTitle");
		String userJobTitle2 = request.getParameter("userJobTitle2");
		String userDeptID = request.getParameter("userDeptID");
		String userDeptName = request.getParameter("userDeptName");
		String userDeptName2 = request.getParameter("userDeptName2");
		String chkFlag = request.getParameter("chkFlag");
		
		String result = ezApprovalGService.updateHistoryForLine(docID ,userID, userName, userName2, userJobTitle, userJobTitle2, userDeptID, userDeptName, userDeptName2, chkFlag, userInfo.getCompanyID(), userInfo.getTenantId());
		logger.debug("docID = " + docID + "userID = " + userID + "userName = " + userName + "userName2 = " + userName2 + "userJobTitle = " + userJobTitle + "userJobTitle2 = " + userJobTitle2 + "userDeptID = " + userDeptID + "userDeptName = " + userDeptName + "userDeptName2 =" + userDeptName + "chkFlag = " + chkFlag);
		logger.debug("updateLineHistory result = " + result);

		logger.debug("updateLineHistory ended");

		return result;
	}
	
	/**
	 * 전자결재G 결재시 암호입력 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezchkPasswd.do")
	public String ezchkPasswd(Model model) throws Exception{
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		model.addAttribute("publicModulus", publicModulus);
        model.addAttribute("publicExponent", publicExponent);
        
		return "ezApprovalG/apprGezchkPasswd";
	}
	
	/**
	 * 전자결재G 결재시 암호입력 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezchkPasswdall.do")
	public String ezchkPasswdall(Model model) throws Exception{
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		
		return "ezApprovalG/apprGezchkPasswdall";
	}
	
	/**
	 * 전자결재G 결재시 암호입력 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/chkPasswd.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String chkPasswd(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = "";
		String orgPassword = "";
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		String eUserID = request.getParameter("userID");
		String ePassWd = request.getParameter("passWd");
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String dPassWd = EgovFileScrty.decryptRsa(pk, ePassWd);
		String dUserID = EgovFileScrty.decryptRsa(pk, eUserID);
		String password = EgovFileScrty.encryptPassword(dPassWd, dUserID);
		String flag = ezApprovalGService.getApprovalPWD(dUserID, userInfo.getTenantId(), userInfo.getCompanyID());

		if (flag != null) {
			if (flag.equals("Y")) {
				String pwdType = ezApprovalGService.getApprovalPWD2(dUserID, userInfo.getTenantId(), userInfo.getCompanyID());
				
				if (pwdType.equals("L")) {
					orgPassword = ezOrganService.getEncPassword(dUserID, userInfo.getTenantId());
					
					if (orgPassword.trim().equals(password)) {
						result = "1";
					}
				} else {
					String dbPassword = ezApprovalGService.getApprovalPWD1(dUserID, userInfo.getTenantId(), userInfo.getCompanyID());
					
					if (dbPassword.trim().equals(password)) {
						result = "1";
					}
				}
			} else {
				orgPassword = ezOrganService.getEncPassword(dUserID, userInfo.getTenantId());
				
				if (orgPassword.trim().equals(password)) {
					result = "1";
				}
			}
		} else {
			orgPassword = ezOrganService.getEncPassword(dUserID, userInfo.getTenantId());
			
			if (orgPassword.trim().equals(password)) {
				result = "1";
			}
		}
		
		if (result.equals("1")) {
			return "true";
		} else {
			return "False";
		}
	}
	
	/**
	 * 전자결재G 결재화면 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/approvui.do")
	public String approvui(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		String crossEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String susinAdmin = "";
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String docID = request.getParameter("docID");
		String uID = request.getParameter("id");
		String name = request.getParameter("name");
		String deptID = request.getParameter("deptID");
		String allFlag = request.getParameter("allFlag");
		String tempUserID = userInfo.getId();
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String dirPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator;
		String docDir = docID.substring(docID.length() - 3);
		String approvalPWD = ezApprovalGService.getApprovalPWD(uID, userInfo.getTenantId(), userInfo.getCompanyID());
		
		if (docDir.substring(0, 1).equals("0")) {
			docDir = docDir.substring(docDir.length() - 2);
		} else if (docDir.substring(0, 2).equals("00")) {
			docDir = docDir.substring(docDir.length() - 1);
 		} else if (docDir.equals("000")) {
			docDir = "0";
		}
		
		dirPath = dirPath + docDir + "." + docID + ".mht";
		
		if (!allFlag.equals("1") && !allFlag.equals("2")) {
			allFlag = "0";
		}
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optIsSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		String optJunKyukInfo = ezApprovalGService.getOptionInfo("A32", "001", userInfo, "CODE");
		
		if (docID != null && !docID.equals("")) {
			String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1", tenantID, userInfo.getOffset());
			String[] proxyUserArray = proxyUser.split(",");
			boolean checkPermission = true;
			
			if (proxyUserArray.length > 1) {
				String docList = ezApprovalGService.getAprLineInfoDB(docID, "1", "", "", userInfo.getCompanyID(), userInfo.getTenantId());
				
				Document docXML = commonUtil.convertStringToDocument(docList);
				
				for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
					if (docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().equals("002")) {
						String curAprUserID = docXML.getElementsByTagName("ORGUSERID").item(k).getTextContent();
						
						for (int j = 0; j < proxyUserArray.length; j++) {
							if (curAprUserID.equals(proxyUserArray[j].trim().substring(1, proxyUserArray[j].trim().length() - 1))) {
								checkPermission = false;
								break;
							}
						}
					}
				}
			}
			
			if (checkPermission) {
				Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "APR", userInfo.getCompanyID(), userInfo.getTenantId());
				
				if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
					return "main/warning";
				}
			}
		}
		
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optIsSplit", optIsSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("optJunKyukInfo", optJunKyukInfo);
		model.addAttribute("uID", uID);
		model.addAttribute("name", name);
		model.addAttribute("deptID", deptID);
		model.addAttribute("dirPath", dirPath);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("docID", docID);
		model.addAttribute("tempUserID", tempUserID);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("allFlag", allFlag);
		model.addAttribute("oldYear", oldYear);
		model.addAttribute("tempUserID", tempUserID);
		model.addAttribute("approvalPWD", approvalPWD);
		model.addAttribute("crossEditor", crossEditor);
		
		return "ezApprovalG/apprGapprovui";
	}
	
	/**
	 * 전자결재G 결재화면 결재내용 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/approvUIcontent.do")
	public String approvUIcontent(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		model.addAttribute("editor", editor);
		
		return "ezApprovalG/apprGapprovUIcontent";
	}
	
	/**
	 * 전자결재G 결재정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getApproveDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getApproveDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getApproveDocInfo(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());

		return result;
	}
	
	/**
	 * 전자결재G 결재문서정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getDocInfo(docID, "APR", "ALL", userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 마지막의견내용 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getLastOpinonCotent.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getLastOpinonCotent(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getLastOpinionContent(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return "<PARA><Row>" + result + "</Row></PARA>";
	}

	/**
	 * 전자결재G 사인정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getSignInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSignInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getSignInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());

		Document xmlResult = commonUtil.convertStringToDocument(result);
		
		for (int k = 0; k < xmlResult.getElementsByTagName("CONTENT").getLength(); k++) {
			String strCont = xmlResult.getElementsByTagName("CONTENT").item(k).getTextContent().toLowerCase();
			
			if (strCont.equals("b1") || strCont.equals("b2") || strCont.equals("b3") || strCont.equals("b4") || strCont.equals("b5") || strCont.equals("b6") || strCont.equals("b7") || strCont.equals("b8") || strCont.equals("b9") || strCont.equals("b10") || strCont.equals("b11") || strCont.equals("b12")) {
				xmlResult.getElementsByTagName("CONTENT").item(k).setTextContent(messageSource.getMessage("ezApprovalG." + strCont, locale));
			}
		}
		
		result = commonUtil.convertDocumentToString(xmlResult);
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물번호 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getCabinetSN.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetSN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getCabinetSN started");
	
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String result = ezApprovalGService.getCabinetNum(deptID, "", userInfo.getCompanyID(), docID, userInfo.getLang(), userInfo.getTenantId());
		logger.debug("docID = " + docID + "deptID = " + deptID);

		logger.debug("getCabinetSN result = " + result);
		logger.debug("getCabinetSN ended");

		return result;
	}
	
	/**
	 * 전자결재G 기록물번호롤백 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/rollbackCabinetSN.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String rollbackCabinetSN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String sn = request.getParameter("docNumber");
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.rollbackCabinetNum(deptID, "", sn, userInfo.getCompanyID(), docID, userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 사인날짜 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getSignDate.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSignDate() throws Exception{
		String month = EgovDateUtil.getTodayTime().substring(5, 7);
		String day = EgovDateUtil.getTodayTime().substring(8, 10);
		String gyulJaeDate = month + "/" + day;
		
		return gyulJaeDate;
	}
	
	/**
	 * 전자결재G 사인정보 저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setSignInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setSignInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.updateSignInfo(xmlDom, userInfo.getCompanyID(), "SET", userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 결재 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doApprov.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String doApprov(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.doProcess("003", xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(43).getTextContent(), dirPath, xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent(), xmlDom, xmlDom.getDocumentElement().getChildNodes().item(26).getTextContent(), userInfo.getCompanyID(), userInfo.getLang(),userInfo);
		
		return result;
	}
	
	/**
	 * 전자결재G 반송 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doBansongApprov.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String doBansongApprov(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.doProcess("004", xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(43).getTextContent(), dirPath, xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent(), xmlDom, "", userInfo.getCompanyID(), userInfo.getLang(), userInfo);
		
		return result;
	}
	
	/**
	 * 전자결재G 보류 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doBoryuApprov.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String doBoryuApprov(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.doProcess("005", xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(43).getTextContent(), dirPath, xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent(), 
				xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent(), xmlDom, "", userInfo.getCompanyID(), userInfo.getLang(), userInfo);
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/sendAckforExch.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String sendAckforExch() throws Exception{
		//TODO: aspx 파일 존재안함
		return "";
	}
	
	/**
	 * 전자결재G 회수 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doCanCelYN.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String doCanCelYN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String tempUserID = request.getParameter("userID");
 		String result = ezApprovalGService.getCallBackYN(docID, tempUserID, userInfo.getCompanyID(), userInfo.getTenantId());
		
 		return result;
	}
	
	/**
	 * 전자결재G 강제회수 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doForceCancelYN.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String doForceCancelYN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String tempUserID = request.getParameter("userID");
		String result = ezApprovalGService.getCallBackYNForceLine(docID, tempUserID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 문서보기 내용 호출 Method
	 * 
	 */
	@RequestMapping(value = "/ezApprovalG/ConDocViewContent.do")
	public String ConDocViewContent(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		model.addAttribute("editor", editor);
		
		return "ezApprovalG/apprGConDocViewContent";
	}
	
	/**
	 * 전자결재G 첨부파일정보 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/totalSaveFileInfo.do")
	public String totalSaveFileInfo(HttpServletRequest request, Model model) throws Exception{
		String docID = request.getParameter("docID");
		String type = request.getParameter("type");
		
		model.addAttribute("docID", docID);
		model.addAttribute("type", type);
		
		return "ezApprovalG/apprGtotalSaveFileInfo";
	}
	
	/**
	 * 전자결재G 통합문서다운 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getTotalDoc.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getTotalDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		String result = ezApprovalGService.getTotalDownload(docID, mode, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 통합문서다운 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/saveTotalDoc.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String saveTotalDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String realPath = commonUtil.getRealPath(request);
		String docID = xmlDom.getElementsByTagName("PDOCID").item(0).getTextContent().trim();
		String zipFileName = xmlDom.getElementsByTagName("PTITLE").item(0).getTextContent().replace("\\", "").replace("/", "").replace(":", "").replace("?", "").
                replace('"' + "", "").replace("*", "").replace("<", "").replace(">", "").replace("|", "");
		String path = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());;
		String path2 = realPath + commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
		String separators = "\\|\\|\\|";
		String[] fileTypes = xmlDom.getElementsByTagName("PTYPEINFO").item(0).getTextContent().split(separators);
		String[] filePaths = xmlDom.getElementsByTagName("PPATHINFO").item(0).getTextContent().split(separators);
		String[] fileNames = xmlDom.getElementsByTagName("PFILEINFO").item(0).getTextContent().split(separators);

		ZipOutputStream zout = null;
		FileInputStream inpStream = null;
		String zipFilePath = null;
		try{
		File sourceDir = new File(realPath + commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID);
		
		if (sourceDir.exists()) {
			sourceDir.delete();
		}
		
		for (int k = 0; k < filePaths.length; k++) {
			String sourcePath = realPath + filePaths[k];
			String targetPath = "";
			String fileName = fileNames[k].replace("\\", "").replace("/", "").replace(":", "").replace("?", "").
	                replace('"' + "", "").replace("*", "").replace("<", "").replace(">", "").replace("|", "");
			
			if (fileTypes[k].equals("ATT")) {
				targetPath = commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID + commonUtil.separator + fileName;
			} else if (fileTypes[k].equals("ATTDOC")) {
				targetPath = commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID + commonUtil.separator + fileName + "." + sourcePath.substring(sourcePath.lastIndexOf(".") + 1); 
			} else {
				targetPath = commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID + commonUtil.separator + fileName + "." + sourcePath.substring(sourcePath.lastIndexOf(".") + 1); 
			}

			sourcePath = path + sourcePath.replace(realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			targetPath = path2 + targetPath.replace(commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId()), "");
			
			String dir = targetPath.substring(0, targetPath.lastIndexOf(commonUtil.separator));
			File file1 = new File(dir);

			if (!file1.exists()) {
				file1.mkdirs();
			}

			File file2 = new File(targetPath);

			if (!file2.exists()) {
				File file3 = new File(sourcePath);
				FileUtils.copyFile(file3, file2);
			}
		}
		
		 zipFilePath = commonUtil.getUploadPath("upload_common.DOCDOWNLOAD", userInfo.getTenantId()) + commonUtil.separator + docID + commonUtil.separator + zipFileName + ".zip";

		byte[] buffer = new byte[1024];

		 zout = new ZipOutputStream(new FileOutputStream(new File(realPath + zipFilePath)));
		zout.setEncoding("EUC-KR");
		
		for (int k = 0; k < filePaths.length; k++) {
			 inpStream = new FileInputStream(new File(realPath + filePaths[k]));
			String fileName = fileNames[k].replace("\\", "").replace("/", "").replace(":", "").replace("?", "").
	                replace('"' + "", "").replace("*", "").replace("<", "").replace(">", "").replace("|", "");

			if (fileName.indexOf("." + filePaths[k].substring(filePaths[k].lastIndexOf(".") + 1)) == -1) {
				fileName = fileName + "." + filePaths[k].substring(filePaths[k].lastIndexOf(".") + 1);
			}
			zout.putNextEntry(new ZipEntry(fileName));

			int length = 0;
			
			while ((length = inpStream.read(buffer)) > 0) {
				zout.write(buffer, 0, length);
			}
		}
		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		} finally {
			if (zout != null) {
				try {
					zout.closeEntry();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
			if (inpStream != null) {
				try {
					inpStream.close();
					zout.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
		return zipFilePath;
	}
	
	/**
	 * 전자결재G 수신처리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getReceivedDocList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getReceivedDocList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String receiveDocMode = request.getParameter("mFlag");
		String pageSize = request.getParameter("pageSize");
		String pageNum = request.getParameter("pageNum");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String searchQuery = request.getParameter("searchQuery");
		String userLang = userInfo.getLang();
		Document xmlDomSub = null;
		
		if (searchQuery.length() > 10) {
			String tempQuery = "";
			String returnQuery = "(1 = 1) ";
			xmlDomSub = commonUtil.convertStringToDocument(searchQuery);
			
			tempQuery = xmlDomSub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
			
			if (tempQuery.indexOf("DOCNO;") != -1) {
				returnQuery += " AND TBL_APRDOCINFO.DOCNO LIKE '%" + xmlDomSub.getElementsByTagName("DOCNO").item(0).getTextContent() + "%' ";
			}
			
			if (tempQuery.indexOf("DOCTITLE;") != -1) {
                returnQuery += " AND TBL_APRDOCINFO.DocTitle LIKE '%" + xmlDomSub.getElementsByTagName("DOCTITLE").item(0).getTextContent() + "%' ";
            }

            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    returnQuery += " AND TBL_APRDOCINFO.WRITERNAME" + userLang + " LIKE '%" + xmlDomSub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                }
            } else {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    returnQuery += " AND TBL_APRDOCINFO.WRITERNAME LIKE '%" + xmlDomSub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                }
            }

            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                    returnQuery += " AND TBL_APRDOCINFO.WriterDeptName" + userLang + " LIKE '%" + xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent() + "%' ";
                }
            } else {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                    returnQuery += " AND TBL_APRDOCINFO.WriterDeptName LIKE '%" + xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent() + "%' ";
                }
            }
            
            if (tempQuery.indexOf("APRSTARTDATE;") != -1) {
            	if (!dbType.equals("mysql")) {
            		returnQuery += " AND TBL_APRRECEIPTPROCESSINFO.PROCESSDATE >= TO_DATE('" + xmlDomSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent()+ " 00:00:01' ,'YYYY-MM-DD HH24:MI:SS') ";
            	} else {
            		returnQuery += " AND TBL_APRRECEIPTPROCESSINFO.PROCESSDATE >= STR_TO_DATE('" + xmlDomSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent()+ " 00:00:01' , '%Y-%m-%d %H:%i:%s') ";
            	}
            }
            
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
            	if (!dbType.equals("mysql")) {
            		returnQuery += " AND TBL_APRRECEIPTPROCESSINFO.PROCESSDATE <= TO_DATE('" + xmlDomSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59' ,'YYYY-MM-DD HH24:MI:SS') "; 
            	} else {
            		returnQuery += " AND TBL_APRRECEIPTPROCESSINFO.PROCESSDATE <= STR_TO_DATE('" + xmlDomSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59' , '%Y-%m-%d %H:%i:%s') "; 

            	}
            }
            
            if (tempQuery.indexOf("FORMID;") != -1) {
                returnQuery += " AND TBL_APRDOCINFO.FormID = '" + xmlDomSub.getElementsByTagName("FORMID").item(0).getTextContent() + "' ";
            }
            
            if (tempQuery.indexOf("KAPR;") != -1) {
                returnQuery += " AND TBL_EXPAPRDOCINFO.keyword LIKE '%" + xmlDomSub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
            }
            
            if (tempQuery.indexOf("KEND;") != -1) {
                returnQuery += " AND TBL_EXPAPRDOCINFO.keyword LIKE '%" + xmlDomSub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
            }
            
            if (tempQuery.indexOf("CAPR;") != -1) {
                returnQuery += " AND TBL_EXPENDAPRDOCINFO.itemcode = '" + xmlDomSub.getElementsByTagName("ITEMCODE").item(0).getTextContent() + "' ";
            }
            
            if (tempQuery.indexOf("CEND;") != -1) {
                returnQuery += " AND TBL_EXPAPRDOCINFO.itemcode = '" + xmlDomSub.getElementsByTagName("ITEMCODE").item(0).getTextContent() + "' ";
            }
            
            if (tempQuery.indexOf("URGENTAPPROVAL;") != -1) {
                returnQuery += " AND TBL_EXPAPRDOCINFO.URGENTAPPROVAL = '" + xmlDomSub.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent() + "' ";
            }
            returnQuery += " AND TBL_APRRECEIPTPROCESSINFO.TENANT_ID =" + userInfo.getTenantId();
            searchQuery = returnQuery;
		}
		
		String result = ezApprovalGService.getReceiveDocList(userID, deptID, receiveDocMode, pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userLang, searchQuery, xmlDomSub, userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 공람정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/gongRamDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String gongRamDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.gongRamDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return "<RESULT>" + result + "</RESULT>";
	}
	
	/**
	 * 전자결재G 수신처 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recevGSusin.do")
	public String recevGSusin(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		String crossEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String docID = request.getParameter("docID");
		String orgDocID = request.getParameter("uOrgID");
		String isReDraft = request.getParameter("isReDraft");
		String draftFlag = request.getParameter("draftFlag");
		String retFlag = request.getParameter("retFlag");
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		String optIsSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");
		
		String dirPath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
		
		if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
			String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
			String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
			
			orgDocFile = dirPath + orgDocFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			docFile = dirPath + docFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), "");
			
			String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
			File file = new File(dir);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			File newFile = new File(docFile);
			
			if (!newFile.exists()) {
				File orgFile = new File(orgDocFile);
				
				FileUtils.copyFile(orgFile, newFile);
			}
		}
		
		if (docID != null && !docID.equals("")) {
			Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "REC", userInfo.getCompanyID(), userInfo.getTenantId());
			
			if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
				return "main/warning";
			}
		}
		
		model.addAttribute("crossEditor", crossEditor);
		model.addAttribute("docID", docID);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("isReDraft", isReDraft);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("retFlag", retFlag);
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optIsSplit", optIsSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("sihangURL", sihangURL);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalPWD", approvalPWD);
		
		return "ezApprovalG/apprGrecevGSusin";
	}
	
	/**
	 * 전자결재G 수신처내용 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recevEndContent.do")
	public String recevEndContent() {
		return "ezApprovalG/apprGrecevEndContent";
	}
	
	/**
	 * 전자결재G 수신처문서 정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getReceiveDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getReceiveDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getReceivedDocInfo(docID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 문서정보 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getDocData.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getDocData(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String flag = request.getParameter("mode");
		String data = request.getParameter("sel");
		String result = ezApprovalGService.getDocInfo(docID, flag, data, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물선택 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/selectCabinet.do")
	public String selectCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String initFlag = request.getParameter("initFlag");
		
		model.addAttribute("initFlag", initFlag);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGselectCabinet";
	}
	
	/**
	 * 전자결재G 문서상태 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getDocState.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getDocState(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String result = ezApprovalGService.getDocRecvState(docID, deptID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 수신수락 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezReceiveAssignUI.do")
	public String ezReceiveAssignUI(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String susinAdmin = "";
		String serverName = userInfo.getServerName();
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", serverName);
		
		return "ezApprovalG/apprGezReceiveAssignUI";
	}
	
	/**
	 * 전자결재G 수신처 지정 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setJijung.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setJijung(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String receiveSN = request.getParameter("receiveSN");
		String processorID = request.getParameter("processorID");
		String processorName = request.getParameter("processorName");
		String processorJobTitle = request.getParameter("processorJobTitle");
		String receivedDeptID = request.getParameter("receivedDeptID");
		String receivedDeptName = request.getParameter("receivedDeptName");
		String docState = request.getParameter("docState");
		String processorName2 = request.getParameter("processorName2");
		String processorJobTitle2 = request.getParameter("processorJobTitle2");
		String receivedDeptName2 = request.getParameter("receivedDeptName2");
		
		String result = ezApprovalGService.setJijung(docID, receiveSN, processorID, processorName, processorJobTitle, receivedDeptID, receivedDeptName, docState, processorName2, processorJobTitle2, receivedDeptName2, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	//잘못만들었지만 쓰일수도있어서 냅둠
//	@RequestMapping(value = "/ezApprovalG/recevG.do")
//	public String recevG(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
//		userInfo = commonUtil.aprUserInfo(loginCookie);
//		
//		String realPath = commonUtil.getRealPath(request);
//		String docID = request.getParameter("docID");
//		String orgDocID = request.getParameter("uOrgID");
//		String isReDraft = request.getParameter("isReDraft");
//		String draftFlag = request.getParameter("draftFlag");
//		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId());
//		
//		String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
//		String optIsSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
//		String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
//		String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", userInfo, "CODE");
//		String dirYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID());
//		String dirPath = realPath + config.getProperty("upload_approvalG.ROOT") + commonUtil.separator;
//		
//		String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID());
//		
//		Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
//		
//		if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
//			String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
//			String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
//			
//			orgDocFile = dirPath + orgDocFile.replace(config.getProperty("upload_approvalG.ROOT"), "");
//			docFile = dirPath + docFile.replace(config.getProperty("upload_approvalG.ROOT"), "");
//			
//			String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
//			File file = new File(dir);
//			
//			if (!file.exists()) {
//				file.mkdirs();
//			}
//			
//			File newFile = new File(docFile);
//			
//			if (!newFile.exists()) {
//				File orgFile = new File(orgDocFile);
//				
//				FileUtils.copyFile(orgFile, newFile);
//			}
//		}
//		
//		if (docID != null && !docID.equals("")) {
//			int cp = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "REC", userInfo.getCompanyID());
//			
//			if (cp <= 0) {
//				return "main/warning";
//			}
//		}
//		
//		model.addAttribute("docID", docID);
//		model.addAttribute("dirYear", dirYear);
//		model.addAttribute("orgDocID", orgDocID);
//		model.addAttribute("isReDraft", isReDraft);
//		model.addAttribute("draftFlag", draftFlag);
//		model.addAttribute("optSignDateFormat", optSignDateFormat);
//		model.addAttribute("optIsSplit", optIsSplit);
//		model.addAttribute("optSplitKind", optSplitKind);
//		model.addAttribute("sihangURL", sihangURL);
//		model.addAttribute("userInfo", userInfo);
//		model.addAttribute("approvalPWD", approvalPWD);
//		
//		return "ezApprovalG/apprGrecevG";
//	}
	
	/**
	 * 전자결재G 결재라인 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprLine.do")
	public String aprLine(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String userEmail = userInfo.getEmail();
		String susinAdmin = "";
		String serverName = userInfo.getServerName();
		
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String optGamsabu = ezApprovalGService.getOptionInfo("A40", "001", userInfo, "CODE");
		String aprTypeXML = ezApprovalGService.getAprType(userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("aprTypeXML", aprTypeXML);
		model.addAttribute("optGamsabu", optGamsabu);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("userEmail", userEmail);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("serverName", serverName);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGaprLine";
	}
	
	/**
	 * 전자결재G 수신처 업데이트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setSusinUpdateDocID.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setSusinUpdateDocID(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String orgDocID = request.getParameter("orgDocID");
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String result = ezApprovalGService.updateSusinDocInfo(orgDocID, docID, deptID, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 수신처 얼러트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezReceiveDistributeUI.do")
	public String ezReceiveDistributeUI(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		//2015-06-26 표준모듈:수정(자기부서 배부 가능여부)
        String USE_SELFDISTRIBUTE = "N";
		String susinAdmin = "";
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String mode = request.getParameter("mode");
//		String docID = request.getParameter("docID");
//		
//		String strXML = ezApprovalGService.getDocInfo(docID, "APR", "formID", userInfo.getCompanyID());
//		Document doc = commonUtil.convertStringToDocument(strXML);
//		String formID = "";
//		
//		if (doc.getElementsByTagName("FORMID").item(0).getTextContent() != null) {
//			formID = doc.getElementsByTagName("FORMID").item(0).getTextContent();
//		}
//		
//		if (formID == null || formID.equals("")) {
//			strXML = ezApprovalGService.getDocInfo(docID, "", "formID", userInfo.getCompanyID());
//			doc = commonUtil.convertStringToDocument(strXML);
//			formID = doc.getElementsByTagName("FORMID").item(0).getTextContent();
//		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("USE_SELFDISTRIBUTE", USE_SELFDISTRIBUTE);
		model.addAttribute("mode", mode);
		
		
		return "ezApprovalG/apprGezReceiveDistributeUI";
	}

	/**
	 * 전자결재G 문서보기 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDocView.do")
	public String aprDocView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String crossEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String susinAdmin = "";
		String hasOpinionYN = "";
		String realPath = commonUtil.getRealPath(request);
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String opinionFlag = request.getParameter("opinionFlag");
		String docState = request.getParameter("docState");
		String listSusin = request.getParameter("listSusin");
		String orgDocID = request.getParameter("oDoc");
		String isOpinion = request.getParameter("isOpinion");
		String listType = request.getParameter("listType");
		String mode = "VIE";
		String callBackType = request.getParameter("CallBackType");
		
		if (listType.equals("1") || listType.equals("2") || listType.equals("3")) {
			mode = "VIE";
		} else if (listType.equals("4") || listType.equals("6") || listType.equals("10") || listType.equals("99")) {
			mode = "REC";
		} else if (listType.equals("21")) {
			mode = "TMP";
		}
		
		String strXML = ezApprovalGService.getDocInfo(docID, "APR", "hasOpinionYN", userInfo.getCompanyID(), userInfo.getTenantId());
		Document resultXML = commonUtil.convertStringToDocument(strXML);
		
		if (resultXML.getElementsByTagName("HASOPINIONYN").item(0) != null) {
			if (!resultXML.getElementsByTagName("HASOPINIONYN").item(0).getTextContent().trim().equals("")) {
				hasOpinionYN = resultXML.getElementsByTagName("HASOPINIONYN").item(0).getTextContent();
			}
		}
		
		String dirPath = realPath +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String rtnVal = ezApprovalGService.getOrgDocInfo(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		Document xmlDom = commonUtil.convertStringToDocument(rtnVal);
		
		if (xmlDom.getElementsByTagName("ORGHREF").getLength() > 0) {
			String orgDocFile = xmlDom.getElementsByTagName("ORGHREF").item(0).getTextContent();
			String docFile = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
			
			orgDocFile = dirPath + orgDocFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator, "");
			docFile = dirPath + docFile.replace( commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator, "");
			
			String dir = docFile.substring(0, docFile.lastIndexOf(commonUtil.separator) + 1);
			File file = new File(dir);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			File newFile = new File(docFile);
			
			if (!newFile.exists()) {
				File orgFile = new File(orgDocFile);
				
				FileUtils.copyFile(orgFile, newFile);
			}
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			if (docID != null && !docID.equals("")) {
				Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), mode, userInfo.getCompanyID(), userInfo.getTenantId());
				
				if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
					return "main/warning";
				}
				if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals(userInfo.getId()) && !doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("NULL")) {
					if (doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("") && (!doc.getElementsByTagName("RECEIVEDDEPTID").item(0).getTextContent().equals(userInfo.getDeptID()) || userInfo.getRollInfo().indexOf("a=1") == -1)) {
						return "main/warning";
					}
					if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("")) {
						return "main/warning";
					}
				}
			}
		}
		
		model.addAttribute("docID", docID);
		model.addAttribute("crossEditor", crossEditor);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("hasOpinionYN", hasOpinionYN);
		model.addAttribute("docHref", docHref);
		model.addAttribute("opinionFlag", opinionFlag);
		model.addAttribute("docState", docState);
		model.addAttribute("listSusin", listSusin);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("isOpinion", isOpinion);
		model.addAttribute("listType", listType);
		model.addAttribute("mode", mode);
		model.addAttribute("callBackType", callBackType);

		return "ezApprovalG/apprGaprDocView";
	}
	
	/**
	 * 전자결재G 문서보기내용 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDocViewContent.do")
	public String aprDocViewContent() throws Exception{
		return "ezApprovalG/apprGaprDocViewContent";
	}
	
	/**
	 * 전자결재G 모두결재 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezAprAllAlert.do")
	public String ezAprAllAlert() throws Exception{
		return "ezApprovalG/apprGezAprAllAlert";
	}
	
	/**
	 * 전자결재G 모두결재 다음문서 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getNextDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getNextDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String userDeptID = request.getParameter("userDeptID");
		String result = ezApprovalGService.getNextDocInfo(docID, userID, userDeptID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	/**
	 * 전자결재G 반송,회수문서 삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String mode = request.getParameter("field");
		String result = ezApprovalGService.deleteDocInfo(docID, mode, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 결재리스트 검색 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setSearchInfo.do")
	public String setSearchInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String type = request.getParameter("type");
		String susinAdmin = "";
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String monthEndDay = EgovDateUtil.getTodayTime().substring(9, 10);;
		String initDate = EgovDateUtil.getTodayTime().substring(0, 10);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("type", type);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("monthEndDay", monthEndDay);
		model.addAttribute("initDate", initDate);
		
		return "ezApprovalG/apprGsetSearchInfo";
	}

	/**
	 * 전자결재G 대결정보 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/secondApprovalInfo.do")
	public String secondApprovalInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		List<ApprGSecondApprVO> strResult = ezApprovalGService.getSecondApprovalInfo(userInfo.getCompanyID(), userInfo.getTenantId());
		
		model.addAttribute("strResult", strResult);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGsecondApprovalInfo";
	}
	
	/**
	 * 전자결재G 철생성 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/createCabinet.do")
	public String createCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGcreateCabinet";
	}
	
	/**
	 * 전자결재G 특수목록위치 추가 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/insSpecialList.do")
	public String insSpecialList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezApprovalG/apprGinsSpecialList";
	}

	/**
	 * 전자결재G 철생성 등록 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/registerCabinet.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String registerCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String result = ezApprovalGService.registerCabinet(xmlDom, userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}

	/**
	 * 전자결재G 철생성 권호수등록 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/addVolume.do")
	public String addVolume(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGaddVolume";
	}

	/**
	 * 전자결재G 철생성 권호수등록 새호수 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getNewVolNo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getNewVolNo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabClassNO = request.getParameter("cabClassNO");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.getNewVolumeNo(cabClassNO, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 철생성 권호수등록 저장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/addNewVolume.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String addNewVolume(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabClassNO = request.getParameter("cabClassNO");
		String companyID = request.getParameter("companyID");
		String newVolNO = request.getParameter("newVolNO");
		String result = ezApprovalGService.addNewVolume(cabClassNO, newVolNO, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 검색 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/searchCabinet.do")
	public String searchCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGsearchCabinet";
	}
	
	/**
	 * 전자결재G 기록물철 검색 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getCabinetSearch.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetSearch(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		String processDeptCode = request.getParameter("processDeptCode");
		String productionYear = request.getParameter("productionYear");
		String searchKeyword = request.getParameter("searchKeyword");
		String flag = request.getParameter("flag");
		String langType = request.getParameter("langType");
		
		String result = ezApprovalGService.getFindSimpleCabinetList(processDeptCode, productionYear, searchKeyword, flag, companyID, langType, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철 검색 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getCabinetSearchAll.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetSearchAll(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getCabinetSearchAll started.");
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String companyID = request.getParameter("companyID");
		String processDeptCode = request.getParameter("processDeptCode");
		String productionYear = request.getParameter("productionYear");
		String searchKeyword = request.getParameter("searchKeyword");
		String flag = request.getParameter("flag");
		String langType = request.getParameter("langType");
		
		String result = ezApprovalGService.getFindSimpleCabinetListAll(processDeptCode, productionYear, searchKeyword, flag, companyID, langType, userInfo.getTenantId());
		
		logger.debug("getCabinetSearchAll ended.");

		return result;
	}
	
	/**
	 * 전자결재G 접수 배부 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/setBebu.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setBebu(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String realPath = commonUtil.getRealPath(request);
		String dirPath = realPath +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.setBebu(xmlDom, dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 접수 회송 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/setHeSongDocInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setHeSongDocInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		String dirPath = realPath +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String docID = request.getParameter("docID");
		String receiveSN = request.getParameter("receiveSN");
		String deptID = request.getParameter("deptID");
		String docState = request.getParameter("docState");
		String userID = request.getParameter("userID");
		String userName = request.getParameter("userName");
		String userName2 = request.getParameter("userName2");
		String result = ezApprovalGService.doSusinHesong(docID, receiveSN, deptID, docState, userID, userName, userName2, dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 일괄결재 호출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/doApprovAllselect.do")
	public String doApprovAllselect(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		StringBuilder sbStr = new StringBuilder();
		int cnt = 0;
		Document xmlDom = commonUtil.convertStringToDocument(request.getParameter("APPXML"));
		String useAdditionalRole = ezCommonService.getTenantConfig("USE_AdditionalROle", userInfo.getTenantId());
		String listType = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
//		String docType = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String userID = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String deptID = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
		String pageSize = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
		String pageNum = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();
		String companyID = xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
		String orderCell = xmlDom.getDocumentElement().getChildNodes().item(7).getTextContent();
		String orderOption = xmlDom.getDocumentElement().getChildNodes().item(8).getTextContent();
		String searchQuery = "";
		String userLang = userInfo.getLang();
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		Document xmlDomSub = null;
				
		if (xmlDom.getDocumentElement().getChildNodes().item(9).getTextContent().length() > 10) {
			String tempQuery = "";
			String returnQuery = "(1 = 1) ";
			xmlDomSub = commonUtil.convertStringToDocument(xmlDom.getDocumentElement().getChildNodes().item(9).getTextContent());

			tempQuery = xmlDomSub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
			
			if (tempQuery.indexOf("DOCNO;") != -1)
            {
                returnQuery += " AND DOCNO LIKE '%" + xmlDomSub.getElementsByTagName("DOCNO").item(0).getTextContent() + "%' ";
            }
            if (tempQuery.indexOf("DOCTITLE;") != -1)
            {
                returnQuery += " AND DocTitle LIKE '%" + xmlDomSub.getElementsByTagName("DOCTITLE").item(0).getTextContent() + "%' ";
            }

            //2012.05.23 작성자언어설정
            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    returnQuery += " AND WRITERNAME" + userLang + " LIKE '%" + xmlDomSub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                }
            } else {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    returnQuery += " AND WRITERNAME LIKE '%" + xmlDomSub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                }
            }

            //2012.05.23 부서언어설정
            if (commonUtil.getPrimaryData(userLang, userInfo.getTenantId()).equals("2")) {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                    returnQuery += " AND WriterDeptName" + userLang + " LIKE '%" + xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent() + "%' ";
                }
            } else {
                if (tempQuery.indexOf("WRITERDEPTNAME;") != -1) {
                    returnQuery += " AND WriterDeptName LIKE '%" + xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent() + "%' ";
                }
            }


            if (tempQuery.indexOf("APRSTARTDATE;") != -1) {
            	if (!dbType.equals("mysql")) {
            		returnQuery += " AND STARTDATE >= TO_DATE('" + commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), false)+"','YYYY-MM-DD HH24:MI:SS') ";
            	} else {
            		returnQuery += " AND STARTDATE >= STR_TO_DATE('" + commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), false)+"', '%Y-%m-%d %H:%i:%s') ";
            	}
            }
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
            	if (!dbType.equals("mysql")) {
            		returnQuery += " AND STARTDATE <=  TO_DATE('" + commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), false)+"','YYYY-MM-DD HH24:MI:SS') ";
            	} else {
            		returnQuery += " AND STARTDATE <=  STR_TO_DATE('" + commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), false)+"','%Y-%m-%d %H:%i:%s') ";
            	}
            }
            if (tempQuery.indexOf("FORMID;") != -1) {
                returnQuery += " AND FormID = '" + xmlDomSub.getElementsByTagName("FORMID").item(0).getTextContent() + "' ";
            }
            if (tempQuery.indexOf("KAPR;") != -1) {
                returnQuery += " AND keyword LIKE '%" + xmlDomSub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
            }
            if (tempQuery.indexOf("KEND;") != -1) {
                returnQuery += " AND TBL_EXPAPRDOCINFO.keyword LIKE '%" + xmlDomSub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
            }
            if (tempQuery.indexOf("CAPR;") != -1) {
                returnQuery += " AND TBL_EXPENDAPRDOCINFO.itemcode = '" + xmlDomSub.getElementsByTagName("itemCODE").item(0).getTextContent() + "' ";
            }
            if (tempQuery.indexOf("CEND;") != -1) {
                returnQuery += " AND TBL_EXPAPRDOCINFO.itemcode = '" + xmlDomSub.getElementsByTagName("itemCODE").item(0).getTextContent() + "' ";
            }
            if (tempQuery.indexOf("URGENTAPPROVAL;") != -1) {
                returnQuery += " AND URGENTAPPROVAL = '" + xmlDomSub.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent() + "' ";
            }
            returnQuery += " AND TENANT_ID = " + userInfo.getTenantId() ; 
            searchQuery = returnQuery;
		}
		
		String result = ezApprovalGService.aprDocList(listType, userID, deptID, pageSize, pageNum, orderCell, orderOption, companyID, userInfo.getLang(), searchQuery, xmlDomSub, userInfo.getTenantId(), userInfo.getOffset());
		Document xmlResult = commonUtil.convertStringToDocument(result);
		NodeList docListNode = xmlResult.getElementsByTagName("ROW");
		
		if (docListNode != null) {
			String strDocState = "";
			String strAprState = "";
			String aprType_aprState = "";

			for (int k = 0; k < docListNode.getLength(); k++) {
				strDocState = docListNode.item(k).getChildNodes().item(0).getChildNodes().item(15).getTextContent();
				strAprState = docListNode.item(k).getChildNodes().item(0).getChildNodes().item(13).getTextContent();
				
				if (strDocState.equals("015") || (!strAprState.equals("002") && !strAprState.equals("005"))) {
					docListNode.item(k).removeChild(docListNode.item(k).getFirstChild());
				} else {
					String href = docListNode.item(k).getChildNodes().item(0).getChildNodes().item(3).getTextContent();

					if (!docListNode.item(k).getChildNodes().item(0).getChildNodes().item(7).getTextContent().equals(userInfo.getDeptID()) && useAdditionalRole.equals("YES")) {
						docListNode.item(k).removeChild(docListNode.item(k).getFirstChild());
					} else {
						aprType_aprState = ezApprovalGService.getAprType_AprState(docListNode.item(k).getChildNodes().item(0).getChildNodes().item(1).getTextContent(), userID, companyID, userInfo.getTenantId());
						
						String mhtOrHwp = "MHT";
						
						if (href.substring(href.length() - 4).toUpperCase().equals(".HWP")) {
							mhtOrHwp = "HWP";
						}
						
						if (!aprType_aprState.split("/")[0].equals("001") && !aprType_aprState.split("/")[0].equals("019") && !aprType_aprState.split("/")[0].equals("004")) {
							docListNode.item(k).removeChild(docListNode.item(k).getFirstChild());
						} else {
							cnt++;
							
						    sbStr.append("<tr>");
                            sbStr.append("<TD style='padding:0;background-color:White' align='center'><input type='checkbox' name='chk' id='chk' value = \""+ docListNode.item(k).getChildNodes().item(0).getChildNodes().item(1).getTextContent() + "|" + docListNode.item(k).getChildNodes().item(0).getChildNodes().item(4).getTextContent() + "|" + docListNode.item(k).getChildNodes().item(0).getChildNodes().item(17).getTextContent() + "|" + mhtOrHwp + "\")'></td>");
                            sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + docListNode.item(k).getChildNodes().item(0).getChildNodes().item(0).getTextContent() +"</TD>");
                            sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + docListNode.item(k).getChildNodes().item(1).getChildNodes().item(0).getTextContent() + "</TD>");
                            sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + docListNode.item(k).getChildNodes().item(2).getChildNodes().item(0).getTextContent() + "</TD>");
                            sbStr.append("<TD style='padding:0;background-color:White' align='left'>" + docListNode.item(k).getChildNodes().item(3).getChildNodes().item(0).getTextContent() + "</TD>");
                            sbStr.append("</tr>");
						}
					}
				}
			}
		}
		
		model.addAttribute("cnt", cnt);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("sbStr", sbStr.toString());
		model.addAttribute("approvalPWD", approvalPWD);
		
		return "ezApprovalG/apprGdoApprovAllselect";
	}
	
	/**
	 * 전자결재G 회수 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/doCancel.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String doCancel(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String result = ezApprovalGService.doCallBack(docID, userID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 재기안 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getFormConnFlag.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormConnFlag(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String docID = request.getParameter("docID");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.getFormConnFlag(docID, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 양식아이디 가져오기 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getAprDocFormID.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAprDocFormID(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getDocInfo(docID, "APR", "FormID", userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}

	/**
	 * 전자결재G 공람정보 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezLineInfo.do")
	public String ezLineInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String docState = request.getParameter("docState");
		String childDocInfo = ezApprovalGService.getInnerLineInfo(docID, deptID, docState, userInfo.getCompanyID(), userInfo.getTenantId());
		
		model.addAttribute("docID", docID);
		model.addAttribute("deptID", deptID);
		model.addAttribute("docState", docState);
		model.addAttribute("childDocInfo", childDocInfo);
		
		return "ezApprovalG/apprGezLineInfo";
	}
	
	@RequestMapping(value = "/ezApprovalG/getContainerInfo.do")
	public String getContainerInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String userEmail = userInfo.getEmail();
		String userInfoEnforce = ezCommonService.getTenantConfig("UserInfo_Enforce", userInfo.getTenantId()); 
		String openYear = ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId());
		String susinAdmin = "";
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String contType = "END";
		String dirPath = realPath + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator;
		String propList = "extensionAttribute4";
		String contID = request.getParameter("contID");
		String sQuery = request.getParameter("sQuery");
		String type = request.getParameter("type");
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		String result = ezOrganService.getPropertyList(userInfo.getId(), propList, userInfo.getPrimary(), userInfo.getTenantId());
		
		Document xmlDom = commonUtil.convertStringToDocument(result);
		
		String deptInfo = xmlDom.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent();
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("contType", contType);
		model.addAttribute("dirPath", dirPath);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("type", type);
		model.addAttribute("sQuery", sQuery);
		model.addAttribute("contID", contID);
		model.addAttribute("deptInfo", deptInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userEmail", userEmail);
		model.addAttribute("userInfoEnforce", userInfoEnforce);
		model.addAttribute("openYear", openYear);
		model.addAttribute("approvalPWD", approvalPWD);
		
		return "ezApprovalG/apprGgetContainerInfo";
	}
	
	@RequestMapping(value = "/ezApprovalG/getFormSearchDocList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormSearchDocList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String docNumber = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
        String docTitle = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        String drafter = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
        String draftFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
        String draftFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
        String draftFromDAY = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();
        String draftToYEAR = xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
        String draftToMONTH = xmlDom.getDocumentElement().getChildNodes().item(7).getTextContent();
        String draftToDAY = xmlDom.getDocumentElement().getChildNodes().item(8).getTextContent();
        String apprFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(9).getTextContent();
        String apprFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(10).getTextContent();
        String apprFromDAY = xmlDom.getDocumentElement().getChildNodes().item(11).getTextContent();
        String apprToYEAR = xmlDom.getDocumentElement().getChildNodes().item(12).getTextContent();
        String apprToMONTH = xmlDom.getDocumentElement().getChildNodes().item(13).getTextContent();
        String apprToDAY = xmlDom.getDocumentElement().getChildNodes().item(14).getTextContent();

        String myApprFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(15).getTextContent();
        String myApprFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(16).getTextContent();
        String myApprFromDAY = xmlDom.getDocumentElement().getChildNodes().item(17).getTextContent();
        String myApprToYEAR = xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent();
        String myApprToMONTH = xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent();
        String myApprToDAY = xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent();
        String formID = xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent();
        String draftDeptName = xmlDom.getDocumentElement().getChildNodes().item(23).getTextContent();

        String containerID = xmlDom.getDocumentElement().getChildNodes().item(24).getTextContent();
        String userID = xmlDom.getDocumentElement().getChildNodes().item(25).getTextContent();
        String pageNum = xmlDom.getDocumentElement().getChildNodes().item(28).getTextContent();
        String pageSize = xmlDom.getDocumentElement().getChildNodes().item(29).getTextContent();
        String docState = xmlDom.getDocumentElement().getChildNodes().item(30).getTextContent();

        String subQuery = xmlDom.getDocumentElement().getChildNodes().item(31).getTextContent();
        String orderCell = xmlDom.getDocumentElement().getChildNodes().item(32).getTextContent();
        String orderOption = xmlDom.getDocumentElement().getChildNodes().item(33).getTextContent();
        
        String result = ezApprovalGService.getSearchDocList(containerID, userID, subQuery, docNumber, docTitle, drafter, formID, draftFromYEAR, draftFromMONTH, draftFromDAY, draftToYEAR,
        		draftToMONTH, draftToDAY, apprFromYEAR, apprFromMONTH, apprFromDAY, apprToYEAR, apprToMONTH, apprToDAY, myApprFromYEAR, myApprFromMONTH, myApprFromDAY, myApprToYEAR, myApprToMONTH,
        		myApprToDAY, draftDeptName, docState, "", pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userInfo.getLang(), "", userInfo.getTenantId(), userInfo.getOffset());
        
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/ezReceiptHistoryInfo.do")
	public String ezReceiptHistoryInfo(HttpServletRequest request, Model model) throws Exception{
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		
		model.addAttribute("docID", docID);
		model.addAttribute("deptID", deptID);
		//TODO: aspx 파일이 Cross 버젼으로 닷넷소스에는 걸려져있는데 파일이 존재안함 그래서 일단 일반으로 넣었으나 엑티브엑스 사용해서 수정해야됨
		return "ezApprovalG/apprGezReceiptHistoryInfo";
		
	}
	
	@RequestMapping(value = "/ezApprovalG/ezDocInfoGView.do")
	public String ezDocInfoGView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String summary = "";
		String pageNum = "";
		String limitRange = "";
		String publicityCode = "";
		String specialRecordCode = "";
		String urgentApproval = "";
		String securityCode = "";
		String securityDate = "";
		
		String docID = request.getParameter("docID");
		String ingFlag = request.getParameter("ingFlag");
		String strXML = ezApprovalGService.getDocInfo(docID, ingFlag, "UrgentApproval;SpecialRecordCode;PublicityCode;LimitRange;PageNum;Summary;SecurityCode;SecurityApproval", userInfo.getCompanyID(), userInfo.getTenantId());
		
		Document docXML = commonUtil.convertStringToDocument(strXML);
		
		if (docXML.getElementsByTagName("SUMMARY").item(0) != null) {
			summary = docXML.getElementsByTagName("SUMMARY").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("PAGENUM").item(0) != null) {
			pageNum = docXML.getElementsByTagName("PAGENUM").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("LIMITRANGE").item(0) != null) {
			limitRange = docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("PUBLICITYCODE").item(0) != null) {
			publicityCode = docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("SPECIALRECORDCODE").item(0) != null) {
			specialRecordCode = docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("URGENTAPPROVAL").item(0) != null) {
			urgentApproval = docXML.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("SECURITYCODE").item(0) != null) {
			securityCode = docXML.getElementsByTagName("SECURITYCODE").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("SECURITYAPPROVAL").item(0) != null) {
			securityDate = docXML.getElementsByTagName("SECURITYAPPROVAL").item(0).getTextContent();
		}
		
		if (securityDate.equals("")) {
			securityDate = "N";
		}
		
		String securityNode = ezApprovalGService.getSecurityType("", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("summary", summary);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("limitRange", limitRange);
		model.addAttribute("publicityCode", publicityCode);
		model.addAttribute("specialRecordCode", specialRecordCode);
		model.addAttribute("urgentApproval", urgentApproval);
		model.addAttribute("securityCode", securityCode);
		model.addAttribute("securityDate", securityDate);
		model.addAttribute("securityNode", securityNode);
		
		return "ezApprovalG/apprGezDocInfoGView";
	}
	
	@RequestMapping(value = "/ezApprovalG/getEndOpinionInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getEndOpinionInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.getOpinionInfo(docID, "CEND", "", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/aprEndOpinion.do")
	public String aprEndOpinion() throws Exception{
		return "ezApprovalG/apprGaprEndOpinion";
	}
	
	@RequestMapping(value = "/ezApprovalG/updateSignCheck.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String updateSignCheck(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String signCheck = request.getParameter("signCheck");
        String result = ezApprovalGService.updateSignCheck(docID, signCheck, userInfo.getCompanyID(), userInfo.getTenantId());
        
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/aprAttachMail.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprAttachMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		logger.debug("aprAttachMail started");   
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String docID = xmlDom.getDocumentElement().getTextContent();
		String ingFlag = ezApprovalGService.aprAttachMail(docID, "1", userInfo.getCompanyID(), userInfo.getTenantId());
		
		Document xmlQuery = commonUtil.convertStringToDocument(ingFlag);
		
		String rtnVal = "";
		
		if (xmlQuery.getDocumentElement().getTextContent().trim().equals("")) {
			ingFlag = ezApprovalGService.aprAttachMail(docID, "2", userInfo.getCompanyID(), userInfo.getTenantId());
			
			xmlQuery = commonUtil.convertStringToDocument(ingFlag);
			rtnVal = xmlQuery.getDocumentElement().getTextContent();
			
			if (!rtnVal.equals("")) {
				ingFlag = ezApprovalGService.aprAttachMail(docID, "3", userInfo.getCompanyID(), userInfo.getTenantId());
			} else {
				ingFlag = ezApprovalGService.aprAttachMail(docID, "6", userInfo.getCompanyID(), userInfo.getTenantId());
				
				xmlQuery = commonUtil.convertStringToDocument(ingFlag);
				rtnVal = xmlQuery.getDocumentElement().getTextContent();
				
				ingFlag = ezApprovalGService.aprAttachMail(docID, "7", userInfo.getCompanyID(), userInfo.getTenantId());
			}
			
			rtnVal = "<ATTACHINFO><DOCTITLE>" + makeXMLString(rtnVal) + "</DOCTITLE>" + ingFlag + "</ATTACHINFO>";
		} else {
			ingFlag = ezApprovalGService.aprAttachMail(docID, "4", userInfo.getCompanyID(), userInfo.getTenantId());
			
			xmlQuery = commonUtil.convertStringToDocument(ingFlag);
			rtnVal = xmlQuery.getDocumentElement().getTextContent();
			
			ingFlag = ezApprovalGService.aprAttachMail(docID, "5", userInfo.getCompanyID(), userInfo.getTenantId());
			
			rtnVal = "<ATTACHINFO><DOCTITLE>" + makeXMLString(rtnVal) + "</DOCTITLE>" + ingFlag + "</ATTACHINFO>";
		}
		logger.debug("aprAttachMail ended"); 
		return rtnVal;
	}
	
	/**
	 * 전자결재G 내보내기, 전체내보내기 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/excelExportOut.do")
	public void excelExportOut(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		StringBuilder resultExcel = new StringBuilder(); 
		String listType = "";
		
		listType = request.getParameter("listType");
		response.setContentType("application/ms-excel");
		response.setCharacterEncoding("utf-8");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + EgovDateUtil.getTodayTime().substring(0, 10) + "_" + userInfo.getDeptID() + "_" + CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), messageSource.getMessage("ezApprovalG.t1750", locale)) + ".xls\"");
		
		String excelValue = "";
		
		if (listType.toUpperCase().equals("DOC")) {
			String containerID = request.getParameter("cont");
			String pageNum = request.getParameter("PN");
			String pageSize = request.getParameter("PS");
			String orderCell = request.getParameter("OC");
			String orderOption = request.getParameter("OO");
			
			excelValue = ezApprovalGService.getContDocList(containerID, userInfo.getId(), "", pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else if (listType.toUpperCase().equals("PRINT")) {
			excelValue = request.getParameter("saveExcelData");
		} else {
			String P0 = request.getParameter("P0");
            String P1 = request.getParameter("P1");
            String P2 = request.getParameter("P2");
            String P3 = request.getParameter("P3");
            String P4 = request.getParameter("P4");
            String P5 = request.getParameter("P5");
            String P6 = request.getParameter("P6");
            String P7 = request.getParameter("P7");
            String P8 = request.getParameter("P8");
            String P9 = request.getParameter("P9");
            String P10 = request.getParameter("P10");
            String P11 = request.getParameter("P11");
            String P12 = request.getParameter("P12");
            String P13 = request.getParameter("P13");
            String P14 = request.getParameter("P14");
            String P15 = request.getParameter("P15");
            String P16 = request.getParameter("P16");
            String P17 = request.getParameter("P17");
            String P18 = request.getParameter("P18");
            String P19 = request.getParameter("P19");
            String P20 = request.getParameter("P20");
            String P21 = request.getParameter("P21");
//            String P22 = request.getParameter("P22");
            String P23 = request.getParameter("P23");
            String P24 = request.getParameter("P24");
            String pageNum = request.getParameter("PN");
            String pageSize = request.getParameter("PS");
            String orderCell = request.getParameter("OC");
            String orderOption = request.getParameter("OO");
            String subQuery = request.getParameter("SQ");
            
            excelValue = ezApprovalGService.getSearchDocList(P24, userInfo.getId(), subQuery, P0, P1, P2, P21, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16, P17, P18, P19, P20, P23, "", "", pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userInfo.getLang(), "", userInfo.getTenantId(), userInfo.getOffset());
		}
		
		Document objXML = commonUtil.convertStringToDocument(excelValue);
		
		resultExcel.append("<table><tr>");
		
		for (int k = 0; k < objXML.getElementsByTagName("HEADER").getLength(); k++) {
			String headerName = objXML.getElementsByTagName("NAME").item(k).getTextContent();
			String headerWidth = objXML.getElementsByTagName("WIDTH").item(k).getTextContent();
			
			int width = Integer.parseInt(headerWidth) * 2;
			
			resultExcel.append("<td style='BORDER-BOTTOM: windowtext 0.5pt solid; BORDER-LEFT: windowtext; BACKGROUND-COLOR: #a6a6a6; BORDER-TOP: windowtext 0.5pt solid; BORDER-RIGHT: windowtext 0.5pt solid;width:" + width + "'><p align=center><STRONG>" + commonUtil.cleanValue(headerName) + "</STRONG></p></td>        ");
		}
		resultExcel.append("</tr></table>");
		
		resultExcel.append("<table>");

		NodeList objRow = objXML.getElementsByTagName("ROW");
		
		for (int k = 0; k < objRow.getLength(); k++) {
			resultExcel.append("<tr>");
			Element row = (Element) objRow.item(k);
			NodeList objCell = row.getElementsByTagName("CELL");
			
			for (int p = 0; p < objCell.getLength(); p++) {
				Element cell = (Element) objCell.item(p);
				String cellValue = cell.getElementsByTagName("VALUE").item(0).getTextContent();
				String headerWidth = objXML.getElementsByTagName("WIDTH").item(p).getTextContent();
				int width = Integer.parseInt(headerWidth) * 2;
				
				resultExcel.append("<td style='BORDER-BOTTOM: windowtext 0.5pt solid; BORDER-LEFT: windowtext; BORDER-TOP: windowtext 0.5pt solid; BORDER-RIGHT: windowtext 0.5pt solid;width:" + width + "'><p align=left>" + commonUtil.cleanValue(cellValue) + "</p></td>       ");
			}
			resultExcel.append("</tr>");
		}
		resultExcel.append("</table>");
		
		response.getWriter().write(resultExcel.toString());
	}
	
	/**
	 * 전자결재G 결재함 감사함 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getGamSaSearchDocList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getGamSaSearchDocList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String docNumber = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
        String docTitle = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        String drafter = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
        String draftFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
        String draftFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
        String draftFromDAY = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();
        String draftToYEAR = xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
        String draftToMONTH = xmlDom.getDocumentElement().getChildNodes().item(7).getTextContent();
        String draftToDAY = xmlDom.getDocumentElement().getChildNodes().item(8).getTextContent();
        String apprFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(9).getTextContent();
        String apprFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(10).getTextContent();
        String apprFromDAY = xmlDom.getDocumentElement().getChildNodes().item(11).getTextContent();
        String apprToYEAR = xmlDom.getDocumentElement().getChildNodes().item(12).getTextContent();
        String apprToMONTH = xmlDom.getDocumentElement().getChildNodes().item(13).getTextContent();
        String apprToDAY = xmlDom.getDocumentElement().getChildNodes().item(14).getTextContent();

        String myApprFromYEAR = xmlDom.getDocumentElement().getChildNodes().item(15).getTextContent();
        String myApprFromMONTH = xmlDom.getDocumentElement().getChildNodes().item(16).getTextContent();
        String myApprFromDAY = xmlDom.getDocumentElement().getChildNodes().item(17).getTextContent();
        String myApprToYEAR = xmlDom.getDocumentElement().getChildNodes().item(18).getTextContent();
        String myApprToMONTH = xmlDom.getDocumentElement().getChildNodes().item(19).getTextContent();
        String myApprToDAY = xmlDom.getDocumentElement().getChildNodes().item(20).getTextContent();
        String formID = xmlDom.getDocumentElement().getChildNodes().item(21).getTextContent();
        String draftDeptName = xmlDom.getDocumentElement().getChildNodes().item(23).getTextContent();

        String containerID = xmlDom.getDocumentElement().getChildNodes().item(24).getTextContent();
        String userID = xmlDom.getDocumentElement().getChildNodes().item(25).getTextContent();
        String deptID = xmlDom.getDocumentElement().getChildNodes().item(26).getTextContent();
        String pageNum = xmlDom.getDocumentElement().getChildNodes().item(28).getTextContent();
        String pageSize = xmlDom.getDocumentElement().getChildNodes().item(29).getTextContent();
        String docState = xmlDom.getDocumentElement().getChildNodes().item(30).getTextContent();

        String subQuery = xmlDom.getDocumentElement().getChildNodes().item(31).getTextContent();
        String orderCell = xmlDom.getDocumentElement().getChildNodes().item(32).getTextContent();
        String orderOption = xmlDom.getDocumentElement().getChildNodes().item(33).getTextContent();
        
        String result = ezApprovalGService.getGamSaSearchDocList(containerID, userID, deptID, subQuery, docNumber, docTitle, drafter, formID, draftFromYEAR, draftFromMONTH, draftFromDAY,
        		draftToYEAR, draftToMONTH, draftToDAY, apprFromYEAR, apprFromMONTH, apprFromDAY, apprToYEAR, apprToMONTH, apprToDAY, myApprFromYEAR, myApprFromMONTH, myApprFromDAY,
        		myApprToYEAR, myApprToMONTH, myApprToDAY, draftDeptName, docState, "", pageSize, pageNum, orderCell, orderOption, userInfo);
        
		return result;
	}
	
	/**
	 * 전자결재G 단위업무관리 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/taskManage.do")
	public String taskManage(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGtaskManage";
	}
	
	/**
	 * 전자결재G 기록물철인계 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/cabTransfer.do")
	public String cabTransfer(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGcabTransfer";
	}
	
	/**
	 * 전자결재G 기록물철인계 단위업무코드 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/selectTask.do")
	public String selectTask(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String initFlag = "";
		String multiSelect = "";
		
		if (request.getParameter("initFlag") != null) {
			initFlag = request.getParameter("initFlag");
		}
		if (request.getParameter("multiSelect") != null) {
			multiSelect = request.getParameter("multiSelect");
		}
		
		if (initFlag.trim().equals("")) {
			initFlag = "0";
		}
		
		if (multiSelect.trim().equals("")) {
			multiSelect = "0";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("initFlag", initFlag);
		model.addAttribute("multiSelect", multiSelect);
		
		return "ezApprovalG/apprGselectTask";
	}

	/**
	 * 전자결재G 기록물철인계 인수부서 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/selectDept.do")
	public String selectDept(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGselectDept";
	}
	
	/**
	 * 전자결재G 기록물철인계 인계가능여부확인 표출 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getUncompleteDocCount.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getUncompleteDocCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String cabinetID = request.getParameter("cabinetID");
		String result = ezApprovalGService.getUncompleteDocCount(userInfo.getDeptID(), userInfo.getCompanyID(), cabinetID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물철인계 인계버튼 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/transferCab.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String transferCab(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String result = ezApprovalGService.transferCabinet(xmlDom, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 관리자 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/adminPage.do")
	public String adminPage(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String initFlag = request.getParameter("initFlag");
		String pageTitle = "";
		String deptCode = userInfo.getDeptID();
		String deptName = "";
		
		if (userInfo.getPrimary().equals("1")) {
			deptName = userInfo.getDeptName1();
		} else {
			deptName = userInfo.getDeptName2();
		}
		
		switch (initFlag) {
		case "0":
			pageTitle = messageSource.getMessage("ezApprovalG.t520", locale);
			break;
		case "1":
			pageTitle = messageSource.getMessage("ezApprovalG.t521", locale);
			break;
		case "2":
			pageTitle = messageSource.getMessage("ezApprovalG.t522", locale);
			break;
		case "3":
			pageTitle = messageSource.getMessage("ezApprovalG.t523", locale);
			break;
		case "4":
			pageTitle = messageSource.getMessage("ezApprovalG.t559", locale);
			break;
		default:
			pageTitle = messageSource.getMessage("ezApprovalG.t520", locale);
			break;
		}
		
		model.addAttribute("pageTitle", pageTitle);
		model.addAttribute("deptCode", deptCode);
		model.addAttribute("deptName", deptName);
		model.addAttribute("initFlag", initFlag);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGadminPage";
	}
	
	/**
	 * 전자결재G 분리첨부 철변경 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/selectCabinetInTask.do")
	public String selectCabinetInTask(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) {
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGselectCabinetInTask";
	}

	/**
	 * 전자결재G 공람문서 공람승인 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/gongRamUpdate.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String gongRamUpdate(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String result = ezApprovalGService.gongRamUpdate(docID, userID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
				
		return result;
	}
	
	/**
	 * 전자결재G 종료연기 신청,취소 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delayCabEndY.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delayCabEndY(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,HttpServletRequest request) throws Exception{
	    userInfo = commonUtil.aprUserInfo(loginCookie);

		String companyID = request.getParameter("companyID");
		String deptCode = request.getParameter("deptCode");
		String flag = request.getParameter("flag");
		String cabClassList = request.getParameter("cabClassList");
		
		String result = ezApprovalGService.delayCabEndY(deptCode, flag, cabClassList, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 관리자 편철확정 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getUncabinetedDocCount.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getUncabinetedDocCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
	    userInfo = commonUtil.aprUserInfo(loginCookie);
	    
		String deptID = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String confirmYN = commonUtil.getTodayUTCTime("yyyy");
		String result = ezApprovalGService.getUncabinetedDocCount(deptID, confirmYN, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 관리자 편철확정 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/chkIfNotArrangedCabExist.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String chkIfNotArrangedCabExist(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
	    userInfo = commonUtil.aprUserInfo(loginCookie);

		String deptID = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.chkIfNotArrangedCabExist(deptID, companyID, userInfo.getTenantId());
		
		return result;
	}

	/**
	 * 전자결재G 관리자 편철확정 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/confirmClassfy.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String confirmClassfy(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String deptID = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		String result = ezApprovalGService.confirmClassify(deptID, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 전자결재 발송대장 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getSendOutDocList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSendOutDocList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String susinManagerFlag = request.getParameter("susinManagerFlag");
		String pageSize = request.getParameter("pageSize");
		String pageNum  = request.getParameter("pageNum");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		
		String result = ezApprovalGService.getSendOutDocList(userID, deptID, susinManagerFlag, pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}

	/**
	 * 전자결재G 정리대상목록 편철확인 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/endCabProduce.do", method = RequestMethod.GET)
	public String endCabProduce(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String tempYear = EgovDateUtil.getTodayTime().substring(0, 4);
		
		int pYear = Integer.parseInt(tempYear) - 1;
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pYear", pYear);
		
		return "ezApprovalG/apprGendCabProduce";
	}
	
	/**
	 * 전자결재G 정리대상목록 편철확인 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/endCabProduce.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String endCabProduce(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String companyID = request.getParameter("companyID");
		String cabClassNo = request.getParameter("cabClassNO");
		String flag = request.getParameter("flag");
		
		String result = ezApprovalGService.endCabProduce(cabClassNo.trim(), flag, companyID, userInfo.getTenantId() );
		
		return result;
	}
	
	/**
	 * 전자결재G 포틀릿 결재리스트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getPortletAprDocList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getPortletAprDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String pListType = request.getParameter("pListTypeName");
		String pUserID = request.getParameter("pUserID");
		String pUserDeptID = request.getParameter("pUserDeptID");
		String pPageSize = request.getParameter("pPageSize");
		String pPageNum = request.getParameter("pPageNum");
		String companyID = request.getParameter("companyID");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String searchQuery = request.getParameter("searchQuery");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String result = ezApprovalGService.getAprDocList(pListType, pUserID, pUserDeptID, pPageSize, pPageNum, orderCell, orderOption, companyID, searchQuery, userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return result;
	}

	/**
	 * 전자결재G 철생성 비치기록물 변경 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/insDisplayInfo.do")
	public String insDisplayInfo() throws Exception{
		return "ezApprovalG/apprGinsDisplayInfo";
	}

	/**
	 * 전자결재G 결재 일괄결재 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/doApprovAllG.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String doApprovAllG(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String rtnVal = "OK/0/0/0";
		int totCnt = 0, trueCnt = 0, falseCnt = 0;
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String userID = xmlDom.getElementsByTagName("USERID").item(0).getTextContent().trim();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		String pw = xmlDom.getElementsByTagName("PASSWD").item(0).getTextContent().trim();
		String langType = xmlDom.getElementsByTagName("LANGTYPE").item(0).getTextContent().trim();
		String formID = xmlDom.getElementsByTagName("FORMID").item(0).getTextContent().trim();
		String orgUID = "";
		
		if (xmlDom.getElementsByTagName("DOCID").getLength() > 0) {
			totCnt = xmlDom.getElementsByTagName("DOCID").getLength();
			
			for (int k = 0; k < xmlDom.getElementsByTagName("DOCID").getLength(); k++) {
				orgUID = xmlDom.getElementsByTagName("ORGAPRUSERID").item(k).getTextContent();
				
				  if (xmlDom.getElementsByTagName("TYPE").getLength() > 0) {
                      if (xmlDom.getElementsByTagName("TYPE").item(k).getTextContent().equals("MHT")) {
                          rtnVal = ezApprovalGService.mobileSrvConn(userID, "A", formID, "", xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, langType, companyID, pw, request, userInfo);
                      }
                      else {
                          rtnVal = ezApprovalGService.mobileSrvConn_HWP(userID, "A", formID, "", xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, langType, companyID, pw, request, userInfo);
                      }
                  }
                  else {
                      rtnVal = ezApprovalGService.mobileSrvConn(userID, "A", formID, "", xmlDom.getElementsByTagName("DOCID").item(k).getTextContent(), orgUID, langType, companyID, pw, request, userInfo);
                  }
				
				if (rtnVal.equals("ERROR")) {
					falseCnt++;
				} else {
					trueCnt++;
				}
			}
			
			if (falseCnt > 0) {
				rtnVal = "ERR/" + totCnt + "/" + trueCnt + "/" + falseCnt;
			} else {
				rtnVal = "OK/" + totCnt + "/" + trueCnt + "/" + falseCnt;
			}
		}
		
		return rtnVal;
	}

	/**
	 * 전자결재G 종료연기 종료연기신청 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/reqDelayCabEndY.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String reqDelayCabEndY(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String companyID = request.getParameter("companyID");
		String cabClassList = request.getParameter("cabClassList");
		String flag = request.getParameter("flag");
		
		String result = ezApprovalGService.reqDelayCabEndY(cabClassList, flag, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 발송의뢰문서 발송 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezSimsaG.do")
	public String ezSimsaG(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String docHref = request.getParameter("docHref");
		String orgDocID = request.getParameter("orgDocID");
		String accessInfo = config.getProperty("config.UserInfo_ApprovalG_VIEW");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		String pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		if (docID != null && docID.equals("")) {
			Document doc = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), "REC", userInfo.getCompanyID(), userInfo.getTenantId());
			
			if (doc.getElementsByTagName("DOCID").getLength() <= 0) {
				return "main/warning";
			}
			
			if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals(userInfo.getId()) && !doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("NULL")) {
				if (doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("") && (!doc.getElementsByTagName("RECEIVEDDEPTID").item(0).getTextContent().equals(userInfo.getDeptID()) || userInfo.getRollInfo().indexOf("a=1") == -1)) {
					return "main/warning";
				}
				
				if (!doc.getElementsByTagName("PROCESSORID").item(0).getTextContent().equals("")) {
					return "main/warning";
				}
			}
		}
		
		model.addAttribute("docID", docID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("accessInfo", accessInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("pass", pass);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalPWD", approvalPWD);
		
		return "ezApprovalG/apprGezSimsaG";
	}
	
	/**
	 * 전자결재G 발송의뢰문서 발송컨텐츠 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/enforceContent.do")
	public String enforceContent(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		model.addAttribute("editor", editor);
		
		return "ezApprovalG/apprGenforceContent";
	}
	
	/**
	 * 전자결재G 발송의뢰문서 발송 수신자 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ezReceiptInfo.do")
	public String ezReceiptInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		
		model.addAttribute("docID", docID);
		
		return "ezApprovalG/apprGezReceiptInfo";
	}

	/**
	 * 전자결재G 발송의뢰문서 발송 발송 저장 Method
	 */
	@RequestMapping(value = "/ezApprovalG/saveEndFile.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveEndFile(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String formText = request.getParameter("html");
		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String path = commonUtil.getRealPath(request) +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		InputStream stream = null;
		OutputStream bos = null;
		
		try {
		File file = new File(path + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID));
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		String saveFileName = path + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator + docID + ".mht";
	
			stream = new ByteArrayInputStream(formText.getBytes("UTF-8"));
			
			bos = new FileOutputStream(saveFileName);
			
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
		} catch (Exception e) {
		} finally {
			   if (bos != null) {
					try {
					    bos.close();
					} catch (Exception ignore) {
						logger.debug("IGNORED: {}", ignore.getMessage());
					}
			    }
			   if (stream != null) {
					try {
						stream.close();
					} catch (Exception ignore) {
						logger.debug("IGNORED: {}", ignore.getMessage());
					}
			    }
		}
		
		return "SUCCESS";
	}

	/**
	 * 전자결재G 발송의뢰문서 발송 발송 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/sendOfferAprove.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String sendOfferAprove(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String orgDocID = request.getParameter("orgDocID");
		String userID = request.getParameter("userID");
		String userName = request.getParameter("userName");
		String userName2 = request.getParameter("userName2");
		String deptID = request.getParameter("deptID");
		
		String dirPath = commonUtil.getRealPath(request) +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = ezApprovalGService.doSendOfferApprove(docID, orgDocID, userID, userName, userName2, deptID, dirPath, "", userInfo.getCompanyID(), userInfo.getLang(), userInfo);
		
		return result;
	}

	/**
	 * 전자결재G 발송의뢰문서 발송 반송 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/sendOfferReject.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String sendOfferReject(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String result = ezApprovalGService.doSendOfferReject(docID, userID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 기록물 열람권한 확인 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getUserRecRight.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getUserRecRight(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String companyID = request.getParameter("companyID");
		String recID = request.getParameter("recID");
		String sepAttNo = request.getParameter("sepAttNo");
		String userID = request.getParameter("userID");
		
		String result = ezApprovalGService.getUserRecRight(recID, sepAttNo, userID, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 겸직 쿠키 생성 Method
	 */
	@RequestMapping(value = "/ezApprovalG/ChangeUserInfo.do")
	public void changeUserInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String deptID = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptName2 = request.getParameter("deptName2");
		String title = request.getParameter("position");
		String title2 = request.getParameter("position2");
		
		Cookie cookieID0 = new Cookie("APRUI0", deptID);
    	cookieID0.setPath("/");
    	response.addCookie(cookieID0);
    	
    	Cookie cookieID1 = new Cookie("APRUI1", URLEncoder.encode(deptName, "utf-8"));
    	cookieID1.setPath("/");
    	response.addCookie(cookieID1);
    	
    	Cookie cookieID2 = new Cookie("APRUI2", URLEncoder.encode(title, "utf-8"));
    	cookieID2.setPath("/");
    	response.addCookie(cookieID2);
    	
    	Cookie cookieID4 = new Cookie("APRUI4", URLEncoder.encode(deptName2, "utf-8"));
    	cookieID4.setPath("/");
    	response.addCookie(cookieID4);
    	
    	Cookie cookieID6 = new Cookie("APRUI6", URLEncoder.encode(title2, "utf-8"));
    	cookieID6.setPath("/");
    	response.addCookie(cookieID6);
	}
	
	/**
	 * 전자결재G 회송후 대장등록  Method
	 */
	@RequestMapping(value = "/ezApprovalG/removeDocCabinetInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String removeDocCabinetInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("removeDocCabinetInfo Started");
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String deptID = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptName2 = request.getParameter("deptName2");
		String flag = request.getParameter("flag");
		String dirPath = commonUtil.getRealPath(request) +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		String result = ezApprovalGService.setCabinetReject(docID, deptID, deptName, deptName2, dirPath, flag, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLocale());
		
		if(result.indexOf("FALSE") > -1) {
			if (!result.split(",")[1].trim().equals("")) {
        		ezApprovalGService.rollbackCabinetNum(deptID, "", result.split(",")[1], userInfo.getCompanyID(), "", userInfo.getLang(), userInfo.getTenantId());
        	}
		}
		logger.debug("removeDocCabinetInfo ended");

		return result.split(",")[0];
	}
	
	/**
	 * 전자결재G 기록물등록대장 공람발송 호출  Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprGongRamLine.do")
	public String aprGongRamLine(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String type = "APR";
		String serverName = userInfo.getServerName();
		
		if (request.getParameter("type") != null) {
			type = request.getParameter("type");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("type", type);
		model.addAttribute("serverName", serverName);
		
		return "ezApprovalG/apprGaprGongRamLine";
	}
	
	/**
	 * 전자결재G 기록물등록대장 공람발송 등록  Method
	 */
	@RequestMapping(value = "/ezApprovalG/gongRamSave.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String gongRamSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String type = "APR";
		
		if (request.getParameter("type") != null) {
			type = request.getParameter("type");
		}
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String dirPath = commonUtil.getRealPath(request) +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String result = "";
		
		if (type.equals("APR")) {
			result = ezApprovalGService.gongRamSave(xmlDom, dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		} else {
			result = ezApprovalGService.gongRamSaveEnd(xmlDom, dirPath, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		}
		
		return result;
	}
	
	/**
	 * 전자결재G 임시저장 재기안 Method
	 */
	@RequestMapping(value = "/ezApprovalG/makeTmp2Ing.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String makeTmp2Ing(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("tmpDocID");
		String userID = docID.split("@")[0];
		String sn = docID.split("@")[1];
		String result = ezApprovalGService.makeTmp2IngDocInfo(userID, sn, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 메일보내기 Method
	 */
	@RequestMapping(value = "/ezApprovalG/sendToMailApproval.do")
	public String sendToMailApproval(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String docHref = request.getParameter("docHref");
		String cmd = request.getParameter("cmd");
		String docID = request.getParameter("docID");
		String strImgCount = "";
		//TODO 결재문서 ezCommon 경로에 이미지 저장하는 부분 제외 아직까지 사용하는부분 없어서... 모바일쪽에서 사용할지도 
		
         
		return "redirect:/ezEmail/mailWrite.do?docHref=IMAGE&cmd=" + cmd + "&docID=" + docID + "&imageCnt=" + strImgCount + "&target=APPROVALG";
	}
	
	/**
	 * 전자결재G 메일보내기 Method
	 */
	@RequestMapping(value = "/ezApprovalG/createMailImg.do" )
	@ResponseBody
	public String createMailImg(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String strPath = commonUtil.getRealPath(request)+ commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId()) + commonUtil.separator + commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(0,10).replace("-", "") ;
		FileOutputStream stream = null;
		try{
		File file = new File(strPath);
		
		if (!file.exists()) {
			file.mkdirs();
		}
		String data = request.getParameter("imgUrl");
		
	     if(data == null || data=="") {
	         throw new Exception();    
	     }
	     data = data.replaceAll("data:image/png;base64,", "");
	     byte[] file2 = Base64.decodeBase64(data);
	     
	    
//	     stream = new FileOutputStream("E:\\test2\\aaaaa.png");
	     stream = new FileOutputStream(strPath+commonUtil.separator+docID+".png");
	     stream.write(file2);
		}  catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		}  finally {
			   if (stream != null) {
					try {
						stream.close();
					} catch (Exception ignore) {
						logger.debug("IGNORED: {}", ignore.getMessage());
					}
			    }
		}
	     
	     return "true";
	}
	
	/**
	 * 전자결재G 부서병렬합의 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recev.do")
	public String recev(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String draftFlag = request.getParameter("draftFlag");
		String susinAdmin = "";
		String optSignDateFormat = "";
		String optisSplit = "";
		String optSplitKind = "";
		String userDirectSign = "";
		String draftDate = "";
		String approvalPWD = ezApprovalGService.getApprovalPWD(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", userInfo, "CODE");
		optisSplit = ezApprovalGService.getOptionInfo("A33", "001", userInfo, "CODE");
		optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", userInfo, "CODE");
		
		userDirectSign = ezCommonService.getTenantConfig("USE_DirectSign", userInfo.getTenantId());
		
		draftDate = commonUtil.getTodayUTCTime("");
		
		model.addAttribute("docID", docID);
		model.addAttribute("draftFlag", draftFlag);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("optSignDateFormat", optSignDateFormat);
		model.addAttribute("optisSplit", optisSplit);
		model.addAttribute("optSplitKind", optSplitKind);
		model.addAttribute("userDirectSign", userDirectSign);
		model.addAttribute("draftDate", draftDate);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("approvalPWD", approvalPWD);
		
		return "ezApprovalG/apprGrecev";
	}
	
	/**
	 * 전자결재G 결재정보 수신처 민원인주소입력 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprDeptAddressUserName.do")
	public String aprDeptAddressUserName() throws Exception{
		return "ezApprovalG/apprGaprDeptAddressUserName";
	}
	
	/**
	 * 전자결재G 부서병렬합의 접수 컨텐츠 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recevContent.do")
	public String recevContent() throws Exception{
		return "ezApprovalG/apprGrecevContent";
	}
	
	/**
	 * 전자결재G 부서병렬합의 접수 컨텐츠2 Method
	 */
	@RequestMapping(value = "/ezApprovalG/recevContent2.do")
	public String recevContent2() throws Exception{
		return "ezApprovalG/apprGrecevContent2";
	}
	
	/**
	 * 전자결재G 결재선 사용자 포함여부 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/checkAprLineUser.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String checkAprLineUser(@CookieValue("loginCookie") String loginCookie,  LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		String userID = request.getParameter("userID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGService.checkAprLine(docID, mode, userID, companyID, userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 수신순번 겟 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getSusinSN.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSusinSN(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String docID = doc.getElementsByTagName("DOCID").item(0).getTextContent();
		
		String result = ezApprovalGService.getSusinSN(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		return result;
	}
	
	/**
	 * 전자결재G 결재할문서 개수 가져오기 Method
	 */	
	@RequestMapping(value = "/ezApprovalG/getWebPartCount.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getWebPartCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String pFlag = doc.getElementsByTagName("FLAG").item(0).getTextContent();
		
		int result = ezApprovalGService.getWebPartListCount(pFlag, userInfo.getId(), userInfo.getDeptID(), "", "COUNT", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		
		return "<DATA><RESULT>"+result+"</RESULT></DATA>";
	}
	
	/**
	 * 전자결재G 강제회수
	 */	
	@RequestMapping(value = "/ezApprovalG/doCancelForce.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String doCancelForce(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,  HttpServletRequest request ,@RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String docID = doc.getElementsByTagName("docID").item(0).getTextContent();
		String userID = doc.getElementsByTagName("userID").item(0).getTextContent();
		String result = ezApprovalGService.doCancelForce(docID, userID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		if(result == "OK") {
			result = "<RESULT>TRUE</RESULT>";
		} else {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}
	
	
	@RequestMapping(value = "/ezApprovalG/uploadDocHistory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String uploadDocHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,  HttpServletRequest request ,@RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String docID = doc.getElementsByTagName("pDocID").item(0).getTextContent();
		String pHTML = doc.getElementsByTagName("pHtml").item(0).getTextContent().replace("\r\n", "\n").replace("\n", "\r\n");

		String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
		String fileName = docID + "-" + commonUtil.getTodayUTCTime("yyyyMMddHHmmss")+ ".mht";
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID()  +  commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID)  + commonUtil.separator + "history" ;
		String dirPath2 = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID()  +  commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID);
		
		InputStream stream = null;
		OutputStream bos = null;
		
		try {
			File file = new File (dirPath2);
			if(!file.exists()) {
				file.mkdirs();
			}
			
			File file2 = new File (dirPath);
			if(!file2.exists()) {
				file2.mkdirs();
			}
		
			stream = new ByteArrayInputStream(pHTML.getBytes("UTF-8"));
			
			bos = new FileOutputStream(dirPath + commonUtil.separator  + fileName);
			
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} catch (Exception e) {
		} finally {
		   if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		   if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
		return dirPath+ commonUtil.separator  + fileName;
		}
	/**
	 * 전자결재G 문서 내용 변경 이력
	 */	
	@RequestMapping(value = "/ezApprovalG/updateDocHistory.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String updateDocHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo,  HttpServletRequest request ,@RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(xmlPara);
		String docID = doc.getElementsByTagName("pDocID").item(0).getTextContent();
		String url = doc.getElementsByTagName("pURL").item(0).getTextContent();
		String userID = doc.getElementsByTagName("pUserID").item(0).getTextContent();
		String userName = doc.getElementsByTagName("pUserName").item(0).getTextContent();
		String userJobTitle = doc.getElementsByTagName("pUserJobTitle").item(0).getTextContent();
		String userDeptID = doc.getElementsByTagName("pUserDeptID").item(0).getTextContent();
		String userDeptName = doc.getElementsByTagName("pUserDeptName").item(0).getTextContent();
		String userName2 = doc.getElementsByTagName("PUSERNAME2").item(0).getTextContent();
		String userJobTitle2 = doc.getElementsByTagName("PUSERJOBTITLE2").item(0).getTextContent();
		String userDeptName2 = doc.getElementsByTagName("PUSERDEPTNAME2").item(0).getTextContent();

		String result = ezApprovalGService.updateHistoryForDoc(docID, url, userID, userName, userName2, userJobTitle, userJobTitle2, userDeptID, userDeptName, userDeptName2, userInfo);
		
		return result;
	}
}