package egovframework.ezEKP.ezPoll.vo;

public class PollQuestionStatusVO {
	private int qstId;
	private String userId;
	private int tenantId;
	private int seen;
	private int comment;
	private int hide;
	private int modifying;
	
	public PollQuestionStatusVO() {
		
	}
	
	public int getQustId() {
		return qstId;
	}
	
	public void setQustId(int qstId) {
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
	
	public int getSeen() {
		return seen;
	}
	
	public void setSeen(int seen) {
		this.seen = seen;
	}
	
	public int getComment() {
		return comment;
	}
	
	public void setComment(int comment) {
		this.comment = comment;
	}
	
	public int getHide() {
		return hide;
	}
	
	public void setHide(int hide) {
		this.hide = hide;
	}
	
	public int getModifying() {
		return modifying;
	}
	
	public void setModifying(int modifying) {
		this.modifying = modifying;
	}		
}
