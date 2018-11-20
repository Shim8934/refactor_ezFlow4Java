package egovframework.com.cmm.interceptor;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

public class WebfolderAuthenticInterceptor extends WebContentInterceptor {
	
	/** CRYPTO */
    @Resource(name="crypto")
    private EgovFileScrty egovFileScrty;
    
    @Autowired
    private CommonUtil commonUtil;
    
    @Autowired
	private Properties config;
    
    @Autowired
    private EzWebFolderService_y webfolder;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(WebfolderAuthenticInterceptor.class);

	/**
	 * config.mobileClientServerURL과 request의 ip 비교 체크
	 */
	@SuppressWarnings("finally")
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
		String ip = ClientUtil.getClientIP(request);
		String mobileClientServerURL = config.getProperty("config.mobileClientServerURL");
		
		
		// request가 String으로 온다고 가정했을때 
		// 위와같이 가정을 한다면 request에 id:pw 이런식으로 들어오게 될것 
		// 그렇게 되면 :로 끊어서 처리해야함
		// 그렇게 처리하면 지금 jsonObject로 해놓은 것들을 다시 처리해야함 ( loginAPI ) 
		
		// request가 JsonObject로 온다고 가정한다면 request로 오는것을 처리해야함
		// 어떻게 하면 request에서 json을 뽑아낼수 있을지 찾아내야함
		// 위와같이 하게 되면 바꿀내용은 없고 추가할 내용만 존재하게 됨
		
		logger.debug("ip=" + ip + ",mobileClientServerURL=" + mobileClientServerURL);
	
		if (ip.equals("127.0.0.1")) {			
			return true;
		} else if (mobileClientServerURL != null){			
			if (mobileClientServerURL.contains(ip)) {				
				return true;
			} else {
				boolean result = false; 
				
				try {
					JSONObject requestObject = new JSONObject();
					String key = request.getHeader("key");
					JSONParser parser = new JSONParser();
					requestObject = (JSONObject)parser.parse(key);
					
					String userId = requestObject.get("userid") != null ? (String)requestObject.get("userid") : "";
					String token = requestObject.get("token") != null ? (String)requestObject.get("token") : "";
					int tenantId = 0;
					
					int count = webfolder.existsTokenCheck(userId, token, tenantId);
					
					if (count > 0) {
						result =  true;
					} else {
						try (PrintWriter writer = response.getWriter();) {
							JSONObject obj = new JSONObject();
							obj.put("status", "auth-fail");
							writer.println(obj.toString());
							response.setContentType("application/json;charset=utf-8");
						} catch (IOException e1) {
							e1.printStackTrace();
						}
					}
				} catch (Exception e) {
					try (PrintWriter writer = response.getWriter();) {
						JSONObject obj = new JSONObject();
						obj.put("status", "error");
						writer.println(obj.toString());
						response.setContentType("application/json;charset=utf-8");
					} catch (IOException e1) {
						e1.printStackTrace();
					}
				}
				
				return result;
			}
		} else {			
			return false;
		}
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
	}
}
