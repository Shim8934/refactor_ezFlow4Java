package egovframework.ezEKP.ezPortal.vo;

public class PortalGetPortletParametersVO {
	/** */
	private String uID_;
	/** */
	private String paramName;
	/** */
	private String paramValue;
	/** */
	private String paramType;
	/** */
	private String paramInfo;
	/** */
	private String description;
	
	public String getuID() {
		return uID_;
	}
	public void setuID(String uID) {
		this.uID_ = uID;
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
	public String getParamType() {
		return paramType;
	}
	public void setParamType(String paramType) {
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
