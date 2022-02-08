package egovframework.ezEKP.ezApprovalG.service;

import egovframework.let.user.login.vo.LoginVO;
import org.w3c.dom.Document;

import java.util.Map;

public interface EzApprovalGConnService {
    Map<String, Object> getConnData(String keyId, String formCode) throws Exception;

    String getDocUiFlag(String docId, int tenantId, String companyId) throws Exception;

    String getBody(Document keyData, LoginVO userInfo) throws Exception;

    String checkStatus(Document keyData, LoginVO userInfo) throws Exception;

    String updateStatus(Document keyData, LoginVO userInfo) throws Exception;
}
