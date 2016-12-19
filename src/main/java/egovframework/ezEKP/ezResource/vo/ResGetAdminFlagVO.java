package egovframework.ezEKP.ezResource.vo;

public class ResGetAdminFlagVO {
	/** 회원 아이디*/
	private String memberID;
	/** 접근 권한*/
	private String accessLvl;
	
	public String getMemberID() {
		return memberID;
	}
	public void setMemberID(String memberID) {
		this.memberID = memberID;
	}
	public String getAccessLvl() {
		return accessLvl;
	}
	public void setAccessLvl(String accessLvl) {
		this.accessLvl = accessLvl;
	}
}
