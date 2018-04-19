package egovframework.ezEKP.ezLadder.vo;

import java.util.Arrays;

public class LadderOrderVO {
	
	/** 테넌트 id */
	private int tenant_id;
	/** ai, sequence */
	private int id;
	/** 사다리 번호 */
	private int ladderId;
	/** 변경할 사다리 번호 */
	private int changeLadderId;
	/** 사용자 아이디 */
	private String userId;
	
	/** 사다리 번호 */
	private String [] ladderIds;
	/** 변경할 사다리 번호 */
	private String [] changeLadderIds;
	
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
	public int getLadderId() {
		return ladderId;
	}
	public void setLadderId(int ladderId) {
		this.ladderId = ladderId;
	}
	public int getChangeLadderId() {
		return changeLadderId;
	}
	public void setChangeLadderId(int changeLadderId) {
		this.changeLadderId = changeLadderId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String [] getLadderIds() {
		return ladderIds;
	}
	public void setLadderIds(String [] ladderIds) {
		this.ladderIds = ladderIds;
	}
	public String [] getChangeLadderIds() {
		return changeLadderIds;
	}
	public void setChangeLadderIds(String [] changeLadderIds) {
		this.changeLadderIds = changeLadderIds;
	}
	@Override
	public String toString() {
		return "LadderOrderVO [tenant_id=" + tenant_id + ", id=" + id
				+ ", ladderId=" + ladderId + ", changeLadderId="
				+ changeLadderId + ", userId=" + userId + ", ladderIds="
				+ Arrays.toString(ladderIds) + ", changeLadderIds="
				+ Arrays.toString(changeLadderIds) + "]";
	}
	
}
