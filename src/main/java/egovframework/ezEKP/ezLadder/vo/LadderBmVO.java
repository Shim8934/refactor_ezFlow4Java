package egovframework.ezEKP.ezLadder.vo;

public class LadderBmVO {
	
	/** 테넌트 id */
	private int tenant_id;
	/** 즐겨찾기 번호 */
	private int ladderBmId;
	/** 즐겨찾기 그룹 이름 */
	private String bmName;
	/** 즐겨찾기 작성자 아이디 */
	private String userId;
	/** 작성  날짜 */
	private String regdate;
	/** UTC DATE */
	private String offset;
	private String lang;
	private String userName;
	private String userName2;
	private int count;
	
	public int getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(int tenant_id) {
		this.tenant_id = tenant_id;
	}
	public int getLadderBmId() {
		return ladderBmId;
	}
	public void setLadderBmId(int ladderBmId) {
		this.ladderBmId = ladderBmId;
	}
	public String getBmName() {
		return bmName;
	}
	public void setBmName(String bmName) {
		this.bmName = bmName;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	public String getOffset() {
		return offset;
	}
	public void setOffset(String offset) {
		this.offset = offset;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
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
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	
	
	@Override
	public String toString() {
		return "LadderBmVO [tenant_id=" + tenant_id + ", ladderBmId="
				+ ladderBmId + ", bmName=" + bmName + ", userId=" + userId
				+ ", regdate=" + regdate + ", offset=" + offset + "]";
	}
}
