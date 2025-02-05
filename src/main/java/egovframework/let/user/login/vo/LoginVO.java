package egovframework.let.user.login.vo;

import java.io.Serializable;
import java.util.Date;
import java.util.Locale;

/**
 * @Class Name : LoginVO.java
 * @Description : Login VO class
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
public class LoginVO implements Serializable {	

	private static final long serialVersionUID = -8274004534207618049L;
		
	/** 이름 */
	private String name;
	/** 주민등록번호 */
	private String ihidNum;
	/** 이메일주소 */
	private String email;
	/** 비밀번호 */
	private String password;
	/** 비밀번호 힌트 */
	private String passwordHint;
	/** 비밀번호 정답 */
	private String passwordCnsr;
	/** otp */
	private String otp;
	/** fidoSessionId */
	private String fidoSessionId;
	/** 사용자구분 */
	private String userSe;
	/** 조직(부서)ID */
	private String orgnztId;
	/** 조직(부서)명 */
	private String orgnztNm;
	/** 고유아이디 */
	private String uniqId;
	/** 로그인 후 이동할 페이지 */
	private String url;	
	/** GPKI인증 DN */
	private String dn;	
	
	/** ezEKP4Java 변수들 */	
	/** 사용자 ID */
	private String id;
	/** 사용자 IP정보 */
	private String ip;
	/** 사용자 이름 */
	private String displayName;
	/** 사용자 이름1 */
	private String displayName1;
	/** 사용자 이름2 */
	private String displayName2;
	/** 사용자 부서ID */
	private String deptID;
	/** 사용자 부서이름 */
	private String deptName;
	/** 사용자 부서이름1 */
	private String deptName1;
	/** 사용자 부서이름2 */
	private String deptName2;
	/** 사용자 직급 */
	private String title;
	/** 사용자 직급1 */
	private String title1;
	/** 사용자 직급2 */
	private String title2;
	/** 사용자 회사ID */
	private String companyID;
	/** 사용자 회사이름 */
	private String companyName;
	/** 사용자 회사이름1 */
	private String companyName1;
	/** 사용자 회사이름2 */
	private String companyName2;
	/** 사용자 접속 브라우저 */
	private String browser;
	/** 사용자 사용 OS */
	private String os;
	/** 사용자 접속 AGENT 정보 */
	private String agent;
	/** 사용자 접속 상태(성공: Y, 실패: N) */
	private String status;
	/** 사용자 접속 session id */
	private String sessionCode;
	/** RSA 암호화 ID 변수 */
	private String encryptID;
	/** RSA 암호화 password 변수 */
	private String encryptPass;
	/** RSA 암호화 OTP 변수 */
	private String encryptOTP;
	/** 마지막 개인정보 수정 일자 */
	private Date updateDT; 
	/** 조직도 DeptPath*/
	private String deptPathCode;
	/** 유저권한*/
	private String rollInfo;
	/** 언어*/
	private String primary;
	/** 다국어*/
	private String lang;
	/** 핸드폰번호*/
	private String phone;
	/** 직책(extensionattribute10)*/
	private String jikChek;
    /** 직책(extensionattribute102)*/
    private String jikChek2;	
	/** 표준시간대*/
	private String offset;
	/** 다국어설정*/
	private Locale locale;
	/** rootPage*/
	private boolean rootPage;
	/** 유저테마*/
	private String theme;
	/** 유저스킨번호*/
	private String skinNum;
	/** 유저 tableViewOption*/
	private String tableViewOption;
	/** 마지막 접속시간*/
	private String lastLogin;
	/** 로그인 횟수*/
	private int loginCnt;
    /** 사용자가 속한 Tenant의 고유 ID */
    private int tenantId = -1;    
    /** 사용자가 접속한 서버의 이름(80 포트가 아닌 경우엔 포트번호도 포함) */
    private String serverName;
    /** 겸직 정보*/
    private String gyumJik;
    /** 사용자 사진파일경로 */
    private String userFileUrl;
    /** 리얼패스*/
    private String realPath;
    /** 사용자사번*/
    private String sabun;
    /** 마지막 비밀번호 변경 날짜*/
    private Date password_updatedt;    
    /** 휴대전화번호 */
    private String mobile;
    /** 부재정보 */
    private String extensionattribute5;
	/** 직위 ID */
	private String jobId;
	/** 직책 ID */
	private String roleId;
    
	// 생성자 대신 활용도 높게 setter로 정의함.
	public void setForSelectUser(String id, String dn, int tenantId) {
		this.id = id;
		this.dn = dn;
		this.tenantId = tenantId;
	}
	public void setForInsertLog(String ip, String agent, String os, String browser, int tenantId, String status) {
		if (ip != null) this.ip = ip;
		this.agent = agent;
		this.os = os;
		this.browser = browser;
		this.tenantId = tenantId;
		this.status = status;
		if (title2 == null) this.title2 = "";
	}
	// 오버로딩 시에는 파라메터가 적은 쪽에서 → 많은 쪽을 호출하도록 한다. 코드가 더러워지지 않고, 확장성과 활용도를 위함.
	public void setForInsertLog(String agent, String os, String browser, int tenantId, String status) {
		setForInsertLog(null, agent, os, browser, tenantId, status);
	}

	public String getFidoSessionId() {
		return fidoSessionId;
	}
	public void setFidoSessionId(String fidoSessionId) {
		this.fidoSessionId = fidoSessionId;
	}
	public String getOtp() {
		return otp;
	}
	public void setOtp(String otp) {
		this.otp = otp;
	}
	public String getEncryptOTP() {
		return encryptOTP;
	}
	public void setEncryptOTP(String encrypOTP) {
		this.encryptOTP = encrypOTP;
	}

	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getIhidNum() {
		return ihidNum;
	}	
	public void setIhidNum(String ihidNum) {
		this.ihidNum = ihidNum;
	}	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}	
	public String getPassword() {
		return password;
	}	
	public void setPassword(String password) {
		this.password = password;
	}	
	public String getPasswordHint() {
		return passwordHint;
	}	
	public void setPasswordHint(String passwordHint) {
		this.passwordHint = passwordHint;
	}	
	public String getPasswordCnsr() {
		return passwordCnsr;
	}	
	public void setPasswordCnsr(String passwordCnsr) {
		this.passwordCnsr = passwordCnsr;
	}	
	public String getUserSe() {
		return userSe;
	}	
	public void setUserSe(String userSe) {
		this.userSe = userSe;
	}	
	public String getOrgnztId() {
		return orgnztId;
	}	
	public void setOrgnztId(String orgnztId) {
		this.orgnztId = orgnztId;
	}	
	public String getUniqId() {
		return uniqId;
	}	
	public void setUniqId(String uniqId) {
		this.uniqId = uniqId;
	}	
	public String getUrl() {
		return url;
	}	
	public void setUrl(String url) {
		this.url = url;
	}	
	public String getIp() {
		return ip;
	}	
	public void setIp(String ip) {
		this.ip = ip;
	}	
	public String getDn() {
		return dn;
	}	
	public void setDn(String dn) {
		this.dn = dn;
	}	
	public String getDisplayName() {
		return displayName != null ? displayName : displayName1;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getOrgnztNm() {
		return orgnztNm;
	}	
	public void setOrgnztNm(String orgnztNm) {
		this.orgnztNm = orgnztNm;
	}
	public String getEncryptID() {
		return encryptID;
	}
	public void setEncryptID(String encryptID) {
		this.encryptID = encryptID;
	}
	public String getEncryptPass() {
		return encryptPass;
	}
	public void setEncryptPass(String encryptPass) {
		this.encryptPass = encryptPass;
	}
	public Date getUpdateDT() {
		return updateDT;
	}
	public void setUpdateDT(Date updateDT) {
		this.updateDT = updateDT;
	}
	public String getDisplayName1() {
		return displayName1;
	}
	public void setDisplayName1(String displayName1) {
		this.displayName1 = displayName1;
	}
	public String getDisplayName2() {
		return displayName2;
	}
	public void setDisplayName2(String displayName2) {
		this.displayName2 = displayName2;
	}
	public String getDeptID() {
		return deptID;
	}
	public void setDeptID(String deptID) {
		this.deptID = deptID;
	}
	public String getDeptName1() {
		return deptName1;
	}
	public void setDeptName1(String deptName1) {
		this.deptName1 = deptName1;
	}
	public String getDeptName2() {
		return deptName2;
	}
	public void setDeptName2(String deptName2) {
		this.deptName2 = deptName2;
	}
	public String getTitle1() {
		return title1;
	}
	public void setTitle1(String title1) {
		this.title1 = title1;
	}
	public String getTitle2() {
		return title2;
	}
	public void setTitle2(String title2) {
		this.title2 = title2;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getCompanyName1() {
		return companyName1;
	}
	public void setCompanyName1(String companyName1) {
		this.companyName1 = companyName1;
	}
	public String getCompanyName2() {
		return companyName2;
	}
	public void setCompanyName2(String companyName2) {
		this.companyName2 = companyName2;
	}
	public String getBrowser() {
		return browser;
	}
	public void setBrowser(String browser) {
		this.browser = browser;
	}
	public String getOs() {
		return os;
	}
	public void setOs(String os) {
		this.os = os;
	}
	public String getAgent() {
		return agent;
	}
	public void setAgent(String agent) {
		this.agent = agent;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getSessionCode() {
		return sessionCode;
	}
	public void setSessionCode(String sessionCode) {
		this.sessionCode = sessionCode;
	}
	public String getDeptPathCode() {
		return deptPathCode;
	}
	public void setDeptPathCode(String deptPathCode) {
		this.deptPathCode = deptPathCode;
	}
	public String getRollInfo() {
		return rollInfo == null ? "" : rollInfo;
	}
	public void setRollInfo(String rollInfo) {
		this.rollInfo = rollInfo;
	}
	public String getPrimary() {
		return primary;
	}
	public void setPrimary(String primary) {
		this.primary = primary;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getJikChek() {
		return jikChek;
	}
	public void setJikChek(String jikChek) {
		this.jikChek = jikChek;
	}
	public String getJikChek2() {
        return jikChek2;
    }
    public void setJikChek2(String jikChek2) {
        this.jikChek2 = jikChek2;
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
	public boolean isRootPage() {
		return rootPage;
	}
	public void setRootPage(boolean rootPage) {
		this.rootPage = rootPage;
	}
	public String getTheme() {
		return theme;
	}
	public void setTheme(String theme) {
		this.theme = theme;
	}
	public String getSkinNum() {
		return skinNum;
	}
	public void setSkinNum(String skinNum) {
		this.skinNum = skinNum;
	}
	public String getTableViewOption() {
		return tableViewOption;
	}
	public void setTableViewOption(String tableViewOption) {
		this.tableViewOption = tableViewOption;
	}	
    public int getTenantId() {
        return tenantId;
    }    
    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }    
    public String getServerName() {
        return serverName;
    }    
    public void setServerName(String serverName) {
        this.serverName = serverName;
    }    
	public String getLastLogin() {
		return lastLogin;
	}	
	public void setLastLogin(String lastLogin) {
		this.lastLogin = lastLogin;
	}
	public int getLoginCnt() {
		return loginCnt;
	}	
	public void setLoginCnt(int loginCnt) {
		this.loginCnt = loginCnt;
	}	
	public String getGyumJik() {
		return gyumJik;
	}	
	public void setGyumJik(String gyumJik) {
		this.gyumJik = gyumJik;
	}	

	public String getUserFileUrl() {
		return userFileUrl;
	}	
	public void setUserFileUrl(String userFileUrl) {
		this.userFileUrl = userFileUrl;
	}
	
	public boolean equals(Object object) {
		if (object instanceof LoginVO) {
			LoginVO obj = (LoginVO) object;
			return id.equals(obj.id) && tenantId == obj.tenantId;
		}
		else {
			return false;
		}
	}
	
	public int hashCode() {
		// id가 null인 경우 NullPointerException이 발생해 null check 추가함
		return (id != null ? id.hashCode() : super.hashCode()) + tenantId;
	}

	public String getRealPath() {
		return realPath;
	}
	public void setRealPath(String realPath) {
		this.realPath = realPath;
	}
	public String getSabun() {
		return sabun;
	}
	public void setSabun(String sabun) {
		this.sabun = sabun;
	}
	public Date getPassword_updatedt() {
		return password_updatedt;
	}
	public void setPassword_updatedt(Date password_updatedt) {
		this.password_updatedt = password_updatedt;
	}
	public String getExtensionattribute5() {
		return extensionattribute5;
	}
	public void setExtensionattribute5(String extensionattribute5) {
		this.extensionattribute5 = extensionattribute5;
	}
	public String getJobId() {
		return jobId;
	}
	public void setJobId(String jobId) {
		this.jobId = jobId;
	}

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
}
