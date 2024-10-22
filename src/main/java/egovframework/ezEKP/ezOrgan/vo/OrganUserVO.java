package egovframework.ezEKP.ezOrgan.vo;

public class OrganUserVO {
	/** 사용자 부모 ID */
	private String parentCn;
	/** 사용자 ID */
	private String cn;
	/** 사용자 Pass */
	private String password;
	/** 회사 부서명 */
	private String department;
	/** 부서명 */
	private String displayName;
	/** 부서명(다국어) */
	private String displayName1;
	/** 부서명(다국어) */
	private String displayName2;
	/** 메일주소 */
	private String mail;
	/** 메일닉네임 */
	private String mailNickName;
	/** */
	private String upnName;
	/** */
	private String description;
	/** */
	private String description1;
	/** */
	private String description2;
	/** */
	private String physicalDeliveryOfficeName;
	/** */
	private String company;
	/** */
	private String company1;
	/** */
	private String company2;
	/** */
	private String title;
	/** */
	private String title1;
	/** */
	private String title2;
	/** 직책명*/
	private String role;
	
	private String role1;
	
	private String role2;
	/** 직책코드*/
	private String roleId;
	/** */
	private String telephoneNumber;
	/** */
	private String homePhone;
	/** */
	private String mobile;
	/** */
	private String facsimileTelephoneNumber;
	/** */
	private String streetAddress;
	/** */
	private String postalCode;
	/** */
	private String info;
	/** 상위부서ID */
	private String extensionAttribute1;
	/** 회사ID */
	private String extensionAttribute2;
	/** 회사명 */
	private String extensionAttribute3;
	/** 문서과ID */
	private String extensionAttribute4;
	/** 발신명의 */
	private String extensionAttribute5;
	/** 부서약어 */
	private String extensionAttribute6;
	/** 관인경로 */
	private String extensionAttribute7;
	/** 기관여부 */
	private String extensionAttribute8;
	/** 부서장ID */
	private String extensionAttribute9;
	/** DocSymBol */
	private String extensionAttribute10;
	/** */
	private String extensionAttribute11;
	/** */
	private String extensionAttribute12;
	/** */
	private String extensionAttribute13;
	/** */
	private String extensionAttribute14;
	/** 정렬순서값 */
	private String extensionAttribute15;
	/** */
	private String extensionAttribute101;
	/** */
	private String extensionAttribute102;
	/** LDAP 경로 */
	private String adsPath;
	/** 최종업데이트일자 */
	private String updateDT;
	/** */
	private String displayNamePrintable;
	/** */
	private String type;
	/** */
	private String sipUri;
	/** */
	private String positionCD;
	/** */
	private String birth;
	/** */
	private String birthType;
	/** 현재 시간 */
	private String nowDate;
	/** 사용자가 속한 Tenant의 고유 ID */
	private int tenantId = -1;
	/** 겸직사원 구분(addjob or user) */
	private String userType;
	/** 수동으로 추가한 사원 구분(Y/N) */
	private String manualFlag;
	
	/** 메일박스 사용용량 */
	private String mailboxUsage;
	/** 메일박스 총용량 */
	private String mailboxQuota;
	/** 직위 */
	private String jobID;
	/** 후리가나 */
	private String furigana;
	/** 내선번호 */
	private String extensionPhone;
	/** 회사전화 */
	private String officeMobile;
	/** 회사 ID */
	private String companyId;

	/** 프로필사진 날짜를 업데이트할 것 인지 flag */
	private boolean doUpdatePhoto;

	/** 겸직 부서명*/
	private String addJobDeptNM;

	/** 겸직 직위*/
	private String addJobTitle;

	/** 겸직 최상위 부서명*/
	private String physicalDeliveryOfficeName1;

	/** 겸직 타입*/
	private String jobType;

	/** 권한 */
	private String roleInfo;

	/** 관리자 권한 객체 */
	private OrganAuth auth;

	/** 조직도 사용 여부*/
	private String userTreeFlag;

	/** 퇴직자 여부 */
	private int isRetire;

	public String getUserTreeFlag() {
		return userTreeFlag;
	}

	public void setUserTreeFlag(String userTreeFlag) {
		this.userTreeFlag = userTreeFlag;
	}

	public String getAddJobTitle() {
		return addJobTitle;
	}

	public void setAddJobTitle(String addJobTitle) {
		this.addJobTitle = addJobTitle;
	}

	public String getAddJobDeptNM() {
		return addJobDeptNM;
	}

	public void setAddJobDeptNM(String addJobDeptNM) {
		this.addJobDeptNM = addJobDeptNM;
	}

	public String getJobID() {
		return jobID;
	}

	public void setJobID(String jobID) {
		this.jobID = jobID;
	}

	public String getMailboxUsage() {
		return mailboxUsage;
	}

	public void setMailboxUsage(String mailboxUsage) {
		this.mailboxUsage = mailboxUsage;
	}

	public String getMailboxQuota() {
		return mailboxQuota;
	}

	public void setMailboxQuota(String mailboxQuota) {
		this.mailboxQuota = mailboxQuota;
	}

	public String getCn() {
		return cn;
	}

	public void setCn(String cn) {
		this.cn = cn;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
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

	public String getMail() {
		return mail;
	}

	public void setMail(String mail) {
		this.mail = mail;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription1() {
		return description1;
	}

	public void setDescription1(String description1) {
		this.description1 = description1;
	}

	public String getDescription2() {
		return description2;
	}

	public void setDescription2(String description2) {
		this.description2 = description2;
	}

	public String getPhysicalDeliveryOfficeName() {
		return physicalDeliveryOfficeName;
	}

	public void setPhysicalDeliveryOfficeName(String physicalDeliveryOfficeName) {
		this.physicalDeliveryOfficeName = physicalDeliveryOfficeName;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public String getCompany1() {
		return company1;
	}

	public void setCompany1(String company1) {
		this.company1 = company1;
	}

	public String getCompany2() {
		return company2;
	}

	public void setCompany2(String company2) {
		this.company2 = company2;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
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

	public String getTelephoneNumber() {
		return telephoneNumber;
	}

	public void setTelephoneNumber(String telephoneNumber) {
		this.telephoneNumber = telephoneNumber;
	}

	public String getHomePhone() {
		return homePhone;
	}

	public void setHomePhone(String homePhone) {
		this.homePhone = homePhone;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getFacsimileTelephoneNumber() {
		return facsimileTelephoneNumber;
	}

	public void setFacsimileTelephoneNumber(String facsimileTelephoneNumber) {
		this.facsimileTelephoneNumber = facsimileTelephoneNumber;
	}

	public String getStreetAddress() {
		return streetAddress;
	}

	public void setStreetAddress(String streetAddress) {
		this.streetAddress = streetAddress;
	}

	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	public String getExtensionAttribute1() {
		return extensionAttribute1;
	}

	public void setExtensionAttribute1(String extensionAttribute1) {
		this.extensionAttribute1 = extensionAttribute1;
	}

	public String getExtensionAttribute2() {
		return extensionAttribute2;
	}

	public void setExtensionAttribute2(String extensionAttribute2) {
		this.extensionAttribute2 = extensionAttribute2;
	}

	public String getExtensionAttribute3() {
		return extensionAttribute3;
	}

	public void setExtensionAttribute3(String extensionAttribute3) {
		this.extensionAttribute3 = extensionAttribute3;
	}

	public String getExtensionAttribute4() {
		return extensionAttribute4;
	}

	public void setExtensionAttribute4(String extensionAttribute4) {
		this.extensionAttribute4 = extensionAttribute4;
	}

	public String getExtensionAttribute5() {
		return extensionAttribute5;
	}

	public void setExtensionAttribute5(String extensionAttribute5) {
		this.extensionAttribute5 = extensionAttribute5;
	}

	public String getExtensionAttribute6() {
		return extensionAttribute6;
	}

	public void setExtensionAttribute6(String extensionAttribute6) {
		this.extensionAttribute6 = extensionAttribute6;
	}

	public String getExtensionAttribute7() {
		return extensionAttribute7;
	}

	public void setExtensionAttribute7(String extensionAttribute7) {
		this.extensionAttribute7 = extensionAttribute7;
	}

	public String getExtensionAttribute8() {
		return extensionAttribute8;
	}

	public void setExtensionAttribute8(String extensionAttribute8) {
		this.extensionAttribute8 = extensionAttribute8;
	}

	public String getExtensionAttribute9() {
		return extensionAttribute9;
	}

	public void setExtensionAttribute9(String extensionAttribute9) {
		this.extensionAttribute9 = extensionAttribute9;
	}

	public String getExtensionAttribute10() {
		return extensionAttribute10;
	}

	public void setExtensionAttribute10(String extensionAttribute10) {
		this.extensionAttribute10 = extensionAttribute10;
	}

	public String getExtensionAttribute11() {
		return extensionAttribute11;
	}

	public void setExtensionAttribute11(String extensionAttribute11) {
		this.extensionAttribute11 = extensionAttribute11;
	}

	public String getExtensionAttribute12() {
		return extensionAttribute12;
	}

	public void setExtensionAttribute12(String extensionAttribute12) {
		this.extensionAttribute12 = extensionAttribute12;
	}

	public String getExtensionAttribute13() {
		return extensionAttribute13;
	}

	public void setExtensionAttribute13(String extensionAttribute13) {
		this.extensionAttribute13 = extensionAttribute13;
	}

	public String getExtensionAttribute14() {
		return extensionAttribute14;
	}

	public void setExtensionAttribute14(String extensionAttribute14) {
		this.extensionAttribute14 = extensionAttribute14;
	}

	public String getExtensionAttribute15() {
		return extensionAttribute15;
	}

	public void setExtensionAttribute15(String extensionAttribute15) {
		this.extensionAttribute15 = extensionAttribute15;
	}

	public String getAdsPath() {
		return adsPath;
	}

	public void setAdsPath(String adsPath) {
		this.adsPath = adsPath;
	}

	public String getUpdateDT() {
		return updateDT;
	}

	public void setUpdateDT(String updateDT) {
		this.updateDT = updateDT;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getSipUri() {
		return sipUri;
	}

	public void setSipUri(String sipUri) {
		this.sipUri = sipUri;
	}

	public String getPositionCD() {
		return positionCD;
	}

	public void setPositionCD(String positionCD) {
		this.positionCD = positionCD;
	}

	public String getMailNickName() {
		return mailNickName;
	}

	public void setMailNickName(String mailNickName) {
		this.mailNickName = mailNickName;
	}

	public String getUpnName() {
		return upnName;
	}

	public void setUpnName(String upnName) {
		this.upnName = upnName;
	}

	public String getPostalCode() {
		return postalCode;
	}

	public void setPostalCode(String postalCode) {
		this.postalCode = postalCode;
	}

	public String getExtensionAttribute101() {
		return extensionAttribute101;
	}

	public void setExtensionAttribute101(String extensionAttribute101) {
		this.extensionAttribute101 = extensionAttribute101;
	}

	public String getExtensionAttribute102() {
		return extensionAttribute102;
	}

	public void setExtensionAttribute102(String extensionAttribute102) {
		this.extensionAttribute102 = extensionAttribute102;
	}

	public String getDisplayNamePrintable() {
		return displayNamePrintable;
	}

	public void setDisplayNamePrintable(String displayNamePrintable) {
		this.displayNamePrintable = displayNamePrintable;
	}

	public String getBirth() {
		return birth;
	}

	public void setBirth(String birth) {
		this.birth = birth;
	}

	public String getBirthType() {
		return birthType;
	}

	public void setBirthType(String birthType) {
		this.birthType = birthType;
	}

	public String getParentCn() {
		return parentCn;
	}

	public void setParentCn(String parentCn) {
		this.parentCn = parentCn;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	public String getNowDate() {
		return nowDate;
	}

	public void setNowDate(String nowDate) {
		this.nowDate = nowDate;
	}
	
	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}
	
	public String getManualFlag() {
		return manualFlag;
	}

	public void setManualFlag(String manualFlag) {
		this.manualFlag = manualFlag;
	}
	
	public String getFurigana() {
		return furigana;
	}

	public void setFurigana(String furigana) {
		this.furigana = furigana;
	}

	public String getExtensionPhone() {
		return extensionPhone;
	}

	public void setExtensionPhone(String extensionPhone) {
		this.extensionPhone = extensionPhone;
	}

	public String getOfficeMobile() {
		return officeMobile;
	}

	public void setOfficeMobile(String officeMobile) {
		this.officeMobile = officeMobile;
	}

	public boolean getDoUpdatePhoto() {
		return doUpdatePhoto;
	}

	public void setDoUpdatePhoto(boolean doUpdatePhoto) {
		this.doUpdatePhoto = doUpdatePhoto;
	}

	public String getCompanyId() { return companyId; }

	public void setCompanyId(String companyId) {
		this.companyId = companyId;

	}
	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getRole1() {
		return role1;
	}

	public void setRole1(String role1) {
		this.role1 = role1;
	}
	
	public String getRole2() {
		return role2;
	}

	public void setRole2(String role2) {
		this.role2 = role2;
	}

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}

	public String getPhysicalDeliveryOfficeName1() {return physicalDeliveryOfficeName1; }

	public void setPhysicalDeliveryOfficeName1(String physicalDeliveryOfficeName1) {this.physicalDeliveryOfficeName1 = physicalDeliveryOfficeName1; }

	public String getJobType() {
		return jobType;
	}

	public void setJobType(String jobType) {
		this.jobType = jobType;
	}

	public String getRoleInfo() {
		return roleInfo;
	}

	public void setRoleInfo(String roleInfo) {
		this.roleInfo = roleInfo;
	}

	public OrganAuth getAuth() {
		return auth;
	}

	public void setAuth(OrganAuth auth) {
		this.auth = auth;
	}

	public int getIsRetire() {
		return isRetire;
	}

	public void setIsRetire(int isRetire) {
		this.isRetire = isRetire;
	}
}
