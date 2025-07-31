package egovframework.com.cmm.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;


public class CookieAttributeFilter implements Filter{

	private static final Logger logger = LoggerFactory.getLogger(CookieAttributeFilter.class);
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
	}
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		
		String scheme = request.getScheme();
		
		CookieAttributeFilterWrapper rsw = new CookieAttributeFilterWrapper(response);
		rsw.setIsSecure(scheme);
		
		if (request instanceof HttpServletRequest) {
			if (((HttpServletRequest)request).getRequestURI().endsWith(".jsp")) {
				logger.debug("jsp request={}", ((HttpServletRequest)request).getRequestURI());
				
				response.getWriter().println("direct jsp request not allowed.");
				return;
			}
		}
		
		chain.doFilter(request, rsw);
	}
}

