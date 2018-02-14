package egovframework.ezEKP.ezLadder.vo;

public class LadderLineVO {
	
	private int tenant_id;
	/** 참여자 아이디 */
	private String userId;
	/** 참여자 이름 */
	private String userName;
	/** 참여자 이름(다국어) */
	private String userName2;
	/** 게임 아이템 - 결과값 */
	private String item;
	/** 순서 */
	private int ladderOrder;
	/** 아이템을 결과로 가지는 참여자 아이디 */
	private String resultUserId;
	/** 아이템을 결과로 가지는 참여자 이름 */
	private String resultUserName;
	/** 아이템을 결과로 가지는 참여자 이름(다국어) */
	private String resultUserName2;
	
	
	public int getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(int tenant_id) {
		this.tenant_id = tenant_id;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserName2() {
		return userName2;
	}
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}
	public String getItem() {
		return item;
	}
	public void setItem(String item) {
		this.item = item;
	}
	public int getLadderOrder() {
		return ladderOrder;
	}
	public void setLadderOrder(int ladderOrder) {
		this.ladderOrder = ladderOrder;
	}
	public String getResultUserId() {
		return resultUserId;
	}
	public void setResultUserId(String resultUserId) {
		this.resultUserId = resultUserId;
	}
	public String getResultUserName() {
		return resultUserName;
	}
	public void setResultUserName(String resultUserName) {
		this.resultUserName = resultUserName;
	}
	public String getResultUserName2() {
		return resultUserName2;
	}
	public void setResultUserName2(String resultUserName2) {
		this.resultUserName2 = resultUserName2;
	}

}
