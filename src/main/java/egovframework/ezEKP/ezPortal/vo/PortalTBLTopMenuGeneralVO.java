package egovframework.ezEKP.ezPortal.vo;

public class PortalTBLTopMenuGeneralVO {
	/** 아이디*/
	private String uID;
	/** 부모 아이디*/
	private String parentUID;
	/** 깊이*/
	private int depth;
	/** 이름*/
	private String displayName;
	/** 이름(다국어)*/
	private String displayName2;
	/** 생성자 아이디*/
	private String creatorID;
	/** 생성자 이름*/
	private String createDate;
	/** 생성일*/
	private String modifyDate;
	/** 수정일*/
	private int width;
	/** 가로 길이*/
	private int height;
	/** 세로 길이*/
	private int rowLength;
	/** Row 길이*/
	private int columnLength;
	/** Column 길이*/
	private String rowSplit;
	/** Row 분리값*/
	private String columnSplit;
	/** 사용 플래그*/
	private String useFlag;
	/** 회사 아이디*/
	private String companyID;
	/** 언어값*/
	private String lang;
	/** 상단 메뉴 아이디*/
	private String topMnID;
	/** 기본 타입*/
	private String baseType;
	/** 테마 아이디*/
	private String themeUID;
	
	public String getuID() {
		return uID;
	}
	public void setuID(String uID) {
		this.uID = uID;
	}
	public String getParentUID() {
		return parentUID;
	}
	public void setParentUID(String parentUID) {
		this.parentUID = parentUID;
	}
	public int getDepth() {
		return depth;
	}
	public void setDepth(int depth) {
		this.depth = depth;
	}
	public String getDisplayName() {
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	public String getDisplayName2() {
		return displayName2;
	}
	public void setDisplayName2(String displayName2) {
		this.displayName2 = displayName2;
	}
	public String getCreatorID() {
		return creatorID;
	}
	public void setCreatorID(String creatorID) {
		this.creatorID = creatorID;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getModifyDate() {
		return modifyDate;
	}
	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}
	public int getWidth() {
		return width;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public int getHeight() {
		return height;
	}
	public void setHeight(int height) {
		this.height = height;
	}
	public int getRowLength() {
		return rowLength;
	}
	public void setRowLength(int rowLength) {
		this.rowLength = rowLength;
	}
	public int getColumnLength() {
		return columnLength;
	}
	public void setColumnLength(int columnLength) {
		this.columnLength = columnLength;
	}
	public String getRowSplit() {
		return rowSplit;
	}
	public void setRowSplit(String rowSplit) {
		this.rowSplit = rowSplit;
	}
	public String getColumnSplit() {
		return columnSplit;
	}
	public void setColumnSplit(String columnSplit) {
		this.columnSplit = columnSplit;
	}
	public String getUseFlag() {
		return useFlag;
	}
	public void setUseFlag(String useFlag) {
		this.useFlag = useFlag;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	public String getTopMnID() {
		return topMnID;
	}
	public void setTopMnID(String topMnID) {
		this.topMnID = topMnID;
	}
	public String getBaseType() {
		return baseType;
	}
	public void setBaseType(String baseType) {
		this.baseType = baseType;
	}
	public String getThemeUID() {
		return themeUID;
	}
	public void setThemeUID(String themeUID) {
		this.themeUID = themeUID;
	}
}
