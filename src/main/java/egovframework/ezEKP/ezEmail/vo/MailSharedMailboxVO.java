package egovframework.ezEKP.ezEmail.vo;

import java.util.ArrayList;
import java.util.List;

public class MailSharedMailboxVO {
	
	private String shareId;
	private String shareMail;
	private String shareName;
	private String shareName1;
	private String shareName2;
	private String compId;
	private List<MailSharedMailboxUserVO> userList = new ArrayList<>();
	
	public String getShareId() {
		return shareId;
	}
	public void setShareId(String shareId) {
		this.shareId = shareId;
	}
	public String getShareMail() {
		return shareMail;
	}
	public void setShareMail(String shareMail) {
		this.shareMail = shareMail;
	}
	public String getShareName() {
		return shareName;
	}
	public void setShareName(String shareName) {
		this.shareName = shareName;
	}
	public String getShareName1() {
		return shareName1;
	}
	public void setShareName1(String shareName1) {
		this.shareName1 = shareName1;
	}
	public String getShareName2() {
		return shareName2;
	}
	public void setShareName2(String shareName2) {
		this.shareName2 = shareName2;
	}
	public String getCompId() {
		return compId;
	}
	public void setCompId(String compId) {
		this.compId = compId;
	}
	public List<MailSharedMailboxUserVO> getUserList() {
		return userList;
	}
	public void setUserList(List<MailSharedMailboxUserVO> userList) {
		this.userList = userList;
	}
	
	@Override
	public String toString() {
		return "MailSharedMailboxVO [shareId=" + shareId + ", shareMail=" + shareMail + ", shareName=" + shareName
				+ ", shareName1=" + shareName1 + ", shareName2=" + shareName2 + ", compId=" + compId + ", userList="
				+ userList + "]";
	}
	
}
