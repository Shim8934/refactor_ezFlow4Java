package egovframework.ezEKP.ezApprovalG.service.impl;

import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EzFAL;
import egovframework.let.utl.fcc.service.EzFAL.*;
import org.apache.commons.collections4.map.HashedMap;
import org.apache.commons.io.FileUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGConnDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGConnService;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;
import org.w3c.dom.Document;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service("EzApprovalGConnService")
public class EzApprovalGConnServiceImpl extends EzFileMngUtil implements EzApprovalGConnService {
    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGConnServiceImpl.class);
    
    @Autowired
    CommonUtil commonUtil;
    
    @Autowired
    EzApprovalGConnDAO ezApprovalGConnDao;

    @Autowired
    EzApprovalGService ezApprovalGService;

    @Resource(name = "EzApprovalGDAO")
    private EzApprovalGDAO ezApprovalGDAO;

    @Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;

    @Autowired
    private ServletContext servletContext;

    /**
     * 연동 테이블에서 연동 데이터를 조회한다
     * */
    public Map<String, Object> getConnData(String keyId, String formCode) throws Exception {
        logger.debug("getConnData started");
        
        Objects.requireNonNull(keyId);
        Objects.requireNonNull(formCode);

        Map<String, Object> connData = ezApprovalGConnDao.getConnData(keyId, formCode);

        logger.debug("getConnData end");
        
        return connData;
    }

    /**
     * 문서가 진행중인지 완료인지 체크한다
     * */
    public String getDocUiFlag(String docId, int tenantId, String companyId) throws Exception {
        logger.debug("getDocUiFlag started");

        String uiFlag = "draft";
        
        boolean isIngDoc = docId != null;
        if (isIngDoc) {
            uiFlag = ezApprovalGConnDao.getDocUiFlag(docId, tenantId, companyId);
        }

        logger.debug("getDocUiFlag ended");

        return uiFlag;
    }

    /**
     * 연동 데이터를 본문에 뿌려줄 수 있는 형태로 가공한다 (INIT 연동)
     * */
    public String getBody(Document keyData, LoginVO userInfo) throws Exception {
        logger.debug("getBody started");

        String retStr = "";
        String retParam = "";

        String connKey = keyData.getElementsByTagName("c_connkey").item(0).getTextContent().trim();
        String connFormCode = keyData.getElementsByTagName("c_connformcode").item(0).getTextContent().trim();

        logger.debug("### connKey=" + connKey + ", connFormCode=" + connFormCode);

        if (connKey.isEmpty()) { // 본문에 연동데이터를 직접 뿌려주는 연동은 보통 외부에서 시작하는 것이기 때문에 그룹웨어에서 기안할 수 없도록 해야함
            return "<RETURNDATA RESULT=\"close\">현재 양식은 그룹웨어에서 시작할 수 없습니다.</RETURNDATA>";
        }
        
        Map<String, Object> connData = getConnData(connKey, connFormCode);
        String status = (String) connData.get("STATUS");
        String body = (String) connData.get("BODY");

        if (!"INT".equals(status)) { // INT가 외부시스템에서 결재요청중인 상태라고 가정할 때, INT가 아니라면 진행중인 문서로 판단하여 연동을 중단해야함
            return "<RETURNDATA RESULT=\"close\">이미 결재가 진행중인 데이터입니다.</RETURNDATA>";
        }
        
        /**
         * 연동테이블에서 본문 데이터를 xml로 받아서 필드연동 하는 경우
         * 연동 협의 시 아래 형식으로 insert하도록 협의해야한다. 
         * <PARAMETER>
         *     <연동필드1><![CDATA[연동데이터1]]></연동필드1>
         *     <연동필드2><![CDATA[연동데이터2]]></연동필드2>
         * </PARAMETER>
         * */
        retParam = body;
        
        /**
         * 연동테이블에서 본문 데이터를 xml로 받아서 xslt연동 하는 경우
         * xslt작성을 고려하기만 하면 XML형식은 자유롭게 받아도 된다. 아래 예시 참고.
         * <PARAMETER>
         *     <FIELDS> - 개별 필드에 넣을 데이터
         *         <연동필드1><![CDATA[연동데이터1]]></연동필드1>
         *         <연동필드2><![CDATA[연동데이터2]]></연동필드2>
         *     </FIELDS>
         *     <TABLE1> - 첫번째 테이블(표) 데이터
         *         <ROW>
         *             <연동컬럼1><![CDATA[연동데이터1]]></연동컬럼1>
         *             <연동컬럼2><![CDATA[연동데이터2]]></연동컬럼2>
         *         </ROW>
         *         <ROW>
         *             <연동컬럼1><![CDATA[연동데이터1]]></연동컬럼1>
         *             <연동컬럼2><![CDATA[연동데이터2]]></연동컬럼2>
         *         </ROW>
         *     </TABLE1>
         *     <TABLE2> - 두번째 테이블(표) 데이터
         *         <ROW>
         *             <연동컬럼1><![CDATA[연동데이터1]]></연동컬럼1>
         *             <연동컬럼2><![CDATA[연동데이터2]]></연동컬럼2>
         *         </ROW>
         *     </TABLE2>
         * </PARAMETER>
         * */
        String formXslt = ezApprovalGConnDao.getFormXslt(connFormCode, userInfo.getTenantId(), userInfo.getCompanyID());
        
        if (!"".equals(formXslt) && formXslt != null) {
            String bodyHtml = commonUtil.convertXsltToHtml(formXslt, body);

            retParam = "<PARAMETER>"
                    + "<BODYHTML HTML=\"Y\"><![CDATA[" + bodyHtml + "]]></BODYHTML>"
                    + "</PARAMETER>";
        }
        
        /**
         * 연동테이블에서 본문 데이터를 html로 받아서 연동 하는 경우
         * */
        retParam = "<PARAMETER>"
                + "<BODYHTML HTML=\"Y\"><![CDATA[" + body + "]]></BODYHTML>"
                + "</PARAMETER>";
        
        // 연동 리턴데이터 생성 
        retStr = "<RETURNDATA RESULT=\"true\">"
                + retParam
                + "</RETURNDATA>";


        logger.debug("getBody ended");
        
        return retStr;
    }

    /**
     * 연동 상태를 업데이트하기 전 연동 가능한 상태인지 체크한다 (BEFORE 연동)
     * */
    public String checkStatus(Document keyData, LoginVO userInfo) throws Exception {
        logger.debug("checkStatus started");
        
        String connKey = keyData.getElementsByTagName("c_connkey").item(0).getTextContent().trim();
        String connFormCode = keyData.getElementsByTagName("c_connformcode").item(0).getTextContent().trim();
        String docId = keyData.getElementsByTagName("c_docid").item(0).getTextContent().trim();
        String processIdx = keyData.getElementsByTagName("c_processidx").item(0).getTextContent().trim();
        String processTime = keyData.getElementsByTagName("c_processtime").item(0).getTextContent().trim();

        logger.debug("### docId=" + docId + ", processIdx=" + processIdx + ", processTime=" + processTime + ", connKey=" + connKey + ", connFormCode=" + connFormCode);

        Map<String, Object> connData = getConnData(connKey, connFormCode);

        // 기안 가능한 데이터인지 상태 체크
        if ("DRAFT".equals(processTime) && processIdx.startsWith("DRAFTSAVE")) {
            String status = (String) connData.get("STATUS");
            if (!"INT".equals(status)) { // 기안 상신 시 INT상태가 아니면 연동 중단
                return "<RETURNDATA RESULT=\"close\">이미 결재가 진행중인 데이터입니다.</RETURNDATA>";
            }
        } else {
            String connDocId = (String) connData.get("DOCID");
            if (!docId.equals(connDocId)) { // 연동 테이블의 docid가 현재 docid와 다르면 연동 중단
                return "<RETURNDATA RESULT=\"close\">이미 결재가 진행중인 데이터입니다.</RETURNDATA>";
            }
        }

        logger.debug("checkStatus ended");

        return "<RETURNDATA RESULT=\"true\"></RETURNDATA>";
    }

    /**
     * 연동 상태를 업데이트한다 (AFTER 연동)
     * */
    public String updateStatus(Document keyData, LoginVO userInfo) throws Exception {
        logger.debug("updateStatus started");
        
        String connKey = keyData.getElementsByTagName("c_connkey").item(0).getTextContent().trim();
        String connFormCode = keyData.getElementsByTagName("c_connformcode").item(0).getTextContent().trim();
        String docId = keyData.getElementsByTagName("c_docid").item(0).getTextContent().trim();
        String processIdx = keyData.getElementsByTagName("c_processidx").item(0).getTextContent().trim();
        String processTime = keyData.getElementsByTagName("c_processtime").item(0).getTextContent().trim();

        logger.debug("### docId=" + docId + ", processIdx=" + processIdx + ", processTime=" + processTime + ", connKey=" + connKey + ", connFormCode=" + connFormCode);
        
        String status = "";
        String processFlag = processTime + ";" + processIdx.substring(0, processIdx.lastIndexOf("_"));
        switch (processFlag) {
            case "DRAFT;DRAFTSAVE": status = "ING"; break;
            case "DRAFT;DOCNUM": status = "LSN"; break;
            case "DRAFT;BANSONG": status = "RTN"; break;
            case "DRAFT;CALLBACK": status = "RCL"; break;
            case "SUSIN;DOCNUM": status = "SLS"; break;
            case "SUSIN;HESONG": status = "SRT"; break;
        }
        
        // 기안 상신의 경우 TBL_CONNATTACHINFODATA 테이블의 ATTACHFILEHREF 경로에 있는 파일 물리적 삭제처리
        if ("ING".equals(status)) {
            deleteConnAttachData(connKey, "2");
        }
        
        if (status.isEmpty()) {
            return "<RETURNDATA RESULT=\"false\"></RETURNDATA>";
        }

        // 연동 상태 업데이트 
        // 기안상신 시점이면 docid도 업데이트한다
        ezApprovalGConnDao.updateStatus(connKey, connFormCode, status, docId);

        logger.debug("updateStatus ended");

        return "<RETURNDATA RESULT=\"true\"></RETURNDATA>";
    }

    @Override
    public void registConnData(String keyId, String userId, String deptId, String title, String formCode, String bodyHtml) throws Exception {
        logger.debug("registConnData started");
        String nowDate = commonUtil.getTodayUTCTime("");

        Map<String, Object> map = new HashedMap<>();
        map.put("KEYID", keyId);
        map.put("USERID", userId);
        map.put("DEPTID", deptId);
        map.put("TITLE", title);
        map.put("FORMID", formCode);
        map.put("BODYHTML", bodyHtml);
        map.put("v_SYSDATE", nowDate);

        ezApprovalGConnDao.registConnData(map);
        logger.debug("registConnData ended");
    }

    @Override
    public List<Map<String, Object>> getConnAttachData(String keyId) throws Exception {
        logger.debug("getConnAttachData started");

        List<Map<String, Object>> list = ezApprovalGConnDao.getConnAttachData(keyId);

        logger.debug("getConnAttachData ended");
        return list;
    }

    @Override
    public void insertConnAttachData(String keyId, int attachSn, String attachFileName, String attachFileHref, long attachFileSize, String attachUserId) throws Exception {
        logger.debug("insertConnAttachData started");

        Map<String, Object> map = new HashMap<>();
        map.put("KEYID", keyId);
        map.put("ATTACHSN", attachSn);
        map.put("ATTACHFILENAME", attachFileName);
        map.put("ATTACHFILEHREF", attachFileHref);
        map.put("ATTACHFILESIZE", attachFileSize);
        map.put("ATTACHUSERID", attachUserId);
        
        ezApprovalGConnDao.insertConnAttachData(map);
        logger.debug("insertConnAttachData ended");
    }

    @Override
    public void deleteConnAttachData(String keyId, String type) throws Exception {
        logger.debug("deleteConnAttachData started");

        List<Map<String, Object>> list = ezApprovalGConnDao.getConnAttachData(keyId);
        
        for(Map<String, Object> info : list) {
            String delPath = commonUtil.getRealPath(servletContext) + (String) info.get("ATTACHFILEHREF");
            new EzFile(delPath).delete();
        }
        
        // 결재가 올라간 연동문서의 경우 파일첨부 정보 데이터는 히스토리를 위하여 삭제처리 하지 않음.
        if ("1".equals(type)) {
            ezApprovalGConnDao.deleteConnAttachData(keyId);
        }
		
        logger.debug("deleteConnAttachData ended");
    }

    @Override
    public void initConnAttachFileInfo(String docID, LoginVO userInfo, List<Map<String, Object>> attachList) throws Exception {
        logger.info("initConnAttachFileInfo started");

        String size = "";
        String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_DOCID", docID);
        map.put("companyID", userInfo.getCompanyID());
        map.put("v_TENANTID", userInfo.getTenantId());

        String targetHref = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
        
        for (int k = 0; k < attachList.size(); k++) {
            map = attachList.get(k);
            String from = commonUtil.getRealPath(servletContext) + map.get("ATTACHFILEHREF").toString();
            String to = commonUtil.getRealPath(servletContext) + commonUtil.separator
                    + targetHref + commonUtil.separator + userInfo.getCompanyID()
                    + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator
                    + (Integer.parseInt(docID.substring(docID.length() - 3, docID.length())) % 1000)
                    + commonUtil.separator + docID.trim()
                    + getNDigitNum(map.get("ATTACHSN").toString(), 4)
                    + map.get("ATTACHFILENAME");
            
            copyFile(from, to, to.substring(0, to.lastIndexOf(commonUtil.separator)));
            size = map.get("ATTACHFILESIZE").toString();

            /* 2020-03-25 홍승비 - 첨부파일 저장 시점부터 순서값 VIEWORDER 삽입 */
            map.put("v_DOCID", docID);
            map.put("v_ATTACHFILESN", map.get("ATTACHSN"));
            map.put("v_VIEWORDER", map.get("ATTACHSN"));
            map.put("v_ATTACHFILENAME", (String) map.get("ATTACHFILENAME"));
            map.put("v_ATTACHFILEHREF", to.substring(to.indexOf("/fileroot/")));
            map.put("v_ATTACHFILESIZE", size);
            map.put("v_ATTACHUSERID", userInfo.getId());
            map.put("v_ATTACHUSERNAME", userInfo.getDisplayName());
            map.put("v_ATTACHUSERNAME2", userInfo.getDisplayName2());
            map.put("v_ATTACHUSERJOBTITLE", userInfo.getJikChek());
            map.put("v_ATTACHUSERJOBTITLE2", userInfo.getJikChek2());
            map.put("v_ATTACHUSERDEPTID", userInfo.getDeptID());
            map.put("v_ATTACHUSERDEPTNAME", userInfo.getDeptName());
            map.put("v_ATTACHUSERDEPTNAME2", userInfo.getDeptName2());
            map.put("v_PAGENUM", 1);
            map.put("v_DISPLAYNAME", (String) map.get("ATTACHFILENAME"));
            map.put("v_BODYATTACH", "N");
            map.put("FLAG", "Y");
            map.put("companyID", userInfo.getCompanyID());
            map.put("v_TENANTID", userInfo.getTenantId());

            /* 2020-11-12 홍승비 - 대용량첨부 플래그, 첨부파일 최초 저장일 추가 */
            map.put("v_ISBIGATTACH", "N");
            map.put("v_ISBIGATTACHDEL", "N");
            map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
            ezApprovalGDAO.insertAprAttachInfo(map);
            ezApprovalGDAO.updateHistoryAttachInfo(map);
            ezApprovalGDAO.updateAttachFileInfo(map);
        }

        logger.info("initConnAttachFileInfo ended");
    }

    public String getNDigitNum(String strValue, int numDigits) {
        int valueLen = strValue.length();
        String tempDigit = "";

        while (valueLen < numDigits) {
            tempDigit = "0" + "" + tempDigit;
            valueLen++;
        }

        return tempDigit + strValue;
    }

    public boolean copyFile(String source, String target, String dirPath) throws Exception {
        logger.debug("copyFile started source : " + source);
        logger.debug("copyFile started target : " + target);

        if (!dirPath.trim().equals("")) {
            EzFile file = new EzFile(commonUtil.detectPathTraversal(dirPath));

            if (!file.exists()) {
                file.mkdirs();
            }
        }
        try {
            EzFile src = new EzFile(commonUtil.detectPathTraversal(source));
            EzFile des = new EzFile(commonUtil.detectPathTraversal(target));

            EzFAL.copyFile(src, des);

            logger.debug("copyFile ended");
            return true;
        } catch (Exception e) {
            logger.debug("e: {}", e);
            return false;
        }
    }
    @Override
    public String checkFileAttach(List<MultipartFile> attachList, int tenantID) throws Exception {
        logger.debug("checkFileAttach started");

        String apprAttachCntLimitMax = ezCommonService.getTenantConfig("ApprAttachCntLimitMax", tenantID);
        String apprTotalAttachLimit = ezCommonService.getTenantConfig("ApprTotalAttachLimit", tenantID);
        String ext = ezCommonService.getTenantConfig("USE_FileExtension", tenantID);

        long totalSize = 0;
        long maxSizeByte = (long) (Integer.parseInt(apprTotalAttachLimit)) * 1024 * 1024;
        try {
            for (MultipartFile attachInfo : attachList) {
                long fileSize = attachInfo.getSize();
                String fileName = attachInfo.getOriginalFilename();
                String fileExt = "";

                if (fileName != null && fileName.contains(".")) {
                    fileExt = fileName.substring(fileName.lastIndexOf(".") + 1);
                }
                if (fileSize == 0) {
                    return "ZERO_SIZE"; // 파일 사이즈 0일때
                }
                if (!ext.contains(fileExt)) {
                    return "EXT_ERROR"; // 파일 확장자 에러
                }
                totalSize += fileSize;
            }
            if (attachList.size() > Integer.parseInt(apprAttachCntLimitMax)) {
                return "OVER_CNT";  // 파일 개수 에러
            }

            if (maxSizeByte != 0 && totalSize > maxSizeByte) {
                return "OVER_SIZE"; // 파일 사이즈 에러
            }
        } catch (Exception e) {
            return "ERROR";
        }

        logger.debug("checkFileAttach ended");
        return "TRUE";
    }
    
    @Override
    public String getDraftUrl(Map<String, Object> connData, LoginVO userInfo) throws Exception {
        String keyId = (String) connData.get("KEYID");
        String formCode = (String) connData.get("FORMCODE");
        String fileCheck = (String) connData.get("fileCheck");

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
            if (fileCheck != null && !fileCheck.isEmpty()) 
                queryParam.set("connAttachCheck", fileCheck);
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
            if (fileCheck != null && !fileCheck.isEmpty())
                queryParam.set("connAttachCheck", fileCheck);
        } else {
            throw new Exception();
        }

        return makeUrl(path, queryParam);
    }

    @Override
    public String getAprUrl(Map<String, Object> connData, LoginVO userInfo) throws Exception {
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

    @Override
    public String getEndUrl(Map<String, Object> connData, LoginVO userInfo) throws Exception {
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
}
