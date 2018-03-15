package egovframework.ezEKP.ezLadder.vo;

import java.util.ArrayList;
import java.util.List;

public class LadderBmUserVO {
	
	/** 테넌트 id */
	private int tenant_id;
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
	
	/** 즐겨찾기에 포함된 멤버 아이디 */
	private String [] userIds;
	/** 즐겨찾기에 포함된 멤버 이름  */
	private String [] userNames;
	/** 즐겨찾기에 포함된 멤버 이름 (다국어)*/
	private String [] userName2s;
	
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
	
	/** 배열 */
	public String[] getUserIds() {
		return userIds;
	}
	public void setUserIds(String[] userIds) {
		this.userIds = userIds;
	}
	public String[] getUserNames() {
		return userNames;
	}
	public void setUserNames(String[] userNames) {
		this.userNames = userNames;
	}
	public String[] getUserName2s() {
		return userName2s;
	}
	public void setUserName2s(String[] userName2s) {
		this.userName2s = userName2s;
	}
}
