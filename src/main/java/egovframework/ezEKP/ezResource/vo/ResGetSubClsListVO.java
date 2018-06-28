package egovframework.ezEKP.ezResource.vo;

public class ResGetSubClsListVO {
	/** 게시판ID*/
	private int brdID;
	/** 회사ID*/
	private String brdCompany;
	/** 게시판명*/
	private String brdNm;
	/** 게시판명(다국어)*/
	private String brdNm2;
	/** 게시그룹*/
	private String brdGroup;
	/** 게시구분*/
	private String brdGb;
	/** 최상위게시판ID*/
	private int brdRef;
	/** 관련 게시판의 계층 레벨*/
	private int brdLevel;
	/** 관련 게시판 내 순서*/
	private int brdStep;
	/** 게시 만료 기간*/
	private int brdPostTerm;
	/** 게시판 설명*/
	private String brdExplain;
	/** 게시판 접근 거부 메시지*/
	private String brdAccess;
	/** 상위 게시판 ID*/
	private int brdUpper;
	/** 게시판 수*/
	private int brdCount;
	/** 게시판 연결 URL*/
	private String brdURL;
	/** 첨부 제한 크기*/
	private int attachSize;
	/** 게시물 답변 시 메일 발송 허용 여부*/
	private int replyMailFg;
	/** 담당부서ID*/
	private String ownDeptID;
	/** 담당부서명*/
	private String ownDeptNm;
	/** 담당부서명(다국어)*/
	private String ownDeptNm2;
	/** 담당자ID*/
	private String ownerID;
	/** 담당자명*/
	private String ownerNm;
	/** 담당자명(다국어)*/
	private String ownerNm2;
	/** 담당자직위*/
	private String ownerPosition;
	/** 담당자직위(다국어)*/
	private String ownerPosition2;
	/** 담당자연락처*/
	private String ownerCall;
	/** 생성일*/
	private String makeDate;
	/** 자원위치*/
	private String resLocation;
	/** 사용안함*/
	private String brdUpper2;
	/** 사용허가유무*/
	private String approveFlag;
	
	public int getBrdID() {
		return brdID;
	}
	public void setBrdID(int brdID) {
		this.brdID = brdID;
	}
	public String getBrdCompany() {
		return brdCompany;
	}
	public void setBrdCompany(String brdCompany) {
		this.brdCompany = brdCompany;
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
	public String getBrdGroup() {
		return brdGroup;
	}
	public void setBrdGroup(String brdGroup) {
		this.brdGroup = brdGroup;
	}
	public String getBrdGb() {
		return brdGb;
	}
	public void setBrdGb(String brdGb) {
		this.brdGb = brdGb;
	}
	public int getBrdRef() {
		return brdRef;
	}
	public void setBrdRef(int brdRef) {
		this.brdRef = brdRef;
	}
	public int getBrdLevel() {
		return brdLevel;
	}
	public void setBrdLevel(int brdLevel) {
		this.brdLevel = brdLevel;
	}
	public int getBrdStep() {
		return brdStep;
	}
	public void setBrdStep(int brdStep) {
		this.brdStep = brdStep;
	}
	public int getbrdPostTerm() {
		return brdPostTerm;
	}
	public void setbrdPostTerm(int brdPostTerm) {
		this.brdPostTerm = brdPostTerm;
	}
	public String getBrdExplain() {
		return brdExplain;
	}
	public void setBrdExplain(String brdExplain) {
		this.brdExplain = brdExplain;
	}
	public String getBrdAccess() {
		return brdAccess;
	}
	public void setBrdAccess(String brdAccess) {
		this.brdAccess = brdAccess;
	}
	public int getBrdUpper() {
		return brdUpper;
	}
	public void setBrdUpper(int brdUpper) {
		this.brdUpper = brdUpper;
	}
	public int getBrdCount() {
		return brdCount;
	}
	public void setBrdCount(int brdCount) {
		this.brdCount = brdCount;
	}
	public String getBrdURL() {
		return brdURL;
	}
	public void setBrdURL(String brdURL) {
		this.brdURL = brdURL;
	}
	public int getAttachSize() {
		return attachSize;
	}
	public void setAttachSize(int attachSize) {
		this.attachSize = attachSize;
	}
	public int getReplyMailFg() {
		return replyMailFg;
	}
	public void setReplyMailFg(int replyMailFg) {
		this.replyMailFg = replyMailFg;
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
	public String getMakeDate() {
		return makeDate;
	}
	public void setMakeDate(String makeDate) {
		this.makeDate = makeDate;
	}
	public String getResLocation() {
		return resLocation;
	}
	public void setResLocation(String resLocation) {
		this.resLocation = resLocation;
	}
	public String getBrdUpper2() {
		return brdUpper2;
	}
	public void setBrdUpper2(String brdUpper2) {
		this.brdUpper2 = brdUpper2;
	}
	public String getApproveFlag() {
		return approveFlag;
	}
	public void setApproveFlag(String approveFlag) {
		this.approveFlag = approveFlag;
	}
}
