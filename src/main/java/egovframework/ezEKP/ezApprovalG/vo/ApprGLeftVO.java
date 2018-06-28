package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGLeftVO {

	/** 헤더 명, 코드 명*/
	private String name;
	/** 헤더 길이*/
	private int width;
	/** 컬럼명*/
	private String colName;
	/** 컨테이너타입 명*/
	private String containerTypeName;
	/** 컨테이너타입 명(다국어)*/
	private String containerTypeName2;
	/** 컨테이너 아이디*/
	private String containerID;
	/** 컨테이너 타입 아이디*/
	private String containerTypeID;
	/** 컨테이너뎁트아이디*/
	private String containerOwnDepID;
	/** 코드*/
	private String code2;
	/** 컨테이너 사용하는 부서ID */
	private String useDepID;
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getWidth() {
		return width;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public String getColName() {
		return colName;
	}
	public void setColName(String colName) {
		this.colName = colName;
	}
	public String getContainerTypeName() {
		return containerTypeName;
	}
	public void setContainerTypeName(String containerTypeName) {
		this.containerTypeName = containerTypeName;
	}
	public String getContainerTypeName2() {
		return containerTypeName2;
	}
	public void setContainerTypeName2(String containerTypeName2) {
		this.containerTypeName2 = containerTypeName2;
	}
	public String getContainerID() {
		return containerID;
	}
	public void setContainerID(String containerID) {
		this.containerID = containerID;
	}
	public String getContainerTypeID() {
		return containerTypeID;
	}
	public void setContainerTypeID(String containerTypeID) {
		this.containerTypeID = containerTypeID;
	}
	public String getContainerOwnDepID() {
		return containerOwnDepID;
	}
	public void setContainerOwnDepID(String containerOwnDepID) {
		this.containerOwnDepID = containerOwnDepID;
	}
	public String getCode2() {
		return code2;
	}
	public void setCode2(String code2) {
		this.code2 = code2;
	}
	public String getUseDepID() {
		return useDepID;
	}
	public void setUseDepID(String useDepID) {
		this.useDepID = useDepID;
	}
	
}
