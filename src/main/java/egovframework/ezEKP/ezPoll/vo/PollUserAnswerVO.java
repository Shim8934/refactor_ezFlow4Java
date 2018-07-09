package egovframework.ezEKP.ezPoll.vo;


public class PollUserAnswerVO {
	private int ansId;
	private int qstId;
	private String userId;
	private int tenantId;
	private String userName1;
	private String userName2;
	private String voteDate;
	private String userImage;
	private String phone;
	private String deptId;
	
	public int getAnsId() {
		return ansId;
	}
	
	public void setAnsId(int ansId) {
		this.ansId = ansId;
	}
	
	public int getQstId() {
		return qstId;
	}
	
	public void setQstId(int qstId) {
		this.qstId = qstId;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public String getVoteDate() {
		return voteDate;
	}
	
	public void setVoteDate(String voteDate) {
		this.voteDate = voteDate;
	}

	public String getUserName1() {
		return userName1;
	}

	public void setUserName1(String userName1) {
		this.userName1 = userName1;
	}

	public String getUserName2() {
		return userName2;
	}

	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}

	public String getUserImage() {
		return userImage;
	}

	public void setUserImage(String userImage) {
		this.userImage = userImage;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getDeptId() {
		return deptId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}	
	
}	
