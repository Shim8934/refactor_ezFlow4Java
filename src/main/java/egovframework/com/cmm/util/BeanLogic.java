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
			
			filePath = msg.getMessage(filePath, locale);	
			
			msgFilePath = addVer(filePath);
		}
		
		return msgFilePath;
		
		/*String springMessage = "<spring:message";
		int startOfSpringMessage = filePath.indexOf(springMessage);
		
		if (startOfSpringMessage > -1) {
			String code = "code='";
			int startOfCode = filePath.indexOf(code, startOfSpringMessage + springMessage.length());
			
			if (startOfCode > -1) {
				int endOfCode = filePath.indexOf("'", startOfCode + code.length());
				
				if (endOfCode > -1) {
					ServletRequestAttributes attr = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();		
					Locale locale = localeResolver.resolveLocale(attr.getRequest());
					
					String codeValue = filePath.substring(startOfCode + code.length(), endOfCode);					
					String str = msg.getMessage(codeValue, locale);					
					int endOfSpringMessage = filePath.indexOf(">", endOfCode + 1); 
					
					if (endOfSpringMessage > -1) {
						filePath = filePath.substring(0, startOfSpringMessage) + str
									+ filePath.substring(endOfSpringMessage + 1);
					}
				}
			}
		}*/

		/*File fileObj = new File(servletContext.getRealPath(filePath));
		
		if (fileObj.exists()) {
			Date lastDate = new Date(fileObj.lastModified());
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
			String version = sdf.format(lastDate);
			
			filePath += "?v=" + version;
		}
		
		return filePath;*/
	}
	
	/*public static String addVer(ServletContext application, HttpServletRequest request, String filePath) {
		String springMessage = "<spring:message";
		int startOfSpringMessage = filePath.indexOf(springMessage);
		
		if (startOfSpringMessage > -1) {
			String code = "code='";
			int startOfCode = filePath.indexOf(code, startOfSpringMessage + springMessage.length());
			
			if (startOfCode > -1) {
				int endOfCode = filePath.indexOf("'", startOfCode + code.length());
				
				if (endOfCode > -1) {
					String codeValue = filePath.substring(startOfCode + code.length(), endOfCode);					
					String msg = commonUtilInstance.egovMessageSource.getMessage(codeValue, new CookieLocaleResolver().resolveLocale(request));					
					int endOfSpringMessage = filePath.indexOf(">", endOfCode + 1); 
					
					if (endOfSpringMessage > -1) {
						filePath = filePath.substring(0, startOfSpringMessage) + msg
									+ filePath.substring(endOfSpringMessage + 1);
					}
				}
			}
		}
		
		File fileObj = new File(application.getRealPath(filePath));
		
		if (fileObj.exists()) {
			Date lastDate = new Date(fileObj.lastModified());
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String version = sdf.format(lastDate);
			
			filePath += "?v=" + version;
		}
		
		return filePath;
	}*/
}

