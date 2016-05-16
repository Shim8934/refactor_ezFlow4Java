package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGFormVO {
	/** 양식함아이디*/
	private String formContID;
	/** 양식아이디*/
	private String formID;
	/** 양식이름*/
	private String formName;
	/** 양식이름(다국어)*/
	private String formName2;
	/** 양식종류*/
	private String formDocType;
	/** 양식설명*/
	private String formDescription;
	/** 양식파일경로*/
	private String formFileLocation;
	/** 연동양식여부*/
	private String formConnFlag;
	/** 양식순서*/
	private String formOrder;
	
	public String getFormContID() {
		return formContID;
	}
	public void setFormContID(String formContID) {
		this.formContID = formContID;
	}
	public String getFormID() {
		return formID;
	}
	public void setFormID(String formID) {
		this.formID = formID;
	}
	public String getFormName() {
		return formName;
	}
	public void setFormName(String formName) {
		this.formName = formName;
	}
	public String getFormName2() {
		return formName2;
	}
	public void setFormName2(String formName2) {
		this.formName2 = formName2;
	}
	public String getFormDocType() {
		return formDocType;
	}
	public void setFormDocType(String formDocType) {
		this.formDocType = formDocType;
	}
	public String getFormDescription() {
		return formDescription;
	}
	public void setFormDescription(String formDescription) {
		this.formDescription = formDescription;
	}
	public String getFormFileLocation() {
		return formFileLocation;
	}
	public void setFormFileLocation(String formFileLocation) {
		this.formFileLocation = formFileLocation;
	}
	public String getFormConnFlag() {
		return formConnFlag;
	}
	public void setFormConnFlag(String formConnFlag) {
		this.formConnFlag = formConnFlag;
	}
	public String getFormOrder() {
		return formOrder;
	}
	public void setFormOrder(String formOrder) {
		this.formOrder = formOrder;
	}

}
