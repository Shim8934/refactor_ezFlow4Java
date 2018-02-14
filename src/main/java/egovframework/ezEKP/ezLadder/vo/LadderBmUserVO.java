package egovframework.ezEKP.ezLadder.vo;

public class LadderBmUserVO {
	
	/** 테넌트 id */
	private int tenant_id;
	/** ai, sequence */
	private int id;
	/** 사다리 즐겨찾기 번호 */
	private int ladderBmId;
	/** 즐겨찾기에 포함된 멤버 아이디 */
	private String userId;
	/** 즐겨찾기에 포함된 멤버 이름  */
	private String userName;
	/** 즐겨찾기에 포함된 멤버 이름 (다국어)*/
	private String userName2;
	
	public int getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(int tenant_id) {
		this.tenant_id = tenant_id;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getLadderBmId() {
		return ladderBmId;
	}
	public void setLadderBmId(int ladderBmId) {
		this.ladderBmId = ladderBmId;
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
}
