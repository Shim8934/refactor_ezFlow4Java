package egovframework.let.user.login.vo;

public class SessionVO {

	/** 세션ID */
	private String ezSessionId;
	/** 로그인쿠키 */
	private String loginCookie;
	/** 생성 시간 */
	private String creationTime;
	/** 마지막 접속 시간 */
	private String lastAccessTime;
	/** 세션 유지 시간 */
	private int maxInactiveInterval;
	/** 세션 유효 시간 */
	private int timeDiff;
	/** 테넌트ID*/
	private int tenantId;

	// Getter & Setter
	public String getEzSessionId() {
		return ezSessionId;
	}

	public void setEzSessionId(String ezSessionId) {
		this.ezSessionId = ezSessionId;
	}

	public String getLoginCookie() {
		return loginCookie;
	}

	public void setLoginCookie(String loginCookie) {
		this.loginCookie = loginCookie;
	}

	public String getCreationTime() {
		return creationTime;
	}

	public void setCreationTime(String creationTime) {
		this.creationTime = creationTime;
	}

	public String getLastAccessTime() {
		return lastAccessTime;
	}

	public void setLastAccessTime(String lastAccessTime) {
		this.lastAccessTime = lastAccessTime;
	}

	public int getMaxInactiveInterval() {
		return maxInactiveInterval;
	}

	public void setMaxInactiveInterval(int maxInactiveInterval) {
		this.maxInactiveInterval = maxInactiveInterval;
	}

	public int getTimeDiff() {
		return timeDiff;
	}

	public void setTimeDiff(int timeDiff) {
		this.timeDiff = timeDiff;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
}
