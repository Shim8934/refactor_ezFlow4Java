package egovframework.ezMobile.ezOrgan.vo;

public class MOrganListVO {
	/** 하위 부서여부 */
	private String isLast;
	/** 부서아이디 */
	private String deptID;
	/** 부서명 */
	private String deptName;
	/** 회사,부서 여부 */
	private String deptType;
	/** 확장된여부 */
	private String expand;
	/** 상위부서아이디 */
	private String highDeptID;
	/** 유저명 */
	private String userName;
	/** 유저아이디 */
	private String userID;
	/** 유저 직급 */
	private String title;
	/** 테넌트아이디 */
	private int tenant_ID;
	/** 유저사진경로 */
	private String imageName;
	/** 유저 메일 */
	private String mail;
	/** 유저 타입 */
	private String type;
	/** 모바일 전화번호 */
	private String mobile;
	/** 집 전화번호 */
	private String telephoneNumber;
	/** 직위 아이디*/
	private String jobId;
	/** 유저 회사아이디 */
	private String userCompanyID;
	/** 부서명1 */
	private String deptName1;
	/** 부서명2 */
	private String deptName2;
	/** 유저명1 */
	private String userName1;
	/** 유저명2 */
	private String userName2;
	/** 유저 직급1 */
	private String title1;
	/** 유저 직급2 */
	private String title2;

	public String getIsLast() {
		return isLast;
	}

	public void setIsLast(String isLast) {
		this.isLast = isLast;
	}

	public String getDeptID() {
		return deptID;
	}

	public void setDeptID(String deptID) {
		this.deptID = deptID;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getDeptType() {
		return deptType;
	}

	public void setDeptType(String deptType) {
		this.deptType = deptType;
	}

	public String getExpand() {
		return expand;
	}

	public void setExpand(String expand) {
		this.expand = expand;
	}

	public String getHighDeptID() {
		return highDeptID;
	}

	public void setHighDeptID(String highDeptID) {
		this.highDeptID = highDeptID;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getTenant_ID() {
		return tenant_ID;
	}

	public void setTenant_ID(int tenant_ID) {
		this.tenant_ID = tenant_ID;
	}

	public String getImageName() {
		return "/fileroot/" + tenant_ID + "/files/upload_personal/photo/" + imageName;
	}

	public void setImageName(String imageName) {
		this.imageName = imageName;
	}

	public String getMail() {
		return mail;
	}

	public void setMail(String mail) {
		this.mail = mail;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getTelephoneNumber() {
		return telephoneNumber;
	}

	public void setTelephoneNumber(String telephoneNumber) {
		this.telephoneNumber = telephoneNumber;
	}

	public String getJobId() {
		return jobId;
	}

	public void setJobId(String jobId) {
		this.jobId = jobId;
	}

	public String getUserCompanyID() { return userCompanyID; }

	public void setUserCompanyID(String userCompanyID) { this.userCompanyID = userCompanyID; }

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

	public String getUserName1() {
		return userName1;
	}

	public void setUserName1(String userName1) {
		this.userName1 = userName1;
	}

	public String getUserName2() {
		return userName2;
	}

	public void setUserName2(String userName2) {
		this.userName2 = userName2;
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
}
