package egovframework.ezEKP.ezEmail.util;

import org.springframework.stereotype.Component;

@Component
public class EzEmailUtil {

	public String getSizeWithUnit(double size) {
		String strSize;
		
		if (size > 1024 * 1024) {
			size = size / 1024.0 / 1024.0;
			strSize = String.format("%.1fMB", size);
		} else if (size > 1024) {
			size = size / 1024.0;
			strSize = String.format("%dKB", (int)size);
		} else {
			strSize = size + "B";
		}

		return strSize;
	}
	
}


