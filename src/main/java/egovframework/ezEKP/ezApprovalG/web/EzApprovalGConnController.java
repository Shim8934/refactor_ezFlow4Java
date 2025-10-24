package egovframework.ezEKP.ezApprovalG.web;

import egovframework.ezEKP.ezApprovalG.CustomException.DocHandlingException;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.util.RestWHWP;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.web.LoginController;
import java.util.ArrayList;
import java.util.UUID;

import kr.dogfoot.hwplib.object.HWPFile;
import kr.dogfoot.hwplib.object.bodytext.Section;
import kr.dogfoot.hwplib.object.bodytext.control.Control;
import kr.dogfoot.hwplib.object.bodytext.control.ControlTable;
import kr.dogfoot.hwplib.object.bodytext.control.ControlType;
import kr.dogfoot.hwplib.object.bodytext.control.table.Cell;
import kr.dogfoot.hwplib.object.bodytext.control.table.Row;
import kr.dogfoot.hwplib.object.bodytext.paragraph.Paragraph;
import kr.dogfoot.hwplib.object.bodytext.paragraph.ParagraphList;
import kr.dogfoot.hwplib.object.bodytext.paragraph.charshape.CharPositionShapeIdPair;
import kr.dogfoot.hwplib.object.bodytext.paragraph.charshape.ParaCharShape;
import kr.dogfoot.hwplib.object.bodytext.paragraph.header.ParaHeader;
import kr.dogfoot.hwplib.reader.HWPReader;
import kr.dogfoot.hwplib.writer.HWPWriter;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;
import org.w3c.dom.Document;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
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
            redirectUrl = ezApprovalGConnService.getDraftUrl(connData, userInfo);
        } else if ("apr".equals(uiFlag)) {
            redirectUrl = ezApprovalGConnService.getAprUrl(connData, userInfo);
        } else if ("end".equals(uiFlag)) {
            redirectUrl = ezApprovalGConnService.getEndUrl(connData, userInfo);
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

    @RequestMapping(value = "/ezConn/insertApprGate.do", method = RequestMethod.POST)
    public String insertApprGate(HttpServletRequest request, @RequestParam(value = "files", required = false) List<MultipartFile> files, HttpServletResponse response, Model model) throws Exception {
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

        // 첨부파일 정보 및 파일 데이터 삭제
        if ("draft".equals(uiFlag))
            ezApprovalGConnService.deleteConnAttachData(keyId, "1");

        if ("draft".equals(uiFlag) && files != null) {
            if (!files.isEmpty() && files.get(0).getSize() > 0) {
                String dirPath = commonUtil.getUploadPath("upload_approvalG.CONNATTACH", tenantId) + commonUtil.separator + keyId;

                File fileDir = new File(commonUtil.getRealPath(request) + dirPath);
                if (!fileDir.exists()) {
                    if (!fileDir.mkdirs()) {
                        throw new IOException("Failed to create directory: " + dirPath);
                    }
                }

                // 첨부파일 체크
                String fileCheckVal = ezApprovalGConnService.checkFileAttach(files, userInfo.getTenantId());

                if ("TRUE".equals(fileCheckVal)) {
                    for (int i = 0; i < files.size(); i++) {
                        MultipartFile file = files.get(i);
                        if (!file.isEmpty()) {
                            try {
                                byte[] bytes = file.getBytes();

                                String fileName = file.getOriginalFilename();
                                String filePath = commonUtil.getRealPath(request) + dirPath + commonUtil.separator + fileName;
                                long fileSize = file.getSize();
                                int fileSn = i + 1;

                                File connAttach = new File(filePath);
                                try (FileOutputStream fos = new FileOutputStream(connAttach)) {
                                    fos.write(bytes);
                                }
                                ezApprovalGConnService.insertConnAttachData(keyId, fileSn, fileName, dirPath + commonUtil.separator + fileName, fileSize, userId);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
                logger.debug("insertApprGate keyId: " + keyId + " fileCheck: " + fileCheckVal);
                connData.put("fileCheck", fileCheckVal);
            }
        }

        String redirectUrl;
        if ("draft".equals(uiFlag)) {
            redirectUrl = ezApprovalGConnService.getDraftUrl(connData, userInfo);
        } else if ("apr".equals(uiFlag)) {
            redirectUrl = ezApprovalGConnService.getAprUrl(connData, userInfo);
        } else if ("end".equals(uiFlag)) {
            redirectUrl = ezApprovalGConnService.getEndUrl(connData, userInfo);
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

    @RequestMapping(value = "/ezConn/insertInitConnAttach.do", method = RequestMethod.POST)
    @ResponseBody
    public void insertInitConnAttach(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
        logger.debug("insertInitConnAttach started.");

        LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
        
        String connKey = request.getParameter("connKey");
        String docID = request.getParameter("docID");
        
        List<Map<String, Object>> connnAttachList = ezApprovalGConnService.getConnAttachData(connKey);
        
        if (!connnAttachList.isEmpty())
            ezApprovalGConnService.initConnAttachFileInfo(docID, userInfo, connnAttachList);
        
        logger.debug("insertInitConnAttach ended.");
    }

    @RequestMapping(value = "/ezConn/insertAprAttach.do", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject insertAprAttach(HttpServletRequest request, @RequestParam("files") List<MultipartFile> files) throws Exception{
        logger.debug("insertAprAttach started.");

        JSONObject result = new JSONObject();

        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);
        
        String keyId = request.getParameter("keyId");
        String userId = request.getParameter("userId");
        
        if (keyId == null || userId == null) {
            result.put("code", "error");
            result.put("message", "PARAM ERROR");
            
            return result;
        }

        try {
            if (!files.isEmpty() && files.get(0).getSize() > 0) {
                String dirPath = commonUtil.getUploadPath("upload_approvalG.CONNATTACH", tenantId) + commonUtil.separator + keyId;

                File fileDir = new File(commonUtil.getRealPath(request) + dirPath);
                if (!fileDir.exists()) {
                    if (!fileDir.mkdirs()) {
                        throw new IOException("Failed to create directory: " + dirPath);
                    }
                }

                for (int i = 0; i < files.size(); i++) {
                    MultipartFile file = files.get(i);
                    if (!file.isEmpty()) {
                        try {
                            byte[] bytes = file.getBytes();

                            String fileName = file.getOriginalFilename();
                            String filePath = commonUtil.getRealPath(request) + dirPath + commonUtil.separator + fileName;
                            long fileSize = file.getSize();
                            int fileSn = i + 1;

                            File connAttach = new File(filePath);
                            try (FileOutputStream fos = new FileOutputStream(connAttach)) {
                                fos.write(bytes);
                            }
                            ezApprovalGConnService.insertConnAttachData(keyId, fileSn, fileName, dirPath + commonUtil.separator + fileName, fileSize, userId);
                        } catch (IOException e) {
                            e.printStackTrace();

                        }
                    }
                }
            }
            result.put("code", "ok");
            result.put("message", "");
        } catch (Exception e) {
            result.put("code", "error");
            result.put("message", "FILE ERROR");
            throw new RuntimeException(e);
        }

        logger.debug("insertAprAttach ended.");
        
        return result;
    }

    @ResponseBody
    @RequestMapping(value = "/admin/ezApprovalG/insertApprGate.do", method = RequestMethod.POST)
    public String adminInsertApprGate(HttpServletRequest request, @RequestParam(value = "files", required = false) List<MultipartFile> files, HttpServletResponse response, Model model) throws Exception {
        logger.debug("adminInsertApprGate started");

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

        // 첨부파일 정보 및 파일 데이터 삭제
        if ("draft".equals(uiFlag))
            ezApprovalGConnService.deleteConnAttachData(keyId, "1");

        if ("draft".equals(uiFlag) && files != null) {
            if (!files.isEmpty() && files.get(0).getSize() > 0) {
                String dirPath = commonUtil.getUploadPath("upload_approvalG.CONNATTACH", tenantId) + commonUtil.separator + keyId;

                File fileDir = new File(commonUtil.getRealPath(request) + dirPath);
                if (!fileDir.exists()) {
                    if (!fileDir.mkdirs()) {
                        throw new IOException("Failed to create directory: " + dirPath);
                    }
                }

                // 첨부파일 체크
                String fileCheckVal = ezApprovalGConnService.checkFileAttach(files, userInfo.getTenantId());

                if ("TRUE".equals(fileCheckVal)) {
                    for (int i = 0; i < files.size(); i++) {
                        MultipartFile file = files.get(i);
                        if (!file.isEmpty()) {
                            try {
                                byte[] bytes = file.getBytes();

                                String fileName = file.getOriginalFilename();
                                String filePath = commonUtil.getRealPath(request) + dirPath + commonUtil.separator + fileName;
                                long fileSize = file.getSize();
                                int fileSn = i + 1;

                                File connAttach = new File(filePath);
                                try (FileOutputStream fos = new FileOutputStream(connAttach)) {
                                    fos.write(bytes);
                                }
                                ezApprovalGConnService.insertConnAttachData(keyId, fileSn, fileName, dirPath + commonUtil.separator + fileName, fileSize, userId);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
                logger.debug("insertApprGate keyId: " + keyId + " fileCheck: " + fileCheckVal);
                connData.put("fileCheck", fileCheckVal);
            }
        }

        String redirectUrl;
        if ("draft".equals(uiFlag)) {
            redirectUrl = ezApprovalGConnService.getDraftUrl(connData, userInfo);
        } else if ("apr".equals(uiFlag)) {
            redirectUrl = ezApprovalGConnService.getAprUrl(connData, userInfo);
        } else if ("end".equals(uiFlag)) {
            redirectUrl = ezApprovalGConnService.getEndUrl(connData, userInfo);
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

        logger.info("### redirect url = " + redirectUrl);

        logger.debug("adminInsertApprGate ended");

        return redirectUrl;
    }

    @ResponseBody
    @RequestMapping(value = "/test.do", method = RequestMethod.GET)
    public String test(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
        logger.debug("test started");

        String path = "C:\\Users\\jungj\\Downloads\\work\\ezFlow4Java\\src\\main\\webapp\\fileroot\\0\\files\\upload_approvalG\\kaoni\\doc\\2025\\59/00000000000000044059.hwp";
        HWPFile hwpFile = HWPReader.fromFile(path);
        String[] signTextArray = new String[] {"09/15","기사원"};
        List<Object> a = new ArrayList();
        a.add(1);
        a.add(2);
        
        try {
            for (Section s : hwpFile.getBodyText().getSectionList()) {
                for (Paragraph p : s) {
                    Cell cell = findHwpFieldCell(p,"sign4");
                    if (cell != null) {
                        ParagraphList paragraphList = cell.getParagraphList();
                        ParaHeader ph = paragraphList.getParagraph(0).getHeader();
                        ParaCharShape pcs = paragraphList.getParagraph(0).getCharShape();

                        for (int k = 1; k < signTextArray.length; k++) {
                            Paragraph newParagraph = paragraphList.addNewParagraph();

                            newParagraph.createText();
                            newParagraph.createCharShape();

                            //글자모양 복사해주기
                            for (CharPositionShapeIdPair charPositionShapeIdPair : pcs.getPositonShapeIdPairList()) {
                                newParagraph.getCharShape().addParaCharShape(charPositionShapeIdPair.getPosition(), charPositionShapeIdPair.getShapeId());
                            }

                            //헤더값 복사해서 정렬 맞추기
                            newParagraph.getHeader().setParaShapeId(ph.getParaShapeId());
                            newParagraph.getHeader().setStyleId(ph.getStyleId());

                            newParagraph.getText().addString(signTextArray[k]);
                        }
                        /* 2023-04-28 양지혜 - 공백 문자를 제거하고 사인을 삽입 */
                        paragraphList.getParagraph(0).deleteText();
                        paragraphList.getParagraph(0).createText();
                        paragraphList.getParagraph(0).getText().addString(signTextArray[0]);
                    }
                }
            }
//            for (Section s : hwpFile.getBodyText().getSectionList()) {
//                for (Paragraph p : s) {
//                    Cell cell = findHwpFieldCell(p, "sign3");
//                    if (cell != null) {
//                        /* 2023-04-28 양지혜 - 공백 문자를 제거하고 사인을 삽입 */
//                        cell.getParagraphList().getParagraph(0).deleteText();
//                        cell.getParagraphList().getParagraph(0).createText();
//                        cell.getParagraphList().getParagraph(0).getText().addString(String.join("\r\n", signTextArray));
//                    }
//                }
//            }
        }catch (Exception e){
            throw new DocHandlingException(e.getMessage());
        }
        HWPWriter.toFile(hwpFile, "C:\\Users\\jungj\\Downloads\\work\\ezFlow4Java\\src\\main\\webapp\\fileroot\\0\\files\\upload_approvalG\\kaoni\\doc\\2025\\579/00000000000000043579.hwp");
        RestWHWP hwp = new RestWHWP("http://webhwp.kaoni.com:8080/filterserver/convert/manager");
        hwp.open("/home/hancom/data/test1.hwp");
        hwp.putText("sign1","테스트\r\n123");
        hwp.putText("sign3","테스트");
        hwp.putText("sign4","테스트");
        hwp.putText("sign5","테스트");
        hwp.putImg("sign2","/home/hancom/data/sign","50","50");
        hwp.putImg("sign2{{1}}","/home/hancom/data/sign","50","50");
        hwp.saveHwp("/home/hancom/data/result.hwp");
        hwp.flush();
        return "S";
    }
    private Cell findHwpFieldCell(Paragraph p, String fieldName) throws Exception {
        if (p == null || p.getControlList() == null) {
            return null;
        }
        try {
            for (Control c : p.getControlList()) {
                if (c.getType() == ControlType.Table) {
                    ControlTable ct = (ControlTable) c;

                    for (Row row : ct.getRowList()) {
                        for (Cell cell : row.getCellList()) {
                            Cell fieldCell = null;

                            if (cell.getListHeader().getFieldName() != null && cell.getListHeader().getFieldName().equals(fieldName)) {
                                fieldCell = cell;
                            } else {
                                fieldCell = findHwpFieldCell(cell.getParagraphList(), fieldName);
                            }

                            if (fieldCell != null) {
                                return fieldCell;
                            }
                        }
                    }
                }
            }
        }catch (Exception e){
            throw new DocHandlingException(e.getMessage());
        }

        return null;
    }
    private Cell findHwpFieldCell(ParagraphList pList, String fieldName) throws Exception {
        Cell fieldCell = null;
        try {
            for (Paragraph p : pList) {
                fieldCell = findHwpFieldCell(p, fieldName);

                if (fieldCell != null) {
                    break;
                }
            }
        }
        catch (Exception e){
            throw new DocHandlingException(e.getMessage());
        }
        return fieldCell;
    }
}
