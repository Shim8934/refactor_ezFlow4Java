package egovframework.com.cmm.interceptor;

import java.util.Optional;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;
import org.springframework.web.util.WebUtils;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

public class UserEmailInterceptor extends WebContentInterceptor {

	@Autowired
	private CommonUtil commonUtil;

	@Resource(name = "loginService")
	private LoginService loginService;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Autowired
	private EzEmailService ezEmailService;

	/** Logger */
	private static final Logger LOGGER = LoggerFactory.getLogger(UserEmailInterceptor.class);

	private static final String EMAIL_ALIAS_PAGE = "/user/login/email.do";

	/**
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
		try {
			String serverName = request.getServerName();
			int tenantId = loginService.getTenantId(serverName);
			String useMailAliasSettingOnLogin = ezCommonService.getTenantConfig("useMailAliasSettingOnLogin", tenantId);

			if (!"YES".equals(useMailAliasSettingOnLogin)) {
				return true;
			}

			LoginVO loginVO = Optional
					.ofNullable(WebUtils.getCookie(request, "loginCookie"))
					.map(Cookie::getValue)
					.map(commonUtil::userInfo)
					.orElse(null);

			if (loginVO == null) {
				return true;
			}

			String requestUri = request.getRequestURI();
			String userId = loginVO.getId();
			String userPrimaryEmail = loginVO.getEmail();
			String userFriendlyEmailAddress = ezCommonService.getUserConfigInfo(tenantId, userId, "userFriendlyEmailAddress");
			boolean isPrimaryDifferentFromCn = !userPrimaryEmail.startsWith(userId + "@");
			boolean hasFriendlyPrimary = !userFriendlyEmailAddress.trim().isEmpty();
			boolean isEmailPage = requestUri.startsWith(EMAIL_ALIAS_PAGE);

			if (hasFriendlyPrimary) {
				if (isEmailPage) {
					response.sendRedirect("/ezNewPortal/newPortalMain.do");
					return false;
				}
			} else {
				if (isPrimaryDifferentFromCn) {
					String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
					String userEmail = new StringBuilder(userId).append("@").append(domainName).toString();
					ezEmailService.updatePrimaryIndividualAlias(userEmail, "", userPrimaryEmail, tenantId);
					LOGGER.debug("auto alias apply. userEmail: {}, aliasEmail: {}", userEmail, userPrimaryEmail);
				} else if (!isEmailPage) {
					response.sendRedirect(EMAIL_ALIAS_PAGE);
					return false;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
	}
}