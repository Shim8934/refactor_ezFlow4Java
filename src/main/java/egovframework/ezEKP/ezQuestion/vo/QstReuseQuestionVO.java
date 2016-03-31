package egovframework.ezEKP.ezQuestion.vo;

public class QstReuseQuestionVO {
	//제목	
	private String title;
	//내용	
	private String content;
	//기간	
	private String postTerm;
	//복수응답여부	
	private String multiResponseFlg;
	//결과공개여부	
	private String publicResultFlg;
	//공개범위		
	private String responseRange;
	//아이템번호
	private int itemNo;
	//게시글번호
	private int brdId;
	
	public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	public int getBrdId() {
		return brdId;
	}
	public void setBrdId(int brdId) {
		this.brdId = brdId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getPostTerm() {
		return postTerm;
	}
	public void setPostTerm(String postTerm) {
		this.postTerm = postTerm;
	}
	public String getMultiResponseFlg() {
		return multiResponseFlg;
	}
	public void setMultiResponseFlg(String multiResponseFlg) {
		this.multiResponseFlg = multiResponseFlg;
	}
	public String getPublicResultFlg() {
		return publicResultFlg;
	}
	public void setPublicResultFlg(String publicResultFlg) {
		this.publicResultFlg = publicResultFlg;
	}
	public String getResponseRange() {
		return responseRange;
	}
	public void setResponseRange(String responseRange) {
		this.responseRange = responseRange;
	}
}
