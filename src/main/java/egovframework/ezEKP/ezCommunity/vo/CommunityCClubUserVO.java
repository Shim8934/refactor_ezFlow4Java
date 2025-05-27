package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCClubUserVO {
	/** 커뮤니티번호*/
	private String c_clubNo;
	/** 사용자아이디*/
	private String c_ID;
	/** 커뮤니티가입일시*/
	private String c_inDate;
	/** 커뮤니티최근접속일시*/
	private String c_lastDate;
	/** 이메일여부*/
	private int c_eMail;
	/** 이동전화여부*/
	private int c_hPhone;
	/** 회사여부*/
	private int c_company;
	/** 집여부*/
	private int c_house;
	/** 직업여부*/
	private int c_job;
	/** 생년월일공개여부*/
	private int c_birth;
	/** 성별여부*/
	private int c_sex;
	/** 접속횟수(1일1회)*/
	private int c_visited;
	/** 자기소개*/
	private String c_intro;
	/** 권한*/
	private String permit;
	/** 사용자회사아이디*/
	private String companyID;
	/** 사용자이름*/
	private String userName;
	/** 사용자이름(다국어)*/
	private String userName2;
	/** 2018-07-02 홍승비 - 회원의 부서ID */
	private String deptID;
	/** 2018-07-02 홍승비 - 회원의 부서이름 */
	private String deptName;
	/** 사용자 회원등급*/
	private String grade;

	public String getC_clubNo() {
		return c_clubNo;
	}
	public void setC_clubNo(String c_clubNo) {
		this.c_clubNo = c_clubNo;
	}
	public String getC_ID() {
		return c_ID;
	}
	public void setC_ID(String c_ID) {
		this.c_ID = c_ID;
	}
	public String getC_inDate() {
		return c_inDate;
	}
	public void setC_inDate(String c_inDate) {
		this.c_inDate = c_inDate;
	}
	public String getC_lastDate() {
		return c_lastDate;
	}
	public void setC_lastDate(String c_lastDate) {
		this.c_lastDate = c_lastDate;
	}
	public int getC_eMail() {
		return c_eMail;
	}
	public void setC_eMail(int c_eMail) {
		this.c_eMail = c_eMail;
	}
	public int getC_hPhone() {
		return c_hPhone;
	}
	public void setC_hPhone(int c_hPhone) {
		this.c_hPhone = c_hPhone;
	}
	public int getC_company() {
		return c_company;
	}
	public void setC_company(int c_company) {
		this.c_company = c_company;
	}
	public int getC_house() {
		return c_house;
	}
	public void setC_house(int c_house) {
		this.c_house = c_house;
	}
	public int getC_job() {
		return c_job;
	}
	public void setC_job(int c_job) {
		this.c_job = c_job;
	}
	public int getC_birth() {
		return c_birth;
	}
	public void setC_birth(int c_birth) {
		this.c_birth = c_birth;
	}
	public int getC_sex() {
		return c_sex;
	}
	public void setC_sex(int c_sex) {
		this.c_sex = c_sex;
	}
	public int getC_visited() {
		return c_visited;
	}
	public void setC_visited(int c_visited) {
		this.c_visited = c_visited;
	}
	public String getC_intro() {
		return c_intro;
	}
	public void setC_intro(String c_intro) {
		this.c_intro = c_intro;
	}
	public String getPermit() {
		return permit;
	}
	public void setPermit(String permit) {
		this.permit = permit;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserName2() {
		return userName2;
	}
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
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
	
	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

}
