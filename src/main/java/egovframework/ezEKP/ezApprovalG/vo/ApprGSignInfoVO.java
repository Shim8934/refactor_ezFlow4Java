package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGSignInfoVO {
	/** 사인종류*/
	private String signType;
	/** 사인위치*/
	private String signName;
	/** 사인내용*/
	private String content;
	/** */
	private String aprSN;
	/** 사인자 이름*/
	private String aprMemberName;
	
	public String getSignType() {
		return signType;
	}
	public void setSignType(String signType) {
		this.signType = signType;
	}
	public String getSignName() {
		return signName;
	}
	public void setSignName(String signName) {
		this.signName = signName;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getAprSN() {
		return aprSN;
	}
	public void setAprSN(String aprSN) {
		this.aprSN = aprSN;
	}
	public String getAprMemberName() {
		return aprMemberName;
	}
	public void setAprMemberName(String aprMemberName) {
		this.aprMemberName = aprMemberName;
	}

}
