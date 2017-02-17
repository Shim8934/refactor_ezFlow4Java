package egovframework.ezEKP.ezPersonal.dao;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezPersonal.vo.PersonalApprovMailVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetQuickLinkMenuVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPersonalDAO")
public class EzPersonalDAO extends EgovAbstractDAO{
	
    private static final Logger logger = LoggerFactory.getLogger(EzPersonalDAO.class);
    
    @Autowired
    private Properties config;

    @Autowired
    private EzEmailUtil ezEmailUtil;
    
	@SuppressWarnings("unchecked")
	public List<PersonalSliderImageVO> getSilderList (Map<String, Object> map) {
		return (List<PersonalSliderImageVO>) list("EzPersonalDAO.getSliderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalApprovMailVO> getApprovNotiConfig(Map<String, Object> map) throws Exception{
		return (List<PersonalApprovMailVO>) list("EzPersonalDAO.getApprovNotiConfig", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalApprovMailVO> getApprovNotiConfig_S2(Map<String, Object> map) throws Exception{
		return (List<PersonalApprovMailVO>) list("EzPersonalDAO.getApprovNotiConfig_S2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalApprovMailVO> getApprovNotiConfig_S3(Map<String, Object> map) throws Exception{
		return (List<PersonalApprovMailVO>) list("EzPersonalDAO.getApprovNotiConfig_S3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollListUser(Map<String, Object> map) throws Exception{
		return (List<PersonalLightPollVO>) list("EzPersonalDAO.getPollListUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollResultOrderResult (Map<String, Object> map) {
		return (List<PersonalLightPollVO>) list("EzPersonalDAO.getPollResultOrderResult", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollResult (Map<String, Object> map) {
		return (List<PersonalLightPollVO>) list("EzPersonalDAO.getPollResult", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetPopUpListUserVO> getPopUpListUser (Map<String, Object> map) {
		return (List<PersonalGetPopUpListUserVO>) list("EzPersonalDAO.getPopUpListUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetWebPartGroupVO> getWebPartGroup (Map<String, Object> map) {
		return (List<PersonalGetWebPartGroupVO>) list("EzPersonalDAO.getWebPartGroup", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetWebPartVO> getUserWebPart_S2 (Map<String, Object> map) {
		return (List<PersonalGetWebPartVO>) list("EzPersonalDAO.getUserWebPart_S2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetWebPartVO> getUserWebPart_S3 (Map<String, Object> map) {
		return (List<PersonalGetWebPartVO>) list("EzPersonalDAO.getUserWebPart_S3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetQuickLinkMenuVO> getQuickLinkMenu (Map<String, Object> map) {
		return (List<PersonalGetQuickLinkMenuVO>) list("EzPersonalDAO.getQuickLinkMenu", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalNoticeVO> getNoticeListMain (Map<String, Object> map) {
		return (List<PersonalNoticeVO>) list("EzPersonalDAO.getNoticeListMain", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalNoticeVO> getNoticeListUser (Map<String, Object> map) {
		return (List<PersonalNoticeVO>) list("EzPersonalDAO.getNoticeListUser", map);
	}
	
	public PersonalGetEmpOfMonthVO getEmpOfMonth (Map<String, Object> map) {
		return (PersonalGetEmpOfMonthVO) select("EzPersonalDAO.getEmpOfMonth", map);
	}
	
	public PersonalLightPollVO getCurrentPoll (Map<String, Object> map) {
		return (PersonalLightPollVO) select("EzPersonalDAO.getCurrentPoll", map);
	}
	
	public PersonalLightPollVO getPollInfo (Map<String, Object> map) {
		return (PersonalLightPollVO) select("EzPersonalDAO.getPollInfo", map);
	}
	
    private String getPasswordForJMocha (String cn, int tenantID) throws Exception {
        logger.debug("getPasswordForJMocha started. tenantId=" + tenantID + ",cn=" + cn);
        
        String resultValue = null;
                
        String param1 = "tenantId=" + URLEncoder.encode(tenantID + "", "UTF-8");
        String param2 = "userId=" + URLEncoder.encode(cn, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getUserPassword";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);
        
        String resultCode = "Error";
        int reasonCode = -100; 
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
                
                if (reasonCode == 0) {
                    JSONObject result = (JSONObject)responseObj.get("result");
                    
                    if (result != null) {
                        resultValue = (String)result.get("password");
                    }                   
                }
            }
        }                       
        
        logger.debug("getPasswordForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return resultValue;
    }
	
    private String getPasswordForLocal (String cn, int tenantID) {
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("cn", cn);
    	map.put("tenantID", tenantID);
        return (String) select("EzPersonalDAO.getPassword", map);
    }
    
    public String getApprovNotiConfig_S1 (Map<String, Object> map) {
        return (String) select("EzPersonalDAO.getApprovNotiConfig_S1", map);
    }
    
    public String setApprovalPwd_S (Map<String, Object> map) {
        return (String) select("EzPersonalDAO.setApprovalPwd_S", map);
    }
    
    public String setApprovNotiMail_S (Map<String, Object> map) {
        return (String) select("EzPersonalDAO.setApprovNotiMail_S", map);
    }
    
    public String insertResult_S (Map<String, Object> map) {
        return (String) select("EzPersonalDAO.insertResult_S", map);
    }
    
    public String getUserWebPart_S1 (Map<String, Object> map) {
        return (String) select("EzPersonalDAO.getUserWebPart_S1", map);
    }
    
	public String getPassword (String cn, int tenantID) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getPasswordForJMocha(cn, tenantID);
        } else {
            return getPasswordForLocal(cn, tenantID);
        }       
	}
	
	public int getPollCount(Map<String, Object> map) {
		return (int) select("EzPersonalDAO.getPollCount", map);
	}

	public void setApprovalPwd(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovalPwd", map);
	}

	public void setApprovNotiMail(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovNotiMail", map);
	}
	
	public void insertResult(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.insertResult", map);
	}
	
	public void setApprovalPwd_I(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovalPwd_I", map);
	}
	
	public void setApprovNotiMail_I(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovNotiMail_I", map);
	}
	
	public void setApprovalPwd_U(Map<String, Object> map) throws Exception{
		update("EzPersonalDAO.setApprovalPwd_U", map);
	}
	
	public void setApprovNotiMail_U(Map<String, Object> map) throws Exception{
		update("EzPersonalDAO.setApprovNotiMail_U", map);
	}
	
}
