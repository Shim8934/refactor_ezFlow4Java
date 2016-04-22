package egovframework.ezEKP.ezCommunity.vo;

public class CommunityLeftCommunityVO {
	/** 커뮤니티ID*/
	String c_ClubNo;
	/** 권한*/
	String permit;
	/** 접속횟수(1일1회)*/
	int c_Visited;
	/** 커뮤니티 이름*/
	String c_ClubName;
	/** 커뮤니티 이름(다국어)*/
	String c_ClubName2;
	/** 커뮤니티 회원 수 */
	int c_MemberCnt;
	/** 커뮤니티 마스터 ID*/
	String c_SysopID;
	/** 커뮤니티 공개 여부*/
	String c_ClubGubun;
	/** 마스터 커뮤니티 승인여부*/
	String c_ClubConfirmType;
	/** 커뮤니티 홈 로고 (썸네일용)*/
	String c_Logo_Thumbnail;
	public String getC_ClubNo() {
		return c_ClubNo;
	}
	public void setC_ClubNo(String c_ClubNo) {
		this.c_ClubNo = c_ClubNo;
	}
	public String getPermit() {
		return permit;
	}
	public void setPermit(String permit) {
		this.permit = permit;
	}
	public int getC_Visited() {
		return c_Visited;
	}
	public void setC_Visited(int c_Visited) {
		this.c_Visited = c_Visited;
	}
	public String getC_ClubName() {
		return c_ClubName;
	}
	public void setC_ClubName(String c_ClubName) {
		this.c_ClubName = c_ClubName;
	}
	public String getC_ClubName2() {
		return c_ClubName2;
	}
	public void setC_ClubName2(String c_ClubName2) {
		this.c_ClubName2 = c_ClubName2;
	}
	public int getC_MemberCnt() {
		return c_MemberCnt;
	}
	public void setC_MemberCnt(int c_MemberCnt) {
		this.c_MemberCnt = c_MemberCnt;
	}
	public String getC_SysopID() {
		return c_SysopID;
	}
	public void setC_SysopID(String c_SysopID) {
		this.c_SysopID = c_SysopID;
	}
	public String getC_ClubGubun() {
		return c_ClubGubun;
	}
	public void setC_ClubGubun(String c_ClubGubun) {
		this.c_ClubGubun = c_ClubGubun;
	}
	public String getC_ClubConfirmType() {
		return c_ClubConfirmType;
	}
	public void setC_ClubConfirmType(String c_ClubConfirmType) {
		this.c_ClubConfirmType = c_ClubConfirmType;
	}
	public String getC_Logo_Thumbnail() {
		return c_Logo_Thumbnail;
	}
	public void setC_Logo_Thumbnail(String c_Logo_Thumbnail) {
		this.c_Logo_Thumbnail = c_Logo_Thumbnail;
	}
	
}
