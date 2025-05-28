package egovframework.ezEKP.ezEmail.vo;

// origin message
public class MailWriteMessageVO {
	// url
	private String urlOwn; // folderPath/uid (ex. "INBOX/4")
	private String url = ""; // (String) uid or draftUID
	private String cdoMessageID; // message id (예약발송수정에만 해당)

	// message
	private String to = "";
	private String cc = "";
	private String bcc = "";
	private String subject = "";
	private String encodedSubject;
	private String bodyValue = "";
	private String tempBody = "";
	private String attach = "";

	// 보안메일
	private String isSecureMail = "false"; // X-JMocha-Secure-Mail Header
	private String secureMaxReadCount = "0"; // X-JMocha-Secure-Mail-Password Header (예약발송수정에만 해당)
	private String secureMaxReadDate = ""; // X-JMocha-Secure-Mail-ReadCount Header (예약발송수정에만 해당)
	private String securePassword = ""; // X-JMocha-Secure-Mail-ReadDate Header (예약발송수정에만 해당)

	// MailGeneralVO: textOption, defaultSeparateSend, (fontSize, fontFamily)
	private String bodyType = "0"; // 메일 본문 형식 (멀티파트 타입)
	private String isEach = "FALSE"; // 개별발신 (개별발신 기본 사용 여부)
	private String defaultFontAndSize; // 에디터 기본 폰트 및 크기

	private String unread = "0"; // SMTP flag (poll은 빈값으로 넘김.)
	private String importance = "1"; // X-Priority Header (중요도)
	private String replyReadTime = "1"; // X-JMocha-Disp-Noti-To Header
	private String replySendTime = "0"; // Return-Receipt-To Header
	private String delaySendDate = ""; // 예약발송 시간 (예약발송수정에만 해당) pReservedSaveTime

	private boolean overQuota = false; // origin mail 작업 중 에러

	public void setUrlOwn(String urlOwn) {
		this.urlOwn = urlOwn;
	}
	public String getUrlOwn() {
		return urlOwn;
	}

	public void setUrl(String url) {
		this.url = url;
	}
	public String getUrl() {
		return url;
	}

	public void setCdoMessageID(String cdoMessageID) {
		this.cdoMessageID = cdoMessageID;
	}
	public String getCdoMessageID() {
		return cdoMessageID;
	}

	public void setTo(String to) {
		this.to = to;
	}
	public String getTo() {
		return to;
	}

	public void setCc(String cc) {
		this.cc = cc;
	}
	public String getCc() {
		return cc;
	}

	public void setBcc(String bcc) {
		this.bcc = bcc;
	}
	public String getBcc() {
		return bcc;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getSubject() {
		return subject;
	}

	public void setEncodedSubject(String encodedSubject) {
		this.encodedSubject = encodedSubject;
	}
	public String getEncodedSubject() {
		return encodedSubject;
	}

	public void setBodyValue(String bodyValue) {
		this.bodyValue = bodyValue;
	}
	public String getBodyValue() {
		return bodyValue;
	}

	public void setTempBody(String tempBody) {
		this.tempBody = tempBody;
	}
	public String getTempBody() {
		return tempBody;
	}

	public void setAttach(String attach) {
		this.attach = attach;
	}
	public String getAttach() {
		return attach;
	}

	public void setIsSecureMail(String isSecureMail) {
		this.isSecureMail = isSecureMail;
	}
	public String getIsSecureMail() {
		return isSecureMail;
	}

	public void setSecureMaxReadCount(String secureMaxReadCount) {
		this.secureMaxReadCount = secureMaxReadCount;
	}
	public String getSecureMaxReadCount() {
		return secureMaxReadCount;
	}

	public void setSecureMaxReadDate(String secureMaxReadDate) {
		this.secureMaxReadDate = secureMaxReadDate;
	}
	public String getSecureMaxReadDate() {
		return secureMaxReadDate;
	}

	public void setSecurePassword(String securePassword) {
		this.securePassword = securePassword;
	}
	public String getSecurePassword() {
		return securePassword;
	}

	public void setBodyType(String bodyType) {
		this.bodyType = bodyType;
	}
	public String getBodyType() {
		return bodyType;
	}

	public void setIsEach(String isEach) {
		this.isEach = isEach;
	}
	public String getIsEach() {
		return isEach;
	}

	public void setDefaultFontAndSize(String defaultFontAndSize) {
		this.defaultFontAndSize = defaultFontAndSize;
	}
	public String getDefaultFontAndSize() {
		return defaultFontAndSize;
	}

	public void setUnread(String unread) {
		this.unread = unread;
	}
	public String getUnread() {
		return unread;
	}

	public void setImportance(String importance) {
		this.importance = importance;
	}
	public String getImportance() {
		return importance;
	}

	public void setReplyReadTime(String replyReadTime) {
		this.replyReadTime = replyReadTime;
	}
	public String getReplyReadTime() {
		return replyReadTime;
	}

	public void setReplySendTime(String replySendTime) {
		this.replySendTime = replySendTime;
	}
	public String getReplySendTime() {
		return replySendTime;
	}

	public void setDelaySendDate(String delaySendDate) {
		this.delaySendDate = delaySendDate;
	}
	public String getDelaySendDate() {
		return delaySendDate;
	}

	public void setOverQuota(boolean overQuota) {
		this.overQuota = overQuota;
	}
	public boolean getOverQuota() {
		return overQuota;
	}

	@Override
	public String toString() {
		return "MailWriteMessageVO [urlOwn=" + urlOwn + ", url=" + url + ", cdoMessageID=" + cdoMessageID + ", to=" + to
				+ ", cc=" + cc + ", bcc=" + bcc + ", subject=" + subject + ", encodedSubject=" + encodedSubject
				+ ", bodyValue=" + bodyValue + ", tempBody=" + tempBody + ", attach=" + attach + ", isSecureMail="
				+ isSecureMail + ", secureMaxReadCount=" + secureMaxReadCount + ", secureMaxReadDate="
				+ secureMaxReadDate + ", securePassword=" + securePassword + ", bodyType=" + bodyType + ", isEach="
				+ isEach + ", defaultFontAndSize=" + defaultFontAndSize + ", unread=" + unread + ", importance="
				+ importance + ", replyReadTime=" + replyReadTime + ", replySendTime=" + replySendTime
				+ ", delaySendDate=" + delaySendDate + ", overQuota=" + overQuota + "]";
	}
}