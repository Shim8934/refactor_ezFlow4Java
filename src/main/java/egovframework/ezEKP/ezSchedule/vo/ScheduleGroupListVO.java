package egovframework.ezEKP.ezSchedule.vo;

public class ScheduleGroupListVO {
	/** 그룹ID */
	private String groupId;	
	/** 그룹 이름 */
	private String groupName;
	/** 그룹 설명 */
	private String description;
	/** 그룹 생성일 */
	private String createDate;
	/** 그룹멤버 아이디 */
	private String memberId;
	/** 그룹멤버 메일 */
	private String mail;
	/** 그룹멤버 정보 */
	private String info;
	
	
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public String getGroupName() {
		return groupName;
	}
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public String getInfo() {
		return info;
	}
	public void setInfo(String info) {
		this.info = info;
	}
	
	
	
}
