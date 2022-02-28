package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGAttachOptionVO {
	/** 파일첨부여부*/
	private boolean attachFlag;
	/** 문서첨부여부*/
	private boolean docAttachFlag;
	/** 분리첨부 여부*/
	private boolean seperateAttachFlag;
	/** 의견여부*/
	private boolean opinionFlag;
	/** 메인문서아이디*/
	private String mainDocID;
	/** 현재문서아이디*/
	private String currentDocID;
	/** 디렉토리경로*/
	private String dirPath;
	/** 회사아이디 */
	private String companyID;
	/** 테넌트아이디 */
	private int tenantID;
	
	public boolean isAttachFlag() {
		return attachFlag;
	}
	public void setAttachFlag(boolean attachFlag) {
		this.attachFlag = attachFlag;
	}
	public boolean isDocAttachFlag() {
		return docAttachFlag;
	}
	public void setDocAttachFlag(boolean docAttachFlag) {
		this.docAttachFlag = docAttachFlag;
	}
	public boolean isSeperateAttachFlag() {
		return seperateAttachFlag;
	}
	public void setSeperateAttachFlag(boolean seperateAttachFlag) {
		this.seperateAttachFlag = seperateAttachFlag;
	}
	public boolean isOpinionFlag() {
		return opinionFlag;
	}
	public void setOpinionFlag(boolean opinionFlag) {
		this.opinionFlag = opinionFlag;
	}
	public String getMainDocID() {
		return mainDocID;
	}
	public void setMainDocID(String mainDocID) {
		this.mainDocID = mainDocID;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public String getCurrentDocID() {
		return currentDocID;
	}
	public void setCurrentDocID(String currentDocID) {
		this.currentDocID = currentDocID;
	}
	public String getDirPath() {
		return dirPath;
	}
	public void setDirPath(String dirPath) {
		this.dirPath = dirPath;
	}
}
