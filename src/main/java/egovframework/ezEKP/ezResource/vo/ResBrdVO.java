package egovframework.ezEKP.ezResource.vo;

public class ResBrdVO {
	/** 게시판ID*/
	private String brdID;
	/** 게시판명*/
	private String brdNm;
	/** 영문 게시판명*/
	private String brdNm2;
	/** 게시판 설명*/
	private String brdExplain;
	/** 담당 부서ID*/
	private String ownDeptID;
	/** 담당 부서명*/
	private String ownDeptNm;
	/** 영문 담당 부서명*/
	private String ownDeptNm2;
	/** 담당자 ID*/
	private String ownerID;
	/** 담당자명*/
	private String ownerNm;
	/** 영문 담당자명*/
	private String ownerNm2;
	/** 담당자 직위*/
	private String ownerPosition;
	/** 영문 담당자 직위*/
	private String ownerPosition2;
	/** 담당자 연락처*/
	private String ownerCall;
	/** 자원위치*/
	private String resLocation;
	/** 생성일*/
	private String makeDate;
	/** 사용 허가 유무*/
	private String approveFlag;
	/** 반납 절차*/
	private String returnFlag;
	/** 게시판 접근 거부 메시지*/
	private String brdAccess;
	/** 자원관리 포틀릿 시간*/
	private String rsPortletTime;
	/** 자원관리 포틀릿 번호*/
	private String rsPortletNum;
	/** 자원관리 포틀릿 소유자*/
	private String rsPortletOwnName;
	/** 자원관리 포틀릿 소유자부서*/
	private String rsPortletDeptName;
	/** 반복예약허용 유무*/
	private String repeatFlag;
	/** 자원관리 자원예약 제목 */
	private String rsPortletTitle;
	/** 자원관리 종료날짜 */
	private String rsPortletStratAllTime;
	/** 자원관리 시작날짜 */
	private String rsPortletEndAllTime;
	
	public String getRsPortletTime() {
		return rsPortletTime;
	}
	public void setRsPortletTime(String rsPortletTime) {
		this.rsPortletTime = rsPortletTime;
	}
	public String getRsPortletNum() {
		return rsPortletNum;
	}
	public void setRsPortletNum(String rsPortletNum) {
		this.rsPortletNum = rsPortletNum;
	}
	public String getRsPortletOwnName() {
		return rsPortletOwnName;
	}
	public void setRsPortletOwnName(String rsPortletOwnName) {
		this.rsPortletOwnName = rsPortletOwnName;
	}
	public String getRsPortletDeptName() {
		return rsPortletDeptName;
	}
	public void setRsPortletDeptName(String rsPortletDeptName) {
		this.rsPortletDeptName = rsPortletDeptName;
	}
	public String getBrdID() {
		return brdID;
	}
	public void setBrdID(String brdID) {
		this.brdID = brdID;
	}
	public String getBrdNm() {
		return brdNm;
	}
	public void setBrdNm(String brdNm) {
		this.brdNm = brdNm;
	}
	public String getBrdNm2() {
		return brdNm2;
	}
	public void setBrdNm2(String brdNm2) {
		this.brdNm2 = brdNm2;
	}
	public String getBrdExplain() {
		return brdExplain;
	}
	public void setBrdExplain(String brdExplain) {
		this.brdExplain = brdExplain;
	}
	public String getOwnDeptID() {
		return ownDeptID;
	}
	public void setOwnDeptID(String ownDeptID) {
		this.ownDeptID = ownDeptID;
	}
	public String getOwnDeptNm() {
		return ownDeptNm;
	}
	public void setOwnDeptNm(String ownDeptNm) {
		this.ownDeptNm = ownDeptNm;
	}
	public String getOwnDeptNm2() {
		return ownDeptNm2;
	}
	public void setOwnDeptNm2(String ownDeptNm2) {
		this.ownDeptNm2 = ownDeptNm2;
	}
	public String getOwnerID() {
		return ownerID;
	}
	public void setOwnerID(String ownerID) {
		this.ownerID = ownerID;
	}
	public String getOwnerNm() {
		return ownerNm;
	}
	public void setOwnerNm(String ownerNm) {
		this.ownerNm = ownerNm;
	}
	public String getOwnerNm2() {
		return ownerNm2;
	}
	public void setOwnerNm2(String ownerNm2) {
		this.ownerNm2 = ownerNm2;
	}
	public String getOwnerPosition() {
		return ownerPosition;
	}
	public void setOwnerPosition(String ownerPosition) {
		this.ownerPosition = ownerPosition;
	}
	public String getOwnerPosition2() {
		return ownerPosition2;
	}
	public void setOwnerPosition2(String ownerPosition2) {
		this.ownerPosition2 = ownerPosition2;
	}
	public String getOwnerCall() {
		return ownerCall;
	}
	public void setOwnerCall(String ownerCall) {
		this.ownerCall = ownerCall;
	}
	public String getResLocation() {
		return resLocation;
	}
	public void setResLocation(String resLocation) {
		this.resLocation = resLocation;
	}
	public String getMakeDate() {
		return makeDate;
	}
	public void setMakeDate(String makeDate) {
		this.makeDate = makeDate;
	}
	public String getApproveFlag() {
		return approveFlag;
	}
	public void setApproveFlag(String approveFlag) {
		this.approveFlag = approveFlag;
	}
	public String getReturnFlag() {
		return returnFlag;
	}
	public void setReturnFlag(String returnFlag) {
		this.returnFlag = returnFlag;
	}
	public String getBrdAccess() {
		return brdAccess;
	}
	public void setBrdAccess(String brdAccess) {
		this.brdAccess = brdAccess;
	}
	public String getRepeatFlag() { return repeatFlag; }
	public void setRepeatFlag(String repeatFlag) { this.repeatFlag = repeatFlag; }
	public String getRsPortletTitle() { return rsPortletTitle; }
	public void setRsPortletTitle(String rsPortletTitle) { this.rsPortletTitle = rsPortletTitle; }
	public String getRsPortletStratAllTime() { return rsPortletStratAllTime; }
	public void setRsPortletStratAllTime(String rsPortletStratAllTime) { this.rsPortletStratAllTime = rsPortletStratAllTime; }
	public String getRsPortletEndAllTime() { return rsPortletEndAllTime; }
	public void setRsPortletEndAllTime(String rsPortletEndAllTime) { this.rsPortletEndAllTime = rsPortletEndAllTime; }
}
