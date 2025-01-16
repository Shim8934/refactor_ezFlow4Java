package egovframework.ezEKP.ezEmail.vo;

import java.io.File;
import java.util.HashMap;

import egovframework.ezEKP.ezEmail.type.WriteType;

public class MailWriteProcessVO {
	/**
	 * load origin message (MailWriteMessageVO)
	 */
	private MailWriteMessageVO mailWriteMessageVO = new MailWriteMessageVO();
	/**
	 * 메일쓰기에 필요한 옵션 모음 (MailWriteOptionsVO)
	 * 각종 tenant config 등
	 */
	private MailWriteOptionsVO mailWriteOptionsVO = new MailWriteOptionsVO();
	/**
	 * 기본환경설정 관련 (MailGeneralVO)
	 * keepDeleteLength → pAutoSaveTime: 자동 임시저장
	 * mailSenderNm → mailSendObject: 보내는사람이름
	 * previewMail: 발송 전 미리보기
	 * defaultCursorPosition: 메일쓰기 기본 커서 위치
	 * mailSendResult: 메일 발송 결과 표시
	 */
	private MailGeneralVO mailGeneralVO = new MailGeneralVO();
	/**
	 * 메일 서명 (MailSignatureVO)
	 * content1, content2, content3, useFlag
	 * → mailSign1, mailSign2, mailSign3, mailSignSel
	 */
	private MailSignatureVO mailSignatureVO = new MailSignatureVO();
	/**
	 * 메일 색상 관련 설정 (MailColorVO)
	 * inMailColor, outMailColor
	 */
	private MailColorVO mailColorVO = new MailColorVO("#808080", "#0080ff"); // default
	/**
	 * 공유사서함 (MailSharedMailboxVO)
	 * shareMail, shareName
	 */
	private MailSharedMailboxVO sharedMailboxInfoVO = new MailSharedMailboxVO();

	// for process
	private WriteType writetype;
	private boolean hasOrigin = false;
	private String cmdOwn;
	private String cmd;
	private String folderPath;
	private long uid = 0; // (long) uid, draftUID(x)
	private String draftsFolderName; // 임시보관함에 저장
	private String from = "";
	private String msgto = ""; // RESEND_IN_SENT 에서 사용
	private String mailId;
	private String reciverName; // for RESEND_IN_SENT
	private HashMap<String, Object> extraMap = new HashMap<>(); // shareId
	private File emlFile; // for RESERVE

	// vo
	public void setMailWriteMessageVO(MailWriteMessageVO mailWriteMessageVO) {
		this.mailWriteMessageVO = mailWriteMessageVO;
	}
	public MailWriteMessageVO getMailWriteMessageVO() {
		return mailWriteMessageVO;
	}
	public void setMailWriteOptionsVO(MailWriteOptionsVO mailWriteOptionsVO) {
		this.mailWriteOptionsVO = mailWriteOptionsVO;
	}
	public MailWriteOptionsVO getMailWriteOptionsVO() {
		return mailWriteOptionsVO;
	}
	public void setMailGeneralVO(MailGeneralVO mailGeneralVO) {
		this.mailGeneralVO = mailGeneralVO;
	}
	public MailGeneralVO getMailGeneralVO() {
		return mailGeneralVO;
	}
	public void setMailSignatureVO(MailSignatureVO mailSignatureVO) {
		this.mailSignatureVO = mailSignatureVO;
	}
	public MailSignatureVO getMailSignatureVO() {
		return mailSignatureVO;
	}
	public void setMailColorVO(MailColorVO mailColorVO) {
		this.mailColorVO = mailColorVO;
	}
	public MailColorVO getMailColorVO() {
		return mailColorVO;
	}
	public void setSharedMailboxInfoVO(MailSharedMailboxVO sharedMailboxInfoVO) {
		this.sharedMailboxInfoVO = sharedMailboxInfoVO;
	}
	public MailSharedMailboxVO getSharedMailboxInfoVO() {
		return sharedMailboxInfoVO;
	}

	// message
	public void setUrlOwn(String urlOwn) {
		mailWriteMessageVO.setUrlOwn(urlOwn);
	}
	public void setUrl(String url) {
		mailWriteMessageVO.setUrl(url);
	}
	public void setTo(String to) {
		mailWriteMessageVO.setTo(to);
	}
	public void setDraftUID(long draftUID) {
		if (writetype.isReserve()) {
			this.uid = draftUID;
		}

		String url = String.valueOf(draftUID);
		mailWriteMessageVO.setUrl(url);
//		mailWriteMessageVO.setUrlOwn(url);
		/**
		 * urlOwn은 = "Drafts/url(uid)" 이어야 함.
		 * 기존 코드는 urlOwn을 url(uid)값으로 넘겨주고 있었음. (var gg_url)
		 * but [발송]하지 않으니 쓰임이 없었음, urlOwn 세팅하는 과정 생략함.
		 */
	}

	// setter getter
	public void setWriteType() {
		/**
		 * switch: 조건이 많아질수록 if보다 빠른 조건 분기 가능.
		 * [if] 순차 조건 평가. [switch] 점프 테이블 사용.
		 */
		switch (cmd) {
//			case "": // defaultIfBlank NEW이므로 필요없음.
			case "NEW":
				this.writetype = WriteType.NEW;
				break;
			case "EDIT":
				this.writetype = WriteType.EDIT;
				break;
			case "EDIT_IN_DRAFTS":
				this.writetype = WriteType.EDIT_IN_DRAFTS;
				break;
			case "RESERVE":
				this.cmdOwn = "EDIT"; // for 기존 코드 유지 (cmd)
				this.writetype = WriteType.RESERVE;
				break;
			case "RESEND":
				this.writetype = WriteType.RESEND;
				break;
			case "RESEND_IN_SENT":
				this.writetype = WriteType.RESEND_IN_SENT;
				break;
			case "REPLY":
				this.writetype = WriteType.REPLY;
				break;
			case "REPLYALL":
				this.writetype = WriteType.REPLYALL;
				break;
			case "FORWARD":
				this.writetype = WriteType.FORWARD;
				break;
			case "READ":
				this.writetype = WriteType.READ;
				break;
			case "BOARD":
				this.writetype = WriteType.BOARD;
				break;
			case "BOARDDOTNET":
				this.writetype = WriteType.BOARDDOTNET;
				break;
			case "COMMUNITY":
				this.writetype = WriteType.COMMUNITY;
				break;
			case "COMMUNITYDOTNET":
				this.writetype = WriteType.COMMUNITYDOTNET;
				break;
			case "DOCSEND":
				this.writetype = WriteType.DOCSEND;
				break;
			case "DOCSENDDOTNET":
				this.writetype = WriteType.DOCSENDDOTNET;
				break;
			case "JOURNAL":
				this.writetype = WriteType.JOURNAL;
				break;
			case "EZPMS":
				this.writetype = WriteType.EZPMS;
				break;
			case "EZPMSBOARD":
				this.writetype = WriteType.EZPMSBOARD;
				break;
			case "ATTITUDE":
				this.writetype = WriteType.ATTITUDE;
				break;
			case "ATTITUDEABSENTED":
				this.writetype = WriteType.ATTITUDEABSENTED;
				break;
			case "POLL":
				this.cmdOwn = ""; // for 기존 코드 유지 (cmd)
				this.writetype = WriteType.POLL;
				break;
/* 아직 이 값으로는 받는 부분 없음
			case "DOCSENDDOC":
				this.writetype = WriteType.DOCSENDDOC;
				break;
			case "ACCESSNO":
				this.writetype = WriteType.ACCESSNO;
				break;
			case "REPORT":
				this.writetype = WriteType.REPORT;
				break;
*/
			default:
				this.writetype = null;
		}
	}
	public WriteType getWriteType() {
		return writetype;
	}
	public void setHasOrigin(boolean hasOrigin) {
		this.hasOrigin = hasOrigin; // useLoadFromOrigin 인지는 isInValid 에서 check.
	}
	public boolean hasOrigin() {
		return hasOrigin;
	}
	public void setCmd(String cmd) {
		/**
		 * cmdOwn: 들어온 그대로 보존해서 model에 전달. (for 기존 코드 유지: RESERVE→EDIT, POLL→"")
		 * writetype로 대체하려면 front, send controller 까지 다 수정해야함.
		 */
		this.cmdOwn = cmd;
		this.cmd = cmd.toUpperCase();
	}
	public void setCmdWithFolderName(String sentFolderName) {
		if (folderPath.equalsIgnoreCase(draftsFolderName) && "EDIT".equals(cmd)) {
			cmd = "EDIT_IN_DRAFTS";
		} else if (folderPath.equalsIgnoreCase(sentFolderName) && "RESEND".equals(cmd)) {
			cmd = "RESEND_IN_SENT";
		}
	}
	public String getCmdOwn() {
		return cmdOwn;
	}
	public String getCmd() {
		return cmd;
	}
	public void setFolderPath(String folderPath) {
		this.folderPath = folderPath;
	}
	public String getFolderPath() {
		return folderPath;
	}
	public void setUid(long uid) {
		this.uid = uid;
	}
	public long getUid() {
		return uid;
	}
	public void setDraftsFolderName(String draftsFolderName) {
		this.draftsFolderName = draftsFolderName;
	}
	public String getDraftsFolderName() {
		return draftsFolderName;
	}
	public void setFrom(String from) {
		this.from = from;
	}
	public String getFrom() {
		return from;
	}
	public void setMsgto(String msgto) {
		this.msgto = msgto;
	}
	public String getMsgto() {
		return msgto;
	}
	public void setMailId(String mailId) {
		this.mailId = mailId;
	}
	public String getMailId() {
		return mailId;
	}
	public void setReciverName(String reciverName) {
		this.reciverName = reciverName;
	}
	public String getReciverName() {
		return reciverName;
	}
	public void putIntoExtraMap(String shareId) {
		extraMap.put("shareId", shareId);
	}
	public HashMap<String, Object> getExtraMap() {
		return extraMap;
	}
	public void setEmlFile(File emlFile) {
		this.emlFile = emlFile;
	}
	public File getEmlFile() {
		return emlFile;
	}
	public void setReservation(String messageId, String delaySendDate, File emlFile) {
		mailWriteMessageVO.setCdoMessageID(messageId);
		mailWriteMessageVO.setDelaySendDate(delaySendDate);
		setEmlFile(emlFile);
		setFolderPath(draftsFolderName);
		setHasOrigin(true);
	}

	// function
	public boolean isValid() {
		return writetype != null && !(hasOrigin && !writetype.useLoadFromOrigin());
	}

	@Override
	public String toString() {
		return "MailWriteProcessVO [hasOrigin=" + hasOrigin + ", folderPath=" + folderPath + ", uid=" + uid
				+ ", draftsFolderName=" + draftsFolderName + ", from=" + from + ", msgto=" + msgto + ", mailId="
				+ mailId + ", reciverName=" + reciverName + ", extraMap=" + extraMap + "]";
	}
}
