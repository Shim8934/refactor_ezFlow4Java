package egovframework.ezEKP.ezPersonal.vo;

public class PersonalNoticeVO {

	/** 일련번호 */
	private Integer itemSeq;
	/** 회사ID */
	private String companyID;
	/** 게시일 */
	private String postDate;
	/** 공지사항 제목 */
	private String title;
	/** 공지사항 제목(다국어) */
	private String title2;
	/** 공지사항 본문  CLOB*/
	private String content;
	public Integer getItemSeq() {
		return itemSeq;
	}
	public void setItemSeq(Integer itemSeq) {
		this.itemSeq = itemSeq;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getPostDate() {
		return postDate;
	}
	public void setPostDate(String postDate) {
		this.postDate = postDate;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getTitle2() {
		return title2;
	}
	public void setTitle2(String title2) {
		this.title2 = title2;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
}
