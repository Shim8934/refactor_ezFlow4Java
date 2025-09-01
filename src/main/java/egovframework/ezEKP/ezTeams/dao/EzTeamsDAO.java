package egovframework.ezEKP.ezTeams.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezTeams.vo.TeamsPresenceVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

@Repository("EzTeamsDAO")
public class EzTeamsDAO extends EgovAbstractDAO {

    private static final Logger logger = LoggerFactory.getLogger(EzTeamsDAO.class);

    @SuppressWarnings("unchecked")
    public List<TeamsPresenceVO> getPresenceList(List<String> cnList) {
        return (List<TeamsPresenceVO>) list("EzTeamsDAO.getPresenceList", cnList);
    }
    
    @SuppressWarnings("unchecked")
    public List<String> getTeamsIdList() throws Exception {
        return (List<String>) list("EzTeamsDAO.getTeamsIdList");
    }

    public int updatePresenceStatus(Map<String, Object> param) throws Exception {
        return update("EzTeamsDAO.updatePresenceStatus", param);
    }

    public void insertPresenceStatus(Map<String, Object> param) throws Exception {
        insert("EzTeamsDAO.insertPresenceStatus", param);
    }

    public List<String> getToken(Map<String, Object> param) throws Exception {
        return (List<String>) list("EzTeamsDAO.getToken", param);
    }

    public int checkAuthToken(String apiType, String tokenType) {
        Map<String, Object> map = new HashMap<>();
        map.put("APITYPE", apiType);
        map.put("TOKENTYPE", tokenType);
        return (Integer) select("EzTeamsDAO.checkAuthToken", map);
    }

    public void insertAuthToken(Map<String, Object> paramMap) {
        insert("EzTeamsDAO.insertAuthToken", paramMap);
    }

    public void updateAuthToken(Map<String, Object> paramMap) {
        update("EzTeamsDAO.updateAuthToken", paramMap);
    }
}
