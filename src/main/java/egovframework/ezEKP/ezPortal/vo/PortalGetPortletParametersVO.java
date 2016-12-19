package egovframework.ezEKP.ezPortal.vo;

public class PortalGetPortletParametersVO {
	/** */
	private String uID_;
	/** */
	private String paramName;
	/** */
	private String paramValue;
	/** */
	private int paramType;
	/** */
	private String paramInfo;
	/** */
	private String description;
	
	public String getuID_() {
		return uID_;
	}
	public void setuID_(String uID_) {
		this.uID_ = uID_;
	}
	public String getParamName() {
		return paramName;
	}
	public void setParamName(String paramName) {
		this.paramName = paramName;
	}
	public String getParamValue() {
		return paramValue;
	}
	public void setParamValue(String paramValue) {
		this.paramValue = paramValue;
	}
	public int getParamType() {
		return paramType;
	}
	public void setParamType(int paramType) {
		this.paramType = paramType;
	}
	public String getParamInfo() {
		return paramInfo;
	}
	public void setParamInfo(String paramInfo) {
		this.paramInfo = paramInfo;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
}
