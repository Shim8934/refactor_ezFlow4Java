package egovframework.let.user.login.web;

import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
/** 
 * @Description [Controller] 모바일 - 로그인
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 * @
 * @  수정일         		수정자                   수정내용
 * @ -------    	--------    ---------------------------
 * @ 2017.08.02    	장진혁       		 최초 생성
 * @see
 */
@RestController
public class MLoginGWController {

	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
    /** LoginService */
	@Resource(name = "loginService")
    private LoginService loginService;
    
    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
        
    /** CRYPTO */
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
    
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
    
    /** Logger */
    private static final Logger LOGGER = LoggerFactory.getLogger(MLoginGWController.class);
	
    /**
	 * 모바일 G/W 사용자 [GET] 로그인
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezUser/login/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")    
    public JSONObject login(@PathVariable String userId, HttpServletRequest request) throws Exception {
    	LOGGER.debug("=========================================== G/W login ============================================");
    	
    	JSONObject result = new JSONObject();
    	
    	try {
    		PrivateKey pk = EgovFileScrty.getPrivateKey(egovFileScrty.getPrm(), egovFileScrty.getPre());
    		
    		String uid = EgovFileScrty.decryptRsa(pk, userId);
    		
    		if (uid == null || uid.equals("")) {
    			LOGGER.debug("invalid uid=" + uid);
    			
    			result.put("status", "error");
    			result.put("code", "2");			
    			result.put("data", "invalid uid");
    			
    		    return result;
    		}
    		
    		String rpwd = EgovFileScrty.decryptRsa(pk, request.getParameter("pw"));
    		String pwd = EgovFileScrty.encryptPassword(rpwd, uid);
    		
    		String serverName = request.getHeader("x-user-host");
    		int tenantId = loginService.getTenantId(serverName);
			    		
    		LoginVO loginVO = new LoginVO();
    		
    		loginVO.setId(uid);
    		loginVO.setPassword(pwd);
    		loginVO.setTenantId(tenantId);
    		
    		LoginVO resultVO = loginService.selectUser(loginVO);
    		
    		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {        	
            	//비밀번호 변경 팝업 상태 값 초기화
            	int diff = 1;
            	
            	if (resultVO.getLoginCnt() == 0) {
            		LOGGER.debug("isFirstLogin");
                	
        			result.put("status", "error");
        			result.put("code", "4");			
        			result.put("data", "isFirstLogin");
        			
        			return result;
            	} else {
    	        	String expirePassPeriod = ezCommonService.getTenantConfig("ExpirePassPeriod", tenantId);        	
    	        	
    	        	if (!expirePassPeriod.trim().equals("0")) {
    	        		int realPeriod = Integer.parseInt("-" + expirePassPeriod.trim());
    	        		
    	        		Calendar cal = Calendar.getInstance();
    	        		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	            	
    	            	String baseStr = commonUtil.getTodayUTCTime("");        	
    	            	Date baseDT = date.parse(baseStr);
    	            	            	
    	            	cal.setTime(baseDT);
    	            	cal.add(Calendar.DATE, realPeriod);
    	            	
    	            	baseDT = cal.getTime();
    	            	Date lastDT = resultVO.getUpdateDT();
    	            	//오늘 기준 6개월전 날짜, 마지막 개인정보 수정일자 간 뺄셈
    	    			diff = EgovDateUtil.getDaysDiff(baseDT, lastDT);	    			
    	        	}	        	
            	}        	        	
    			//0보다 작아지면 패스워드 변경기한 Expired
    			if (diff <= 0) {
    				LOGGER.debug("isExpireDate");
                	
        			result.put("status", "error");
        			result.put("code", "5");			
        			result.put("data", "isExpireDate");
        			
        			return result;    	        	
    			} else {			
    				String ip = ClientUtil.getClientIP(request);		
    				loginVO.setIp(ip);
    				
    				//IP Address,  마지막 login시간 저장
    				loginService.updateUser(loginVO);
    				
    				//접속 로그정보 저장
    				resultVO.setIp(ip);
    				resultVO.setAgent(ClientUtil.getClientInfo(request, "agent"));
    				resultVO.setOs(ClientUtil.getClientInfo(request, "os"));
    				resultVO.setBrowser(ClientUtil.getClientInfo(request, "browser"));
    				resultVO.setTenantId(tenantId);

    				if(resultVO.getTitle2() == null){
    					resultVO.setTitle2("");
    				}
    				
    				loginService.insertLog(resultVO);

    				//DB에서 모바일 환경설정 값 가져옴
    				MOptionVO mOptionVO = mOptionService.optionInfo(uid, tenantId);
    				
    				String acceptLanguage = request.getHeader("Accept-Language");    				
    				String lang = "";
    				String timeZone = "";
    				String maintype = "";
    				String listCnt = "";    				
    				String useSecurity = "";					
    				String returnValue = "";
    				
    				String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
    				
    				//userMobileInfo 테이블에 정보가 없을 때 (첫 로그인)
    				if (mOptionVO == null || mOptionVO.equals("")) {    			        
    					
    			        //UsePrimaryLangOnly가 YES일 때는 무조건 PrimaryLang 언어로 설정한다.
    			        if (config.getProperty("config.UsePrimaryLangOnly").equals("YES")) {
    				        if (primaryLang.equals("1")) {
    				        	acceptLanguage = "ko";
    				        } else if (primaryLang.equals("3")) {
    				        	acceptLanguage = "ja";
    				        }
    			        }
    			        
    				    if (acceptLanguage != null) {
    				        returnValue = acceptLanguage.substring(0, 2);
    				    //이유는 정확히 알 수 없지만 로그를 확인한 결과 윗 라인에서 acceptLanguage가 null인 경우가 발생하여 추가함.
    				    } else {				        
    				        returnValue = commonUtil.getTwoLetterLangFromLangNum(primaryLang);
    				    }
    					
    				    lang = commonUtil.getLangNumFromTwoLetterLang(returnValue);
    				    
    				    //브라우저 언어가 한국어,영어,일본어,중국어가 아닐 때 config의 primary 언어를 가져옴.
    				    if (lang.equals("")) {						
    						lang = primaryLang;
    					}
    					
    				    timeZone = "235|+09:00";
    				    maintype = "D";
    				    listCnt = "10";    				    
    				    useSecurity = "N";
    				    
    					mOptionService.insertOption(uid, timeZone, lang, maintype, listCnt, useSecurity, tenantId);    					
    				} else {
    					lang = mOptionVO.getLang();
    					timeZone = mOptionVO.getTimeZone();
        				maintype = mOptionVO.getMainType();
        				listCnt = mOptionVO.getListCnt();        				
        				useSecurity = mOptionVO.getUseSecurity();
        				returnValue = commonUtil.getTwoLetterLangFromLangNum(lang);
    				}
 				
    				Map<String, Object> map = new HashMap<String, Object>();
    				map.put("uid", uid);
    				map.put("ip", ip);
    				map.put("locale", returnValue);
    				map.put("lang", lang);
    				map.put("timeZone", timeZone);
    				map.put("tenantId", tenantId+"");
    				map.put("mainType", maintype);
    				map.put("listCnt", listCnt);    				
    				map.put("useSecurity", useSecurity);    		
    				map.put("companyID", resultVO.getCompanyID());
    				map.put("primaryLang", primaryLang);
    				map.put("rollInfo", resultVO.getRollInfo());
    				
    				if (commonUtil.getPrimaryData(lang, tenantId) == "1") {
    					map.put("userName", resultVO.getDisplayName1());
    				} else {
    					map.put("userName", resultVO.getDisplayName2());
    				}
				    				    				
    				result.put("status", "ok");
    				result.put("code", "0");
    				result.put("data", map);
    				
    				return result;
    			}			
            } else {
            	LOGGER.debug("user does not exist :" + uid);
            	
    			result.put("status", "error");
    			result.put("code", "3");			
    			result.put("data", "user does not exist");
    			
    			return result;
            }    		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");			
			result.put("data", "fail");
			
			return result;
		}    	      
    }
    
}