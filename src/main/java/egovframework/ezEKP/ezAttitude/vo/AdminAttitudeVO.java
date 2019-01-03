package egovframework.ezEKP.ezAttitude.vo;

public class AdminAttitudeVO {
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
	/** IP*/
	private String ip;
	/** 날짜입력형식*/
	private String dateType;
	/** 근태유형 아이디*/
	private String typeId;
	/** 근태타입명*/
	private String typeName;
	/** 근태타입 이미지*/
	private String imgPath;
	/** 유저 이름*/
	private String userName;
	/** 부서 이름*/
	private String deptName;
	/** 유저 직급*/
	private String userTitle;
	/** 유저 이메일*/
	private String userEmail;
	/** 휴가일 수 (근태연차현황관리에서 사용) */
	private String annualCnt;
	/** 총 휴가일 수 (근태연차현황관리에서 사용) */
	private String totalannualCnt;
	
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
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getUserTitle() {
		return userTitle;
	}
	public void setUserTitle(String userTitle) {
		this.userTitle = userTitle;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	/**
	 *  HashSet 중복제거 Override
	 */
	@Override
	public int hashCode() {
		return this.writerId.hashCode();
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof AdminAttitudeVO) {
			if (this.writerId.equals(((AdminAttitudeVO) obj).writerId)) {
				return true;
			}
		}
		
		return false;
	}
	
	public String getAnnualCnt() {
		return annualCnt;
	}
	public void setAnnualCnt(String annualCnt) {
		this.annualCnt = annualCnt;
	}
	public String getTotalannualCnt() {
		return totalannualCnt;
	}
	public void setTotalannualCnt(String totalannualCnt) {
		this.totalannualCnt = totalannualCnt;
	}
}
