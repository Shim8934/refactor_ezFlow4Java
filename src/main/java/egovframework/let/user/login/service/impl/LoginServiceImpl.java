package egovframework.let.user.login.service.impl;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Properties;

import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.let.user.login.dao.LoginDAO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.utl.fcc.service.EgovNumberUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
@Service("loginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService {

    private static final Logger logger = LoggerFactory.getLogger(LoginServiceImpl.class);
            
    @Resource(name="loginDAO")
    private LoginDAO loginDAO;

    @Autowired
    private Properties config;
        
    @Autowired
    private EzEmailUtil ezEmailUtil;

    public LoginVO selectUserForJMocha(LoginVO vo) throws Exception {
        logger.debug("selectUserForJMocha started. id=" + vo.getId());
        
        LoginVO loginVO = new LoginVO();
                
        String param1 = "tenantId=" + URLEncoder.encode(vo.getTenantId() + "", "UTF-8");
        String param2 = "userId=" + URLEncoder.encode(vo.getId(), "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getUserInfo";
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
    
    public LoginVO selectUserForLocal(LoginVO vo) throws Exception {

        // 1. 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
        LoginVO loginVO = loginDAO.selectUser(vo);
        // 2. 결과를 리턴한다.
        if (loginVO != null && !loginVO.getId().equals("") && !loginVO.getPassword().equals("")) {
            return loginVO;
        } else {
            loginVO = new LoginVO();
        }

        return loginVO;
    }
    
    /**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    @Override
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
    @Override
	public LoginVO searchId(LoginVO vo) throws Exception {

    	// 1. 이름, 이메일주소가 DB와 일치하는 사용자 ID를 조회한다.
    	LoginVO loginVO = loginDAO.searchId(vo);

    	// 2. 결과를 리턴한다.
    	if (loginVO != null && !loginVO.getId().equals("")) {
    		return loginVO;
    	} else {
    		loginVO = new LoginVO();
    	}

    	return loginVO;
    }

    /**
	 * 비밀번호를 찾는다.
	 * @param vo LoginVO
	 * @return boolean
	 * @exception Exception
	 */
    @Override
	public boolean searchPassword(LoginVO vo) throws Exception {

    	boolean result = true;

    	// 1. 아이디, 이름, 이메일주소, 비밀번호 힌트, 비밀번호 정답이 DB와 일치하는 사용자 Password를 조회한다.
    	LoginVO loginVO = loginDAO.searchPassword(vo);
    	if (loginVO == null || loginVO.getPassword() == null || loginVO.getPassword().equals("")) {
    		return false;
    	}

    	// 2. 임시 비밀번호를 생성한다.(영+영+숫+영+영+숫=6자리)
    	String newpassword = "";
    	for (int i = 1; i <= 6; i++) {
    		// 영자
    		if (i % 3 != 0) {
    			newpassword += EgovStringUtil.getRandomStr('a', 'z');
    		// 숫자
    		} else {
    			newpassword += EgovNumberUtil.getRandomNum(0, 9);
    		}
    	}

    	// 3. 임시 비밀번호를 암호화하여 DB에 저장한다.
    	LoginVO pwVO = new LoginVO();
    	String enpassword = EgovFileScrty.encryptPassword(newpassword, vo.getId());
    	pwVO.setId(vo.getId());
    	pwVO.setPassword(enpassword);
    	pwVO.setUserSe(vo.getUserSe());
    	loginDAO.updatePassword(pwVO);


    	return result;
    }


	@Override
	public void updateUser(LoginVO vo) throws Exception {
		// TODO Auto-generated method stub
		loginDAO.updateUser(vo);
	}


	@Override
	public void insertLog(LoginVO vo) throws Exception {
		// TODO Auto-generated method stub
		loginDAO.insertLog(vo);
	}


	@Override
	public List<String> getUserIDList() throws Exception {
		return loginDAO.getUserIDList();
	}


	@Override
	public void updatePassword(String userID, String pwd) throws Exception {
		LoginVO pwVO = new LoginVO();
		
		pwVO.setId(userID);
		pwVO.setPassword(pwd);
		
		loginDAO.updatePassword(pwVO);
	}


	private int getTenantIdForJMocha(String serverName) throws Exception {
	    logger.debug("getTenantIdForJMocha started. serverName=" + serverName);
	    
	    int returnValue = -1;
	    
        String param1 = "serverName=" + URLEncoder.encode(serverName, "UTF-8");
        String inputParams = param1;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getTenantId";
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
                        returnValue = Integer.parseInt((String)result.get("tenantId"));
                    }                   
                }
            }
        }                       
        
        logger.debug("getTenantIdForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;                
	}
	
    private int getTenantIdForLocal(String serverName) throws Exception {
        logger.debug("getTenantIdForLocal started. serverName=" + serverName);
        
        int tenantId = -1;
        
        TenantServerNameVO tenantServerNameVO = loginDAO.selectTenantServerName(serverName);
        
        if (tenantServerNameVO != null) {
            tenantId = tenantServerNameVO.getTenantId();
        }
        
        logger.debug("getTenantIdForLocal ended. tenantId=" + tenantId);
        
        return tenantId;
    }
	
    @Override
    public int getTenantId(String serverName) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getTenantIdForJMocha(serverName);
        } else {
            return getTenantIdForLocal(serverName);
        }
    }

}