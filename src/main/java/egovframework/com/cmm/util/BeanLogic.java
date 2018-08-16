package egovframework.com.cmm.util;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.LocaleResolver;

import egovframework.com.cmm.EgovMessageSource;

/**
 * JSP에서 java bean을 호출 가능한 class
 * @author 솔루션2팀 장진혁
 * @since 2018.08.14
 * @version 1.0
 * @see
 */

@Component("beanLogic")
public class BeanLogic {
	
	@Autowired 
	private ServletContext servletContext;
	
	@Autowired
    private LocaleResolver localeResolver;
	
	@Autowired
	private EgovMessageSource msg;
	
	public String addVer(String filePath) {
		File fileObj = new File(servletContext.getRealPath(filePath));
		
		if (fileObj.exists()) {
			Date lastDate = new Date(fileObj.lastModified());
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String version = sdf.format(lastDate);
			
			filePath += "?v=" + version;
		}
		
		return filePath;
	}
	
	public String addVer(String filePath, String type) {
		String msgFilePath = "";
	
		if (type.equals("msg")) {
			ServletRequestAttributes attr = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();		
			Locale locale = localeResolver.resolveLocale(attr.getRequest());
			
			filePath = msg.getMessage(filePath, locale).trim();	
			
			msgFilePath = addVer(filePath);
		}
		
		return msgFilePath;
	}	
}

