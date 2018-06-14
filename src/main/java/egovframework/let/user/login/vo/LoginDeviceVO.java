package egovframework.let.user.login.vo;

import org.springframework.stereotype.Component;

@Component
public class LoginDeviceVO {
	
	private String devSeq; /** 기기 등록 순번 */
	
	private String devId; /** 기기 아이디 */
	
	private String devType; /** 기기 구분 (IOS, Android) */
	
	private String subType; /** 기기 OS 버전 */
	
	private String userId; /** 사용자 아이디 */
	
	private String token; /** APNs, GCM에서 발급된 토큰 */
	
	private String badge; /** 배지 넘버 */
	
	private String tenantId; /** 회사 아이디 - tenantId*/ 
	
	private String state; /** 기기 등록 상태 */
	
	private String pushState; /** 푸시 수신 여부 */
	
	private String regDate; /** 최초 등록 일자 : 삭제후 재설치시 기존꺼삭제후 다시 인서트 */
	
	private String isLogin; /** 로그인 여부 */
	
	private String startMenu; /** 시작 메뉴 */
	
	private String loginTime; /** 로그인 한 시간 : 로그인 할 때마다 갱신 */
	
	private String loginLock; /** 로그인 lock 사용 여부 */
	
	private String isPasswordChange; /** 패스워드 변경 여부 */
	
	private String extension1; /** 확장 1 */
	
	private String extension2; /** 확장 2 */

	
	public String getDevSeq() {
		return devSeq;
	}

	public void setDevSeq(String devSeq) {
		this.devSeq = devSeq;
	}

	public String getDevId() {
		return devId;
	}
	
	public void setDevId(String devId) {
		this.devId = devId;
	}

	public String getDevType() {
		return devType;
	}

	public void setDevType(String devType) {
		this.devType = devType;
	}

	public String getSubType() {
		return subType;
	}

	public void setSubType(String subType) {
		this.subType = subType;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getBadge() {
		return badge;
	}

	public void setBadge(String badge) {
		this.badge = badge;
	}

	public String getCompId() {
		return tenantId;
	}

	public void setCompId(String tenantId) {
		this.tenantId = tenantId;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getPushState() {
		return pushState;
	}

	public void setPushState(String pushState) {
		this.pushState = pushState;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getIsLogin() {
		return isLogin;
	}

	public void setIsLogin(String isLogin) {
		this.isLogin = isLogin;
	}

	public String getStartMenu() {
		return startMenu;
	}

	public void setStartMenu(String startMenu) {
		this.startMenu = startMenu;
	}

	public String getLoginTime() {
		return loginTime;
	}

	public void setLoginTime(String loginTime) {
		this.loginTime = loginTime;
	}

	public String getLoginLock() {
		return loginLock;
	}

	public void setLoginLock(String loginLock) {
		this.loginLock = loginLock;
	}

	public String getIsPasswordChange() {
		return isPasswordChange;
	}

	public void setIsPasswordChange(String isPasswordChange) {
		this.isPasswordChange = isPasswordChange;
	}

	public String getExtension1() {
		return extension1;
	}

	public void setExtension1(String extension1) {
		this.extension1 = extension1;
	}

	public String getExtension2() {
		return extension2;
	}

	public void setExtension2(String extension2) {
		this.extension2 = extension2;
	}
	
}
