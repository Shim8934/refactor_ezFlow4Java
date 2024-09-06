package egovframework.ezEKP.ezSchedule.vo;

public class ScheduleMailConfigVO {
	/** 초대 메일 */
	private String invitationMail;
	/** 초대 취소 메일 */
	private String cancellationMail;
	/** 초대 승인 메일 */
	private String attendanceMail; 
	/** 초대 거절 메일 */
	private String rejectedMail;
	/** 2023-10-20 한태훈 - 초대 일정 수정 삭제 메일 */
	private String inviteScheModMail;
	
	public String getInvitationMail() {
		return invitationMail;
	}
	
	public void setInvitationMail(String invitationMail) {
		this.invitationMail = invitationMail;
	}
	
	public String getCancellationMail() {
		return cancellationMail;
	}
	
	public void setCancellationMail(String cancellationMail) {
		this.cancellationMail = cancellationMail;
	}
	
	public String getAttendanceMail() {
		return attendanceMail;
	}
	
	public void setAttendanceMail(String attendanceMail) {
		this.attendanceMail = attendanceMail;
	}
	
	public String getRejectedMail() {
		return rejectedMail;
	}
	
	public void setRejectedMail(String rejectedMail) {
		this.rejectedMail = rejectedMail;
	}

	public String getInviteScheModMail() {
		return inviteScheModMail;
	}

	public void setInviteScheModMail(String inviteScheModMail) {
		this.inviteScheModMail = inviteScheModMail;
	}

}
