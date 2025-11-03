package egovframework.ezEKP.ezOrgan.web;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.TeamsOrganVO;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.CommonUtil.PasswordCheckPolicyResult;

/** 
 * @Description [Controller] 조직도 및 부서
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    장진혁    신규작성
 *
 * @see
 */

@Controller
public class EzOrganController {
	
    private static final Logger logger = LoggerFactory.getLogger(EzOrganController.class);
    
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzOrganService ezOrganService;	

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	/**
	 * 지정된 부서가 선택된 형태의 조직도 트리를 XML 형식으로 반환한다.
	 */
	@RequestMapping(value = "/ezOrgan/getDeptTreeInfo.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptTreeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("getDeptTreeInfo started.");
	    
	    String deptInfo = null;
		
	    try {
	    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
	        int tenantID = userInfo.getTenantId();        
	        
	        logger.debug("tenantID=" + tenantID);       
			
			Document doc = commonUtil.convertStringToDocument(data);
			
			String userID = "";
			String deptID = doc.getElementsByTagName("DEPTID").item(0).getTextContent();
	        String topID = doc.getElementsByTagName("TOPID").item(0).getTextContent();
	        String propList = doc.getElementsByTagName("PROP").item(0).getTextContent();
	        String adminDist = doc.getElementsByTagName("ADMINDIST").getLength() != 1 ? "false" : doc.getElementsByTagName("ADMINDIST").item(0).getTextContent(); // 관리자 > 공용배포그룹
	        String displayTrashDept = doc.getElementsByTagName("DISPLAYTRASHDEPT").getLength() != 1 ? "" : doc.getElementsByTagName("DISPLAYTRASHDEPT").item(0).getTextContent(); // 조직도에서 폐지부서 표출 여부
	        String userCompanyID = userInfo.getCompanyID();
	        String [] adminOrganChk = topID.split("/"); // 관리자 페이지  > 조직도, 겸직, 권한 관리에서 topId + "/organ" 붙임
	        String orgCompanyID = doc.getElementsByTagName("orgCompanyID").getLength() != 1 ? "" : doc.getElementsByTagName("orgCompanyID").item(0).getTextContent(); // 전자결재 orgCompanyID
	        String adminChk = doc.getElementsByTagName("ADMINCHK").getLength() != 1 ? "" : doc.getElementsByTagName("ADMINCHK").item(0).getTextContent(); // 전체관리자 = true (ip접속관리 관리자페이지)
			String adminOrgan = doc.getElementsByTagName("ADMINORGAN").getLength() != 1 ? "n" : doc.getElementsByTagName("ADMINORGAN").item(0).getTextContent(); // 관리자 조직도 유무
			String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId()) != ""? ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId()) : "NO";
			// useOganHideFlag를 사용하지 않으면 adminOrgan을 다 "y"로 둬서 조직도숨김을 뺀다.
			adminOrgan = "NO".equalsIgnoreCase(useOrganHideFlag) ? "y" : adminOrgan;
			
	        if (adminDist.equals("true") || (adminOrganChk.length > 1 && adminOrganChk[1].equals("other"))) {
	        	topID = adminOrganChk[0];
	        } else if (adminOrganChk.length > 1 && adminOrganChk[1].equals("organ")) { // 전체 관리자 관리자페이지 일부에서 조직도 전체 트리 보여줌
			} else if (!orgCompanyID.equals("") && !orgCompanyID.equals("undefined")) {
				topID = orgCompanyID;
			} else if (!topID.equals(userCompanyID) && adminChk.equals("true")) {
				deptID = topID;
			} else {
	        	topID = userCompanyID;
	        }
	        
	        logger.debug("deptID=" + deptID + ",topID=" + topID + ",propList=" + propList + ",userCompanyID=" + userCompanyID + ",displayTrashDept=" + displayTrashDept);
	        
	        // 지정된 부서가 선택된 형태의 조직도 트리를 XML 형식으로 반환한다.
	        deptInfo = ezOrganService.getDeptTreeInfo(userID, deptID, topID, propList, userInfo.getPrimary(), displayTrashDept, tenantID, adminOrgan);
	    } catch (Exception e) {
	    	logger.error(e.getMessage(), e);
	    }
		
        logger.debug("getDeptTreeInfo ended.");
        
		return deptInfo;
	}
	
	/**
	 * 지정된 부서의 바로 아래에 위치한 자식 부서 목록을 XML 형식으로 반환한다.
	 */
	@RequestMapping(value = "/ezOrgan/getDeptSubTreeInfo.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptSubTreeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("getDeptSubTreeInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
				
		String deptID = doc.getElementsByTagName("DEPTID").item(0).getTextContent();        
        String propList = doc.getElementsByTagName("PROP").item(0).getTextContent();
		String adminOrgan = doc.getElementsByTagName("ADMINORGAN").getLength() > 0 ? doc.getElementsByTagName("ADMINORGAN").item(0).getTextContent() : "n"; // 관리자 조직도 유무 
		String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId()) != ""? ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId()) : "NO";
		// useOganHideFlag를 사용하지 않으면 adminOrgan을 다 "y"로 둬서 조직도숨김을 뺀다.
		adminOrgan = "NO".equalsIgnoreCase(useOrganHideFlag) ? "y" : adminOrgan;
		
        boolean displayTrashDept = doc.getElementsByTagName("DISPLAY_TRASH_DEPT").getLength() > 0;
        String deptInfo = ezOrganService.getDeptSubTreeInfo(deptID, propList, userInfo.getPrimary(), userInfo.getTenantId(), displayTrashDept, adminOrgan);
		
        logger.debug("getDeptSubTreeInfo ended");
        
		return deptInfo;	
	}
	
	/**
	 * 조직도 부서 FULL PATH 정보 호출 함수
	 */
	@RequestMapping(value = "/ezOrgan/getDeptFullPath.do", method = RequestMethod.POST, produces="text/html;charset=utf-8")
	@ResponseBody
	public String getDeptFullPath(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("getDeptFullPath started");
	    
	    LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String cn = request.getParameter("cn");
		
		String result = ezOrganService.getDeptFullPath(cn, userInfo.getTenantId());
		
		logger.debug("getDeptFullPath ended");
		
		return result;
	}
	
	/**
	 * 조직도 부서 사원목록 호출 함수
	 */
	@RequestMapping(value = "/ezOrgan/getDeptMemberList.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptMemberList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("getDeptMemberList started");
	    
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptid = request.getParameter("deptID");
		
		if (deptid == null) {
			return "";
		}
		
		String celllist = request.getParameter("cell");
		
		if (celllist == null) {
			return "";
		}
		
		String proplist = request.getParameter("prop");
		
		if (proplist == null) {
			return "";
		}
		
		String listtype = request.getParameter("type");		
		
		if (listtype == null) {
			return "";
		}

		String adminOrgan = request.getParameter("adminOrgan") != null ? request.getParameter("adminOrgan"): "n";
		
		String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId()) != ""? ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId()) : "NO";
		// useOganHideFlag를 사용하지 않으면 adminOrgan을 다 "y"로 둬서 조직도숨김을 뺀다.
		adminOrgan = "NO".equalsIgnoreCase(useOrganHideFlag) ? "y" : adminOrgan;
		
		String isPrimary = userInfo.getPrimary();
		String page = request.getParameter("page");
		String noAddJob = request.getParameter("noAddJob");
		// String companyId = request.getParameter("companyId") == null ? "" : request.getParameter("companyId");
		String infoXML = "";

		logger.debug("page=" + page);
		
		if (page != null && !page.isEmpty()) {
			if (!commonUtil.isIntNumber(page)) {
				return "";
			}			
		}
		
		if (page == null) {		
			infoXML = ezOrganService.getDeptMemberList(deptid, celllist, proplist, listtype, isPrimary, userInfo.getTenantId(), noAddJob, adminOrgan);
		} else {
			infoXML = ezOrganService.getDeptMemberListPagination(deptid, celllist, proplist, listtype, isPrimary, page, userInfo.getTenantId(), adminOrgan);
		}
		
		Document doc = commonUtil.convertStringToDocument(infoXML);
		/* --jangsewon
		if (celllist.toUpperCase().indexOf("EXTENSIONATTRIBUTE5") > -1) {
            String[] arryCell = celllist.toUpperCase().split(";");
            // String tooltip = "";
            int idx = 0;
            
            for (int j = 0; j < arryCell.length; j++) {
                if (arryCell[j].equals("EXTENSIONATTRIBUTE5")) {
                    idx = j;
                }
            }
            
            for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
                // Element Nodetip = doc.createElement("TOOLTIP");

                if (!doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).getTextContent().equals("")) {
             --jangsewon */
                	//2018-07-12 이효진 미사용 소스 주석처리
                    /*String[] arry = doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).getTextContent().split(":");
                    tooltip = arry[3].replace("/", ":") + " ~ " + arry[4].replace("/", ":");
                    
                    if (arry.length > 5) {
                        tooltip += " " + messageSource.getMessage(arry[5], userInfo.getLocale());
                    }*/
                    
                    /* 
                     * 2016-03-29 장진혁과장 날짜비교 작업 필요
                    // 2012.06.26 부재설정 미리해놓은 경우 현재 시간을 비교하여 표시되도록 추가함.
                    if ((Convert.ToDateTime(arry[3].replace("/", ":")) <= DateTime.Now) && (DateTime.Now <= Convert.ToDateTime(arry[4].replace("/", ":"))))
                    {
                        Nodetip.InnerText = tooltip;

                        xmldom.GetElementsByTagName("ROW").Item(i).ChildNodes.Item(idx).ChildNodes.Item(0).InnerText = "Y";
                        xmldom.GetElementsByTagName("ROW").Item(i).ChildNodes.Item(idx).AppendChild(Nodetip);
                    }
                    else
                    {
                        xmldom.GetElementsByTagName("ROW").Item(i).ChildNodes.Item(idx).ChildNodes.Item(0).InnerText = "";
                    }*/
                    //xmldom.GetElementsByTagName("ROW").Item(i).ChildNodes.Item(idx).ChildNodes.Item(0).InnerText = "";
		/* --jangsewon
                    doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).setTextContent("Y");
                } else {
                	doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).setTextContent("");
                }
            }
        }
		--jangsewon */
		String result = commonUtil.convertDocumentToString(doc);
		result = result.replaceAll("null", "");
		
		logger.debug("getDeptMemberList ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezOrgan/getDeptMemberListCount.do", method = RequestMethod.POST)
	public String getDeptMemberListCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getDeptMemberList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String deptID = request.getParameter("deptID");

		String adminOrgan = request.getParameter("adminOrgan") != null ? request.getParameter("adminOrgan"): "n";

		String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId()) != ""? ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId()) : "NO";
		// useOganHideFlag를 사용하지 않으면 adminOrgan을 다 "y"로 둬서 조직도숨김을 뺀다.
		adminOrgan = "NO".equalsIgnoreCase(useOrganHideFlag) ? "y" : adminOrgan;
		
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		int totalCount = 0, totalCount2 = 0;
		
		String containLow = ezCommonService.getTenantConfig("containLow", tenantID);
		
		if (containLow == null || containLow.equals("")) {
			containLow = "NO";
		}
		
		model.addAttribute("containLow", containLow);
		
		totalCount = ezOrganService.getDeptMemberListCount(deptID, false, primary, tenantID, adminOrgan);
		if (containLow.equals("YES")) {
			totalCount2 = ezOrganService.getDeptMemberListCount(deptID, true, primary, tenantID, adminOrgan);
		}
		
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalCount2", totalCount2);

		logger.debug("getDeptMemberList ended.");
		
		return "json";
	}
	
	/**
	 * 조직도 부서 및 사원목록 검색 함수
	 */
	@RequestMapping(value = "/ezOrgan/getSearchList.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getSearchList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("getSearchList started.");
	    
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		String searchlist = request.getParameter("search").trim();
		String companyId  = request.getParameter("company") == null ? userInfo.getCompanyID() : request.getParameter("company");
		String celllist = request.getParameter("cell");
		String proplist = request.getParameter("prop");
		String listtype = request.getParameter("type");
		String lang = userInfo.getPrimary();
		String page = request.getParameter("page");
		String noAddJob = request.getParameter("noAddJob");
		String infoXML = "";
		String adminOrgan = request.getParameter("adminOrgan") != null ? request.getParameter("adminOrgan"): "n";

		String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId()) != ""? ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId()) : "NO";
		// useOganHideFlag를 사용하지 않으면 adminOrgan을 다 "y"로 둬서 조직도숨김을 뺀다.
		// adminOrgan이 y이고 useOrganHideFlag를 사용하지 않을 때에만 y로 유지한다.
		adminOrgan = "NO".equalsIgnoreCase(useOrganHideFlag) && "y".equalsIgnoreCase(adminOrgan) ? "y" : adminOrgan;
		
		if (userInfo.getRollInfo().indexOf("c=1") != -1 && adminOrgan.equalsIgnoreCase("y")) { // 전체 관리자 && 관리자 > 조직도 메뉴 => 전체 검색
			companyId = "";
		}

		/* '직원조회 검색란 에서 @@검색시 검색 결과가 정상적으로 나오지 않음'과 관련된 내용으로 수정이 필요한 경우 
		   searchlist의 검색어 부분을 앞단에서 넘길때 encodeURIComponent로 변환해서 넘기도록 수정필요 */
		logger.debug("searchlist=" + URLDecoder.decode(searchlist, "utf-8") + ",celllist=" + celllist + ",proplist=" + proplist
		        + ",listtype=" + listtype + ",lang=" + lang + ",page=" + page + ",companyId=" + companyId);
		
			if (page == null) {
				if (companyId.equals("")) {
					infoXML = ezOrganService.getSearchList(searchlist, celllist, proplist, listtype, 10000, lang, tenantID, adminOrgan);
				} else {
					infoXML = ezOrganService.getSearchList(searchlist, celllist, proplist, listtype, 10000, lang, companyId, tenantID, noAddJob, adminOrgan);
				}
			} else {
				infoXML = ezOrganService.getSearchListPagination(searchlist, celllist, proplist, listtype, 10000, lang, page, tenantID, companyId, adminOrgan);
			}
		
		Document doc = commonUtil.convertStringToDocument(infoXML);
		/* jangsewon 주석처리
		if (celllist.toUpperCase().indexOf("EXTENSIONATTRIBUTE5") > -1) {
            String[] arryCell = celllist.toUpperCase().split(";");
            String tooltip = "";
            int idx = 0;
            
            for (int j = 0; j < arryCell.length; j++) {
                if (arryCell[j].equals("EXTENSIONATTRIBUTE5")) {
                    idx = j;
                }
            }
            
            for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
                Element Nodetip = doc.createElement("TOOLTIP");

                if (!doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).getTextContent().equals("")) {
                    String[] arry = doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).getTextContent().split(":");
                    tooltip = arry[3] + " ~ " + arry[4];
                    
                    if (arry.length > 5) {
                        tooltip += " " + arry[5];
                    }
                    
                    Nodetip.setTextContent(tooltip);
                    
                    doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).setTextContent("Y");
                    doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).appendChild(Nodetip);
                }
            }
        }
		*/
		String result = commonUtil.convertDocumentToString(doc);
		result = result.replaceAll("null", "");
		
		logger.debug("getSearchList ended.");
		return result;
	}
	
	/**
	 * 조직도 외부수신처 depth 1 트리정보  함수
	 */
	@RequestMapping(value = "/ezOrgan/getOrganTreeInfo.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getOrganTreeInfo() throws Exception{
		logger.debug("getOrganTreeInfo Started.(Outer Rec.)");
		String strFilter = "(&(objectclass=ucorg2)(ouLevel=1)(docsysteminfo=*))";
		int intScope = 1;

		String strXML = ezOrganService.getOrganTreeInfo(strFilter, intScope);

		logger.debug("getOrganTreeInfo Ended.(Outer Rec.)");
		return strXML;
	}
	
	/**
	 * 조직도 부서 및 사원정보 함수
	 */
	@RequestMapping(value = "/ezOrgan/getADInfos.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getADInfos(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String cn = request.getParameter("cn");
		String propName = request.getParameter("prop");
		String infoXML = ezOrganService.getPropertyList(cn, propName, userInfo.getPrimary(), userInfo.getTenantId());
		
		return infoXML;
	}
	
	/**
	 * 조직도 서브트리정보  함수
	 * @throws Exception 
	 */
	@RequestMapping(value = "/ezOrgan/getOrganSubTreeInfo.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getOrganSubTreeInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo , @RequestBody String xmlPara) throws Exception{
		logger.debug("getOrganSubTreeInfo Started (outer)");
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String strBaseDN = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String strFilter = "(&(objectclass=ucOrg2)(docsysteminfo=*))";

        int intScope = 1;
        String strXML = ezOrganService.getOrganSubTreeInfo(strFilter, strBaseDN, intScope);
		logger.debug("getOrganSubTreeInfo ended (outer)");

		return strXML;
	}
	/**
	 * 선택한 서브트리정보  함수 
	 * @throws Exception 
	 */
	@RequestMapping(value = "/ezOrgan/insertAllOrganSubTreeInfo.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String insertAllOrganSubTreeInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo , String deptID) throws Exception{
		logger.debug("insertAllOrganSubTreeInfo Started (outer)");
		userInfo = commonUtil.userInfo(loginCookie);
		String strFilter = "(&(objectclass=ucOrg2)(docsysteminfo=*))";
		
		int intScope = 1;
		String strXML = ezOrganService.getOrganSubTreeInfo(strFilter, deptID, intScope);
		logger.debug("insertAllOrganSubTreeInfo ended (outer)");
		
		return strXML;
	}
//	/**
//	 * 조직도 부서 및 사원정보 함수
//	 */
	@RequestMapping(value = "/ezOrgan/getADInfo.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getADInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String cn = userInfo.getId();
		String infoXML = ezOrganService.getPropertyValue(cn, "extensionattribute4", userInfo.getTenantId());
		
		 infoXML="<RESULT>" + infoXML + "</RESULT>";
		return infoXML;
	}
	
	/**
	 * 외부 수신처 정보 가져오기
	 * @throws Exception 
	 */
	@RequestMapping(value = "/ezOrgan/getOrgInfo.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getOrgInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("getOrgInfo started");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String strBaseDN = request.getParameter("orgID") ;
		String strFilter = "(&(objectclass=ucOrg2)(ouCode=" + strBaseDN + "))";
		int intScope = 0;
		String strXML = ezOrganService.getOrgInfo(strFilter, intScope);
		
		logger.debug("getOrgInfo ended");
		return strXML;
	}
	
	/**
	 * @NOTE 해당 URL 호출을 하는 곳이 없음
	 * */
	@RequestMapping(value = "/ezOrgan/getAllDeptID", method = RequestMethod.POST, produces = "text/xml;charsert=utf-8")
	@ResponseBody
	public String getAllDeptID(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("getAllDeptID started.");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String parentID = request.getParameter("deptID");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();
		
		//List<String> list = new ArrayList<String>();
		
		String result = ezOrganService.getChildrenDeptID(parentID, companyID, tenantID);		
		
		//logger.debug("list.toString() : " + list.toString());
		
		logger.debug("getAllDeptID ended.");
		return result;
	}
	
	@RequestMapping(value = "/ezOrgan/isProxyUser.do", method = RequestMethod.POST, produces = "text/xml;charsert=utf-8")
	@ResponseBody
	public String isProxyUser(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("isProxyUser started.");
		userInfo = commonUtil.userInfo(loginCookie);
		String nowDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), true);
		String result ="0";
		
		if (ezOrganService.isProxyUser(userInfo.getTenantId(), userInfo.getId(), nowDateTime).equals("1")) {
			result = "1";
		}
		
		logger.debug("isProxyUser ended.");
		return result;
	}
	
	@RequestMapping(value = "/ezOrgan/setListType.do", method = RequestMethod.POST, produces = "text/xml;charsert=utf-8")
	@ResponseBody
	public String setListType(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("setListType started.");
		String listType = request.getParameter("listType");
		userInfo = commonUtil.userInfo(loginCookie);
		String userID = userInfo.getId();
		int tenantID = userInfo.getTenantId();
		String companyID = userInfo.getCompanyID();
		
		ezOrganService.setListType(listType, userID, tenantID, companyID);
		
		logger.debug("setListType ended.");
		return "TRUE";
	}
	
	@RequestMapping(value = "/ezOrgan/getListType.do", method = RequestMethod.POST, produces = "text/xml;charsert=utf-8")
	@ResponseBody
	public String getListType(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("getListType started.");
		userInfo = commonUtil.userInfo(loginCookie);
		String userID = userInfo.getId();
		int tenantID = userInfo.getTenantId();
		String companyID = userInfo.getCompanyID();
		
		String listType = ezOrganService.getListType(userID, tenantID, companyID);
		
		if (listType == null) {
			listType = "TXT";
		}
		
		logger.debug("getListType ended.");
		return listType;
	}
	
	/*
	 * 암호 정책 확인
	 */
 	@RequestMapping(value = "/ezOrgan/checkPasswordPolicy.do", method = RequestMethod.POST)
 	@ResponseBody
 	public String checkPasswordPolicy(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
 		logger.debug("checkPasswordPolicy started.");
 		
 		LoginVO userInfo = commonUtil.userInfo(loginCookie);
 		int tenantId = userInfo.getTenantId();

 		String chkPwPolicy = "";
 		
 		String pwStr = request.getParameter("pw");

		boolean useLoginCookie = StringUtils.isNotBlank(request.getParameter("useLoginCookie"));
		String companyId = useLoginCookie? userInfo.getCompanyID() : request.getParameter("chkCompanyId");
		String userId = useLoginCookie? userInfo.getId() : request.getParameter("userId"); // 개인정보 관련 숫자 검증용

		// 사원 추가 시 지원
		Stream<String> propParams = null;
		if (StringUtils.isNotBlank(request.getParameter("usePropParams"))) {
			propParams = Stream.of("TELEPHONENUMBER", "MOBILE", "HOMEPHONE", "BIRTH");
			propParams = propParams.filter(prop -> StringUtils.isNotBlank(request.getParameter(prop))).map(prop -> request.getParameter(prop));
		}

		PasswordCheckPolicyResult result = commonUtil.checkPwPolicy(pwStr, companyId, tenantId, userId, useLoginCookie, propParams);
		chkPwPolicy = result.succeeded() ? "OK" : result.getMessage();
		
		if ("PREVERROR". equals(chkPwPolicy)) {
			String rememberPWCountConfig = ezCommonService.getCompanyConfig(tenantId, companyId, "RememberPWCount");
			int rememberPWCount = rememberPWCountConfig == null || "".equalsIgnoreCase(rememberPWCountConfig) ? 0 : Integer.parseInt(rememberPWCountConfig);
			chkPwPolicy += "|"+rememberPWCount;
		}
 		
 		logger.debug("checkPasswordPolicy ended. chkPwPolicy=" + chkPwPolicy);
 		return chkPwPolicy;
 	}
 	
 	/**
	 * 회사 트리를 XML 형식으로 반환한다. (조직도 직위, 직책)
	 */
	@RequestMapping(value = "/ezOrgan/getCompanyJobTreeInfo.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getCompanyJobTreeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("getCompanyJobTreeInfo started.");
	    
	    String comInfo = null;
	    try {
	    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
	        int tenantID = userInfo.getTenantId();        
	        String primary = userInfo.getPrimary();
	        String companyId = userInfo.getCompanyID();
	        logger.debug("tenantID=" + tenantID + ", primary=" + primary + ", companyId=" + companyId);  
			
			Document doc = commonUtil.convertStringToDocument(data);
			String comID = doc.getElementsByTagName("COMID").item(0).getTextContent();
	        String topID = doc.getElementsByTagName("TOPID").item(0).getTextContent();
	        String propList = doc.getElementsByTagName("PROP").item(0).getTextContent();
	        String type = doc.getElementsByTagName("TYPE").item(0).getTextContent(); // pos(직위), tit(직책)
	        type = type.equalsIgnoreCase("pos") ? "001" : "002";

	        comID = comID.equals("") ? companyId : comID;
	        logger.debug("comID=" + comID + ",topID=" + topID + ",propList=" + propList + ",type=" + type);

	        comInfo = ezOrganService.getCompanyJobTreeInfo(type, comID, topID, propList, primary, tenantID);
	    } catch (Exception e) {
	    	logger.error(e.getMessage(), e);
	    }
	    
        logger.debug("getCompanyJobTreeInfo ended.");
		return comInfo;
	}
	
	/**
	 * 회사의 직위 또는 직책 목록을 XML 형식으로 반환한다.
	 */
	@RequestMapping(value = "/ezOrgan/getJobMasterTreeInfo.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getJobMasterTreeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("getJobMasterTreeInfo started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		
		String jobInfo = "";

		Document doc = commonUtil.convertStringToDocument(data);
		String comID = doc.getElementsByTagName("COMID").item(0).getTextContent();        
        String type = doc.getElementsByTagName("TYPE").item(0).getTextContent();
        type = type.equalsIgnoreCase("pos") ? "001" : "002"; // pos, tit
                
        if (!comID.equalsIgnoreCase("Top")) { // top회사는 직위 직책 리스트 출력 안함
        	jobInfo = ezOrganService.getJobMasterTreeInfo(type, comID, primary, tenantID);
        }
        
        logger.debug("getJobMasterTreeInfo ended.");
		return jobInfo;	
	}
	
	/**
	 * 직위 또는 직책 사용자 목록
	 */
	@RequestMapping(value = "/ezOrgan/getJobMasterMemberList.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getJobMasterMemberList(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("getJobMasterMemberList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		
		String memInfo = "";
		String type = request.getParameter("type");
		String jobID = request.getParameter("jobID");
		String pageSize = "50";
		String celllist = request.getParameter("cell");
		String proplist = request.getParameter("prop");
		String pageNum = request.getParameter("pageNum");
		String searchType = request.getParameter("searchType");
		String searchValue = request.getParameter("searchValue");
		String comID = request.getParameter("comID");
		String adminOrgan = request.getParameter("adminOrgan") == null ? "n" : request.getParameter("adminOrgan");
		
		String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag",userInfo.getTenantId());
		 // useOganHideFlag를 사용하지 않으면 adminOrgan을 다 "y"로 둬서 조직도숨김을 뺀다.
		adminOrgan = "NO".equalsIgnoreCase(useOrganHideFlag) ? "y" : adminOrgan;
		
		logger.debug("type=" + type + ", jobId=" + jobID + ", pageSize=" + pageSize + ", pageNum=" + pageNum + ", searchType=" + searchType 
				+ ", searchValue=" + searchValue + ", comID=" + comID + ", celllist=" + celllist + ", proplist=" + proplist);
		   
		memInfo = ezOrganService.getJobMasterMemberList(type, jobID, celllist, proplist, pageSize, pageNum, searchType, searchValue, primary, comID, tenantID,adminOrgan);
        
        logger.debug("getJobMasterMemberList ended");
		return memInfo;	
	}
	
	@RequestMapping(value = "/ezOrgan/getUpperDeptName.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject getUpperDeptName(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getJobMasterMemberList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String deptID = request.getParameter("deptID");
		JSONObject json = new JSONObject();
		

		if (StringUtils.isNotBlank(deptID)) {
			String upperDeptName = "";
			OrganDeptVO organDeptVO = ezOrganService.getDeptInfo(deptID, userInfo.getPrimary(), userInfo.getTenantId());
			OrganDeptVO upperDept = ezOrganAdminService.getDeptDisplayNm(organDeptVO.getExtensionAttribute1(), userInfo.getTenantId());
			if (upperDept != null) {
				upperDeptName = userInfo.getLang().equals("2") ? upperDept.getDisplayName2() : upperDept.getDisplayName();
				json.put("upperDeptName", upperDeptName);
				json.put("upperDeptName1", upperDept.getDisplayName());
				json.put("upperDeptName2", upperDept.getDisplayName2());
			}
		}

		logger.debug("getJobMasterMemberList ended");
		return json;
	}

	// 조직도 메인 페이지 매핑
	@RequestMapping(value = "/ezOrgan/organMain.do", method = RequestMethod.GET)
	public String organMain (@CookieValue("loginCookie") String loginCookie, Model model, String device) throws Exception {
		logger.debug("organMain Started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID().toLowerCase();
		String deptId = userInfo.getDeptID();
		int tenantId = userInfo.getTenantId();
		logger.debug("userId={},companyId={},tenantId={},device={}", userId, companyId, tenantId, device);
//		device = replaceXSS(device);
		TeamsOrganVO teamsOrganInfo =  new TeamsOrganVO(); ;
		if ("kaoni".equals(companyId)) {
			teamsOrganInfo = ezOrganService.organMain(userInfo, device, "kaoni", "", "", "Y", tenantId);
		} else {
			teamsOrganInfo = ezOrganService.organMain(userInfo, device, companyId, "", deptId, "",  tenantId);
		}

		if (teamsOrganInfo.getCompanyList() != null) {
			for (int i = 0; i < teamsOrganInfo.getCompanyList().size(); i++) {
				Map<String, String> row = teamsOrganInfo.getCompanyList().get(i);
			}
		} else {
			logger.debug("teamsOrganInfo.companyList is null");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("teamsOrganInfo", teamsOrganInfo);
		logger.debug("organMain ended");
		return "/ezOrgan/organMain_New";
	}

	// 부서, 사용자 조직도 트리 정보 조회 (Teams용)
	@RequestMapping(value = "/ezOrgan/getTotalTreeInfo.do", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	@ResponseBody
	public String getTotalTreeInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestBody Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		logger.debug("getTotalTreeInfo started");
		logger.debug("paramMap = {}", paramMap);
		
		String deptStr = "";
		userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();

		try {
			
			String userId = userInfo != null ? userInfo.getId() : null;
			String deptId         = (String) paramMap.getOrDefault("deptid", userInfo.getDeptID());
			String selectedUserId = (String) paramMap.getOrDefault("userid", "");
			String propList       = (String) paramMap.getOrDefault("prop", "");
			String type           = (String) paramMap.getOrDefault("type", "DEPT");
			String companyId      = (String) paramMap.getOrDefault("topid", userInfo.getCompanyID());
			String cellList       = (String) paramMap.getOrDefault("celllist", "");
			String listType       = (String) paramMap.getOrDefault("listtype", "");
			String noAddJob       = (String) paramMap.getOrDefault("noaddjob", "");

			if (StringUtils.isNotEmpty(selectedUserId)) {
				userId = selectedUserId;
			}
			
			deptStr = ezOrganService.getTotalTreeNodeInfo(userInfo, userId, selectedUserId, deptId, companyId, propList, userInfo.getLang(), type, "N");

		} catch (Exception e) {
			logger.error("getTotalTreeInfo error", e);
		}

		logger.debug("getTotalTreeInfo ended");
		return deptStr;
	}
	
	/**
	 * 팀즈 조직도 부서 및 사원목록 검색 함수
	 */
	@RequestMapping(value = "/ezOrgan/getTeamsSearchListJson.do", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	@ResponseBody
	public List<Map<String, Object>> getTeamsSearchListJson(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getTeamsSearchListJson started.");

		userInfo = commonUtil.aprUserInfo(loginCookie);

		int tenantID = userInfo.getTenantId();

		logger.debug("tenantID=" + tenantID);

		String searchlist = request.getParameter("search").trim();
		String companyId  = request.getParameter("company") == null ? userInfo.getCompanyID() : request.getParameter("company");
		String celllist = request.getParameter("cell");
		String proplist = request.getParameter("prop");
		String listtype = request.getParameter("type");
		String lang = userInfo.getPrimary();
		String page = request.getParameter("page");
		String noAddJob = request.getParameter("noAddJob");
		String adminOrgan = request.getParameter("adminOrgan") != null ? request.getParameter("adminOrgan") : "n";

		String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag", tenantID);
		useOrganHideFlag = (useOrganHideFlag == null || useOrganHideFlag.isEmpty()) ? "NO" : useOrganHideFlag;

		// useOrganHideFlag가 NO면 숨김 없이 모두 조회
		adminOrgan = "NO".equalsIgnoreCase(useOrganHideFlag) ? "y" : adminOrgan;

		if (userInfo.getRollInfo().contains("c=1") && adminOrgan.equalsIgnoreCase("y")) {
			companyId = "";
		}

		logger.debug("searchlist=" + URLDecoder.decode(searchlist, "utf-8") + ", celllist=" + celllist + ", proplist=" + proplist
				+ ", listtype=" + listtype + ", lang=" + lang + ", page=" + page + ", companyId=" + companyId);

		List<Map<String, Object>> rows = ezOrganService.getSearchListForTeamsJson(searchlist, celllist, proplist, listtype, 10000, lang, companyId, tenantID, noAddJob, "");


		logger.debug("getTeamsSearchListJson ended.");
		logger.debug("result size = " + rows.size());

		return rows;
	}

}
