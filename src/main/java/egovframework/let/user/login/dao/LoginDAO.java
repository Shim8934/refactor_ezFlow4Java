package egovframework.let.user.login.dao;


import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
/**
 * 일반 로그인을 처리하는 비즈니스 구현 클래스
 * @author 공통서비스 개발팀 박지욱
 * @since 2009.03.06
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2009.03.06  박지욱          최초 생성
 *  2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 *  </pre>
 */
@Repository("loginDAO")
public class LoginDAO extends EgovAbstractDAO {

    private static final Logger logger = LoggerFactory.getLogger(LoginDAO.class);
            
    @Autowired
    private Properties config;

    @Autowired
    private EzEmailUtil ezEmailUtil;

    private LoginVO selectUserForJMocha(LoginVO vo) throws Exception {
        logger.debug("selectUserForJMocha started. tenantId=" + vo.getTenantId() + ",id=" + vo.getId());
        
        LoginVO loginVO = null;
                
        String param1 = "tenantId=" + URLEncoder.encode(vo.getTenantId() + "", "UTF-8");
        String param2 = "userId=" + URLEncoder.encode(vo.getId(), "UTF-8");
        String param3 = "password=" + URLEncoder.encode(vo.getPassword() != null ? vo.getPassword() : "", "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getLoginInfo";
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
                        loginVO = new LoginVO();
                                
                        loginVO.setId((String)result.get("userId"));
                        loginVO.setPassword((String)result.get("password"));
                        loginVO.setDisplayName1((String)result.get("displayname"));
                        loginVO.setDisplayName2((String)result.get("displayname2"));
                        loginVO.setDeptID((String)result.get("department"));
                        loginVO.setDeptName1((String)result.get("description"));
                        loginVO.setDeptName2((String)result.get("description2"));
                        loginVO.setTitle1((String)result.get("title"));
                        loginVO.setTitle2((String)result.get("title2"));
                        loginVO.setCompanyID((String)result.get("companyid"));
                        loginVO.setCompanyName1((String)result.get("company"));
                        loginVO.setCompanyName2((String)result.get("company2"));
                        
                        String updateDt = (String)result.get("updatedt");
                        
                        if (updateDt != null) {
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            loginVO.setUpdateDT(sdf.parse(updateDt));
                        }
                        
                        loginVO.setRollInfo((String)result.get("permissions"));
                        loginVO.setPhone((String)result.get("telephoneNumber"));
                        loginVO.setEmail((String)result.get("mail"));
                        loginVO.setJikChek((String)result.get("role1"));
                        loginVO.setJikChek2((String)result.get("role2"));
                        loginVO.setTenantId(Integer.parseInt((String)result.get("tenantId")));
                    }                   
                }
            }
        }                       
        
        logger.debug("selectUserForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return loginVO;
    }
    
    private LoginVO selectUserForLocal(LoginVO vo) throws Exception {
        return (LoginVO)select("loginDAO.selectUser", vo);
    }
    
	/**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO selectUser(LoginVO vo) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return selectUserForJMocha(vo);
        } else {
            return selectUserForLocal(vo);
        }       
    }

    /**
	 * 아이디를 찾는다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO searchId(LoginVO vo) throws Exception {

    	return (LoginVO)select("loginDAO.searchId", vo);
    }

    /**
	 * 비밀번호를 찾는다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO searchPassword(LoginVO vo) throws Exception {

    	return (LoginVO)select("loginDAO.searchPassword", vo);
    }

    private void updatePasswordForJMocha(LoginVO vo) throws Exception {
        logger.debug("updatePasswordForJMocha started. tenantId=" + vo.getTenantId() + ",userId=" + vo.getId());

        String param1 = "tenantId=" + vo.getTenantId();
        String param2 = "userId=" + URLEncoder.encode(vo.getId(), "UTF-8");
        String param3 = "password=" + URLEncoder.encode(vo.getPassword(), "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/updateUserPassword";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);

        String resultCode = "Error";
        int reasonCode = -100; // 웹서비스로부터 아무런 응답을 받지 못하거나 OK 응답이 오지 않은 경우를 의미
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
            }
        }                       
        
        logger.debug("updatePasswordForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Updating User Password Failed!");
        }
    }
    
    private void updatePasswordForLocal(LoginVO vo) throws Exception {
        update("loginDAO.updatePassword", vo);
    }
    
    /**
	 * 변경된 비밀번호를 저장한다.
	 * @param vo LoginVO
	 * @exception Exception
	 */
    public void updatePassword(LoginVO vo) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            updatePasswordForJMocha(vo);
        } else {
            updatePasswordForLocal(vo);
        }       
    }
    
    private void updateUserForJMocha(LoginVO vo) throws Exception {
        logger.debug("updateUserForJMocha started. tenantId=" + vo.getTenantId() + ",userId=" + vo.getId());

        String param1 = "tenantId=" + vo.getTenantId();
        String param2 = "userId=" + URLEncoder.encode(vo.getId(), "UTF-8");
        String param3 = "ipAddress=" + URLEncoder.encode(vo.getIp(), "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/updateUserLoginTrackInfo";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);

        String resultCode = "Error";
        int reasonCode = -100; // 웹서비스로부터 아무런 응답을 받지 못하거나 OK 응답이 오지 않은 경우를 의미
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
            }
        }                       
        
        logger.debug("updateUserForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Updating User Failed!");
        }
    }
    
    private void updateUserForLocal(LoginVO vo) throws Exception {
        update("loginDAO.updateUser", vo);
    }
    
    public void updateUser(LoginVO vo) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            updateUserForJMocha(vo);
        } else {
            updateUserForLocal(vo);
        }       
    }

    private void insertLogForJMocha(LoginVO vo) throws Exception {
        logger.debug("insertLogForJMocha started. tenantId=" + vo.getTenantId() + ",userId=" + vo.getId());

        String param1 = "tenantId=" + vo.getTenantId();
        String param2 = "userId=" + URLEncoder.encode(vo.getId(), "UTF-8");
        String param3 = "connectIp=" + URLEncoder.encode(vo.getIp(), "UTF-8");
        String param4 = "connectBrowser=" + URLEncoder.encode(vo.getBrowser(), "UTF-8");
        String param5 = "connectOS=" + URLEncoder.encode(vo.getOs(), "UTF-8");
        String param6 = "connectAgent=" + URLEncoder.encode(vo.getAgent(), "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5 + "&" + param6;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/addLoginLog";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);

        String resultCode = "Error";
        int reasonCode = -100; // 웹서비스로부터 아무런 응답을 받지 못하거나 OK 응답이 오지 않은 경우를 의미
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
            }
        }                       
        
        logger.debug("insertLogForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Inserting Log Failed!");
        }        
    }
    
    private void insertLogForLocal(LoginVO vo) throws Exception {
        update("loginDAO.insertLog", vo);
    }
    
    public void insertLog(LoginVO vo) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            insertLogForJMocha(vo);
        } else {
            insertLogForLocal(vo);
        }       
    }

	@SuppressWarnings("unchecked")
	public List<String> getUserIDList() throws Exception{
		return (List<String>) list("loginDAO.getUserIDList");
	}
	
    public TenantServerNameVO selectTenantServerName(String serverName) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();        
        map.put("serverName", serverName);
        
        return (TenantServerNameVO)select("loginDAO.selectTenantServerName", map);
    }
 
	
}
