package egovframework.ezEKP.ezResource.vo;

public class ResGetClsAclListVO {
	/** 기본세팅값(Y)*/
	private String deptYn;
	/** 기본세팅값(Y)*/
	private String sdaYn;
	/** 권한 대상자명*/
	private String memberNam;
	/** 권한 대상자 아이디*/
	private String memberID;
	/** 대상자 구분*/
	private String accessLvl;
	
	public String getDeptYn() {
		return deptYn;
	}
	public void setDeptYn(String deptYn) {
		this.deptYn = deptYn;
	}
	public String getSdaYn() {
		return sdaYn;
	}
	public void setSdaYn(String sdaYn) {
		this.sdaYn = sdaYn;
	}
	public String getMemberNam() {
		return memberNam;
	}
	public void setMemberNam(String memberNam) {
		this.memberNam = memberNam;
	}
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
