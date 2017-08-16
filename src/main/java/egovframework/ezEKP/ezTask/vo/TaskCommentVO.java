package egovframework.ezEKP.ezTask.vo;

public class TaskCommentVO {
	/** 메모ID */
	private String commentID;
	/** 업무ID*/
	private String taskID;
	/** 메모작성자 ID*/
	private String commentorID;
	/** 메모작성자 이름*/
	private String commentName;
	/** 메모작성일*/
	private String commentDate;
	/** 메모내용*/
	private String comment;
	/** 테넌트 ID*/
	private int tenantID;
	public String getCommentID() {
		return commentID;
	}
	public void setCommentID(String commentID) {
		this.commentID = commentID;
	}
	public String getTaskID() {
		return taskID;
	}
	public void setTaskID(String taskID) {
		this.taskID = taskID;
	}
	public String getCommentorID() {
		return commentorID;
	}
	public void setCommentorID(String commentorID) {
		this.commentorID = commentorID;
	}
	public String getCommentName() {
		return commentName;
	}
	public void setCommentName(String commentName) {
		this.commentName = commentName;
	}
	public String getCommentDate() {
		return commentDate;
	}
	public void setCommentDate(String commentDate) {
		this.commentDate = commentDate;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	@Override
	public String toString() {
		return "TaskCommentVO [commentID=" + commentID + ", taskID=" + taskID
				+ ", commentorID=" + commentorID + ", commentName="
				+ commentName + ", commentDate=" + commentDate + ", comment="
				+ comment + ", tenantID=" + tenantID + "]";
	}
}
