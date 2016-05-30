package egovframework.ezEKP.ezApprovalG.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.HandlerMapping;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

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
public class EzApprovalGController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties globals;

	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Autowired
	private EgovMessageSource messageSource;
	
	/**
	 * 전자결재G 메인화면 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/apprGMain.do")
	public String apprGMain(HttpServletRequest request, Model model){
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
		String viewLeftCount = config.getProperty("config.APPROVLEFTCOUNT");
		String listType = request.getParameter("listType");
		String userSendOut = "";
		String firstContainerID = "";
		String subTitleString = "";
		boolean isSubTitle = false;
		StringBuffer containers = new StringBuffer();
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		List<ApprGLeftVO> apprGLeftVOList = ezApprovalGService.getUseContInfo(userInfo, "2");
		String sendOutDept = ezApprovalGService.getOptionInfo("A55", "001", userInfo, "CODE");
		String optGamsabu = ezApprovalGService.getOptionInfo("A40", "001", userInfo, "CODE");
		
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
		String infoXML = ezOrganService.getPropertyValue(userInfo.getDeptID(), "extensionAttribute4");
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
		model.addAttribute("strLang", commonUtil.getMultiData(userInfo.getLang()));
		
		return "ezApprovalG/apprGLeft";
	}

	/**
	 * 전자결재G 서브타이틀 실행 Method
	 */
	public void getUserSubTitle(LoginVO userInfo, List<Object> referenceTemp) throws Exception{
		String propList = "extensionAttribute4;department;description;title;title2;description2";
		String results = ezOrganService.getPropertyList(userInfo.getId(), propList, userInfo.getLang());
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
        
        myDept = userInfo.getLang().equals("1") ? deptName : deptName2;
        
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
        
        if (!userInfo.getLang().equals("1")) {
        	lang = "2";
        }
        
        if (!deptInfo.equals("")) {
        	isSubTitle = true;
        	String[] deptList = deptInfo.split(";");
        	
        	for (int k = 0; k < deptList.length; k++) {
        		String[] subList = deptList[k].split(":");
        		String pTitle_ = userInfo.getLang().equals("1") ? commonUtil.cleanValue(subList[1]) : commonUtil.cleanValue(subList[2]);
                String pTitle1_ = commonUtil.cleanValue(subList[1]);
                String pTitle2_ = commonUtil.cleanValue(subList[2]);
                String pDeptNM1_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DISPLAYNAME"));
                String pDeptNM2_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DISPLAYNAME2"));
                String pDeptNM_ = userInfo.getLang().equals("1") ? pDeptNM1_ : pDeptNM2_;
                
                if (userInfo.getDeptID().equals(subList[0])) {
                    if (pTitle_.equals("")) {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "'  selected>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang)) + "</option>";
                    } else {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "'  selected>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang)) + "[" + pTitle_ + "]" + "</option>";
                    }
                } else {
                    if (pTitle_.equals("")) {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "' >" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang)) + "</option>";
                    } else {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "' >" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang)) + "[" + pTitle_ + "]" + "</option>";
                    }
                }
        	}
        }
        referenceTemp.set(0, subTitleString);
        referenceTemp.set(1, isSubTitle);
	}
	
	/**
	 * 전자결재G 우측리스트 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/aprManage.do")
	public String aprManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
		String openYear = config.getProperty("config.Site_OpenYear");
		String buJaeInfo = "";
		String nowDate = EgovDateUtil.convertDate(egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "");
		String susinAdmin = "";
		String listType = request.getParameter("listType");
		String viewLeftCount = config.getProperty("config.APPROVLEFTCOUNT");
		String useMobile = config.getProperty("config.Use_Mobile");
		String useOcs = config.getProperty("config.USE_OCS");
		String selMenu = "all";
		
		userInfo = commonUtil.userInfo(loginCookie);
		nowDate = nowDate.substring(0, 16);
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getLang());
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
		
		userInfo = commonUtil.userInfo(loginCookie);
		
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

            if (userLang.equals("2")) {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    returnQuery += " AND WRITERNAME" + userLang + " LIKE '%" + domSub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                }
            } else {
                if (tempQuery.indexOf("WRITERNAME;") != -1) {
                    returnQuery += " AND WRITERNAME LIKE '%" + domSub.getElementsByTagName("WRITERNAME").item(0).getTextContent() + "%' ";
                }
            }

            if (userLang.equals("2")) {
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
                	returnQuery += " AND RECEIVEDDATE >= TO_DATE('" + domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01','YYYY-MM-DD HH24:MI:SS') ";
                } else {
                	returnQuery += " AND STARTDATE >=TO_DATE('" + domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01','YYYY-MM-DD HH24:MI:SS') ";
                }
            }
            
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
                if (listType.equals("10")){
                	returnQuery += " AND RECEIVEDDATE <= TO_DATE('" + domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59','YYYY-MM-DD HH24:MI:SS') ";
                } else {
                	returnQuery += " AND STARTDATE <= TO_DATE('" + domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59','YYYY-MM-DD HH24:MI:SS') ";
                }
            }
            
            if (tempQuery.indexOf("FORMID;") != -1) {
                returnQuery += " AND FormID = '" + domSub.getElementsByTagName("FORMID").item(0).getTextContent() + "' ";
            }
            
            if (tempQuery.indexOf("KAPR;") != -1) {
                returnQuery += " AND keyword LIKE '%" + domSub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
            }
            
            if (tempQuery.indexOf("KEND;") != -1) {
                returnQuery += " AND TBEXPAPRDOCINFO.keyword LIKE '%" + domSub.getElementsByTagName("KEYWORD").item(0).getTextContent() + "%' ";
            }
            
            if (tempQuery.indexOf("CAPR;") != -1) {
                returnQuery += " AND TBEXPENDAPRDOCINFO.itemcode = '" + domSub.getElementsByTagName("itemCODE").item(0).getTextContent() + "' ";
            }
            
            if (tempQuery.indexOf("CEND;") != -1) {
                returnQuery += " AND TBEXPAPRDOCINFO.itemcode = '" + domSub.getElementsByTagName("itemCODE").item(0).getTextContent() + "' ";
            }
            
            if (tempQuery.indexOf("URGENTAPPROVAL;") != -1) {
                returnQuery += " AND URGENTAPPROVAL = '" + domSub.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent() + "' ";
            }
            
            searchQuery = returnQuery;
		}
		
		String resultXML = ezApprovalGService.aprDocList(listType, userID, deptID, pageSize, pageNum, orderCell, orderOption, companyID, userLang, searchQuery, domSub);
		
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
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			if (mode.toUpperCase().equals("APR") || mode.toUpperCase().equals("TMP")) {
				if (docID != null && !docID.equals("")) {
					String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1");
					String[] proxyUserArray = proxyUser.split(",");
					boolean checkPermission = true;
					
					if (proxyUserArray.length > 1) {
						String docList = ezApprovalGService.getAprLineInfoDB(docID.trim(), "1", "", "", userInfo.getCompanyID());
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
						int cp = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), checkMode, userInfo.getCompanyID());
						
						if (cp <= 0) {
							return "NOTPERMISSION";
						}
					}
				}
			} else if (mode.toUpperCase().equals("END")) {
				String accessInfo = config.getProperty("config.UserInfo_ApprovalG_VIEW");
				String pass = ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang());
				
				if (!pass.equals("<RESULT>TRUE</RESULT>")) {
					return "NOTPERMISSION";
				}
			}
		}
		String result = "";
		
		if (requestURL.indexOf("getLineList") > -1) {
			result = ezApprovalGService.getLineInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang());
		} else if (requestURL.indexOf("getTotalAttachInfo") > -1) {
			result = ezApprovalGService.getAttachInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang());
		} else if (requestURL.indexOf("getReceiptinfo") > -1) {
			result = ezApprovalGService.getReceiptInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang());
		} else if (requestURL.indexOf("getOpinionInfo") > -1) {
			result = ezApprovalGService.getOpinionInfo(docID, mode, "", "", userInfo.getCompanyID(), userInfo.getLang());
		}
		
		return result;
	}
	
	/**
	 * 전자결재G 레프트메뉴카운트 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getListCount.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getListCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, @RequestBody String docXml) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(docXml);
		String listType = doc.getElementsByTagName("LISTTYPE").item(0).getTextContent();
		String mode = request.getParameter("mode");
		String susinAdmin = "user";
		String result = "";
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "admin";
		}
		
		if (mode != null) {
			result = ezApprovalGService.getWebPartList(listType, userInfo.getId(), userInfo.getDeptID(), "", "LEFT", susinAdmin, userInfo.getCompanyID(), userInfo.getLang());
		} else {
			result = ezApprovalGService.getWebPartList(listType, userInfo.getId(), userInfo.getDeptID(), "", "COUNT", susinAdmin, userInfo.getCompanyID(), userInfo.getLang());
		}
		
		return result;
	}
	
	/**
	 * 전자결재G 기안양식 호출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getFormCont.do")
	public String getFormCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String deptID = userInfo.getDeptID();
		String docType = ezApprovalGService.getDocType("", userInfo.getCompanyID(), userInfo.getLang());
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
		userInfo = commonUtil.userInfo(loginCookie);
		String id = request.getParameter("id");
		String kind = request.getParameter("kind");
		String searchType = request.getParameter("searchType");
		String searchName = request.getParameter("searchName");
		String result = ezApprovalGService.getFormInfo(id.trim(), kind, searchType, searchName, userInfo.getId(), userInfo.getCompanyID(), userInfo.getLang());
		
		return result;
	}
	
	/**
	 * 전자결재G 기안양식함 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/getFormContainer.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormContainer(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String id = request.getParameter("id");
		String deptID = request.getParameter("deptID");
		String result = ezApprovalGService.getFormContainerInfo(id, deptID, userInfo.getCompanyID());
		
		return result;
	}
	
	/**
	 * 전자결재G 양식즐겨찾기등록 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/setFormUserInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String setFormUserInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String para, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(para);
		String formID = doc.getElementsByTagName("PARA").item(0).getTextContent();
		String result = ezApprovalGService.setUserFormInfo(formID.trim(), userInfo.getId(), userInfo.getCompanyID());
		
		return result;
	}
	
	/**
	 * 전자결재G 양식즐겨찾기삭제 표출 Method
	 */
	@RequestMapping(value = "/ezApprovalG/delFormUserInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delFormUserInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String para, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(para);
		String formID = doc.getElementsByTagName("PARA").item(0).getTextContent();
		String result = ezApprovalGService.delUserFormInfo(formID.trim(), userInfo.getId(), userInfo.getCompanyID());
		
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
		userInfo = commonUtil.userInfo(loginCookie);
		String useEditor = config.getProperty("config.EDITOR");
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
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		if (listType.equals("21")) {
			if (request.getParameter("docSN") != null) {
				docSN = request.getParameter("docSN");
			}
		}
		
		String dirPath = "/upload_ApprovalG" + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0,4) + commonUtil.separator;
		String mode = "APR";
		String docID = isTmpDoc;
		
		if (listType.equals("1") || listType.equals("2") || listType.equals("3")) {
			mode = "APR";
		} else if (listType.equals("4") || listType.equals("6") || listType.equals("10") || listType.equals("99")) {
			mode = "REC";
		} else if (listType.equals("21")) {
			docID = docSN;
			mode = "TMP";
		}
		
		if (docID != null && !docID.equals("")) {
			String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1");
			String[] proxyUserArray = proxyUser.split(",");
			boolean checkPermission = true;
			
			if (proxyUserArray.length > 1) {
				String docList = ezApprovalGService.getAprLineInfoDB(docID.trim(), "1", "", "", userInfo.getCompanyID());
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
				int cp = ezApprovalGService.checkPermission(docID.trim(), userInfo.getId(), userInfo.getDeptID(), mode, userInfo.getCompanyID());
				
				if (cp <= 0) {
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
	
	@RequestMapping(value = "/ezApprovalG/getApprovalPWD.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String getApprovalPWD(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String result = ezApprovalGService.getApprovalPWD(userInfo.getId());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/draftContent.do")
	public String draftContent(HttpServletRequest request, Model model) throws Exception{
		String mode = "";
		String editor = config.getProperty("config.EDITOR");
		
		if (request.getParameter("draftFlag") != null) {
			mode = request.getParameter("draftFlag");
		}
		
		model.addAttribute("mode", mode);
		model.addAttribute("editor", editor);
		
		return "ezApprovalG/apprGDraftContent";
	}
	
	@RequestMapping(value = "/ezApprovalG/ckEditor.do")
	public String ckEditor(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		String height = request.getParameter("height");
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("height", height);
		model.addAttribute("userInfo", userInfo);
		
		return "ezApprovalG/apprGCKEditor";
	}
	
	@RequestMapping(value = "/ezApprovalG/getCodeData.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getCodeData(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String code1 = request.getParameter("code1");
		String code2 = request.getParameter("code2");
		String flag = request.getParameter("flag");
		String result = ezApprovalGService.getOptionInfo(code1, code2, userInfo, flag);
		
		return "<RESULT>" + result + "</RESULT>";
	}
	
	@RequestMapping(value = "/ezApprovalG/ezApprovalInfo.do")
	public String ezApprovalInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String securityNode3 = ezApprovalGService.getSecurityType("", userInfo.getCompanyID(), commonUtil.getMultiData(userInfo.getLang()));
		String startDateTime = EgovDateUtil.getTodayTime();
		String endDateTime = EgovDateUtil.getTodayTime();
		String initFlag = request.getParameter("initFlag");
		String guBun = request.getParameter("guBun").trim();
		String docSN = "";
		String susinAdmin = "";
		String aprTypeXML = "";
		String useOcs = config.getProperty("config.USE_OCS");
		
		if (request.getParameter("docSN") != null) {
			docSN = request.getParameter("docSN");
		}
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		if (initFlag.trim().equals("")) {
			initFlag = "0";
		}
		
		aprTypeXML = ezApprovalGService.getAprType(userInfo.getCompanyID(), userInfo.getLang());
		
		String optGamsabu = ezApprovalGService.getOptionInfo("A40", "001", userInfo, "CODE");
		String susinGroupUseFlag = ezApprovalGService.getCode2Name("A53", "002", userInfo.getCompanyID(), userInfo.getLang());
		
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
	
	@RequestMapping(value = "/ezApprovalG/aprLineRequest.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprLineRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.getAprLineInfo(docID.trim(), userID, formID, userInfo.getCompanyID(), userInfo.getLang());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/getLineTemplist.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getLineTemplist(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Locale locale) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String tempList = ezApprovalGService.getTempList(userID, formID, userInfo.getCompanyID(), userInfo.getLang());
		String headerXML = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + messageSource.getMessage("ezApprovalG.t379", locale) + "</NAME><WIDTH>100%</WIDTH></HEADER></HEADERS><ROWS>" + tempList + "</ROWS></LISTVIEWDATA>";
		
		return headerXML;
	}
	
	@RequestMapping(value = "/ezApprovalG/formCheckUI.do")
	public String formCheckUI(){
		return "ezApprovalG/apprGFormCheckUI";
	}
	
	@RequestMapping(value = "/ezApprovalG/ezAprOpinion.do")
	public String ezAprOpinion(){
		return "ezApprovalG/apprGezAprOpinion";
	}

	@RequestMapping(value = "/ezApprovalG/aprLineSave.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprLineSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String ret) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String result = ezApprovalGService.updateLineInfo(ret, userInfo.getCompanyID(), userInfo.getLang());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/aprDeptSave.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprDeptSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String ret2) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String result = ezApprovalGService.updateReceiptInfo(ret2, userInfo.getCompanyID(), userInfo.getLang());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/aprLineTempletName.do")
	public String aprLineTempletName(){
		return "ezApprovalG/apprGaprLineTempletName";
	}
	
	@RequestMapping(value = "/ezApprovalG/aprLineTempletList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprLineTempletList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.getLineTempletInfo(formID, userID, userInfo.getCompanyID());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/aprLineTempletListInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String aprLineTempletListInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprSN = request.getParameter("aprLineSN");
		String result = ezApprovalGService.getLineTempletDetailInfo(formID, userID, aprSN, userInfo.getCompanyID(), userInfo.getLang());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/getFormDetail.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getFormDetail(HttpServletRequest request) throws Exception{
		String formID = request.getParameter("formID");
		String companyID = request.getParameter("companyID");
		String resultXML = ezApprovalGService.getFormInfoDetail(formID, companyID);
		
		return resultXML;
	}
	
	@RequestMapping(value = "/ezApprovalG/getFormRecv.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String getFormRecv(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.getFormRecvApr(docID, formID, userInfo.getId(), userInfo.getCompanyID(), userInfo.getLang());

		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/createNewDoc.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String createNewDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String formID = request.getParameter("formID");
		String result = ezApprovalGService.createNewDoc(formID, userInfo.getCompanyID());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/getFullDate.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String getFullDate(){
		String fullDate = EgovDateUtil.getTodayTime();
		fullDate = fullDate.substring(0, 16).replace("-", "."); 
		
		return fullDate;
	}
	
	@RequestMapping(value = "/ezApprovalG/getDate.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String getDate(){
		String fullDate = EgovDateUtil.getTodayTime();
		fullDate = fullDate.substring(0, 10).replace("-", ".");
		
		return fullDate;
	}
	
	@RequestMapping(value = "/ezApprovalG/undoDoc.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String undoDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String result = ezApprovalGService.deleteDocInfo(docID, "CHECK", userInfo.getCompanyID());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/createAprLineTemplet.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String createAprLineTemplet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody String aprLineXml) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(aprLineXml);
		String result = ezApprovalGService.updateLineTempletDetailInfo(xmlDom, userInfo.getCompanyID(), userInfo.getLang());

		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/delAprLineTempletList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String delAprLineTempletList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprLineSN = request.getParameter("aprLineSN");
		String result = ezApprovalGService.deleteLineTempletDetailInfo(formID, userID, aprLineSN, userInfo.getCompanyID());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/addToAprLine.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String addToAprLine(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String aprSN = request.getParameter("aprSN");
		String result = ezApprovalGService.addToAprLine(userID, formID, aprSN, userInfo.getCompanyID(), userInfo.getLang());
		
		return result;
	}
}
