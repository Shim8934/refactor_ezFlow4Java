package egovframework.ezEKP.ezQuestion.vo;

public class QstResponsePersonVO {
	/** 게시판아이디(설문:5)*/
	int brdID;
	/** 설문아이디*/
	int itemNo;
	/** 대상자아이디*/
	String userID;
	/** 응답일시*/
	String responseDate; 
	/** 대상자이름*/
	String userNm;
	/** 대상자이름(다국어)*/
	String userNm2;
	/** 대상자이메일*/
	String userEmail;
	/** 대상자부서아이디*/
	String userDeptID;
	/** 대상자부서이름*/
	String userDeptNm;
	/** 대상자부서이름(다국어)*/
	String userDeptNm2;
	/** 대상자직위*/
	String userPos;
	/** 대상자직위(다국어)*/
	String userPos2;
	/** 직급(사용안함)*/
	String Jikgub;
	/** 직급(사용안함)(다국어)*/
	String Jikgub2;
	/** 성별*/
	String gender;
	/** 대상자나이*/
	int userAge;
	/** (사용안함)*/
	String groupID;
	/** (사용안함)*/
	String groupName;
	
	public int getBrdID() {
		return brdID;
	}
	public void setBrdID(int brdID) {
		this.brdID = brdID;
	}
	public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getResponseDate() {
		return responseDate;
	}
	public void setResponseDate(String responseDate) {
		this.responseDate = responseDate;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getUserNm2() {
		return userNm2;
	}
	public void setUserNm2(String userNm2) {
		this.userNm2 = userNm2;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getUserDeptID() {
		return userDeptID;
	}
	public void setUserDeptID(String userDeptID) {
		this.userDeptID = userDeptID;
	}
	public String getUserDeptNm() {
		return userDeptNm;
	}
	public void setUserDeptNm(String userDeptNm) {
		this.userDeptNm = userDeptNm;
	}
	public String getUserDeptNm2() {
		return userDeptNm2;
	}
	public void setUserDeptNm2(String userDeptNm2) {
		this.userDeptNm2 = userDeptNm2;
	}
	public String getUserPos() {
		return userPos;
	}
	public void setUserPos(String userPos) {
		this.userPos = userPos;
	}
	public String getUserPos2() {
		return userPos2;
	}
	public void setUserPos2(String userPos2) {
		this.userPos2 = userPos2;
	}
	public String getJikgub() {
		return Jikgub;
	}
	public void setJikgub(String jikgub) {
		Jikgub = jikgub;
	}
	public String getJikgub2() {
		return Jikgub2;
	}
	public void setJikgub2(String jikgub2) {
		Jikgub2 = jikgub2;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public int getUserAge() {
		return userAge;
	}
	public void setUserAge(int userAge) {
		this.userAge = userAge;
	}
	public String getGroupID() {
		return groupID;
	}
	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}
	public String getGroupName() {
		return groupName;
	}
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	
}
