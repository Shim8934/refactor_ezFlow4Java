package egovframework.ezEKP.ezApprovalG.service.impl;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.apache.commons.collections4.map.HashedMap;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGConnDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGConnService;
import org.w3c.dom.Document;

import javax.servlet.http.HttpServletRequest;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;

@Service("EzApprovalGConnService")
public class EzApprovalGConnServiceImpl extends EgovFileMngUtil implements EzApprovalGConnService {
    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGConnServiceImpl.class);
    
    @Autowired
    CommonUtil commonUtil;
    
    @Autowired
    EzApprovalGConnDAO ezApprovalGConnDao;

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
}
