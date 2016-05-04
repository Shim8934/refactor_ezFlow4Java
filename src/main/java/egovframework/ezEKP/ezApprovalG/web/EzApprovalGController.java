package egovframework.ezEKP.ezApprovalG.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

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
	private void getUserSubTitle(LoginVO userInfo, List<Object> referenceTemp) throws Exception{
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
		String viewLeftCount = config.getProperty("APPROVLEFTCOUNT");
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
	@RequestMapping(value = "/ezApprovalG/getLineList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getLineList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		String docID = request.getParameter("docID");
		String mode = request.getParameter("mode");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			if (mode.toUpperCase().equals("APR") || mode.toUpperCase().equals("TMP")) {
				if (docID != null && !docID.equals("")) {
					String proxyUser = ezApprovalGService.getProxyUser(userInfo.getId(), "1");
					String[] proxyUserArray = proxyUser.split(",");
					boolean checkPermission = true;
					
					if (proxyUserArray.length > 1) {
						String docList = ezApprovalGService.getAprLineInfo(docID.trim(), "1", "", "", userInfo.getCompanyID());
						Document docXML = commonUtil.convertStringToDocument(docList);
						
						for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
							
						}
					}
				}
			}
		}
		return "";
	}
}
