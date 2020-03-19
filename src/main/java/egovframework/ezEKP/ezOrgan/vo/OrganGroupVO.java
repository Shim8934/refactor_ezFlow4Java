package egovframework.ezEKP.ezOrgan.vo;

public class OrganGroupVO {
	/** 권한그룹 ID */
	private String GroupID;
	/** 권한그룹 이름 */
	private String GroupName;
	/** 권한그룹 생성자 */
	private String CreateID;
	/** 권한그룹 생성일자 */
	private String CreateDate;
	/** 권한그룹 수정자 */
	private String UpdateID;
	/** 권한그룹 수정일자 */
	private String UpdateDate;
	/** 권한그룹 소속회사 */
	private String CompanyID;
	/** 권한그룹 그룹원 */
	private String MemberID;
	/** 권한그룹 그룹원 타입 */
	private String MemberType;
	/** 권한그룹 그룹원 추가일자 */
	private String AddedDate;
	/** 권한그룹 하위부서 포함여부 */
	private String SubDeptYN;
	/** 권한그룹 그룹원 소속회사ID*/
	private String MemberCompanyID;
	
	
	public String getMemberCompanyID() {
		return MemberCompanyID;
	}
	public void setMemberCompanyID(String memberCompanyID) {
		MemberCompanyID = memberCompanyID;
	}
	public String getGroupID() {
		return GroupID;
	}
	public void setGroupID(String groupID) {
		GroupID = groupID;
	}
	public String getGroupName() {
		return GroupName;
	}
	public void setGroupName(String groupName) {
		GroupName = groupName;
	}
	public String getCreateID() {
		return CreateID;
	}
	public void setCreateID(String createID) {
		CreateID = createID;
	}
	public String getCreateDate() {
		return CreateDate;
	}
	public void setCreateDate(String createDate) {
		CreateDate = createDate;
	}
	public String getUpdateID() {
		return UpdateID;
	}
	public void setUpdateID(String updateID) {
		UpdateID = updateID;
	}
	public String getUpdateDate() {
		return UpdateDate;
	}
	public void setUpdateDate(String updateDate) {
		UpdateDate = updateDate;
	}
	public String getCompanyID() {
		return CompanyID;
	}
	public void setCompanyID(String companyID) {
		CompanyID = companyID;
	}
	public String getMemberID() {
		return MemberID;
	}
	public void setMemberID(String memberID) {
		MemberID = memberID;
	}
	public String getMemberType() {
		return MemberType;
	}
	public void setMemberType(String memberType) {
		MemberType = memberType;
	}
	public String getAddedDate() {
		return AddedDate;
	}
	public void setAddedDate(String addedDate) {
		AddedDate = addedDate;
	}
	public String getSubDeptYN() {
		return SubDeptYN;
	}
	public void setSubDeptYN(String subDeptYN) {
		SubDeptYN = subDeptYN;
	}
	
	

}
