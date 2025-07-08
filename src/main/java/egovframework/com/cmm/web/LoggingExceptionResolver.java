package egovframework.com.cmm.web;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoggingExceptionResolver extends SimpleMappingExceptionResolver {
	
	private static final Logger logger = LogManager.getLogger(LoggingExceptionResolver.class);
	
	@Override
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex){
		logger.error(ex.getMessage(), ex);
		return super.doResolveException(request, response, handler, ex);
	}
}