package egovframework.ezMobile.ezSurvey.vo;

import java.io.Serializable;

public class MSimpleUserVO implements Serializable {
	private static final long serialVersionUID = 180L;
	private String userId;
	private String userName;
	private String userName1;
	private String userName2;
	private String deptId;
	private String deptName;
	private String deptName1;
	private String deptName2;
	private String position;
	private String telNumber;
	private String mail;
	private String userImg;
	private int    userType;
	
	public MSimpleUserVO() {
		
	}
	
	public MSimpleUserVO(MSurveyParticipantVO participant) {
		this.userId = participant.getUserId();
		this.deptId = participant.getDeptId();
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public String getUserName() {
		return userName;
	}
	
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getDeptId() {
		return deptId;
	}
	
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	
	public String getDeptName() {
		return deptName;
	}
	
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	
	public String getPosition() {
		return position;
	}
	
	public void setPosition(String position) {
		this.position = position;
	}
	
	public String getTelNumber() {
		return telNumber;
	}
	
	public void setTelNumber(String telNumber) {
		this.telNumber = telNumber;
	}
	
	public String getMail() {
		return mail;
	}
	
	public void setMail(String mail) {
		this.mail = mail;
	}
	
	public String getUserImg() {
		return userImg;
	}
	
	public void setUserImg(String userImg) {
		this.userImg = userImg;
	}
	
	public int getUserType() {
		return userType;
	}
	
	public void setUserType(int userType) {
		this.userType = userType;
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
	
	public boolean equals(Object object) {
		if (object instanceof MSimpleUserVO) {
			MSimpleUserVO obj = (MSimpleUserVO) object;
			return userId.equals(obj.userId) && deptId.equals(obj.deptId);
		}
		else {
			return false;
		}
	}
	
	public int hashCode() {
		return 100 + userId.hashCode() + deptId.hashCode();
	}
}
