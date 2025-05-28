package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCClubGuestReplyVO {
	/** 작성자아이디*/
	String userId;
	/** 작성자이름*/
	String userName;
	/** 작성자이름(다국어)*/
	String userName2;
	/** 작성자회사아이디*/
	String companyID;
	/** 내용(CLOB)*/
	String content;
	/** 작성일시*/
	String writeDate;
	/** 커뮤니티별방명록일련번호*/
	int itemId;
	/** 커뮤니티번호*/
	String c_clubNo;
	/** 커뮤니티 방명록별 댓글*/
	String replyId;
	/** 테넌트 ID*/
	int tenantID;

	public String getUserId() {return userId;}

	public void setUserId(String userId) {this.userId = userId;}

	public String getUserName() {return userName;}

	public void setUserName(String userName) {this.userName = userName;}

	public String getUserName2() {return userName2;}

	public void setUserName2(String userName2) {this.userName2 = userName2;}

	public String getCompanyID() {return companyID;}

	public void setCompanyID(String companyID) {this.companyID = companyID;}

	public String getContent() {return content;}

	public void setContent(String content) {this.content = content;}

	public String getWriteDate() {return writeDate;}

	public void setWriteDate(String writeDate) {this.writeDate = writeDate;}

	public int getItemId() {return itemId;}

	public void setItemId(int itemId) {this.itemId = itemId;}

	public String getC_clubNo() {return c_clubNo;}

	public void setC_clubNo(String c_clubNo) {this.c_clubNo = c_clubNo;}

	public String getReplyId() {return replyId;}

	public void setReplyId(String replyId) {this.replyId = replyId;}

	public int getTenantID() {return tenantID;}

	public void setTenantID(int tenantID) {this.tenantID = tenantID;}

}
