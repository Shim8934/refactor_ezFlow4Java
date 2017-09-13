package egovframework.ezMobile.ezOrgan.vo;

public class MOrganListVO {
	/** 하위 부서여부*/
	private String isLast;
	/** 부서아이디*/
	private String deptID;
	/** 부서명*/
	private String deptName;
	/** 회사,부서 여부*/
	private String deptType;
	/** 확장된여부*/
	private String expand;
	/** 상위부서아이디*/
	private String highDeptID;
	/** 유저명*/
	private String userName;
	/** 유저아이디*/
	private String userID;
	/** 유저 직급*/
	private String title;
	/** 테넌트아이디*/
	private int tenant_ID;
	/** 유저사진경로*/
	private String imageName; 
	
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
}
