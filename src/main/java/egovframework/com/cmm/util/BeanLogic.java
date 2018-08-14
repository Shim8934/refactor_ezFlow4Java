package egovframework.com.cmm.util;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


@Component("beanLogic")
public class BeanLogic {
	
	@Autowired 
	private ServletContext servletContext;
	
	public String addVer(String filePath) {
		File fileObj = new File(servletContext.getRealPath(filePath));
		
		if (fileObj.exists()) {
			Date lastDate = new Date(fileObj.lastModified());
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
			String version = sdf.format(lastDate);
			
			filePath += "?v=" + version;
		}
		
		return filePath;
	}
}

