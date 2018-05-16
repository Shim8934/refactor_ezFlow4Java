package egovframework.ezEKP.ezLadder.vo;

public class LadderCommentVO {
	
	private int tenant_id;
	/** 댓글 아이디 */
	private int id;
	/** 사다리 아이디 */
	private int ladderId;
	/** 댓글 내용 */
	private String comment;
	/** 댓글 작성자 아이디 */
	private String userId;
	/** 댓글 작성자 이름 */
	private String userName;
	/** 댓글 작성자 이름(다국어) */
	private String userName2;
	/** 댓글 작성 날짜 */
	private String writeDate;
	/** 사진 */
	private String pic;
	/** UTC time */
	private String offset;
	/** 다국어 */
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
	public void setId(String id) {
		this.id = Integer.parseInt(id);
	}
	public int getLadderId() {
		return ladderId;
	}
	public void setLadderId(int ladderId) {
		this.ladderId = ladderId;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
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
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic != null ? pic : "";
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
	@Override
	public String toString() {
		return "LadderCommentVO [tenant_id=" + tenant_id + ", id=" + id
				+ ", ladderId=" + ladderId + ", comment=" + comment
				+ ", userId=" + userId + ", userName=" + userName
				+ ", userName2=" + userName2 + ", writeDate=" + writeDate
				+ ", offset=" + offset + ", lang=" + lang + "]";
	}
}
