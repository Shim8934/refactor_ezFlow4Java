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

}
