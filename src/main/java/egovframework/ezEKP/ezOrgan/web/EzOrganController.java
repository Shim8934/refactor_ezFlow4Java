package egovframework.ezEKP.ezOrgan.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

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

	@Autowired
	private EgovMessageSource messageSource;
	
	/**
	 * 지정된 부서가 선택된 형태의 조직도 트리를 XML 형식으로 반환한다.
	 */
	@RequestMapping(value = "/ezOrgan/getDeptTreeInfo.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptTreeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("getDeptTreeInfo started.");
	    
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		Document doc = commonUtil.convertStringToDocument(data);
		
		String userID = "";
		String deptID = doc.getElementsByTagName("DEPTID").item(0).getTextContent();
        String topID = doc.getElementsByTagName("TOPID").item(0).getTextContent();
        String propList = doc.getElementsByTagName("PROP").item(0).getTextContent();
        
        logger.debug("deptID=" + deptID + ",topID=" + topID + ",propList=" + propList);
        
        // 지정된 부서가 선택된 형태의 조직도 트리를 XML 형식으로 반환한다.
        String deptInfo = ezOrganService.getDeptTreeInfo(userID, deptID, topID, propList, userInfo.getPrimary(), tenantID);
        
        logger.debug("getDeptTreeInfo ended.");
        
		return deptInfo;
	}
	
	/**
	 * 지정된 부서의 바로 아래에 위치한 자식 부서 목록을 XML 형식으로 반환한다.
	 */
	@RequestMapping(value = "/ezOrgan/getDeptSubTreeInfo.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptSubTreeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("getDeptSubTreeInfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
				
		String deptID = doc.getElementsByTagName("DEPTID").item(0).getTextContent();        
        String propList = doc.getElementsByTagName("PROP").item(0).getTextContent();
                
        String deptInfo = ezOrganService.getDeptSubTreeInfo(deptID, propList, userInfo.getPrimary(), userInfo.getTenantId());
		
        logger.debug("getDeptSubTreeInfo ended");
        
		return deptInfo;	
	}
	
	/**
	 * 조직도 부서 FULL PATH 정보 호출 함수
	 */
	@RequestMapping(value = "/ezOrgan/getDeptFullPath.do", produces="text/html;charset=utf-8")
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
	@RequestMapping(value = "/ezOrgan/getDeptMemberList.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptMemberList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("getDeptMemberList started");
	    
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptid = request.getParameter("deptID");
		String celllist = request.getParameter("cell");
		String proplist = request.getParameter("prop");
		String listtype = request.getParameter("type");		
		String isPrimary = userInfo.getPrimary();
		String page = request.getParameter("page");
		String infoXML = "";

		logger.debug("page=" + page);
		
		if (page == null) {		
			infoXML = ezOrganService.getDeptMemberList(deptid, celllist, proplist, listtype, isPrimary, userInfo.getTenantId());
		} else {
			infoXML = ezOrganService.getDeptMemberListPagination(deptid, celllist, proplist, listtype, isPrimary, page, userInfo.getTenantId());
		}
		
		Document doc = commonUtil.convertStringToDocument(infoXML);
		
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
                    tooltip = arry[3].replace("/", ":") + " ~ " + arry[4].replace("/", ":");
                    
                    if (arry.length > 5) {
                        tooltip += " " + messageSource.getMessage(arry[5], userInfo.getLocale());
                    }
                    
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
                    doc.getElementsByTagName("ROW").item(i).getChildNodes().item(idx).getChildNodes().item(0).setTextContent("");
                }
            }
        }
		
		String result = commonUtil.convertDocumentToString(doc);
		result = result.replaceAll("null", "");
		
		logger.debug("getDeptMemberList ended");
		
		return result;
	}
	
	/**
	 * 조직도 부서 및 사원목록 검색 함수
	 */
	@RequestMapping(value = "/ezOrgan/getSearchList.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getSearchList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("getSearchList started.");
	    
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		String searchlist = request.getParameter("search").trim();
		String celllist = request.getParameter("cell");
		String proplist = request.getParameter("prop");
		String listtype = request.getParameter("type");
		String lang = userInfo.getPrimary();
		String page = request.getParameter("page");
		String infoXML = "";
		
		logger.debug("searchlist=" + searchlist + ",celllist=" + celllist + ",proplist=" + proplist
		        + ",listtype=" + listtype + ",lang=" + lang + ",page=" + page);
		
		if (page == null) {
			infoXML = ezOrganService.getSearchList(searchlist, celllist, proplist, listtype, 100, lang, tenantID);
		} else {
			/* TODO 2016-03-29 장진혁과장 pagination 작업 필요 */
			infoXML = ezOrganService.getSearchListPagination(searchlist, celllist, proplist, listtype, 100, lang, page, tenantID);
		}
		
		Document doc = commonUtil.convertStringToDocument(infoXML);
		
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
		
		String result = commonUtil.convertDocumentToString(doc);
		result = result.replaceAll("null", "");
		
		logger.debug("getSearchList ended.");
		
		return result;
	}
	
	/**
	 * 조직도 트리정보  함수
	 */
	@RequestMapping(value = "/ezOrgan/getOrganTreeInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getOrganTreeInfo() throws Exception{
		String strFilter = "(&(objectclass=ucorg2)(ouLevel=1))";
		int intScope = 1;
		String strXML = ezOrganService.getOrganTreeInfo(strFilter, intScope);
		//TODO LDAP 이라 보류중
		return "";
	}
	
	/**
	 * 조직도 부서 및 사원정보 함수
	 */
	@RequestMapping(value = "/ezOrgan/getADInfos.do", produces = "text/xml;charset=utf-8")
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
	 */
	@RequestMapping(value = "/ezOrgan/getOrganSubTreeInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getOrganSubTreeInfo(){
		//TODO LDAP 이라 보류중
		return "";
	}
//	/**
//	 * 조직도 부서 및 사원정보 함수
//	 */
	@RequestMapping(value = "/ezOrgan/getADInfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getADInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String cn = userInfo.getId();
		String infoXML = ezOrganService.getPropertyValue(cn, "extensionattribute4", userInfo.getTenantId());
		
		 infoXML="<RESULT>" + infoXML + "</RESULT>";
		return infoXML;
	}
}
