package egovframework.ezEKP.ezPoll.vo;


public class PollUserAnswerVO {
	private int ansId;
	private int qstId;
	private String userId;
	private int tenantId;
	private String userName;
	private String voteDate;
	
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
	
	public String getUserName() {
		return userName;
	}
	
	public void setUserName(String userName) {
		this.userName = userName;
	}	
}	
