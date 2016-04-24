package egovframework.ezEKP.ezEmail.util;

import org.springframework.stereotype.Component;

/** 
 * @Description [Utility] 메일 관련 유틸리티
 * @author 오픈솔루션팀 이동호
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.22    이동호    신규작성
 *
 * @see
 */

@Component
public class EzEmailUtil {

	/**
	 * returns a string containing size with a size unit(MB or KB or B) 
	 */
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


