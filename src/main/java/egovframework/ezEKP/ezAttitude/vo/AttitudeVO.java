package egovframework.ezEKP.ezAttitude.vo;

public class AttitudeVO {
	/** 근태아이디*/
	private String attitudeId;
	/** 회사아이디*/
	private String companyId;
	/** 테넌트*/
	private int tenantId;
	/** 작성자아이디*/
	private String writerId;
	/** 부서아이디*/
	private String deptId;
	/** 시작일*/
	private String startDate;
	/** 시작시간*/
	private String startTime;
	/** 종료일*/
	private String endDate;
	/** 종료시간*/
	private String endTime;
	/** 수정신청여부*/
	private String modAppl;
	/** 근무지역*/
	private String region;
	/** 연락처*/
	private String mobile;
	/** 업무대리인*/
	private String bizSub;
	/** 내용*/
	private String content;
	/** IP*/
	private String ip;
	/** 날짜입력형식*/
	private String dateType;
	/** 근태유형 아이디*/
	private String typeId;
	/** 근태타입명*/
	private String typeName;
	/** 근태타입명2*/
	private String typeName2;
	/** 근태타입 이미지*/
	private String imgPath;
	/** 작성자명*/
	private String writerName;
	/** 작성자부서명*/
	private String writerDeptName;
	
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	public String getTypeName() {
		return typeName;
	}
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	public String getImgPath() {
		return imgPath;
	}
	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}
	public String getAttitudeId() {
		return attitudeId;
	}
	public void setAttitudeId(String attitudeId) {
		this.attitudeId = attitudeId;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
	public String getDeptId() {
		return deptId;
	}
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public String getModAppl() {
		return modAppl;
	}
	public void setModAppl(String modAppl) {
		this.modAppl = modAppl;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getBizSub() {
		return bizSub;
	}
	public void setBizSub(String bizSub) {
		this.bizSub = bizSub;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		if (content != null) {
			this.content = content.replaceAll(": \'", ":").replaceAll("\';", ";");
		}
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getDateType() {
		return dateType;
	}
	public void setDateType(String dateType) {
		this.dateType = dateType;
	}
	public String getTypeId() {
		return typeId;
	}
	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	public String getTypeName2() {
		return typeName2;
	}
	public void setTypeName2(String typeName2) {
		this.typeName2 = typeName2;
	}
	public String getWriterDeptName() {
		return writerDeptName;
	}
	public void setWriterDeptName(String writerDeptName) {
		this.writerDeptName = writerDeptName;
	}
}
