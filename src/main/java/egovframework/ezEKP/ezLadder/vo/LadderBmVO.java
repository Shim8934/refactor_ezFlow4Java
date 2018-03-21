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
	@Override
	public String toString() {
		return "LadderBmVO [tenant_id=" + tenant_id + ", ladderBmId="
				+ ladderBmId + ", bmName=" + bmName + ", userId=" + userId
				+ ", regdate=" + regdate + ", offset=" + offset + "]";
	}
}
