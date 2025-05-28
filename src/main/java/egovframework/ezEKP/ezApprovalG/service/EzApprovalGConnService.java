package egovframework.ezEKP.ezApprovalG.service;

import egovframework.let.user.login.vo.LoginVO;
import org.json.simple.JSONObject;
import org.springframework.web.multipart.MultipartFile;
import org.w3c.dom.Document;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public interface EzApprovalGConnService {
    Map<String, Object> getConnData(String keyId, String formCode) throws Exception;

    String getDocUiFlag(String docId, int tenantId, String companyId) throws Exception;

    String getBody(Document keyData, LoginVO userInfo) throws Exception;

    String checkStatus(Document keyData, LoginVO userInfo) throws Exception;

    String updateStatus(Document keyData, LoginVO userInfo) throws Exception;
    
    void registConnData(String keyId, String userId, String deptId, String title, String formCode, String bodyXml) throws Exception;
    
    List<Map<String, Object>> getConnAttachData(String keyId) throws Exception;

    void initConnAttachFileInfo(String docID, LoginVO userInfo, List<Map<String, Object>> list) throws Exception;
        
    void insertConnAttachData(String keyId, int attachSn, String attachFileName, String attachFileHref, long attachFileSize, String attachUserId) throws Exception;
    
    void deleteConnAttachData(String keyId, String type) throws Exception;
    
    String checkFileAttach(List<MultipartFile> attachList, int tenantID) throws Exception;
    
    String getDraftUrl(Map<String, Object> connData, LoginVO userInfo) throws Exception;

    String getAprUrl(Map<String, Object> connData, LoginVO userInfo) throws Exception;

    String getEndUrl(Map<String, Object> connData, LoginVO userInfo) throws Exception;
}
