package egovframework.ezEKP.ezApprovalG.service;

import egovframework.let.user.login.vo.LoginVO;
import org.json.simple.JSONObject;
import org.w3c.dom.Document;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

public interface EzApprovalGConnService {
    Map<String, Object> getConnData(String keyId, String formCode) throws Exception;

    String getDocUiFlag(String docId, int tenantId, String companyId) throws Exception;

    String getBody(Document keyData, LoginVO userInfo) throws Exception;

    String checkStatus(Document keyData, LoginVO userInfo) throws Exception;

    String updateStatus(Document keyData, LoginVO userInfo) throws Exception;
    
    void registConnData(String keyId, String userId, String deptId, String title, String formCode, String bodyXml) throws Exception;
}
