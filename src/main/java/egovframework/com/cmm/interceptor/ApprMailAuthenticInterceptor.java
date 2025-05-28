package egovframework.com.cmm.interceptor;

import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;
import org.springframework.web.util.WebUtils;

import javax.annotation.Resource;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Properties;

public class ApprMailAuthenticInterceptor extends WebContentInterceptor {
	
	/** CRYPTO */
    @Resource(name="crypto")
    private EgovFileScrty egovFileScrty;

	@Autowired
	private CommonUtil commonUtil;
			
    @Autowired
	private Properties config;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(ApprMailAuthenticInterceptor.class);

	/**
	 * 승인메일
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
		try {
			Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
			if (loginCookie == null) { return false; }
			
			boolean isAdminPage = request.getRequestURI().contains("/admin/ezEmail/appr/");

			// 승인자 리스트 출력 및 검색은 일반사용자와 관리자가 같은 url을 호출하기 때문에 관리자 체크 대상에서 제외한다.
			boolean isExcludeCheckAdmin = request.getRequestURI().contains("/getApproverList.do")
					|| request.getRequestURI().contains("/getApproverSearchList.do");

			boolean returnValue = true;
			String errPage = "";
		
			String decryptedLoginCookie = commonUtil.getDecryptedLoginCookie(loginCookie.getValue());
			String[] cookieInfo = decryptedLoginCookie.split("///");

			int tenantID = Integer.parseInt(cookieInfo[8]);

			if (!commonUtil.checkTenantConfigBool(tenantID, "useApprMail", "false")) {
				returnValue = false;
			} else if (isAdminPage && commonUtil.checkAdmin(loginCookie.getValue()) == null && !isExcludeCheckAdmin) {
				returnValue = false;
				errPage = "/admin/adminDenied.do"; 
			}

			if (!returnValue && StringUtils.isNotEmpty(errPage)) {
				RequestDispatcher dispatcher = request.getRequestDispatcher(errPage);
				dispatcher.forward(request, response);
			}
			
			return returnValue;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return false;
		}
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
	}
}
