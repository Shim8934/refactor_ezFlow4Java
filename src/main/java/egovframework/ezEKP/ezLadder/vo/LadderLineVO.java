package egovframework.ezEKP.ezLadder.vo;

import java.util.ArrayList;

public class LadderLineVO {
	
	private int tenant_id;
	private int ladderId;
	/** 라인 아이디 (pk) */
	private String lineId;
	/** 참여자 아이디 */
	private String userId;
	/** 참여자 이름 */
	private String userName;
	/** 참여자 이름(다국어) */
	private String userName2;
	private String deptName;
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
	/** 생성자 아이디 */
	private String writerId;
	/** 다국어 */
	private String lang;
	/** 사진 */
	private String pic;
	
	/** 참여자 아이디 배열 */
	private String [] userIds;
	/** 참여자 이름 배열 */
	private String [] userNames;
	/** 참여자 이름(다국어) 배열 */
	private String [] userName2s;
	/** 게임 아이템 - 결과값 배열 */
	private String [] items;
	/** 순서 배열 */
	private int [] ladderOrders;
	
	public int getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(int tenant_id) {
		this.tenant_id = tenant_id;
	}
	public int getLadderId() {
		return ladderId;
	}
	public void setLadderId(int ladderId) {
		this.ladderId = ladderId;
	}
	public String getLineId() {
		return lineId;
	}
	public void setLineId(String lineId) {
		this.lineId = lineId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;;
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
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
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
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic != null ? pic : "";
	}
	
	/** 배열 */
	public String[] getUserIds() {
		return userIds;
	}
	public void setUserIds(String[] userIds) {
		this.userIds = userIds;
	}
	public void setUserIds(ArrayList<String> userIds) {
		this.userIds = (String[]) userIds.toArray(new String[userIds.size()]);
	}
	public String[] getUserNames() {
		return userNames;
	}
	public void setUserNames(String[] userNames) {
		this.userNames = userNames;
	}
	public void setUserNames(ArrayList<String> userNames) {
		this.userNames = (String[]) userNames.toArray(new String[userNames.size()]);
	}
	public String[] getUserName2s() {
		return userName2s;
	}
	public void setUserName2s(String[] userName2s) {
		this.userName2s = userName2s;
	}
	public void setUserName2s(ArrayList<String> userName2s) {
		this.userName2s = (String[]) userName2s.toArray(new String[userName2s.size()]);
	}
	public String[] getItems() {
		return items;
	}
	public void setItems(String[] items) {
		this.items = items;
	}
	public void setItems(ArrayList<String> items) {
		this.items = (String[]) items.toArray(new String[items.size()]);
	}
	public int[] getLadderOrders() {
		return ladderOrders;
	}
	public void setLadderOrders(int[] ladderOrders) {
		this.ladderOrders = ladderOrders;
	}
}
