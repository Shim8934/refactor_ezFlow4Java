package egovframework.ezEKP.ezSchedule.vo;

public class ScheduleGmailInfoVO {
	/** 유저ID */
	private String	userId;
	
	/** Flag */
	private String	flag;

	/** Gmail ID */
	private String	gmailId;

	/** Gmail PWD */
	private String	gmailPwd;

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * @return the flag
	 */
	public String getFlag() {
		return flag;
	}

	/**
	 * @param flag the flag to set
	 */
	public void setFlag(String flag) {
		this.flag = flag;
	}

	/**
	 * @return the gmailId
	 */
	public String getGmailId() {
		return gmailId;
	}

	/**
	 * @param gmailId the gmailId to set
	 */
	public void setGmailId(String gmailId) {
		this.gmailId = gmailId;
	}

	/**
	 * @return the gmailPwd
	 */
	public String getGmailPwd() {
		return gmailPwd;
	}

	/**
	 * @param gmailPwd the gmailPwd to set
	 */
	public void setGmailPwd(String gmailPwd) {
		this.gmailPwd = gmailPwd;
	}
}
