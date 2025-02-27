package egovframework.ezEKP.ezApprovalG.dao;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.stereotype.Repository;

import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository("EzApprovalGConnDAO")
public class EzApprovalGConnDAO extends EgovAbstractDAO {
    public Map<String, Object> getConnData(String keyId, String formCode) throws Exception {
        Map<String, Object> param = new HashedMap() {{
            put("keyId", keyId);
            put("formCode", formCode);
        }};
        
        return (Map<String, Object>) select("ezApprovalGConn.getConnData", param);
    }
    
    public void updateStatus(String keyId, String formCode, String status, String docId) throws Exception {
        Map<String, Object> param = new HashedMap() {{
            put("keyId", keyId);
            put("formCode", formCode);
            put("status", status);
            put("docId", docId);
        }};

        update("ezApprovalGConn.updateStatus", param);
    }
    
    public String getDocUiFlag(String docId, int tenantId, String companyId) throws Exception {
        Map<String, Object> param = new HashedMap() {{
            put("docId", docId);
            put("tenantId", tenantId);
            put("companyId", companyId);
        }};
        
        return (String) select("ezApprovalGConn.getDocUiFlag", param);
    }
    
    public String getFormXslt(String formId, int tenantId, String companyId) throws Exception {
        Map<String, Object> param = new HashedMap() {{
            put("formId", formId);
            put("tenantId", tenantId);
            put("companyId", companyId);
        }};

        return (String) select("ezApprovalGConn.getFormXslt", param);
    }
    
    public void registConnData(Map<String, Object> map) throws Exception {
        insert("EzApprovalGConnDAO.registConnData", map);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getConnAttachData(String keyId) throws Exception {
        return (List<Map<String, Object>>) list("ezApprovalGConn.getConnAttachData", keyId);
    }
    
    public void insertConnAttachData(Map<String, Object> map) throws Exception {
        insert("ezApprovalGConn.insertConnAttachData", map);
    }

    public void deleteConnAttachData(String keyID) {
        delete("ezApprovalGConn.deleteConnAttachData", keyID);
    }
}
