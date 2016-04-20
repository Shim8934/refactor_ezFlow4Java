package egovframework.ezEKP.ezCommunity.vo;

public class CommunityLeftCommunityVO {
	/** 커뮤니티ID*/
	String cClubNo;
	/** 권한*/
	String permit;
	/** 접속횟수(1일1회)*/
	int cVisited;
	/** 커뮤니티 이름*/
	String cClubName;
	/** 커뮤니티 이름(다국어)*/
	String cClubName2;
	/** 커뮤니티 회원 수 */
	int cMemberCnt;
	/** 커뮤니티 마스터 ID*/
	String cSysopID;
	/** 커뮤니티 공개 여부*/
	String cClubGubun;
	/** 마스터 커뮤니티 승인여부*/
	String cClubConfirmType;
	/** 커뮤니티 홈 로고 (썸네일용)*/
	String cLogoThumbnail;
	public String getcClubNo() {
		return cClubNo;
	}
	public void setcClubNo(String cClubNo) {
		this.cClubNo = cClubNo;
	}
	public String getPermit() {
		return permit;
	}
	public void setPermit(String permit) {
		this.permit = permit;
	}
	public int getcVisited() {
		return cVisited;
	}
	public void setcVisited(int cVisited) {
		this.cVisited = cVisited;
	}
	public String getcClubName() {
		return cClubName;
	}
	public void setcClubName(String cClubName) {
		this.cClubName = cClubName;
	}
	public String getcClubName2() {
		return cClubName2;
	}
	public void setcClubName2(String cClubName2) {
		this.cClubName2 = cClubName2;
	}
	public int getcMemberCnt() {
		return cMemberCnt;
	}
	public void setcMemberCnt(int cMemberCnt) {
		this.cMemberCnt = cMemberCnt;
	}
	public String getcSysopID() {
		return cSysopID;
	}
	public void setcSysopID(String cSysopID) {
		this.cSysopID = cSysopID;
	}
	public String getcClubGubun() {
		return cClubGubun;
	}
	public void setcClubGubun(String cClubGubun) {
		this.cClubGubun = cClubGubun;
	}
	public String getcClubConfirmType() {
		return cClubConfirmType;
	}
	public void setcClubConfirmType(String cClubConfirmType) {
		this.cClubConfirmType = cClubConfirmType;
	}
	public String getcLogoThumbnail() {
		return cLogoThumbnail;
	}
	public void setcLogoThumbnail(String cLogoThumbnail) {
		this.cLogoThumbnail = cLogoThumbnail;
	}
	
}
