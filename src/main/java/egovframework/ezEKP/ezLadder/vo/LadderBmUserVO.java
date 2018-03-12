package egovframework.ezEKP.ezLadder.vo;

public class LadderBmUserVO {
	
	/** 테넌트 id */
	private int tenant_id;
	/** ai, sequence */
	private int id;
	/** 사다리 즐겨찾기 번호 */
	private int ladderBmId;
	/** 해당 ladderBmId를 작성한 유저 */
	private String writerId;
	/** 즐겨찾기에 포함된 멤버 아이디 */
	private String userId;
	/** 즐겨찾기에 포함된 멤버 이름  */
	private String userName;
	/** 즐겨찾기에 포함된 멤버 이름 (다국어)*/
	private String userName2;
	/** 다국어 설정 */
	private String lang;
	
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
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
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
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	@Override
	public String toString() {
		return "LadderBmUserVO [tenant_id=" + tenant_id + ", id=" + id
				+ ", ladderBmId=" + ladderBmId + ", writerId=" + writerId
				+ ", userId=" + userId + ", userName=" + userName
				+ ", userName2=" + userName2 + ", lang=" + lang + "]";
	}
}
