package egovframework.ezEKP.ezResource.vo;

public class ResGetAdmSubClsTreeVO {
	/** 자원 번호*/
	private int brdId;
	/** 자원 이름*/
	private String brdNm;
	/** 자원 번호 2*/
	private String brdNm2;
	/** 자원 레벨*/
	private int brdLevel;
	/** 자원 순서*/
	private int brdStep;
	/** 자원 만료기간*/
	private int brdPostterm;
	/** 상위 자원 ID*/
	private int brdUpper;
	/** 게시구분*/
	private String brdGb;
	/** 연결URL*/
	private String brdUrl;
	/** 자원 설명*/
	private String brdExplain;
	/** 접근 거부 메시지*/
	private String brdAccess;
	/** 첨부 제한 크기*/
	private int attachSize;
	/** 하위 Cls수*/
	private int subClsCnt;
	/** 게시판 리소스 수*/
	private int subResCnt;
	/** 게시판 접근 권한*/
	private int accessLvl;
	/** 사용허가유무*/
	private String approveFlag;
	
	public int getAccessLvl() {
		return accessLvl;
	}
	public void setAccessLvl(int accessLvl) {
		this.accessLvl = accessLvl;
	}
	public int getBrdId() {
		return brdId;
	}
	public void setBrdId(int brdId) {
		this.brdId = brdId;
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
	public int getBrdPostterm() {
		return brdPostterm;
	}
	public void setBrdPostterm(int brdPostterm) {
		this.brdPostterm = brdPostterm;
	}
	public int getBrdUpper() {
		return brdUpper;
	}
	public void setBrdUpper(int brdUpper) {
		this.brdUpper = brdUpper;
	}
	public String getBrdGb() {
		return brdGb;
	}
	public void setBrdGb(String brdGb) {
		this.brdGb = brdGb;
	}
	public String getBrdUrl() {
		return brdUrl;
	}
	public void setBrdUrl(String brdUrl) {
		this.brdUrl = brdUrl;
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
	public int getAttachSize() {
		return attachSize;
	}
	public void setAttachSize(int attachSize) {
		this.attachSize = attachSize;
	}
	public int getSubClsCnt() {
		return subClsCnt;
	}
	public void setSubClsCnt(int subClsCnt) {
		this.subClsCnt = subClsCnt;
	}
	public int getSubResCnt() {
		return subResCnt;
	}
	public void setSubResCnt(int subResCnt) {
		this.subResCnt = subResCnt;
	}
	public String getApproveFlag() {
		return approveFlag;
	}
	public void setApproveFlag(String approveFlag) {
		this.approveFlag = approveFlag;
	}
}
