package egovframework.let.user.login.vo;

import java.io.Serializable;
import java.util.Locale;

/**
 * @Class Name : LoginSimpleVO.java
 * @Description : LoginSimple VO class
 * @Modification Information
 * @
 * @  수정일         수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2009.03.03    박지욱          최초 생성
 *
 *  @author 공통서비스 개발팀 박지욱
 *  @since 2009.03.03
 *  @version 1.0
 *  @see
 *  
 */
/**
 * @author YOON
 *
 */
public class LoginSimpleVO implements Serializable{	

	private static final long serialVersionUID = -8274004534207618049L;
		
	/** 사용자 아이디 */
	private String id;
	/** 테넌트 아이디 */
	private int tenantId;
	/** 사용언어 */
	private String lang;
	/** 국가 */
	private Locale locale;
	/** offset 시간 */
	private String offset;
	/** 서버네임 */
	private String serverName;
	
	

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}	
	public Locale getLocale() {
		return locale;
	}
	public void setLocale(Locale locale) {
		this.locale = locale;
	}
	public String getOffset() {
		return offset;
	}
	public void setOffset(String offset) {
		this.offset = offset;
	}
	public String getServerName() {
		return serverName;
	}
	public void setServerName(String serverName) {
		this.serverName = serverName;
	}
	
}
