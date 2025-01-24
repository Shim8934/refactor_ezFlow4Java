package egovframework.ezEKP.ezApprovalG.web;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.web.LoginController;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGConnService;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;
import org.w3c.dom.Document;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;

@Controller
public class EzApprovalGConnController {
    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGConnController.class);
    
    @Autowired
	private Properties config;

    @Autowired
    CommonUtil commonUtil;
    
    @Autowired
    EzApprovalGConnService ezApprovalGConnService;
    
    @Autowired
    EzApprovalGService ezApprovalGService;

    @Autowired
    LoginController loginController;

    @Autowired
    LoginService loginService;
    
    /**
     * 연동 샘플 코드는 git저장소 ezFlow4Java\docs\tech\ezApprovalG\전자결재연동\전자결재연동_참고용.pptx 설계를 바탕으로 작성됨
     * */

    /**
     * 외부->그룹웨어 기안(결재)창 오픈
     * 로직은 연동설계에 따가 변경해야함
     * */
    @RequestMapping(value = "/ezConn/ezApprGate.do", method = RequestMethod.GET)
    public String apprGate(HttpServletRequest request, HttpServletResponse response, Model model, @RequestParam String connkey) throws Exception {
        logger.debug("ezApprGate started");

        Objects.requireNonNull(connkey);
        logger.debug("### connkey = " + connkey);

        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);

        String charset = StandardCharsets.UTF_8.displayName();

        // 파라미터 체크 (파라미터를 userid|deptid|companyid|keyid|formcode 로 넘겨준다고 가정) 
        connkey = new String(Base64.getDecoder().decode(URLDecoder.decode(connkey, charset)));
        String [] connkeyArr = connkey.split("\\|");
        if (connkeyArr.length != 5) {
            throw new ArrayIndexOutOfBoundsException();
        }
        String userId = connkeyArr[0].toLowerCase();
        String deptId = connkeyArr[1].toLowerCase();
        String companyId = connkeyArr[2].toLowerCase();
        String keyId = connkeyArr[3];
        String formCode = connkeyArr[4];

        // loginVO 생성
        LoginVO paramUserInfo = new LoginVO();
        paramUserInfo.setId(userId);
        paramUserInfo.setTenantId(tenantId);
        paramUserInfo.setDn("NOPASSWORD");

        LoginVO userInfo = loginService.selectUser(paramUserInfo);

        logger.debug("### userId=" + userId + ", deptId=" + deptId + ", companyId=" + companyId + ", keyId=" + keyId + ", formCode=" + formCode);

        // 리다이렉트 링크 생성
        Map<String, Object> connData = ezApprovalGConnService.getConnData(keyId, formCode);
        String docId = (String) connData.get("DOCID");
        
        String uiFlag = ezApprovalGConnService.getDocUiFlag(docId, tenantId, companyId);
        if (!userId.equals(connData.get("USERID")) || !deptId.equals(connData.get("DEPTID"))) { // 파라미터 유저정보와 인터페이스 디비 유저정보가 같은지 체크
            uiFlag = "isBadUser";
        } else if (!deptId.equals(userInfo.getDeptID())) { // 파라미터 부서정보와 userinfo 부서정보가 같은지 체크 (겸직일경우도 있는데, 이에대한 처리는 따로 해야함)
            uiFlag = "isAddJob";
        }
        
        logger.debug("### uiFlag = " + uiFlag);
        String redirectUrl;
        if ("draft".equals(uiFlag)) {
            redirectUrl = getDraftUrl(connData, userInfo);
        } else if ("apr".equals(uiFlag)) {
            redirectUrl = getAprUrl(connData, userInfo);
        } else if ("end".equals(uiFlag)) {
            redirectUrl = getEndUrl(connData, userInfo);
        } else {
            return "cmm/error/accessBlock";
        }
        
        // 로그인쿠키 생성
        Cookie[] cookies = request.getCookies();
        boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));

        if (cookies != null) {
            for (Cookie cookie : cookies) {
				if (useDbSession || cookie.getName().equalsIgnoreCase("loginCookie")) {
					loginService.deleteSession(cookie.getValue());
				}

                if (!"JSESSIONID".equalsIgnoreCase(cookie.getName())) { // JSESSIONID는 지우지 않음 (이중화 시 JSESSIONID 쿠키를 사용)
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                }
            }
        }

        loginController.createLoginCookie(userId, "", "", tenantId, request, response, deptId, companyId);

        model.addAttribute("redUrl", redirectUrl);

        logger.debug("### redirect url = " + redirectUrl);

        return "ezApprovalG/conn/connRedirect";
    }

    @RequestMapping(value = "/ezApprovalG/conn/getBody.do", produces = "text/xml; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String getBody(@CookieValue("loginCookie") String loginCookie, @RequestBody String keyDataStr) throws Exception {
        logger.debug("getBody started");

        LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

        Document keyData = commonUtil.convertStringToDocument(keyDataStr);

        String retStr = ezApprovalGConnService.getBody(keyData, userInfo);

        logger.debug("getBody ended");

        return retStr;
    }

    @RequestMapping(value = "/ezApprovalG/conn/checkStatus.do", produces = "text/xml; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String checkStatus(@CookieValue("loginCookie") String loginCookie, @RequestBody String keyDataStr, HttpServletRequest request) throws Exception {
        logger.debug("checkStatus started");

        LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

        Document keyData = commonUtil.convertStringToDocument(keyDataStr);
        
        String retStr = ezApprovalGConnService.checkStatus(keyData, userInfo);

        logger.debug("checkStatus ended");

        return retStr;
    }

    @RequestMapping(value = "/ezApprovalG/conn/updateStatus.do", produces = "text/xml; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String updateStatus(@CookieValue("loginCookie") String loginCookie, @RequestBody String keyDataStr, HttpServletRequest request) throws Exception {
        logger.debug("updateStatus started");

        LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

        Document keyData = commonUtil.convertStringToDocument(keyDataStr);
        
        String retStr = ezApprovalGConnService.updateStatus(keyData, userInfo);;

        logger.debug("updateStatus ended");

        return retStr;
    }

    private String getDraftUrl(Map<String, Object> connData, LoginVO userInfo) throws Exception {
        String keyId = (String) connData.get("KEYID");
        String formCode = (String) connData.get("FORMCODE");
        
        String formInfoStr = ezApprovalGService.getFormInfoDetail(formCode, userInfo.getCompanyID(), userInfo.getTenantId());
        Document formInfo = commonUtil.convertStringToDocument(formInfoStr);

        String formUrl = formInfo.getElementsByTagName("FORMFILELOCATION").item(0).getTextContent().trim();
        String formDocType = formInfo.getElementsByTagName("FORMDOCTYPE").item(0).getTextContent().trim();

        String path = "";
        MultiValueMap queryParam = new LinkedMultiValueMap();
        if (formUrl.endsWith(".mht")) {
            path = "/ezApprovalG/draftui.do";
            queryParam.set("formURL", formUrl);
            queryParam.set("draftFlag", "DRAFT");
            queryParam.set("formDocType", formDocType);
            queryParam.set("susinSN", "0");
            queryParam.set("docState", "");
            queryParam.set("listType", "1");
            queryParam.set("aprState", "");
            queryParam.set("isTmpDoc", "");
            queryParam.set("officeFlag", "N");
            queryParam.set("connKey", keyId);
            queryParam.set("connFormCode", formCode);
        } else if (formUrl.endsWith(".hwp")) {
            path = "/ezApprovalG/draftuiWHWP.do";
            queryParam.set("formURL", formUrl);
            queryParam.set("draftFlag", "DRAFT");
            queryParam.set("formDocType", formDocType);
            queryParam.set("susinSN", "0");
            queryParam.set("docState", "");
            queryParam.set("listType", "1");
            queryParam.set("aprState", "");
            queryParam.set("isTmpDoc", "");
            queryParam.set("connKey", keyId);
            queryParam.set("connFormCode", formCode);
        } else {
            throw new Exception();
        }

        return makeUrl(path, queryParam);
    }

    private String getAprUrl(Map<String, Object> connData, LoginVO userInfo) throws Exception {
        String docId = (String) connData.get("DOCID");

        String docInfoStr = ezApprovalGService.getDocInfo(docId, "APR", "ALL", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
        Document docInfo = commonUtil.convertStringToDocument(docInfoStr);

        String docHref = docInfo.getElementsByTagName("HREF").item(0).getTextContent().trim();
        String opinionFlag = docInfo.getElementsByTagName("HASOPINIONYN").item(0).getTextContent().trim();
        String docState = docInfo.getElementsByTagName("DOCSTATE").item(0).getTextContent().trim();

        String path = "";
        MultiValueMap queryParam = new LinkedMultiValueMap();
        if (docHref.endsWith(".mht")) {
            path = "/ezApprovalG/aprDocView.do";
            queryParam.set("docID", docId);
            queryParam.set("docHref", docHref);
            queryParam.set("opinionFlag", opinionFlag);
            queryParam.set("docState", docState);
            queryParam.set("listSusin", "");
            queryParam.set("oDoc", "");
            queryParam.set("isOpinion", "OPINION_SHOW");
            queryParam.set("listType", "1");
            queryParam.set("CallBackType", "");
            queryParam.set("ext", docHref.substring(docHref.lastIndexOf(".") + 1));
            queryParam.set("orgCompanyID", userInfo.getCompanyID());
        } else if (docHref.endsWith(".hwp")) {
            path = "/ezApprovalG/ezviewAprWHWP.do";
            queryParam.set("docID", docId);
            queryParam.set("docHref", docHref);
            queryParam.set("opinionFlag", opinionFlag);
            queryParam.set("docState", docState);
            queryParam.set("listSusin", "");
            queryParam.set("oDoc", "");
            queryParam.set("isOpinion", "OPINION_SHOW");
            queryParam.set("listType", "1");
            queryParam.set("CallBackType", "");
            queryParam.set("ext", docHref.substring(docHref.lastIndexOf(".") + 1));
            queryParam.set("orgCompanyID", userInfo.getCompanyID());
        } else {
            throw new Exception();
        }

        return makeUrl(path, queryParam);
    }

    private String getEndUrl(Map<String, Object> connData, LoginVO userInfo) throws Exception {
        String docId = (String) connData.get("DOCID");
        String formCode = (String) connData.get("FORMCODE");

        String docInfoStr = ezApprovalGService.getDocInfo(docId, "END", "ALL", userInfo, userInfo.getCompanyID(), userInfo.getTenantId(), "", "");
        Document docInfo = commonUtil.convertStringToDocument(docInfoStr);

        String docHref = docInfo.getElementsByTagName("HREF").item(0).getTextContent().trim();
        String docState = docInfo.getElementsByTagName("DOCSTATE").item(0).getTextContent().trim();
        String orgDocId = docInfo.getElementsByTagName("ORGDOCID").item(0).getTextContent().trim();

        String tempDocHref = docHref;
        if (tempDocHref.endsWith(".ezd")) {
            tempDocHref = tempDocHref.replace(".ezd", "");
        }

        String path = "";
        MultiValueMap queryParam = new LinkedMultiValueMap();
        if (tempDocHref.endsWith(".mht")) {
            path = "/ezApprovalG/contDocView.do";
            queryParam.set("docID", docId);
            queryParam.set("docHref", docHref);
            queryParam.set("formID", formCode);
            queryParam.set("orgDocID", orgDocId);
            queryParam.set("docState", docState);
            queryParam.set("orgCompanyID", userInfo.getCompanyID());
        } else if (tempDocHref.endsWith(".hwp")) {
            path = "/ezApprovalG/ezViewEnd_WHWP.do";
            queryParam.set("docID", docId);
            queryParam.set("docHref", docHref);
            queryParam.set("formID", formCode);
            queryParam.set("orgDocID", orgDocId);
            queryParam.set("docState", docState);
            queryParam.set("orgCompanyID", userInfo.getCompanyID());
        } else {
            throw new Exception();
        }

        return makeUrl(path, queryParam);
    }

    private String makeUrl(String path, MultiValueMap queryParam) throws Exception {
        UriComponents uriComponents = UriComponentsBuilder.newInstance()
                .path(path)
                .queryParams(queryParam)
                .build();

        return uriComponents.toUriString();
    }

    @RequestMapping(value = "/ezConn/insertApprGate.do", method = RequestMethod.POST)
    public String insertApprGate(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
        logger.debug("insertApprGate started");

        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);

        String userId = request.getParameter("userId");
        String deptId = request.getParameter("deptId");
        String keyId = request.getParameter("keyId");
        String formCode = request.getParameter("formCode");
        String bodyHtml = request.getParameter("bodyHtml");
        String title = request.getParameter("title");

        // loginVO 생성
        LoginVO paramUserInfo = new LoginVO();
        paramUserInfo.setId(userId);
        paramUserInfo.setTenantId(tenantId);
        paramUserInfo.setDn("NOPASSWORD");

        LoginVO userInfo = loginService.selectUser(paramUserInfo);

        Map<String, Object> connData = ezApprovalGConnService.getConnData(keyId, formCode);

        if(connData == null) {
            ezApprovalGConnService.registConnData(keyId, userId, deptId, title, formCode, bodyHtml);
        }

        connData = ezApprovalGConnService.getConnData(keyId, formCode);

        String docId = null;
        if(connData != null)
            docId = (String) connData.get("DOCID");

        String companyId = userInfo.getCompanyID();

        String uiFlag = ezApprovalGConnService.getDocUiFlag(docId, userInfo.getTenantId(), companyId);

        logger.info("### uiFlag = " + uiFlag);
        if("redraft".equals(uiFlag)) {
            uiFlag = "draft";
        }else if("draft".equals(uiFlag)) {
            connData.put("DOCID", null);
        }
        
        String redirectUrl;
        if ("draft".equals(uiFlag)) {
            redirectUrl = getDraftUrl(connData, userInfo);
        } else if ("apr".equals(uiFlag)) {
            redirectUrl = getAprUrl(connData, userInfo);
        } else if ("end".equals(uiFlag)) {
            redirectUrl = getEndUrl(connData, userInfo);
        } else {
            return "cmm/error/accessBlock";
        }

        // 로그인쿠키 생성
        Cookie[] cookies = request.getCookies();
        boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (useDbSession || cookie.getName().equalsIgnoreCase("loginCookie")) {
                    loginService.deleteSession(cookie.getValue());
                }

                if (!"JSESSIONID".equalsIgnoreCase(cookie.getName())) { // JSESSIONID는 지우지 않음 (이중화 시 JSESSIONID 쿠키를 사용)
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                }
            }
        }

        loginController.createLoginCookie(userId, "", "", tenantId, request, response, deptId, companyId);
        
        model.addAttribute("redUrl", redirectUrl);

        logger.info("### redirect url = " + redirectUrl);
        
        logger.debug("insertApprGate ended");
       
        return "ezApprovalG/conn/connRedirect";
    }
}
