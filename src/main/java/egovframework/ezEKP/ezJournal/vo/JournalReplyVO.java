package egovframework.ezEKP.ezJournal.vo;

public class JournalReplyVO {

	private String replyId;
	private String replyContent;
	private String replyDate;
	private String replyWriter;
	private String replyWriterName;
	private String mine;
	
	public String getReplyWriterName() {
		return replyWriterName;
	}
	public void setReplyWriterName(String replyWriterName) {
		this.replyWriterName = replyWriterName;
	}
	public String getReplyId() {
		return replyId;
	}
	public void setReplyId(String replyId) {
		this.replyId = replyId;
	}
	public String getReplyContent() {
		return replyContent;
	}
	public void setReplyContent(String replyContent) {
		this.replyContent = replyContent;
	}
	public String getReplyDate() {
		return replyDate;
	}
	public void setReplyDate(String replyDate) {
		this.replyDate = replyDate;
	}
	public String getReplyWriter() {
		return replyWriter;
	}
	public void setReplyWriter(String replyWriter) {
		this.replyWriter = replyWriter;
	}
	public String getMine() {
		return mine;
	}
	public void setMine(String mine) {
		this.mine = mine;
	}
}
