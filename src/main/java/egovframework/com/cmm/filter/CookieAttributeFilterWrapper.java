package egovframework.com.cmm.filter;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

import org.springframework.http.HttpHeaders;

public class CookieAttributeFilterWrapper extends HttpServletResponseWrapper{

	private static final Logger logger = LoggerFactory.getLogger(CookieAttributeFilterWrapper.class);

	private boolean isSecure = false;
	
	public CookieAttributeFilterWrapper(ServletResponse response) {
		super((HttpServletResponse) response);
	}
	
	@Override
	public PrintWriter getWriter() {
		try {
			setSameSite();
			return super.getWriter();
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
		}
		return null;
	}
	
	@Override
	public void sendRedirect(String location) {
		try {
			setSameSite();
			super.sendRedirect(location);
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
		}
	}

	@Override
	public void setStatus(int sc) {
		super.setStatus(sc);
		setSameSite();
	}
	
	@Override
    public void sendError(int sc, String msg) throws IOException {
        super.sendError(sc, msg);
        setSameSite();
    }
    
	@Override
    public void sendError(int sc) throws IOException {
        super.sendError(sc);
        setSameSite();
    }
	
	private void setSameSite() {
		if (!isSecure) { return; }
		
		Collection<String> headers = getHeaders(HttpHeaders.SET_COOKIE);
       
        boolean firstHeader = true;
        for (String header : headers) {
    		if (firstHeader) {
    			setHeader(HttpHeaders.SET_COOKIE, String.format("%s; Secure; SameSite=None", header)); 
				firstHeader = false;
				continue;
			}
    	   
			addHeader(HttpHeaders.SET_COOKIE, String.format("%s; Secure; SameSite=None", header)); 
        }
	}
	
	public void setIsSecure(String scheme) {
		isSecure = "https".equalsIgnoreCase(scheme) ? true : false;
	}
}
