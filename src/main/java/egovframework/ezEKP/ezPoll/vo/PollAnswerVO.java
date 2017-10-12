package egovframework.ezEKP.ezPoll.vo;

public class PollAnswerVO {
	private int ansId;
	private int qstId;
	private int tenantId;
	private String content;	
	private int votesNumber;
	
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
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public int getVotesNumber() {
		return votesNumber;
	}
	
	public void setVotesNumber(int votesNumber) {
		this.votesNumber = votesNumber;
	}	
}
